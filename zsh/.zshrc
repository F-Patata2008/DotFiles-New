# 1. THE INSTANT PROMPT (Must be at the very top)
# We set this to 'quiet' so it doesn't show warnings, but it MUST be active.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# 2. PATHS (Consolidated)
export PATH="$HOME/.local/bin:$(go env GOPATH)/bin:$PATH"
export ZSH="$HOME/.oh-my-zsh"

# 3. THEME & PROMPT CONFIG
ZSH_THEME="powerlevel10k/powerlevel10k"
# REMOVED: POWERLEVEL9K_INSTANT_PROMPT=off (This was the lag source!)

# 4. PLUGINS (Removed autojump and bloat)
# Note: 'z' is a built-in OMZ plugin that is 10x faster than 'autojump'
plugins=(
    git
    colored-man-pages
    archlinux
    z                   # <-- Fast alternative to autojump (no Python needed)
    zsh-autosuggestions
    zsh-syntax-highlighting
)

# 5. SOURCE OH-MY-ZSH (The "Heavy" part)
source $ZSH/oh-my-zsh.sh

# 6. USER LOGIC (Your custom nv function)
nv() {
  if [ $# -eq 0 ]; then
    nvim .
  else
    nvim "$@"
  fi
}

# 7. CUSTOM DOTFILES LOADER (Optimized)
# Using a glob check to prevent errors if the directory is empty
if [ -d ~/.zsh/custom ]; then
  for file in ~/.zsh/custom/*.zsh(N); do
    source "$file"
  done
fi

# 8. P10K CONFIG SOURCE
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# 9. PERFORMANCE HACK: FASTFETCH
# In UnixPorn videos, they don't run fastfetch on every shell start
# because it adds 100ms-200ms of lag.
# If you want it, keep it, but it's faster to just type 'ff' when you want to see it.
alias ff='fastfetch'

# 10. EDITOR & BROWSER
export EDITOR='nvim'
export BROWSER='zen'

# Keybinds
bindkey '^W' backward-kill-word
bindkey '^[[1;5C' forward-word       # Ctrl+Right
bindkey '^[[1;5D' backward-word      # Ctrl+Left
