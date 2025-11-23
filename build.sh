#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default values
IMAGE_NAME="php-grpc"
REGISTRY="ghcr.io/clegginabox"

# Function to print colored output
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to build a single image
build_image() {
    local php_version=$1
    local variant=$2
    local tag="${php_version}-${variant}"

    print_info "Building ${REGISTRY}/${IMAGE_NAME}:${tag}"

    docker build \
        --build-arg PHP_VERSION="${php_version}" \
        --build-arg PHP_VARIANT="${variant}" \
        -t "${REGISTRY}/${IMAGE_NAME}:${tag}" \
        -f Dockerfile.template \
        .

    if [ $? -eq 0 ]; then
        print_info "Successfully built ${tag}"

        # Also tag as latest if this is 8.3-cli
        if [ "${tag}" == "8.3-cli" ]; then
            docker tag "${REGISTRY}/${IMAGE_NAME}:${tag}" "${REGISTRY}/${IMAGE_NAME}:latest"
            print_info "Tagged as latest"
        fi
    else
        print_error "Failed to build ${tag}"
        return 1
    fi
}

# Function to get versions from versions.json
get_versions() {
    if command -v jq &> /dev/null; then
        jq -r '.php_versions[]' versions.json
    else
        # Fallback if jq is not available
        echo "8.1 8.2 8.3 8.4"
    fi
}

get_variants() {
    if command -v jq &> /dev/null; then
        jq -r '.variants[]' versions.json
    else
        # Fallback if jq is not available
        echo "cli fpm apache cli-alpine fpm-alpine"
    fi
}

# Main script
main() {
    local php_version=$1
    local variant=$2

    if [ -z "$php_version" ] || [ -z "$variant" ]; then
        echo "Usage: $0 <php_version|all> <variant|all>"
        echo ""
        echo "Examples:"
        echo "  $0 8.2 cli              # Build PHP 8.2 CLI"
        echo "  $0 8.3 all              # Build all variants for PHP 8.3"
        echo "  $0 all all              # Build all versions and variants"
        echo ""
        echo "Available PHP versions: $(get_versions | tr '\n' ' ')"
        echo "Available variants: $(get_variants | tr '\n' ' ')"
        exit 1
    fi

    # Build all versions and variants
    if [ "$php_version" == "all" ] && [ "$variant" == "all" ]; then
        print_info "Building all PHP versions and variants"
        for ver in $(get_versions); do
            for var in $(get_variants); do
                build_image "$ver" "$var" || print_warn "Skipping ${ver}-${var}"
            done
        done
    # Build all variants for a specific version
    elif [ "$variant" == "all" ]; then
        print_info "Building all variants for PHP ${php_version}"
        for var in $(get_variants); do
            build_image "$php_version" "$var" || print_warn "Skipping ${php_version}-${var}"
        done
    # Build all versions for a specific variant
    elif [ "$php_version" == "all" ]; then
        print_info "Building all PHP versions for variant ${variant}"
        for ver in $(get_versions); do
            build_image "$ver" "$variant" || print_warn "Skipping ${ver}-${variant}"
        done
    # Build a specific version and variant
    else
        build_image "$php_version" "$variant"
    fi

    print_info "Build completed!"
}

main "$@"
