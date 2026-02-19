==================================================================
 DUMP DE CONFIGURACIÓN: systemd/.config/systemd
 Fecha: Thu Feb 19 04:21:00 PM -03 2026
==================================================================


################################################################################
ARCHIVO: systemd/.config/systemd/user/hyprland-session.target
################################################################################

[Unit]
Description=Hyprland Session Target
Requires=graphical-session.target
After=graphical-session.target

################################################################################
ARCHIVO: systemd/.config/systemd/user/noctalia.service
################################################################################

[Unit]
Description=Noctalia Shell Service
PartOf=graphical-session.target
Requisite=graphical-session.target
After=graphical-session.target

[Service]
ExecStart=qs -c noctalia-shell --no-duplicate
Restart=on-failure
RestartSec=1

[Install]
WantedBy=graphical-session.target
