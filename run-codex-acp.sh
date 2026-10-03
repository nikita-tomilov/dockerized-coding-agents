#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/timezone.sh"

# ACP uses stdio: keep stdin open without allocating a TTY or printing to stdout.
exec docker run --rm -i \
  --network host \
  --user "$(id -u):$(id -g)" \
  --tmpfs /tmp:rw,nosuid,size=512m \
  -v "$PWD":"$PWD" \
  -v "$HOME/.codex:/home/node/.codex" \
  -v "$HOME/.config/codex:/home/node/.config/codex" \
  -e HOME=/home/node \
  -e TZ \
  -e INITIAL_AGENT_MODE=agent-full-access \
  -e CODEX_API_KEY \
  -e OPENAI_API_KEY \
  -e CODEX_CONFIG=$CODEX_CONFIG \
  -w "$PWD" \
  nikitatomilov/agentshell \
  /usr/local/bin/codex-acp "$@"
