# 🕯️ Candela Homebrew Tap

Official Homebrew formulae and casks for [Candela](https://github.com/candelahq/candela) — the OTel-native LLM observability platform.

> Trace every LLM call. Track every cent. Set budgets. All on your machine.

## Quick Start

```bash
# Desktop app (macOS, system tray + traces + budgets)
brew install --cask candelahq/tap/candela

# CLI proxy (macOS / Linux, headless)
brew install candelahq/tap/candela-local
```

## What's Available

| Name | Type | Description |
|------|------|-------------|
| `candela` | Cask | Candela Desktop — native macOS app with system tray, traces, costs, and budgets |
| `candela-local` | Formula | Developer proxy — unified model routing, local observability, runtime management |

## Requirements

- **macOS 13+** (Ventura or later recommended)
- **Apple Silicon** (M1/M2/M3/M4) — Intel Macs run via Rosetta 2
- [Homebrew](https://brew.sh) 4.0+

## Upgrade

```bash
brew upgrade --cask candela
brew upgrade candela-local
```

## Uninstall

```bash
brew uninstall --cask candela
brew uninstall candela-local
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

- **Cask** (`candela`) — the Desktop GUI app (`.dmg` → `/Applications`)
- **Formula** (`candela-local`) — the CLI binary (headless proxy, works on macOS + Linux)

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
