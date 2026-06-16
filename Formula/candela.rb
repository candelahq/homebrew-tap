# typed: false
# frozen_string_literal: true

class Candela < Formula
  desc "LLM observability proxy — traces, costs, budgets for AI dev tools"
  homepage "https://github.com/candelahq/candela"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/candelahq/candela/releases/download/v0.7.1/candela_0.7.1_Darwin_universal.tar.gz"
      sha256 "9d3780534e2d28d05acb297e84d6c6c583d496131b73050637906616e3af9f7f"
    end
    on_intel do
      url "https://github.com/candelahq/candela/releases/download/v0.7.1/candela_0.7.1_Darwin_universal.tar.gz"
      sha256 "9d3780534e2d28d05acb297e84d6c6c583d496131b73050637906616e3af9f7f"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/candelahq/candela/releases/download/v0.7.1/candela_0.7.1_Linux_amd64.tar.gz"
      sha256 "b3980034fef9f8a789a599e9995a4de17115d06f20e018920378555a09839d52"
    end
    on_arm do
      url "https://github.com/candelahq/candela/releases/download/v0.7.1/candela_0.7.1_Linux_arm64.tar.gz"
      sha256 "d2b0e48a7c3b3054ff4b8617da1403e49dfbf9fd4bdd187d5ae5313c7c1be6af"
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
