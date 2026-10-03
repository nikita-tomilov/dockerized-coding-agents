FROM node:22-bookworm

# Setup home dir
ARG USER_ID=1000
ARG GROUP_ID=1000

ENV HOME=/home/node
RUN if ! getent group "${GROUP_ID}" >/dev/null; then \
      groupmod --gid "${GROUP_ID}" node; \
    fi \
    && usermod --uid "${USER_ID}" --gid "${GROUP_ID}" node \
    && chown -R "${USER_ID}:${GROUP_ID}" /home/node

# Install Python (useful for agents), ripgrep, and named timezone data
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    python3-venv \
    ripgrep \
    tzdata \
    && rm -rf /var/lib/apt/lists/*

# Install agents
RUN npm install -g @openai/codex
RUN npm install -g @agentclientprotocol/codex-acp
RUN npm install -g --ignore-scripts @earendil-works/pi-coding-agent
RUN npm install -g @anthropic-ai/claude-code

# Switch to non-root
USER node

# Give Bash some color

RUN echo 'export PS1="\[\e[32m\]\u@\h\[\e[0m\]:\[\e[34m\]\w\[\e[0m\]\$ "' >> /home/node/.bashrc \
    && echo "alias ls='ls --color=auto'" >> /home/node/.bashrc \
    && echo "alias ll='ls -la'" >> /home/node/.bashrc

# Install more agents
RUN curl https://cursor.com/install -fsS | bash

# Install Python and uv
RUN curl https://astral.sh/uv/install.sh -fsSL | sh
ENV PATH="/home/node/.local/bin:${PATH}"
RUN uv python install 3.12
# Do not override .venv from the machine
ENV UV_PROJECT_ENVIRONMENT=/home/node/.venv-agentshell-linux
ENV UV_LINK_MODE=copy

# Entrypoint
CMD ["/bin/bash"]
