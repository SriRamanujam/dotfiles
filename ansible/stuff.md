Stuff to install on a new dev machine
---

Graphical installs only:

* Slack
* Visual Studio Code
* Quassel
* Bitwarden
* virt-manager

Graphical installs on fedora:
    * Ubuntu GNOME theme (yaru)

All installs:

* htop
* jq
* podman
    * enable podman.socket for docker compose
* git
* git lfs
* neovim
* openssh server
* openssh client
* ripgrep
* rsync
* composer
* tmux
* unzip
* xz
* ansible + ansible-pull

dev tooling
* php
* rustup + latest stable rust toolchain
* python3
* python3-virtualenv
* poetry
* nvm
* rvm

If running under hyperv:
* hyperv daemons
* cifs-utils
    * configure fstab mount unit to automount ~/Documents/Temp

If ubuntu under hyperv:
* azure tuned kernel
