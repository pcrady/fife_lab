import os
import signal
from fastapi.responses import JSONResponse
from fastapi import APIRouter
from typing import List
from pathlib import Path
from app.models.models import Config
from app.database.database import ConfigDB, ProjectDB
from app.utils.app_logging import stdout_print
from app.utils.image_utils import ImageUtils


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
        return JSONResponse(status_code=200, content={'status': 'config set'})
    except Exception as e:
        stdout_print(e)
        return JSONResponse(status_code=500, content={"error": str(e)})


@router.post("/upload-images")
async def upload_images(image_paths: List[str]) -> JSONResponse:
    try:
        images_dir = ConfigDB.get_images_dir()
        
        if not images_dir:
            raise Exception('No images directory has been specified')

        images_dir.mkdir(exist_ok=True)

        for image_path in image_paths:
            ImageUtils.convert_to_png(image_path, str(images_dir))

        ProjectDB.set_images()
        return JSONResponse(status_code=201, content={'status': 'images added'})

    except Exception as e:
        stdout_print(e)
        return JSONResponse(status_code=500, content={"error": str(e)})


def get_image_paths() -> List[Path]:
    images_dir = ConfigDB.get_images_dir()

    if not images_dir:
        raise Exception('No images directory has been specified')

    return [images_dir.joinpath(image) for image in os.listdir(images_dir) if image.endswith('png')]




@router.get('/verify-images')
async def verify_images():
    return 'test'

@router.get('/get-images')
async def get_images(image_paths: List[str]) -> JSONResponse:
    pass

@router.post('/remove-images')
async def remove_images(image_paths: List[str]) -> JSONResponse:
    pass









