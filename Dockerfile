FROM lfnovo/open_notebook:v1-latest

# Install SurrealDB 2.x (3.x has breaking SQL changes incompatible with base image migrations)
RUN curl -sSf https://install.surrealdb.com | sh -s -- --version v2.4.1 && \
    mkdir -p /app/data/db

COPY supervisord-surrealdb.conf /etc/supervisor/conf.d/surrealdb.conf

# Include the SurrealDB config (base image supervisord.conf has no [include])
RUN echo '[include]' >> /etc/supervisor/conf.d/supervisord.conf && \
    echo 'files = /etc/supervisor/conf.d/surrealdb.conf' >> /etc/supervisor/conf.d/supervisord.conf

# Tell Railway which port to route to (it won't override an existing PORT)
ENV PORT=8502

# Defaults for all-in-one container (SurrealDB runs on localhost)
ENV SURREAL_URL=ws://localhost:8000/rpc
ENV SURREAL_USER=root
ENV SURREAL_PASSWORD=root
ENV SURREAL_NAMESPACE=open_notebook
ENV SURREAL_DATABASE=open_notebook

EXPOSE 8502 5055
