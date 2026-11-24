# typed: false
# frozen_string_literal: true

class Candela < Formula
  desc "LLM observability proxy — traces, costs, budgets for AI dev tools"
  homepage "https://github.com/candelahq/candela"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/candelahq/candela/releases/download/v0.12.0/candela_0.12.0_Darwin_universal.tar.gz"
      sha256 "3642b5417a52136f6ffc7e9c776842d3be5b4f9f3cf528645330f685e8136d52"
    end
    on_intel do
      url "https://github.com/candelahq/candela/releases/download/v0.12.0/candela_0.12.0_Darwin_universal.tar.gz"
      sha256 "3642b5417a52136f6ffc7e9c776842d3be5b4f9f3cf528645330f685e8136d52"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/candelahq/candela/releases/download/v0.12.0/candela_0.12.0_Linux_amd64.tar.gz"
      sha256 "5477203e26c8adf8197668a0af5388ce4f844f57fbca6cd0dbeaa7b714327f00"
    end
    on_arm do
      url "https://github.com/candelahq/candela/releases/download/v0.12.0/candela_0.12.0_Linux_arm64.tar.gz"
      sha256 "7bbcc18fcf79d05dadfc2773935008dd123f606c51e61f1182a4a5b8393fbd21"
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
