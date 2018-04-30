# Usage: docker run -it --restart=always -v /home/.croat:/root/.croat -p 8080:8080 -p 8081:8081 --name=croat-node -d looongcat/croat-node

FROM debian:9
LABEL description="CROAT node image"
LABEL version="0.0.1"

# upgrade dist to latest and greatest
RUN apt-get update && apt-get -y upgrade
RUN apt-get install -y wget

# Deploy last version of Karbo CLI suite
WORKDIR /home
RUN wget https://croat.cat/apps/CroatCore_v1_55_ubuntu_16.04.tar.gz &&\
    tar -xzvf CroatCore_v1_55_ubuntu_16.04.tar.gz -C ./ &&\
    rm CroatCore_v1_55_ubuntu_16.04.tar.gz

WORKDIR /home/CROATCore

# Create blockchain folder and assign owner to the files
RUN /bin/bash -c 'mkdir /root/.croat'
RUN /bin/bash -c 'chmod +x /home/CROATCore/croatd /home/CROATCore/miner /home/CROATCore/simplewallet'

# Open container's ports for P2P and Lightwallet connections
EXPOSE 8080/tcp 8081/tcp

# Mount blockchain?
VOLUME ["/root/.croat"]

# Entry point
ENTRYPOINT ["/home/CROATCore/croatd", "--config-file=/home/CROATCore/configs/croat.conf", "--rpc-bind-ip=0.0.0.0", "--rpc-bind-port=8081"]
