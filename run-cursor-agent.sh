#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/timezone.sh"

echo -e
docker run --rm -it \
  --network host \
  --user "$(id -u):$(id -g)" \
  --tmpfs /tmp:rw,nosuid,size=512m \
  -v "$PWD":"$PWD" \
  -v "$HOME/.cursor:/home/node/.cursor" \
  -e HOME=/home/node \
  -e TZ \
  -w "$PWD" \
  nikitatomilov/agentshell \
  /home/node/.local/bin/agent --force "$@"
