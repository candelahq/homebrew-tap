# typed: false
# frozen_string_literal: true

class Candela < Formula
  desc "LLM observability proxy — traces, costs, budgets for AI dev tools"
  homepage "https://github.com/candelahq/candela"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/candelahq/candela/releases/download/v0.11.9/candela_0.11.9_Darwin_universal.tar.gz"
      sha256 "920cf611b37d432598ca9a9ecafec05424ad3fc252a0148b8312128b947fd9c5"
    end
    on_intel do
      url "https://github.com/candelahq/candela/releases/download/v0.11.9/candela_0.11.9_Darwin_universal.tar.gz"
      sha256 "920cf611b37d432598ca9a9ecafec05424ad3fc252a0148b8312128b947fd9c5"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/candelahq/candela/releases/download/v0.11.9/candela_0.11.9_Linux_amd64.tar.gz"
      sha256 "9fc47dfeba1a4ab1a07c0c2271ba27e7f496906cada6f3f0bca989e2a538579a"
    end
    on_arm do
      url "https://github.com/candelahq/candela/releases/download/v0.11.9/candela_0.11.9_Linux_arm64.tar.gz"
      sha256 "032eb0f6318d9b7b2ffce894c4eb7d36a0e07a7b6a49b3f9769f359a79ded99a"
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
