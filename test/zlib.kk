import std/test
import zlib/generated
import std/cextern

fun main()
  basic/test("Basics")
    expect("1.2.11") 
      zlibVersion().to-string