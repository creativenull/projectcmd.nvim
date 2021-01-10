# ProjectCMD (WIP)

A plugin to run project-level vim config in your project directory. For example, run different linters based on project
without changing your global config.

## Installation

[Neovim nightly][nightly] (v0.5 or build from `master` branch) is __required__.

Install via a plugin manager, any will do, here are examples using packer, minpac and vim-plug.

[packer.nvim][packer]

```lua
use { 'creativenull/projectcmd.nvim', opt = true }
```

[Minpac][minpac]

```vim
call minpac#add('creativenull/projectcmd.nvim', { 'type': 'opt'  })
```

[vim-plug][vim-plug]

```vim
Plug 'creativenull/projectcmd.nvim'
```

## Configuration

First you'll need a key that will be used to compare the key within your project-level settings. To setup a key, you
add the `key` key (😉) in the setup.

```vim
" init.vim
packadd projectcmd.nvim

lua <<EOF
require'projectcmd'.setup {
    key = 'SECRET_KEY'
}
EOF
```

```lua
-- init.lua
vim.cmd [[ packadd projectcmd.nvim ]]

require'projectcmd'.setup {
    key = 'SECRET_KEY'
}
```

It's a better practice to create an enviroment variable and keep the key there, so it's not specific to your init file.

```lua
-- init.lua
vim.cmd [[ packadd projectcmd.nvim ]]

require'projectcmd'.setup {
    key = os.getenv('NVIMRC_PROJECTCMD_KEY')
}
```

### Add key to project

Create the `settings.vim` in `$PROJECT_DIR/.vim/settings.vim` where `$PROJECT_DIR` is your project root directory.
Add the `SECRET_KEY` at the top of the file as a comment. If you added a global env variable, as mentioned above, you
can add your key via the command line (assuming you're in the project directory):

```sh
echo "\"=${NVIMRC_PROJECTCMD_KEY}" > ./.vim/settings.vim

# For lua
echo "--${NVIMRC_PROJECTCMD_KEY}" > ./.vim/settings.lua
```

Or enter manually like below:

#### .vim/settings.vim

```vim
"=SECRET_KEY

autocmd VimEnter * echom 'Loaded project settings'
```

#### .vim/settings.lua
```lua
--SECRET_KEY

vim.cmd [[ autocmd VimEnter * echom 'Loaded project settings' ]]
```

[nightly]: https://github.com/neovim/neovim/releases/tag/nightly
[packer]: https://github.com/wbthomason/packer.nvim
[minpac]: https://github.com/k-takata/minpac
[vim-plug]: https://github.com/junegunn/vim-plug
