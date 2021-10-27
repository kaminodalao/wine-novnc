FROM debian:11

ENV HOME /root
ENV USER root
ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

WORKDIR /root

EXPOSE 6080

RUN mkdir /root/build &&\
    cd /root/build &&\
    sed -i 's/deb.debian.org/mirrors.tencent.com/g' /etc/apt/sources.list &&\
    sed -i 's/security.debian.org/mirrors.tencent.com/g' /etc/apt/sources.list &&\
    apt update &&\
    apt install -y wget gnupg2 websockify procps tightvncserver xfce4 dbus-x11 &&\
    dpkg --add-architecture i386 &&\
    wget -qO - https://mirrors.imea.me/dl.winehq.org/wine-builds/winehq.key | apt-key add - &&\
    echo "deb https://mirrors.imea.me/dl.winehq.org/wine-builds/debian/ bullseye main" >> /etc/apt/sources.list &&\
    apt update &&\
    apt install -y --install-recommends winehq-stable &&\
    wget https://ghproxy.com/https://github.com/novnc/noVNC/archive/refs/tags/v1.3.0.tar.gz &&\
    tar -zxvf v1.3.0.tar.gz -C /opt &&\
    wget https://mirrors.imea.me/dl.winehq.org/wine/wine-mono/6.4.0/wine-mono-6.4.0-x86.msi &&\
    wine msiexec /i wine-mono-6.4.0-x86.msi &&\
    wget https://mirrors.imea.me/dl.winehq.org/wine/wine-gecko/2.47.2/wine-gecko-2.47.2-x86_64.msi &&\
    wine msiexec /i wine-gecko-2.47.2-x86_64.msi

ADD docker-entrypoint.sh /usr/bin/
ADD xstartup /root/.vnc/

ENTRYPOINT ["docker-entrypoint.sh"]