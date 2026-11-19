# Praxis custom hostnames (Cloudflare DNS)

## Working now (Universal SSL `*.causq.com`)

| Type  | Name         | Content                                      | Notes |
|-------|--------------|----------------------------------------------|-------|
| CNAME | app-praxis   | praxis-app-proxy.tufaylahmed.workers.dev     | Use this for cloud |
| CNAME | docs-praxis  | praxis-docs-proxy.tufaylahmed.workers.dev    | Use this for docs |

- Cloud: https://app-praxis.causq.com/
- Docs: https://docs-praxis.causq.com/
- CDN: https://praxis.causq.com/

## Nested names (need Advanced Certificate Manager)

`app-praxis.causq.com` and `docs-praxis.causq.com` CNAMEs exist, but free
Universal SSL only covers `*.causq.com` (one label). Nested hosts need ACM
for `*.praxis.causq.com` before HTTPS works.
