# Homebrew Cask for Candela Desktop
# Auto-updated by the release workflow via the update-cask job.
#
# Manual install:
#   brew install --cask candelahq/tap/candela-desktop
#
# This file lives in candelahq/homebrew-tap → Casks/candela-desktop.rb

cask "candela-desktop" do
  version "0.5.0"
  sha256 "2d5d012ee5cdb8065a45683aed1393a24fcfff7f0d6bf470c53d99fa79bad6cf"

  url "https://github.com/candelahq/candela-desktop/releases/download/v#{version}/Candela-macos-arm64.dmg"
  name "Candela"
  desc "LLM observability for your machine — traces, costs, and budgets for AI dev tools"
  homepage "https://github.com/candelahq/candela-desktop"

  # Only Apple Silicon for now (release matrix only builds arm64).
  # Intel Macs can run via Rosetta 2.
  depends_on arch: :arm64

  # Once the `candela` CLI formula is published (via GoReleaser),
  # users can install it separately: brew install candelahq/tap/candela

  app "Candela.app"

  # Ad-hoc signed (no Apple Developer ID yet) — strip quarantine and
  # provenance so Gatekeeper doesn't block Finder launches.
  # macOS Sequoia protects com.apple.provenance; sudo is required.
  # Remove this block once proper Developer ID signing is in place.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-cr", "#{appdir}/Candela.app"],
                   sudo: true
  end

  zap trash: [
    "~/.candela",
    "~/.config/candela",
    "~/Library/Application Support/com.candelahq.candela",
    "~/Library/Caches/com.candelahq.candela",
    "~/Library/Preferences/com.candelahq.candela.plist",
  ]
end
