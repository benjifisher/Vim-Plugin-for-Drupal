setl comments=b:;\ -,b:;
" Recognize '; ' at the start of a line as a comment and recognize one level
" of lists with '; - '.  Not smart enough to require ';' in first column.
setl omnifunc=syntaxcomplete#Complete
" Complete keywords using <C-O>.  :help ft-syntax-omni
