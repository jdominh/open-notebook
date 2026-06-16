FROM lfnovo/open_notebook:v1-latest

# Install SurrealDB
RUN curl -sSf https://install.surrealdb.com | sh && \
    mkdir -p /app/data/db

COPY supervisord-surrealdb.conf /etc/supervisor/conf.d/surrealdb.conf

# Tell Railway which port to route to (it won't override an existing PORT)
ENV PORT=8502

# Defaults for all-in-one container (SurrealDB runs on localhost)
ENV SURREAL_URL=ws://localhost:8000/rpc
ENV SURREAL_USER=root
ENV SURREAL_NAMESPACE=open_notebook
ENV SURREAL_DATABASE=open_notebook

EXPOSE 8502 5055
