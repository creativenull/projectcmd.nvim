local utils = require('projectrc.utils')

-- Checks if the global variable is properly defined
local function has_key()
    if vim.g.projectrc_key == nil and vim.g.projectrc_key ~= '' then
        return true
    end

    return false
end

-- Checks if the file exists and match the key
local function is_key_match()
    if ~utils.file_exists(vim.g.projectrc_path) then
        return false
    end

    local f = io.open(vim.g.projectrc_path, 'r')
    local first_line = io.read()
    f.close()

    -- In the string format: "=SECRET_KEY
    local key = string.sub(first_line, 3)

    return key == vim.g.projectrc_key
end

-- Loads the settings.vim into runtime
local function load_project_settings()
    print('[PROJECTRC] Settings found!')
end

-- Main setup
local function setup()
    if vim.g.projectrc_path == nil then
        vim.g.projectrc_path = vim.fn.getcwd() .. '/.vim/settings.vim'
    end

    if has_key() and is_key_match() then
        load_project_settings()
    end
end

return setup
