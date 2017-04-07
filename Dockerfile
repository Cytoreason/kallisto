FROM ubuntu:16.04
MAINTAINER Robert Schiemann "rschiemann@parkerici.org"

RUN apt-get update && apt-get install -y wget
RUN cd ~/ && wget https://github.com/pachterlab/kallisto/releases/download/v0.43.1/kallisto_linux-v0.43.1.tar.gz && tar -xzvf kallisto_linux-v0.43.1.tar.gz && rm kallisto_linux-v0.43.1.tar.gz
ADD homo_sapiens_GRCh38 /root/indices/