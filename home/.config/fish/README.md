# Fish Config

[![License: Unlicense](https://img.shields.io/badge/license-Unlicense-green.svg)](http://unlicense.org/)

Custom fish shell configurations because I prefer not to use a package manager.

## Overview

### Custom fish prompt

```plaintext
[ username@hostname :: /current/working/directory ] -> { git_branch }
 >
```

### Builtin functions wrapper

#### cd
  
| Option | Value     | Description                |
| -------- | ------- | ------------------------- |
| `-l` | `none` | Show cd history of this fish session |
| `-i` | `number` |  Go to directory at index `number` in  the history of this session |

### Shortform commands
  - `cls` = `clear`
  - `q` = `exit`
  - `l` = `ls -lhA --ignore=lost+found --color=always`
  - `vim` = `nvim` (If neovim is installed. Why use vim when you install neovim already.)

### Abbreviations

#### Apt

| Abbreviation | Full command | Note                |
| -------- | ------- | ------------------------- |
| `pud` | `sudo apt update` | |
| `prm` | `sudo apt purge` | |
| `pcl` | `sudo apt autoclean; sudo apt autoremove` | |
| `pss` | `apt-cache search` | |
| `pfm` | `sudo apt install --fix-missing` | |
| `pit` | `sudo apt install -y` | |
| `pit` | `sudo apt-fast install -y` | `apt-fast` is installed |
| `pug` | `sudo apt upgrade` | |
| `pug` | `sudo apt-fast upgrade` | `apt-fast` is installed |
| `puf` | `sudo apt update; sudo apt upgrade` | |
| `puf` | `sudo apt update; sudo apt-fast upgrade` | `apt-fast` is installed |

Note: Using `p` as a prefix for Apt instead of `a` because I use Arch Linux as the main driver. It's a `pacman` thing, you know. :)

#### Pacman

| Abbreviation | Full command | Note                |
| -------- | ------- | ------------------------- |
| `pud` | `sudo pacman -Sy` | |
| `pug` | `sudo pacman -Su --noconfirm` | |
| `puf` | `sudo pacman -S --noconfirm --needed archlinux-keyring; sudo pacman -Syu` | |
| `pit` | `sudo pacman -S --noconfirm --needed` | |
| `pcl` | `sudo pacman -Rns (pacman -Qdttq)` | |
| `prm` | `sudo pacman -Rns` | |
| `pss` | `pacman -sS` | |
| `pqr` | `pacman -Q` | |
| `yuf` | `yay -Syu` | `yay` is installed |
| `yit` | `yay -S` | `yay` is installed |

#### Git

| Abbreviation | Full command |
| -------- | ------- |
|`gco`|`git checkout`|
|`gcm`|`git commit`|
|`gca`|`git commit --amend`|
|`gcn`|`git commit --amend --no-edit`|
|`grs`|`git clean -f -d && git reset --hard HEAD^^ && git pull`|
|`gpo`|`git push origin`|
|`gpl`|`git pull`|
|`gcl`|`git clone`|
|`gst`|`git status`|
|`gdf`|`git diff`|
|`gad`|`git add`|
|`glo`|`git log --oneline`|
|`gpom`|`git push origin master`|

#### Others

| Abbreviation | Full command |
| -------- | ------- |
|`chmox`|`chmod +x`|
|`rmrf`|`rm -rf`|

### User Customizations

A `custom` directory will be created inside `quanta-fish` if it does not exist when a `fish` session starts. Every change inside this directory will be ignored by Git.

The directory structure is the same as `quanta-fish`. Check [init.fish](https://github.com/QuantaRicer/fish/blob/master/quanta-fish/init.fish) for more information.

Users can modify this folder without interfering with other Git operations.

## Disclaimer

This customization is tailored for personal use, and others are welcome to utilize it as they see fit. However, please be aware that this customization is provided as-is, without any guarantees or promises of immediate support for issues that may arise.

**Disclaimer:**
- This configuration is designed for personal preferences and may not cater to all use cases.
- Users are encouraged to adapt and modify the configuration to suit their own needs.
- While efforts may be made to address issues, there is no commitment to immediate resolutions.
- The owner of this customization reserves the right to address and modify issues at their discretion and may not guarantee timely updates.

Use this customization at your own risk, and feel free to contribute or modify it according to your requirements.
