# typed: false
# frozen_string_literal: true

class Candela < Formula
  desc "LLM observability proxy — traces, costs, budgets for AI dev tools"
  homepage "https://github.com/candelahq/candela"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/candelahq/candela/releases/download/v0.9.2/candela_0.9.2_Darwin_universal.tar.gz"
      sha256 "fedef578b3183a603a63e2c6b879c2f7706966da64064845ba4859a89dce2319"
    end
    on_intel do
      url "https://github.com/candelahq/candela/releases/download/v0.9.2/candela_0.9.2_Darwin_universal.tar.gz"
      sha256 "fedef578b3183a603a63e2c6b879c2f7706966da64064845ba4859a89dce2319"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/candelahq/candela/releases/download/v0.9.2/candela_0.9.2_Linux_amd64.tar.gz"
      sha256 "328c176cabe561288072aa0125de8df5dacbf7402ce7a774a8613480fcf4bf7d"
    end
    on_arm do
      url "https://github.com/candelahq/candela/releases/download/v0.9.2/candela_0.9.2_Linux_arm64.tar.gz"
      sha256 "bc6e9aedbb67d1d025ed6e77a55865414a148459cbcfb63110007d24bcef32ba"
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
