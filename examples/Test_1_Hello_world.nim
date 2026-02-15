# nim c -d:release Test_1_Hello_world.nim


import libGTK4

proc activate(app: GtkApplication, userData: gpointer) {.cdecl.} =
  let window = gtk_application_window_new(app)
  gtk_window_set_title(window, "Hello GTK4")
  gtk_window_set_default_size(window, 400, 300)
  
  let button = gtk_button_new_with_label("Hello, World!")
  gtk_window_set_child(window, button)
  
  proc onClicked(btn: GtkButton, data: gpointer) {.cdecl.} =
    echo "Hello, World!"
  
  discard g_signal_connect_data(button, "clicked", 
                                cast[GCallback](onClicked), 
                                nil, nil, 0)
  
  gtk_window_present(window)

proc main() =
  let app = gtk_application_new("com.example.hello", G_APPLICATION_DEFAULT_FLAGS)
  discard g_signal_connect_data(app, "activate", 
                                cast[GCallback](activate), 
                                nil, nil, 0)
  let status = g_application_run(app, 0, nil)
  g_object_unref(app)
  quit(status)

main()






# nim c -d:release Test_1_Hello_world.nim


