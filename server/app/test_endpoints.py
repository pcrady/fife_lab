from fastapi import APIRouter
from app.models import IOTest


router = APIRouter()

@router.post("/iotest")
async def lock_test(io_test: IOTest):
    pass
