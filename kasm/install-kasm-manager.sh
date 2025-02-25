#!/usr/bin/env bash
cd "$(dirname "$0")"

HOST_IP=$(hostname -I | awk '{print $1}') # Hardcode this value if the first index isn't the host IP

$KASM_TAR=kasm_release_1.16.1.98d6fa.tar.gz

docker exec -it kasm-db bash -c "cd /tmp && curl -O https://kasm-static-content.s3.amazonaws.com/$KASM_TAR && tar -xf $KASM_TAR && bash kasm_release/install.sh --role db"

MANAGER_TOKEN=$(docker exec kasm-db yq eval '.manager.token' /opt/kasm/current/conf/app/agent.app.config.yaml)
DATABASE_PW=$(docker exec kasm-db yq eval '.database.password' /opt/kasm/current/conf/app/api.app.config.yaml)
REDIS_PW=$(docker exec kasm-db yq eval '.redis.redis_password' /opt/kasm/current/conf/app/api.app.config.yaml)
docker exec -it kasm-manager bash -c "cd /tmp && curl -O https://kasm-static-content.s3.amazonaws.com/$KASM_TAR && tar -xf $KASM_TAR && bash kasm_release/install.sh --role app --db-hostname kasm-db.kasm_kasm-network --db-password $DATABASE_PW --redis-password $REDIS_PW -N"


cat <<EOF
### Install on VMs that you want to act as your Docker agents.
### Use IPs instead of trying to use hostnames to make your life easier.
cd /tmp
curl -O https://kasm-static-content.s3.amazonaws.com/$KASM_TAR
tar -xf $KASM_TAR
sudo bash kasm_release/install.sh --role agent --public-hostname <AGENT_IP_ADDRESS> --manager-hostname <HOST_IP> --manager-token $MANAGER_TOKEN"
EOF