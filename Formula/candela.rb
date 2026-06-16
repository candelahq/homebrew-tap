# typed: false
# frozen_string_literal: true

class Candela < Formula
  desc "LLM observability proxy — traces, costs, budgets for AI dev tools"
  homepage "https://github.com/candelahq/candela"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/candelahq/candela/releases/download/v0.7.0/candela_0.7.0_Darwin_universal.tar.gz"
      sha256 "4dfb3c4a897e0d003ed3d75cca071109bf362c0f112298c59b45c4a302048744"
    end
    on_intel do
      url "https://github.com/candelahq/candela/releases/download/v0.7.0/candela_0.7.0_Darwin_universal.tar.gz"
      sha256 "4dfb3c4a897e0d003ed3d75cca071109bf362c0f112298c59b45c4a302048744"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/candelahq/candela/releases/download/v0.7.0/candela_0.7.0_Linux_amd64.tar.gz"
      sha256 "6c10b77aad46b6414956c74a080ff0aeb9559db1d9bbf2c152bb1ea4a201a6a7"
    end
    on_arm do
      url "https://github.com/candelahq/candela/releases/download/v0.7.0/candela_0.7.0_Linux_arm64.tar.gz"
      sha256 "cfa65ae79658928d39e115f1160baafa4a411835602f2d46cb1f7dfeb84db591"
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
