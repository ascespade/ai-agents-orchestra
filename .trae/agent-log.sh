#!/usr/bin/env bash
set -e
role="$1"; shift || true; msg="$*"; ts="$(date -Iseconds)"
lower="$(printf "%s" "$role" | tr '[:upper:]' '[:lower:]')"
case "$lower" in
  architect|orchestrator|architect-orchestrator) arabic="أوركسترا"; code="architect-orchestrator"; emoji="🎼"; color="\033[35m";;
  planner|planner-agent) arabic="مخطّط"; code="planner-agent"; emoji="🗂️"; color="\033[34m";;
  builder|builder-code) arabic="منفّذ"; code="builder-code"; emoji="🛠️"; color="\033[32m";;
  qa|qa-runtime-validator) arabic="تحقّق"; code="qa-runtime-validator"; emoji="🔎"; color="\033[33m";;
  ai|ai-integration) arabic="تكامل AI"; code="ai-integration"; emoji="🤖"; color="\033[36m";;
  regression|regression-guard) arabic="حارس التراجعات"; code="regression-guard"; emoji="🛡️"; color="\033[31m";;
  stability|stability-guard) arabic="حارس الاستقرار"; code="stability-guard"; emoji="🧭"; color="\033[36m";;
  *) arabic="وكيل"; code="$role"; emoji="⚙️"; color="\033[0m";;
esac
reset="\033[0m"
out=""
if [ "${AGENT_LOG_JSON:-0}" = "1" ]; then
  out="$(printf '{"agent":"%s","code":"%s","time":"%s","message":"%s"}\n' "$arabic" "$code" "$ts" "$msg")"
else
  if [ "${AGENT_LOG_COLOR:-0}" = "1" ]; then
    out="$(printf "%b%s%b %s | %s | %s: %s\n" "$color" "$emoji" "$reset" "$arabic" "$code" "$ts" "$msg")"
  else
    out="$(printf "%s %s | %s | %s: %s\n" "$emoji" "$arabic" "$code" "$ts" "$msg")"
  fi
fi
printf "%s\n" "$out"
if [ "${AGENT_LOG_FILE:-0}" = "1" ]; then
  mkdir -p .trae/logs
  logf=".trae/logs/agent.log"
  if [ -f "$logf" ] && [ "$(wc -c <"$logf")" -gt 100000 ]; then mv "$logf" "$logf.1"; fi
  printf "%s\n" "$out" >> "$logf"
fi
