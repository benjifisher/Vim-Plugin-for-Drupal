" Allow Vim-only settings even if they break vi keybindings.
set nocompatible

" Always edit in utf-8:
set encoding=utf-8

" Enable filetype detection
filetype plugin on

" General settings
set incsearch               "Find as you type
set scrolloff=2             "Number of lines to keep above/below cursor
set number                  "Show line numbers
set wildmode=longest,list   "Complete longest string, then list alternatives
set pastetoggle=<F2>        "Toggle paste mode
set fileformats=unix        "Use Unix line endings
set history=300             "Number of commands to remember
set showmode                "Show whether in Visual, Replace, or Insert Mode
set showmatch               "Show matching brackets/parentheses
set backspace=2             "Use standard backspace behavior
set hlsearch                "Highlight matches in search
set ruler                   "Show line and column number
set formatoptions=1         "Don't wrap text after a one-letter word
set linebreak               "Break lines when appropriate

" Persistent Undo (vim 7.3 and later)
if exists('&undofile') && !&undofile
  set undodir=~/.vim_runtime/undodir
  set undofile
endif

" Drupal settings
let php_htmlInStrings = 1   "Syntax highlight for HTML inside PHP strings
let php_parent_error_open = 1 "Display error for unmatch brackets

" Enable syntax highlighting
if &t_Co > 1
  syntax enable
endif
syntax on

" When in split screen, map <C-LeftArrow> and <C-RightArrow> to switch panes.
nn [5C <C-W>w
nn [5R <C-W>W

" Custom key mapping
map <S-u> :redo<cr>
map <C-n> :tabn<cr>
map <C-p> :tabp<cr>

" Uncomment the following to have Vim jump to the last position when
" reopening a file
if has("autocmd")
 au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
 \| exe "normal! g'\"" | endif
endif

" Highlight long comments and trailing whitespace.
" Adapted from http://vim.wikia.com/wiki/Highlight_unwanted_spaces
" TODO:  When we move thes commands to an ftplugin, see :help autocmd-buflocal
highlight ExtraWhitespace ctermbg=red guibg=red
highlight OverLength ctermbg=red ctermfg=white guibg=red guifg=white
augroup Drupal
  " Remove ALL autocommands for the Drupal group.
  autocmd!
  autocmd BufWinEnter * let w:whitespace_match_number =
	\ matchadd('ExtraWhitespace', '\s\+$')
  autocmd BufWinEnter * call matchadd('OverLength',
	\ '\(^\(\s\)\{-}\(*\|//\|/\*\)\{1}\(.\)*\(\%81v\)\)\@<=\(.\)\{1,}$')
  autocmd InsertEnter * call s:ToggleWhitespaceMatch('i')
  autocmd InsertLeave * call s:ToggleWhitespaceMatch('n')
augroup END
function! s:ToggleWhitespaceMatch(mode)
  let pattern = (a:mode == 'i') ? '\s\+\%#\@<!$' : '\s\+$'
  if exists('w:whitespace_match_number')
    call matchdelete(w:whitespace_match_number)
    call matchadd('ExtraWhitespace', pattern, 10, w:whitespace_match_number)
  else
    " Something went wrong, try to be graceful.
    w:whitespace_match_number =  matchadd('ExtraWhitespace', pattern)
  endif
endfunction
