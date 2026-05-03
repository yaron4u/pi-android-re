#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
PI_DIR="$HOME/.pi/agent"
BIN_DIR="$HOME/.local/bin"
SKILL_DIR="$PI_DIR/skills"

if ! command -v pi &>/dev/null; then
    echo "ERROR: Pi coding agent not found. Install it first:"
    echo "  npm install -g @mariozechner/pi-coding-agent"
    exit 1
fi

mkdir -p "$PI_DIR" "$SKILL_DIR" "$PI_DIR/prompts" "$BIN_DIR"

echo "[1/4] Installing AGENTS.md..."
cp "$REPO_DIR/AGENTS.md" "$PI_DIR/AGENTS.md"

echo "[2/4] Installing skills..."
rm -rf "$SKILL_DIR/android-static-analysis" "$SKILL_DIR/android-dynamic-analysis"
cp -r "$REPO_DIR/skills/android-static-analysis" "$SKILL_DIR/"
cp -r "$REPO_DIR/skills/android-dynamic-analysis" "$SKILL_DIR/"
chmod +x "$SKILL_DIR/android-static-analysis/scripts/"*.sh

echo "[3/4] Installing prompt templates..."
cp "$REPO_DIR/prompts/static.md" "$PI_DIR/prompts/"
cp "$REPO_DIR/prompts/dynamic.md" "$PI_DIR/prompts/"

echo "[4/4] Installing apk-* CLI tools to $BIN_DIR..."
SCRIPTS_DIR="$SKILL_DIR/android-static-analysis/scripts"

for pair in "apk-check-deps:check-deps.sh" "apk-install-dep:install-dep.sh" "apk-decompile:decompile.sh" "apk-find-apis:find-api-calls.sh"; do
    cmd="${pair%%:*}"
    script="${pair##*:}"
    cat > "$BIN_DIR/$cmd" <<WRAPPER
#!/usr/bin/env bash
exec bash "$SCRIPTS_DIR/$script" "\$@"
WRAPPER
    chmod +x "$BIN_DIR/$cmd"
done

echo ""
echo "=== Installation complete ==="
echo ""
echo "Skills:   /skill:android-static-analysis"
echo "          /skill:android-dynamic-analysis"
echo "Prompts:  /static  /dynamic"
echo "CLI:      apk-check-deps  apk-decompile  apk-find-apis  apk-install-dep"
echo ""

if echo "$PATH" | tr ':' '\n' | grep -q "$BIN_DIR"; then
    echo "Running dependency check..."
    echo ""
    bash "$BIN_DIR/apk-check-deps" || true
else
    echo "WARNING: $BIN_DIR is not in your PATH."
    echo "Add this to your ~/.bashrc or ~/.zshrc:"
    echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
fi
