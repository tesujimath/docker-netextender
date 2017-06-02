FROM ubuntu:16.04
LABEL maintainer "Jakub Vanak"

# Usage:
#
# Linux:
#
#   docker run -ti --privileged --name netextender --rm \
#     -e PROXY_USER=proxy_user -e VPN_USER=vpn_user \
#     -e VPN_DOMAIN=domain -e VPN_SERVER=server \
#     -p 3128:3128 -v /lib/modules:/lib/modules netextender

RUN \
  apt-get update && \
  apt-get install -q -y build-essential \
                        software-properties-common \
                        apache2-utils byobu curl git htop man ppp squid3 unzip vim w3m wget \
                        ipppd iptables iputils-ping iproute net-tools ssh

RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java8-installer && \
  rm -rf /var/cache/oracle-jdk8-installer 

ENV JAVA_HOME /usr/lib/jvm/java-8-oracle 

RUN mkdir -p /build && \
  cd /build && \
  wget https://sslvpn.demo.sonicwall.com/NetExtender.x86_64.tgz 

RUN cd /build && \
  tar xzvf NetExtender.x86_64.tgz && \
  cd netExtenderClient && \
  ./install  

ADD run.sh / 
RUN chmod u+x /run.sh 

WORKDIR /

CMD ["/run.sh"]
