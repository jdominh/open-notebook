# open-notebook

Self-hosted [Open Notebook LM](https://github.com/lfnovo/open-notebook) — an open-source NotebookLM alternative with more flexibility.

## Deploy on Railway (one click)

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/new/template?template=https://github.com/jdominh/open-notebook&envs=OPEN_NOTEBOOK_ENCRYPTION_KEY,SURREAL_URL,SURREAL_USER,SURREAL_PASSWORD,SURREAL_NAMESPACE,SURREAL_DATABASE&OPEN_NOTEBOOK_ENCRYPTION_KEYDesc=Secret+key+to+encrypt+stored+API+keys+(any+random+string)&SURREAL_URLDefault=ws%3A%2F%2Flocalhost%3A8000%2Frpc&SURREAL_USERDefault=root&SURREAL_PASSWORDDefault=root&SURREAL_NAMESPACEDefault=open_notebook&SURREAL_DATABASEDefault=open_notebook)

> **Required:** Set `OPEN_NOTEBOOK_ENCRYPTION_KEY` to any random secret string before deploying.  
> Generate one: `openssl rand -hex 32`

After deploy, open your Railway public URL and go to **Models** to add your AI provider API key.

## Run locally

```bash
cp .env.example .env
# Edit .env — set OPEN_NOTEBOOK_ENCRYPTION_KEY to a random secret
docker compose up -d
```

Open: http://localhost:8502

## Services

| Port | Service |
|------|---------|
| 8502 | Web UI |
| 5055 | REST API |
| 8000 | SurrealDB (local only) |

## Manage (local)

```bash
onote           # start + open browser
onote stop      # stop
onote status    # container status
onote logs      # tail logs
```
