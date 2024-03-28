#!/bin/bash
set -e

export DEBIAN_FRONTEND=noninteractive

mount --make-rshared /usr/share/hassio

docker rm -f hassio_supervisor || true

cd /tmp

rm -rf supervised-installer
git clone https://github.com/home-assistant/supervised-installer.git supervised-installer
cd supervised-installer

docker run --rm -v $(pwd):/tmp debian:bullseye-slim bash -c \
          "cd /tmp \
          && chmod 555 homeassistant-supervised/DEBIAN/p* \
          && dpkg-deb --build --root-owner-group homeassistant-supervised"
cd ..

wget -O os-agent_linux_x86_64.deb https://github.com/home-assistant/os-agent/releases/download/1.6.0/os-agent_1.6.0_linux_x86_64.deb

apt install -y ./os-agent_linux_x86_64.deb

apt install -y ./supervised-installer/homeassistant-supervised.deb

exec "$@"
