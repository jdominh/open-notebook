# open-notebook

Self-hosted [Open Notebook LM](https://github.com/lfnovo/open-notebook) — an open-source NotebookLM alternative with 18+ AI providers and full data ownership.

## Deploy on Railway (one click)

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/new/template?template=https://github.com/jdominh/open-notebook&envs=OPEN_NOTEBOOK_ENCRYPTION_KEY,OPEN_NOTEBOOK_PASSWORD,SURREAL_URL,SURREAL_USER,SURREAL_PASSWORD,SURREAL_NAMESPACE,SURREAL_DATABASE,CORS_ORIGINS&OPEN_NOTEBOOK_ENCRYPTION_KEYDesc=Secret+key+to+encrypt+stored+API+keys+(openssl+rand+-hex+32)&OPEN_NOTEBOOK_PASSWORDDesc=Password+to+access+the+UI+and+API&SURREAL_URLDefault=ws%3A%2F%2Flocalhost%3A8000%2Frpc&SURREAL_USERDefault=root&SURREAL_PASSWORDDefault=root&SURREAL_NAMESPACEDefault=open_notebook&SURREAL_DATABASEDefault=open_notebook)

**Required env vars before deploying:**

| Variable | Description | Generate |
|----------|-------------|---------|
| `OPEN_NOTEBOOK_ENCRYPTION_KEY` | Encrypts stored API keys | `openssl rand -hex 32` |
| `OPEN_NOTEBOOK_PASSWORD` | UI + API access password | Any strong passphrase |

After deploy, **add persistent volumes** (see below), then open your Railway public URL → **Settings → API Keys** to add your AI provider.

---

## Persistent Storage (Railway)

By default Railway containers are ephemeral — data is lost on redeploy. Fix this by attaching two volumes to your service:

### Step-by-step

1. In your Railway project, click the **open-notebook service**
2. Go to **Settings → Volumes → Add Volume**
3. Add volume 1:
   - **Mount path:** `/data`
   - (this is where SurrealDB stores your database)
4. Add volume 2:
   - **Mount path:** `/app/data`
   - (this is where uploaded PDFs, audio, and other files are stored)
5. Railway will redeploy — your data now survives restarts and redeploys

**Cost:** ~$0.25/GB/month. A typical personal notebook database stays well under 1GB.

> Do this **before** adding documents. If you add documents first and then attach volumes, the existing data inside the container will not be migrated automatically.

---

## Security

### Password Protection

Open Notebook uses bearer-token password protection on both the UI and REST API.

Set `OPEN_NOTEBOOK_PASSWORD` in your env. The default (`open-notebook-change-me`) is **development only** — always set your own for any public deployment.

### 2FA via Cloudflare Access (recommended for Railway)

Open Notebook has no native 2FA. Add it for free with [Cloudflare Access](https://www.cloudflare.com/products/zero-trust/access/):

1. Add your Railway domain to Cloudflare (or use a custom domain proxied through CF)
2. In [Cloudflare Zero Trust](https://one.dash.cloudflare.com/) → **Access → Applications → Add an application**
3. Choose **Self-hosted**, enter your Railway URL
4. Set **Identity providers** → Google, GitHub, or any TOTP-based provider
5. Enable **2FA enforcement** in the policy
6. Anyone hitting your URL must now authenticate via Cloudflare before reaching the app

This gives you SSO + 2FA without changing any app code, and it's free on Cloudflare's free tier.

---

## AI Providers

### Natively supported

| Provider | LLM | Embeddings | Notes |
|----------|-----|------------|-------|
| OpenAI | ✅ | ✅ | |
| Anthropic | ✅ | — | |
| Google (Gemini) | ✅ | ✅ | |
| Groq | ✅ | — | Fast & cheap |
| OpenRouter | ✅ | ✅ | 100+ models |
| Ollama | ✅ | ✅ | Local/private |
| Azure OpenAI | ✅ | ✅ | Enterprise |
| DashScope (Qwen) | ✅ | — | |

### OpenAI-compatible (any endpoint)

Any service that speaks the OpenAI API works via **Settings → API Keys → Add Credential → OpenAI-Compatible**. Tested providers:

| Provider | Base URL |
|----------|----------|
| [OpenRouter](https://openrouter.ai) | `https://openrouter.ai/api/v1` |
| [Requesty](https://requesty.ai) | `https://router.requesty.ai/v1` |
| [APIPie](https://apipie.ai) | `https://apipie.ai/v1` |
| [NanoGPT](https://nano-gpt.com) | `https://nano-gpt.com/api/v1` |
| [OpenCode](https://opencode.ai) | check their docs for base URL |
| LM Studio | `http://localhost:1234/v1` |
| vLLM | `http://localhost:8000/v1` |
| Text Generation UI | `http://localhost:5000/v1` |

Set the **Base URL** and **API key** for the provider. If it returns OpenAI-format responses, it will work.

---

## Run locally

```bash
cp .env.example .env
# Edit .env — set OPEN_NOTEBOOK_ENCRYPTION_KEY and OPEN_NOTEBOOK_PASSWORD
docker compose up -d
```

Open: http://localhost:8502

## Manage (local CLI)

```bash
onote           # start + open browser
onote stop      # stop
onote restart   # restart
onote status    # container status
onote logs      # tail logs
```

## Ports

| Port | Service |
|------|---------|
| 8502 | Web UI |
| 5055 | REST API |
| 8000 | SurrealDB (localhost only) |
