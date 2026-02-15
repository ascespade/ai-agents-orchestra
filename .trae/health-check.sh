#!/usr/bin/env bash
set -e
echo "health:ok"
if [ -d ".trae/skills" ]; then echo "skills:present"; else echo "skills:missing"; exit 1; fi
if command -v git >/dev/null 2>&1; then echo "git:ok"; else echo "git:missing"; exit 1; fi
exit 0
