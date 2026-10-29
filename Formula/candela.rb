# typed: false
# frozen_string_literal: true

class Candela < Formula
  desc "LLM observability proxy — traces, costs, budgets for AI dev tools"
  homepage "https://github.com/candelahq/candela"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/candelahq/candela/releases/download/v0.11.8/candela_0.11.8_Darwin_universal.tar.gz"
      sha256 "2fe3b81a00e1018e524a28e0ad1e597f745cf6fb90d0899931a78d4b1eb20215"
    end
    on_intel do
      url "https://github.com/candelahq/candela/releases/download/v0.11.8/candela_0.11.8_Darwin_universal.tar.gz"
      sha256 "2fe3b81a00e1018e524a28e0ad1e597f745cf6fb90d0899931a78d4b1eb20215"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/candelahq/candela/releases/download/v0.11.8/candela_0.11.8_Linux_amd64.tar.gz"
      sha256 "8e4756f3e01e5da3180b8f06e4d4d42c4810668d93438140c11520378abad29f"
    end
    on_arm do
      url "https://github.com/candelahq/candela/releases/download/v0.11.8/candela_0.11.8_Linux_arm64.tar.gz"
      sha256 "1909141bda77efee3c6757ba7a6601d7b3e09552df4cfea5fa067e1c8392c983"
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
