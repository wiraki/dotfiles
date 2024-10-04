# ssh alias to fix keybind problems on remote ssh
alias ssh="kitty +kitten ssh"

# less alias to never chop long lines
alias less="less -S -r"

# Alias for neovim
alias vi="lvim"

# Alias for Codium to code
# alias code="codium"

# Alias ll
alias ll="eza --long --icons --all --group --time-style=long-iso --git --color-scale all --color always"
alias ls="eza -G --icons --color always"

# Alias for bat to remove some decorations
# alias bat="bat -p"

# Alias to view images in terminal
# ImageMagick must be installed for icat kitten to work.
alias icat="kitty +kitten icat"

# Alias for tidy-viewer (https://github.com/alexhallam/tv)
alias tv="tidy-viewer"

# show file previews for fzf using bat
alias fp="fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'"

# ripgrep
alias grep="rg"
alias rg="rg -SN"

# Alias for advcpmv (cp and mv with progress bar)
alias cp="/usr/local/bin/advcp -g"
alias mv="/usr/local/bin/advmv -g"

# Switch lazyvim configs
alias zvim='NVIM_APPNAME=nvim-lazyvim nvim' # LazyVim
alias kvim='NVIM_APPNAME=nvim-kick nvim' # Kickstart
alias qvim='NVIM_APPNAME=nvim-quarto nvim' # Quarto

# Make shorter alias for lazygit
alias lg='lazygit'

# Alias to cd to the git repo root
alias cdr='cd $(git rev-parse --show-toplevel)'

# Alias for fastfetch with preset
alias ffetch='fastfetch -c examples/12.jsonc'

# Alias for glow
alias glow='glow --pager'

