# Contributing to PHP-GRPC

Thank you for considering contributing to this project! Here's how you can help.

## Adding New PHP Versions

When a new PHP version is released:

1. Update `versions.json` to include the new version:
   ```json
   {
     "php_versions": [
       "8.1",
       "8.2",
       "8.3",
       "8.4",
       "8.5"  // Add new version here
     ],
     ...
   }
   ```

2. The GitHub Actions workflow will automatically build images for the new version.

## Adding New Variants

To add support for a new PHP variant (e.g., `fpm-alpine3.19`):

1. Update `versions.json`:
   ```json
   {
     ...
     "variants": [
       "cli",
       "fpm",
       "apache",
       "cli-alpine",
       "fpm-alpine",
       "fpm-alpine3.19"  // Add new variant here
     ]
   }
   ```

2. Test locally:
   ```bash
   ./build.sh 8.3 fpm-alpine3.19
   ```

## Adding Additional Extensions

To add more PHP extensions beyond GRPC:

1. Edit `Dockerfile.template`:
   ```dockerfile
   RUN ( curl -sSLf https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions -o - || echo 'return 1' ) | sh -s \
       grpc \
       protobuf \
       redis
   ```

2. Update the README to document the new extensions.

## Testing Changes Locally

Before submitting a PR:

1. Build an image locally:
   ```bash
   ./build.sh 8.3 cli
   ```

2. Test that GRPC works:
   ```bash
   docker run --rm ghcr.io/clegginabox/php-grpc:8.3-cli php -m | grep grpc
   ```

3. Test a specific variant:
   ```bash
   docker run --rm ghcr.io/clegginabox/php-grpc:8.3-fpm php --ri grpc
   ```

## Submitting Pull Requests

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature`
3. Make your changes
4. Test locally using `./build.sh`
5. Commit your changes: `git commit -am 'Add new feature'`
6. Push to the branch: `git push origin feature/your-feature`
7. Create a Pull Request

## GitHub Actions Workflows

The repository uses two main workflows:

1. **build-and-push.yml**: Runs daily to check for new PHP versions and builds/pushes images
2. **test.yml**: Runs on PRs to test that images build successfully

## Reporting Issues

If you find a bug or have a suggestion:

1. Check if an issue already exists
2. If not, create a new issue with:
   - Clear description of the problem
   - Steps to reproduce
   - Expected vs actual behavior
   - PHP version and variant affected

## Questions?

Feel free to open an issue for any questions about contributing!
