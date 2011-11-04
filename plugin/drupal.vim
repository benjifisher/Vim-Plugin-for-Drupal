" Drupal settings for highlighting and indenting:  see
" :help ft-php-syntax and comments in $VIMRUNTIME/indent/php.vim .
let php_htmlInStrings = 1   "Syntax highlight for HTML inside PHP strings
let php_parent_error_open = 1 "Display error for unmatch brackets
let PHP_autoformatcomment = 0
let PHP_removeCRwhenUnix = 1

if has("autocmd")
augroup Drupal
  " Remove ALL autocommands for the Drupal group.
  autocmd!
  " Add drupal as a secondary filetype.  This will load the ftplugins and syntax
  " files drupal.vim after the usual ones.
  autocmd FileType php,css,javascript,dosini set ft+=.drupal

  " Highlight trailing whitespace.
  autocmd BufWinEnter * call s:ToggleWhitespaceMatch('BufWinEnter')
  autocmd BufWinLeave * call s:ToggleWhitespaceMatch('BufWinLeave')
  autocmd InsertEnter * call s:ToggleWhitespaceMatch('InsertEnter')
  autocmd InsertLeave * call s:ToggleWhitespaceMatch('InsertLeave')
augroup END
highlight default link drupalExtraWhitespace Error

" Adapted from http://vim.wikia.com/wiki/Highlight_unwanted_spaces
function! s:ToggleWhitespaceMatch(event)
  " Bail out unless the filetype is php.drupal, css.drupal, ...
  if &ft !~ '\<drupal\>'
    return
  endif
  if a:event == 'BufWinEnter'
    let w:whitespace_match_number = matchadd('drupalExtraWhitespace', '\s\+$')
    return
  endif
  if !exists('w:whitespace_match_number')
    return
  endif
  call matchdelete(w:whitespace_match_number)
  if a:event == 'BufWinLeave'
    unlet w:whitespace_match_number
  elseif a:event == 'InsertEnter'
    call matchadd('drupalExtraWhitespace', '\s\+\%#\@<!$', 10, w:whitespace_match_number)
  elseif a:event == 'InsertLeave'
    call matchadd('drupalExtraWhitespace', '\s\+$', 10, w:whitespace_match_number)
  endif
endfunction
endif " has("autocmd")
