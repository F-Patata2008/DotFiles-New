# 1. THE INSTANT PROMPT (Must be at the very top)
# We set this to 'quiet' so it doesn't show warnings, but it MUST be active.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# 2. PATHS (Consolidated & Fast - No fork subprocesses)
typeset -U path
path=(
    "$HOME/.local/bin"
    "$HOME/.cargo/bin"
    "$HOME/go/bin"
    "${GOPATH:-$HOME/go}/bin"
    "$HOME/.opencode/bin"
    "$HOME/.spicetify"
    $path
)
export PATH
export ZSH="$HOME/.oh-my-zsh"

# 3. THEME & PROMPT CONFIG
ZSH_THEME="powerlevel10k/powerlevel10k"

# 4. PLUGINS (Modular & Distro-Aware)
plugins=(
    git
    colored-man-pages
    z                   # Fast alternative to autojump
    zsh-autosuggestions
    zsh-syntax-highlighting
)

# Dynamically load distro plugins without hardcoded locks
if [[ -f /etc/arch-release ]]; then
    plugins+=(archlinux)
elif [[ -f /etc/fedora-release ]]; then
    plugins+=(dnf)
fi

# 5. SOURCE OH-MY-ZSH
source $ZSH/oh-my-zsh.sh

# 6. USER LOGIC
nv() {
  if [ $# -eq 0 ]; then
    nvim .
  else
    nvim "$@"
  fi
}

# 7. CUSTOM DOTFILES LOADER
if [ -d "$HOME/.zsh/custom" ]; then
  for file in "$HOME"/.zsh/custom/*.zsh(N); do
    source "$file"
  done
fi

# 8. P10K CONFIG SOURCE
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# 9. PERFORMANCE HACK: FASTFETCH
# Fastfetch can be summoned anytime using 'ff'

# 10. EDITOR, BROWSER & ENVIRONMENT
export EDITOR='nvim'
export BROWSER='zen'

if [[ -d "$HOME/Progra/Python/Yo/Codigo_fuente" ]]; then
    export PYTHONPATH="$HOME/Progra/Python/Yo/Codigo_fuente${PYTHONPATH:+:$PYTHONPATH}"
fi

# Keybinds
bindkey '^W' backward-kill-word
bindkey '^[[1;5C' forward-word       # Ctrl+Right
bindkey '^[[1;5D' backward-word      # Ctrl+Left
