# ProjectCMD (Experimental)

A vim plugin to run your project-level neovim configuration.

# Table of Contents

1. [Motivation](#motivation)
2. [Installation](#installation)
3. [Configuration](#configuration)
4. [Default Settings](#default-settings)
5. [Troubleshooting](#troubleshooting)

## Motivation

If you've used `set exrc` before, you would be informed that using it might execute malicious code, see
[`:h 'exrc'`][vim-exrc]. Therefore, you would've been advised to also enable `set secure` to disable some vim config
options like `autocmds`, shell executions and write commands, see [`:h 'secure'`][vim-secure].

However, there might some options you may want to conditionally set in a project-level basis but the limitations of
`secure` restrict you those options.

__ProjectCMD__ tries to tackle this by not using `set secure` or `set exrc` but sourcing a .vim/.lua file in
your `$PROJECT_DIR/.vim/init.vim`/`$PROJECT_DIR/.vim/init.lua` and only executing the code if it allowed by the user
obfuscated from a potential malicious user.

Essentially, the goal of this plugin is to help you safely source your project-specific options. Think of it like an
`.vscode/settings.json` file but for vim.

### Example

For example, let's say you're using [ALE][ale-plugin] on a JavaScript project and you only want to enable tsserver,
eslint and prettier for your code. Within your `$PROJECT_DIR/.vim/init.vim` you can add:

```vim
" $PROJECT_DIR/.vim/init.vim
autocmd! FileType javascript let b:ale_linters = ['tsserver', 'eslint'] | let b:ale_fixers = ['prettier']
```

When you open vim it will prompt you to load the file, once accepted it will execute the file and register ALE commands.
What the current file does, is that when you open a `javascript` type file it will set buffer variables defined by
ALE to run only the specified linters and fixers, therefore, overriding the default ALE variables set for JavaScript.
This way, you don't need to specify the linter and/or fixer in your vimrc and manually changing it every time for
different projects.

## TODO

+ [X] Omit the `type` key once we can automatically source based on the filepath extension. Solution: removed type
+ [X] If both `.vim` and `.lua` files are present, then figure how to source them in order or require them to only have
one file. Solution: in this case, use .vim only
+ [ ] Figure out a way to save previous settings, so that we can implement the disable feature. Solution: re-source
vimrc file after calling `:ProjectCmdDisable` (not implemented)

## Installation

[Neovim nightly][nightly] (v0.5 or build from `master` branch) is __required__.

Install via a plugin manager, any will do, here are examples using packer, minpac and vim-plug.

[packer.nvim][packer]

```lua
use { 'creativenull/projectcmd.nvim', branch = 'v2' }
```

[Minpac][minpac]

```vim
call minpac#add('creativenull/projectcmd.nvim', { 'branch': 'v2' })
```

[vim-plug][vim-plug]

```vim
Plug 'creativenull/projectcmd.nvim', { 'branch': 'v2'}
```

## Configuration

```vim
" init.vim

lua require 'projectcmd'.setup {}
```

```lua
-- init.lua

require 'projectcmd'.setup {}
```

#### Autoloading

By default this is enabled, this means the plugin will source the local config file. If you want to manually source the
local config file, then set the `enable` key to `true`.

```
require 'projectcmd'.setup {
  enable = false
}
```

## Default Settings


## Troubleshooting


+ If you have `autochdir` enabled, make sure to disable it: `set noautochdir`. This messes with getting the current
working directory.

[nightly]: https://github.com/neovim/neovim/releases/tag/nightly
[packer]: https://github.com/wbthomason/packer.nvim
[minpac]: https://github.com/k-takata/minpac
[vim-plug]: https://github.com/junegunn/vim-plug
[ale-plugin]: https://github.com/dense-analysis/ale
[vim-exrc]: https://vimhelp.org/options.txt.html#'exrc'
[vim-secure]: https://vimhelp.org/options.txt.html#'secure'
