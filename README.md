Dotfiles
============

These are my dotfiles. It's an ansible playbook, designed to be bootstrapped manually with `ansible-playbook` and then self-managing with `ansible-pull`.

## Ansible?

Yeah, Ansible. For years and years I managed my dotfiles with GNU Stow, which is a fantastic tool that does its job admirably. However, configs on different computers drifted in
and out of sync, and Stow doesn't manage actually installing the programs that use the configs, which was arguably a bigger part of my new-computer-who-dis bootstrap process. I
never did come up with a good solution for that, until I finally just sat down and started writing down all my ad-hoc installations in the form of this playbook.

Now I can keep everything up to date and pristine automagically. This playbook can go from a vanilla install all the way to a fully-customized and prepped environment without any
user interaction, and it'll keep everything up-to-date with the remote repository without any action on my part. I can just keep using my computer and everything stays up-to-date.

## Prerequisites

This playbook is designed to run on either Ubuntu, Fedora, or MacOS. It will gracefully fail to run on any other distribution.

This playbook is designed to be run as the user account you're gonna use in your day-to-day work. So don't run this as root or with sudo! For remote deployment, make sure you have passwordless SSH set up prior
to running the playbook otherwise it won't work. 

Note that this user account needs to again have passwordless sudo on the local computer. Check that you have the necessary permissions with `sudo -l` prior to deployment:

```sh
❯ sudo -l
[... some output elided ...]

User sramanujam@sriramanujam.lan may run the following commands on hapes:
    (ALL : ALL) NOPASSWD: ALL
```
Anything less permissive than this is not supported and may fail to deploy.

### MacOS

For MacOS specifically, you will need to have Homebrew installed and configured prior to invoking the playbook. It is recommended to then install Ansible via Homebrew.
You will also need the `community.general` collection installed at the global scope for this playbook on Mac hosts. Install it with `ansible-galaxy collection install community.general`.

## Deployment

Deploying this playbook is simple. Simply clone this repository down and run either of the following, depending on your circumstances:

```sh
# Deploy the playbook to the current computer
ansible-playbook -i localhost, --connection=local ./local.yml

# Deploy the playbook to a remote computer
ansible-playbook -i <ip-or-hostname>, --user <remote-user-youre-gonna-login-as> ./local.yml
```
