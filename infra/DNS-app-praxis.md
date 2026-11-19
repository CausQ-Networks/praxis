# app.praxis.causq.com DNS

Wrangler OAuth can attach Worker routes but cannot create zone DNS records.

Add this in Cloudflare Dashboard → causq.com → DNS:

| Type  | Name       | Content                                      | Proxy |
|-------|------------|----------------------------------------------|-------|
| CNAME | app.praxis | praxis-app-proxy.tufaylahmed.workers.dev     | Proxied |

Until then, cloud landing is served at https://praxis.causq.com/ (Worker rewrite to `/app/`).
CLI defaults to `https://praxis.causq.com`.
