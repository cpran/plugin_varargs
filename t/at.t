include ../procedures/varargs.proc
include ../../plugin_tap/procedures/more.proc
include ../../plugin_utils/procedures/trace.proc

trace.enable = 1

@plan: 29

call @:myproc
@is$: myproc.result$, "foo bar", "Empty call"

call @:myproc ()
@is$: myproc.result$, "foo bar", "Empty call with spaced parens"

call @:myproc()
@is$: myproc.result$, "foo bar", "Empty call with parens"

call @:myproc: "baz"
@is$: myproc.result$, "baz bar", "Colon call with one argument"

call @:myproc("baz")
@is$: myproc.result$, "baz bar", "Paren call with one argument"

call @:myproc: "baz")
@is$: myproc.result$, "baz bar", "Mixed call with one argument"

call @:myproc : "baz", "fee")
@is$: myproc.result$, "baz fee", "Spaced colon with closing paren"

call @:myproc ("baz", "fee")
@is$: myproc.result$, "baz fee", "Paren call with space before"

call @:myproc( "baz", "fee" )
@is$: myproc.result$, "baz fee", "Paren call with space within"

call @:myproc("baz", "fee")
@is$: myproc.result$, "baz fee", "Paren call with no spaces"

call @:myproc: "10"
@is$: myproc.result$, "10 bar", "Numish string"

call @:myproc: 10
@is$: myproc.result$, "10 bar", "Number"

call @:myproc: "baz", "10"
@is$: myproc.result$, "baz 10", "String and numish string"

call @:myproc: "baz", 10)
@is$: myproc.result$, "baz 10", "String and number"

call @:myproc: "5", 10
@is$: myproc.result$, "5 10", "Numish string and number"

call @:myproc: 2, "20"
@is$: myproc.result$, "2 20", "Number and numish string"

call @:myproc: 2, 20
@is$: myproc.result$, "22", "Two numbers"

a = 10
call @:myproc: a, 20
@is$: myproc.result$, "30", "Two numbers with numeric variable"

procedure myproc ()
  .result$ = ""

  .argv$[1] = if .argn >= 1 then .argv$[1] else "foo" fi
  .argv$[2] = if .argn >= 2 then .argv$[2] else "bar" fi

  if .argt$ == "nn"
    .result$ = string$(number(.argv$[1]) + number(.argv$[2]))
  else
    .result$ = .argv$[1] + " " + .argv$[2]
  endif
endproc

call @:sumorcat: 2
@is: sumorcat.result, 2, "Sum (1)"

call @:sumorcat: 2, 3
@is: sumorcat.result, 5, "Sum (2)"

call @:sumorcat: 2, 3, 10
@is: sumorcat.result, 15, "Sum (3)"

call @:sumorcat: 2, 3, 10, 1
@is: sumorcat.result, 16, "Sum (4)"

call @:sumorcat: 2, "3", 10, 1
@is$: sumorcat.result$, "23101", "Cat (4)"

call @:sumorcat: "a"
@is$: sumorcat.result$, "a", "Cat (1)"

call @:sumorcat: "a", " "
@is$: sumorcat.result$, "a ", "Cat (2)"

call @:sumorcat: "a", " ", "cat"
@is$: sumorcat.result$, "a cat", "Cat (3)"

call @:recursive: "a", "b", "c"
@is$: recursive.args$, """a"", ""b"", ""c""", "Arguments list kept in recursive call"
@is$: recursive.argv$[3], "c", "Final argument kept in recursive call"

procedure recursive ()
  if .argn
    .foo$ = .args$ - ("""" + .argv$[.argn] + """")
    .foo$ = .foo$ - ", "
    call @:recursive('.foo$')
  endif
endproc

procedure sumorcat ()
  .result$ = ""
  .result  = 0

  if index(.argt$, "s")
    for .i to .argn
      .result$ = .result$ + .argv$[.i]
    endfor
  else
    for .i to .argn
      .result += number(.argv$[.i])
    endfor
    .result$ = string$(.result)
  endif
endproc

call @:fibonacci: 7
@is: fibonacci.return, 13, "Recursive Fibonacci"

procedure fibonacci ()
  if number(.argv$[1]) == 0
    .return = 0
  elsif number(.argv$[1]) == 1
    .return = 1
  else
    call @:fibonacci: number(fibonacci.argv$[1]) - 1
    .a['@.level'] = fibonacci.return

    call @:fibonacci: number(fibonacci.argv$[1]) - 2
    .b['@.level'] = fibonacci.return

    .return = .a['@.level'] + .b['@.level']
  endif
endproc

call @:fibonacci: 7
@is: fibonacci.return, 13, "Recursive Fibonacci"


call @:undefined: undefined
procedure undefined ()
  @diag: .args$
endproc

@done_testing()
