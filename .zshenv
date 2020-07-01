ZDOTDIR=$HOME/.config/zsh
EDITOR="emacsclient -c -n -a=' '"
BROWSER="firefox"
export XAUTHORITY="$XDG_RUNTIME_DIR"/Xauthority
export XDG_DATA_HOME="$HOME"/.local/share
export XDG_CONFIG_HOME="$HOME"/.config
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
export GHCUP_INSTALL_BASE_PREFIX="$HOME"/.local/share
export CLION_JDK=/opt/intellij-idea-ce/jbr/
export PATH="$PATH:$HOME/.local/bin:$HOME/.local/share/cargo/bin:$HOME/.local/share/.ghcup/bin:$HOME/.cabal/bin:$HOME/.config/emacs/bin"
