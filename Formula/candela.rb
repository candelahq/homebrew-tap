# typed: false
# frozen_string_literal: true

class Candela < Formula
  desc "LLM observability proxy — traces, costs, budgets for AI dev tools"
  homepage "https://github.com/candelahq/candela"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/candelahq/candela/releases/download/v0.5.6/candela_0.5.6_Darwin_universal.tar.gz"
      sha256 "2e9c3eda3313e99c1556489ebc877bb350664cf2aef34288577f973d0856bb65"
    end
    on_intel do
      url "https://github.com/candelahq/candela/releases/download/v0.5.6/candela_0.5.6_Darwin_universal.tar.gz"
      sha256 "2e9c3eda3313e99c1556489ebc877bb350664cf2aef34288577f973d0856bb65"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/candelahq/candela/releases/download/v0.5.6/candela_0.5.6_Linux_amd64.tar.gz"
      sha256 "0b85c933ade238f2261ab54e510eb13d3df53e07257adeaa7f70bfea638ef2ac"
    end
    on_arm do
      url "https://github.com/candelahq/candela/releases/download/v0.5.6/candela_0.5.6_Linux_arm64.tar.gz"
      sha256 "fc99c684c7ccbd48c2d72fa53c32bb07d9b8e6ec1fa9f3f6c510c939a5ff632d"
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
