# typed: false
# frozen_string_literal: true

class Candela < Formula
  desc "LLM observability proxy — traces, costs, budgets for AI dev tools"
  homepage "https://github.com/candelahq/candela"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/candelahq/candela/releases/download/v0.9.1/candela_0.9.1_Darwin_universal.tar.gz"
      sha256 "d5def892c9dcb15b83720c854728d5cde58024f6b372f20d76e1c605043b6946"
    end
    on_intel do
      url "https://github.com/candelahq/candela/releases/download/v0.9.1/candela_0.9.1_Darwin_universal.tar.gz"
      sha256 "d5def892c9dcb15b83720c854728d5cde58024f6b372f20d76e1c605043b6946"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/candelahq/candela/releases/download/v0.9.1/candela_0.9.1_Linux_amd64.tar.gz"
      sha256 "adc21c61754a92c8c770514104c715e32700a37fab7dbf33844f3aecd55d9919"
    end
    on_arm do
      url "https://github.com/candelahq/candela/releases/download/v0.9.1/candela_0.9.1_Linux_arm64.tar.gz"
      sha256 "127732288da801e328bac0d0797190624ece19ef5b3550ba1aca0b37ac532329"
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
