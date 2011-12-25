" {{{ @function drupal#CreateMaps(modes, target, menu, key, ...)
" Create maps and menu items, where the menu items display the mapped keys.
" @param
"   String modes:  the modes for which the map/menu item will be defined, such
"     as 'nv'.
"   String menu:  the complete menu item.
"   String key:  the key sequence to be mapped.
"   String target:  the result of the map or menu item.
"   String a:1:  text to be added to the menu, right justified.
" If a:modes == '', then use plain :menu and :map commands.
" If a:menu == '' or a:key == '', then do not define a map.
" If a:1 is omitted, default to a:key.
" {{{
function! drupal#CreateMaps(modes, menu, key, target, ...)
  let map_command = 'map <silent> ' . a:key . ' ' . a:target
  let shortcut = a:0 ? a:1 : a:key
  let menu_command = 'menu <silent> ' . escape(a:menu, ' ')
  if strlen(shortcut)
    let leader = exists('mapleader') ? mapleader : '\'
    let shortcut = substitute(shortcut, '\c<leader>', escape(leader, '\'), 'g')
    let menu_command .= '<Tab>' . shortcut
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
