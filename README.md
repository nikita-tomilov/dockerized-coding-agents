# Dockerized coding agents

This is a small, **non-production-ready** example of running coding agents manually in a Dockerized
environment. It is intended as a simple local setup, without relying on Docker Sandbox or other
container-management tools.

The image includes:

- OpenAI Codex
- Claude Code
- Cursor Agent
- Pi coding agent

## Benefits

- You can dangerously-skip-permissions without relying on the agent's builtin sandbox
- You can use Linux tools on any environment (ie MacOS)
- You can use it on any docker-cli compatible distro (ie Orbstack)
- Harness can run any kind of Python or Bash script without breaking your machine, only project
  directory and agent configs are exposed

## Drawbacks

- Agent cannot run the project or use anything else that is not packaged to the docker image
- Agent can still access the Internet
- Agent does not have access to your desktop environment (pasting images or opening the browser wont
  work)
- If agent has access to an MCP that has shell tool, it can still run shell scripts over your actual
  environment

## Build the image

From this directory, run:

```bash
./build.sh
```

This builds the `nikitatomilov/agentshell` image and maps the container's `node` user to your
current UID and GID, so files created in a mounted project remain owned by you.

## Run an agent

Run the corresponding script from the project you want the agent to work on:

```bash
/path/to/dockerized-coding-agents/run-codex.sh
/path/to/dockerized-coding-agents/run-claude.sh
/path/to/dockerized-coding-agents/run-cursor-agent.sh
/path/to/dockerized-coding-agents/run-pi.sh
```

Each script mounts the current directory into the container, sets it as the working directory, and
mounts the relevant local agent configuration directory so the agent can use its existing login and
settings.

Arguments are passed through to the underlying agent. For example:

```bash
/path/to/dockerized-coding-agents/run-codex.sh --help
```

## Optional shell aliases

Add aliases to `~/.bashrc` or `~/.zprofile` to invoke an agent more conveniently:

```bash
alias codex=/path/to/dockerized-coding-agents/run-codex.sh
```

## Use the image behind an allowlisted proxy

See the [mitmproxy Compose example](compose-mitmproxy/README.md) for instructions on running an
agent behind an allowlisted proxy.

## Security note

This is deliberately a lightweight manual setup, not a hardened sandbox.
The launch scripts mount your current working directory and agent credentials/configuration into the
container.
Agents are started with skip-permission-checks where applicable.

An allowlisted proxy narrows outbound network access, but it is not a complete security boundary:
HTTPS traffic is decrypted at the local proxy and the container still receives your mounted project
and agent credentials. Review the scripts and use them only with projects and credentials you are
comfortable exposing to the agent container.
