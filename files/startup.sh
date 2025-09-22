#!/usr/bin/env bash
set -euxo pipefail

# Update packages
apt-get update -y
apt-get upgrade -y

# Install dependencies
apt-get install -y ca-certificates curl gnupg lsb-release git

# Install Docker
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
> /etc/apt/sources.list.d/docker.list

apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
systemctl enable docker
systemctl start docker

# Clone T-Pot repo
if [ ! -d /opt/tpotce ]; then
  git clone https://github.com/telekom-security/tpotce /opt/tpotce
fi

echo "Startup script completed — T-Pot repo is ready at /opt/tpotce."