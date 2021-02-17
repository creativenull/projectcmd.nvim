# ProjectCMD (WIP)

A vim plugin to run your project-level neovim configuration.

## Motivation

If you've used `set exrc` before, you would be informed that using it might execute malicious code, see
[`:h 'exrc'`][vim-exrc]. Therefore, you would've been advised to also enable `set secure` to disable some vim config
options like `autocmds`, shell executions and write commands, see [`:h 'secure'`][vim-secure].

However, there might some options you may want to conditionally set in a project-level basis but the limitations of
`secure` restrict you those options.

__ProjectCMD__ tries to tackle this by not using `set secure` or `set exrc` but sourcing a .vim/.lua file in
your `$PROJECT_DIR/.vim/settings.vim`/`$PROJECT_DIR/.vim/settings.lua` and only executing the code if it matches a
secret key that you set in your `init.vim` or within an profile environment variable like `$NVIMRC_PROJECTCMD_KEY`
obfuscated from a potential malicious user.

Essentially, the goal of this plugin is to help you safely source your project-specific options. Think of it like an
`.vscode/settings.json` file but for vim.

### Example

For example, let's say you're using [ALE][ale-plugin] on a JavaScript project and you only want to enable tsserver,
eslint and prettier for your code. Within your `$PROJECT_DIR/.vim/settings.vim` you can add:

```vim
"=SECRET_KEY
au! FileType javascript let b:ale_linters = ['tsserver', 'eslint'] | let b:ale_fixers = ['prettier']
```

Where `SECRET_KEY` is the secret key you have placed somewhere in your vimrc or profile environment variable. What the
current autocmd does, is that when you open a `javascript` type file it will set buffer variables defined by ALE to run
only the specified linters and fixers, therefore, overriding the default ALE variables set for JavaScript. This way, you
don't need to specify the linter and/or fixer in your vimrc and manually changing it every time for different projects.

## TODO

+ [ ] Omit the `type` key once we can figure out what the filepath extension
+ [ ] If both `.vim` and `.lua` files are present, then figure how to source them in order or require them to only have
one file

## Installation

[Neovim nightly][nightly] (v0.5 or build from `master` branch) is __required__.

Install via a plugin manager, any will do, here are examples using packer, minpac and vim-plug.

[packer.nvim][packer]

```lua
use { 'creativenull/projectcmd.nvim', opt = true }
```

[Minpac][minpac]

```vim
call minpac#add('creativenull/projectcmd.nvim', { 'type': 'opt' })
```

[vim-plug][vim-plug]

```vim
Plug 'creativenull/projectcmd.nvim'
```

> _Note for vim-plug_: No need to add `packadd projectcmd.nvim`, since it loads automatically

## Configuration

First you'll need a key that will be used to compare the key within your project-level settings. To setup a key, you
add the `key` key in the setup.

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

It's a better practice to create an environment variable and keep the key there, so it's not specific to your init file.

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

### Default Settings

```lua
require'projectcmd'.setup {
    key = nil,
    type = 'vim',
    filepath = vim.fn.cwd() .. '/.vim/settings.vim',
    autoload = false
}
```

Key | Default | Description
----|---------|------------
`key` | (required) | The secret key that will verify the `settings.vim/.lua`, this must not be empty
`type` | `'vim'` | The settings file type: `'vim' or 'lua'`
`filepath` | `'$ROOT_PROJECT/.vim/settings.vim'` | The filepath location of the settings file
`autoload` | `false` | Should the plugin autoload the settings file or not

#### Autoloading

By default this is disabled to manually source the settings file use `:ProjectCmdEnable` command. If you want to
automatically source the settings file, set the `autoload` key to `true`.

[nightly]: https://github.com/neovim/neovim/releases/tag/nightly
[packer]: https://github.com/wbthomason/packer.nvim
[minpac]: https://github.com/k-takata/minpac
[vim-plug]: https://github.com/junegunn/vim-plug
[ale-plugin]: https://github.com/dense-analysis/ale
[vim-exrc]: https://vimhelp.org/options.txt.html#'exrc'
[vim-secure]: https://vimhelp.org/options.txt.html#'secure'
