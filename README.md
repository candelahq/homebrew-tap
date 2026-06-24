# 🕯️ Candela Homebrew Tap

Official Homebrew formulae and casks for [Candela](https://github.com/candelahq/candela) — the OTel-native LLM observability platform.

> Trace every LLM call. Track every cent. Set budgets. Enforce with eBPF. All on your machine.

## Quick Start

```bash
# CLI — candela start, candela stop, candela status
brew install candelahq/tap/candela

# Desktop app (optional) — native macOS GUI with system tray
brew install --cask candelahq/tap/candela-desktop
```

## What's Available

| Name | Type | Version | Description |
|------|------|---------|-------------|
| `candela` | Formula | 0.8.1 | CLI proxy — `candela start/stop/status/run` + multi-cloud auth |
| `candela-desktop` | Cask | 0.7.1 | Desktop app — native macOS GUI with tray, traces, budgets |

## What's New (v0.5.7 → v0.7.1)

- **💰 Pricing Engine Overhaul**: Model costs are now driven by an external `pricing.yaml`; hot-reload without restarting the proxy.
- **🤖 Model Allowlist & Policy Gate**: Restrict which models users can call via config-driven allowlists and deny rules.
- **💳 Billing Interface Extraction**: Billing logic is decoupled into its own service interface, ready for custom backends.
- **🌐 Budget Timezone Support**: Per-budget timezone field — daily/monthly resets honour the configured timezone instead of UTC.
- **🔒 Security Hardening (v0.7.1)**: TLS cert rotation, stricter CSP headers, and hardened cookie flags for the admin UI.
- **🔧 New Env Vars**: `CANDELA_VERTEX_REGION`, `CANDELA_BILLING_BACKEND`, `CANDELA_PRICING_PATH` for finer-grained runtime control.
- **🖥️ Add Model UI**: Admin dashboard now exposes an "Add Model" form for registering custom or fine-tuned models.
- **👥 Users Pagination & Status Filter**: User list in the admin UI supports server-side pagination and active/suspended status filtering.

## Usage

```bash
# Authenticate (no gcloud/aws CLI required)
candela auth login                 # GCP OAuth2 (default)
candela auth login --provider aws  # AWS SSO

# Proxy management
candela start          # Start proxy in background
candela stop           # Graceful shutdown
candela status         # Check running state
candela run            # Run in foreground (debug)
```

Or as a login service:

```bash
brew services start candela
```

## Requirements

- **macOS 13+** (Ventura or later recommended)
- **Apple Silicon** (M1/M2/M3/M4) — Intel Macs run via Rosetta 2
- [Homebrew](https://brew.sh) 4.0+

## Upgrade

```bash
brew upgrade candela
brew upgrade --cask candela-desktop
```

## Uninstall

```bash
brew uninstall candela
brew uninstall --cask candela-desktop
brew untap candelahq/tap
```

## Troubleshooting

### Git asks for a password during install

This tap is **public** — no GitHub account or credentials are required. If `brew install` prompts for a password like:

```
Password for 'https://username@github.com':
```

Your git credential helper has a stale or expired token cached for `github.com`. Fix it with any of these:

```bash
# Option 1: Skip the prompt (works since the tap is public)
GIT_TERMINAL_PROMPT=0 brew install candelahq/tap/candela

# Option 2: Clear the cached credential
git credential reject <<EOF
protocol=https
host=github.com
EOF

# Option 3: Re-authenticate with GitHub CLI
gh auth login
gh auth setup-git
```

### "Candela.app is damaged and can't be opened"

The desktop app is ad-hoc signed (not yet Apple-notarized). macOS quarantine may block it on first launch:

```bash
xattr -cr /Applications/Candela.app
```

The cask's `postflight` hook runs this automatically, but manual downloads or re-installs may need it again.

### Intel Mac

The desktop cask is built for Apple Silicon. On Intel Macs it runs under Rosetta 2 — no extra steps needed.

### Formula vs Cask?

- **Formula** (`candela`) — the CLI binary (headless proxy, works on macOS + Linux)
- **Cask** (`candela-desktop`) — the Desktop GUI app (`.dmg` → `/Applications`)

## How Updates Work

- **Desktop cask** — auto-bumped by the [candela-desktop](https://github.com/candelahq/candela-desktop) release workflow via `repository_dispatch`.
- **CLI formula** — auto-bumped by [GoReleaser](https://goreleaser.com/) on each [candela](https://github.com/candelahq/candela) release tag.

## Links

- 🕯️ [Candela](https://github.com/candelahq/candela) — main monorepo
- 🖥️ [Candela Desktop](https://github.com/candelahq/candela-desktop) — Flutter desktop app
- 📚 [Documentation](https://candelahq.com)
- 🐛 [Report an issue](https://github.com/candelahq/candela/issues)

## License

Apache-2.0 — see [LICENSE](LICENSE).
