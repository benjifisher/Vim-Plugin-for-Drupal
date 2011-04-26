:filetype on

"General settings
set incsearch
set ignorecase
set scrolloff=2
set smartcase
set number
set wildmode=longest,list
set pastetoggle=<F2>
set ffs=unix
set smartindent
set smarttab
set history=300
set showmode
set showmatch
set backspace=2
set hlsearch
set ruler
set formatoptions=1
set lbr

"Drupal settings
set expandtab
set tabstop=2
set shiftwidth=2
set autoindent
let php_htmlInStrings = 1
let php_parent_error_open = 1

if &t_Co > 1
  syntax enable
endif

nn [5C <C-W>w
nn [5R <C-W>W

if has("autocmd")
 " Drupal *.module and *.install files.
  augroup module
    autocmd BufRead,BufNewFile *.module set filetype=php
    autocmd BufRead,BufNewFile *.php set filetype=php
    autocmd BufRead,BufNewFile *.install set filetype=php
    autocmd BufRead,BufNewFile *.inc set filetype=php
    autocmd BufRead,BufNewFile *.profile set filetype=php
    autocmd BufRead,BufNewFile *.theme set filetype=php
  augroup END
endif
syntax on

"Custom key mapping
map <S-u> :redo<cr>
map <C-n> :tabn<cr>
map <C-p> :tabp<cr>

"Custom SVN blame
vmap gl :<C-U>!svn blame <C-R>=expand("%:P") <CR> \| sed -n <C-R>=line("'<") <CR>,<C-R>=line("'>") <CR>p <CR>

" Uncomment the following to have Vim jump to the last position when
" reopening a file
if has("autocmd")
 au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
 \| exe "normal! g'\"" | endif
endif

" Highlight long comments and trailing whitespace.
highlight ExtraWhitespace ctermbg=red guibg=red
let a = matchadd('ExtraWhitespace', '\s\+$')
highlight OverLength ctermbg=red ctermfg=white guibg=red guifg=white
let b = matchadd('OverLength', '\(^\(\s\)\{-}\(*\|//\|/\*\)\{1}\(.\)*\(\%81v\)\)\@<=\(.\)\{1,}$')
