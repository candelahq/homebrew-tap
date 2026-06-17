# typed: false
# frozen_string_literal: true

class Candela < Formula
  desc "LLM observability proxy — traces, costs, budgets for AI dev tools"
  homepage "https://github.com/candelahq/candela"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/candelahq/candela/releases/download/v0.8.0/candela_0.8.0_Darwin_universal.tar.gz"
      sha256 "50d205a5e41fdd46ef83c17d5c43a1fe218382753031f03e8a5a586cffb46c2d"
    end
    on_intel do
      url "https://github.com/candelahq/candela/releases/download/v0.8.0/candela_0.8.0_Darwin_universal.tar.gz"
      sha256 "50d205a5e41fdd46ef83c17d5c43a1fe218382753031f03e8a5a586cffb46c2d"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/candelahq/candela/releases/download/v0.8.0/candela_0.8.0_Linux_amd64.tar.gz"
      sha256 "f24c2426e03bd80f35402c74ff00efc59ebee0676ccd93b0ff96bfe8c904d881"
    end
    on_arm do
      url "https://github.com/candelahq/candela/releases/download/v0.8.0/candela_0.8.0_Linux_arm64.tar.gz"
      sha256 "21600491f9d9d84731608534e7790b2dbcaa1cfbb4a7ba3f2764fcb0fd16bba0"
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
