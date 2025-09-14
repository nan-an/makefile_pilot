#ifndef __XX_STR_H__
#define __XX_STR_H__
#include "stddef.h"

typedef struct Str Str;
Str *str_new(const char *s, size_t len);
void str_free(Str *str);
size_t str_len(const Str *str);
const char *str_cstr(const Str *str);
Str *str_dup(const Str *str);

const char* get_version();
#endif // __XX_STR_H__
