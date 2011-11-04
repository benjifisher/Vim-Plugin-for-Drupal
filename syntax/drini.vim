" Vim syntax file
" Language:	Configuration File (ini file) for Drupal, Drush
" Author:	Benji Fisher <http://drupal.org/user/683300>
" Last Change:	Fri Nov 04 01:00 PM 2011 EDT

" TODO:  strict checking for the name, description, core, dependencies lines.
" Note that dependencies can specify version (in)equalities.
" References:
" - modules (7.x):  http://drupal.org/node/542202
" - modules (6.x):  http://drupal.org/node/231036
" - themes (6.x, 7.x):  http://drupal.org/node/171205
" - format (7.x):
"   http://api.drupal.org/api/drupal/includes--common.inc/function/drupal_parse_info_format/7
" - format (6.x):
"   http://api.drupal.org/api/drupal/includes--common.inc/function/drupal_parse_info_file/6
" - Profiler:
"   http://drupalcode.org/project/profiler_example.git/blob_plain/HEAD:/profiler_example.info

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syn case match
syn clear	" TODO:  remove this line.

" Find the Drupal core version.
let s:save_cursor = getpos(".")
call cursor(1, 1)
let s:core_re = '^\s*core\s*=\s*\zs\d\+\ze\.x\s*$'
let s:core_line = search(s:core_re, 'cn', 500)
let s:core = matchstr(getline(s:core_line), s:core_re)
call setpos('.', s:save_cursor)

" Is this a theme, a module, or a Drush make file?
" TODO:  How do we recognize a Profiler ini file?  For now, Profiler includes
" all syntax items, which may be the right thing to do anyway.
function! s:IniType()
  let ext = expand('%:e')
  if ext == 'make' || ext == 'build'
    return 'make'
  endif
  " If the extension is not 'info' at this point, I do not know how we got
  " here.
  let path = expand('%:p')
  let m_index = strridx(path, '/modules/')
  let t_index = strridx(path, '/themes/')
  if m_index == -1 && t_index == -1
    let m_index = strridx(path, '/modules/')
    let t_index = strridx(path, '/themes/')
  endif
  if m_index > t_index
    return 'module'
  elseif m_index < t_index
    return 'theme'
  else	" We are not inside a themes/ directory, nor a mudules/ directory.  Do not guess.
    return ''
  endif
endfun

" Unless there is a more specific match, the entire line will be given Normal
" highlighting.
syn match    driniNormal "\S.*"
" The following clusters contain all the legal keywords.  They each declare
" nextgroup=driniEquals or nextgroup=driniIndex or a more specific variant.
syn cluster  driniRequired contains=driniName,driniDescr,driniCore
syn cluster  driniOptional contains=@driniScalar,@driniArray
syn cluster  driniScalar   contains=driniProfiler
syn cluster  driniArray    contains=driniDep,driniProfilerArray

" Keywords common to all file types.
syn keyword  driniName		nextgroup=driniEquals skipwhite skipempty name
syn keyword  driniDescr		nextgroup=driniEquals skipwhite skipempty description
syn keyword  driniCore		nextgroup=driniCoreEquals skipwhite skipempty core
syn keyword  driniDep		nextgroup=driniDepIndex skipwhite skipempty dependencies
syn keyword  driniPackage	nextgroup=driniEquals skipwhite skipempty datestamp project version

" Keywords for the Profiler module.
syn match    driniProfiler	nextgroup=driniEquals skipwhite skipempty /\<base\>/
syn keyword  driniProfilerArray	nextgroup=driniIndex skipwhite skipempty nodes terms users variables
syn match    driniProfilerArray	nextgroup=driniIndex skipwhite skipempty /\<theme\>/

" After the keyword, need =, [], or [subkey].
syn region driniIndex		contained oneline skipwhite skipempty
      \ nextgroup=driniIndex,driniEquals matchgroup=driniBracket start=/\[/ end=/]/
syn region driniDepIndex	contained oneline skipwhite skipempty
      \ nextgroup=driniDepIndex,driniDepEquals matchgroup=driniDepBracket start=/\[/ end=/]/
syn match  driniEquals		contained skipwhite skipempty nextgroup=@driniValue /=/
syn match  driniCoreEquals	contained skipwhite skipempty nextgroup=driniCoreValue /=/
syn match  driniDepEquals	contained skipwhite skipempty
      \ nextgroup=driniDepValue,driniDepString /=/

