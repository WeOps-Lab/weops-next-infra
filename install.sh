#!/bin/bash
set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

timestamp() {
    BLUE='\033[0;34m'
    echo -e "${BLUE}$(date +"[%Y-%m-%d %H:%M:%S]")${NC}"
}

print_message() {
    local color=$1
    local message=$2
    echo -e "$(timestamp) ${color}${message}${NC}"
}

if command -v docker 2>&1 1>/dev/null; then
    print_message "${YELLOW}" "docker installed. skip."
else
    if [[ -f bin/install_docker.sh ]]; then
        chmod +x bin/install_docker.sh
        bin/install_docker.sh
    fi
fi

if command -v k3s 2>&1 1>/dev/null; then
    print_message "${YELLOW}" "k3s installed. skip."
else
    if [[ -f bin/install_k3s.sh ]]; then
        chmod +x bin/install_k3s.sh
        mkdir -p /data/k3s
        bin/install_k3s.sh --docker --data-dir /data/k3s
    fi
fi

if command -v k9s 2>&1 1>/dev/null; then
    print_message "${YELLOW}" "k9s installed. skip."
else
    if [[ -f bin/install_k9s.sh ]]; then
        chmod +x bin/install_k9s.sh
        bin/install_k9s.sh
    fi
fi

if [[ -d images ]]; then
    for image in images/*; do
        print_message "${GREEN}" "Loading image: $image"
        docker load < $image
    done
else
    print_message "${YELLOW}" "images not found. skip."
fi

generate_password() {
    openssl rand -base64 32 | colrm 16
}

generate_env_file() {
    if [[ -f .env ]]; then
        print_message "${YELLOW}" ".env file already exists, skip."
        return
    fi
    cat <<EOF >.env
export LITE_DOMAIN=weops.com
export POSTGRES_PASSWORD=$(generate_password)
export KEYCLOAK_ADMIN_PASSWORD=$(generate_password)
export RABBITMQ_PASSWORD=$(generate_password)
export REDIS_PASSWORD=$(generate_password)
export LAN_IP=$(hostname -I | awk '{print $1}')
EOF
    print_message "${GREEN}" ".env file generated."
}

render_template() {
    export LAN_IP=$(hostname -I | awk '{print $1}')
    envsubst < manifests/weops-lite.yaml.tpl > manifests/weops-lite.yaml
    source .env
    envsubst < manifests/secret.yaml.tpl > manifests/secret.yaml
    print_message "${GREEN}" "Templates rendered."
}

wait_for_crd() {
    local crd_name="ingressroutes.traefik.io"
    local retry_interval=3
    local max_attempts=100
    local attempt_counter=0
    local crd_ready=false

    print_message "${GREEN}" "Waiting for CRD $crd_name to be ready..."

    until $crd_ready; do
        if kubectl get crd $crd_name > /dev/null 2>&1; then
            crd_ready=true
            print_message "${GREEN}" "CRD ${YELLOW}$crd_name${GREEN} is ready."
        else
            attempt_counter=$((attempt_counter+1))
            if [ $attempt_counter -ge $max_attempts ]; then
                print_message "${RED}" "Timeout waiting for CRD $crd_name."
                exit 1
            fi
            print_message "${YELLOW}" "CRD $crd_name is not ready, retrying in ${retry_interval} seconds... (Attempt $attempt_counter/$max_attempts)"
            sleep $retry_interval
        fi
    done
}

install() {
    generate_env_file
    render_template
    wait_for_crd
    kubectl apply -f manifests/namespace.yaml
    kubectl apply -f manifests/
    print_message "${GREEN}" "Weops Lite installed successfully."
    print_message "${GREEN}" "Read secrets from ${YELLOW}$PWD/.env${GREEN} file."
    print_message "${GREEN}" "Manage your cluster with ${YELLOW}k9s${GREEN}."
}

install