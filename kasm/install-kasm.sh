#!/usr/bin/env bash
cd "$(dirname "$0")"
$KASM_TAR=kasm_release_1.16.1.98d6fa.tar.gz 
docker exec -it kasm-db bash -c "cd /tmp && curl -O https://kasm-static-content.s3.amazonaws.com/$KASM_TAR && tar -xf $KASM_TAR && bash kasm_release/install.sh --role db"