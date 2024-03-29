.PHONY: all
all: dotfiles bin ## Installs the dotfiles and bin directory

.PHONY: dotfiles
dotfiles: ## Install dotfiles
	ln -snf $(CURDIR)/.aliases $(HOME)/.aliases;
	ln -snf $(CURDIR)/.bash_profile $(HOME)/.bash_profile;
	ln -snf $(CURDIR)/.bashrc $(HOME)/.bashrc;
	ln -snf $(CURDIR)/.bash_prompt $(HOME)/.bash_prompt;
	ln -snf $(CURDIR)/.exports $(HOME)/.exports;
	ln -snf $(CURDIR)/.functions $(HOME)/.functions;
	ln -snf $(CURDIR)/.gitconfig $(HOME)/.gitconfig;
	ln -snf $(CURDIR)/gitignore_global $(HOME)/.gitignore_global;
	#ln -snf $(CURDIR)/.gtkrc-2.0 $(HOME)/.gtkrc-2.0;
	ln -snf $(CURDIR)/.inputrc $(HOME)/.inputrc;
	ln -snf $(CURDIR)/.path $(HOME)/.path;
	ln -snf $(CURDIR)/.tmux.conf $(HOME)/.tmux.conf;
	ln -snf $(CURDIR)/.Xmodmap $(HOME)/.Xmodmap;
	ln -snf $(CURDIR)/.xinitrc $(HOME)/.xinitrc;
	ln -snf $(CURDIR)/.Xresources $(HOME)/.Xresources;
	xrdb -merge $(HOME)/.Xresources || true
	git update-index --skip-worktree $(CURDIR)/.gitconfig;
	mkdir -p $(HOME)/.config;
	#ln -snf $(CURDIR)/config/gtk-3.0/settings.ini $(HOME)/.config/gtk-3.0/settings.ini;
	ln -snf $(CURDIR)/config/i3 $(HOME)/.config/i3;
	ln -snf $(CURDIR)/config/dunst $(HOME)/.config/dunst;
	ln -snf $(CURDIR)/config/mpd $(HOME)/.config/mpd;
	ln -snf $(CURDIR)/config/ncmpcpp $(HOME)/.config/ncmpcpp;
	ln -snf $(CURDIR)/config/ranger $(HOME)/.config/ranger;
	ln -snf $(CURDIR)/config/sway $(HOME)/.config/sway;
	ln -snf $(CURDIR)/config/waybar $(HOME)/.config/waybar;
	ln -snf $(CURDIR)/config/wofi $(HOME)/.config/wofi;

.PHONY: bin
bin: ## Sym link the bin dicretory files
	mkdir -p $(HOME)/.local/bin
	for file in $(shell find $(CURDIR)/bin -type f); do \
		f=$$(basename $$file); \
		ln -sf $$file $(HOME)/.local/bin/$$f; \
	done

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
