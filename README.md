# PHP Docker Images with GRPC Pre-installed

This repository provides PHP Docker images based on official PHP images, but with GRPC extension pre-compiled and installed. This saves significant build time in your projects since GRPC compilation can take several minutes.

## Why Use These Images?

- **Faster builds**: GRPC is already compiled, saving 5-10 minutes per build
- **Automatic updates**: Images are automatically built when new PHP versions are released
- **Drop-in replacement**: Same base as official PHP images, just with GRPC added
- **Multiple variants**: Supports CLI, FPM, Apache, and Alpine variants
- **Multi-platform**: Built for both AMD64 and ARM64 (Apple Silicon M1/M2/M3 chips)

## Available Images

Images are published to both Docker Hub and GitHub Container Registry:

### Docker Hub (recommended)
```
clegginabox/php-grpc:8.2-cli
clegginabox/php-grpc:8.2-fpm
clegginabox/php-grpc:8.2-apache
clegginabox/php-grpc:8.3-cli
clegginabox/php-grpc:8.3-fpm
clegginabox/php-grpc:8.3-apache
```

### GitHub Container Registry
```
ghcr.io/clegginabox/php-grpc:8.2-cli
ghcr.io/clegginabox/php-grpc:8.2-fpm
ghcr.io/clegginabox/php-grpc:8.2-apache
ghcr.io/clegginabox/php-grpc:8.3-cli
ghcr.io/clegginabox/php-grpc:8.3-fpm
ghcr.io/clegginabox/php-grpc:8.3-apache
```

All images support both **linux/amd64** and **linux/arm64** platforms.

## Usage

Simply replace your PHP base image:

```dockerfile
# Instead of:
FROM php:8.2-cli

# Use (Docker Hub):
FROM clegginabox/php-grpc:8.2-cli

# Or (GitHub Container Registry):
FROM ghcr.io/clegginabox/php-grpc:8.2-cli
```

The GRPC extension is already installed and enabled. You can verify with:

```bash
# Using Docker Hub
docker run --rm clegginabox/php-grpc:8.2-cli php -m | grep grpc

# Using GHCR
docker run --rm ghcr.io/clegginabox/php-grpc:8.2-cli php -m | grep grpc
```

### Platform Support

These images work seamlessly on both Intel/AMD and Apple Silicon Macs:

```bash
# Works on both architectures
docker run --rm clegginabox/php-grpc:8.3-cli php --version

# Explicitly specify platform if needed
docker run --platform linux/arm64 --rm clegginabox/php-grpc:8.3-cli php --version
```

## Supported PHP Versions

This repository automatically tracks official PHP releases and builds images for:

- PHP 8.1 (cli, fpm, apache, alpine)
- PHP 8.2 (cli, fpm, apache, alpine)
- PHP 8.3 (cli, fpm, apache, alpine)
- PHP 8.4 (cli, fpm, apache, alpine)

## How It Works

1. GitHub Actions checks for new PHP versions on DockerHub daily
2. When a new version is detected, it automatically builds matching images for both AMD64 and ARM64 architectures
3. Images are pushed to both Docker Hub and GitHub Container Registry
4. You get the latest PHP with GRPC pre-installed automatically, optimized for your platform

## Building Locally

To build images locally:

```bash
# Build a specific version
./build.sh 8.2 cli

# Build all variants for a version
./build.sh 8.2 all

# Build all versions
./build.sh all all
```

## What's Installed

Each image includes:

- Base official PHP image (matching version and variant)
- GRPC extension (latest stable version)
- All dependencies required for GRPC

The installation uses the excellent [docker-php-extension-installer](https://github.com/mlocati/docker-php-extension-installer) tool, which handles all dependencies automatically.

## Setup

To enable automatic publishing to Docker Hub, you need to set up repository secrets:

1. Go to your repository Settings > Secrets and variables > Actions
2. Add the following secrets:
   - `DOCKERHUB_USERNAME`: Your Docker Hub username
   - `DOCKERHUB_TOKEN`: Your Docker Hub access token (create one at https://hub.docker.com/settings/security)

GitHub Container Registry works automatically without additional setup.

## Contributing

Contributions are welcome! If you'd like to:

- Add support for additional PHP extensions
- Improve build times
- Add new PHP versions or variants

Please open an issue or pull request.

## License

MIT License - See [LICENSE](LICENSE) file for details.

## Related Projects

- [Official PHP Docker Images](https://hub.docker.com/_/php)
- [docker-php-extension-installer](https://github.com/mlocati/docker-php-extension-installer)
