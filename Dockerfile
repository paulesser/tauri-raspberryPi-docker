###################
# BASE
###################
FROM rust:bookworm AS base
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"

WORKDIR /app

RUN apt-get update \
    && apt install -y libwebkit2gtk-4.1-dev \
    build-essential \
    curl \
    wget \
    file \
    libxdo-dev \
    libssl-dev \
    libayatana-appindicator3-dev \
    librsvg2-dev

RUN wget -qO- https://get.pnpm.io/install.sh | ENV="$HOME/.shrc" SHELL="$(which sh)" sh -

RUN pnpm env use --global lts

###################
# BUILD
###################
FROM base AS build

COPY src src
COPY src-tauri src-tauri
COPY index.html index.html
COPY vite.config.ts vite.config.ts
COPY public public
COPY package.json package.json
COPY pnpm-lock.yaml pnpm-lock.yaml
COPY tailwind.config.js tailwind.config.js
COPY tsconfig.json tsconfig.json
COPY tsconfig.node.json tsconfig.node.json
COPY postcss.config.js postcss.config.js

RUN --mount=type=cache,id=pnpm,target=/root/.local/share/pnpm/store pnpm fetch --frozen-lockfile
RUN --mount=type=cache,id=pnpm,target=/root/.local/share/pnpm/store pnpm install --frozen-lockfile

CMD ["pnpm", "tauri", "build", "--bundles"]

###################
# DEVELOPMENT
###################
FROM base AS development
ENV NODE_ENV=development

COPY . .

RUN pnpm install

CMD ["pnpm", "tauri", "dev"]
