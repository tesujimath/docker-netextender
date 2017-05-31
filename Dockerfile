FROM hjoest/netextender
LABEL maintainer "Jakub Vanak"

# Usage:
#
# Linux:
#
#   docker run -ti --privileged --name netextender --rm \
#     -e PROXY_USER=proxy_user -e VPN_USER=vpn_user \
#     -e VPN_DOMAIN=domain -e VPN_SERVER=server \
#     -p 3128:3128 -v /lib/modules:/lib/modules netextender
#
# OS/X:
#
#   docker run -ti --privileged --name netextender --rm \
#     -e PROXY_USER=proxy_user -e VPN_USER=vpn_user \
#     -e VPN_DOMAIN=domain -e VPN_SERVER=server \
#     -p 3128:3128 netextender

RUN \
  apt-get update && \
  apt-get install -q -y expect iptables net-tools iproute ipppd ssh

ADD run.sh /
RUN chmod u+x /run.sh

COPY netextender /usr/bin/netextender
RUN chmod u+x /usr/bin/netextender

WORKDIR /

CMD ["/run.sh"]
