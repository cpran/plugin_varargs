include ../procedures/varargs.proc
include ../../plugin_testsimple/procedures/test_simple.proc

@no_plan()

a = 5

list$ = "1"
call min: 'list$'
@ok: min.return == min('list$'), "One"

list$ = "1, 3"
call min: 'list$'
@ok: min.return == min('list$'), "Two"

list$ = "1, 3, 34"
call min: 'list$'
@ok: min.return == min('list$'), "Three"

list$ = "1, 3, a, 32"
call min: 'list$'
@ok: min.return == min('list$'), "Four with variable"

list$ = "1, 3, 34, 32, -1"
call min: 'list$'
@ok: min.return == min('list$'), "Five"

list$ = "1, 3, 34, 32, -1, 0"
call min: 'list$'
@ok: min.return == min('list$'), "Six"

procedure min: .args$
  @arg: .args$
  .return = undefined
  if arg.n
    .return = number(arg.v$[1])
    for .i from 2 to arg.n
      .n = number(arg.v$[.i])
      .return = if .n < .return then .n else .return fi
    endfor
  endif
endproc

@done_testing()
