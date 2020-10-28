# NetExtender (SonicWALL) for Docker

Connect to a SonicWALL VPNs through docker NetExtender container.

*This fork differs from upstream by using VPN_IPFORWARD instead of VPN_RDPIP for port forwarding.  VPN_IP_FORWARD should be a comma separated list of localport:remoteip:remoteport triples.*

## Usage

You can access a predetermined target PC inside the VPN directly from any machine in your LAN using RDP. You just open RDP and set the `IP:PORT` like this `docker-host-name-or-IP:docker-host-mapped-port`, where
 * `docker-host-name-or-IP` - name (or IP) of your docker host,
 * `docker-host-mapped-port` - port on the left side of `-p` parameter (can be seen below).
The docker image will handle the rest using internally installed **NetExtender** and via routings
specified inside as well.

This allows the user to connect to the docker host with the specified port, which will then be forwarded to the docker container running the vpn, and finally redirected to the remote machine you wish to connect to (set by `VPN_IPFORWARD`).

If running the docker container from the machine you wish to connect from you can omit the -p settings, and connect to the IP address of the container on port 3380.

```bash
# Start the privileged docker container

# -d => detached mode (you can use -it to run it interactively)
# --name => specify a name of the container
# --label => labels are not necessary but can help to identify and filter the containers
# --privileged => this is vital to run VPN containers in a privileged mode (or use caps)
# -p => # use mapped ports to allow access to anyone in your network (using a port on the left side)

# -e "VPN_SERVER=vpn-gateway-ip:port" => specify VPN gateway and port (defined by your VPN provider)
# -e "VPN_USER=[user-id]" => VPN user ID (defined by your VPN provider)
# -e "VPN_PASS=[pwd]" => VPN user password (defined by your VPN provider). You can use DOCKER SWARM secrets to make this more secure.
# -e "VPN_DOMAIN=domain-or-address" (defined by your VPN provider)
# -e "VPN_IPFORWARD=3380:192.168.1.123:3389" => port forwarding rule for RDP to remote PC (target PC inside the VPN)

docker run \
    -d 
    --name vpn-test1 \
    --label container-type=vpnclient \
    --label vpn-type=netextender \
    --label customer=customer-XYZ \
    --cap-add=NET_ADMIN \
    --device=/dev/ppp \
    -p 51234:3380 \
    -e "VPN_SERVER=vpn-gateway-ip:port" \
    -e "VPN_USER=[user-id]" \
    -e "VPN_PASS=[pwd]" \
    -e "VPN_DOMAIN=domain-or-address" \
    -e "VPN_IPFORWARD=3380:192.168.1.123:3389" \
    calidae/netextender
```
