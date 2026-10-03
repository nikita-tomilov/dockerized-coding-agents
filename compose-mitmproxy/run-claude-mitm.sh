#!/bin/bash

mkdir -p ~/.claude-mitm
mkdir -p ~/.config/claude-mitm

cat ~/.claude.json | sed -e 's/localhost/host.docker.internal/g' > ~/.claude-mitm.json

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../timezone.sh"
COMPOSE_FILE="$SCRIPT_DIR/docker-compose.yml"

docker compose -f "$COMPOSE_FILE" run --rm dock-code-ag-claude \
 /usr/local/bin/claude --dangerously-skip-permissions "$@"
