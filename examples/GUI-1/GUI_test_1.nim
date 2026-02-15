import libGTK4
import math

var points: seq[tuple[x, y: float]] = @[]

proc drawCallback(area: GtkDrawingArea, cr: ptr cairo_t, 
                  width: gint, height: gint, data: gpointer) {.cdecl.} =
  # White background
  cairo_set_source_rgb(cr, 1.0, 1.0, 1.0)
  cairo_paint(cr)

  # Draw lines
  if points.len > 0:
    cairo_set_source_rgb(cr, 0.0, 0.0, 0.0)
    cairo_set_line_width(cr, 2.0)
    cairo_move_to(cr, points[0].x, points[0].y)
    for i in 1..<points.len:
      cairo_line_to(cr, points[i].x, points[i].y)
    cairo_stroke(cr)

proc onDrag(gesture: GtkGesture, x: gdouble, y: gdouble, area: gpointer) {.cdecl.} =
  points.add((x, y))
  gtk_widget_queue_draw(cast[GtkWidget](area))

proc onDragEnd(gesture: GtkGesture, x: gdouble, y: gdouble, data: gpointer) {.cdecl.} =
  points = @[]

proc activate(app: GtkApplication, userData: gpointer) {.cdecl.} =
  let window = gtk_application_window_new(app)
  gtk_window_set_title(window, "Drawing App")
  gtk_window_set_default_size(window, 800, 600)

  let drawingArea = gtk_drawing_area_new()
  gtk_drawing_area_set_draw_func(drawingArea, drawCallback, nil, nil)
  gtk_window_set_child(window, drawingArea)

  # Add drag gesture
  let dragGesture = gtk_gesture_drag_new()
  discard g_signal_connect_data(dragGesture, "drag-update", 
                                cast[GCallback](onDrag), 
                                drawingArea, nil, 0)
  discard g_signal_connect_data(dragGesture, "drag-end", 
                                cast[GCallback](onDragEnd), 
                                nil, nil, 0)
  gtk_widget_add_controller(drawingArea, dragGesture)

  gtk_window_present(window)







proc main() =
  let app = gtk_application_new("com.example.drawing", G_APPLICATION_DEFAULT_FLAGS)
  discard g_signal_connect_data(app, "activate", 
                                cast[GCallback](activate), 
                                nil, nil, 0)
  discard g_application_run(app, 0, nil)
  g_object_unref(app)

main()







# nim c -d:release GUI_test_1.nim



