import os
import logging

logger = logging.getLogger(__name__)


def stdout_print(msg) -> None:
    logger.info(f"WORKER pid: {os.getpid()} - {msg}")


