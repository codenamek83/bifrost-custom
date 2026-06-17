# Bifrost Custom

A customized build of the [Bifrost](https://github.com/maximhq/bifrost) Docker image, extended with additional language runtimes and pre-installed MCP (Model Context Protocol) servers.

## 🚀 Features

- **Base Image**: Built on top of `maximhq/bifrost`.
- **Extended Runtimes**: Includes `Node.js`, `npm`, `Python 3`, and `pip` to support a wider range of MCP tools.
- **Pre-installed Tools**: 
  - `bookstack-mcp-server`: Ready-to-use integration for BookStack.
- **Multi-Architecture Support**: Automatically built for both `linux/amd64` and `linux/arm64`.

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

Adding new MCP servers is straightforward. Edit the `Dockerfile` and add the installation command in the `RUN` section:

```dockerfile
# Example: Adding more MCP servers
RUN npm install -g bookstack-mcp-server \
    another-mcp-server \
    yet-another-mcp-tool
```

After editing, push your changes to the `main` branch to trigger the automatic build pipeline.

## ⚙️ CI/CD Pipeline

This repository uses GitHub Actions for fully automated build and release management:

- **Automatic Versioning**: The pipeline queries the `maximhq/bifrost` API to find the latest `transports/v*` tag and uses it as the base image.
- **Tagging Strategy**:
  - `:latest` - The most recent successful build.
  - `:<version>` - Pinned to the specific upstream Bifrost version.
  - `:sha-<hash>` - Pinned to the specific git commit of this repository for precise rollbacks.
- **Upstream Tracking**: The `.upstream-tag` file stores the version of the last successful build. This allows the `auto-rebuild` workflow to detect when a new upstream version is available and trigger a rebuild automatically.

## 💻 Local Building

If you wish to build the image locally:

```bash
docker build -t bifrost-custom .
```

To build for a specific Bifrost version:
```bash
docker build --build-arg BIFROST_VERSION=v1.2.3 -t bifrost-custom .
```