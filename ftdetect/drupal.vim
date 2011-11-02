" Set filetype for Drupal PHP files.
autocmd BufRead,BufNewFile *.module set filetype=php.drupal
autocmd BufRead,BufNewFile *.php set filetype=php.drupal
autocmd BufRead,BufNewFile *.install set filetype=php.drupal
autocmd BufRead,BufNewFile *.inc set filetype=php.drupal
autocmd BufRead,BufNewFile *.profile set filetype=php.drupal
autocmd BufRead,BufNewFile *.theme set filetype=php.drupal
autocmd BufRead,BufNewFile *.engine set filetype=php.drupal
autocmd BufRead,BufNewFile *.test set filetype=php.drupal
" info and make files use INI syntax.
autocmd BufRead,BufNewFile *.{info,make,build}	set filetype=dosini
