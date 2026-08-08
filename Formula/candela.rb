# typed: false
# frozen_string_literal: true

class Candela < Formula
  desc "LLM observability proxy — traces, costs, budgets for AI dev tools"
  homepage "https://github.com/candelahq/candela"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/candelahq/candela/releases/download/v0.10.12/candela_0.10.12_Darwin_universal.tar.gz"
      sha256 "cd09a696de08750086c65a7a64e2d9426a2e06ca91828409bba4dc1d0330081c"
    end
    on_intel do
      url "https://github.com/candelahq/candela/releases/download/v0.10.12/candela_0.10.12_Darwin_universal.tar.gz"
      sha256 "cd09a696de08750086c65a7a64e2d9426a2e06ca91828409bba4dc1d0330081c"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/candelahq/candela/releases/download/v0.10.12/candela_0.10.12_Linux_amd64.tar.gz"
      sha256 "79a4cb5724e20184cb3aa3f93012bf3f75da5b39ff10685486de8a6aace33a2f"
    end
    on_arm do
      url "https://github.com/candelahq/candela/releases/download/v0.10.12/candela_0.10.12_Linux_arm64.tar.gz"
      sha256 "97db19886478518bbed4ce7c4908aa811a31ce30fcc2c739371bdbe5dca50938"
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
