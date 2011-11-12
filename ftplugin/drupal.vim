" We never :set ft=drupal.  This filetype is always added to another, as in
" :set ft=php.drupal or :set ft=css.drupal.

setl nojoinspaces            "No second space when joining lines that end in "."
setl autoindent              "Auto indent based on previous line
setl smartindent             "Smart autoindenting on new line
setl smarttab                "Respect space/tab settings
setl expandtab               "Tab key inserts spaces
setl tabstop=2               "Use two spaces for tabs
setl shiftwidth=2            "Use two spaces for auto-indent
setl textwidth=80            "Limit comment lines to 80 characters.
setl formatoptions-=t
setl formatoptions+=croql
"  -t:  Do not apply 'textwidth' to code.
"  +c:  Apply 'textwidth' to comments.
"  +r:  Continue comments after hitting <Enter> in Insert mode.
"  +o:  Continue comments after when using 'O' or 'o' to open a new line.
"  +q:  Format comments using q<motion>.
"  +l:  Do not break a comment line if it is long before you start.

" Custom SVN blame
vmap <buffer> gl :<C-U>!svn blame <C-R>=expand("%:P") <CR> \| sed -n <C-R>=line("'<") <CR>,<C-R>=line("'>") <CR>p <CR>

" Return a string that can be used to open URL's (and other things).
" Usage:
" let open = s:OpenCommand()
" if strlen(open) | execute '!' . open . ' http://example.com' | endif
" See http://www.dwheeler.com/essays/open-files-urls.html
if !exists('*s:OpenCommand')

function s:OpenCommand()
if has('macunix') && executable('open')
  return 'open'
endif
if has('win32unix') && executable('cygstart')
  return 'cygstart'
endif
if has('unix') && executable('xdg-open')
  return 'xdg-open'
endif
if (has('win32') || has('win64')) && executable('cmd')
  return 'cmd /c start'
endif
  return ''
endfun

function s:OpenURL(base)
  let open = s:OpenCommand()
  if open == ''
    return
  endif
  let func =  shellescape(expand('<cword>'))
  if a:base == 'api.d.o'
    execute '!' . open . ' http://api.drupal.org/' . func
  else
    execute '!' . open . ' ' . a:base . func
  endif
endfun

endif " !exists('*s:OpenCommand')

if strlen(s:OpenCommand())
  " Lookup the API docs for a drupal function under cursor.
  nnoremap <buffer> <LocalLeader>da :silent call <SID>OpenURL('api.d.o')<CR><C-L>

  " Lookup the API docs for a drush function under cursor.
  nnoremap <buffer> <LocalLeader>dda :silent call <SID>OpenURL('http://api.drush.ws/api/function/')<CR><C-L>
endif

" Get the value of the drupal variable under cursor.
nnoremap <buffer> <LocalLeader>dv :execute "!drush vget ".shellescape(expand("<cword>"), 1)<CR>

" PHP specific settings.
" In ftdetect/drupal.vim we set ft=php.drupal.  This means that the settings
" here will come after those set by the PHP ftplugins.  In particular, we can
" override the 'comments' setting.

if &ft =~ '\<php\>'
  setl ignorecase              "Ignore case in search
  setl smartcase               "Only ignore case when all letters are lowercase
  setl comments=sr:/**,m:*\ ,ex:*/,://
  "  Format comment blocks.  Just type / on a new line to close.
  "  Recognize // (but not #) style comments.
endif
