# vim:set ft=dockerfile:
FROM ubuntu:14.04

MAINTAINER Joan Llopis "jllopisg@gmail.com"
ENV DEBIAN_FRONTEND noninteractive

RUN locale-gen es_ES.UTF-8
ENV LANG es_ES.UTF-8
ENV LC_ALL es_ES.UTF-8

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8 &&\
    echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" > /etc/apt/sources.list.d/pgdg.list &&\

    apt-get update &&\
    apt-get -yq install python-software-properties software-properties-common --no-install-recommends &&\

# Install postgresql 9.4
    apt-get -yq install postgresql-9.4 postgresql-client-9.4 postgresql-contrib-9.4 --no-install-recommends

# Use the postgres user
USER postgres

# Initialize the server
RUN /usr/bin/pg_dropcluster 9.4 main &&\
    /usr/bin/pg_createcluster --locale es_ES.UTF-8 9.4 main &&\
    /etc/init.d/postgresql start &&\
    psql --command "ALTER USER postgres ENCRYPTED PASSWORD 'secret';" &&\
    /etc/init.d/postgresql stop &&\

    echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/9.4/main/pg_hba.conf &&\
    echo "listen_addresses='*'" >> /etc/postgresql/9.4/main/postgresql.conf

# Expose the PostgreSQL port
EXPOSE 5432

# Add VOLUMEs to allow backup of config, logs and databases
VOLUME ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]

ENTRYPOINT ["/usr/lib/postgresql/9.4/bin/postgres"]
CMD ["-D", "/var/lib/postgresql/9.4/main", "-c", "config_file=/etc/postgresql/9.4/main/postgresql.conf"]

# docker build -t jllopis/postgresql:9.4 .
