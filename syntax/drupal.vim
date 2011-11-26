" We never :set ft=drupal.  This filetype is always added to another, as in
" :set ft=php.drupal or :set ft=css.drupal.

" Highlight long comments.  The order of these two commands matters!
syn match drupalOverLength "\%>80v[^*/].*" containedin=@drupalComment contained
syn match drupalOverLength "\%81v.*\*\/"me=e-2 containedin=@drupalComment contained
" Add <syntax>Comment.* to the @drupalComment cluster for all applicable
" syntax types.
let s:syntax = substitute(&syntax, '\.drupal\>', '', 'g')
execute 'syn cluster drupalComment contains=' .
      \ substitute(s:syntax, '\.\|$', 'Comment.*,', 'g')

highlight default link drupalOverLength Error
