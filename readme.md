# Kasm Docker in Docker

Kasm 1.16 doesn't make it easy to install Kasm DB and Kasm manager on one machine (without an agent).
This solves the issue by following the multi server install but using a Docker container as a host (Docker in Docker).

## Table of Contents

- [Features](#features)
- [Installation](#installation)

## Features

- Docker in Docker base image
- Runs databases in Dind container (`kasm_redis`, `kasm_db`)
- Runs Kasm management containers in seperate Dind (`kasm_proxy`, `kasm_manager`, `kasm_share`, `kasm_api`)

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/username/repo-name.git```