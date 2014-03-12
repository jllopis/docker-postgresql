docker-postgresql
=================

Docker trusted build for PostgreSQL database

# Version

PostgreSQL v9.3.3

# Build from repository

````bash

$ git clone git@github.com:jllopis/docker-postgresql.git
$ cd docker-postgresql
$ docker build --rm -t my_user/postgresql:latest
````

# Start

````bash

# docker run -d -p 5432:5432 \
             -v {local_etc_fs}:/etc/postgresql \
             -v {local_log_fs}:/var/log/postgresql \
             -v {local_lib_fs}:/var/lib/postgresql \
             -t -h {node_host_name} -name {image_name} my_user/postgresql:latest
````

where:

- **local_XXX_fs** is the local storage to keep data safe. If not specified it will use the container so the data will be lost upon restart.
- **node_hostname** is the name that will hold the HOSTNAME variable inside the container. This is accessible to CMD so etcd will use it as their node name. If not specified a default name wil be used.
- **image_name** is the name given to the image so you don't have to play with ids

You can also start postgresql image with command line options:

````bash

# docker run -d -p 7777:7777 \
             -v {local_etc_fs}:/etc/postgresql \
             -v {local_log_fs}:/var/log/postgresql \
             -v {local_lib_fs}:/var/lib/postgresql \
             -t -h {node_host_name} -name {image_name} \
             my_user/postgresql:latest -c config_file=/etc/postgresql/other_postgresql.conf
````

# Ports

The ports used are:

- 5432

Remember that if you want access from outside the container you must explicitly tell docker to do so by setting -p at image launch.

# PostgreSQL use

By default, a postgres user is created and given a password (*default password*: secret). It is highly encouraged that you change this password for your own.

To change the password issue:

````bash

psql --command "ALTER USER postgres ENCRYPTED PASSWORD 'secret';"
````

Change *'secret'* for your highly secure password.

Usually you can modify the database (manage users, databases, etc) by executing **psql** commands from your host by way of the **postgres** user:

````bash

psql -Upostgres --command "SQL COMMAND;"
````

## Examples

### Create a user

````bash

psql -Upostgres --command "CREATE ROLE my_user WITH LOGIN ENCRYPTED PASSWORD 'very_secure_password';"
````

### Create a database

````bash

psql -Upostgres --command "CREATE DATABASE testdb OWNER my_user ENCODING 'UTF-8';"
````

### Drop a database

````bash

psql -Upostgres --command "DROP DATABASE testdb;"
````


## How to restore data from a pg_dump backup

````bash

$ psql -Upostgres < path_to_dump_file.sql
````
