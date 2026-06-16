FROM lfnovo/open_notebook:v1-latest

# Install SurrealDB
RUN curl -sSf https://install.surrealdb.com | sh && \
    mv /root/.surrealdb/surreal /usr/local/bin/surreal && \
    mkdir -p /data

COPY supervisord-surrealdb.conf /etc/supervisor/conf.d/surrealdb.conf

EXPOSE 8502 5055
