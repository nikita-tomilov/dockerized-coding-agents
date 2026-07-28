#!/bin/bash

mkdir -p ~/.codex-mitm
mkdir -p ~/.config/codex-mitm

cat ~/.codex/config.toml | sed -e 's/localhost/host.docker.internal/g' > ~/.codex-mitm/config.toml

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMPOSE_FILE="$SCRIPT_DIR/docker-compose.yml"

docker compose -f "$COMPOSE_FILE" run --rm dock-code-ag-codex \
  /usr/local/bin/codex --sandbox danger-full-access "$@"