#!/usr/bin/env bash

# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

if [ -z "$NOMAD_VERSION" ]; then
  NOMAD_VERSION=1.4.3
fi
HOST_ARCH=$( [ $(uname -m) = aarch64 ] && echo arm64 || echo amd64)

echo "Installing nomad version $NOMAD_VERSION to /usr/local/bin/"
curl -L -o nomad.zip "https://releases.hashicorp.com/nomad/$NOMAD_VERSION/nomad_"$NOMAD_VERSION"_linux_$HOST_ARCH".zip
unzip -o nomad.zip -d /usr/local/bin/

echo "Installing CNI reference plugins"
curl -L -o cni-plugins.tgz "https://github.com/containernetworking/plugins/releases/download/v1.0.0/cni-plugins-linux-$HOST_ARCH"-v1.0.0.tgz
mkdir -p /opt/cni/bin
tar -C /opt/cni/bin -xzf cni-plugins.tgz

echo "Setting up CNI network iptables"
echo 1 | tee /proc/sys/net/bridge/bridge-nf-call-arptables
echo 1 | tee /proc/sys/net/bridge/bridge-nf-call-ip6tables
echo 1 | tee /proc/sys/net/bridge/bridge-nf-call-iptables


if [ ! -f /etc/sysctl.d/bridge.conf ]; then
  cat <<EOF >> /etc/sysctl.d/bridge.conf
  net.bridge.bridge-nf-call-arptables = 1
  net.bridge.bridge-nf-call-ip6tables = 1
  net.bridge.bridge-nf-call-iptables = 1
EOF
fi
