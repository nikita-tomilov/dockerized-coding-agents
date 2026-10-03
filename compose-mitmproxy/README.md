# Run Claude Code or Codex behind an allowlisted proxy

This directory contains a [mitmproxy](https://mitmproxy.org/)-based example that permits only the
external domains an agent needs. The agent container has no direct external network connection; its
traffic must pass through the proxy and its allowlist.

It places the Claude Code or Codex containers on an internal-only network and currently permits
only domains necessary for the agents plus a localhost forwarding for your MCPs.

Build the agent image first if you have not already:

```bash
/path/to/dockerized-coding-agents/build.sh
```

Then, you can start the harness.

```bash
/path/to/dockerized-coding-agents/compose-mitmproxy/run-codex-mitm.sh
```

Arguments are passed to Claude or Codex as usual:

```bash
/path/to/dockerized-coding-agents/compose-mitmproxy/run-claude-mitm.sh --help
```

Both launchers detect the host timezone on Linux and macOS and pass it through `TZ`.
You can override it with `TZ=Europe/Berlin /path/to/dockerized-coding-agents/compose-mitmproxy/run-codex-mitm.sh`.
When invoking `docker compose` directly, export `TZ` yourself to select a timezone.

The example Compose configuration mounts the current project directory, necessary configuration per
agent and a generated proxy CA certificate. The certificate is exposed only to the agent container
and is configured through `NODE_EXTRA_CA_CERTS` or similar, so agent can still use HTTPS through the
proxy.

Use this example as a starting point for other agents: adapt the mounted credentials, the agent
command, and `ALLOWED_DOMAINS` in [allowlist.py](allowlist.py). The proxy's certificate material is
kept in the named Docker volume `dock-code-mitm-certs`.

## MCP

The configuration of the agent is altered accordingly, so that any MCP on `localhost` is accessed
via the `host.docker.internal`. Your MCP running on `localhost` may not be able to allow access from
clients if clients send the header `Host: host.docker.internal`. If this is the case, you have to
either configure your MCP server accordingly or use some kind of additional proxy to alter this
header, like [this one](https://github.com/nikita-tomilov/mcp-gateway).

## Security note

An allowlisted proxy narrows outbound network access, but it is not a complete security boundary:
HTTPS traffic is decrypted at the local proxy and the container still receives your mounted project
and agent credentials. Review the scripts and use them only with projects and credentials you are
comfortable exposing to the agent container.
