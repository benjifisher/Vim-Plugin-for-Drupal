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

" Syntastic settings, adapted from
" echodittolabs.org/drupal-coding-standards-vim-code-sniffer-syntastic-regex
if &ft =~ '\<php\>' && exists('loaded_syntastic_plugin') && executable('phpcs')
  let g:syntastic_phpcs_conf = ' --standard=DrupalCodingStandard'
	\ . ' --extensions=php,module,inc,install,test,profile,theme'
endif

" Custom SVN blame
let s:options = {'root': 'Drupal', 'special': '<buffer>'}
call drupal#CreateMaps('v', 'SVN blame', 'gl', ':<C-U>!svn blame <C-R>=expand("%:P") <CR> \| sed -n <C-R>=line("''<") <CR>,<C-R>=line("''>") <CR>p <CR>', s:options)

augroup Drupal
  autocmd! BufEnter <buffer> call s:BufEnter()
augroup END

" {{{ @function s:BufEnter()
" There are some things that we *wish* were local to the buffer.  We stuff
" them into this function and call them from the autocommand above.
" - @var $DRUPAL_ROOT
"   Set this environment variable from b:Drupal_info.DRUPAL_ROOT.
" - SnipMate settings
let s:snip_path = expand('<sfile>:p:h:h') . '/snipmate/drupal'
function! s:BufEnter()
  if strlen(b:Drupal_info.DRUPAL_ROOT)
    let $DRUPAL_ROOT = b:Drupal_info.DRUPAL_ROOT
  endif
  if exists('*ExtractSnips')
    call ResetSnippets('drupal')
    " Load the version-independent snippets.
    let snip_path = s:snip_path . '/'
    for ft in split(&ft, '\.')
      call ExtractSnips(snip_path . ft, 'drupal')
      call ExtractSnipsFile(snip_path . ft . '.snippets', 'drupal')
    endfor
    " If we know the version of Drupal, add the coresponding snippets.
    if strlen(b:Drupal_info.CORE)
      let snip_path = s:snip_path . b:Drupal_info.CORE . '/'
      for ft in split(&ft, '\.')
	call ExtractSnips(snip_path . ft, 'drupal')
	call ExtractSnipsFile(snip_path . ft . '.snippets', 'drupal')
      endfor
    endif " strlen(b:Drupal_info.CORE)
  endif " exists('*ExtractSnips')
endfun
" }}} s:BufEnter()

" The tags file can be used for PHP omnicompletion even if $DRUPAL_ROOT == ''.
" If $DRUPAL_ROOT is set correctly, then the tags file can be used for tag
" searches.
" TODO:  If we do not know which version of Drupal core, add no tags file or
" all?
if strlen(b:Drupal_info.CORE)
  let s:tags = 'drupal' . b:Drupal_info.CORE . '.tags'
  " Bail out if the Drupal tags file has already been added.
  if stridx(&l:tags, s:tags) == -1
    let &l:tags .= ',' . expand('<sfile>:p:h:h') . '/' . s:tags
  endif
endif

if !exists('*s:OpenURL')

function s:OpenURL(base)
  let open = b:Drupal_info.OPEN_COMMAND
  if open == ''
    return
  endif
  let func =  shellescape(expand('<cword>'))
  if a:base == 'api.d.o'
    if strlen(b:Drupal_info.CORE)
      execute '!' . open . ' http://api.drupal.org/api/search/' .
	    \ b:Drupal_info.CORE . '/' . func
    else
      execute '!' . open . ' http://api.drupal.org/' . func
    endif
  else
    execute '!' . open . ' ' . a:base . func
  endif
endfun

endif " !exists('*s:OpenURL')

if strlen(b:Drupal_info.OPEN_COMMAND)
  let s:options = {'root': 'Drupal', 'special': '<buffer>'}

  " Lookup the API docs for a drupal function under cursor.
  nmap <Plug>DrupalAPI :silent call <SID>OpenURL("api.d.o")<CR><C-L>
  call drupal#CreateMaps('n', 'Drupal API', '<LocalLeader>da', 
	\ '<Plug>DrupalAPI', s:options)

  " Lookup the API docs for a drush function under cursor.
  nmap <Plug>DrushAPI :silent call <SID>OpenURL("http://api.drush.ws/api/function/")<CR><C-L>
  call drupal#CreateMaps('n', 'Drush API', '<LocalLeader>dda',
	\ '<Plug>DrushAPI', s:options)
endif

" Get the value of the drupal variable under cursor.
nnoremap <buffer> <LocalLeader>dv :execute "!drush vget ".shellescape(expand("<cword>"), 1)<CR>
  call drupal#CreateMaps('n', 'variable_get', '<LocalLeader>dv',
	\ ':execute "!drush vget ".shellescape(expand("<cword>"), 1)<CR>',
	\ s:options)

" {{{ PHP specific settings.
" In ftdetect/drupal.vim we set ft=php.drupal.  This means that the settings
" here will come after those set by the PHP ftplugins.  In particular, we can
" override the 'comments' setting.

if &ft =~ '\<php\>'
  setl ignorecase              "Ignore case in search
  setl smartcase               "Only ignore case when all letters are lowercase
  "  Format comment blocks.  Just type / on a new line to close.
  "  Recognize // (but not #) style comments.
  setl comments=sr:/**,m:*\ ,ex:*/,://
endif
" }}} PHP specific settings.
