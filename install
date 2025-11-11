#!/bin/bash
# Install VS-SLN utility to /usr/local/bin

set -e  # exit on error

VS_URL="https://raw.githubusercontent.com/idandrori555/vs-sln/refs/heads/main/vs"
DEST="/usr/local/bin/vs"
TMP_FILE="/tmp/vs"
FORCE=false

# Parse args
for arg in "$@"; do
  [[ "$arg" == "--force" ]] && FORCE=true
done

echo "📦 Downloading latest VS-SLN from GitHub..."
if ! curl -fsSL -H "Cache-Control: no-cache, no-store, must-revalidate" \
     -H "Pragma: no-cache" \
     -H "Expires: 0" \
     "${VS_URL}?$(date +%s)" -o "$TMP_FILE"; then
  echo "❌ Failed to download VS-SLN from $VS_URL"
  exit 1
fi

chmod +x "$TMP_FILE"

if [[ -f "$DEST" ]]; then
  if $FORCE || ! [ -t 0 ]; then
    echo "⚠️  Overwriting existing $DEST (forced or non-interactive mode)..."
    sudo rm -f "$DEST"
  else
    read -p "⚠️  $DEST already exists. Overwrite? [y/N] " ans
    [[ $ans != "y" && $ans != "Y" ]] && echo "Aborted." && exit 0
    sudo rm -f "$DEST"
  fi
fi

echo "🚀 Installing VS-SLN to $DEST..."
sudo mv "$TMP_FILE" "$DEST"

echo "✅ VS-SLN installed successfully at $DEST"
echo "   Try running: vs"

