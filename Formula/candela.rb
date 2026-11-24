# typed: false
# frozen_string_literal: true

class Candela < Formula
  desc "LLM observability proxy — traces, costs, budgets for AI dev tools"
  homepage "https://github.com/candelahq/candela"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/candelahq/candela/releases/download/v0.12.1/candela_0.12.1_Darwin_universal.tar.gz"
      sha256 "0f978ca4fce15c9938f93b01a6881a348abf1bdce42ce9b2cf8ab530f709bdfc"
    end
    on_intel do
      url "https://github.com/candelahq/candela/releases/download/v0.12.1/candela_0.12.1_Darwin_universal.tar.gz"
      sha256 "0f978ca4fce15c9938f93b01a6881a348abf1bdce42ce9b2cf8ab530f709bdfc"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/candelahq/candela/releases/download/v0.12.1/candela_0.12.1_Linux_amd64.tar.gz"
      sha256 "0f847ea29bd94c988777674fd9f7f7aafe12133ae463ba7162db83614e0ee1f6"
    end
    on_arm do
      url "https://github.com/candelahq/candela/releases/download/v0.12.1/candela_0.12.1_Linux_arm64.tar.gz"
      sha256 "9cac6d57cc83f8f8916cb33252740950960aa25a35ce26e7eabf5b893433cc65"
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
