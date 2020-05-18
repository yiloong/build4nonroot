FROM ubuntu:18.04

RUN echo "deb http://ftp.sjtu.edu.cn/ubuntu bionic main universe restricted multiverse" > /etc/apt/sources.list \
    && echo "deb http://ftp.sjtu.edu.cn/ubuntu bionic-security main universe restricted multiverse" >> /etc/apt/sources.list \
    && echo "deb http://ftp.sjtu.edu.cn/ubuntu bionic-updates main universe restricted multiverse" >> /etc/apt/sources.list \
    && echo "deb http://ftp.sjtu.edu.cn/ubuntu bionic-backports main universe restricted multiverse" >> /etc/apt/sources.list \
    && echo "deb-src http://ftp.sjtu.edu.cn/ubuntu bionic main universe restricted multiverse" >> /etc/apt/sources.list \
    && echo "deb-src http://ftp.sjtu.edu.cn/ubuntu bionic-security main universe restricted multiverse" >> /etc/apt/sources.list \
    && echo "deb-src http://ftp.sjtu.edu.cn/ubuntu bionic-updates main universe restricted multiverse" >> /etc/apt/sources.list \
    && echo "deb-src http://ftp.sjtu.edu.cn/ubuntu bionic-backports main universe restricted multiverse" >> /etc/apt/sources.list \
    && apt-get update 
