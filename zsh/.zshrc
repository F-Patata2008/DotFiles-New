fastfetch  # <-- REMOVE THIS, IT'S JUST A COMMENT

# Enable Powerlevel10k instant prompt. Should stay at the very top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the Oh My Zsh theme to load.
ZSH_THEME="powerlevel10k/powerlevel10k"
typeset -g POWERLEVEL9K_INSTANT_PROMPT=off  # <-- REMOVE THIS LINE
export PATH=$HOME/.local/bin:$PATH
export PATH="$PATH:$(go env GOPATH)/bin"

# Function to open nvim with current directory if no arguments are given
nv() {
  if [ $# -eq 0 ]; then
    # No arguments were provided, so run nvim in the current directory
    nvim .
  else
    # Arguments were provided, so pass them all to nvim
    nvim "$@"
  fi
}


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
export BROWSER='opera'


# +++ ADD THIS BLOCK +++
# Load all custom .zsh files (like aliases.zsh and shortcuts.zsh)
# The path ~/.zsh/custom works because 'stow' symlinks ~/Dotfiles/zsh to ~/.zsh
for file in ~/.zsh/custom/*.zsh; do
  if [ -r "$file" ]; then
    source "$file"
  fi
done
# +++ END OF BLOCK +++


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# Run fastfetch once, right before the first prompt is drawn
run_fastfetch_once() {
  fastfetch
  # Unregister this function so it only runs once per session
  precmd_functions=(${precmd_functions[@]/run_fastfetch_once})
}
#precmd_functions+=(run_fastfetch_once)
#
#
bindkey '^W' backward-kill-word
