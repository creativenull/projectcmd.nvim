local utils = require 'projectcmd.utils'
local M = {}

-- Checks if the global variable is properly defined
local function has_key(key)
    if key ~= '' then
        return true
    end

    return false
end

-- Checks if the file exists and match the key
local function is_key_match(opts)
    if vim.fn.filereadable(opts.filepath) == 0 then
        return false
    end

    local fp = io.open(opts.filepath)
    local first_line = io.input(fp):read()
    fp.close()

    if not first_line then
        return false
    end

    local filekey = ''
    if opts.type == 'vim' then
        filekey = string.sub(first_line, 3)
    elseif opts.type == 'lua' then
        filekey = string.sub(first_line, 3)
    end

    return filekey == opts.key
end

function M.enable()
    local opts = vim.g.projectcmd_options
    if opts.type == 'vim' then
        vim.cmd('source ' .. opts.filepath)
    elseif opts.type == 'lua' then
        vim.cmd('luafile ' .. opts.filepath)
    end
end

-- Loads the settings.vim into runtime
function M.setup(opts)
    opts = utils.validate_opts(opts)

    if has_key(opts.key) then
        if is_key_match(opts) then
            vim.g.projectcmd_options = opts
        end
    else
        utils.print_err('Key is required!')
    end
end

return M
