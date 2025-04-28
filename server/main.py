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

is_keep_alive_worker = False;

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

first_ws_seen = asyncio.Event()

def stdout_print(message: str) -> None:
    if is_keep_alive_worker:
        logger.info(f"worker pid: {os.getpid()}, KeepAlive - {message}")
    else:
        logger.info(f"worker pid: {os.getpid()} - {message}")

@app.on_event("startup")
async def start_watchdog() -> None:
    async def watchdog() -> None:
        try:
            await asyncio.wait_for(first_ws_seen.wait(), timeout=None)
            message = json.dumps({"client_connected": True})
            stdout_print("CLIENT_MSG:" + message)
        except:
            message = json.dumps({"client_connected": False})
            stdout_print("CLIENT_MSG" + message)
            
    asyncio.create_task(watchdog())

@app.get("/stress-test")
async def stress_test():
    total = 0
    for i in range(1, 10_000_000):
        total += math.sqrt(i) * math.sin(i) * math.cos(i)
    stdout_print(f"pid: {os.getpid()}")
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

@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    await websocket.accept()
    first_ws_seen.set()
    client = websocket.client
    stdout_print(f"WebSocket connected: {client}")
    stdout_print(f"WebSocket connection pid: {os.getpid}")
    is_keep_alive_worker = True

    try:
        while True:
            data = await websocket.receive_text()
            stdout_print(f"Received: {data}")
            await websocket.send_text(f"Message text was: {data}")
    except WebSocketDisconnect as e:
        stdout_print(f"WebSocket {client} disconnected. Close code={e.code}")
        os.kill(os.getppid(), signal.SIGTERM)
    finally:
        stdout_print("WebSocket {client} cleanup complete")
