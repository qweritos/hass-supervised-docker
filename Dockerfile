FROM debian:12

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -y \
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
  bluez

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

RUN systemctl enable systemd-journal-remote.service systemd-resolved systemd-journal-gatewayd hass-install

# ENTRYPOINT [ "/entrypoint.sh" ]
CMD ["/sbin/init", "--log-level=info", "--log-target=console"]
