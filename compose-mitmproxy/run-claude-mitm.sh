#!/bin/bash
docker compose run --rm dock-code-ag-main \
 /usr/local/bin/claude --dangerously-skip-permissions "$@"