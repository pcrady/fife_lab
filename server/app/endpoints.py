import os
import signal
from fastapi.responses import JSONResponse
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


@router.post("/uploadimages")
async def upload_images():
    pass
