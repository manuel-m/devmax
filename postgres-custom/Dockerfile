FROM postgres:15

# Set non-root UID/GID (match your host user, e.g., 1000)
ARG PGUSER_UID=1000
ARG PGUSER_GID=1000

# Create a new postgres user with this UID/GID
RUN groupadd -g ${PGUSER_GID} pguser && \
    useradd -u ${PGUSER_UID} -g pguser -m pguser && \
    mkdir -p /var/lib/postgresql/data/pgdata && \
    chown -R pguser:pguser /var/lib/postgresql/data /docker-entrypoint-initdb.d

USER pguser
ENV PGDATA=/var/lib/postgresql/data/pgdata
