include ../procedures/varargs.proc
include ../../plugin_tap/procedures/more.proc

@plan: 37

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

call arg undefined
@is:  arg.n,     1,                  "undefined value: n"
@is$: arg.v$[1], string$(undefined), "undefined value: v$[]"
@is$: arg.t$,    "n",                "undefined value: t$"

call arg undefined, undefined, 10
@is:  arg.n,     3,     "undefined list: n"
@is$: arg.v$[3], "10",  "undefined list: v$[]"
@is$: arg.t$,    "nnn", "undefined list: t$"

call arg ""
@is:  arg.n,     0,  "empty string: n"
@is$: arg.t$,    "", "empty string: t$"

@arg("")
@is:  arg.n,     0,  "blank: n"
@is$: arg.t$,    "", "blank: t$"

if praatVersion >= 6016
  a[   "na" + "me"] = 5
  num$["na" + "me"] = "5"
  str$["na" + "me"] = "hello"

  call arg a["na" + "me" + string$(number("hello")) - string$(undefined)]
  @is:  arg.n,             1,         "Hash with complex index: n"
  @is:  number(arg.v$),    a["name"], "Hash with complex index: v$"
  @is:  number(arg.v$[1]), a["name"], "Hash with complex index: v$[]"
  @is$: arg.t$,            "n",       "Hash with complex index: t$"
  @is:  index_regex(arg.s$, """"), 0, "Hash with complex index: s$"

  call arg a["name"]
  @is:  arg.n,             1,         "Numeric hash: n"
  @is:  number(arg.v$),    a["name"], "Numeric hash: v$"
  @is:  number(arg.v$[1]), a["name"], "Numeric hash: v$[]"
  @is$: arg.t$,            "n",       "Numeric hash: t$"
  @is:  index_regex(arg.s$, """"), 0, "Numeric hash: s$"

  call arg num$["name"]
  @is:  arg.n,     1,            "Numish string hash: n"
  @is$: arg.v$,    num$["name"], "Numish string hash: v$"
  @is$: arg.v$[1], num$["name"], "Numish string hash: v$[]"
  @is$: arg.t$,    "s",          "Numish string hash: t$"
  @is:  index_regex(arg.s$, "^"".*""$"), 1, "Numish string hash: s$"

  call arg str$["name"]
  @is:  arg.n,     1,            "String hash: n"
  @is$: arg.v$,    str$["name"], "String hash: v$"
  @is$: arg.v$[1], str$["name"], "String hash: v$[]"
  @is$: arg.t$,    "s",          "String hash: t$"
  @is:  index_regex(arg.s$, "^"".*""$"), 1, "String hash: s$"
else
  # Just to maintain test numbers
  @skip: 20, "hashes not supported below 6.0.16"
  for i to 20
    @ok: 0, ""
  endfor
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
