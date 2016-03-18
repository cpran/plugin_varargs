include ../procedures/varargs.proc
include ../../plugin_testsimple/procedures/test_simple.proc

@no_plan()

result$ = ""
call varargs myproc
@ok: result$ == "foo bar", "Empty call"

result$ = ""
call varargs myproc ()
@ok: result$ == "foo bar", "Empty call with spaced parens"

result$ = ""
call varargs myproc()
@ok: result$ == "foo bar", "Empty call with parens"

result$ = ""
call varargs myproc: "bar"
@ok: result$ == "bar bar", "Colon call with one argument"

result$ = ""
call varargs myproc("bar")
@ok: result$ == "bar bar", "Paren call with one argument"

result$ = ""
call varargs myproc: "bar")
@ok: result$ == "bar bar", "Mixed call with one argument"

result$ = ""
call varargs myproc : "bar", "foo")
@ok: result$ == "bar foo", "Spaced colon with closing paren"

result$ = ""
call varargs myproc ("bar", "foo")
@ok: result$ == "bar foo", "Paren call with space before"

result$ = ""
call varargs myproc( "bar", "foo" )
@ok: result$ == "bar foo", "Paren call with space within"

result$ = ""
call varargs myproc("bar", "foo")
@ok: result$ == "bar foo", "Paren call with no spaces"

procedure myproc ()
  .nil = 1
  .s   = 1
  .ss  = 1

  .a$  = "foo"
  .b$  = "bar"
endproc

procedure myproc.nil ()
  @test: myproc.a$, myproc.b$
endproc

procedure myproc.s: .a$
  @test: .a$, myproc.b$
endproc

procedure myproc.ss: .a$, .b$
  @test: .a$, .b$
endproc

procedure test: .a$, .b$
  result$ = .a$ + " " + .b$
endproc

@done_testing()
