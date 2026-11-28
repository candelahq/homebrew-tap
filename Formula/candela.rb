# typed: false
# frozen_string_literal: true

class Candela < Formula
  desc "LLM observability proxy — traces, costs, budgets for AI dev tools"
  homepage "https://github.com/candelahq/candela"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/candelahq/candela/releases/download/v0.12.2/candela_0.12.2_Darwin_universal.tar.gz"
      sha256 "f37c3fc533ef3a9a1fb10a2dc4d3069fa45797d3372cfd8609a5098197f23638"
    end
    on_intel do
      url "https://github.com/candelahq/candela/releases/download/v0.12.2/candela_0.12.2_Darwin_universal.tar.gz"
      sha256 "f37c3fc533ef3a9a1fb10a2dc4d3069fa45797d3372cfd8609a5098197f23638"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/candelahq/candela/releases/download/v0.12.2/candela_0.12.2_Linux_amd64.tar.gz"
      sha256 "236e85255e8bdc7480ebf230a8a6cbff5c0c758bdde6435f5600c2a291caa303"
    end
    on_arm do
      url "https://github.com/candelahq/candela/releases/download/v0.12.2/candela_0.12.2_Linux_arm64.tar.gz"
      sha256 "c8bb6a1fd58df3ee8a7796cc90a14d0895e405533635eeb2d27390d3ee6e6796"
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
