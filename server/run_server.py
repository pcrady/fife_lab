#!/usr/bin/env python3

import os
import signal
import subprocess
import time
import threading
import json
import logging

server_process: subprocess.Popen | None = None

logging.basicConfig(
    level=logging.DEBUG,
    format="%(message)s"
)

logger = logging.getLogger(__name__)

def stdout_print(message: str) -> None:
    message = message.replace('\n', '')
    if message.startswith("worker pid:"):
        logger.info(message) 
    else:
        logger.info(f"main pid: {os.getpid()} - {message}")

def start_gunicorn() -> None:
    global server_process
    dir_path = os.path.dirname(os.path.realpath(__file__))
    server_process = subprocess.Popen(
        [
            dir_path + "/fife_lab_env/bin/uvicorn",
            "main:app",
            "--host", "127.0.0.1",
            "--port", "8000",
            "--workers", "4",
            "--log-config", os.path.join(dir_path, "log_config.json"),
        ],
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True,
        bufsize=1,
        start_new_session=True,
        cwd=dir_path,
    )
    stdout_print(f"Uvicorn started (pid={server_process.pid})")


def shutdown_gunicorn(timeout: int = 5) -> None:
    global server_process
    if not server_process or server_process.poll() is not None:
        return

    pgid = os.getpgid(server_process.pid)
    os.killpg(pgid, signal.SIGINT)               
    server_process.wait(timeout=timeout)      
    stdout_print("Uvicorn terminated; exiting wrapper")
    os.kill(os.getpid(), signal.SIGTERM)    

def reader():
    global server_process
    timer = threading.Timer(10, shutdown_gunicorn)
    timer.start()
   
    if server_process and server_process.stdout is not None:
        client_msg = "CLIENT_MSG:"
        child_process = "Child process"
        death = "died"

        for line in server_process.stdout:
            stdout_print(line)

            if child_process in line and death in line:
                stdout_print("Child process died, starting timer again")
                timer.cancel()
                timer = threading.Timer(10, shutdown_gunicorn)
                timer.start()

            if client_msg in line:
                json_index = line.find(client_msg) + len(client_msg)
                payload = json.loads(line[json_index:])
                client_connected = payload['client_connected']
                stdout_print(f"client connected: {client_connected}\n")
                if client_connected:
                    timer.cancel()


def main() -> None:
    start_gunicorn()

    try:
        threading.Thread(target=reader, daemon=True).start()
        while server_process and server_process.poll() is None:
            time.sleep(1)
    except KeyboardInterrupt:
        stdout_print("KeyboardInterrupt caught in wrapper")
        shutdown_gunicorn()
    except SystemExit:
        stdout_print("SystemExit caught in wrapper")
        shutdown_gunicorn()


if __name__ == "__main__":
    stdout_print(f"wrapper pid={os.getpid()} - ")
    main()

