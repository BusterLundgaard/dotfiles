-- TODO:
-- Basic LSP setup
-- Still want half a screen scrolling!

-- ESSENTIAL OPTIONS
----------------------------------------------------------------------------------------------------------------------------------
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.o.number = true
vim.o.relativenumber = true

vim.o.wrap = false

vim.o.breakindent = true
vim.o.showbreak = '↪'
vim.o.tabstop = 3
vim.o.shiftwidth = 3


vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '.', nbsp = '␣' }
--how many lines to the bottom or top should the cursor be before we start scrolling the screen?
vim.o.scrolloff = 10

vim.o.mouse = 'a'

vim.g.have_nerd_font = true

-- We do this scheduling as a trick to decrease startup time
vim.schedule(function() 
end)
vim.o.clipboard = 'unnamedplus'

vim.o.undofile = true

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.updatetime = 100
vim.o.timeoutlen = 300

-- This somewhat cryptic setting previews substitutions live as you type!
vim.o.inccommand = 'split'

-- Ask user if they want to save unsaved buffer when performming an operation that would fail due to an unsaved buffer
vim.o.confirm = true

vim.g.neovide_refresh_rate = 60
---------------------------------------------------------------------------------------------------------------------------------

-- KEYMAPS
---------------------------------------------------------------------------------------------------------------------------------
-- Make paste not paste what was recently deleted (so more usual behaviour like other programs)
-- --- In normal mode
vim.keymap.set('n',	'p',	'\"0p')
vim.keymap.set('n','P','\"0P')
vim.keymap.set('n','<C-p>','p')
vim.keymap.set('n','<C-S-p>','P')
-- --- In visual mode
vim.keymap.set('v','p','\"0p')
vim.keymap.set('v','P','\"0P')
vim.keymap.set('v','<C-p>','p')
vim.keymap.set('v','<C-S-p>','P')

-- For quickly pasting over something
vim.keymap.set('n', 'æw', 'vw\"0p')
vim.keymap.set('n', 'æ<S-w>', 'vW\"0p')
vim.keymap.set('n', 'æe', 've\"0p')

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
vim.keymap.set('n', '<a-l>', '<cmd>vertical res +5<CR>', {desc = "Resize window left"})
vim.keymap.set('n', '<a-h>', '<cmd>vertical res -5<CR>', {desc = "Resize window left"})
vim.keymap.set('n', '<a-j>', '<cmd>horizontal res +5<CR>', {desc = "Resize window left"})
vim.keymap.set('n', '<a-k>', '<cmd>horizontal res -5<CR>', {desc = "Resize window left"})
vim.keymap.set('n', '<C-q>', '<cmd>q<CR>', {desc = 'Quit window'})
vim.keymap.set('n', '<C-w>', '<cmd>w<CR>', {desc = 'Save bufer'})

-- Compile commands
vim.keymap.set('n', '<C-c>', function() 
	vim.cmd("w")
	local command = ""
	local filetype = vim.bo.filetype
	if filetype == 'typst' then
		command = "typst compile --diagnostic-format=short " .. vim.api.nvim_buf_get_name(0)
	else
		command = "make"	
	end
	command = command .. " 2> compile_errors.txt"
	vim.fn.jobstart(command, {
		stderr_buffered = true,
		on_exit = function(_, exit_code)
			if exit_code ~= 0 then
				vim.cmd("cfile compile_errors.txt")
			else
				print("Compile success!")
			end
		end
	})
end);

-- Move lines up/down
vim.keymap.set('n', '<S-j>', ':m .+1<CR>==')
vim.keymap.set('n', '<S-k>', ':m .-2<CR>==')
vim.keymap.set('v', '<S-j>', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', '<S-k>', ":m '<-2<CR>gv=gv")

---------------------------------------------------------------------------------------------------------------------------------
-- CUSTOM OPERATORS! (HACKY AND WONKY)
-- These are operators that expect a motion afterwards, then do something over that range
-- The range that they operate on will start at the mark Z, end at the mark X

empty_function = function() end
custom_operation_function = empty_function

function begin_custom_operation(operation_function) 
	vim.cmd("normal! mZ") -- set a temporary mark
	custom_operation_function = operation_function
end

-- "Paste onto" custom operation
vim.keymap.set('n', 'ø', function() begin_custom_operation(function() 
	vim.cmd("normal! mX") -- set mark for current position, use Z to access previous position
	vim.cmd("normal! `Zv`X\"0P") -- paste in between marks, and the last charachter as well
end) end)

vim.api.nvim_create_autocmd('CursorMoved', {callback = function()
	custom_operation_function()
	custom_operation_function = empty_function
end})

vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = "*.man",
  command = "set filetype=man"
})

---------------------------------------------------------------------------------------------------------------------------------
-- CUSTOM WACKY AUTOCOMPLETION
-- function _G.show_custom_window() 
-- 	local buf = vim.api.nvim_create_buf(false, true)  -- create new (unlisted) buffer
--
-- 	local width = 30
-- 	local height = 10
-- 	local row = 5
-- 	local col = 10
--
-- 	vim.api.nvim_open_win(buf, false, {
-- 	  relative = 'cursor',
-- 	  focusable = true,
-- 	  noautocmd = true,
-- 	  width = width,
-- 	  height = height,
-- 	  row = row,
-- 	  col = col,
-- 	  style = 'minimal',
-- 	  border = 'single',
-- 	})
--
-- 	vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
-- 	  "This is a floating window",
-- 	  "You can use it for custom UI!",
-- 	})
-- end


