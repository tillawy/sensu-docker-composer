FROM ubuntu:18.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -y wget apt-utils apt-transport-https gnupg
RUN wget -q https://sensu.global.ssl.fastly.net/apt/pubkey.gpg -O- | apt-key add -


RUN echo "deb https://sensu.global.ssl.fastly.net/apt bionic main" | tee /etc/apt/sources.list.d/sensu.list
RUN apt-get update
RUN apt-get install -y supervisor sensu uchiwa

RUN apt install gcc g++ make telnet iputils-ping -y

RUN /opt/sensu/embedded/bin/gem install sensu-plugins-http sensu-plugins-redis --no-ri --no-rdoc 

COPY files/config.json files/transport.json files/uchiwa.json /etc/sensu/
COPY files/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 4567

CMD ["/usr/bin/supervisord"]

