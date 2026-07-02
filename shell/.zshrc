autoload -U colors && colors
# PS1="%{$fg[red]%}%n%{$reset_color%}@%{$fg[blue]%}%m %{$fg[yellow]%}%~ %{$reset_color%}%% "

# export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
# zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# export CLICOLOR=1

export CLICOLOR=1
export LSCOLORS=ExGxBxDxCxEgEdxbxgxcxd
alias ll='ls -lGD "%b %e %Y %H:%M:%S"'

# code () { VSCODE_CWD="$PWD" open -n -b "com.microsoft.VSCode" --args $* ;}

export PATH=$HOME/.local/bin:/opt/homebrew/opt/llvm/bin:/opt/homebrew/opt/imagemagick-full/bin:$PATH
export LDFLAGS="-L$HOME/Downloads/OpenBLAS-0.3.26/lib -L/opt/homebrew/opt/lapack/lib -L/opt/homebrew/opt/openblas/lib -L/opt/homebrew/opt/llvm/lib"
export CPPFLAGS="-I/opt/homebrew/opt/lapack/include -I/opt/homebrew/opt/openblas/include -I/opt/homebrew/opt/llvm/include"
export PKG_CONFIG_PATH="/opt/homebrew/opt/openblas/lib/pkgconfig"

alias python="python3"

# neofetch
fastfetch


# >>> Added by Spyder >>>
alias uninstall-spyder=$HOME/Library/spyder-6/uninstall-spyder.sh
# <<< Added by Spyder <<<
