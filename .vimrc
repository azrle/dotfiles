" don't bother with vi compatibility
set nocompatible

" enable syntax highlighting
syntax enable

" configure Vundle
filetype on " without this vim emits a zero exit status, later, because of :ft off
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" install Vundle bundles
if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
"  source ~/.vimrc.bundles.local
endif

" ensure ftdetect et al work by including this after the Vundle stuff
filetype plugin indent on

set shell=bash
set autoindent
set autoread                                                 " reload files when changed on disk, i.e. via `git checkout`
set backspace=2                                              " Fix broken backspace in some setups
set backupcopy=yes                                           " see :help crontab
set clipboard=unnamed                                        " yank and paste with the system clipboard
set directory-=.                                             " don't store swapfiles in the current directory
set encoding=utf-8
set expandtab                                                " expand tabs to spaces
set ignorecase                                               " case-insensitive search
set incsearch                                                " search as you type
set laststatus=2                                             " always show statusline
set list                                                     " show trailing whitespace
set listchars=tab:▸\ ,trail:▫
set number                                                   " show line numbers
set ruler                                                    " show where you are
set scrolloff=3                                              " show context above/below cursorline
set shiftwidth=4                                             " normal mode indentation commands use 4 spaces
set showcmd
set smartcase                                                " case-sensitive search if any caps
set softtabstop=2                                            " insert mode tab and backspace use 2 spaces
set tabstop=4                                                " actual tabs occupy 4 characters
set wildignore=log/**,node_modules/**,target/**,tmp/**,*.rbc
set wildmenu                                                 " show a navigable menu for tab completion
set wildmode=longest,list,full
set t_Co=256
set cursorline

" Enable basic mouse behavior such as resizing buffers.
" set mouse=a
" if exists('$TMUX')  " Support resizing in tmux
"   set ttymouse=xterm2
" endif

" thanks to http://vimcasts.org/episodes/tidying-whitespace/
function! <SID>StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction

" keyboard shortcuts
let mapleader = ','
vmap <F2> :.w !pbcopy<CR><CR>
imap <F2> <ESC>:.w !pbcopy<CR><CR>
imap <C-i> <ESC><leader><leader>lw
imap <C-o> <ESC><leader><leader>le
imap <C-e> <ESC>A
imap <C-a> <ESC>I
" map <C-h> <C-w>h
" map <C-j> <C-w>j
" map <C-k> <C-w>k
" map <C-l> <C-w>l
map <leader>l :Align
nmap <C-i> <leader><leader>lw
nmap <C-o> <leader><leader>le
nmap t <leader><leader>lw
nmap T <leader><leader>le
nmap <F2> :.w !pbcopy<CR><CR>
nmap <leader>r :set rnu<CR>
nmap <leader>b :CtrlPBuffer<CR>
nmap <leader>d :NERDTreeToggle<CR>
nmap <leader>f :NERDTreeFind<CR>
nmap <leader>t :CtrlPCurWD<CR>
nmap <leader>T :CtrlPClearCache<CR>:CtrlPCurWD<CR>
nmap <leader>] :TagbarToggle<CR>
nmap <leader>g :GitGutterToggle<CR>
nmap <leader><space> :call <SID>StripTrailingWhitespaces()<CR>
map <silent> <leader>V :source ~/.vimrc<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>

" molokai color
let g:molokai_original = 0
let g:rehash256 = 0
colorscheme molokai
if has('gui_running')
  set guifont=Menlo_Regular:h14
endif

" plugin settings
let g:ctrlp_match_window = 'order:ttb,max:20'
let g:ctrlp_working_path_mode = 'ra'
let g:NERDSpaceDelims    = 1
let g:NERDTreeDirArrows  = 0
let g:gitgutter_enabled  = 0
let g:indent_guides_guide_size = 1
" Don't allow gitgutter eager loading if we are using an old version of vim.
if !exists("*gettabvar")
  let g:gitgutter_eager = 0
endif
let g:syntastic_perl_checkers = ['perl']
let g:syntastic_php_checkers = ['php', 'phpcs', 'phpmd']
let g:syntastic_enable_perl_checker = 1

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  let g:ackprg = 'ag --nogroup --column'

  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif

" fcgi is perl
autocmd BufRead,BufNewFile *.fcgi set filetype=perl
" psgi is perl
autocmd BufRead,BufNewFile *.psgi set filetype=perl
" tt is html template
autocmd BufRead,BufNewFile *.tt set filetype=html
" fdoc is yaml
autocmd BufRead,BufNewFile *.fdoc set filetype=yaml
" md is markdown
autocmd BufRead,BufNewFile *.md set filetype=markdown
" automatically rebalance windows on vim resize
autocmd VimResized * :wincmd =
" remove unexpected spaces
" autocmd FileType c,cpp,java,php,perl,html,sql,markdown autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()

" Fix Cursor in TMUX
if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif
