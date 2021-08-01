# Home Assistant Supervised in docker

Simple container image based on Debian 10 with systemd and dockerd. 

Can be used to run supervised instance of hass.io inside single docker container (as for example inside kubernetes pod).

## Run:

```bash
docker run -d --name hass --privileged -p 8123:8123 -v $(pwd)/data:/hassio qweritos/hass-supervised-docker:latest
```

for k8s you may need to use this to avoid some issues with hassio-dns:
```yaml
spec:
  containers:
  # ...
  dnsConfig:
    options:
      - name: ndots
        value: "0"
```

Open http://localhost:8123/ and follow the instructions.

Config path: `/hassio/homeassistant/`

Startup configs and scripts are taken from https://github.com/home-assistant/supervised-installer/tree/master/files
