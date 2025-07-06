# Kasm Docker in Docker

Kasm 1.16 doesn't make it easy to install Kasm DB and Kasm manager on one machine (without an agent).
This solves the issue by following the multi server install but using a Docker container as a host (Docker in Docker). 

I only use browsers with Kasm so RDP/VNC isn't accounted for in this setup.

## Table of Contents

- [Features](#features)
- [Installation](#installation)

## Features

- Docker in Docker base image
- Runs databases in DinD container (`kasm_redis`, `kasm_db`)
- Runs Kasm management containers in seperate DinD (`kasm_proxy`, `kasm_manager`, `kasm_share`, `kasm_api`)
- Container data will persist even after system reboot or destroying DinD containers

## Installation
1. Install Docker on your host.
2. Clone the repository:
    ```bash
   git clone https://github.com/maxandcheeses/kasm.git
   ```
3. Build base image
    ```bash
    (cd build-docker && bash ./build.sh)
    ```
4. Bring up the containers
    ```bash
    (cd kasm && docker compose up -d)
    ```
5. Install Kasm in containers
    ```bash
    (cd kasm && bash ./install-kasm-manager.sh)
    ```
6. Install Kasm agent on VMs using commands outputted from step 5.
