#!/bin/bash
set -e
set -o pipefail

add_rpmfusion() {
        sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora)".noarch.rpm
}

base() {
        sudo dnf check-update
        sudo dnf upgrade -y

        sudo dnf install -y \
                atool \
                bash-completion \
                cifs-utils \
                curl \
                fd-find \
                foot \
                fzf \
                git \
                gcc \
                g++ \
                htop \
                jq \
                libcaca \
                lynx \
                make \
                neovim \
                poppler \
                ranger \
                ripgrep \
                ShellCheck \
                tig \
                tmux \
                tree \
                vim \
                wget \
                w3m \
                xclip \
                zip

        sudo dnf autoremove -y
}

install_wm() {
        sudo dnf check-update
        sudo dnf upgrade -y

        sudo dnf install -y \
                dunst \
                sway \
                wofi \
                wl-clipboard \
                waybar \
                grim \
                slurp

        sudo dnf autoremove -y
}

install_misc() {
        sudo dnf check-update
        sudo dnf upgrade -y

        add_rpmfusion;

        sudo dnf install -y \
                arandr \
                chromium \
                ffmpeg \
                firefox \
                fontawesome-fonts \
                gnome-tweaks \
                keepassxc \
                newsboat \
                mpd \
                mpc \
                ncmpcpp \
                pandoc \
                syncthing \
                thunderbird \
                wireguard-tools

        sudo dnf autoremove -y
}

install_docker() {
        sudo dnf -y install dnf-plugins-core

        sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
        sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

        sudo systemctl daemon-reload
        sudo systemctl enable docker
        sudo systemctl start docker
}

start_service() {
        mkdir ~/.mpd
        systemctl --user enable mpd
        systemctl --user start mpd
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
        rustup component add rust-src
        rustup component add rust-analyzer
        rustup component add clippy
}

# based on https://github.com/jessfraz/dotfiles/blob/master/bin/install.sh
install_golang() {
        export GO_VERSION
        GO_VERSION=$(curl -sSL "https://golang.org/VERSION?m=text" | head -1)
        export GO_SRC=/usr/local/go

        # if we are passing the version
        if [[ -n "$1" ]]; then
                GO_VERSION=$1
        fi

        # purge old src
        if [[ -d "$GO_SRC" ]]; then
                sudo rm -rf "$GO_SRC"
                #sudo rm -rf "$GOPATH"
        fi

        GO_VERSION=${GO_VERSION#go}

        # subshell
        (
        kernel=$(uname -s | tr '[:upper:]' '[:lower:]')
        curl -sSL "https://storage.googleapis.com/golang/go${GO_VERSION}.${kernel}-amd64.tar.gz" | sudo tar -v -C /usr/local -xz
        )

        # get tools
        (
        set -x
        set +e
        # tools for go
        go install golang.org/x/tools/gopls@latest
        go install honnef.co/go/tools/cmd/staticcheck@latest
        go install golang.org/x/tools/cmd/goimports@master
        go install mvdan.cc/gofumpt@latest
        go install golang.org/x/vuln/cmd/govulncheck@latest
        go install golang.org/x/lint/golint@master
        )
}

usage() {
        echo -e "install.sh\\n\\tThis script install my basic setup for fedora\\n"
        echo "Usage:"
        echo "  base      - install base packages"
        echo "  full      - install base, wm and desktop"
        echo "  wm        - install window manager"
        echo "  apps      - install desktop pkgs"
        echo "  rust      - install rust"
        echo "  golang    - install go"
        echo "  docker    - install docker"
        echo "  scripts   - install scripts"
        echo "  services  - enable/start services"
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
        elif [[ $arg == "wm" ]]; then
                install_wm
        elif [[ $arg == "misc" ]]; then
                install_misc
        elif [[ $arg == "docker" ]]; then
                install_docker
        elif [[ $arg == "rust" ]]; then
                install_rust
        elif [[ $arg == "golang" ]]; then
                install_golang "$2"
        elif [[ $arg == "scripts" ]]; then
                install_scripts
        elif [[ $arg == "services" ]]; then
                start_service
        else
                usage
        fi
}

main "$@"
