# 🕯️ Candela Homebrew Tap

Official Homebrew formulae and casks for [Candela](https://github.com/candelahq/candela) — the OTel-native LLM observability platform.

> Trace every LLM call. Track every cent. Set budgets. All on your machine.

## Quick Start

```bash
# CLI — candela start, candela stop, candela status
brew install candelahq/tap/candela

# Desktop app (optional) — native macOS GUI with system tray
brew install --cask candelahq/tap/candela-desktop
```

## What's Available

| Name | Type | Description |
|------|------|-------------|
| `candela` | Formula | CLI proxy — `candela start/stop/status/run` |
| `candela-desktop` | Cask | Desktop app — native macOS GUI with tray, traces, budgets |

## Usage

```bash
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
- 📚 [Documentation](https://github.com/candelahq/candela/tree/main/docs)
- 🐛 [Report an issue](https://github.com/candelahq/candela/issues)

## License

Apache-2.0 — see [LICENSE](LICENSE).
