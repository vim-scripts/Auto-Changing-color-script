" +-----------------------------------------------------------------------------+
" | TIMER                                                                       |
" +-----------------------------------------------------------------------------+
" | START                                                                       |
" +-----------------------------------------------------------------------------+
" | The following 'script' does a sort of a 'timer' function like there is on   |
" | other programming environments in VIM.  It relies on updatetime.  If the    |
" | updatetime is set to 4000 for example it will wait and then execute after   |
" | 4 seconds.                                                                  |
" +-----------------------------------------------------------------------------+
" | REVISONS:                                                                   |
" | SUN 19TH SEP 2010:   1.0                                                    |
" |                      Initial revision.                                      |
" +-----------------------------------------------------------------------------+

autocmd CursorHold * call Timer()
function! Timer()
  call feedkeys("f\e")
endfunction 
