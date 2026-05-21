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
| `candela` | Formula | 0.5.1 | CLI proxy — `candela start/stop/status/run` + multi-cloud auth |
| `candela-desktop` | Cask | 0.5.0 | Desktop app — native macOS GUI with tray, traces, budgets |

## What's New in v0.4.7+

- **🔑 Multi-Cloud Auth**: `candela auth login --provider gcp|aws` — native OAuth2 for GCP, SSO/access keys for AWS. No `gcloud` or `aws` CLI dependency.
- **🛡️ eBPF Enforcement**: Kernel-level security ensures all LLM API calls are captured — Tetragon process enforcement + iptables transparent proxy.
- **📊 Phase A Observability Hardening**: Circuit breaker, fuzz tests, runtime coverage.
- **🤖 Expanded Models**: Gemini 3.5 Flash, Opus 4.7, Sonnet 4.6, Haiku 4.5, Gemini 3.0 Pro.
- **🔧 Tetragon gRPC Audit**: MultiSink pipeline with graceful shutdown and hardened error handling.
- **🖥️ Desktop v0.5.0**: Riverpod 3.x `DashboardController` migration, native ADC auth (no gcloud dependency), model pricing UI, and user-scoped admin dashboard.

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
