describe('Default configs -', function()
  local config = require('projectcmd.config')

  it('Should show proper path to allowlist', function()
    assert.equals(config.get_allowlist(), vim.fn.expand('~/.cache/projectcmd') .. '/allowlist')
  end)

  it('Should show proper path to ignorelist', function()
    assert.equals(config.get_ignorelist(), vim.fn.expand('~/.cache/projectcmd') .. '/ignorelist')
  end)
end)
