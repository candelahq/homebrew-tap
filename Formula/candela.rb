# typed: false
# frozen_string_literal: true

class Candela < Formula
  desc "LLM observability proxy — traces, costs, budgets for AI dev tools"
  homepage "https://github.com/candelahq/candela"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/candelahq/candela/releases/download/v0.11.7/candela_0.11.7_Darwin_universal.tar.gz"
      sha256 "d91f6eb04ff15b3eb25465071f1916171ab59e9476aa719a6b720c4d58d8bba0"
    end
    on_intel do
      url "https://github.com/candelahq/candela/releases/download/v0.11.7/candela_0.11.7_Darwin_universal.tar.gz"
      sha256 "d91f6eb04ff15b3eb25465071f1916171ab59e9476aa719a6b720c4d58d8bba0"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/candelahq/candela/releases/download/v0.11.7/candela_0.11.7_Linux_amd64.tar.gz"
      sha256 "8686259b93497bbceb3e654e5ce57c73a88932ef86db2df0d949e5045fa30c1b"
    end
    on_arm do
      url "https://github.com/candelahq/candela/releases/download/v0.11.7/candela_0.11.7_Linux_arm64.tar.gz"
      sha256 "31ecea6c3072d7c2e835f9cc098cc58d84a2d01902917c972cd5f017ff95f363"
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
