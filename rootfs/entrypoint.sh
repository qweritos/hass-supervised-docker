#!/bin/bash
set -e

mount --make-rshared /usr/share/hassio


cd /tmp

git clone https://github.com/home-assistant/supervised-installer.git
cd supervised-installer
git apply /mypatch.patch
docker run --rm -v $(pwd):/tmp debian:bullseye-slim bash -c \
          "cd /tmp \
          && chmod 555 homeassistant-supervised/DEBIAN/p* \
          && dpkg-deb --build --root-owner-group homeassistant-supervised"
cd ..


wget https://github.com/home-assistant/os-agent/releases/download/1.6.0/os-agent_1.6.0_linux_x86_64.deb

apt install -y ./os-agent_1.6.0_linux_x86_64.deb

rm -rf /etc/docker/*

apt install -y ./supervised-installer/homeassistant-supervised.deb

exec "$@"
