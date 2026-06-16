#!/bin/sh
set -e

# Ensure SurrealDB data dir exists at runtime
# (volume mount at /app/data hides dirs created at build time)
mkdir -p /app/data/db

# Railway overrides PORT at runtime. Supervisord's environment= lines don't
# inherit the parent environment, so we patch the conf before supervisord starts.
LISTEN_PORT="${PORT:-8502}"
if [ "$LISTEN_PORT" != "8502" ]; then
    sed -i "s/PORT=\"8502\"/PORT=\"${LISTEN_PORT}\"/" \
        /etc/supervisor/conf.d/supervisord.conf
fi

exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
