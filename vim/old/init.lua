-- TODO:
-- Basic LSP setup
-- Want it to be possible to change what make command we use when we press ctrl+c
-- Should be easier to turn off/on image preview
-- Maybe the half-a-screen scrolling thing does it in "chunks" with a few ms between, so that it's easier to orient one self
-- Maybe a quick way to move the cursor 15 lines?

-- ESSENTIAL OPTIONS
----------------------------------------------------------------------------------------------------------------------------------
-- vim.g.mapleader = ' '
-- vim.g.maplocalleader = ' '

vim.o.number = true
vim.o.relativenumber = true

vim.o.wrap = false

vim.o.breakindent = true
vim.o.showbreak = '↪'
vim.o.tabstop = 3
vim.o.shiftwidth = 3
vim.opt.expandtab = false

vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '.', nbsp = '␣' }
--how many lines to the bottom or top should the cursor be before we start scrolling the screen?
-- vim.o.scrolloff = 10

vim.o.mouse = 'a'

vim.g.have_nerd_font = true

-- We do this scheduling as a trick to decrease startup time
vim.schedule(function() 
end)
vim.o.clipboard = 'unnamedplus'

vim.o.undofile = true

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.updatetime = 4000
vim.o.timeoutlen = 300

-- This somewhat cryptic setting previews substitutions live as you type!
vim.o.inccommand = 'split'

-- Ask user if they want to save unsaved buffer when performming an operation that would fail due to an unsaved buffer
vim.o.confirm = true

vim.g.neovide_refresh_rate = 120

vim.opt.grepprg = "rg --vimgrep"
vim.opt.grepformat = "%f:%l:%c:%m"

---------------------------------------------------------------------------------------------------------------------------------

-- BASIC KEYMAPS
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

