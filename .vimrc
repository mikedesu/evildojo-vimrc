" This is Mike Bell's .vimrc file
call pathogen#infect()

" this is some magic for Command-T file navigation
let mapleader = "`"
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>w :CommandTFlush<cr>\|:CommandT<cr>
map <leader>e :CommandTFlush<cr>\|:CommandT %%<cr>
nnoremap <leader><leader> <c-^>

" Return key un-highlights searches
:nnoremap <CR> :nohlsearch<cr>

set t_Co=256
"set background=dark
"let g:solarized_termcolors=256
colorscheme lucius

syntax on

set ttyfast

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" BASIC EDITING CONFIGURATION
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible

" display incomplete commands
set showcmd

" allow unsaved background buffers and remember marks/undo for them
set hidden

" remember more commands and search history
set history=10000

set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set autoindent

" always have status line on
set laststatus=2

set showmatch
set incsearch
set hlsearch

set backspace=2
set number
set ruler
set smartindent

" makes searches case-sensitive only if they contain upper-case characters
set ignorecase smartcase

" highlights cursor line
set cursorline

set cmdheight=2
set switchbuf=useopen
set numberwidth=5
set showtabline=2
set winwidth=79
set shell=bash

" Prevent Vim from clobbering the scrollback buffer. See
" http://www.shallowsky.com/linux/noaltscreen.html
set t_ti= t_te=

" keep more context when scrolling off the end of a buffer
set scrolloff=3

" Store temporary files in a central spot
set backup
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" List open buffers and prompt for one to switch to
map <leader>b :buffers<CR>:buffer<Space>

" Enable file type detection
" Use the default filetype settings, so that mail gets 'tw' set to 72,
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
filetype plugin indent on

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CUSTOM AUTOCMDS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup vimrcEx
    " Clear all autocmds in the group
    autocmd!
    autocmd FileType text setlocal textwidth=78
    " Jump to last cursor position unless it's invalid or in an event handler
    autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MULTIPURPOSE TAB KEY
" Indent if we're at the beginning of a line. Else, do completion
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
inoremap <s-tab> <c-n>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RENAME CURRENT FILE 
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'))
    if new_name != '' && new_name != old_name
        exec ':saveas ' . new_name
        exec ':silent !rm ' . old_name
        redraw!
    endif
endfunction
map <leader>n :call RenameFile()<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Direction Key Remaps
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Map Right Hand Directionals to Left Hand Commands
noremap s h
noremap d k
noremap f j
noremap g l

" Map Left Hand Commands to Right Hand Directionals
noremap h s
noremap k d
noremap j f
noremap l g

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ARROW KEYS ARE UNACCEPTABLE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <Left> :echo "no!"<cr>
map <Right> :echo "no!"<cr>
map <Up> :echo "no!"<cr>
map <Down> :echo "no!"<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Function to open Chrome and search
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! Terms()
    call inputsave()
    let searchterm = input('Google: ')
    call inputrestore()
    return searchterm
endfunction
map <leader>g :! /usr/bin/open -a "/Applications/Google Chrome.app" 'https://google.com/search?q=<C-R>=Terms()<CR>'<CR><CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Open .vimrc faster, reload .vimrc faster
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nmap <leader>sv :so ~/.vimrc<CR>
nmap <leader>ev :e ~/.vimrc<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Hex editing stuff
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <leader>h :Hexmode<CR>

" ex command for toggling hex mode - define mapping if desired
command -bar Hexmode call ToggleHex()

" helper function to toggle hex mode
function ToggleHex()
  " hex mode should be considered a read-only operation
  " save values for modified and read-only for restoration later,
  " and clear the read-only flag for now
    let l:modified=&mod
    let l:oldreadonly=&readonly
    let &readonly=0
    let l:oldmodifiable=&modifiable
    let &modifiable=1
    if !exists("b:editHex") || !b:editHex
        " save old options
        let b:oldft=&ft
        let b:oldbin=&bin
        " set new options
        setlocal binary " make sure it overrides any textwidth, etc.
        let &ft="xxd"
        " set status
        let b:editHex=1
        " switch to hex editor
        %!xxd
    else
        " restore old options
        let &ft=b:oldft
        if !b:oldbin
            setlocal nobinary
        endif
        " set status
       let b:editHex=0
           " return to normal editing
           %!xxd -r
    endif
    " restore values for modified and read only state
    let &mod=l:modified
    let &readonly=l:oldreadonly
    let &modifiable=l:oldmodifiable
endfunction

if has ("autocmd")
    augroup Binary
        au!
        au BufReadPre *.bin,*.hex setlocal binary
        au BufReadPost *
            \ if exists('b:editHex') && b:editHex | 
            \   let b:editHex = 0
            \ endif
        au BufReadPost *
            \ if &binary | Hexmode | endif
        au BufUnload
            \ if getbufvar(expand("<afile>"), 'editHex') == 1 | 
            \   call setbufvar(expand("<afile>"), 'editHex', 0) | 
            \ endif
        au BufWritePre *
            \ if exists("b:editHex") && b:editHex && &binary | 
            \ let oldro=&ro | let &ro=0 | 
            \ let oldma=&ma | let &ma=1 |
            \ silent exe "%!xxd" | 
            \ exe "set nomod" | 
            \ let &ma=oldma | let &ro=oldro | 
            \ unlet oldma | unlet oldro | 
            \ endif
    augroup END
endif

