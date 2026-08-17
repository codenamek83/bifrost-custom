ARG BIFROST_VERSION=latest
FROM maximhq/bifrost:${BIFROST_VERSION}

# Switch to root to install runtimes
USER root

# Disable runtime transpiler cache inside Docker
ENV BUN_RUNTIME_TRANSPILER_CACHE_PATH=0

# Ensure global installs target /usr/local/bin
ENV BUN_INSTALL=/usr/local
ENV BUN_INSTALL_BIN=/usr/local/bin

# Install system dependencies and Bun via official release binary
# ca-certificates curl unzip - BUN INSTALLER
# libgcc libstdc++ - BUN RUNTIME
# nodejs npm - NODE-BASED MCP SERVERS
# python3 py3-pip - PYTHON-BASED TOOLS / NATIVE BUILDS
RUN apk add --no-cache ca-certificates curl unzip libgcc libstdc++ nodejs npm python3 py3-pip \
    && arch="$(apk --print-arch)" \
    && case "${arch##*-}" in \
      x86_64) build="x64-musl-baseline";; \
      aarch64) build="aarch64-musl";; \
      *) echo "error: unsupported architecture: $arch"; exit 1 ;; \
    esac \
    && curl "https://github.com/oven-sh/bun/releases/latest/download/bun-linux-$build.zip" \
      -fsSLO \
      --compressed \
      --retry 5 \
    && unzip "bun-linux-$build.zip" \
    && mv "bun-linux-$build/bun" /usr/local/bin/bun \
    && rm -rf "bun-linux-$build.zip" "bun-linux-$build" \
    && chmod +x /usr/local/bin/bun \
    && ln -s /usr/local/bin/bun /usr/local/bin/bunx

# Install BookStack MCP server globally via Bun
RUN bun add -g bookstack-mcp-server \
 && which bookstack-mcp-server

# Secure the container by switching back to the default user
USER 1001