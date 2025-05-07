import logging
import os
import signal

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from contextlib import asynccontextmanager
from pathlib import Path
from filelock import FileLock
from tinydb import TinyDB, Query
from tinydb.storages  import JSONStorage
from typing import Final

from app.models import Config, IOTest

DB_PATH: Final[Path] = Path('database').joinpath('db.json')


logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)
db_lock = FileLock(f"{DB_PATH}.lock")


def stdout_print(message) -> None:
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


@app.post("/config")
async def set_config(config: Config):
    try:
        with db_lock:
            db = TinyDB(DB_PATH, storage=JSONStorage)
            query = Query()
            id = db.upsert(config.model_dump(), query.key == config.key)
        return {'doc_id': id}
    except Exception as err:
        err_str = str(err)
        stdout_print(err_str)


@app.post('/clear')
async def clear_db():
    try:
        with db_lock:
            db = TinyDB(DB_PATH, storage=JSONStorage)
            db.truncate()
            return {'success'}
 
    except Exception as err:
        err_str = str(err)
        stdout_print(err_str)


@app.get("/all")
async def all():
    stdout_print('here')
    try:
        with db_lock:
            db = TinyDB(DB_PATH, storage=JSONStorage)
            for item in db:
                stdout_print(str(item))
            
        return {"FUCK"}
    except Exception as err:
        err_str = str(err)
        stdout_print(err_str)


@app.post("/iotest")
async def lock_test(io_test: IOTest):
    try:
        with db_lock:
            db = TinyDB(DB_PATH, storage=JSONStorage)
            q = Query()
            items = db.search(q.test_type == io_test.test_type)

            if len(items) == 0:
                db.insert(io_test.model_dump())
                return io_test.model_dump()
            elif len(items) == 1: 
                item = IOTest(**items[0])
                item.value = item.value + io_test.value

                db.update(item.model_dump(), q.key == item.key)
                return item.model_dump()
            else: 
                raise Exception('this has gone wrong')
            
    except Exception as err:
        err_str = str(err)
        stdout_print(err_str)



