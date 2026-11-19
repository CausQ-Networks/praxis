# Praxis community

## Discord

| | |
| --- | --- |
| Server (guild) ID | `1572896060949659679` |
| Primary channel | [#general / configured channel](https://discord.com/channels/1572896060949659679/1572896062153293885) |
| Public invite | Set a **never-expire** invite, then put it in `discord.json` → `inviteUrl` and CDN `/discord` |

### One-time Discord server setup (Community Server)

1. **Server Settings → Enable Community** (required for never-expire invites and rules screening).
2. Create channels (match `discord.json` → `recommendedChannels`):
   - `#announcements` — release notes / status (mods + bots only post)
   - `#general` — chat
   - `#support` — help (use a support forum or tickets if volume grows)
   - `#self-hosting` — install / Traefik / Docker / Helm
   - `#showcase` — screenshots and use cases
   - `#development` — contributors / PRs
   - `#releases` — webhook feed from GitHub
3. **Roles:** `@everyone` (read), `Member`, `Contributor`, `Moderator`, `Admin`.
4. **Rules screening** + welcome screen pointing at `#announcements` and `#support`.
5. **Server Widget** on (Server Settings → Widget) so shields.io member counts work.
6. **Invite:** channel → Invite People → Edit invite link → Expire **Never**, Max uses **No limit** → copy `https://discord.gg/…`.
7. Paste that invite into:
   - `community/discord.json` (`inviteUrl`)
   - `static/discord/index.html` (meta refresh)
   - optional repo secret / env `DISCORD_INVITE_URL`
8. **Integrations → Webhooks → New Webhook** on `#releases`, copy URL into GitHub secret `DISCORD_WEBHOOK` on `CausQ-Networks/praxis` (and other release repos).

### GitHub → Discord

Workflow: `.github/workflows/discord-notify.yml` posts release / star events when `DISCORD_WEBHOOK` is set.
