" Maintainer: Tim Pope <http://tpo.pe/>

if exists('g:autoloaded_timl_string')
  finish
endif
let g:autoloaded_timl_string = 1

let s:type = type('')
function! timl#string#test(str) abort
  return type(a:str) == s:type
endfunction

" Characters, not bytes
function! timl#string#lookup(this, idx, default) abort
  if type(a:idx) == type(0)
    let ch = matchstr(a:this, repeat('.', a:idx).'\zs.')
    return empty(ch) ? (a:0 ? a:1 : g:timl#nil) : ch
  endif
  return a:default
endfunction

function! timl#string#length(this) abort
  return exists('*strchars') ? strchars(a:this) : len(substitute(a:this, '.', '.', 'g'))
endfunction

function! timl#string#seq(this) abort
  return timl#array_seq#create(split(a:this, '\zs'))
endfunction

function! timl#string#join(sep_or_coll, ...) abort
  return join(map(copy(timl#array#coerce(a:0 ? a:1 : a:sep_or_coll)), 'timl#str(v:val)'), a:0 ? timl#str(a:sep_or_coll) : '')
endfunction

function! timl#string#split(s, re) abort
  return timl#vec(split(a:s, '\C'.a:re))
endfunction

function! timl#string#replace(s, re, repl) abort
  return substitute(a:s, '\C'.a:re, a:repl, 'g')
endfunction

function! timl#string#replace_one(s, re, repl) abort
  return substitute(a:s, '\C'.a:re, a:repl, '')
endfunction

function! timl#string#re_quote_replacement(re) abort
  return escape(a:re, '\~&')
endfunction

function! timl#string#re_find(re, s)
  let result = matchlist(a:s, '\C'.a:re)
  return empty(result) ? g:timl#nil : timl#vec(result)
endfunction

function! timl#string#sub(str, start, ...) abort
  if a:0 && a:1 <= a:start
    return ''
  elseif a:0
    return matchstr(a:str, '.\{,'.(a:1-a:start).'\}', byteidx(a:str, a:start))
  else
    return a:str[byteidx(a:str, a:start) :]
  endif
endfunction

function! timl#string#pr(_) abort
  return join(map(copy(a:_), 'timl#printer#string(v:val)'), ' ')
endfunction

function! timl#string#prn(_) abort
  return join(map(copy(a:_), 'timl#printer#string(v:val)'), ' ')."\n"
endfunction

function! timl#string#print(_) abort
  return join(map(copy(a:_), 'timl#str(v:val)'), ' ')
endfunction

function! timl#string#println(_) abort
  return join(map(copy(a:_), 'timl#str(v:val)'), ' ')."\n"
endfunction
