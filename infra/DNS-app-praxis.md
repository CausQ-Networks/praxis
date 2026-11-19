# Praxis custom hostnames (Cloudflare DNS)

Wrangler OAuth can attach Worker routes but cannot create zone DNS records
(`zone` scope is read-only). Add these CNAMEs in Cloudflare Dashboard →
`causq.com` → DNS (Proxied):

| Type  | Name        | Content                                         |
|-------|-------------|-------------------------------------------------|
| CNAME | app.praxis  | praxis-app-proxy.tufaylahmed.workers.dev        |
| CNAME | docs.praxis | praxis-docs-proxy.tufaylahmed.workers.dev       |

Until DNS exists:

- Cloud landing: https://praxis.causq.com/
- Docs landing: https://praxis.causq.com/docs/
- CLI installer: https://praxis.causq.com/get-cli.sh
- Downloads: https://praxis.causq.com/downloads/
- Workers.dev fallbacks work for app/docs proxies

Or create an API token with `Zone.DNS Edit` for `causq.com` and export
`CLOUDFLARE_API_TOKEN` so these records can be created automatically.
