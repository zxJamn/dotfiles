# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# --- Zsh Plugin Management ---
# It's generally recommended to load Oh My Zsh and then your theme,
# before manually sourcing other plugins for better control.

ZSH_THEME="powerlevel10k/powerlevel10k"

# Define Oh My Zsh plugins (only git, as requested)
plugins=(git)

# Initialize Oh My Zsh
# This should be sourced relatively early as it sets up core Zsh features.
source "$ZSH/oh-my-zsh.sh"

# --- Completion System ---
# compinit should be called after oh-my-zsh.sh and before any plugins that depend on it.
autoload -Uz compinit

# Only run compinit if the completion dump file doesn't exist or is outdated.
# This makes startup faster by skipping compinit's potentially slow checks.
# `-d` checks if a directory in fpath has changed.
# `-C` forces checking for new completions in fpath.
if [ -z "$_compinit_done" ]; then
  if [[ -n "$ZDOTDIR" && ! -d "$ZDOTDIR" ]]; then
    mkdir -p "$ZDOTDIR"
  fi
  compinit -d "${ZDOTDIR:-$HOME}/.zcompdump" -C
  typeset -g _compinit_done=1 # Mark compinit as done for the current session
fi

zstyle ':completion:*' rehash true


# --- Third-Party Zsh Plugins (Manual Source) ---
# It's good practice to group these.
# Ensure syntax highlighting is LAST, as per its requirements.

# fzf-tab (adds fzf-powered tab completion UI)
if [[ -f "/usr/share/zsh/plugins/fzf-tab-source/fzf-tab.plugin.zsh" ]]; then
  source "/usr/share/zsh/plugins/fzf-tab-source/fzf-tab.plugin.zsh"
fi

# zsh-autosuggestions
if [[ -f "/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
  source "/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# zsh-vi-mode
if [[ -f "/usr/share/zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh" ]]; then
  source "/usr/share/zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh"
fi

# zsh-syntax-highlighting — must be last
if [[ -f "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
  source "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# --- Environment Variables and PATH Adjustments ---
# Place these before aliases if aliases depend on them.
# Use arrays for PATH for better handling, then join them.
typeset -a path_elements
path_elements=(
  "$HOME/.local/bin"
  "$HOME/bin"
  "/home/jam/.spicetify"
)

# Add elements to PATH if they exist and are not already there
for p in "${path_elements[@]}"; do
  if [[ -d "$p" && -z "$(echo "$PATH" | grep -o -w "$p")" ]]; then # Added quotes for robustness
    export PATH="$p:$PATH"
  fi
done

# Environment variables
export NVM_DIR="$HOME/.nvm"
# Check if nvm.sh exists and source it.
# The `|| return 1` is a common pattern to stop sourcing if nvm init fails.
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" || return 1
# This loads nvm bash_completion - should be after nvm.sh
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" || return 1

# Optional environment variables
# export GTK_THEME=Adwaita-dark # Uncomment if you need this theme

# --- Aliases ---
alias pacup='sudo pacman -Rns $(pacman -Qdtq)'
alias grep='grep --color=auto'
alias pool='clear && asciiquarium'
alias bye='sudo shutdown -h now'
alias loop='sudo reboot'
alias h='dbus-launch Hyprland'
alias fonts='fc-list -f "%{family}\n"'
alias tasks='btm'
alias n="nvim"
alias yt-download='yt-dlp --concurrent-fragments 8 -f "bestvideo+bestaudio" --merge-output-format mp4'
alias f='clear && fastfetch'

# --- Key Bindings ---
# Optional: Bind Tab to cycle completions
# bindkey "^I" menu-complete

# --- User Configuration and Styling ---
# Place custom styles and prompt customization after all plugins are loaded.

# Style overrides for zsh-syntax-highlighting
# Ensure these are applied AFTER zsh-syntax-highlighting is sourced.
if (( ${+ZSH_HIGHLIGHT_STYLES} )); then
  ZSH_HIGHLIGHT_STYLES[default]='fg=cyan'
  ZSH_HIGHLIGHT_STYLES[command]='fg=cyan'
  ZSH_HIGHLIGHT_STYLES[alias]='fg=cyan'
  ZSH_HIGHLIGHT_STYLES[builtin]='fg=cyan'
  ZSH_HIGHLIGHT_STYLES[function]='fg=cyan'
  ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=cyan'
  ZSH_HIGHLIGHT_STYLES[precommand]='fg=cyan'
  ZSH_HIGHLIGHT_STYLES[comment]='fg=cyan'
  ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=cyan,bold'
fi

# Style for zsh-autosuggestions
# Ensure this is applied AFTER zsh-autosuggestions is sourced.
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=cyan'

# --- Last: Powerlevel10k Configuration ---
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# This should always be the very last thing to source, as it configures the prompt itself.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
