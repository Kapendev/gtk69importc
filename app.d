import gtk;

// Extra stuff to make the example work.

GtkWindow* GTK_WINDOW(GtkWidget* ptr) {
    return cast(GtkWindow*) ptr;
}

_GApplication* G_APPLICATION(_GtkApplication* ptr) {
    return cast(_GApplication*) ptr;
}

alias G_CALLBACK_TYPE = extern(C) void function();
G_CALLBACK_TYPE G_CALLBACK(void* ptr) {
    return cast(G_CALLBACK_TYPE) ptr;
}

void g_signal_connect(gpointer instance, const(gchar)* detailed_signal, GCallback c_handler, gpointer data) {
    g_signal_connect_data(instance, detailed_signal, c_handler, data, null, cast(GConnectFlags) 0);
}

// The example.

void print_hello(GtkWidget* widget, gpointer data) {
    g_print("Hello from D!\n");
}

void activate(GtkApplication* app, gpointer user_data) {
    GtkWidget* window;
    GtkWidget* button;

    window = gtk_application_window_new(app);
    gtk_window_set_title(GTK_WINDOW(window), "Hello");
    gtk_window_set_default_size(GTK_WINDOW(window), 200, 200);

    button = gtk_button_new_with_label("Hello World");
    g_signal_connect(button, "clicked", G_CALLBACK(&print_hello), null);
    gtk_window_set_child(GTK_WINDOW(window), button);

    gtk_window_present(GTK_WINDOW(window));
}

int main(string[] args) {
    GtkApplication* app;
    int status;

    app = gtk_application_new("org.gtk.example", G_APPLICATION_DEFAULT_FLAGS);
    g_signal_connect(app, "activate", G_CALLBACK(&activate), null);
    status = g_application_run(G_APPLICATION(app), 0, null);
    g_object_unref(app);

    return status;
}
