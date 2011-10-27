" Drupal settings for highlighting and indenting:  see
" :help ft-php-syntax and comments in $VIMRUNTIME/indent/php.vim .
let php_htmlInStrings = 1   "Syntax highlight for HTML inside PHP strings
let php_parent_error_open = 1 "Display error for unmatch brackets
let PHP_autoformatcomment = 0
let PHP_removeCRwhenUnix = 1

" Highlight long comments and trailing whitespace.
" It is not good practice to include syntax items in a plugin file, but we do
" it here, with Syntax autocommands, because syntax files do not follow the
" same naming conventions as ftplugin files, so we cannot use (for example)
" syntax/php_drupal.vim .
" Adapted from http://vim.wikia.com/wiki/Highlight_unwanted_spaces
highlight default link drupalExtraWhitespace Error
highlight default link drupalOverLength Error
augroup Drupal
  " Remove ALL autocommands for the Drupal group.
  autocmd!
  autocmd Syntax php syn match drupalOverLength "\%81v.*" containedin=phpComment contained
  autocmd Syntax css syn match drupalOverLength "\%81v.*" containedin=cssComment contained
  autocmd BufWinEnter * call s:ToggleWhitespaceMatch('BufWinEnter')
  autocmd BufWinLeave * call s:ToggleWhitespaceMatch('BufWinLeave')
  autocmd InsertEnter * call s:ToggleWhitespaceMatch('InsertEnter')
  autocmd InsertLeave * call s:ToggleWhitespaceMatch('InsertLeave')
augroup END
function! s:ToggleWhitespaceMatch(event)
  if &ft != 'php' && &ft != 'css'
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
