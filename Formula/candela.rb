# typed: false
# frozen_string_literal: true

class Candela < Formula
  desc "LLM observability proxy — traces, costs, budgets for AI dev tools"
  homepage "https://github.com/candelahq/candela"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/candelahq/candela/releases/download/v0.10.7/candela_0.10.7_Darwin_universal.tar.gz"
      sha256 "baab762b90daf5cc3b18f1b3e93026845c8a7c259307f3a20ffce4e4092a8915"
    end
    on_intel do
      url "https://github.com/candelahq/candela/releases/download/v0.10.7/candela_0.10.7_Darwin_universal.tar.gz"
      sha256 "baab762b90daf5cc3b18f1b3e93026845c8a7c259307f3a20ffce4e4092a8915"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/candelahq/candela/releases/download/v0.10.7/candela_0.10.7_Linux_amd64.tar.gz"
      sha256 "66bbf49ddfc391c3a374ecb5b539722041f6b33900ee19b638af88181e4b2dd7"
    end
    on_arm do
      url "https://github.com/candelahq/candela/releases/download/v0.10.7/candela_0.10.7_Linux_arm64.tar.gz"
      sha256 "85203f2c958a0aa20e1e29d9961c314ff0020e3dafbf4fd857abb3561d10d279"
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
