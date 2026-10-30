-- Lua port of my original Vimscript: Zettelkasten helpers

-- NOTES_DIR from environment, or default; expand ~ and resolve symlinks once
local notes_dir = vim.fn.resolve(vim.fn.expand(os.getenv 'NOTES_DIR' or '~/Documents/Notes'))

-- Unescaped path; escape only at the point of use in Ex commands
vim.g.zettelkasten = notes_dir

-- Filename for a new note: timestamp ID plus title, with spaces as underscores
local function zettel_filename(title)
  return os.date '%Y%m%d%H%M' .. '-' .. title:gsub('%s+', '_') .. '.md'
end

-- Open a note and, if it is new, prefill it with its title as heading
local function open_zettel(filename, title)
  local path = vim.fs.joinpath(notes_dir, filename)
  vim.cmd.edit(vim.fn.fnameescape(path))
  if vim.fn.filereadable(path) == 0 then
    vim.api.nvim_buf_set_lines(0, 0, -1, false, { '# ' .. title, '', '' })
    vim.api.nvim_win_set_cursor(0, { 3, 0 })
  end
end

vim.api.nvim_create_user_command('NewZettel', function(opts)
  open_zettel(zettel_filename(opts.args), opts.args)
end, { nargs = 1, desc = 'Create new Zettel' })

vim.keymap.set('n', '<leader>ni', function()
  vim.cmd.cd(vim.fn.fnameescape(notes_dir))
end, { desc = 'Change directory to Zettelkasten' })

vim.keymap.set('n', '<leader>nz', ':NewZettel ', { desc = 'Create new Zettel' })

-- Map <leader>nb to list notes that link to the current note
vim.keymap.set('n', '<leader>nb', function()
  require('telescope.builtin').grep_string { cwd = notes_dir, search = vim.fn.expand '%:t' }
end, { desc = 'Backlinks to current Zettel' })

-- Map <leader>nl to insert a link to a new note at the cursor, then open that note
vim.keymap.set('n', '<leader>nl', function()
  vim.ui.input({ prompt = 'New Zettel title: ' }, function(title)
    if not title or title == '' then
      return
    end
    local filename = zettel_filename(title)
    vim.api.nvim_put({ string.format('[%s]( %s )', title, filename) }, 'c', true, true)
    open_zettel(filename, title)
  end)
end, { desc = 'Link to and create new Zettel' })

-- Not a plugin spec; this file only sets up commands and keymaps
return {}
