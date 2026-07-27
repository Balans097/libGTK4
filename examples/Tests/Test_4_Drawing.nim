# nim c -d:release Test_4_Drawing.nim


import libGTK4
import math



var points: seq[tuple[x, y: float]] = @[]
var isDrawing: bool = false

proc drawCallback(area: GtkDrawingArea, cr: cairo_t, 
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

proc onPressed(gesture: GtkGesture, n_press: gint, x: gdouble, y: gdouble, area: gpointer) {.cdecl.} =
  isDrawing = true
  points = @[]
  points.add((x, y))
  discard gtk_widget_queue_draw(cast[GtkWidget](area))

proc onReleased(gesture: GtkGesture, n_press: gint, x: gdouble, y: gdouble, area: gpointer) {.cdecl.} =
  isDrawing = false

proc onMotion(controller: pointer, x: gdouble, y: gdouble, area: gpointer) {.cdecl.} =
  if isDrawing:
    points.add((x, y))
    discard gtk_widget_queue_draw(cast[GtkWidget](area))

proc activate(app: GtkApplication, userData: gpointer) {.cdecl.} =
  let window = gtk_application_window_new(app)
  gtk_window_set_title(window, "Drawing App")
  gtk_window_set_default_size(window, 800, 600)
  
  let drawingArea = gtk_drawing_area_new()
  gtk_drawing_area_set_draw_func(drawingArea, drawCallback, nil, nil)
  gtk_window_set_child(window, drawingArea)
  
  # Add click gesture for press/release
  let clickGesture = gtk_gesture_click_new()
  discard g_signal_connect_data(clickGesture, "pressed", 
                                cast[GCallback](onPressed), 
                                drawingArea, nil, 0)
  discard g_signal_connect_data(clickGesture, "released", 
                                cast[GCallback](onReleased), 
                                drawingArea, nil, 0)
  gtk_widget_add_controller(drawingArea, clickGesture)
  
  # Add motion controller for drawing
  let motionController = gtk_event_controller_motion_new()
  discard g_signal_connect_data(motionController, "motion", 
                                cast[GCallback](onMotion), 
                                drawingArea, nil, 0)
  gtk_widget_add_controller(drawingArea, motionController)
  
  gtk_window_present(window)

proc main() =
  let app = gtk_application_new("com.example.drawing", G_APPLICATION_DEFAULT_FLAGS)
  discard g_signal_connect_data(app, "activate", 
                                cast[GCallback](activate), 
                                nil, nil, 0)
  discard g_application_run(app, 0, nil)
  g_object_unref(app)

main()





# nim c -d:release Test_4_Drawing.nim


