FROM lfnovo/open_notebook:v1-latest

# Install SurrealDB 2.x (3.x has breaking SQL changes incompatible with base image migrations)
RUN curl -sSf https://install.surrealdb.com | sh -s -- --version v2.4.1 && \
    mkdir -p /app/data/db

# Add surrealdb as a supervisord program.
# The container CMD uses: supervisord -c /etc/supervisor/conf.d/supervisord.conf
# That file is the REAL main config (not /etc/supervisor/supervisord.conf).
# It has no [include], so we append one — otherwise surrealdb.conf is never loaded.
COPY supervisord-surrealdb.conf /etc/supervisor/conf.d/surrealdb.conf
RUN printf '\n[include]\nfiles = /etc/supervisor/conf.d/surrealdb.conf\n' \
    >> /etc/supervisor/conf.d/supervisord.conf

# Defaults for all-in-one container (SurrealDB runs on localhost)
ENV SURREAL_URL=ws://localhost:8000/rpc
ENV SURREAL_USER=root
ENV SURREAL_PASSWORD=root
ENV SURREAL_NAMESPACE=open_notebook
ENV SURREAL_DATABASE=open_notebook

# entrypoint.sh patches the frontend's hardcoded PORT=8502 to Railway's
# injected port at runtime before supervisord starts
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
CMD ["/entrypoint.sh"]

EXPOSE 8502 5055
