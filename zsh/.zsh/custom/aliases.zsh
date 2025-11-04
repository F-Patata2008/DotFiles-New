#alias nv='nvim'

alias clases='cd ~/Apunte/'
alias PE='nvim ~/Apunte/Probabilidad\ y\ Estadistica/Apunte/Apunte.tex'
alias prob='cd ~/Apunte//Probabilidad\ y\ Estadistica/'


alias please='sudo $(fc -ln -1)'
alias update='sh $HOME/Dotfiles/hypr/.config/hypr/scripts/update.sh'

alias 'exec zsh'='clear; exec zsh'
alias tl='java -jar ~/Desktop/TLauncher.v16/TLauncher.jar'
alias cl='clear; tree'
alias arduino='sudo chmod a+rw /dev/ttyACM0'


alias wifi='nmcli dev wifi list --rescan yes'
alias celu='nmcli dev wifi connect "Doxiado" --ask'
alias papo="nmcli dev wifi connect \"Alvaro's A53\" --ask"
alias movil="nmcli dev wifi connect WHATSAPP-COLLI --ask"

# My custom power profiles for TLP
alias set-powersave="echo powersave | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor && echo power | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference"
alias set-balanced="echo schedutil | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor && echo balance_power | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference"
alias set-performance="echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor && echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference"
