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

This playbook is designed to be run during an OCI image build of Fedora Silverblue to slipstream in all necessary customizations. Don't try to run this outside of that environment,
as it won't work.

Note that this playbook makes a ton of assumptions about the environment in which it is being run and is therefore unsuitable for general use.

This is based _heavily_ off of the work done by Jim Campbell in his excellent (ansible-silverblue-oci)[https://github.com/j1mc/ansible-silverblue-oci] repository, thank you!

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
