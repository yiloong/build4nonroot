FROM ubuntu:20.04

RUN echo "deb http://mirrors.zju.edu.cn/ubuntu focal main universe restricted multiverse" > /etc/apt/sources.list \
    && echo "deb http://mirrors.zju.edu.cn/ubuntu focal-security main universe restricted multiverse" >> /etc/apt/sources.list \
    && echo "deb http://mirrors.zju.edu.cn/ubuntu focal-updates main universe restricted multiverse" >> /etc/apt/sources.list \
    && echo "deb http://mirrors.zju.edu.cn/ubuntu focal-backports main universe restricted multiverse" >> /etc/apt/sources.list \
    && echo "deb-src http://mirrors.zju.edu.cn/ubuntu focal main universe restricted multiverse" >> /etc/apt/sources.list \
    && echo "deb-src http://mirrors.zju.edu.cn/ubuntu focal-security main universe restricted multiverse" >> /etc/apt/sources.list \
    && echo "deb-src http://mirrors.zju.edu.cn/ubuntu focal-updates main universe restricted multiverse" >> /etc/apt/sources.list \
    && echo "deb-src http://mirrors.zju.edu.cn/ubuntu focal-backports main universe restricted multiverse" >> /etc/apt/sources.list \
    && apt-get update 
