# Setup Guide

This guide will help you set up automated builds for your PHP-GRPC Docker images.

## Prerequisites

- GitHub repository with GitHub Actions enabled
- Docker Hub account (for publishing to Docker Hub)
- GitHub account (for publishing to GHCR)

## Step 1: Fork or Clone This Repository

Fork this repository to your own GitHub account or organization.

## Step 2: Configure Docker Hub Credentials

To publish images to Docker Hub, you need to create an access token and add it to your repository secrets.

### Create Docker Hub Access Token

1. Log in to [Docker Hub](https://hub.docker.com)
2. Go to [Account Settings > Security](https://hub.docker.com/settings/security)
3. Click **New Access Token**
4. Give it a descriptive name (e.g., "GitHub Actions - php-grpc")
5. Set permissions to **Read & Write**
6. Click **Generate**
7. **Important**: Copy the token immediately - you won't be able to see it again!

### Add Secrets to GitHub Repository

1. Go to your GitHub repository
2. Navigate to **Settings > Secrets and variables > Actions**
3. Click **New repository secret**
4. Add the following secrets:

   **DOCKERHUB_USERNAME**
   - Value: Your Docker Hub username

   **DOCKERHUB_TOKEN**
   - Value: The access token you just created

## Step 3: Configure Image Names

Update the workflow file `.github/workflows/build-and-push.yml` if needed:

```yaml
env:
  GHCR_REGISTRY: ghcr.io
  DOCKERHUB_REGISTRY: docker.io
  IMAGE_NAME: ${{ github.repository }}  # Uses your-username/repo-name
  DOCKERHUB_IMAGE: your-dockerhub-username/php-grpc  # Update this!
```

Make sure to update `DOCKERHUB_IMAGE` to match your Docker Hub repository name.

## Step 4: Enable GitHub Actions

1. Go to your repository's **Actions** tab
2. If prompted, click **I understand my workflows, go ahead and enable them**

## Step 5: Trigger Initial Build

You can trigger the initial build in several ways:

### Option 1: Manual Trigger
1. Go to **Actions** tab
2. Click on **Build and Push Docker Images** workflow
3. Click **Run workflow**
4. Select branch and click **Run workflow**

### Option 2: Push a Change
Make any change to `Dockerfile.template`, `versions.json`, or the workflow file and push to main branch.

### Option 3: Wait for Scheduled Run
The workflow runs automatically every day at 2 AM UTC.

## Step 6: Verify Builds

### Check GitHub Actions
1. Go to **Actions** tab
2. Click on the running workflow
3. Monitor the build progress

### Check Docker Hub
1. Go to [Docker Hub](https://hub.docker.com)
2. Navigate to your repository
3. Check the **Tags** tab for published images

### Check GitHub Container Registry
1. Go to your GitHub profile or organization
2. Click **Packages**
3. Find your `php-grpc` package
4. Verify the tags are published

## Step 7: Test Your Images

Pull and test an image:

```bash
# From Docker Hub
docker pull your-username/php-grpc:8.3-cli
docker run --rm your-username/php-grpc:8.3-cli php -m | grep grpc

# From GHCR
docker pull ghcr.io/your-username/php-grpc:8.3-cli
docker run --rm ghcr.io/your-username/php-grpc:8.3-cli php -m | grep grpc
```

## Multi-Platform Support

The images are automatically built for both:
- **linux/amd64** (Intel/AMD processors)
- **linux/arm64** (ARM processors, including Apple Silicon M1/M2/M3)

You don't need to do anything special - Docker will automatically pull the correct image for your platform.

### Testing Platform Support

```bash
# Check available platforms for an image
docker buildx imagetools inspect your-username/php-grpc:8.3-cli

# Force a specific platform
docker pull --platform linux/arm64 your-username/php-grpc:8.3-cli
docker pull --platform linux/amd64 your-username/php-grpc:8.3-cli
```

## Customization

### Add More PHP Versions

Edit `versions.json`:

```json
{
  "php_versions": [
    "8.1",
    "8.2",
    "8.3",
    "8.4",
    "8.5"  // Add new version
  ],
  "variants": [
    "cli",
    "fpm",
    "apache",
    "cli-alpine",
    "fpm-alpine"
  ]
}
```

### Add More Variants

Edit `versions.json`:

```json
{
  "php_versions": [...],
  "variants": [
    "cli",
    "fpm",
    "apache",
    "cli-alpine",
    "fpm-alpine",
    "fpm-alpine3.19"  // Add new variant
  ]
}
```

### Add More Extensions

Edit `Dockerfile.template`:

```dockerfile
RUN ( curl -sSLf https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions -o - || echo 'return 1' ) | sh -s \
    grpc \
    protobuf \
    redis
```

## Troubleshooting

### Builds Failing

1. Check the Actions logs for error messages
2. Verify your Docker Hub credentials are correct
3. Make sure the base PHP image exists on Docker Hub
4. Check if you have enough Docker Hub rate limit

### Images Not Appearing

1. Verify the workflow completed successfully
2. Check that secrets are set correctly
3. Make sure GitHub Actions has permission to write packages
4. For GHCR, ensure your repository visibility settings allow package publishing

### Multi-Platform Build Issues

Multi-platform builds take longer (up to 3x) because they build for multiple architectures. This is normal. GitHub Actions has a 6-hour timeout, which should be sufficient.

## Support

If you encounter issues:

1. Check the [GitHub Actions documentation](https://docs.github.com/en/actions)
2. Check the [Docker Build Push Action documentation](https://github.com/docker/build-push-action)
3. Open an issue in this repository

## Next Steps

- Set up automatic security scanning with [Trivy](https://github.com/aquasecurity/trivy-action)
- Add image signing with [Cosign](https://github.com/sigstore/cosign)
- Configure automated testing before publishing
- Set up notifications for failed builds
