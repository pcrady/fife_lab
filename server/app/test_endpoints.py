from fastapi.responses import JSONResponse
from fastapi import APIRouter

from app.models import IOTest
from app.database import ProjectDB
from app.app_logging import stdout_print


router = APIRouter()

@router.post("/iotest")
async def lock_test(io_test: IOTest):
    try:
        ProjectDB.io_test(io_test)
    except Exception as e:
        stdout_print(str(e))
        return JSONResponse(status_code=500, content={"error": str(e)})
