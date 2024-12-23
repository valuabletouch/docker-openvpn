FROM alpine:latest

LABEL maintainer="Mehmet Yasin AKAR <yasin.akar@valuabletouch.com>"

ENV S6_OVERLAY_VERSION=v3.2.0.2
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2
ENV S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0

RUN set -ex; \
    apk add \
        --repository=http://dl-cdn.alpinelinux.org/alpine/edge/main \
        --update \
        --no-cache \
        openvpn \
        easy-rsa \
        dnsmasq \
        iptables \
        iproute2 \
        bash \
        curl \
        openvpn-auth-pam \
        google-authenticator; \
    ln -s /usr/share/easy-rsa/easyrsa /usr/local/bin; \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /var/cache/distfiles/*

RUN set -ex; \
    apk add \
        --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing \
        --update \
        --no-cache \
        pamtester; \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /var/cache/distfiles/*

RUN set -ex; \
    curl -L https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz | \
        tar -C / -Jxvf -; \
    curl -L https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz | \
        tar -C / -Jxvf -

COPY rootfs/ /

RUN chmod a+x /usr/local/bin/ovpn_*
RUN chmod a+x /cont-init.d/*
RUN chmod a+x /services.d/*/run

ENV OPENVPN=/etc/openvpn
ENV OPENVPN_CONF=$OPENVPN/openvpn.conf

ENV EASYRSA=/usr/share/easy-rsa
ENV EASYRSA_PKI=$OPENVPN/pki
ENV EASYRSA_CRL_DAYS=3650

ENV DNSMASQ=/etc/dnsmasq.d
ENV DNSMASQ_CONF=$DNSMASQ/dnsmasq.conf

EXPOSE 1194/udp

VOLUME ["/etc/dnsmasq.d"]

VOLUME ["/etc/openvpn"]

ENTRYPOINT ["/init"]

CMD []
