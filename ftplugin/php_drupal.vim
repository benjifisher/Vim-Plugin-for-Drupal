" Source the default ftplugin so that it does not change our settings.
" Specifically, the 'comments' option gets clobbered by html.vim.
runtime! ftplugin/php.vim

" Get common settings and mappings for Drupal.
source <sfile>:h/drupal.vim

setl ignorecase              "Ignore case in search
setl smartcase               "Only ignore case when all letters are lowercase
setl comments=sr:/**,m:*\ ,ex:*/,://
"  Format comment blocks.  Just type / on a new line to close.
"  Recognize // (but not #) style comments.
