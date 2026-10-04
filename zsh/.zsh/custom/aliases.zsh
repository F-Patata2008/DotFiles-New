# Quick directory navigation
alias clases='cd ~/Apunte/'
alias PE='nvim ~/Apunte/Probabilidad\ y\ Estadistica/Apunte/Apunte.tex'
alias g++='clang++'
alias prob='cd ~/Apunte/Probabilidad\ y\ Estadistica/'

# System utilities
alias please='sudo $(fc -ln -1)'
alias update='bash ~/.config/hypr/scripts/update.sh'
alias ff='clear; fastfetch'
alias cl='clear; tree -d'
alias reload='clear; exec zsh'

# Hardware & Biometrics
alias arduino='sudo chmod a+rw /dev/ttyACM0'
alias icat="kitty +kitten icat"
alias finger="sudo systemctl restart fprintd.service"

# Network & Remote Access
alias wifi='nmcli dev wifi list --rescan yes'
alias celu='nmcli dev wifi connect "Doxiado" --ask'
alias papo="nmcli dev wifi connect \"Alvaro's A53\" --ask"
alias movil="nmcli dev wifi connect WHATSAPP-COLLI --ask"

# Kitty SSH wrapper: transparently clones xterm-kitty terminfo to remote servers
if [[ -n "$KITTY_PID" || "$TERM" == "xterm-kitty" ]]; then
    alias ssh="kitten ssh"
fi
# Direct fallback for minimal systems, rescue environments, or routers
alias xssh="TERM=xterm-256color \ssh"

# CPU / Power Profiles for Ryzen 3 3250U (Native D-Bus via powerprofilesctl / Tuned)
alias set-powersave="powerprofilesctl set power-saver 2>/dev/null || tuned-adm profile powersave"
alias set-balanced="powerprofilesctl set balanced 2>/dev/null || tuned-adm profile balanced"
alias set-performance="powerprofilesctl set performance 2>/dev/null || tuned-adm profile throughput-performance"
