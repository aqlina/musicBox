FROM postgres:13.0-alpine

RUN mkdir -p /tmp/psql_data

COPY dumpfile.sql /tmp/psql_data
COPY dumpfile.sql /docker-entrypoint-initdb.d/

#RUN chown -R postgres:postgres /tmp/psql_data
RUN chown postgres:postgres /docker-entrypoint-initdb.d/*.sql

EXPOSE 5432



