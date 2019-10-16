.PHONY: all
all: dotfiles

.PHONY: dotfiles
dotfiles: ## Install dotfiles
	ln -snf $(CURDIR)/.aliases $(HOME)/.aliases;
	ln -snf $(CURDIR)/.bash_profile $(HOME)/.bash_profile;
	ln -snf $(CURDIR)/.bashrc $(HOME)/.bashrc;
	ln -snf $(CURDIR)/.bash_prompt $(HOME)/.bash_prompt;
	ln -snf $(CURDIR)/.exports $(HOME)/.exports;
	ln -snf $(CURDIR)/.functions $(HOME)/.functions;
	ln -snf $(CURDIR)/.gitconfig $(HOME)/.gitconfig;
	ln -snf $(CURDIR)/gitignore $(HOME)/.gitignore;
	ln -snf $(CURDIR)/.gtkrc-2.0 $(HOME)/.gtkrc-2.0;
	ln -snf $(CURDIR)/.inputrc $(HOME)/.inputrc;
	ln -snf $(CURDIR)/.path $(HOME)/.path;
	ln -snf $(CURDIR)/.tmux.conf $(HOME)/.tmux.conf;
	ln -snf $(CURDIR)/.Xresources $(HOME)/.Xresources;
	xrdb -merge $(HOME)/.Xresources || true
	git update-index --skip-worktree $(CURDIR)/.gitconfig;
	mkdir -p $(HOME)/.config;
	ln -snf $(CURDIR)/config/Code/User/settings.json $(HOME)/.config/Code/User/settings.json;
	ln -snf $(CURDIR)/config/gtk-3.0/settings.ini $(HOME)/.config/gtk-3.0/settings.ini;
	ln -snf $(CURDIR)/config/i3 $(HOME)/.config/i3;
	ln -snf $(CURDIR)/config/mpd $(HOME)/.config/mpd;
	ln -snf $(CURDIR)/config/ranger $(HOME)/.config/ranger;

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

