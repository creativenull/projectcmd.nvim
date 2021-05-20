local M = {}

function M.get_file_extension(filepath)
  return string.match(filepath, '[^.]+$')
end

function M.source_by_type(init_filepath)
  if M.get_file_extension(init_filepath) == 'lua' then
    dofile(init_filepath)
  end

  if M.get_file_extension(init_filepath) == 'vim' then
    vim.cmd('source ' .. init_filepath)
  end
end

return M
