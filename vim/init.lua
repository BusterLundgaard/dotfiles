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

vim.opt.switchbuf = { "useopen", "usetab" }

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

-- vim.keymap.set('n', '<a-1>', '<cmd>tabfir<CR>');
-- vim.keymap.set('n', '<a-2>', '<cmd>tabfir<CR><cmd>+tabnext<CR>')
-- vim.keymap.set('n', '<a-3>', '<cmd>tabfir<CR><cmd>+2tabnext<CR>')
-- vim.keymap.set('n', '<a-4>', '<cmd>tabfir<CR><cmd>+3tabnext<CR>')
-- vim.keymap.set('n', '<a-5>', '<cmd>tabfir<CR><cmd>+4tabnext<CR>')
-- vim.keymap.set('n', '<a-6>', '<cmd>tabfir<CR><cmd>+5tabnext<CR>')
-- vim.keymap.set('n', '<a-7>', '<cmd>tabfir<CR><cmd>+6tabnext<CR>')
-- vim.keymap.set('n', '<a-+>', '<cmd>tabnew<CR>')
-- vim.keymap.set('n', '<a-->', '<cmd>tabclose<CR>')
-- vim.keymap.set('n', '<a-tab>', '<cmd>tabnext<CR>')

vim.keymap.set('n', '<C-c>', function() 
	vim.cmd("w")
	local command = ""
	local filetype = vim.bo.filetype
	if filetype == 'typst' then
		command = "typst compile --diagnostic-format=short " .. vim.api.nvim_buf_get_name(0)
	else
		command = "make"
	end
	command = command .. " 2> ~/.compile_errors.txt"
	vim.fn.jobstart(command, {
		stderr_buffered = true,
		on_exit = function(_, exit_code)
			if exit_code ~= 0 then
				vim.cmd("cfile ~/.compile_errors.txt")
			else
				print("Compile success!")
			end
		end
	})
end);


-- ZEN MODE
---------------------------------------------------------------------------------------------------------------------------------
zenmode = false
previous_listchars = vim.opt.listchars
previous_showbreak = vim.opt.showbreak

vim.api.nvim_create_user_command("Zen", function()
	if not zenmode then
		zenmode = true

		vim.o.wrap = true
		vim.o.linebreak = true
		vim.o.showbreak = ''
		vim.opt.listchars = { tab = '  ', trail = ' ', nbsp = ' ' }

		vim.keymap.set('n', 'j', 'gj')
		vim.keymap.set('n', 'k', 'gk')

		vim.cmd("ZenMode")
	else 
		zenmode = false;
		vim.o.wrap = false
		vim.o.linebreak = false
		vim.opt.listchars = previous_listchars
		vim.opt.showbreak = previous_showbreak

		vim.keymap.del('n', 'j')
		vim.keymap.del('n', 'k')

		vim.cmd("ZenMode")
	end
end, { desc = "Activate a slightly better Zen mode" })

-- Highlight yanked text
vim.api.nvim_create_autocmd('TextYankPost', {
	callback = function() vim.hl.on_yank() end
})

-- PLUGINS
---------------------------------------------------------------------------------------------------------------------------------
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
	-- Adds support for comments plus loads of nice little motions
	"echasnovski/mini.nvim",

	-- Zen mode
	{
	'folke/zen-mode.nvim',
	opts = {
		window = {
			width = 80
		}
	}

	-- File explorer
	},
	'justinmk/vim-dirvish',

	-- Syntax highlighting with treesitter
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
	{
		"aktersnurra/no-clown-fiesta.nvim",
		priority = 1000,
		config = function()
			local plugin = require "no-clown-fiesta"
			return plugin.load({
				theme = "dark",
				styles = {
					type = { bold = true },
					lsp = { underline = false },
					match_paren = { underline = true },
				},
			})
		end,
	},
	{
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
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
		config = function() 
			local harpoon = require("harpoon")
			harpoon:setup()
			vim.keymap.set("n", "<C-S-æ>", function() harpoon:list():clear() end)
			vim.keymap.set("n", "<C-ø>", function() harpoon:list():add() end)
			vim.keymap.set("n", "<C-å>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
			vim.keymap.set("n", "<a-1>", function() harpoon:list():select(1) end)
			vim.keymap.set("n", "<a-2>", function() harpoon:list():select(2) end)
			vim.keymap.set("n", "<a-3>", function() harpoon:list():select(3) end)
			vim.keymap.set("n", "<a-4>", function() harpoon:list():select(4) end)
		end
	},
})

---------------------------------------------------------------------------------------------------------------------------------
