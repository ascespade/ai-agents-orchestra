#!/usr/bin/env bash
set -e
mkdir -p .trae/logs
before_file=".trae/logs/before.out"
after_file=".trae/logs/after.out"
AGENT_LOG_JSON=1 bash .trae/health-check.sh > "$before_file"
AGENT_LOG_JSON=1 bash .trae/health-check.sh > "$after_file"
if grep -q '"message":"بدء فحص الصحة"' "$before_file" && grep -q '"message":"بدء فحص الصحة"' "$after_file"; then
  :
else
  echo "regression:missing-start" && exit 1
fi
if grep -q 'health:ok' "$before_file" && grep -q 'health:ok' "$after_file"; then
  echo "regression:ok"
else
  echo "regression:fail" && diff -u "$before_file" "$after_file" || true && exit 1
fi
