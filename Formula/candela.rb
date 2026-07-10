# typed: false
# frozen_string_literal: true

class Candela < Formula
  desc "LLM observability proxy — traces, costs, budgets for AI dev tools"
  homepage "https://github.com/candelahq/candela"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/candelahq/candela/releases/download/v0.10.4/candela_0.10.4_Darwin_universal.tar.gz"
      sha256 "7624628145cfb1219ef41d94fd9c2b965e2bb7ad8be1c6e581a5e390cdd2b6fb"
    end
    on_intel do
      url "https://github.com/candelahq/candela/releases/download/v0.10.4/candela_0.10.4_Darwin_universal.tar.gz"
      sha256 "7624628145cfb1219ef41d94fd9c2b965e2bb7ad8be1c6e581a5e390cdd2b6fb"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/candelahq/candela/releases/download/v0.10.4/candela_0.10.4_Linux_amd64.tar.gz"
      sha256 "2bf0619701b1cdb13f9f4210f08cedca11da250a4aaa6f347bc6436cc86e9169"
    end
    on_arm do
      url "https://github.com/candelahq/candela/releases/download/v0.10.4/candela_0.10.4_Linux_arm64.tar.gz"
      sha256 "452014e97e75553d111943a6d41bd527293750bbadf728ec44ed5c092d175521"
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
