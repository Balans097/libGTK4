# nim c -d:release Test_2_Text_editor.nim


import libGTK4

proc activate(app: GtkApplication, userData: gpointer) {.cdecl.} =
  # Create window
  let window = gtk_application_window_new(app)
  gtk_window_set_title(window, "Simple Text Editor")
  gtk_window_set_default_size(window, 600, 400)
  
  # Create header bar
  let headerBar = gtk_header_bar_new()
  let btnOpen = gtk_button_new_with_label("Open")
  let btnSave = gtk_button_new_with_label("Save")
  gtk_header_bar_pack_start(headerBar, btnOpen)
  gtk_header_bar_pack_end(headerBar, btnSave)
  gtk_window_set_titlebar(window, headerBar)
  
  # Create text view with scrolling
  let scrolled = gtk_scrolled_window_new()
  let textView = gtk_text_view_new()
  gtk_text_view_set_wrap_mode(textView, PANGO_WRAP_WORD)
  gtk_scrolled_window_set_child(scrolled, textView)
  gtk_window_set_child(window, scrolled)
  
  # Open button handler
  proc onOpen(btn: GtkButton, data: gpointer) {.cdecl.} =
    let window = cast[GtkWindow](data)
    let textView = g_object_get_data(cast[GObject](btn), "textview")
    let dialog = gtk_file_chooser_dialog_new(
      "Open File",
      window,
      GTK_FILE_CHOOSER_ACTION_OPEN,
      nil
    )
    discard gtk_dialog_add_button(dialog, "Cancel", gint(GTK_RESPONSE_CANCEL))
    discard gtk_dialog_add_button(dialog, "Open", gint(GTK_RESPONSE_ACCEPT))
    
    proc onResponse(dlg: GtkDialog, response: gint, tv: gpointer) {.cdecl.} =
      if response == gint(GTK_RESPONSE_ACCEPT):
        let file = gtk_file_chooser_get_file(dlg)
        if file != nil:
          # Read file content (simplified)
          let path = g_file_get_path(file)
          echo "Opening: ", path
          g_free(path)
          g_object_unref(file)
      gtk_window_destroy(dlg)
    
    discard g_signal_connect_data(dialog, "response", 
                                  cast[GCallback](onResponse), 
                                  textView, nil, 0)
    gtk_window_present(dialog)
  
  # Save button handler
  proc onSave(btn: GtkButton, tv: gpointer) {.cdecl.} =
    let textView = cast[GtkTextView](tv)
    let buffer = gtk_text_view_get_buffer(textView)
    var start, endIter: GtkTextIter
    gtk_text_buffer_get_start_iter(buffer, addr start)
    gtk_text_buffer_get_end_iter(buffer, addr endIter)
    let text = gtk_text_buffer_get_text(buffer, addr start, addr endIter, 0)
    echo "Saving text: ", text
  
  # Store textView in button data for onOpen handler
  g_object_set_data(cast[GObject](btnOpen), "textview", textView)
  
  discard g_signal_connect_data(btnOpen, "clicked", 
                                cast[GCallback](onOpen), 
                                window, nil, 0)
  discard g_signal_connect_data(btnSave, "clicked", 
                                cast[GCallback](onSave), 
                                textView, nil, 0)
  
  gtk_window_present(window)

proc main() =
  let app = gtk_application_new("com.example.editor", G_APPLICATION_DEFAULT_FLAGS)
  discard g_signal_connect_data(app, "activate", 
                                cast[GCallback](activate), 
                                nil, nil, 0)
  discard g_application_run(app, 0, nil)
  g_object_unref(app)

main()





# nim c -d:release Test_2_Text_editor.nim


