#!/usr/bin/env bash
set -euo pipefail

BIN_NAME="sqlfmt"
INSTALL_DIR="${HOME}/bin"
TARGET="${INSTALL_DIR}/${BIN_NAME}"

mkdir -p "${INSTALL_DIR}"

cp "./${BIN_NAME}" "${TARGET}"
chmod +x "${TARGET}"

# Check if INSTALL_DIR is on PATH
if [[ ":$PATH:" != *":${INSTALL_DIR}:"* ]]; then
    # Determine which shell config to update
    SHELL_PROFILE=""
    if [[ -n "${ZSH_VERSION:-}" ]]; then
        SHELL_PROFILE="${HOME}/.zshrc"
    elif [[ -n "${BASH_VERSION:-}" ]]; then
        SHELL_PROFILE="${HOME}/.bashrc"
    else
        # Default to profile
        SHELL_PROFILE="${HOME}/.profile"
    fi

    echo "export PATH=\"\${PATH}:${INSTALL_DIR}\"" >> "${SHELL_PROFILE}"
    echo "Added ${INSTALL_DIR} to PATH in ${SHELL_PROFILE}"
else
    echo "${INSTALL_DIR} already in PATH"
fi

echo "Installed to ${TARGET}"
echo ""
echo "Run 'source ${SHELL_PROFILE}' or restart your terminal to use 'sqlfmt'"
