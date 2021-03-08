#
# ~/.bash_profile
#
[[ -f /etc/profile ]] && . /etc/profile

if $(grep -q "Microsoft" /proc/version); then
    umask 022
    export DISPLAY=:0
    export DOCKER_HOST="192.168.39.2:2375"
fi

[[ -f ~/.bashrc ]] && . ~/.bashrc

export PATH="$HOME/.poetry/bin:$PATH"
