fastfetch

# Enable Powerlevel10k instant prompt. Should stay at the very top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the Oh My Zsh theme to load.
ZSH_THEME="powerlevel10k/powerlevel10k"

# Zsh plugins to load.
plugins=(
    git
    colored-man-pages
    command-not-found
    cp
    archlinux
    autojump
    themes
    zsh-autosuggestions
    zsh-syntax-highlighting
)

# Source Oh My Zsh.
source $ZSH/oh-my-zsh.sh

# Source autojump script.
# This needs to be done on Arch after installing the package.
[ -f /etc/profile.d/autojump.zsh ] && . /etc/profile.d/autojump.zsh

# --- User Configuration ---

# Preferred editor
export EDITOR='nvim'

# Custom aliases
# Add your Arch-specific aliases from the archlinux plugin here if you want to override them
# alias pacupg='sudo pacman -Syu'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# This should be at the end.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
