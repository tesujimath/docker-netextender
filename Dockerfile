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
  apt-get install -q -y iptables net-tools iproute ipppd iptables ssh

CMD ["/run.sh"]
