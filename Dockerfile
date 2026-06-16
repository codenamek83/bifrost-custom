ARG BIFROST_VERSION=latest
FROM maximhq/bifrost:${BIFROST_VERSION}

# Re-declare ARG after FROM to make it available for labels
ARG BIFROST_VERSION

# Add version and metadata labels
LABEL org.opencontainers.image.version=${BIFROST_VERSION} \\
      org.opencontainers.image.description=\"Custom Bifrost build with BookStack MCP Server\"

# 1. Switch to root to install all language runtimes at once
USER root
RUN apk add --no-cache nodejs npm python3 py3-pip

# 2. Add your MCP tools here as a list (Easy to scale!)
RUN npm install -g bookstack-mcp-server 

# 3. Secure the container by switching back to the default user
USER 1001