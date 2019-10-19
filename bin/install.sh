#!/bin/bash

add_rpmfusion() {
        sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
}

base() {
        sudo dnf check-update
        sudo dnf upgrade -y

        sudo dnf install -y \
                atool \
                bash-completion \
                curl \
                fzf \
                git \
                htop \
                jq \
                libcaca \
                lynx \
                neovim \
                poppler \
                ranger \
                ripgrep \
                rxvt-unicode-256color \
                tig \
                tmux \
                tree \
                vim \
                wget \
                w3m \
                xclip \
                zip \

        sudo dnf autoremove -y
}

install_wm() {
        sudo dnf check-update
        sudo dnf upgrade -y

        sudo dnf install -y \
                feh \
                i3 \
                i3status \
                i3lock \
                dmenu \

        sudo dnf autoremove -y
}

install_misc() {
        sudo dnf check-update
        sudo dnf upgrade -y

        add_rpmfusion;

        sudo dnf install -y \
                arc-theme \
                chromium \
                ffmpeg \
                firefox \
                keepassxc \
                mozilla-fira-mono-fonts \
                mozilla-fira-sans-fonts \
                mozilla-fira-fonts-common \
                mpd \
                mpc \
                ncmpcpp \
                papirus-icon-theme \
                thunderbird \
                zathura \

        sudo dnf autoremove -y
}

# install custom scripts
install_scripts() {
        # install icdiff
        curl -sSL https://raw.githubusercontent.com/jeffkaufman/icdiff/master/icdiff > /usr/local/bin/icdiff
        curl -sSL https://raw.githubusercontent.com/jeffkaufman/icdiff/master/git-icdiff > /usr/local/bin/git-icdiff
        chmod +x /usr/local/bin/icdiff
        chmod +x /usr/local/bin/git-icdiff
}

# install rust
install_rust() {
        curl https://sh.rustup.rs -sSf | sh
}

# based on https://github.com/jessfraz/dotfiles/blob/master/bin/install.sh
install_golang() {
        export GO_VERSION
        GO_VERSION=$(curl -sSL "https://golang.org/VERSION?m=text")
        export GO_SRC=/usr/local/go

        # if we are passing the version
        if [[ -n "$1" ]]; then
                GO_VERSION=$1
        fi

        # purge old src
        if [[ -d "$GO_SRC" ]]; then
                sudo rm -rf "$GO_SRC"
                sudo rm -rf "$GOPATH"
        fi

        GO_VERSION=${GO_VERSION#go}

        # subshell
        (
        kernel=$(uname -s | tr '[:upper:]' '[:lower:]')
        curl -sSL "https://storage.googleapis.com/golang/go${GO_VERSION}.${kernel}-amd64.tar.gz" | sudo tar -v -C /usr/local -xz
        )
}

usage() {
        echo -e "install.sh\\n\\tThis script install my basic setup for fedora\\n"
        echo "Usage:"
        echo "  base      - install base packages"
        echo "  full      - install base, wm and desktop"
        echo "  wm        - install window manager"
        echo "  misc      - install desktop pkgs"
        echo "  rust      - install rust"
        echo "  golang    - install go"
        echo "  scripts   - install scripts"
}

main() {
        local arg=$1

        if [[ -z "$arg" ]]; then
                usage
                exit 1
        fi

        if [[ $arg == "base" ]]; then
                base
        elif [[ $arg == "full" ]]; then
                base
                install_misc
                install_wm
                install_scripts
        elif [[ $arg == "wm" ]]; then
                install_wm
        elif [[ $arg == "misc" ]]; then
                install_misc
        elif [[ $arg == "rust" ]]; then
                install_rust
        elif [[ $arg == "golang" ]]; then
                install_golang
        elif [[ $arg == "scripts" ]]; then
                install_scripts
        else
                usage
        fi
}

main "$@"
