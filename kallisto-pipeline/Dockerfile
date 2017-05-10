FROM ubuntu:16.04
MAINTAINER Robert Schiemann "rschiemann@parkerici.org"

RUN apt-get update && apt-get install -y wget r-base

RUN cd ~/ && wget https://github.com/pachterlab/kallisto/releases/download/v0.43.1/kallisto_linux-v0.43.1.tar.gz && \
    tar -xzvf kallisto_linux-v0.43.1.tar.gz && rm kallisto_linux-v0.43.1.tar.gz && \
    echo 'PATH="$PATH:$HOME/kallisto_linux-v0.43.1"' >> ~/.bashrc

ADD code /code
RUN chmod a+x /code/*
