#include <pilot/base.h>

const char *get_version(void) {
#ifdef PROJECT_VERSION
  return PROJECT_VERSION;
#else
  return "unknown - (Compiled without version specification)";
#endif
}
