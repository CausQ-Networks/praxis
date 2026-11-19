# praxis.causq.com → static CDN

Cloudflare Worker that serves `https://praxis.causq.com` from the `praxis-static` Pages project.

The Pages custom domain still wants a CNAME (`praxis` → `praxis-static.pages.dev`). Wrangler OAuth cannot edit zone DNS, so this Worker route is the active path until that CNAME is set.

```bash
npx wrangler@4 deploy --config infra/praxis-domain-proxy/wrangler.toml
```
