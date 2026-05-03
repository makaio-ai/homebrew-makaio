cask "makaio" do
  version "1.0.0"
  sha256 :no_check

  url "https://github.com/makaio-ai/makaio-framework/releases/download/v#{version}/stable-macos-arm64-Makaio.dmg"
  name "Makaio"
  desc "Runtime for building and hosting AI agent systems"
  homepage "https://makaio.ai"

  depends_on macos: ">= :ventura"

  app "Makaio.app"

  postflight do
    launcher = "#{HOMEBREW_PREFIX}/bin/makaio"
    File.write(launcher, <<~SH)
      #!/bin/bash
      set -euo pipefail
      MAKAIO_APP="#{appdir}/Makaio.app"
      BUN_BIN="${MAKAIO_APP}/Contents/MacOS/bun"
      if [[ ! -x "${BUN_BIN}" ]]; then
        echo "error: Makaio has not been launched yet. Open Makaio.app first." >&2
        exit 1
      fi
      exec "${BUN_BIN}" "${MAKAIO_APP}/Contents/Resources/app/dist/cli.mjs" "$@"
    SH
    set_permissions launcher, "+x"
  end

  uninstall quit: "ai.makaio.app",
            delete: "#{HOMEBREW_PREFIX}/bin/makaio"

  zap trash: [
    "~/.makaio",
    "~/Library/Application Support/ai.makaio.app",
  ]
end
