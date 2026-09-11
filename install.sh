#!/bin/bash
# ==============================================================================
# PATATA'S DOTFILES MASTER INSTALLATION ENTRYPOINT
# Forwards execution to Install/install.sh
# ==============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "$SCRIPT_DIR/Install/install.sh" "$@"
