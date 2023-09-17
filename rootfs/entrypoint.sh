#!/bin/bash
set -e

mount --make-rshared /usr/share/hassio

cd /tmp
wget https://github.com/home-assistant/os-agent/releases/download/1.6.0/os-agent_1.6.0_linux_x86_64.deb
wget https://github.com/home-assistant/supervised-installer/releases/latest/download/homeassistant-supervised.deb

apt install ./os-agent_1.6.0_linux_x86_64.deb

# mv /etc/docker/daemon.json /etc/docker/daemon.json.orig

apt install ./homeassistant-supervised.deb

exec "$@"