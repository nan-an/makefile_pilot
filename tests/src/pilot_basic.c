#include <pilot/base.h>
#include <stdio.h>

int main(void) {
  const char *version = get_version();
  printf("Pilot version: %s\n", version);
  return 0;
}
