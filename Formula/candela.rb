# typed: false
# frozen_string_literal: true

class Candela < Formula
  desc "LLM observability proxy — traces, costs, budgets for AI dev tools"
  homepage "https://github.com/candelahq/candela"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/candelahq/candela/releases/download/v0.11.3/candela_0.11.3_Darwin_universal.tar.gz"
      sha256 "a8adb475783b02d97e899c49427ce2fe18880338a8ae67f387f87aed79f945c9"
    end
    on_intel do
      url "https://github.com/candelahq/candela/releases/download/v0.11.3/candela_0.11.3_Darwin_universal.tar.gz"
      sha256 "a8adb475783b02d97e899c49427ce2fe18880338a8ae67f387f87aed79f945c9"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/candelahq/candela/releases/download/v0.11.3/candela_0.11.3_Linux_amd64.tar.gz"
      sha256 "67144b8fff5c7c0bd34ea984c110ddb9b1f3cc366ffab67fc41bd598e4b541fa"
    end
    on_arm do
      url "https://github.com/candelahq/candela/releases/download/v0.11.3/candela_0.11.3_Linux_arm64.tar.gz"
      sha256 "94fa577e43ac0df1c1b724d15e7d9e69f198b9b3d1f6ba8133f286dfbd7fcb54"
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
