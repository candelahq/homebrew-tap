# typed: false
# frozen_string_literal: true

class Candela < Formula
  desc "LLM observability proxy — traces, costs, budgets for AI dev tools"
  homepage "https://github.com/candelahq/candela"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/candelahq/candela/releases/download/v0.10.2/candela_0.10.2_Darwin_universal.tar.gz"
      sha256 "ab663bd42cf2dd20213d51dd98b5b0494dd81de19123b026718913672a148888"
    end
    on_intel do
      url "https://github.com/candelahq/candela/releases/download/v0.10.2/candela_0.10.2_Darwin_universal.tar.gz"
      sha256 "ab663bd42cf2dd20213d51dd98b5b0494dd81de19123b026718913672a148888"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/candelahq/candela/releases/download/v0.10.2/candela_0.10.2_Linux_amd64.tar.gz"
      sha256 "e04e0d5ddb39a657a404a281cac77f701da30c661b9ae5b73546cf948191a195"
    end
    on_arm do
      url "https://github.com/candelahq/candela/releases/download/v0.10.2/candela_0.10.2_Linux_arm64.tar.gz"
      sha256 "7df592469524f25f59f5d7f1e8439b833a7bcc3f28ea5fc548765843ea5fca99"
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
