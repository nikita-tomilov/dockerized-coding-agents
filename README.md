# Dockerized coding agents

This is a small, **non-production-ready** example of running coding agents manually in a Dockerized environment. It is intended as a simple local setup, without relying on Docker Sandbox or other container-management tools.

The image includes:

- OpenAI Codex
- Claude Code
- Cursor Agent
- Pi coding agent

## Build the image

From this directory, run:

```bash
./build.sh
```

This builds the `nikitatomilov/agentshell` image and maps the container's `node` user to your current UID and GID, so files created in a mounted project remain owned by you.

## Run an agent

Run the corresponding script from the project you want the agent to work on:

```bash
/path/to/dockerized-coding-agents/run-codex.sh
/path/to/dockerized-coding-agents/run-claude.sh
/path/to/dockerized-coding-agents/run-cursor-agent.sh
/path/to/dockerized-coding-agents/run-pi.sh
```

Each script mounts the current directory into the container, sets it as the working directory, and mounts the relevant local agent configuration directory so the agent can use its existing login and settings.

Arguments are passed through to the underlying agent. For example:

```bash
/path/to/dockerized-coding-agents/run-codex.sh --help
```

## Optional shell aliases

Add aliases to `~/.bashrc` or `~/.zprofile` to invoke an agent more conveniently:

```bash
alias codex=/path/to/dockerized-coding-agents/run-codex.sh
alias claude=/path/to/dockerized-coding-agents/run-claude.sh
alias cursor-agent=/path/to/dockerized-coding-agents/run-cursor-agent.sh
alias pi=/path/to/dockerized-coding-agents/run-pi.sh
```

Reload your shell configuration afterwards, for example:

```bash
source ~/.bashrc
```

Then, from any project directory, run:

```bash
codex
```

## Use the image in an allowlisted proxy environment

The image can also be used in a [mitmproxy](https://mitmproxy.org/)-based environment that permits only the external domains an agent needs. The agent container has no direct external network connection; its traffic must pass through the proxy and its allowlist.

The included `compose-mitmproxy` directory is an example for Claude Code. It places the agent container on an internal-only network and currently permits `anthropic.com` and its subdomains.

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

Use this example as a starting point for other agents: adapt the mounted credentials, the agent command, and `ALLOWED_DOMAINS` in [`compose-mitmproxy/allowlist.py`](compose-mitmproxy/allowlist.py). The proxy's certificate material is kept in the named Docker volume `dock-code-mitm-certs`.

## Security note

This is deliberately a lightweight manual setup, not a hardened sandbox. The launch scripts mount your current working directory and agent credentials/configuration into the container. Agents are started with skip-permission-checks where applicable.

An allowlisted proxy narrows outbound network access, but it is not a complete security boundary: HTTPS traffic is decrypted at the local proxy and the container still receives your mounted project and agent credentials. Review the scripts and use them only with projects and credentials you are comfortable exposing to the agent container.