---------------------------------------------------------------------------------------------------------------------------------
---ZEN MODE
zenmode = false
previous_wrap = false
previous_linebreak = false
previous_listchars = vim.opt.listchars

vim.api.nvim_create_user_command("Zen", function()
	if not zenmode then
		zenmode = true

		previous_wrap = vim.o.wrap
		previous_linebreak = vim.o.linebreak
		vim.o.wrap = true
		vim.o.linebreak = true

		vim.o.showbreak = ''
		vim.opt.listchars = { tab = '  ', trail = ' ', nbsp = ' ' }

		vim.keymap.set('n', 'j', 'gj')
		vim.keymap.set('n', 'k', 'gk')

		vim.cmd("ZenMode")
	else 
		zenmode = false;
		vim.o.wrap = previous_wrap
		vim.o.linebreak = previous_linebreak
		vim.opt.listchars = previous_listchars

		vim.keymap.del('n', 'j')
		vim.keymap.del('n', 'k')

		vim.cmd("ZenMode")
	end
end, { desc = "Activate a slightly better Zen mode" })




---------------------------------------------------------------------------------------------------------------------------------
--EVENTS / AUTOCOMMANDS
--see :help lua-guide-autocommands for a guide on how to use autocommands
--see :help events for a list of events you can listen to

-- Highlight yanked text
vim.api.nvim_create_autocmd('TextYankPost', {
	callback = function() vim.hl.on_yank() end
})


-- PLUGINS
---------------------------------------------------------------------------------------------------------------------------------
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
	'numToStr/Comment.nvim',
	{
		'folke/zen-mode.nvim',
		opts = {
			window = {
				width = 80
			}
		}
	},
	'junegunn/vim-easy-align',

	-- File explorer
	'justinmk/vim-dirvish',

	-- Various small mini-improvements like extra text objects. Bassicly just nice extra motions for vim
	'echasnovski/mini.nvim',

	-- Highlight TODO's and some comments and such
	 { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
	'ziontee113/color-picker.nvim',

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

	-- Colors and basic syntax highlighting!
{ -- You can easily change to a different colorscheme.
	  -- Change the name of the colorscheme plugin below, and then
	  -- change the command in the config to whatever the name of that colorscheme is.
	  --
	  -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
	  'folke/tokyonight.nvim',
	  priority = 1000, -- Make sure to load this before all the other start plugins.
	  config = function()
		 ---@diagnostic disable-next-line: missing-fields
		 require('tokyonight').setup {
			styles = {
			  comments = { italic = false }, -- Disable italics in comments
			},
		 }

		 -- Load the colorscheme here.
		 -- Like many other themes, this one has different styles, and you could load
		 -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
		 vim.cmd.colorscheme 'tokyonight-night'
	  end,
	},

	-- Transparent background
	'xiyaowong/transparent.nvim',

	-- More/better syntax highlighting with treesitter!
	{
		 'nvim-treesitter/nvim-treesitter',
		 build = ':TSUpdate',
		 config = function()
			require('nvim-treesitter.configs').setup {
			  ensure_installed = { "c", "lua", "python", "javascript", "typst" }, -- add what you use
			  ignore_install = {'org'},
			  highlight = {
				 enable = true, -- enable Treesitter highlighting
			  }
			}
		 end,
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
		      vim.keymap.set('n', '<leader>p', builtin.find_files,    { desc = '[S]earch [F]iles' })
		      vim.keymap.set('n', '<leader>ss', builtin.builtin,       { desc = '[S]earch [S]elect Telescope' })
		      vim.keymap.set('n', '<leader>sw', builtin.grep_string,   { desc = '[S]earch current [W]ord' })
		      vim.keymap.set('n', '<C-g>', builtin.live_grep,     { desc = '[S]earch by [G]rep' })
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
	{
		  'nvim-orgmode/orgmode',
		  event = 'VeryLazy',
		  ft = {'org'},
		  config = function()
					 require('orgmode').setup({
								org_agenda_files = '~/calendar/*',
								org_default_notes_file = '~/calendar/tasks.org'
					 })
		  end,
	},
	{
		  '3rd/image.nvim',
		  build = false,
		  opts = {
					 processor = "magick_cli",
		  },
		  config = function()
					 require("image").setup({
								  backend = "kitty",
								  processor = "magick_cli", -- or "magick_rock"
								  integrations = {
									 markdown = {
										enabled = true,
										clear_in_insert_mode = false,
										download_remote_images = true,
										only_render_image_at_cursor = false,
										only_render_image_at_cursor_mode = "popup",
										floating_windows = false, -- if true, images will be rendered in floating markdown windows
										filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
									 },
									 neorg = {
										enabled = true,
										filetypes = { "norg" },
									 },
									 typst = {
										enabled = true,
										filetypes = { "typst" },
									 },
									 html = {
										enabled = false,
									 },
									 css = {
										enabled = false,
									 },
								  },
								  max_width = nil,
								  max_height = nil,
								  max_width_window_percentage = nil,
								  max_height_window_percentage = 50,
								  window_overlap_clear_enabled = false, -- toggles images when windows are overlapped
								  window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "snacks_notif", "scrollview", "scrollview_sign" },
								  editor_only_render_when_focused = false, -- auto show/hide images when the editor gains/looses focus
								  tmux_show_only_in_active_window = false, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
								  hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" }, -- render image files as images when opened
					 })
		  end
	},
})

require('Comment').setup()
require('color-picker').setup()
---------------------------------------------------------------------------------------------------------------------------------
