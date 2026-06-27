# typed: false
# frozen_string_literal: true

class Candela < Formula
  desc "LLM observability proxy — traces, costs, budgets for AI dev tools"
  homepage "https://github.com/candelahq/candela"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/candelahq/candela/releases/download/v0.9.4/candela_0.9.4_Darwin_universal.tar.gz"
      sha256 "708ab1c608c825ad06847805232eba0a1b540e247e5c44c144958328c36ad8c9"
    end
    on_intel do
      url "https://github.com/candelahq/candela/releases/download/v0.9.4/candela_0.9.4_Darwin_universal.tar.gz"
      sha256 "708ab1c608c825ad06847805232eba0a1b540e247e5c44c144958328c36ad8c9"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/candelahq/candela/releases/download/v0.9.4/candela_0.9.4_Linux_amd64.tar.gz"
      sha256 "39eb0c9c1f5afe5c166f49620417d59a9aaccc7db26d5aff48ad43edf97f9718"
    end
    on_arm do
      url "https://github.com/candelahq/candela/releases/download/v0.9.4/candela_0.9.4_Linux_arm64.tar.gz"
      sha256 "988bd2f2a271673ef03538cefe23788443f8417e0e7b3595d289804d415c7b87"
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
