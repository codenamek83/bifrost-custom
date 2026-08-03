# Bifrost Custom

A customized build of the [Bifrost](https://github.com/maximhq/bifrost) Docker image, extended with additional language runtimes and pre-installed MCP (Model Context Protocol) servers.

### 🚀 Features

- **Base Image**: Built on top of `maximhq/bifrost`.
- **Extended Runtimes**: Includes `Bun`, `Node.js`, `npm`, `Python 3`, and `pip` to support a wider range of MCP tools.
- **Pre-installed Tools**: 
  - `bookstack-mcp-server`: Ready-to-use integration for BookStack (installed via Bun).
- **Multi-Architecture Support**: Automatically detects and builds Bun binaries for `x86_64` (musl baseline) and `aarch64` (musl).

## 📦 Usage

The images are published to the GitHub Container Registry (GHCR).

### Pulling the Image
```bash
docker pull ghcr.io/codenamek83/bifrost-custom:latest
```

### Running with Docker
```bash
docker run -d \
  --name bifrost-custom \
  -p 8080:8080 \
  ghcr.io/codenamek83/bifrost-custom:latest
```

## 🛠 Customization

Adding new MCP servers is straightforward. Edit the `Dockerfile` and add the installation command in the `RUN` section using either **Bun** or **npm**:

```dockerfile
# Example: Adding MCP servers via Bun
RUN bun add -g bookstack-mcp-server

# Example: Adding MCP servers via npm
RUN npm install -g another-node-mcp-server
```

After editing, push your changes to the `main` branch to trigger the automatic build pipeline.

## ⚙️ CI/CD Pipeline

This repository uses GitHub Actions for fully automated build and release management:

- **Automatic Versioning**: The pipeline queries the `maximhq/bifrost` API to find the latest `transports/v*` tag and uses it as the base image.
- **Tagging Strategy**:
  - `:latest` - The most recent successful build.
  - `:<version>` - Pinned to the specific upstream Bifrost version.
  - `:sha-<hash>` - Pinned to the specific git commit of this repository for precise rollbacks.

## 💻 Local Building

If you wish to build the image locally:

```bash
docker build -t bifrost-custom .
```

To build for a specific Bifrost version:
```bash
docker build --build-arg BIFROST_VERSION=v1.2.3 -t bifrost-custom .
```