# typed: false
# frozen_string_literal: true

class Candela < Formula
  desc "LLM observability proxy — traces, costs, budgets for AI dev tools"
  homepage "https://github.com/candelahq/candela"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/candelahq/candela/releases/download/v0.10.0/candela_0.10.0_Darwin_universal.tar.gz"
      sha256 "787bd748f83ff67b59ad5c790caebb89ff788a1f5ddf91a328bb0330182e141a"
    end
    on_intel do
      url "https://github.com/candelahq/candela/releases/download/v0.10.0/candela_0.10.0_Darwin_universal.tar.gz"
      sha256 "787bd748f83ff67b59ad5c790caebb89ff788a1f5ddf91a328bb0330182e141a"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/candelahq/candela/releases/download/v0.10.0/candela_0.10.0_Linux_amd64.tar.gz"
      sha256 "a3559792f26f72f6f29b8417ac4f35b53b663c9625726412131301dd9957a75f"
    end
    on_arm do
      url "https://github.com/candelahq/candela/releases/download/v0.10.0/candela_0.10.0_Linux_arm64.tar.gz"
      sha256 "bd4fb3ca7bd37ce9d0cd442c7f4b7e16be80231cefbde8a8e0a0892bf6a25e70"
    end
  end

  def install
    bin.install "candela"
  end

  def caveats
    <<~EOS
      To get started, create a config file:

        mkdir -p ~/.config/candela
        cat > ~/.config/candela/config.yaml <<EOF
        port: 8181
        providers:
- name: google
  models: ["gemini-2.5-pro", "gemini-2.5-flash", "gemini-3.5-flash"]
- name: anthropic
  models: ["claude-sonnet-4-20250514"]
        vertex_ai:
project: YOUR_GCP_PROJECT
region: us-central1
        EOF

      Authenticate (no gcloud required):
        candela auth login             # GCP OAuth2 (default)
        candela auth login --provider aws  # AWS SSO/access keys

      Then run:
        candela start          # background daemon
        candela status         # check running state
        candela run            # foreground (debug)

      Management UI: http://127.0.0.1:8181/_local/

      Or as a login service:
        brew services start candela
    EOS
  end

  service do
    run [opt_bin/"candela", "run"]
    keep_alive true
    log_path var/"log/candela.log"
    error_log_path var/"log/candela.log"
  end

  test do
    system "#{bin}/candela", "version"
  end
end
