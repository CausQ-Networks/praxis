# Praxis static CDN

Public origin: **https://praxis.causq.com**

Mirrors the role of `static.pangolin.net` using **Cloudflare** (Pages + Worker route) and **GitHub Pages** as backup.

## Layout

| Path | Purpose |
| --- | --- |
| `get-cli.sh` | Installer script shown in the dashboard |
| `index.html` | Landing page for the static origin |
| `packages/` | Optional npm tarball mirrors (e.g. Devolutions) |

## Origins

| Origin | URL | Role |
| --- | --- | --- |
| Custom domain | `https://praxis.causq.com` | Primary (Worker → Pages) |
| Cloudflare Pages | `https://praxis-static.pages.dev` | Upstream content |
| GitHub Pages | `https://causq-networks.github.io/praxis` | Backup |

Set in `config/config.yml`:

```yaml
app:
  static_base_url: "https://praxis.causq.com"
```

## Domain wiring

1. Pages project `praxis-static` holds the files (`npx wrangler pages deploy static --project-name=praxis-static`).
2. Worker `infra/praxis-domain-proxy` routes `praxis.causq.com/*` to that Pages project (active now).
3. Optional hardening: in Cloudflare DNS for `causq.com`, set CNAME `praxis` → `praxis-static.pages.dev` (proxied). That lets the Pages custom domain finish SSL without the Worker. Needs a Zone DNS Edit API token (Wrangler OAuth cannot write DNS).

## CI

Push to `static/` on `main` runs `.github/workflows/deploy-static.yml` (GitHub Pages + Cloudflare Pages when secrets are set).

## Binaries

`get-cli.sh` downloads from **GitHub Releases** on `CausQ-Networks/praxis-cli` (not from the CDN). Override if needed:

```bash
PRAXIS_CLI_REPO=CausQ-Networks/praxis-cli PRAXIS_CLI_VERSION=0.21.0 curl -fsSL https://praxis.causq.com/get-cli.sh | sh
```

## npm packages

To stop `npm install` hitting `static.pangolin.net/packages/…`, download the tarballs into `static/packages/`, point `package.json` at your `static_base_url`, and keep them in sync on Releases or R2.
