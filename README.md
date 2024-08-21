# fzf-ghq

## Table of Contents

- [fzf-ghq](#fzf-ghq)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Installation](#installation)
    - [Download fzf-ghq to your home directory](#download-fzf-ghq-to-your-home-directory)
    - [Using key bindings](#using-key-bindings)
  - [Usage](#usage)
  - [License](#license)

## Overview

This is a shell plugin that allows you to execute [`ghq`](https://github.com/x-motemen/ghq) commands using keyboard shortcuts utilizing [`junegunn/fzf`](https://github.com/junegunn/fzf) and [`x-motemen/ghq`](https://github.com/x-motemen/ghq).

The following additional features are implemented in the [`ghq`](https://github.com/x-motemen/ghq) command:

- Search and open the directory in Finder
- Search and open the directory in Cursor
- Search and open the directory in Visual Studio Code
- Search and open the directory in Sourcetree

## Installation

### Download [fzf-ghq](https://github.com/gumob/fzf-ghq) to your home directory

```shell
wget -O ~/.fzfgitutil https://raw.githubusercontent.com/gumob/fzf-ghq/main/fzf-ghq.sh
```

### Using key bindings

Source `fzf` and `fzf-ghq` in your run command shell.
By default, no key bindings are set. If you want to set the key binding to `Ctrl+G`, please configure it as follows:

```shell
cat <<EOL >> ~/.zshrc
export FZF_GHQ_KEY_BINDING="^G"
source ~/.fzfgitutil
EOL
```

`~/.zshrc` should be like this.

```shell
source <(fzf --zsh)
export FZF_GHQ_KEY_BINDING='^G'
source ~/.fzfgitutil
```

Source run command

```shell
source ~/.zshrc
```

## Usage

Using the shortcut key set in `FZF_GHQ_KEY_BINDING`, you can execute `fzf-ghq`, which will display a list of `ghq` and `git fuzzy` commands.

To run `fzf-ghq` without using the keyboard shortcut, enter the following command in the shell:

```shell
fzf-ghq
```

## License

This project is licensed under the MIT License. The MIT License is a permissive free software license that allows for the reuse, modification, distribution, and sale of the software. It requires that the original copyright notice and license text be included in all copies or substantial portions of the software. The software is provided "as is", without warranty of any kind, express or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose, and noninfringement.
