import os
import signal
from fastapi.responses import JSONResponse
from fastapi import APIRouter
from typing import List
from pathlib import Path
from shutil import copy


from app.models import Config
from app.database import ConfigDB, ProjectDB
from app.app_logging import stdout_print
from app.image_utils import ImageUtils


router = APIRouter()

@router.post("/shutdown")
async def shutdown():
    stdout_print("Shutdown requested")
    os.kill(os.getppid(), signal.SIGTERM)
    return JSONResponse(content={"status": "shutting down..."})


@router.get('/heartbeat')
async def heartbeat() -> JSONResponse:
    return JSONResponse(status_code=200, content={'status': 'alive'})


@router.post("/config")
async def set_config(config: Config) -> JSONResponse:
    try:
        stdout_print(config)
        ConfigDB.set_project_config(config)
        ProjectDB.set_test_value(15)
        return JSONResponse(status_code=200, content={'status': 'config set'})
    except Exception as e:
        stdout_print(e)
        return JSONResponse(status_code=500, content={"error": str(e)})


@router.post("/uploadimages")
async def upload_images(image_paths: List[str]) -> JSONResponse:
    try:
        stdout_print(image_paths)
        project_dir = ConfigDB.get_project_dir()
        
        if not project_dir:
            raise Exception('No project directory has been specified')

        images_dir = Path(project_dir).joinpath('images')
        images_dir.mkdir(exist_ok=True)

        for image_path in image_paths:
            stdout_print(image_path)
            ImageUtils.convert_to_png(image_path, str(images_dir))

        return JSONResponse(status_code=201, content={'status': 'images added'})

    except Exception as e:
        stdout_print(e)
        return JSONResponse(status_code=500, content={"error": str(e)})


@router.post('/removeimages')
async def remove_images(image_paths: List[str]) -> JSONResponse:
    try:
        # TODO 
        return JSONResponse(status_code=204, content={'status': 'images removed'})
    except Exception as e:
        stdout_print(e)
        return JSONResponse(status_code=500, content={"error": str(e)})











