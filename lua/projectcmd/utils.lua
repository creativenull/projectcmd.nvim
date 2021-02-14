local config = require 'projectcmd.config'
local M = {}

function M.printd(str)
    print(config.PRINTF_PLUGIN .. ' ' .. str)
end

function M.print_err(str)
    vim.api.nvim_err_writeln(config.PRINTF_PLUGIN .. ' ' .. str)
end

-- Validate user options
function M.validate_opts(opts)
    if opts.key == nil then
        opts.key = ''
    end

    if opts.type == nil then
        opts.type = 'vim'
    end

    if opts.filepath == nil then
        if opts.type == 'vim' then
            opts.filepath = vim.fn.getcwd() .. '/.vim/settings.vim'
        elseif opts.type == 'lua' then
            opts.filepath = vim.fn.getcwd() .. '/.vim/settings.lua'
        else
            M.print_err('Not a valid type')
        end
    end

    if opts.autoload == nil then
        opts.autoload = false
    end

    return opts
end

return M
