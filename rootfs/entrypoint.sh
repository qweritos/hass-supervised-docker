#!/bin/bash
set -e

dpkg -i /root/os-agent_1.5.1_linux_x86_64.deb

exec "$@"