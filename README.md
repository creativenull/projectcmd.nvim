# ProjectCMD (Beta)

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
your `$PROJECT_DIR/.vim/init.vim`/`$PROJECT_DIR/.vim/init.lua` - if allowed by the user - and execute the code once its
determined safe.

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

## Installation

[Neovim nightly][nightly] (v0.5 or build from `master` branch) is __required__.

Install via a plugin manager, any one will do, here are some examples using packer, minpac, vim-packager and vim-plug.

[packer.nvim][packer]

```lua
use 'creativenull/projectcmd.nvim'
```

[Minpac][minpac]

```vim
call minpac#add('creativenull/projectcmd.nvim')
```

[vim-packager][vim-packager]

```vim
call packager#add('creativenull/projectcmd.nvim')
```

[vim-plug][vim-plug]

```vim
Plug 'creativenull/projectcmd.nvim'
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

```lua
require 'projectcmd'.setup {
  enable = false
}
```

## Default Settings

Below are the default settings that are set, if not provided.

```lua
-- Default Settings
require 'projectcmd'.setup {
  enable = true,
  show_message = true,
  root_dir = '~/.cache/projectcmd',
  project_config_filepath = '/.vim/init.lua'
}
```

Key | Description
----|------------
`enable` | Let the plugin automatically source the project config file
`show_message` | Shows the message on command line bar, at the bottom of statusline
`root_dir` | Shows the message on command line bar, at the bottom of statusline
`project_config_filepath` | Location of the local config file in the project directory

## Troubleshooting

+ If you have `autochdir` enabled, make sure to disable it: `set noautochdir`. This messes with getting the current
working directory.

## Contributing

Guide coming soon, but you are more than welcome to explore the codebase and make an issue on the problem.

[nightly]: https://github.com/neovim/neovim/releases/tag/nightly
[packer]: https://github.com/wbthomason/packer.nvim
[minpac]: https://github.com/k-takata/minpac
[vim-packager]: https://github.com/kristijanhusak/vim-packager
[vim-plug]: https://github.com/junegunn/vim-plug
[ale-plugin]: https://github.com/dense-analysis/ale
[vim-exrc]: https://vimhelp.org/options.txt.html#'exrc'
[vim-secure]: https://vimhelp.org/options.txt.html#'secure'
