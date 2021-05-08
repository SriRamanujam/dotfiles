Stuff to install on a new dev machine
---

Graphical installs only:

* Slack (flathub)
* Visual Studio Code (dnf + custom repo)
* Quassel (dnf)
* Bitwarden (flathub)
* virt-manager (dnf)

Graphical installs on fedora:
    * Ubuntu GNOME theme (yaru) (dnf)

All installs:

* htop
* neovim
* most
* openssh server
* openssh client
* ripgrep
* rsync
* tmux
* unzip
* xz
* curl
* wget
* nc
* ansible + ansible-pull

dev tooling
* php
* rustup + latest stable rust toolchain (custom script)
* python3
* python3-virtualenv
* poetry
* nvm (custom script)
* rvm (custom script)

* podman
    * enable podman.socket for docker compose
* composer
* jq
* git
* git lfs

* latest versions of oc and kubectl from okd upstream
    * alias/symlink kubectl -> k
* terraform and packer using the hashicorp repo

* openshift tooling (extract from container? fetch from github release?)

If running under hyperv:
* hyperv daemons
* cifs-utils
    * configure fstab mount unit to automount ~/Documents/Temp

If ubuntu under hyperv:
* azure tuned kernel

Lay down dotfiles
    * bashrc
    * bash_profile
    * tmux conf
    * gitconfig
    * vim

** SET UP bashrc.d FOR SNIPPETS **

If in WSL env:
    * wsl config

If _not_ in wsl env:
    * ansible-pull service + timer

If a laptop:
    * Install and enable tlp
    * Config snippets in tlp.d per model??

======================================

bashrc.d

snippets to deploy:
    * vim configuration
    * ruby tooling env
    * rust/cargo env
    * podman config + aliases
    * nvm configuration
    * history options
    * various shell opts
    * bits and bobs of config
    * $PS1 config
    * term colors and dircolors
    * all my aliases
    * java options
    * ssh-agent configuration
    * go tooling
    * tmux aliases
