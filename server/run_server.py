#!/usr/bin/env python3

import os
import signal
import subprocess
import time
import threading
import json
import logging
import socket

server_process: subprocess.Popen | None = None

logging.basicConfig(
    level=logging.DEBUG,
    format="%(message)s"
)

logger = logging.getLogger(__name__)

def stdout_print(message: str) -> None:
    logger.info(message) 

def start_gunicorn() -> None:
    HOST = "127.0.0.1"
    PORT = "8000"
    global server_process
    dir_path = os.path.dirname(os.path.realpath(__file__))
    server_process = subprocess.Popen(
        [
            dir_path + "/fife_lab_env/bin/uvicorn",
            "main:app",
            "--host", HOST,
            "--port", PORT,
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
    stdout_print(f"MAIN pid: {os.getpid()} - Uvicorn started (pid={server_process.pid}) on {HOST}/{PORT}")

def shutdown_gunicorn(timeout: int = 5) -> None:
    global server_process
    if not server_process or server_process.poll() is not None:
        return

    pgid = os.getpgid(server_process.pid)
    os.killpg(pgid, signal.SIGINT)               
    server_process.wait(timeout=timeout)      
    stdout_print(f"MAIN pid: {os.getpid()} - Uvicorn terminated; exiting wrapper")
    os.kill(os.getpid(), signal.SIGTERM)

def socket_server():
    global connected
    HOST = '127.0.0.1'
    PORT = 8001
    timer = threading.Timer(10, shutdown_gunicorn)
    timer.start()

    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        connected = False
        s.bind((HOST, PORT))
        s.listen()
        stdout_print(f"MAIN pid: {os.getpid()} - Control Server listening on {HOST}:{PORT}")

        while not connected:
            if not connected:
                conn, addr = s.accept()
                stdout_print(f"MAIN pid: {os.getpid()} - Incomming connection from {addr}")
                stdout_print(f"MAIN pid: {os.getpid()} - Canceling autokill timer")
                timer.cancel()
                threading.Thread(target=handle_client, args=(conn, addr), daemon=True).start()
                connected = True
 

def handle_client(conn, addr):
    with conn:
        control_server_pid = os.getpid()
        stdout_print(f"CONTROL_SERVER pid: {control_server_pid} - Listening for clients")
        while True:
            data = conn.recv(1024)
            if not data:
                stdout_print(f"CONTROL_SERVER pid: {control_server_pid} - Connection closed by {addr}")
                stdout_print(f"CONTROL_SERVER pid: {control_server_pid} - Terminating processes")
                # TODO restart control server
                shutdown_gunicorn()
                break
            else:
                stdout_print(f"CONTROL_SERVER pid: {control_server_pid} - Received from {addr}: {data!r}")
                conn.sendall(f"Poop {data}")

def reader():
    global server_process
    if server_process and server_process.stdout is not None:
        for line in server_process.stdout:
            if line.startswith('WORKER'):
                stdout_print(line)
            else:
                line = f"WEB_SERVER pid: {os.getpid()} - {line}"
                stdout_print(line)


def main() -> None:
    start_gunicorn()

    try:
        socket_server()
        threading.Thread(target=reader, daemon=True).start()
        while server_process and server_process.poll() is None:
            time.sleep(1)
    except KeyboardInterrupt:
        stdout_print(f"MAIN pid: {os.getpid()} - KeyboardInterrupt caught in wrapper")
        shutdown_gunicorn()
    except SystemExit:
        stdout_print(f"MAIN pid: {os.getpid()} - SystemExit caught in wrapper")
        shutdown_gunicorn()


if __name__ == "__main__":
    main()
