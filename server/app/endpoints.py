import os
import signal
from fastapi.responses import JSONResponse
from tinydb import TinyDB, Query
from tinydb.storages import JSONStorage
from fastapi import APIRouter

from app.models import Config
from app.database import ConfigDB, ProjectDB
from app.app_logging import stdout_print


router = APIRouter()

@router.post("/shutdown")
async def shutdown():
    stdout_print("Shutdown requested")
    os.kill(os.getppid(), signal.SIGTERM)
    return JSONResponse(content={"status": "shutting down..."})


@router.get('/heartbeat')
async def heartbeat():
    return JSONResponse(content={'status': 'alive'})


@router.post("/config")
async def set_config(config: Config):
    try:
        stdout_print(config)
        ConfigDB.set_project_config(config)
        ProjectDB.set_test_value(15)
        return {"Config Set"}
    except Exception as e:
        stdout_print(e)
        return JSONResponse(status_code=500, content={"error": str(e)})


#@router.post("/clear")
#async def clear_db():
#    try:
#        with db_lock:
#            db = TinyDB(CONFIG_DB_PATH, storage=JSONStorage)
#            db.truncate()
#        return {"success": True}
#    except Exception as e:
#        stdout_print(str(e))
#        return JSONResponse(status_code=500, content={"error": str(e)})
#
#
#@router.get("/all")
#async def get_all():
#    stdout_print("Fetching all records")
#    try:
#        with db_lock:
#            db = TinyDB(CONFIG_DB_PATH, storage=JSONStorage)
#            items = list(db)
#        return {"items": items}
#    except Exception as e:
#        stdout_print(str(e))
#        return JSONResponse(status_code=500, content={"error": str(e)})
