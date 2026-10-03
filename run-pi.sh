#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/timezone.sh"

echo -e
docker run --rm -it \
  --network host \
  --user "$(id -u):$(id -g)" \
  --tmpfs /tmp:rw,nosuid,size=512m \
  -v "$PWD":"$PWD" \
  -v "$HOME/.pi/agent:/home/node/.pi/agent" \
  -e HOME=/home/node \
  -e TZ \
  -w "$PWD" \
  nikitatomilov/agentshell \
  /usr/local/bin/pi "$@"
