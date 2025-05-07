import os
import signal
from fastapi.responses import JSONResponse
from tinydb import TinyDB, Query
from tinydb.storages import JSONStorage
from fastapi import APIRouter

from app.models import Config
from app.lib import DB_PATH, db_lock, stdout_print


router = APIRouter()

@router.post("/shutdown")
async def shutdown():
    stdout_print("Shutdown requested")
    os.kill(os.getppid(), signal.SIGTERM)
    return JSONResponse(content={"status": "shutting down..."})


@router.post("/config")
async def set_config(config: Config):
    try:
        with db_lock:
            db = TinyDB(DB_PATH, storage=JSONStorage)
            q = Query()
            doc_id = db.upsert(config.model_dump(), q.key == config.key)
        return {"doc_id": doc_id}
    except Exception as e:
        stdout_print(str(e))
        return JSONResponse(status_code=500, content={"error": str(e)})


@router.post("/clear")
async def clear_db():
    try:
        with db_lock:
            db = TinyDB(DB_PATH, storage=JSONStorage)
            db.truncate()
        return {"success": True}
    except Exception as e:
        stdout_print(str(e))
        return JSONResponse(status_code=500, content={"error": str(e)})


@router.get("/all")
async def get_all():
    stdout_print("Fetching all records")
    try:
        with db_lock:
            db = TinyDB(DB_PATH, storage=JSONStorage)
            items = list(db)
        return {"items": items}
    except Exception as e:
        stdout_print(str(e))
        return JSONResponse(status_code=500, content={"error": str(e)})
