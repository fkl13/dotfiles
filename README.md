# dotfiles

## Customizing

Save env vars, etc in a `.extra` file, that looks something like
this:

```bash
###
### Git credentials
###

GIT_AUTHOR_NAME="Your Name"
GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
git config --global user.name "$GIT_AUTHOR_NAME"
GIT_AUTHOR_EMAIL="email@you.com"
GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
git config --global user.email "$GIT_AUTHOR_EMAIL"
GH_USER="nickname"
git config --global github.user "$GH_USER"
```

## Acknowledgements

Inspiration and code was taken from many sources, including:

* [github.com/jessfraz/dotfiles](https://github.com/jessfraz/dotfiles).
* [github.com/mathiasbynens/dotfiles](https://github.com/mathiasbynens/dotfiles)
