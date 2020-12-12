local utils = require('projectcmd.utils')

if vim.g.projectcmd_loaded == nil then
    vim.g.projectcmd_loaded = true
end

local PROJECTCMD = '[PROJECTCMD]'

-- Checks if the global variable is properly defined
local function has_key(key)
    if key ~= '' then
        return true
    end

    return false
end

-- Checks if the file exists and match the key
local function is_key_match(opts)
    if utils.file_exists(opts.filepath) == false then
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
        filekey = string.sub(first_line, 2)
    end

    return filekey == opts.key
end

-- Validate user options
local function validate_opts(opts)
    if opts['key'] == nil then
        opts['key'] = ''
    end

    if opts['type'] == nil then
        opts['type'] = 'vim'
    end

    if opts['filepath'] == nil then
        if opts.type == 'vim' then
            opts['filepath'] = vim.fn.getcwd() .. '/.vim/settings.vim'
        elseif opts.type == 'lua' then
            opts['filepath'] = vim.fn.getcwd() .. '/.vim/settings.lua'
        else
            print(PROJECTCMD .. ' Error: Not a valid type')
        end
    end

    return opts
end

local function source_file(opts)
    if opts.type == 'vim' then
        vim.cmd('source ' .. opts.filepath)
    elseif opts.type == 'lua' then
        vim.cmd('luafile ' .. opts.filepath)
    end
end

-- Loads the settings.vim into runtime
local function setup(opts)
    local _opts = validate_opts(opts)

    if has_key(_opts.key) then
        if is_key_match(opts) then
            source_file(opts)
        end
    else
        print(PROJECTCMD .. ' Key is required!')
    end
end

return { setup = setup }
