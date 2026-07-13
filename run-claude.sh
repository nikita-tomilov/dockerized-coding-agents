#!/bin/bash
echo -e
docker run --rm -it \
  --user "$(id -u):$(id -g)" \
  --tmpfs /tmp:rw,nosuid,size=512m \
  -v "$PWD":"$PWD" \
  -v "$HOME/.claude:/home/node/.claude" \
  -v "$HOME/.config/claude:/home/node/.config/claude" \
  -e HOME=/home/node \
  -w "$PWD" \
  nikitatomilov/agentshell \
  /usr/local/bin/claude --dangerously-skip-permissions "$@"
