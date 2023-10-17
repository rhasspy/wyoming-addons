#!/usr/bin/env python3
import argparse
import logging
import subprocess
from pathlib import Path

_LOGGER = logging.getLogger()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--train-dir")
    parser.add_argument("--snowman-dir")
    args = parser.parse_args()

    logging.basicConfig(level=logging.DEBUG)
    _LOGGER.debug(args)

    snowman_dir = Path(args.snowman_dir)
    for lang_dir in Path(args.train_dir).iterdir():
        if not lang_dir.is_dir():
            continue

        lang = lang_dir.name
        for ww_dir in lang_dir.iterdir():
            if not ww_dir.is_dir():
                continue

            wav_files = list(ww_dir.glob("*.wav"))
            if not wav_files:
                # No WAV files
                _LOGGER.debug("No WAV files in %s, skipping", ww_dir)
                continue

            ww_name = ww_dir.name
            ww_model = ww_dir / f"{ww_name}.pmdl"
            if ww_model.exists() and (ww_model.stat().st_size > 0):
                # Already trained
                _LOGGER.debug("Found %s, skipping %s", ww_model, ww_dir)
                continue

            # WAV -> .pmdl
            enroll = [
                str((snowman_dir / "enroll").absolute()),
                "--language",
                lang,
                "--output",
                str(ww_model),
            ]

            for wav_path in wav_files:
                enroll.extend(["--recording", str(wav_path)])

            _LOGGER.debug(enroll)
            subprocess.check_call(enroll)


if __name__ == "__main__":
    main()
