FROM srinivasachalla/docker-ubuntu
MAINTAINER Sunidhi Sharma <sunidhi.sharma@sap.com>

# Install wget
RUN apt-get update && \
    apt-get install wget

#ENV CPUS $(grep -c ^processor /proc/cpuinfo)

# Install PostgreSQL 9.4
RUN DEBIAN_FRONTEND=noninteractive \
    cd /tmp && \
    wget https://ftp.postgresql.org/pub/source/v9.4.14/postgresql-9.4.14.tar.gz && \
    tar xfv postgresql-9.4.14.tar.gz && \
    cd postgresql-9.4.14 && \
    pwd && \
    ls -l && \
    apt-get install libssl-dev -y && \
    apt-get install libreadline6 libreadline6-dev && \
    mkdir -p /usr/lib/postgresql/9.4/ && \
    pwd && \
    ls -l && \
    ./configure --with-openssl --prefix=/usr/lib/postgresql/9.4/ && \
    export CPUS=$(grep -c ^processor /proc/cpuinfo) && \
    echo "Number of CPUS >>>> $CPUS" && \
    make -j${CPUS} world && make install-world && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
#RUN sudo apt-get install libssl-dev -y
#RUN sudo apt-get install libreadline6 libreadline6-dev
#RUN mkdir -p /usr/lib/postgresql/9.4/
#RUN pwd
#RUN ls -l
#RUN ./configure --with-openssl --prefix=/usr/lib/postgresql/9.4/
#RUN make -j${CPUS} world && make install-world
#RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#RUN ./configure --with-openssl --with-libxml

#RUN make -j${CPUS} world && make install-world

## remove wget
RUN apt-get remove wget -y

# Add scripts
ADD scripts /scripts
RUN chmod +x /scripts/*.sh
RUN touch /.firstrun

# Command to run
ENTRYPOINT ["/scripts/run.sh"]
CMD [""]

# Expose listen port
EXPOSE 5432

# Expose our data directory
VOLUME ["/data"]
