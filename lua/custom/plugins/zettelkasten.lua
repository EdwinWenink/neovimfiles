-- Lua port of my original vimscript

-- Check and set NOTES_DIR from environment variable or default path
local notes_dir = os.getenv 'NOTES_DIR' or '~/Documents/Notes/'

-- Function to escape file path (Prevent issues with spaces or special characters)
local function fnameescape(path)
  return vim.fn.fnameescape(vim.fn.resolve(path))
end

-- Set the global zettelkasten path
vim.g.zettelkasten = fnameescape(notes_dir)

return {
  -- Define the NewZettel command
  vim.api.nvim_create_user_command('NewZettel', function(opts)
    local filename = vim.g.zettelkasten .. os.date '%Y%m%d%H%M' .. '-' .. opts.args .. '.md'
    vim.cmd('edit ' .. vim.fn.fnameescape(filename))
  end, { nargs = 1 }),

  -- Map <leader>nz to the NewZettel command in normal mode
  -- vim.api.nvim_set_keymap('n', '<leader>nz', ':NewZettel ', { noremap = true, silent = false }),
  vim.keymap.set('n', '<leader>nz', ':NewZettel ', { noremap = true, silent = false, desc = 'Create new Zettel' }),
}
