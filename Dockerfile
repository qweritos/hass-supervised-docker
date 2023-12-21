FROM debian:12

LABEL org.opencontainers.image.title="Home Assistant Supervised in docker"
LABEL org.opencontainers.image.authors="Andrey Artamonychev<me@andrey.wtf>"
LABEL org.opencontainers.image.vendor="Andrey Artamonychev"
LABEL org.opencontainers.image.source="https://github.com/qweritos/hass-supervised-docker"
LABEL org.opencontainers.image.documentation="https://github.com/qweritos/hass-supervised-docker"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.description="Home Assistant Supervised container image based on Debian 12 with systemd and docker"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
  systemd \
  apparmor \
  jq \
  wget \
  curl \
  udisks2 \
  libglib2.0-bin \
  network-manager \
  dbus \
  lsb-release \
  systemd-journal-remote \
  systemd-resolved \
  nano \
  inetutils-ping \
  bluez \
  iproute2 \
  httping \
  avahi-daemon avahi-utils libnss-mdns \
  bash-completion

RUN curl -fsSL get.docker.com | sh

RUN rm -f \
  /lib/systemd/system/sockets.target.wants/*udev* \
  /lib/systemd/system/sockets.target.wants/*initctl* \
  /lib/systemd/system/local-fs.target.wants/* \
  /lib/systemd/system/sysinit.target.wants/systemd-tmpfiles-setup* \
  /etc/systemd/system/etc-resolv.conf.mount \
  /etc/systemd/system/etc-hostname.mount \
  /etc/systemd/system/etc-hosts.mount

RUN systemctl mask -- \
  tmp.mount \
  etc-hostname.mount \
  etc-hosts.mount \
  etc-resolv.conf.mount \
  swap.target \
  getty.target \
  getty-static.service \
  dev-mqueue.mount \
  cgproxy.service \
  systemd-tmpfiles-setup-dev.service \
  systemd-remount-fs.service \
  systemd-ask-password-wall.path \
  systemd-logind && \
  systemctl set-default multi-user.target || true

RUN systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target ModemManager.service

STOPSIGNAL SIGRTMIN+3

ADD ./rootfs /

RUN systemctl enable systemd-journal-remote.service systemd-resolved systemd-journal-gatewayd hass-install avahi-daemon

# ENTRYPOINT [ "/entrypoint.sh" ]
CMD ["/sbin/init", "--log-level=info", "--log-target=console"]
