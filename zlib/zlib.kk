/*----------------------------------------------------------------------------
   Copyright 2024, Koka-Community Authors

   Licensed under the MIT License ("The License"). You may not
   use this file except in compliance with the License. A copy of the License
   can be found in the LICENSE file at the root of this distribution.
----------------------------------------------------------------------------*/
pub import zlib/generated
import std/cextern
import std/num/int32
import std/num/int64

extern import
  c file "alloc.h"

extern kkallocfn(): intptr_t
  c inline "(intptr_t)&kkzlib_alloc"


extern kkfreefn(): intptr_t
  c inline "(intptr_t)&kkzlib_free"

fun main()
  with strm <- z-stream-sc().with-ptr
  strm.set-zalloc(kkallocfn())
  strm.set-zfree(kkfreefn())
  strm.deflateInit_((-1).int32, kzlib_version.c-string, z-stream-s/size-of(cnull()))
  val toCompress = "Hello World!Hello World!Hello World!Hello World!Hello World!Hello World!Hello World!";
  strm.set-next-in(toCompress.c-string)
  strm.set-avail-in(toCompress.count.int32)
  with buff <- single/malloc(?size-of=fn(s) 100.int32).with-ptr
  strm.set-next-out(buff)
  strm.set-avail-out(100.int32)
  println("Compressing " ++ toCompress.show)
  val result = strm.deflate(kz_finish.int32)
  if result.int != kz_stream_end then 
    "Only partially compressed!".println
  else
    "Fully Compressed".println
    with istrm <- z-stream-sc().with-ptr
    istrm.set-zalloc(kkallocfn())
    istrm.set-zfree(kkfreefn())
    istrm.inflateInit_(kzlib_version.c-string, z-stream-s/size-of(cnull()))
    println("Total bytes compressed " ++ strm.total-out.show)
    println("Total bytes left in output buffer " ++ strm.avail-out.show)
    istrm.set-next-in(buff)
    istrm.set-avail-in((strm.total-out.int).int32)
    with ibuff <- single/malloc(?size-of=fn(s) 100.int32).with-ptr
    istrm.set-next-out(ibuff)
    istrm.set-avail-out(100.int32)
    println("Decompressing " ++ istrm.avail-in.show ++ " bytes from input")
    val result = istrm.inflate(kz_finish.int32)
    if (result.int != kz_stream_end) then 
      "Only partially decompressed!".println
    else 
      "Fully Decompressed".println
      println("Total bytes decompressed " ++ istrm.total-out.show)
      println("Total bytes left in output buffer " ++ istrm.avail-out.show)
      println("Result " ++ ibuff.to-string(istrm.total-out).show)
      strm.deflateEnd()
      istrm.inflateEnd()
      ()