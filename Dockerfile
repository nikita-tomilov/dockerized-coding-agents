FROM node:22-bookworm

# Setup home dir
ARG USER_ID=1000
ARG GROUP_ID=1000

ENV HOME=/home/node
RUN groupmod --gid "${GROUP_ID}" node \
    && usermod --uid "${USER_ID}" --gid "${GROUP_ID}" node \
    && chown -R node:node /home/node

# Install python (useful for agents)
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    python3-venv \
    && rm -rf /var/lib/apt/lists/*

# Install agents
RUN npm install -g @openai/codex
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

# Entrypoint
CMD ["/bin/bash"]