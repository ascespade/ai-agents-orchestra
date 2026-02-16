#!/usr/bin/env bash
set -e
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG="$DIR/agent-log.sh"
if [ ! -x "$LOG" ]; then LOG="$HOME/.trae/agent-log.sh"; fi
start_ns="$(date +%s%N)"
"$LOG" architect-orchestrator "بدء فحص الصحة"
if [ -d ".trae/skills" ]; then "$LOG" builder-code "التحقق من المهارات"; echo "skills:present"; else "$LOG" builder-code "المهارات غير موجودة"; echo "skills:missing"; exit 1; fi
if command -v git >/dev/null 2>&1; then "$LOG" qa-runtime-validator "التحقق من git"; echo "git:ok"; else "$LOG" qa-runtime-validator "git غير مثبت"; echo "git:missing"; exit 1; fi
"$LOG" regression-guard "مقارنة السلوك قبل/بعد"
"$LOG" stability-guard "قرار السماح"
echo "health:ok"
end_ns="$(date +%s%N)"
dur_ms=$(( (end_ns - start_ns)/1000000 ))
echo "metric:health_check_duration_ms=$dur_ms"
exit 0
