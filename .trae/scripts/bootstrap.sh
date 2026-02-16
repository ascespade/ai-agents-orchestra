#!/usr/bin/env bash
set -e
mkdir -p .trae/logs
chmod +x .trae/agent-log.sh .trae/health-check.sh
AGENT_LOG_FILE=1 bash .trae/health-check.sh
echo "bootstrap:ok"
