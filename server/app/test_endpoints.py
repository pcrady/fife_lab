import os
import signal
from fastapi.responses import JSONResponse
from tinydb import TinyDB, Query
from tinydb.storages import JSONStorage

from app.models import Config, IOTest
from app.lib import DB_PATH, db_lock, stdout_print, router



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


@router.post("/iotest")
async def lock_test(io_test: IOTest):
    try:
        with db_lock:
            db = TinyDB(DB_PATH, storage=JSONStorage)
            q = Query()
            existing = db.search(q.test_type == io_test.test_type)
            if not existing:
                db.insert(io_test.model_dump())
                return io_test.model_dump()
            if len(existing) == 1:
                item = IOTest(**existing[0])
                item.value += io_test.value 

                db.update(item.model_dump(), q.key == item.key)
                return item.model_dump()
            raise RuntimeError("Multiple records found for same test_type")
    except Exception as e:
        stdout_print(str(e))
        return JSONResponse(status_code=500, content={"error": str(e)})
