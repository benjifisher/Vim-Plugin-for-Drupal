" We never :set ft=drupal.  This filetype is always added to another, as in
" :set ft=php.drupal or :set ft=css.drupal.

" Highlight long comments.
syn match drupalOverLength "\%81v.*" containedin=@drupalComment contained
" Add <syntax>Comment to the @drupalComment cluster for all applicable syntax
" types.
execute 'syn cluster drupalComment contains=' . 
      \ join(map(split(&syntax, '\.'), 'v:val."Comment"'), ',')

highlight default link drupalOverLength Error
