#!/bin/bash

add_rpmfusion() {
        sudo dnf install   https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
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

# install rust
install_rust() {
        curl https://sh.rustup.rs -sSf | sh
}

usage() {
        echo -e "install.sh\\n\\tThis script install my basic setup for fedora\\n"
        echo "Usage:"
        echo "base      - install base packages"
        echo "full      - install base, wm and desktop"
        echo "wm        - install window manager"
        echo "misc      - install desktop apps"
}

main() {
        local arg=$1

        if [[ -z "$arg" ]]; then
                usage
                exit 1
        elif [[ $arg = "base" ]]; then
                base
        elif [[ $arg = "full" ]]; then
                base
                install_misc
                install_wm
        elif [[ $arg = "wm" ]]; then
                install_wm
        elif [[ $arg = "misc" ]]; then
                install_misc
        else
                usage
        fi
}

main "$@"
