call plug#begin('~/.vim/plugged')

Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-commentary'
Plug 'frazrepo/vim-rainbow'
Plug 'simnalamburt/vim-mundo'
Plug 'justinmk/vim-dirvish'
Plug 'junegunn/vim-easy-align'
Plug 'roginfarrer/vim-dirvish-dovish', {'branch': 'main'}
Plug 'junegunn/goyo.vim'
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

nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l
nnoremap <A-d> :vsplit<CR>
nnoremap <A-f> :split<CR>
nnoremap <A-t> :tabnew<CR>
nnoremap <A-e> :tabprevious<CR>
nnoremap <A-r> :tabnext<CR>
nnoremap <A-g> :vertical resize -10<CR>
nnoremap <A-s> :vertical resize +10<CR>
nnoremap yl :silent !latexmk -pdf % > /dev/null 2>&1 &<CR>:redraw!<CR>

xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" Toggle number + relativenumber with Alt+n
nnoremap <silent> <A-n> :call ToggleLineNumbers()<CR>

function! ToggleLineNumbers()
  if &number
    set nonumber norelativenumber
  else
    set number relativenumber
  endif
endfunction

" EASY ALIGN	
" ==================================================
let g:easy_align_delimiters = {
\ ';': { 'pattern': ';', 'left_margin': 0, 'right_margin': 1, 'stick_to_left': 1 },
\ '_': { 'pattern': '_', 'left_margin': 0, 'right_margin': 0, 'stick_to_left': 0 },
\ 'c': { 'pattern': '_', 'left_margin': 0, 'right_margin': 0, 'stick_to_left': 0 }
\ }
" let s:easy_align_delimiters_default = {
" \  ' ': { 'pattern': ' ',  'left_margin': 0, 'right_margin': 0, 'stick_to_left': 0 },
" \  '=': { 'pattern': '===\|<=>\|\(&&\|||\|<<\|>>\)=\|=\~[#?]\?\|=>\|[:+/*!%^=><&|.-]\?=[#?]\?',
" \                          'left_margin': 1, 'right_margin': 1, 'stick_to_left': 0 },
" \  ':': { 'pattern': ':',  'left_margin': 0, 'right_margin': 1, 'stick_to_left': 1 },
" \  ',': { 'pattern': ',',  'left_margin': 0, 'right_margin': 1, 'stick_to_left': 1 },
" \  '|': { 'pattern': '|',  'left_margin': 1, 'right_margin': 1, 'stick_to_left': 0 },
" \  '.': { 'pattern': '\.', 'left_margin': 0, 'right_margin': 0, 'stick_to_left': 0 },
" \  '#': { 'pattern': '#\+', 'delimiter_align': 'l', 'ignore_groups': ['!Comment']  },
" \  '&': { 'pattern': '\\\@<!&\|\\\\',
" \                          'left_margin': 1, 'right_margin': 1, 'stick_to_left': 0 },
" \  '{': { 'pattern': '(\@<!{',
" \                          'left_margin': 1, 'right_margin': 1, 'stick_to_left': 0 },
" \  '}': { 'pattern': '}',  'left_margin': 1, 'right_margin': 0, 'stick_to_left': 0 }
" \ }
" ===========================================================

" DIRVISH
" ======================================================
nmap <silent><buffer> e <Plug>(dovish_delete)
" =======================================================
let g:rainbow_active = 1


" FZF and RIPGREP
" ==========================================================================
let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'
set grepprg=rg\ --vimgrep\ --smart-case\ --follow
command! -nargs=* Rgi call fzf#vim#grep("rg -i --vimgrep --hidden --glob '!.git/*' ".shellescape(<q-args>), 1, fzf#vim#with_preview(), 0)

function! s:open_file_and_close_current(file)
  " Save current buffer if modified
  if &modified
    write
  endif

  " Get current buffer number
  let l:curbuf = bufnr('%')

  " Check if buffer is visible in more than one window
  if len(win_findbuf(l:curbuf)) <= 1	
    exec 'bd'
  endif

  " Open selected file
  exec 'edit ' . fnameescape(a:file)
endfunction

function! SmartBufferClean()
  " Save current buffer number
  let l:curbuf = bufnr('%')

  " Delete all buffers
  silent! execute '%bd'

  " Reopen the saved buffer if it still exists
  if buflisted(l:curbuf)
    execute 'buffer' l:curbuf
  else
    " Fallback: try to reopen alternate file
    if expand('#') != ''
      execute 'edit #'
    endif
  endif
endfunction

" Map it to <Del><Del>
nnoremap <silent> <Del><Del> :call SmartBufferClean()<CR>
" ==========================================================================

" ZEN MODE
" =============================================================
let g:display_line_mode = 0

function! ToggleDisplayLineMode()
  if g:display_line_mode
    unmap j
    unmap k
    unmap <buffer> j
    unmap <buffer> k
    let g:display_line_mode = 0
    echo "Display-line mode OFF"
  else
    nnoremap j gj
    nnoremap k gk
    vnoremap j gj
    vnoremap k gk
    let g:display_line_mode = 1
    echo "Display-line mode ON"
  endif
endfunction

command! Zen call ZenMode()

function! ZenMode()
  Goyo
  set wrap!
  call ToggleDisplayLineMode()
endfunction
" =============================================================

set number
set nocompatible
set relativenumber number
set hlsearch
set ignorecase smartcase
set wrapscan
set nowrap
nnoremap <esc><esc> :noh<return><esc>
set nrformats+=alpha
set tabstop=4
set shiftwidth=4
set hidden
set so=999
set wrap!

let g:fzf_layout = { 'down': 12 }
