" {{{ @function drupal#CreateMaps(modes, menu, key, target, options)
" Create maps and menu items, where the menu items display the mapped keys.
" @param
"   String modes:  the modes for which the map/menu item will be defined, such
"     as 'nv'.
"   String menu:  the menu item:  see also a:options.root.
"   String key:  the key sequence to be mapped.
"   String target:  the result of the map or menu item.
"   Dictionary options:  the keys are all optional.
"     'root':  menu root, prepended to a:menu.
"     'shortcut':  displayed in menu, defaults to a:key.
"     'weight':  weight of the menu item (:help sub-menu-priority).
"     'special':  extra arguments to :map command, one or more of <buffer>,
"       <silent>, <special>, <script>, <expr>, <unique>, separated by
"       spaces. Only <silent>, <special>, <script> apply to the :menu
"       command as well.
" If a:modes == '', then use plain :menu and :map commands.
" If a:menu == '' or a:key == '', then do not define a menu or map.
" Do not escape spaces in a:menu nor a:options.root:  the function will.
" {{{
function! drupal#CreateMaps(modes, menu, key, target, options)
  let special = ' ' . get(a:options, 'special', '') . ' '
  let map_command = 'map' . special . a:key . ' ' . a:target
  let shortcut = escape(get(a:options, 'shortcut', a:key), ' ')
  if has_key(a:options, 'root')
    let item = a:options.root . '.' . a:menu
  else
    let item = a:menu
  endif
  let specials = filter(split(special), "v:val =~? '^<s'")
  let menu_command = 'menu ' . join(specials)
  if has_key(a:options, 'weight')
    " Prepend one dot for each parent menu.
    let dots = strpart(s:Dots(item), strlen(s:Dots(a:options.weight)))
    let menu_command .= ' ' . dots . a:options.weight
  endif
  let menu_command .= ' ' . escape(item, ' ')
  if strlen(shortcut)
    let leader = exists('mapleader') ? mapleader : '\'
    let shortcut = substitute(shortcut, '\c<leader>', escape(leader, '\'), 'g')
    let lleader = exists('maplocalleader') ? maplocalleader : '\'
    let shortcut = substitute(shortcut, '\c<localleader>', escape(lleader, '\'), 'g')
    if !has('macunix')
      let menu_command .= '<Tab>'
    else
      " Menu shortcuts work differently on the Mac, so use escaped spaces.
      let len = strlen(a:menu . shortcut)
      let menu_command .= repeat('\ ', max([1, 20 - len]))
    endif
    let menu_command .= escape(shortcut, '\')
  endif
  let menu_command .= ' ' . a:target
  " Execute the commands built above for each requested mode.
  for mode in (a:modes == '') ? [''] : split(a:modes, '\zs')
    if strlen(a:key)
      execute mode . map_command
    endif
    if strlen(a:menu)
      execute mode . menu_command
    endif
  endfor
endfunction
" }}} }}}

" {{{ @function s:Dots(menuPath)
" Remove everything but unescaped dots.
" @param
"   String menuPath:  any string, such as 'Foo.bar.item'.
" @return
"   String:  in the example, '..'.
" {{{
function! s:Dots(menuPath)
  let dots = substitute(a:menuPath, '\\\\', '', 'g')
  let dots = substitute(dots, '\\\.', '', 'g')
  let dots = substitute(dots, '[^.]', '', 'g')
  return dots
endfunction
" }}} }}}
