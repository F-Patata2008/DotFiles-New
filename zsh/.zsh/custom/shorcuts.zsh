# ==============================================================================
# Zsh Named Directory Shortcuts (hash -d)
# Enables `cd ~Name` with instant tab-completion and `$Name` variable access
# ==============================================================================

# Atajos Probabilidad y Estadistica
export Apunte="$HOME/Clases/Probabilidad y Estadistica/Apunte"
export Trabajo="$HOME/Clases/Probabilidad y Estadistica/Trabajos"
export Proyecto="$HOME/Clases/Probabilidad y Estadistica"
hash -d Apunte="$Apunte"
hash -d Trabajo="$Trabajo"
hash -d Proyecto="$Proyecto"

# Atajo ZSH
export bash="$HOME/.oh-my-zsh/custom"
hash -d bash="$bash"

# Atajos Programacion & Robotica
export C="$HOME/Progra/CIPC"
export Python="$HOME/Progra/Python"
export arduino="$HOME/Arduino"
hash -d C="$C"
hash -d Python="$Python"
hash -d arduino="$arduino"
