# Kiewn's Fish Config (KFC)

[![License: Unlicense](https://img.shields.io/badge/license-Unlicense-green.svg)](http://unlicense.org/)

## What is this?
A custom fish shell configurations because I prefer not to use a package manager.

### Key features:
- Nerdy custom prompt with icons.
- Wrapper for some built-in commands.
- Some short aliases.
- Some new handy functions.
- Abbreviations for apt, pacman, git, tec.

## A nerdy custom fish prompt

1. **Preview**

```plaintext
 username 󰉋 /current/working/directory  get_branch [[git_relative_count]  git_status]
󰶻 command
```
2. **To show git status**
```fish
# Set this variable in your user config
set -g KFC_GIT_STATUS true
```
3. **To show relative distance of current commit to HEAD**
```fish
# Set these variables in your user config
# Both of them are required
set -g KFC_GIT_STATUS true
set -g KFC_GIT_RELATIVE_COUNT true
```
**Note:** Enabling the Git status prompt is not recommended for slow devices as it may result in significant delays.

## Built-in commands wrapper

1. **cd wrapper**

- Automatically saves a detailed history of all directories visited during a fish session.
- Ensures that the history is cleared when the fish session is ended.
- Provide an easy way to travel to any of visited directories with index.
  
| Option | Value     | Description               |
| :--------: | ------- | ------------------------- |
| `-l` | none | Show cd history of this fish session |
| `-i` | number |  Go to directory at index `number` in  the history of this session |

2. **ls wrapper**

- Ignores the lost+found directory in the listing
- Enforces color-coded output for easy identification of file types and attributes.
- Use like the standard `ls` command


## Short aliases for some commands

| Aliases | Commands     | Note               |
| :-----: | ----------- | ------------------ |
|  `cls`  | `clear` | |
|   `q`  | `exit` | |
| `quit`  | `exit` | |
|   `l`   | `ls -lhA --ignore=lost+found --color=always` | |
|  `vim` | `nvim` | Only when `neovim` is installed. |


## Some new handy functions

1. **git_push_now**

- Displays a clear prompt asking if the user wants to push changes to the current branch.
- Retrieves the name of the current Git branch dynamically.
- Waits for user input, ensuring a deliberate choice.
- Validates the user input to accept only 'Y' or 'N' as valid responses. The user can respond with either upper or lowercase letters.
   - If the user confirms ('Y' or 'y'), the function executes `git push origin <current_branch>` to push changes to the remote repository.
   - If the user chooses not to push changes, it prints a "Canceled!" message.
- Safely handles interruptions during user interaction, preventing accidental actions.


## Abbreviations

1. **Apt**

| Abbr | Full command | Note                |
| :--------: | ------- | ------------------------- |
| `pud` | `sudo apt update` | |
| `prm` | `sudo apt purge` | |
| `pcl` | `sudo apt autoclean; sudo apt autoremove` | |
| `pss` | `apt-cache search` | |
| `pfm` | `sudo apt install --fix-missing` | |
| `pit` | `sudo apt install -y` | |
| `pit` | `sudo apt-fast install -y` | If `apt-fast` is installed |
| `pug` | `sudo apt upgrade` | |
| `pug` | `sudo apt-fast upgrade` | If `apt-fast` is installed |
| `puf` | `sudo apt update; sudo apt upgrade` | |
| `puf` | `sudo apt update; sudo apt-fast upgrade` | If `apt-fast` is installed |

Note: Using `p` as a prefix for Apt instead of `a` because I use Arch Linux as the main driver. Muscle memory.

2. **Pacman**

| Abbr | Full command |
| :-------: | ------- |
| `pud` | `sudo pacman -Sy` |
| `pug` | `sudo pacman -Su --noconfirm` |
| `puf` | `sudo pacman -S --noconfirm --needed archlinux-keyring; sudo pacman -Syu` |
| `pit` | `sudo pacman -S --noconfirm --needed` |
| `pcl` | `sudo pacman -Rns (pacman -Qdttq)` |
| `prm` | `sudo pacman -Rns` |
| `pss` | `pacman -sS` |
| `pqr` | `pacman -Q` |

3. **Git**

| Abbr | Full command |
| :--------: | ------- |
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
|`gpp`|`git_push_now`|

4. **Others**

| Abbr | Full command |
| :--------: | ------- |
|`chmox`|`chmod +x`|
|`rf`|`rm -rf`|

## User Customization Guide

To customize your Fish shell configuration, follow these simple guidelines:

1. **Pattern Matching Exclusion:**
  - Files matching the pattern `user_*.fish` will be ignored by Git.
2. **Variable Configuration:**
  - Create a file named `user_<abcxyz>.fish` in the `conf.d` directory.
  - Customize the file to set specific variables according to your preferences.
3. **Function Customization:**
  - For custom functions, create a file named `user_<abcxyz>.fish` in the `functions` directory.
  - Define and implement your desired functions within this file.

## Disclaimer

This customization is tailored for personal use, and others are welcome to utilize it as they see fit. However, please be aware that this customization is provided as-is, without any guarantees or promises of immediate support for issues that may arise.

- This configuration is designed for personal preferences and may not cater to all use cases.
- Users are encouraged to adapt and modify the configuration to suit their own needs.
- While efforts may be made to address issues, there is no commitment to immediate resolutions.
- The owner of this customization reserves the right to address and modify issues at their discretion and may not guarantee timely updates.

Use this customization at your own risk, and feel free to contribute or modify it according to your requirements.

Happy ricing! ✨
