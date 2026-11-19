#!/bin/sh
# Praxis CLI installer — hosted on GitHub Pages / Cloudflare (replaces static.pangolin.net/get-cli.sh)
# Usage: curl -fsSL https://praxis-static.pages.dev/get-cli.sh | sh
#
# Binaries: GitHub Releases (default fosrl/cli until a Praxis CLI fork publishes assets).
# Override: PRAXIS_CLI_REPO=owner/repo PRAXIS_CLI_VERSION=1.2.3

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

REPO="${PRAXIS_CLI_REPO:-fosrl/cli}"
REQUESTED_VERSION="${PRAXIS_CLI_VERSION:-}"

print_status() { printf '%b[INFO]%b %s\n' "${GREEN}" "${NC}" "$1"; }
print_warning() { printf '%b[WARN]%b %s\n' "${YELLOW}" "${NC}" "$1" >&2; }
print_error() { printf '%b[ERROR]%b %s\n' "${RED}" "${NC}" "$1" >&2; }

TMP_DIR=""
cleanup() { [ -n "$TMP_DIR" ] && rm -rf "$TMP_DIR"; }
trap cleanup EXIT
trap 'exit 1' INT TERM

detect_platform() {
    os="" arch=""
    case "$(uname -s)" in
        Linux*) os="linux" ;;
        Darwin*) os="darwin" ;;
        MINGW*|MSYS*|CYGWIN*) os="windows" ;;
        FreeBSD*) os="freebsd" ;;
        *) print_error "Unsupported OS: $(uname -s)"; exit 1 ;;
    esac
    case "$(uname -m)" in
        x86_64|amd64) arch="amd64" ;;
        arm64|aarch64) arch="arm64" ;;
        armv6l) arch="arm32v6" ;;
        armv7l) arch="arm32" ;;
        riscv64) arch="riscv64" ;;
        *) print_error "Unsupported architecture: $(uname -m)"; exit 1 ;;
    esac
    printf '%s_%s' "$os" "$arch"
}

get_install_dir() {
    case "$PLATFORM" in
        *windows*) printf '%s' "$HOME/bin" ;;
        *) printf '%s' "/usr/local/bin" ;;
    esac
}

dir_in_path() {
    case ":${PATH}:" in *":$1:"*) return 0 ;; *) return 1 ;; esac
}

needs_sudo() {
    [ -w "$1" ] 2>/dev/null && return 1 || return 0
}

get_sudo_cmd() {
    if needs_sudo "$1"; then
        if command -v sudo >/dev/null 2>&1; then
            printf 'sudo'
        else
            print_error "Cannot write to $1 and sudo is not available."
            exit 1
        fi
    else
        printf ''
    fi
}

resolve_release() {
    if [ -n "$REQUESTED_VERSION" ]; then
        VERSION=$(printf '%s' "$REQUESTED_VERSION" | sed 's/^v//')
        BASE_URL="https://github.com/${REPO}/releases/download/${VERSION}"
        print_status "Requested version: v${VERSION}"
    else
        VERSION=""
        BASE_URL="https://github.com/${REPO}/releases/latest/download"
        print_status "Using latest release from github.com/${REPO}"
    fi
}

install_cli() {
    platform="$1"
    install_dir="$2"
    sudo_cmd="$3"
    # Upstream asset naming (fosrl/cli). Keep until Praxis publishes its own assets.
    asset_name="pangolin-cli_${platform}"
    final_name="pangolin"
    case "$platform" in
        *windows*) asset_name="${asset_name}.exe"; final_name="pangolin.exe" ;;
    esac

    download_url="${BASE_URL}/${asset_name}"
    temp_file="${TMP_DIR}/${final_name}"
    final_path="${install_dir}/${final_name}"

    print_status "Downloading from ${download_url}"
    if command -v curl >/dev/null 2>&1; then
        curl -fsSL "$download_url" -o "$temp_file"
    else
        wget -q "$download_url" -O "$temp_file"
    fi
    [ -s "$temp_file" ] || { print_error "Download failed: ${download_url}"; exit 1; }
    chmod +x "$temp_file"

    if [ -n "$sudo_cmd" ]; then
        $sudo_cmd mkdir -p "$install_dir"
        $sudo_cmd mv "$temp_file" "$final_path"
    else
        mkdir -p "$install_dir"
        mv "$temp_file" "$final_path"
    fi

    print_status "Installed to ${final_path}"
    if ! dir_in_path "$install_dir"; then
        print_warning "Add to PATH: export PATH=\"${install_dir}:\$PATH\""
    fi
}

main() {
    if ! command -v curl >/dev/null 2>&1 && ! command -v wget >/dev/null 2>&1; then
        print_error "Need curl or wget"
        exit 1
    fi

    print_status "Installing Praxis site/client CLI..."
    resolve_release
    TMP_DIR=$(mktemp -d "${TMPDIR:-/tmp}/praxis-cli.XXXXXX")
    PLATFORM=$(detect_platform)
    print_status "Platform: ${PLATFORM}"
    INSTALL_DIR=$(get_install_dir)
    SUDO_CMD=$(get_sudo_cmd "$INSTALL_DIR")
    install_cli "$PLATFORM" "$INSTALL_DIR" "$SUDO_CMD"
    print_status "Done. Try: pangolin --help"
}

main "$@"
