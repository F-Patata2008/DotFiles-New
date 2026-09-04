#!/bin/bash
# ==============================================================================
# CORE DOTFILES INSTALLATION ENTRYPOINT (V6.0 MODULAR WRAPPER)
# Redirects to the unified, distro-aware install.sh
# ==============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "$SCRIPT_DIR/install.sh" "$@"
