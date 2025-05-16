import os
import signal
from fastapi.responses import JSONResponse
from fastapi import APIRouter
from typing import List
from app.models.models import Config
from app.database.database import ConfigDB, ProjectDB
from app.utils.app_logging import stdout_print, stderr_print
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
        stderr_print(e)
        return JSONResponse(status_code=500, content={"error": str(e)})


@router.post("/add-images")
async def add_images(image_paths: List[str]) -> JSONResponse:
    try:
        number_of_images_recieved = len(image_paths)
        images_dir = ConfigDB.get_images_dir()
        if not images_dir:
            raise Exception('No images directory has been specified')
        images_dir.mkdir(exist_ok=True)
    except Exception as e:
        stderr_print(e)
        return JSONResponse(status_code=500, content={"error": str(e)})

    images_added = 0
    for image_path in image_paths:
        try:
            # TODO see if can parallelize this
            ImageUtils.convert_to_png(image_path, str(images_dir))
            images_added += 1
        except Exception as e:
            stderr_print(e)
            continue

    try: 
        ProjectDB.set_images()
        return JSONResponse(status_code=201, content={'status': 'images added',
                                                      'images_recieved': number_of_images_recieved,
                                                      'images_added': images_added})
    except Exception as e:
        stderr_print(e)
        return JSONResponse(status_code=500, content={"error": str(e)})


@router.get('/verify-images')
async def verify_images():
    try:
        image_paths = ProjectDB.get_image_paths()

        if image_paths is None:
            return  JSONResponse(status_code=201, content=[])
           
        corrupted_images = ImageUtils.verify_images(image_paths)
        return  JSONResponse(status_code=201, content=corrupted_images)

    except Exception as e:
        stderr_print(e)
        return JSONResponse(status_code=500, content={"error": str(e)})


@router.get('/get-all-images')
async def get_all_images() -> JSONResponse:
    try:
        images = ProjectDB.get_images()
 
        if images is None:
            return  JSONResponse(status_code=201, content=[])

        image_dict = [image.serialize_for_front_end() for image in images]
        return  JSONResponse(status_code=201, content=image_dict)

    except Exception as e:
        stderr_print(e)
        return JSONResponse(status_code=500, content={"error": str(e)})



@router.post('/remove-images')
async def remove_images(image_paths: List[str]) -> JSONResponse:
    pass


@router.post('/remove-all-images')
async def remove_all_images() -> JSONResponse:
    pass








