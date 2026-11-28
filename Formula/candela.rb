# typed: false
# frozen_string_literal: true

class Candela < Formula
  desc "LLM observability proxy — traces, costs, budgets for AI dev tools"
  homepage "https://github.com/candelahq/candela"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/candelahq/candela/releases/download/v0.12.3/candela_0.12.3_Darwin_universal.tar.gz"
      sha256 "3b6e6ae685eb73ced8869425b67d75bd8f2d183561a174e8aef6ec22237d7b30"
    end
    on_intel do
      url "https://github.com/candelahq/candela/releases/download/v0.12.3/candela_0.12.3_Darwin_universal.tar.gz"
      sha256 "3b6e6ae685eb73ced8869425b67d75bd8f2d183561a174e8aef6ec22237d7b30"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/candelahq/candela/releases/download/v0.12.3/candela_0.12.3_Linux_amd64.tar.gz"
      sha256 "905f2a20d5c42ad76bf230746123e3b33d21add4b3032ed33021c0657fc5f3d5"
    end
    on_arm do
      url "https://github.com/candelahq/candela/releases/download/v0.12.3/candela_0.12.3_Linux_arm64.tar.gz"
      sha256 "182ed9eef0c92efc31b9a6a0599fd5b28f84f9c55340dd8920c7c15ca2b0e02a"
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
