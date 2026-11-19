# Praxis static CDN

Mirrors the role of `static.pangolin.net` using **GitHub** (Pages + Releases) and **Cloudflare** (R2 / Pages).

## Layout

| Path | Purpose |
| --- | --- |
| `get-cli.sh` | Installer script shown in the dashboard |
| `index.html` | Landing page for the static origin |
| `packages/` | Optional npm tarball mirrors (e.g. Devolutions) |

## GitHub (primary, works first)

1. In the repo: **Settings → Pages → Build and deployment → GitHub Actions**.
2. Push to `main` (workflow `.github/workflows/deploy-static.yml`).
3. Public URL: `https://tufaylahmed.github.io/praxis/get-cli.sh`

Set in `config/config.yml`:

```yaml
app:
  static_base_url: "https://tufaylahmed.github.io/praxis"
```

## Cloudflare (custom domain + edge CDN)

### Option A — Cloudflare Pages (recommended)

1. Authenticate Cloudflare in Cursor desktop (Cloudflare MCP) or install Wrangler: `npm i -g wrangler && wrangler login`.
2. Create a Pages project from this folder:

```bash
cd static
npx wrangler pages project create praxis-static
npx wrangler pages deploy . --project-name=praxis-static
```

3. In Cloudflare dashboard: Pages → `praxis-static` → Custom domains → add `static.yourdomain.com` (DNS can stay at Namecheap with a CNAME to Cloudflare).
4. Update config:

```yaml
app:
  static_base_url: "https://static.yourdomain.com"
```

### Option B — R2 bucket + public access

```bash
npx wrangler r2 bucket create praxis-static
npx wrangler r2 object put praxis-static/get-cli.sh --file=./get-cli.sh --content-type=text/x-sh
```

Attach a custom domain to the bucket in the Cloudflare dashboard, then point `static_base_url` at it.

### CI sync (optional)

Add repo secrets `CLOUDFLARE_API_TOKEN` and `CLOUDFLARE_ACCOUNT_ID`. The deploy workflow will push to Pages when those secrets exist.

## Binaries

`get-cli.sh` downloads from **GitHub Releases**, not from the CDN. Default repo: `fosrl/cli`. Override later:

```bash
PRAXIS_CLI_REPO=YourOrg/praxis-cli curl -fsSL …/get-cli.sh | sh
```

## npm packages

To stop `npm install` hitting `static.pangolin.net/packages/…`, download the tarballs into `static/packages/`, point `package.json` at your `static_base_url`, and keep them in sync on Releases or R2.
