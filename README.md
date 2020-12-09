# ProjectCMD (WIP)

A plugin to load custom vimscript (lua, eventually) from a project directory.

## Installation

Using `packer.nvim` or similar package manager:

```lua
use { 'creativenull/projectcmd.nvim', opt = true }
```

Minpac example:

```lua
call minpac#add('creativenull/projectcmd.nvim', { 'type': 'opt'  })
```

## Setup

First you'll need a key that will be used to compare the key within your project-level settings. To setup a key, you
add the `key` key (😉) in the setup.

`init.vim`

```vim
packadd projectcmd.nvim

lua <<EOF
require'projectcmd'.setup {
    key = 'SECRET_KEY'
}
EOF
```

`init.lua`

```lua
vim.cmd [[ packadd projectcmd.nvim ]]

require'projectcmd'.setup {
    key = 'SECRET_KEY'
}
```

### Add key to project

Create the `settings.vim` in `$PROJECT_DIR/.vim/settings.vim` where `$PROJECT_DIR` is your project root directory.

#### Vimscript

```vim
"=SECRET_KEY

autocmd VimEnter echom 'Loaded project settings'
```

#### Lua

Coming Soon
