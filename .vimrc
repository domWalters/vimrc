" My vimrc file.

" When started as "evim", evim.vim will already have done these settings, bail
" out.
if v:progname =~? "evim"
  finish
endif

" Start of Vundle
set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'vim-pandoc/vim-pandoc-syntax'
Plugin 'vim-pandoc/vim-pandoc'
Plugin 'ycm-core/YouCompleteMe'
call vundle#end()
filetype plugin indent on
" End of Vundle

" Get the defaults that most users want. Warning: This line breaks git vi.
" source $VIMRUNTIME/defaults.vim

" Contents of defaults.vim as of 27/09/19
" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
" Avoid side effects when it was already reset.
if &compatible
  set nocompatible
endif

" When the +eval feature is missing, the set command above will be skipped.
" Use a trick to reset compatible only when the +eval feature is missing.
silent! while 0
  set nocompatible
silent! endwhile


" Do incremental searching when it's possible to timeout.
if has('reltime')
  set incsearch
endif

" Do not recognize octal numbers for Ctrl-A and Ctrl-X, most users find it
" confusing.
set nrformats-=octal

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries.
if has('win32')
  set guioptions-=t
endif

" Don't use Ex mode, use Q for formatting.
" Revert with ":unmap Q".
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
" Revert with ":iunmap <C-U>".
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine.  By enabling it you
" can position the cursor, Visually select and scroll with the mouse.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on when the terminal has colors or when using the
" GUI (which always has colors).
if &t_Co > 2 || has("gui_running")
  set hlsearch " Switch on highlighting the last used search pattern.
  syntax on
  " I like highlighting strings inside C comments.
  " Revert with ":unlet c_comment_strings".
  let c_comment_strings=1
endif

" Only do this part when Vim was compiled with the +eval feature.
if 1
  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  " Revert with ":filetype off".
  filetype plugin indent on
  " Put these in an autocmd group, so that you can revert them with:
  " ":augroup vimStartup | au! | augroup END"
  augroup vimStartup
    au!
    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid, when inside an event handler
    " (happens when dropping a file on gvim) and for a commit message (it's
    " likely a different one than last time).
    autocmd BufReadPost *
      \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
      \ |   exe "normal! g`\""
      \ | endif
  augroup END
endif

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
" Revert with: ":delcommand DiffOrig".
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
        \ | wincmd p | diffthis
endif

if has('langmap') && exists('+langremap')
  " Prevent that the langmap option applies to characters that result from a
  " mapping.  If set (default), this may break plugins (but it's backward
  " compatible).
  set nolangremap
endif

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file (restore to previous version)
  if has('persistent_undo')
    set undofile	" keep an undo file (undo changes after closing)
  endif
endif

" Put these in an autocmd group, so that we can delete them easily.
augroup vimrcEx
  au!
  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78
augroup END

" Add optional packages.
"
" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
" The ! means the package won't be loaded right away but when plugins are
" loaded during initialization.
if has('syntax') && has('eval')
  packadd! matchit
endif

" Line Settings
set number              " Show line numbers
highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE
set cursorline          " Highlight the line the cursor is on
set ruler
set laststatus=2

" Tab and Indent Settings
set tabstop=2           " Indent with 2 spaces
set softtabstop=2       " Backspace deletes 2 spaces if possible
set expandtab           " Tabs to spaces
set shiftwidth=2        " Use 2 spaces when shifting (>>)
set autoindent          " New lines inherit indent level
set smarttab            " Insert tabstop spaces when tab pressed

" List chars
set listchars=tab:>-,eol:¬,trail:⌴,extends:>,precedes:<,space:·" Show \t as >-
highlight SpecialKey term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE
noremap <F5> :set list!<CR>
inoremap <F5> <C-o>:set list!<CR>
cnoremap <F5> <C-c>:set list!<CR>
set list

" Other Settings
set dir=~/.cache/vim            " Place swaps here
set backupdir=~/.cache/vim      " Place backups here
set undodir=~/.cache/vim        " Place undo files here
set backspace=indent,eol,start  " Allow backspacing over everything in insert mode.
set history=200                 " keep 200 lines of command line history
set showcmd                     " display incomplete commands
set wildmenu                    " display completion matches in a status line
set ttimeout                    " time out for key codes
set ttimeoutlen=100             " wait up to 100ms after Esc for special key
set display=truncate            " Show @@@ in the last line if it is truncated.
set scrolloff=5                 " Always show 5 lines around the cursor

" Fold Settings
set foldmethod=indent           " Automatically generate folds based on indenting
set foldcolumn=1                " Show where open folds are
set foldlevelstart=99

" File Tree
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 15
let g:netrw_list_hide = '.*\.swp$,.*\.*\~$,*\~$'
set autochdir

"augroup ProjectDrawer
"  autocmd!
"  autocmd VimEnter * :Lexplore
"augroup END

augroup closeNetrwIfLastBuffer
  au!
  autocmd WinEnter * if winnr('$') == 1 && getbufvar(winbufnr(winnr()), "&filetype") == "netrw" || &buftype == 'quickfix' |q|endif
  nmap - :Lexplore<CR>
augroup END

" Toggle Lexplore with Ctrl-E
let g:NetrwIsOpen=1

function! ToggleNetrw()
  if g:NetrwIsOpen
    let i = bufnr("$")
    while (i >= 1)
      if (getbufvar(i, "&filetype") == "netrw")
        silent exe "bwipeout " . i
      endif
      let i-=1
    endwhile
    let g:NetrwIsOpen=0
  else
    let g:NetrwIsOpen=1
    silent Lexplore
    set nolist
  endif
endfunction
map <silent> <C-E> :call ToggleNetrw()<CR>

" YCM Config
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'

" Binds to prevent accidental shift keying of saving and closing
command W w
command Q q
command WQ wq
