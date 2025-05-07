from fastapi.responses import JSONResponse
from tinydb import TinyDB, Query
from tinydb.storages import JSONStorage
from fastapi import APIRouter

from app.models import IOTest
from app.lib import DB_PATH, db_lock, stdout_print


router = APIRouter()

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
