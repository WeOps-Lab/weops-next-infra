#!/bin/bash
set -euo pipefail
export DOCKER_VERSION="20.10.23"
export DOCKER_DATA_PATH="/data/docker"

mkdir -p $DOCKER_DATA_PATH
TMP_DIR=$(mktemp -d weops-lite-XXX)
cp ../docker/docker-${DOCKER_VERSION}.tgz /tmp/soft
cd $TMP_DIR
tar -xvf ./docker-${DOCKER_VERSION}.tgz

mv ./docker/* /usr/local/bin/
chmod 0755 /usr/local/bin/*
mkdir -p /etc/docker

cat > /etc/docker/daemon.json <<EOF
{
    "registry-mirrors": [
        "https://docker.1panel.live",
        "https://huecker.io",
        "https://dockerhub.timeweb.cloud",
        "https://noohub.ru"
    ],
    "insecure-registries": [],
    "max-concurrent-downloads": 10,
    "log-driver": "json-file",
    "log-level": "warn",
    "log-opts": {
    "max-size": "10m",
    "max-file": "3"
    },
    "data-root": "${DOCKER_DATA_PATH}"
}
EOF

cat > /usr/lib/systemd/system/docker.service <<EOF
[Unit]
Description=Docker Application Container Engine
Documentation=https://docs.docker.com
After=network-online.target firewalld.service
Wants=network-online.target

[Service]
Type=notify
ExecStart=/usr/local/bin/dockerd
ExecReload=/bin/kill -s HUP 
LimitNOFILE=infinity
LimitNPROC=infinity
LimitCORE=infinity
#TasksMax=infinity
TimeoutStartSec=0
Delegate=yes
KillMode=process
Restart=onfailure
StartLimitBurst=3
StartLimitInterval=60s

[Install]
WantedBy=multi-user.target
EOF
rm -Rf ./docker
rm -Rf ./docker-${DOCKER_VERSION}.tgz
systemctl enable --now docker
docker ps
rm -rf $TMP_DIR