" Source the default ftplugin so that it does not clobber our settings.
" Specifically, the 'comments' option gets clobbered by html.vim.
runtime! ftplugin/php.vim

setl ignorecase              "Ignore case in search
setl smartcase               "Only ignore case when all letters are lowercase
setl smartindent             "Smart autoindenting on new line
setl smarttab                "Respect space/tab settings
setl expandtab               "Tab key inserts spaces
setl tabstop=2               "Use two spaces for tabs
setl shiftwidth=2            "Use two spaces for auto-indent
setl autoindent              "Auto indent based on previous line

" Custom SVN blame
vmap <buffer> gl :<C-U>!svn blame <C-R>=expand("%:P") <CR> \| sed -n <C-R>=line("'<") <CR>,<C-R>=line("'>") <CR>p <CR>

" Lookup the API docs for a drupal function under cursor.
nnoremap <buffer> <LocalLeader>da :execute "!open http://api.drupal.org/".shellescape(expand("<cword>"), 1)<CR>
" Lookup the API docs for a drush function under cursor.
nnoremap <buffer> <LocalLeader>dda :execute "!open http://api.drush.ws/api/function/".shellescape(expand("<cword>"), 1)<CR>
" Get the value of the drupal variable under cursor.
nnoremap <buffer> <LocalLeader>dv :execute "!drush vget ".shellescape(expand("<cword>"), 1)<CR>
