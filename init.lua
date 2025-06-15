-- TODO:
-- Better keybinds for telescope 
-- Basic LSP setup
-- Basic color/syntax highlighting setup
-- Shortcuts to move screen
-- Make tab size way smaller
-- Install a bunch of the missing plugins you had earlier.

-- OPTIONS
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.o.number = true
vim.o.relativenumber = true

vim.o.wrap = true
vim.o.breakindent = true
vim.o.showbreak = '↪'

vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '.', nbsp = '␣' }
--how many lines to the bottom or top should the cursor be before we start scrolling the screen?
vim.o.scrolloff = 10

vim.o.mouse = 'a'

vim.g.have_nerd_font = true

-- We do this scheduling as a trick to decrease startup time
vim.schedule(function() 
	vim.o.clipboard = 'unnamedplus'
end)

vim.o.undofile = true

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.updatetime = 100
vim.o.timeoutlen = 300

-- This somewhat cryptic setting previews substitutions live as you type!
vim.o.inccommand = 'split'

-- Ask user if they want to save unsaved buffer when performming an operation that would fail due to an unsaved buffer
vim.o.confirm = true


-- KEYMAPS
vim.keymap.set(
	'n', -- In normal mode
	'<CR>', -- Set what enter does
	'<cmd>nohlsearch<CR>' -- <cmd> takes us into command mode (as if having pressed ':'), we write out the command nohlsearch and execute it with enter (<CR>) 
)

vim.keymap.set(
	't', --in terminal mode
	'<Esc><Esc>', -- .. press escape escape
	'<C-\\><C-n>' -- to exit by using the somewhat complicated default keybind to exit
)

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', {desc = 'Move focus to the left window'})
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', {desc = 'Move focus to the below window'})
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', {desc = 'Move focus to the upper window'})
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', {desc = 'Move focus to the right window'})
vim.keymap.set('n', '<C-d>', '<cmd>split<CR>', {desc = 'Split window vertically'})
vim.keymap.set('n', '<C-f>', '<cmd>vsplit<CR>', {desc = 'Split window horizontally'})
vim.keymap.set('n', '<C-q>', '<cmd>q<CR>', {desc = 'Quit window'})
vim.keymap.set('n', '<C-w>', '<cmd>w<CR>', {desc = 'Save bufer'})


--EVENTS / AUTOCOMMANDS
--see :help lua-guide-autocommands for a guide on how to use autocommands
--see :help events for a list of events you can listen to

-- Highlight yanked text
vim.api.nvim_create_autocmd('TextYankPost', {
	callback = function() vim.hl.on_yank() end
})


-- PLUGINS
-- First some stuff i dont quite get with installing lazy plugin manager:
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

local rtp = vim.opt.rtp
rtp:prepend(lazypath)

require('lazy').setup({
	'NMAC427/guess-indent.nvim',

	{ -- Adds git related signs to the gutter, as well as utilities for managing changes
		'lewis6991/gitsigns.nvim',
		opts = {
			signs = {
				add = { text = '+' },
				change = { text = '~' },
				delete = { text = '_' },
				topdelete = { text = '‾' },
				changedelete = { text = '~' },
			},
		},
	},

	{ --FZF/Telescope
		'nvim-telescope/telescope.nvim',
		event = 'VimEnter',
		dependencies = {
			{'nvim-lua/plenary.nvim'}, --Just something used in the code for telescope
			{'nvim-telescope/telescope-fzf-native.nvim',
				build = 'make',
				-- Function used to determine whether plugin is loaded and installed or not
				cond = function() 
					return vim.fn.executable 'make' == 1
				end
			},
			{'nvim-telescope/telescope-ui-select.nvim'},
			{'nvim-tree/nvim-web-devicons', 
				enabled = vim.g.have_nerd_font 
			},
			{'BurntSushi/ripgrep'}
		},
		config = function()
			require('telescope').setup {
			-- You can put your default mappings / updates / etc. in here
			--  All the info you're looking for is in `:help telescope.setup()`
			--
			-- defaults = {
			--   mappings = {
			--     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
			--   },
			-- },
			-- pickers = {}
			extensions = {
			  ['ui-select'] = {
			    require('telescope.themes').get_dropdown(),
			  },
			},
			}

		      -- Enable Telescope extensions if they are installed
		      pcall(require('telescope').load_extension, 'fzf')
		      pcall(require('telescope').load_extension, 'ui-select')

		      -- See `:help telescope.builtin`
		      local builtin = require 'telescope.builtin'
		      vim.keymap.set('n', '<leader>sh', builtin.help_tags,     { desc = '[S]earch [H]elp' })
		      vim.keymap.set('n', '<leader>sk', builtin.keymaps,       { desc = '[S]earch [K]eymaps' })
		      vim.keymap.set('n', '<leader>sf', builtin.find_files,    { desc = '[S]earch [F]iles' })
		      vim.keymap.set('n', '<leader>ss', builtin.builtin,       { desc = '[S]earch [S]elect Telescope' })
		      vim.keymap.set('n', '<leader>sw', builtin.grep_string,   { desc = '[S]earch current [W]ord' })
		      vim.keymap.set('n', '<leader>sg', builtin.live_grep,     { desc = '[S]earch by [G]rep' })
		      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

		      -- Slightly advanced example of overriding default behavior and theme
		      vim.keymap.set('n', '<leader>/', function()
			-- You can pass additional configuration to Telescope to change the theme, layout, etc.
			builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
			  winblend = 10,
			  previewer = false,
			})
		      end, { desc = '[/] Fuzzily search in current buffer' })

		      -- It's also possible to pass additional configuration options.
		      --  See `:help telescope.builtin.live_grep()` for information about particular keys
		      vim.keymap.set('n', '<leader>s/', function()
			builtin.live_grep {
			  grep_open_files = true,
			  prompt_title = 'Live Grep in Open Files',
			}
		      end, { desc = '[S]earch [/] in Open Files' })

		      -- Shortcut for searching your Neovim configuration files
		      vim.keymap.set('n', '<leader>sn', function()
			builtin.find_files { cwd = vim.fn.stdpath 'config' }
		      end, { desc = '[S]earch [N]eovim files' })
		end
	},
})

