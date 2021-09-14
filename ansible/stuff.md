Stuff to install on a new dev machine
---

Graphical installs only:

* Slack (flathub)
* Quassel (dnf)
* Bitwarden (flathub)
* virt-manager (dnf)

Graphical installs on fedora:
    * Ubuntu GNOME theme (yaru) (dnf)

dev tooling
* nvm (custom script)
* rvm (custom script)


If a laptop:
    * Configure power saving based on model
    * powertop --auto-tune, maybe?
    * GDM scaling factor and enabling fractional scaling if required
        * Note that this has to be laptop specific
        * Enabling fractional scaling for GDM is super annoying too
            * ```su - gdm -s /bin/bash
dbus-launch --exit-with-session dconf write /org/gnome/mutter/experimental-features "['scale-monitor-framebuffer']"```

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