-- Moves lines up/down
vim.keymap.set('n', '<S-j>', ':m .+1<CR>==')
vim.keymap.set('n', '<S-k>', ':m .-2<CR>==')
vim.keymap.set('v', '<S-j>', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', '<S-k>', ":m '<-2<CR>gv=gv")

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', {desc = 'Move focus to the left window'})
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', {desc = 'Move focus to the below window'})
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', {desc = 'Move focus to the upper window'})
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', {desc = 'Move focus to the right window'})
vim.keymap.set('n', '<C-d>', '<cmd>split<CR>', {desc = 'Split window vertically'})
vim.keymap.set('n', '<C-f>', '<cmd>vsplit<CR>', {desc = 'Split window horizontally'})
vim.keymap.set('n', '<C-q>', '<cmd>q<CR>', {desc = 'Quit window'})
vim.keymap.set('n', '<C-w>', '<cmd>w<CR>', {desc = 'Save bufer'})
vim.keymap.set('n', '<C-n>', '<cmd>cnext<CR>')
vim.keymap.set('n', '<C-b>', '<cmd>cprev<CR>')
vim.keymap.set('n', '<C-e>', '5<C-e>')
vim.keymap.set('n', '<C-y>', '5<C-y>')
vim.keymap.set('n', '<C-u>', '25<C-e>')
vim.keymap.set('n', '<C-i>', '25<C-y>')
vim.keymap.set('n', '<C-Right>', '<cmd>cnext<CR>')
vim.keymap.set('n', '<C-Left>', '<cmd>cprev<CR>')

vim.keymap.set('n', '<a-l>', '<cmd>vertical res +5<CR>', {desc = "Resize window left"})
vim.keymap.set('n', '<a-h>', '<cmd>vertical res -5<CR>', {desc = "Resize window left"})
vim.keymap.set('n', '<a-j>', '<cmd>horizontal res +5<CR>', {desc = "Resize window left"})
vim.keymap.set('n', '<a-k>', '<cmd>horizontal res -5<CR>', {desc = "Resize window left"})
vim.keymap.set('n', '<a-Right>', '<cmd>bnext<CR>')
vim.keymap.set('n', '<a-Left>', '<cmd>bprev<CR>')
vim.keymap.set('n', '<a-Up>', '<C-W>}')

show_top_start = false
local saved_view = nil
vim.keymap.set('n', '<a-g>', function() 
	show_top_start = not show_top_start
	if show_top_start then
		saved_view = vim.fn.winsaveview()
		vim.cmd("normal! mtgg")
	else
		if saved_view then
			vim.fn.winrestview(saved_view)
		end
	end
end)

vim.keymap.set('n', '<Space>', function() 
	local create_split = vim.api.nvim_replace_termcodes("moi<CR><Esc>`o", true, false, true)
	vim.api.nvim_feedkeys(create_split, 'n', false)
end)

vim.keymap.set('n', '<a-1>', '<cmd>tabfir<CR>');
vim.keymap.set('n', '<a-2>', '<cmd>tabfir<CR><cmd>+tabnext<CR>')
vim.keymap.set('n', '<a-3>', '<cmd>tabfir<CR><cmd>+2tabnext<CR>')
vim.keymap.set('n', '<a-4>', '<cmd>tabfir<CR><cmd>+3tabnext<CR>')
vim.keymap.set('n', '<a-5>', '<cmd>tabfir<CR><cmd>+4tabnext<CR>')
vim.keymap.set('n', '<a-6>', '<cmd>tabfir<CR><cmd>+5tabnext<CR>')
vim.keymap.set('n', '<a-7>', '<cmd>tabfir<CR><cmd>+6tabnext<CR>')
vim.keymap.set('n', '<a-+>', '<cmd>tabnew<CR>')
vim.keymap.set('n', '<a-->', '<cmd>tabclose<CR>')
vim.keymap.set('n', '<a-tab>', '<cmd>tabnext<CR>')


---------------------------------------------------------------------------------------------------------
--- WHOLE BUNCH OF COMPLICATED SCROLLING BEHAVIOUR
---------------------------------------------------------------------------------------------------------
-- local scroll_namespace_id = vim.api.nvim_create_namespace("scrolling_namespace")
-- function highlight_around_current_line_a_bit() 
-- 	local buf = vim.api.nvim_get_current_buf()
-- 	local current_line_number = vim.fn.getpos(".")[2]
-- 	local next_line_length = string.len(vim.fn.getline(current_line_number+1))
-- 	vim.hl.range(buf, scroll_namespace_id, "Visual", {current_line_number-2, 0}, {current_line_number, next_line_length})
--
-- 	vim.defer_fn(function() 
-- 		vim.api.nvim_buf_clear_namespace(buf, scroll_namespace_id, 0, -1)
-- 	end, 800)
-- end
--
-- vim.keymap.set('n', '<C-u>', function()
-- 	highlight_around_current_line_a_bit()
-- 	half_window_up = vim.api.nvim_replace_termcodes("<C-d>", true, false, true)
-- 	vim.api.nvim_feedkeys(half_window_up, 'n', false)
-- end)
--
-- vim.keymap.set('n', '<C-i>', function()
-- 	highlight_around_current_line_a_bit()
-- 	half_window_up = vim.api.nvim_replace_termcodes("<C-u>", true, false, true)
-- 	vim.api.nvim_feedkeys(half_window_up, 'n', false)
-- end)
--
--
-- scrolling_started = false
-- scrolling_active = false;
-- previous_scroll = 0; -- The scroll position (in terms of line number at top of screen, not cursor...)
--
-- function move_cursor_to_screen_center()
--   local topline = vim.fn.line("w0")
--   local botline = vim.fn.line("w$")
--
--   local center_line = math.floor((topline + botline) / 2)
--   local col = vim.fn.col(".")
--   vim.api.nvim_win_set_cursor(0, { center_line, col - 1 })
-- end
--
-- vim.keymap.set('n', '<a-e>', function() 
-- 	if not scrolling_started then
-- 		vim.cmd("normal! ms")
-- 		previous_scroll = vim.fn.getpos("w0")[2]
-- 		scrolling_started = true
-- 	end
--
-- 	scroll_up = vim.api.nvim_replace_termcodes("5<C-e>", true, false, true)
-- 	vim.api.nvim_feedkeys(scroll_up, 'n', false)
-- 	scrolling_active = true
-- 	vim.defer_fn(function() scrolling_active = false end, 20)
-- end)
-- vim.keymap.set('n', '<a-y>', function()
-- 	if not scrolling_started then
-- 		vim.cmd("normal! ms")
-- 		previous_scroll = vim.fn.getpos("w0")[2]
-- 		scrolling_started = true
-- 	end
--
-- 	scroll_up = vim.api.nvim_replace_termcodes("5<C-y>", true, false, true)
-- 	vim.api.nvim_feedkeys(scroll_up, 'n', false)
-- 	scrolling_active = true
-- 	vim.defer_fn(function() scrolling_active = false end, 20)
-- end)
-- vim.keymap.set('n', '<Space>', function() 
-- 	if scrolling_started then
-- 		scrolling_started = false
-- 		move_cursor_to_screen_center()
-- 	else
-- 		local create_split = vim.api.nvim_replace_termcodes("moi<CR><Esc>`o", true, false, true)
-- 		vim.api.nvim_feedkeys(create_split, 'n', false)
-- 	end
-- end)
--
-- vim.api.nvim_create_autocmd("CursorMoved", {callback = function() 
-- 	if not scrolling_active and scrolling_started then
-- 		scrolling_started = false
-- 		-- so, we're trying to both set the cursor and the screen/scrolling, but nvim doesn't let us set scroll directly
-- 		-- so we have to set cursor, then use scroll to top command, then set cursor again
-- 		vim.api.nvim_win_set_cursor(0, {previous_scroll, 0})
-- 		vim.cmd("normal! zt")
-- 		vim.cmd("normal! `s")
-- 	end
-- end})
-- vim.api.nvim_create_autocmd("CursorMovedI", {callback = function() 
-- 	if not scrolling_active and scrolling_started then
-- 		scrolling_started = false
-- 		vim.api.nvim_win_set_cursor(0, {previous_scroll, 0})
-- 		vim.cmd("normal! zt")
-- 		vim.cmd("normal! `s zz")
-- 	end
-- end})

-- Move lines up/down

----------------------------------------------------------------------------------------------------------------------------------------
-- COMPILATION
----------------------------------------------------------------------------------------------------------------------------------------
vim.keymap.set('n', '<C-c>', function() 
	vim.cmd("w")
	local command = ""
	local filetype = vim.bo.filetype
	if filetype == 'typst' then
		command = "typst compile --diagnostic-format=short " .. vim.api.nvim_buf_get_name(0)
	else
		command = "make " .. vim.g.my_make_cmd
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

vim.g.my_make_cmd = ""
vim.api.nvim_create_user_command('SetMakeCmd', function(opts)
	if opts.args == " " then
		vim.g.my_make_cmd = '';
	else
		vim.g.my_make_cmd = opts.args
	end
end, { nargs = 1 })

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
	{
		'numToStr/Comment.nvim',
		-- lazy = false,
		config = function()
			require('Comment').setup()
		end,
	},
	{
		'folke/zen-mode.nvim',
		opts = {
			window = {
				width = 80
			}
		}
	},
	-- 'junegunn/vim-easy-align',

	-- File explorer
	'justinmk/vim-dirvish',

	-- Various small mini-improvements like extra text objects. Bassicly just nice extra motions for vim
	'echasnovski/mini.nvim',

	-- Highlight TODO's and some comments and such
	 { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
	'ziontee113/color-picker.nvim',

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
	{
		'xiyaowong/transparent.nvim',
		config = function() 
			vim.cmd("TransparentEnable")
		end
	},

	-- More/better syntax highlighting with treesitter!
	{
		 'nvim-treesitter/nvim-treesitter',
		 build = ':TSUpdate',
		 config = function()
			require('nvim-treesitter.configs').setup {
			  ensure_installed = { "c", "lua", "python", "javascript", "typst", "zig", "r"}, -- add what you use
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
			vim.keymap.set('n', '<C-æ>', builtin.find_files,    { desc = '[S]earch [F]iles' })
			vim.keymap.set('n', '<C-g>', builtin.live_grep,     { desc = '[S]earch by [G]rep' })
			vim.keymap.set('n', '<C-S-g>', function()
				 local word = vim.fn.expand('<cword>')
				 local results = vim.fn.systemlist('rg --vimgrep ' .. vim.fn.shellescape(word))

				 if true then
					  -- Parse the single result: "file:line:col:text"
					  local file, line, col = results[1]:match('([^:]+):(%d+):(%d+):')
					  if file then
							vim.cmd('edit ' .. file)
							vim.api.nvim_win_set_cursor(0, { tonumber(line), tonumber(col) - 1 })
					  end
				 else
					  builtin.live_grep({ default_text = word })
				 end
			end, { desc = '[S]earch [W]ord under cursor' })
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
		'derektata/lorem.nvim',
		config = function()
			require("lorem").opts {
				sentence_length = "mixed", -- using a default configuration
				comma_chance = 0.3, -- 30% chance to insert a comma
				max_commas = 2, -- maximum 2 commas per sentence
				debounce_ms = 200, -- default debounce time in milliseconds
			}
		end
	}})
-- 	{
-- 		  '3rd/image.nvim',
-- 		  build = false,
-- 		  opts = {
-- 					 processor = "magick_cli",
-- 		  },
-- 		  config = function()
-- 					 require("image").setup({
-- 								  backend = "kitty",
-- 								  processor = "magick_cli", -- or "magick_rock"
-- 								  integrations = {
-- 									 markdown = {
-- 										enabled = true,
-- 										clear_in_insert_mode = false,
-- 										download_remote_images = true,
-- 										only_render_image_at_cursor = false,
-- 										only_render_image_at_cursor_mode = "popup",
-- 										floating_windows = false, -- if true, images will be rendered in floating markdown windows
-- 										filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
-- 									 },
-- 									 neorg = {
-- 										enabled = true,
-- 										filetypes = { "norg" },
-- 									 },
-- 									 typst = {
-- 										enabled = true,
-- 										filetypes = { "typst" },
-- 									 },
-- 									 html = {
-- 										enabled = false,
-- 									 },
-- 									 css = {
-- 										enabled = false,
-- 									 },
-- 								  },
-- 								  max_width = nil,
-- 								  max_height = nil,
-- 								  max_width_window_percentage = nil,
-- 								  max_height_window_percentage = 50,
-- 								  window_overlap_clear_enabled = false, -- toggles images when windows are overlapped
-- 								  window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "snacks_notif", "scrollview", "scrollview_sign" },
-- 								  editor_only_render_when_focused = false, -- auto show/hide images when the editor gains/looses focus
-- 								  tmux_show_only_in_active_window = false, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
-- 								  hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" }, -- render image files as images when opened
-- 					 })
-- 		  end
-- 	}
-- })

require('Comment').setup()
require('color-picker').setup()
---------------------------------------------------------------------------------------------------------------------------------
