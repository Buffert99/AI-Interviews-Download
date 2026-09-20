#!/usr/bin/env bash
set -euo pipefail

DOWNLOAD_REPO="Buffert99/AI-Interviews-Download"
VERSION="${1:-$(node -p "require('./package.json').version" 2>/dev/null || date +%Y.%m.%d.%H%M)}"
REQUIRED="${AI_INTERVIEWS_UPDATE_REQUIRED:-false}"
MINIMUM_VERSION="${AI_INTERVIEWS_MINIMUM_VERSION:-}"
NOTES="${AI_INTERVIEWS_RELEASE_NOTES:-Nieuwe versie van AI Interviews.}"

command -v gh >/dev/null || { echo "FOUT: GitHub CLI (gh) ontbreekt."; exit 1; }
command -v node >/dev/null || { echo "FOUT: Node.js ontbreekt."; exit 1; }

echo "Nieuwste geslaagde Android preview-build ophalen uit EAS..."
BUILD_JSON="$(npx eas-cli@latest build:list --platform android --profile preview --status finished --limit 10 --json --non-interactive)"

APK_URL="$(printf '%s' "$BUILD_JSON" | node -e '
let data="";
process.stdin.setEncoding("utf8");
process.stdin.on("data", c => data += c);
process.stdin.on("end", () => {
  const builds = JSON.parse(data);
  const build = builds.find(item => item && item.artifacts && item.artifacts.buildUrl);
  if (!build) process.exit(2);
  process.stdout.write(build.artifacts.buildUrl);
});
')"

if [[ -z "$APK_URL" ]]; then
  echo "FOUT: geen bruikbare EAS Android preview-build gevonden."
  exit 1
fi

echo "APK gevonden. Publiceer AI Interviews $VERSION..."
echo "Verplicht: $REQUIRED · minimumversie: ${MINIMUM_VERSION:-bestaande minimumversie behouden}"

gh workflow run publish-apk.yml   --repo "$DOWNLOAD_REPO"   --ref main   -f "apk_url=$APK_URL"   -f "version=$VERSION"   -f "required=$REQUIRED"   -f "minimum_version=$MINIMUM_VERSION"   -f "notes=$NOTES"

echo
echo "OK: publicatie is gestart."
echo "Controleer: https://github.com/$DOWNLOAD_REPO/actions"
echo "Na afronding gebruikt de app automatisch update.json en de nieuwste APK."
