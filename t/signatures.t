include ../procedures/varargs.proc
include ../../plugin_testsimple/procedures/test_simple.proc

@no_plan()
@reset()

call varargs myproc
@ok: nil == 1, "No arguments"
@reset()

call varargs myproc: 1
@ok: n == 1, "One numeric"
@reset()

call varargs myproc: "a"
@ok: s == 1, "One string"
@reset()

call varargs myproc: 1, "b"
@ok: ns == 1, "One numeric, one string"
@reset()

call varargs myproc: "a", 0
@ok: sn == 1, "One string, one numeric"
@reset()

a$ = "a"
call varargs myproc: a$, 0
@ok: sn == 1, "One string variable, one numeric"
@reset()

b = 0
call varargs myproc: "a", b
@ok: sn == 1, "One string, one numeric variable"
@reset()

call varargs myproc: "a", "b"
@ok: ss == 1, "Two strings"
@reset()

call varargs myproc: 1, 0
@ok: nn == 1, "Two numerics"

procedure myproc ()
  .nil = 1
  .n   = 1
  .s   = 1
  .sn  = 1
  .ns  = 1
  .nn  = 1
  .ss  = 1

  .a    = 0
  .b    = 1
endproc

procedure reset ()
  nil = 0
  n   = 0
  s   = 0
  sn  = 0
  ns  = 0
  nn  = 0
  ss  = 0
endproc

procedure myproc.nil ()
  nil = 1
  @test: myproc.b, myproc.a
endproc

procedure myproc.s: .a$
  s = 1
  @test: index(.a$, "a") == 1, myproc.a
endproc

procedure myproc.n: .a
  n = 1
  @test: .a, myproc.a
endproc

procedure myproc.ns: .a, .b$
  ns = 1
  @test: .a, index(.b$, "a")
endproc

procedure myproc.sn: .a$, .b
  sn = 1
  @test: index(.a$, "a"), .b
endproc

procedure myproc.ss: .a$, .b$
  ss = 1
  @test: index(.a$, "a"), index(.b$, "a")
endproc

procedure myproc.nn: .a, .b
  nn = 1
  @test: .a, .b
endproc

procedure test: .a, .b
  @ok: .a == 1 and .b == 0, "Correct arguments"
endproc

@done_testing()
