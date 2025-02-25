#!/usr/bin/env bash
set -o pipefail

cd "$(dirname "$0")"

KASM_TAR=kasm_release_1.16.1.98d6fa.tar.gz

HOST_IP=$(hostname -I | awk '{print $1}')

# Check if the retrieval was successful
if [ -z "$HOST_IP" ]; then
    echo "Failed to retrieve the host IP address using 'hostname -I'."
    echo "Please enter the HOST_IP manually:"
    read -rp "Enter the HOST_IP: " HOST_IP
else
    echo "Automatically retrieved HOST_IP: $HOST_IP"

    # Ask the user if the retrieved IP address is correct
    while true; do
        read -rp "Is this IP address correct? (y/n): " response
        case $response in
            [Yy]* ) 
                break
                ;;
            [Nn]* ) 
                echo "Please enter a valid IP address manually:"
                read -rp "Enter the HOST_IP: " HOST_IP
                break  # Exit the current loop for re-entry
                ;;
            * ) 
                echo "Please answer with 'y' or 'n'." ;;
        esac
    done
fi

# Output the final HOST_IP after potential input change
echo "Kasm manager host is: $HOST_IP"

docker exec -it kasm-db bash -c "cd /tmp && curl -O https://kasm-static-content.s3.amazonaws.com/$KASM_TAR && tar -xf $KASM_TAR && bash kasm_release/install.sh --role db -e"

echo -e "\n ‼️‼️ Note down admin/usernames and passwords. This is the last time you'll see them ‼️‼️"
echo "Press 'c' to continue..."
# Infinite loop until the user presses 'c'
while true; do
    read -n 1 key  # Read a single character
    if [[ $key == "c" ]]; then
        echo -e "\nContinuing..."
        break  # Exit the loop
    else
        echo -e "\nYou pressed '$key'. Please press 'c' to continue."
    fi
done

MANAGER_TOKEN=$(docker exec kasm-db yq eval '.manager.token' /opt/kasm/current/conf/app/agent.app.config.yaml)
DATABASE_PW=$(docker exec kasm-db yq eval '.database.password' /opt/kasm/current/conf/app/api.app.config.yaml)
REDIS_PW=$(docker exec kasm-db yq eval '.redis.redis_password' /opt/kasm/current/conf/app/api.app.config.yaml)
docker exec -it kasm-manager bash -c "cd /tmp && curl -O https://kasm-static-content.s3.amazonaws.com/$KASM_TAR && tar -xf $KASM_TAR && bash kasm_release/install.sh --role app --db-hostname kasm-db.kasm_kasm-network --db-password $DATABASE_PW --redis-password $REDIS_PW -N -e"


cat <<EOF

### Install on VMs that you want to act as your Docker agents.
### Use IPs instead of trying to use hostnames to make your life easier.
cd /tmp
curl -O https://kasm-static-content.s3.amazonaws.com/$KASM_TAR
tar -xf $KASM_TAR
sudo bash kasm_release/install.sh --role agent --public-hostname <AGENT_IP_ADDRESS> --manager-hostname <HOST_IP> --manager-token $MANAGER_TOKEN"

EOF