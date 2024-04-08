#!/bin/bash
set -e

mount --make-rshared "${DATA_SHARE:=/usr/share/hassio}"

# wait for `hassio_cli` container available & `system state != "setup"`` 
echo "Start HASS Core container"
while ! ha core start; do
    echo Wait for HASS CLI container...
    sleep 1
done

# issue: https://github.com/home-assistant/supervisor/issues/4381
echo "Restart HASS Supervisor"
systemctl restart hassio-supervisor
