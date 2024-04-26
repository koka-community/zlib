import std/test
import zlib/generated
import std/cextern

extern import
  c file "../zlib/zconf.h"
extern import
  c file "../zlib/zlib.h"
fun main()
  basic/test("Basics")
    expect("1.2.11")
      external/zlibVersion().to-string
    

