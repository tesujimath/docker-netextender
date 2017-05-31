FROM hjoest/netextender
LABEL maintainer "Jakub Vanak"

# Usage:
#
# Linux:
#
#   docker run -ti --privileged --name netextender --rm \
#     -e VPN_RDPIP=remote_terminal_ip \
#     -e VPN_USER=vpn_user -e VPN_PASS=vpn_password \
#     -e VPN_DOMAIN=domain -e VPN_SERVER=server \ 
#     -p 53128:3128 -v /lib/modules:/lib/modules koubek/netextender
#

RUN \
  apt-get update && \
  apt-get install -q -y expect iptables net-tools iproute ipppd ssh

ADD run.sh /
RUN chmod u+x /run.sh

COPY netextender /usr/bin/netextender
RUN chmod u+x /usr/bin/netextender

WORKDIR /

CMD ["/run.sh"]
