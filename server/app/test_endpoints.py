from fastapi.responses import JSONResponse
from tinydb import TinyDB, Query
from tinydb.storages import JSONStorage
from fastapi import APIRouter

from app.models import IOTest
from app.database import ConfigDB


router = APIRouter()

@router.post("/iotest")
async def lock_test(io_test: IOTest):
    pass
#    try:
#        with db_lock:
#            db = TinyDB(CONFIG_DB_PATH, storage=JSONStorage)
#            q = Query()
#            existing = db.search(q.key == io_test.key)
#            if not existing:
#                db.insert(io_test.model_dump())
#                return io_test.model_dump()
#            if len(existing) == 1:
#                item = IOTest(**existing[0])
#                item.value += io_test.value 
#                item.test_type = io_test.test_type
#
#                db.update(item.model_dump(), q.key == item.key)
#                return item.model_dump()
#            raise RuntimeError(f"Multiple records found for {io_test.key}")
#    except Exception as e:
#        stdout_print(str(e))
#        return JSONResponse(status_code=500, content={"error": str(e)})
