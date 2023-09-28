#!/usr/bin/env python3
import argparse
import asyncio
import logging
import platform
import struct
import time
from dataclasses import dataclass
from functools import partial
from pathlib import Path
from typing import Dict, Optional

import pvporcupine
from wyoming.audio import AudioChunk, AudioChunkConverter, AudioStart, AudioStop
from wyoming.event import Event
from wyoming.info import Attribution, Describe, Info, WakeModel, WakeProgram
from wyoming.server import AsyncEventHandler, AsyncServer
from wyoming.wake import Detect, Detection, NotDetected

_LOGGER = logging.getLogger()
_DIR = Path(__file__).parent

DEFAULT_KEYWORD = "porcupine"


@dataclass
class Keyword:
    """Single porcupine keyword"""

    language: str
    name: str
    model_path: Path


class State:
    """State of system"""

    def __init__(self, pv_lib_paths: Dict[str, Path], keywords: Dict[str, Keyword]):
        self.pv_lib_paths = pv_lib_paths
        self.keywords = keywords

    def get_porcupine(
        self, keyword_name: str, sensitivity: float
    ) -> pvporcupine.Porcupine:
        keyword = self.keywords.get(keyword_name)
        if keyword is None:
            raise ValueError(f"No keyword {keyword_name}")

        _LOGGER.debug("Loading %s for %s", keyword.name, keyword.language)
        return pvporcupine.create(
            model_path=str(self.pv_lib_paths[keyword.language]),
            keyword_paths=[str(keyword.model_path)],
            sensitivities=[sensitivity],
        )


async def main() -> None:
    """Main entry point."""
    parser = argparse.ArgumentParser()
    parser.add_argument("--uri", default="stdio://", help="unix:// or tcp://")
    parser.add_argument(
        "--data-dir", default=_DIR / "data", help="Path to directory lib/resources"
    )
    parser.add_argument("--system", help="linux or raspberry-pi")
    parser.add_argument("--sensitivity", type=float, default=0.5)
    #
    parser.add_argument("--debug", action="store_true", help="Log DEBUG messages")
    args = parser.parse_args()
    logging.basicConfig(level=logging.DEBUG if args.debug else logging.INFO)
    _LOGGER.debug(args)

    if not args.system:
        machine = platform.machine().lower()
        if ("arm" in machine) or ("aarch" in machine):
            args.system = "raspberry-pi"
        else:
            args.system = "linux"

    args.data_dir = Path(args.data_dir)

    # lang -> path
    pv_lib_paths: Dict[str, Path] = {}
    for lib_path in (args.data_dir / "lib" / "common").glob("*.pv"):
        lib_lang = lib_path.stem.split("_")[-1]
        pv_lib_paths[lib_lang] = lib_path

    # name -> keyword
    keywords: Dict[str, Keyword] = {}
    for kw_path in (args.data_dir / "resources").rglob("*.ppn"):
        kw_system = kw_path.stem.split("_")[-1]
        if kw_system != args.system:
            continue

        kw_lang = kw_path.parent.parent.name
        kw_name = kw_path.stem.rsplit("_", maxsplit=1)[0]
        keywords[kw_name] = Keyword(language=kw_lang, name=kw_name, model_path=kw_path)

    wyoming_info = Info(
        wake=[
            WakeProgram(
                name="porcupine1",
                description="On-device wake word detection powered by deep learning ",
                attribution=Attribution(
                    name="Picovoice", url="https://github.com/Picovoice/porcupine"
                ),
                installed=True,
                models=[
                    WakeModel(
                        name=kw.name,
                        description=f"{kw.name} ({kw.language})",
                        attribution=Attribution(
                            name="Picovoice",
                            url="https://github.com/Picovoice/porcupine",
                        ),
                        installed=True,
                        languages=[kw.language],
                    )
                    for kw in keywords.values()
                ],
            )
        ],
    )

    state = State(pv_lib_paths=pv_lib_paths, keywords=keywords)

    _LOGGER.info("Ready")

    # Start server
    server = AsyncServer.from_uri(args.uri)

    try:
        await server.run(partial(Porcupine1EventHandler, wyoming_info, args, state))
    except KeyboardInterrupt:
        pass


# -----------------------------------------------------------------------------


class Porcupine1EventHandler(AsyncEventHandler):
    """Event handler for clients."""

    def __init__(
        self,
        wyoming_info: Info,
        cli_args: argparse.Namespace,
        state: State,
        *args,
        **kwargs,
    ) -> None:
        super().__init__(*args, **kwargs)

        self.cli_args = cli_args
        self.wyoming_info_event = wyoming_info.event()
        self.client_id = str(time.monotonic_ns())
        self.state = state
        self.converter = AudioChunkConverter(rate=16000, width=2, channels=1)
        self.audio_buffer = bytes()
        self.detected = False

        self.porcupine: Optional[pvporcupine.Porcupine] = None
        self.keyword_name: str = ""
        self.chunk_format: str = ""
        self.bytes_per_chunk: int = 0

        _LOGGER.debug("Client connected: %s", self.client_id)

    async def handle_event(self, event: Event) -> bool:
        if Describe.is_type(event.type):
            await self.write_event(self.wyoming_info_event)
            _LOGGER.debug("Sent info to client: %s", self.client_id)
            return True

        if Detect.is_type(event.type):
            detect = Detect.from_event(event)
            if detect.names:
                # TODO: use all names
                self._load_keyword(detect.names[0])
        elif AudioStart.is_type(event.type):
            self.detected = False
        elif AudioChunk.is_type(event.type):
            if self.porcupine is None:
                # Default keyword
                self._load_keyword(DEFAULT_KEYWORD)

            chunk = AudioChunk.from_event(event)
            chunk = self.converter.convert(chunk)
            self.audio_buffer += chunk.audio

            while len(self.audio_buffer) >= self.bytes_per_chunk:
                unpacked_chunk = struct.unpack_from(
                    self.chunk_format, self.audio_buffer[: self.bytes_per_chunk]
                )
                keyword_index = self.porcupine.process(unpacked_chunk)
                if keyword_index >= 0:
                    _LOGGER.debug(
                        "Detected %s from client %s", self.keyword_name, self.client_id
                    )
                    await self.write_event(
                        Detection(
                            name=self.keyword_name, timestamp=chunk.timestamp
                        ).event()
                    )

                self.audio_buffer = self.audio_buffer[self.bytes_per_chunk :]

        elif AudioStop.is_type(event.type):
            # Inform client if not detections occurred
            if not self.detected:
                # No wake word detections
                await self.write_event(NotDetected().event())

                _LOGGER.debug(
                    "Audio stopped without detection from client: %s", self.client_id
                )

            return False
        else:
            _LOGGER.debug("Unexpected event: type=%s, data=%s", event.type, event.data)

        return True

    async def disconnect(self) -> None:
        _LOGGER.debug("Client disconnected: %s", self.client_id)

    def _load_keyword(self, keyword_name: str):
        self.porcupine = self.state.get_porcupine(
            keyword_name, self.cli_args.sensitivity
        )
        self.keyword_name = keyword_name
        self.chunk_format = "h" * self.porcupine.frame_length
        self.bytes_per_chunk = self.porcupine.frame_length * 2


# -----------------------------------------------------------------------------

if __name__ == "__main__":
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        pass
