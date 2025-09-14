#include <memory.h>
#include <stdlib.h>
#include <xx/str.h>

typedef struct Str {
  char *data;
  size_t length;
} Str;

Str *str_new(const char *s, size_t len) {
  Str *str = (Str *)malloc(sizeof(Str));
  if (!str)
    return NULL;
  str->data = (char *)malloc(len + 1);
  str->data[len] = '\0';
  if (!str->data) {
    free(str);
    return NULL;
  }
  memcpy(str->data, s, len);
  str->data[len] = '\0';
  str->length = len;
  return str;
}

void str_free(Str *str) {
  if (str) {
    free(str->data);
    free(str);
  }
}
size_t str_len(const Str *str) { return str ? str->length : 0; }
const char *str_cstr(const Str *str) { return str ? str->data : NULL; }
