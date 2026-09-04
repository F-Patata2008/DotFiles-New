#!/bin/bash
# ==============================================================================
# Polkit Authentication Agent Launcher (Distro-Agnostic)
# Automatically searches for and executes the first available Polkit agent.
# ==============================================================================

CANDIDATES=(
    "/usr/libexec/hyprpolkitagent"
    "/usr/lib/hyprpolkitagent"
    "$(command -v hyprpolkitagent 2>/dev/null)"
    "/usr/libexec/polkit-gnome-authentication-agent-1"
    "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"
    "/usr/libexec/kf6/polkit-kde-authentication-agent-1"
    "/usr/lib/polkit-kde-authentication-agent-1"
    "/usr/libexec/polkit-mate-authentication-agent-1"
    "/usr/lib/mate-polkit/polkit-mate-authentication-agent-1"
    "/usr/libexec/lxqt-policykit-agent"
)

for agent in "${CANDIDATES[@]}"; do
    if [[ -n "$agent" && -x "$agent" ]]; then
        # Check if already running to prevent duplicate spawns
        agent_name=$(basename "$agent")
        if pgrep -x "$agent_name" > /dev/null 2>&1; then
            exit 0
        fi
        exec "$agent" &
        exit 0
    fi
done

echo "[WARN] No graphical polkit authentication agent found in system." >&2
