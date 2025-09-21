#include <glib/gprintf.h>
#include <gtk/gtk.h>
#include <pilot/base.h>
#include <stdio.h>

int main(void) {
  printf("Library Version: %s\n", get_version());
  // calling functions from gtk
  gtk_init();
  g_printf("%d.%d.%d\n", gtk_get_major_version(), gtk_get_minor_version(),
           gtk_get_micro_version());
  return 0;
}
