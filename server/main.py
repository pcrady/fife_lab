import asyncio
import logging
import os
import signal
import json
import math
import random

from fastapi import FastAPI, WebSocket, WebSocketDisconnect
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse

logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)
app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

def stdout_print(message: str) -> None:
    logger.info(f"WORKER pid: {os.getpid()} - {message}")

@app.on_event("startup")
async def start_watchdog() -> None:
    stdout_print("Initialized")

@app.get("/stress-test")
async def stress_test():
    total = 0
    for i in range(1, 10_000_000):
        total += math.sqrt(i) * math.sin(i) * math.cos(i)
    stdout_print(f"Stress Test pid: {os.getpid()}")
    return JSONResponse(content="hello")

@app.get("/test")
async def test():
    num = random.random()
    stdout_print(str(num))
    return JSONResponse(content=num)

@app.post("/shutdown")
async def shutdown():
    stdout_print("Shutdown requested")
    os.kill(os.getppid(), signal.SIGTERM)
    return JSONResponse(content={"status": "shutting down..."})
