include ../procedures/varargs.proc
include ../../plugin_testsimple/procedures/test_simple.proc

@plan(11)

a = 5
a[1] = 5

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

list$ = "1, 3, a[1], 32"
call min: 'list$'
@ok: min.return == min('list$'), "Four with indexed variable"

list$ = "1, 3, 34, 32, -1"
call min: 'list$'
@ok: min.return == min('list$'), "Five"

list$ = "1, 3, 34, 32, -1, 0"
call min: 'list$'
@ok: min.return == min('list$'), "Six"

if praatVersion >= 6016
  a[   "na" + "me"] = 5
  num$["na" + "me"] = "5"
  str$["na" + "me"] = "hello"

  call arg a["na" + "me" + string$(number("hello")) - string$(undefined)]
  @ok:  arg.n             == 1         and
    ... number(arg.v$)    == a["name"] and
    ... number(arg.v$[1]) == a["name"] and
    ... arg.t$            == "n"
    ... , "Hash with complex index"

  call arg a["name"]
  @ok:  arg.n             == 1         and
    ... number(arg.v$)    == a["name"] and
    ... number(arg.v$[1]) == a["name"] and
    ... arg.t$            == "n"
    ... , "Numeric hash"

  call arg num$["name"]
  @ok:  arg.n     == 1            and
    ... arg.v$    == num$["name"] and
    ... arg.v$[1] == num$["name"] and
    ... arg.t$    == "s"
    ... , "Numish string hash"

  call arg str$["name"]
  @ok:  arg.n     == 1            and
    ... arg.v$    == str$["name"] and
    ... arg.v$[1] == str$["name"] and
    ... arg.t$    == "s"
    ... , "String hash"
else
  # Just to maintain test numbers
  @skip: undefined, "hashes not supported below 6.0.16"
  @ok: 0, ""
  @ok: 0, ""
  @ok: 0, ""
  @ok: 0, ""
  @end_skip()
endif

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
