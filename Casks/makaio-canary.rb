cask "makaio-canary" do
  version "1.0.0-canary.1"
  sha256 "23f27bf5e6c469e8ac05c1a843c10983b02ee512f1d2462b88e48e9c2a70ad2b"

  url "https://github.com/makaio-ai/makaio-framework/releases/download/v#{version}/canary-macos-arm64-Makaio-canary.dmg"
  name "Makaio Canary"
  desc "Runtime for building and hosting AI agent systems (canary channel)"
  homepage "https://makaio.ai"

  depends_on macos: ">= :ventura"

  app "Makaio-canary.app"

  postflight do
    launcher = "#{HOMEBREW_PREFIX}/bin/makaio"
    File.write(launcher, <<~SH)
      #!/bin/bash
      set -euo pipefail
      MAKAIO_APP="#{appdir}/Makaio-canary.app"
      BUN_BIN="${MAKAIO_APP}/Contents/MacOS/bun"
      if [[ ! -x "${BUN_BIN}" ]]; then
        echo "error: Makaio has not been launched yet. Open Makaio-canary.app first." >&2
        exit 1
      fi
      export MAKAIO_HOME="${MAKAIO_HOME:-$HOME/.makaio-canary}"
      exec "${BUN_BIN}" "${MAKAIO_APP}/Contents/Resources/app/Resources/app/dist/cli.mjs" "$@"
    SH
    set_permissions launcher, "+x"
  end

  uninstall quit: "ai.makaio.app",
            delete: "#{HOMEBREW_PREFIX}/bin/makaio"

  zap trash: [
    "~/.makaio-canary",
    "~/Library/Application Support/ai.makaio.app",
  ]
end
