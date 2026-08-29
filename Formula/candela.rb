# typed: false
# frozen_string_literal: true

class Candela < Formula
  desc "LLM observability proxy — traces, costs, budgets for AI dev tools"
  homepage "https://github.com/candelahq/candela"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/candelahq/candela/releases/download/v0.11.2/candela_0.11.2_Darwin_universal.tar.gz"
      sha256 "c972419a6bc3e14ca0bd6a1c8e06350ac59db8bfa2b5794a037ae2665e392f37"
    end
    on_intel do
      url "https://github.com/candelahq/candela/releases/download/v0.11.2/candela_0.11.2_Darwin_universal.tar.gz"
      sha256 "c972419a6bc3e14ca0bd6a1c8e06350ac59db8bfa2b5794a037ae2665e392f37"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/candelahq/candela/releases/download/v0.11.2/candela_0.11.2_Linux_amd64.tar.gz"
      sha256 "313714b217d05dabcce0bf776546c258a644a0109aa9e5f353b4aca70416fa06"
    end
    on_arm do
      url "https://github.com/candelahq/candela/releases/download/v0.11.2/candela_0.11.2_Linux_arm64.tar.gz"
      sha256 "69e37f1071cd3f86014f5f4e2fd443a32f1bdb858cc246d30734ff307b49d11e"
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