" After the =, either Value or "Value" or 'Value'.  Strings may span lines.
syn cluster  driniValue    	contains=driniString,driniRHS
syn match  driniCoreValue	contained /\(['"]\)\=\d\+\.x\1/
syn match  driniDepValue	contained skipwhite skipempty
      \ nextgroup=driniDepVersion,driniNormal /[a-z_.]\+/
syn region driniDepVersion	contained oneline contains=driniDepVerNo
      \ skipwhite nextgroup=driniNormal matchgroup=driniDepParen start=/(/ end=/)/
syn match  driniDepVerNo	contained
      \ /\(\([=><!]\?=\|[=><]\)\s*\)\=\d\+\.\(x\|\d\+\)/
syn region driniDepString	contained oneline contains=driniDepValue,driniDepVersion
      \ skipwhite nextgroup=driniNormal start=/\z(["']\)/ skip=/\\\z1/ end=/\z1/
syn region driniString		contained skipwhite nextgroup=driniNormal start=/\z(["']\)/ skip=/\\\z1/ end=/\z1/
syn match  driniRHS		contained /[^\t "';].*/

let s:initype = s:IniType()

if s:initype == 'module' || s:initype == ''
  syn cluster  driniScalar   add=driniModule
  syn cluster  driniArray    add=driniModuleArray
  if !s:core || s:core >= 6
    syn keyword  driniModule	nextgroup=driniEquals skipwhite skipempty hidden package php
  endif

  if !s:core || s:core >= 7
    syn keyword  driniModule	nextgroup=driniEquals skipwhite skipempty configure required
    syn keyword  driniModuleArray	nextgroup=driniIndex skipwhite skipempty files scripts stylesheets
  endif

elseif s:initype == 'theme' || s:initype == ''
  syn cluster  driniScalar   add=driniTheme
  syn cluster  driniArray    add=driniThemeArray
  syn keyword  driniTheme    nextgroup=driniEquals skipwhite skipempty engine php screenshot
  " Keywords cannot contain spaces.  Make "base" and "theme" matches, too, or
  " 'base theme' will not work.  There is conflicting documentation ...
  syn match    driniTheme	nextgroup=driniEquals skipwhite skipempty /\<base theme\>/
  syn keyword  driniThemeArray	nextgroup=driniIndex skipwhite skipempty features regions scripts stylesheets
  syn clear  driniDep
  if !s:core || s:core >= 7
    syn keyword  driniTheme	nextgroup=driniEquals skipwhite skipempty hidden required
  endif

elseif s:initype == 'make' || s:initype == ''
  syn cluster  driniScalar   	add=driniMake
  syn cluster  driniArray    	add=driniMakeArray
  syn keyword  driniMake	nextgroup=driniEquals skipwhite skipempty api
  syn keyword  driniMakeArray	nextgroup=driniIndex skipwhite skipempty includes libraries projects
endif

syn match  driniComment		/^;.*$/
syn match  driniOverLength	/\%81v.*/ containedin=driniComment contained

" Define the default highlighting.  The 'default' keyword requires vim 5.8+.

" Link all groups to the cluster that contains them.
highlight default link  driniName	driniRequired
highlight default link  driniDescr	driniRequired
highlight default link  driniCore	driniRequired
highlight default link  driniModule	driniScalar
highlight default link  driniTheme	driniScalar
highlight default link  driniMake	driniScalar
highlight default link  driniProfiler	driniScalar
highlight default link  driniModuleArray	driniArray
highlight default link  driniDep		driniArray
highlight default link  driniThemeArray		driniArray
highlight default link  driniMakeArray		driniArray
highlight default link  driniProfilerArray	driniArray
highlight default link  driniScalar	driniOptional
highlight default link  driniArray	driniOptional

highlight default link  driniNormal	Normal
highlight default link  driniRequired	Keyword
highlight default link  driniPackage	Keyword
highlight default link  driniOptional	Keyword
highlight default link  driniDepBracket	driniBracket
highlight default link  driniBracket	Operator
highlight default link  driniDepIndex	driniIndex
highlight default link  driniIndex	String
highlight default link  driniCoreEquals	driniEquals
highlight default link  driniDepEquals	driniEquals
highlight default link  driniEquals	Operator
highlight default link  driniCoreValue	driniRHS
highlight default link  driniDepValue	driniRHS
highlight default link  driniDepVersion	Normal
highlight default link  driniDepVerNo	WarningMsg
highlight default link  driniDepParen	Operator
highlight default link  driniRHS	String
highlight default link  driniDepString	Normal
highlight default link  driniString	String

highlight default link	driniComment	Comment
highlight default link	driniOverLength	Error

let b:current_syntax = "drini"

" vim:ts=8
