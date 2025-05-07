import os
import logging
from pathlib import Path
from filelock import FileLock
from typing import Final



DB_PATH: Final[Path] = Path('database').joinpath('db.json')
db_lock = FileLock(f"{DB_PATH}.lock")

logger = logging.getLogger(__name__)
def stdout_print(msg: str) -> None:
    logger.info(f"WORKER pid: {os.getpid()} - {msg}")

