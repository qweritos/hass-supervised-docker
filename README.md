# Home Assistant Supervised in docker

Simple container image based on Debian 12 with systemd and dockerd. 

Can be used to run supervised instance of hass.io inside single docker container (as for example inside kubernetes pod).

## Run:

```bash
docker run -d --name hass --privileged -p 8123:8123 -v $(pwd)/data:/usr/share/hassio qweritos/hass-supervised-docker
```
Open http://localhost:8123/ and follow the instructions.

Config path: `/usr/share/hassio` (as it specified in [https://github.com/home-assistant/supervised-installer](https://github.com/home-assistant/supervised-installer) )
