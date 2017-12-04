/*
gcc -o hello hello.c `gtk-config --cflags` `gtk-config --libs`
*/

#include <gtk/gtk.h>                                            /*(01)*/

int main(int argc, char *argv[]) {
GtkWidget *main_win;                                            /*(02)*/
GtkWidget *label;                                               /*(03)*/
  gtk_set_locale();                                             /*(04)*/
  gtk_init(&argc, &argv);                                       /*(05)*/
  main_win = gtk_window_new(GTK_WINDOW_TOPLEVEL);               /*(06)*/
  gtk_signal_connect(                                           /*(07)*/
    GTK_OBJECT(main_win),
    "destroy",
    GTK_SIGNAL_FUNC(gtk_main_quit),
    NULL
  );
  gtk_widget_show(main_win);                                    /*(08)*/
  label = gtk_label_new("‚±‚ñ‚É‚¿‚Í");                          /*(09)*/
  gtk_container_add(GTK_CONTAINER(main_win),label);             /*(10)*/
  gtk_widget_show(label);                                       /*(11)*/
  gtk_widget_show(main_win);                                    /*(12)*/
  gtk_main();                                                   /*(13)*/
  return(0);
}
