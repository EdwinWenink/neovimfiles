-- Lua port of my original Vimscript: Zettelkasten helpers

-- NOTES_DIR from environment, or default; expand ~ and resolve symlinks once
local notes_dir = vim.fn.resolve(vim.fn.expand(os.getenv 'NOTES_DIR' or '~/Documents/Notes'))

-- Unescaped path; escape only at the point of use in Ex commands
vim.g.zettelkasten = notes_dir

vim.api.nvim_create_user_command('NewZettel', function(opts)
  local slug = opts.args:gsub('%s+', '-')
  local filename = vim.fs.joinpath(notes_dir, os.date '%Y%m%d%H%M' .. '-' .. slug .. '.md')
  vim.cmd.edit(vim.fn.fnameescape(filename))
end, { nargs = 1, desc = 'Create new Zettel' })

vim.keymap.set('n', '<leader>ni', function()
  vim.cmd.cd(vim.fn.fnameescape(notes_dir))
end, { desc = 'Change directory to Zettelkasten' })

vim.keymap.set('n', '<leader>nz', ':NewZettel ', { desc = 'Create new Zettel' })

-- Not a plugin spec; this file only sets up commands and keymaps
return {}
