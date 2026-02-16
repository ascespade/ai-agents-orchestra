#!/usr/bin/env bash
set -e
SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
USER_TRAE="$HOME/.trae"
USER_SKILLS="$USER_TRAE/skills"
echo "[INFO] Installing skills to $USER_SKILLS"
mkdir -p "$USER_SKILLS"
rsync -av --delete "$SRC_DIR/skills/" "$USER_SKILLS/"
echo "[INFO] Installing agent-log to $USER_TRAE"
cp "$SRC_DIR/agent-log.sh" "$USER_TRAE/agent-log.sh"
chmod +x "$USER_TRAE/agent-log.sh"
echo "[INFO] Adding auto-link to ~/.bashrc if missing"
if ! grep -q "Trae auto-link skills v2" "$HOME/.bashrc" 2>/dev/null; then
cat >> "$HOME/.bashrc" <<'EOF'
# Trae auto-link skills v2
if [ -f "$HOME/.trae/auto-link-skills.sh" ]; then
  _trae_autolink2() {
    if [ -d ".git" ] || [ -f "package.json" ] || [ -f "pyproject.toml" ] || [ -f "Cargo.toml" ] || [ -f "go.mod" ] || [ -f "pom.xml" ]; then
      bash "$HOME/.trae/auto-link-skills.sh" >/dev/null 2>&1 || true
    fi
  }
  case ":$PROMPT_COMMAND:" in
    *:_trae_autolink2:*) ;;
    *) PROMPT_COMMAND="_trae_autolink2;${PROMPT_COMMAND}";;
  esac
fi
EOF
fi
echo "[DONE] User skills installed. Open a new shell to apply ~/.bashrc changes."
