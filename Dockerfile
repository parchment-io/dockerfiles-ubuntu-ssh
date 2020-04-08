FROM ubuntu:18.04

RUN apt-get update && apt-get install -y ssh && rm -f /etc/ssh/ssh_host_*
RUN sed -i 's/#HostKey \/etc\/ssh\/ssh_host_/HostKey \/etc\/ssh\/keys\/ssh_host_/' /etc/ssh/sshd_config
RUN mkdir -p /run/sshd
COPY /start.sh /start.sh
VOLUME /home
VOLUME /etc/ssh/keys
VOLUME /opt/user_keys
EXPOSE 22
ENTRYPOINT ["/start.sh"]
