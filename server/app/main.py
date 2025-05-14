from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from contextlib import asynccontextmanager
from app.utils.app_logging import stdout_print

from app.api.test_endpoints import router as test_router
from app.api.endpoints import router as router


@asynccontextmanager
async def lifespan(app: FastAPI):
    stdout_print("Initialized")
    yield

app = FastAPI(lifespan=lifespan)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(test_router)
app.include_router(router)
