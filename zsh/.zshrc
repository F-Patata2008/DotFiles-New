#fastfetch  # <-- REMOVE THIS, IT'S JUST A COMMENT

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
# This should be at the end.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# --- Display fastfetch after the prompt is ready ---
# This function runs fastfetch and then removes itself so it only runs once.
_p10k_fastfetch() {
  fastfetch
  # Unregister this function so it doesn't run on every prompt.
  precmd_functions=(${precmd_functions:#_p10k_fastfetch})
}

# Add the function to the list of commands to run before the prompt.
precmd_functions+=(_p10k_fastfetch)
# REMOVE fastfetch from the very end if it's still there.
