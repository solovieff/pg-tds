FROM postgres:12

LABEL maintainer='Andrey Solovyev solovieff.nnov@gmail.com'

RUN apt-get update
RUN apt-get -y install postgresql-server-dev-12 libsybdb5 freetds-dev freetds-common make gcc git libaio1 libaio-dev

WORKDIR /root

RUN git clone https://github.com/tds-fdw/tds_fdw.git
WORKDIR tds_fdw
RUN make USE_PGXS=1
RUN make USE_PGXS=1 install

WORKDIR /root

RUN  apt-get clean && \
     rm -rf /var/cache/apt/* /var/lib/apt/lists/*

#ENTRYPOINT ["/docker-entrypoint.sh"]
RUN    mkdir /pg
RUN    mkdir /backup
RUN    mkdir /logs
RUN   chown postgres:postgres /logs
RUN   chown postgres:postgres /pg
RUN   chown postgres:postgres /backup

WORKDIR /pg

EXPOSE 5432
#CMD ["postgres"]
