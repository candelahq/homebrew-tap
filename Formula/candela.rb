# typed: false
# frozen_string_literal: true

class Candela < Formula
  desc "LLM observability proxy — traces, costs, budgets for AI dev tools"
  homepage "https://github.com/candelahq/candela"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/candelahq/candela/releases/download/v0.10.9/candela_0.10.9_Darwin_universal.tar.gz"
      sha256 "3a09ad0bc2479664cf62c932c002d0ddce9aac6407db27c96091b891a997cb29"
    end
    on_intel do
      url "https://github.com/candelahq/candela/releases/download/v0.10.9/candela_0.10.9_Darwin_universal.tar.gz"
      sha256 "3a09ad0bc2479664cf62c932c002d0ddce9aac6407db27c96091b891a997cb29"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/candelahq/candela/releases/download/v0.10.9/candela_0.10.9_Linux_amd64.tar.gz"
      sha256 "cbed2d5e658c97f629957903f9b45d78d8e877fe23cc20ef92d8d399afead8f1"
    end
    on_arm do
      url "https://github.com/candelahq/candela/releases/download/v0.10.9/candela_0.10.9_Linux_arm64.tar.gz"
      sha256 "7380cf5b731700eab6afe57f6f3bc4b1b96502f2a443aa44f1501c618d638d28"
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
