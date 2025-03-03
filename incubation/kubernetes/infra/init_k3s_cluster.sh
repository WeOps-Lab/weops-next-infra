#!/bin/bash
set -euo pipefail

# 日志输出函数
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

log "开始初始化K3s集群..."

# 解析命令行参数，长短混合模式
(( $# == 0 )) && { log "错误: 需要提供参数"; exit 1; }
while (( $# > 0 )); do 
    case "$1" in
        -w | --wan-ip )
            shift
            WAN_IP=$1
            log "设置WAN IP: $WAN_IP"
            ;;
        -l | --lan-ip)
            shift
            LAN_IP=$1
            log "设置LAN IP: $LAN_IP"
            ;;
        -*)
            log "错误: 未知参数 $1"
            exit -1
            ;;
        *) 
            break
            ;;
    esac
    shift 
done 

# 参数校验
if [[ -z $LAN_IP ]]; then
    log "错误: 必须提供lan-ip参数"
    exit -1
fi

# 安装需要的apt包
log "开始安装系统依赖包..."
apt update
apt install -y nfs-common ca-certificates curl
log "系统依赖包安装完成"


# 配置K3s安装参数
# 允许空变量
set +u
if [[ -n $WAN_IP ]]; then
    log "检测到WAN IP，将配置wireguard"
    INSTALL_K3S_EXEC="--tls-san $WAN_IP --node-ip $LAN_IP -o /root/.kube/config --flannel-backend wireguard-native --flannel-external-ip --service-node-port-range 1-65535 --docker"
else
    log "未检测到WAN IP，使用标准配置"
    INSTALL_K3S_EXEC="--node-ip $LAN_IP -o /root/.kube/config --service-node-port-range 1-65535 --docker"
fi
set -u

K3S_NODE_NAME="prod-ops-pilot-master"

# 添加允许ipv4转发的内核参数
log "配置内核参数..."
cat <<"EOF" > /etc/sysctl.d/99-k3s.conf
net.ipv4.ip_forward=1
EOF
sysctl -p

# 安装docker
log "开始安装Docker..."
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do 
    log "移除可能存在的旧版本包: $pkg"
    sudo apt-get remove $pkg
done

log "配置Docker安装源..."
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update

log "安装Docker组件..."
apt-get install -y docker-ce docker-ce-cli containerd.io

# 配置docker
log "配置Docker数据目录和镜像源..."
cat <<"EOF" > /etc/docker/daemon.json
{
    "data-root": "/data/docker",
    "registry-mirrors": ["https://mirror.ccs.tencentyun.com"]
}
EOF
systemctl restart docker
log "Docker安装和配置完成"

# 安装k3s
log "开始安装K3s..."
curl -sfL https://rancher-mirror.rancher.cn/k3s/k3s-install.sh | sh -
systemctl enable k3s --now
log "K3s安装完成"

# 等待集群ready
log "等待K3s节点就绪..."
while ! kubectl get node $K3S_NODE_NAME; do
    log "正在等待节点 $K3S_NODE_NAME 就绪..."
    sleep 1
done
log "K3s节点已就绪"

# 安装longhorn
log "开始安装Longhorn..."
kubectl apply -f longhorn/longhorn.yaml
log "等待Longhorn组件就绪..."
while [[ $(kubectl get pods -n longhorn-system | grep longhorn | awk '{print $3}') != "Running" ]]; do
    log "正在等待Longhorn pods就绪..."
    sleep 5
done
log "Longhorn安装完成"

log "K3s集群初始化完成!"