autoload -U colors && colors
bindkey -e
_comp_options+=(globdots)

PS1="%{$fg[magenta]%}%~%{$fg[red]%} %{$reset_color%}$%b "

finder() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        open .
    else
        xdg-open . &>/dev/null
    fi
}
zle -N finder
bindkey '^f' finder

mkcd() {
    mkdir -p "$1" && cd "$1"
}

normalize() {
    ffmpeg -i "$1" -af loudnorm=I=-14:TP=-1.0:LRA=11 -c:v copy -c:a aac -b:a 192k output.mp4
}

export EDITOR="nvim"
export MANPAGER="nvim +Man!"
export RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep/rgrc"

typeset -U path
path=(
    "$HOME/.local/share/bob/nvim-bin"
    "$HOME/.local/bin"
    "$HOME/.cargo/bin"
    "/usr/local/bin"
    $path
)

export GG_HOME="$HOME/documents/work"
export GG_API="$GG_HOME/gg-api"
export GG_WEB="$GG_HOME/esports-web/gg-web"
export GG_EW="$GG_HOME/esports-web"
export GG_GCP_USERNAME="rudolf"
export NODE_ENV=development

[[ -d "$GG_API/ops/bin" ]] && path=("$GG_API/ops/bin" $path)

export NVM_DIR="$HOME/.nvm"
lazy_load_nvm() {
    unset -f node nvm npm npx
    [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
    [[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"
}
node() { lazy_load_nvm; node "$@" }
nvm()  { lazy_load_nvm; nvm "$@" }
npm()  { lazy_load_nvm; npm "$@" }

if [[ -d "$HOME/.pyenv" ]]; then
    export PYENV_ROOT="$HOME/.pyenv"
    path=("$PYENV_ROOT/bin" $path)
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
fi

alias vim="nvim"
alias vi="nvim"
alias im="nvim"
alias ls="ls -C -A -p --color=auto"
alias src="source ~/.zshrc"
alias p="poetry"
alias venv="source .venv/bin/activate"

alias cd-ew="cd ${GG_EW}"
alias cd-w="cd ${GG_WEB}"
alias cd-a="cd ${GG_API}"

alias dl-audio="yt-dlp -x --audio-format=\"mp3\""

if [[ "$OSTYPE" == "darwin"* ]]; then
    alias love="/Applications/love.app/Contents/MacOS/love"
else
    alias love="love"
fi

[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
source <(fzf --zsh) 2>/dev/null

for file in \
    /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
    /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
    /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh; do
    [[ -f "$file" ]] && source "$file" && break
done

for file in \
    /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
    /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh \
    /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh; do
    [[ -f "$file" ]] && source "$file" && break
done

autoload -U compinit && compinit
