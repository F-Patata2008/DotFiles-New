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

# Network
alias wifi='nmcli dev wifi list --rescan yes'
alias celu='nmcli dev wifi connect "Doxiado" --ask'
alias papo="nmcli dev wifi connect \"Alvaro's A53\" --ask"
alias movil="nmcli dev wifi connect WHATSAPP-COLLI --ask"

# CPU / Power Profiles for Ryzen 3 3250U
alias set-powersave="echo powersave | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor && echo power | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference"
alias set-balanced="echo schedutil | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor && echo balance_power | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference"
alias set-performance="echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor && echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference"
