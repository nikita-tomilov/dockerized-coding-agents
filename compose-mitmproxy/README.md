# Run Claude Code behind an allowlisted proxy

This directory contains a [mitmproxy](https://mitmproxy.org/)-based example that permits only the external domains an agent needs. The agent container has no direct external network connection; its traffic must pass through the proxy and its allowlist.

It places the Claude Code container on an internal-only network and currently permits `anthropic.com` and its subdomains.

Build the agent image first if you have not already:

```bash
/path/to/dockerized-coding-agents/build.sh
```

From the project Claude should work on, run the example launcher with `COMPOSE_FILE` pointing at this repository's Compose file:

```bash
COMPOSE_FILE=/path/to/dockerized-coding-agents/compose-mitmproxy/docker-compose.yml \
  /path/to/dockerized-coding-agents/compose-mitmproxy/run-claude-mitm.sh
```

Arguments are passed to Claude as usual:

```bash
COMPOSE_FILE=/path/to/dockerized-coding-agents/compose-mitmproxy/docker-compose.yml \
  /path/to/dockerized-coding-agents/compose-mitmproxy/run-claude-mitm.sh --help
```

The example Compose configuration mounts the current project directory, your Claude credentials and configuration, and a generated proxy CA certificate. The certificate is exposed only to the agent container and is configured through `NODE_EXTRA_CA_CERTS` so Claude can use HTTPS through the proxy.

Use this example as a starting point for other agents: adapt the mounted credentials, the agent command, and `ALLOWED_DOMAINS` in [allowlist.py](allowlist.py). The proxy's certificate material is kept in the named Docker volume `dock-code-mitm-certs`.

## Security note

An allowlisted proxy narrows outbound network access, but it is not a complete security boundary: HTTPS traffic is decrypted at the local proxy and the container still receives your mounted project and agent credentials. Review the scripts and use them only with projects and credentials you are comfortable exposing to the agent container.
