#include "zlib.h"

void* kkzlib_alloc(void* opaque, unsigned int items, unsigned int size){
  kk_context_t* ctx = kk_get_context();
  return kk_malloc(items*size, ctx);
}

void kkzlib_free(void* opaque, void* address){
  kk_context_t* ctx = kk_get_context();
  kk_free(address, ctx);
}
