call plug#begin('~/.vim/plugged')

Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-commentary'
Plug 'frazrepo/vim-rainbow'
Plug 'simnalamburt/vim-mundo'
" Example plugin
" Plug 'tpope/vim-sensible'

call plug#end()

nnoremap `` `.
nnoremap <C-e> 10<C-e>
nnoremap <C-y> 10<C-y>
nnoremap <C-p> :Files<CR>
nnoremap <C-g> :Rg<CR>
nnoremap K :m .-2<CR>==
nnoremap J :m .+1<CR>==
vnoremap K :m '<-2<CR>gv=gv
vnoremap J :m '>+1<CR>gv=gv
nnoremap <silent> <cr> :noh<cr>

let g:rainbow_active = 1

let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'
set grepprg=rg\ --vimgrep\ --smart-case\ --follow
command! -nargs=* Rgi call fzf#vim#grep("rg -i --vimgrep --hidden --glob '!.git/*' ".shellescape(<q-args>), 1, fzf#vim#with_preview(), 0)

set number
set nocompatible
set relativenumber number
set hlsearch
set ignorecase smartcase
set wrapscan
nnoremap <esc><esc> :noh<return><esc>
set nrformats+=alpha
set tabstop=4
set shiftwidth=4
set hidden
set so=999

let g:fzf_layout = { 'down': 12 }
