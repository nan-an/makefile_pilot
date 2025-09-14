#include <stdio.h>
#include <xx/str.h>

int main(void){
  Str *myStr = str_new("Hello, World!", 13);
  if (myStr) {
    printf("String: %s\n", str_cstr(myStr));
    printf("Length: %zu\n", str_len(myStr));
    str_free(myStr);
  } else {
    printf("Failed to create string.\n");
  }
  return 0;
}
