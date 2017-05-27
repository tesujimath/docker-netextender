#!/bin/sh

# for v in 'PROXY_USER' 'VPN_USER' 'VPN_DOMAIN' 'VPN_SERVER' 'VPNRDPIP'; do
for v in 'VPN_USER' 'VPN_DOMAIN' 'VPN_SERVER' 'VPN_RDPIP'; do
    if test -z $(eval "echo \$$v"); then
        echo "Missing env variable $v" >&2
        exit 1
    fi
done

iptables -t nat -A PREROUTING -p tcp --dport 3380 -j DNAT --to-destination  ${VPN_RDPIP}:3389
iptables -t nat -A POSTROUTING -j MASQUERADE

# Setup masquerade, to allow using the container as a gateway
for iface in $(ip a | grep eth | grep inet | awk '{print $2}'); do
  iptables -t nat -A POSTROUTING -s "$iface" -j MASQUERADE
done

delayed_start()
{
    while test $(ps -ef | grep -v grep | grep -c nxMonitor) -eq 0; do
        sleep 1
    done
    # squid3
}
# echo "Provide a password for web proxy user '$PROXY_USER':" >&2
# htpasswd -c /etc/squid3/passwords "$PROXY_USER"
# echo >&2
delayed_start &
netExtender -u "$VPN_USER" -d "$VPN_DOMAIN" "$VPN_SERVER"
