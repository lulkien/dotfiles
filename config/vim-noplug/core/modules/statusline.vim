set laststatus=2


set statusline+=\ %{GetMode()}\ >
set statusline+=\ %f%m%r%h%w
set statusline+=%=


function! GetMode()
  let l:mode = mode()
  if l:mode==#"n"
    return "NORMAL"
  elseif l:mode==#"V"
    return "VISUAL LINE"
  elseif l:mode==#"v"
    return "VISUAL"
  elseif l:mode==#"\<C-v>"
    return "VISUAL BLOCK"
  elseif l:mode==#"i"
    return "INSERT"
  elseif l:mode==#"R"
    return "REPLACE"
  elseif l:mode==#"s"
    return "SELECT"
  elseif l:mode==#"t"
    return "TERMINAL"
  elseif l:mode==#"c"
    return "COMMAND"
  else if l:mode==#"!"
    return "SHELL"
  else
    return "VIM"
  endif
endfunction
