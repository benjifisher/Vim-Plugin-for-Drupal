" We never :set ft=drupal.  This filetype is always added to another, as in
" :set ft=php.drupal or :set ft=css.drupal.

" Highlight long comments.  The order of these two commands matters!
syn match drupalOverLength "\%>80c[^*/].*" containedin=@drupalComment contained
syn match drupalOverLength "\%81c.*\*\/"me=e-2 containedin=@drupalComment contained
" Add <syntax>Comment.* to the @drupalComment cluster for all applicable
" syntax types.
let s:syntax = substitute(&syntax, '\.drupal\>', '', 'g')
execute 'syn cluster drupalComment contains=' .
      \ substitute(s:syntax, '\.\|$', 'Comment.*,', 'g')

" Add highlighting for doc blocks in PHP files.
if &syntax =~ '\<php\>'
  highlight default link doxygenBrief ToDo
  highlight default link doxygenBody  Normal
  highlight default link doxygenCodeRegion Statement
  highlight default link doxygenParamName Type
  runtime syntax/doxygen.vim
  syn cluster drupalComment add=doxygen.*
  syn sync fromstart
endif

highlight default link drupalOverLength Error
