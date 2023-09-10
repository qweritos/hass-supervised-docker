FROM debian:12

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
RUN echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN apt-get update
RUN apt-get install -y docker-ce docker-ce-cli containerd.io fuse-overlayfs systemd network-manager jq

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
systemd-resolved.service \
swap.target \
getty.target \
getty-static.service \
dev-mqueue.mount \
cgproxy.service \
systemd-tmpfiles-setup-dev.service \
systemd-remount-fs.service \
systemd-ask-password-wall.path && \
systemctl set-default multi-user.target || true

RUN systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target ModemManager.service NetworkManager.service

STOPSIGNAL SIGRTMIN+3

ADD ./rootfs /

RUN systemctl enable hassio-apparmor.service hassio-supervisor.service

CMD ["/sbin/init", "--log-level=info", "--log-target=console"]

RUN apt-get purge --autoremove -y apt-transport-https \
    curl \
    gnupg \
    lsb-release \
    && rm -rf /var/lib/apt/lists/* && \
    apt-get clean autoclean \
    apt-get autoremove --yes
