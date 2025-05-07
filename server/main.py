import logging
import os
import signal

from pydantic import BaseModel
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from contextlib import asynccontextmanager

from filelock import FileLock
from tinydb import TinyDB
from tinydb.storages  import JSONStorage


logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)
DB_PATH = 'db.json'
db_lock = FileLock(f"{DB_PATH}.lock")

class Config(BaseModel):
    project_path: str


def stdout_print(message: str) -> None:
    logger.info(f"WORKER pid: {os.getpid()} - {message}")


@asynccontextmanager
async def lifespan(app: FastAPI):
    stdout_print("Initialized")
    yield

app = FastAPI(lifespan=lifespan)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.post("/shutdown")
async def shutdown():
    stdout_print("Shutdown requested")
    os.kill(os.getppid(), signal.SIGTERM)
    return JSONResponse(content={"status": "shutting down..."})


# seems to work
@app.post("/config")
async def set_config(config: Config):
    try:
        with db_lock:
            db = TinyDB(DB_PATH, storage=JSONStorage)
            id = db.insert(config.model_dump())
        return {'doc_id': id}
    except Exception as err:
        err_str = str(err)
        stdout_print(err_str)




