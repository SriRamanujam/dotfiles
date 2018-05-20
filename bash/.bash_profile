#
# ~/.bash_profile
#
[[ -f /etc/profile ]] && . /etc/profile

if [[ $(grep -q "Microsoft" /proc/version) ]]; then
    umask 022
    export DISPLAY=:0
    export LIBGL_ALWAYS_INDIRECT=1
fi

[[ -f ~/.bashrc ]] && . ~/.bashrc
