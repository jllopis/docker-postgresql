FROM ubuntu:12.04

MAINTAINER Joan Llopis "jllopis@acb.es"
ENV DEBIAN_FRONTEND noninteractive

RUN locale-gen es_ES.UTF-8
ENV LANG es_ES.UTF-8
ENV LC_ALL es_ES.UTF-8

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" > /etc/apt/sources.list.d/pgdg.list

RUN apt-get update
RUN apt-get -yq install python-software-properties software-properties-common --no-install-recommends

# Install postgresql 9.3
RUN apt-get -yq install postgresql-9.3 postgresql-client-9.3 postgresql-contrib-9.3 --no-install-recommends

# Use the postgres user
USER postgres

# Initialize the server
RUN /etc/init.d/postgresql start &&\
    psql --command "ALTER USER postgres ENCRYPTED PASSWORD 'secret';"

RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/9.3/main/pg_hba.conf
RUN echo "listen_addresses='*'" >> /etc/postgresql/9.3/main/postgresql.conf

# Expose the PostgreSQL port
EXPOSE 5432

# Add VOLUMEs to allow backup of config, logs and databases
VOLUME ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]

ENTRYPOINT ["/usr/lib/postgresql/9.3/bin/postgres"]
CMD ["-D", "/var/lib/postgresql/9.3/main", "-c", "config_file=/etc/postgresql/9.3/main/postgresql.conf"]

# docker build -t jllopis/postgresql:9.3 .
