# Passthrough of the official Open Notebook image.
#
# This repo is the source for the Railway template's APP service
# (https://railway.com/deploy/open-notebook-1). The template also provisions a
# SEPARATE SurrealDB service (surrealdb/surrealdb:v2) and auto-wires SURREAL_URL
# so the app connects to it over Railway's private network.
#
# Therefore this image must behave EXACTLY like the official image:
#   - do NOT bundle SurrealDB (the template provides it)
#   - do NOT hardcode SURREAL_URL (the template sets it)
#   - do NOT patch the frontend port (the template routes to the image's 8502;
#     a custom entrypoint that moves it elsewhere causes a 502 at the edge)
FROM lfnovo/open_notebook:v1-latest
