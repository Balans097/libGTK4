# nim c -d:release Test_3_Calculator.nim


import libGTK4
import strutils

var display: GtkEntry
var currentValue: float = 0.0
var pendingOp: string = ""
var pendingValue: float = 0.0
var newNumber: bool = true  # Флаг для отслеживания начала ввода нового числа

proc processNumber(num: string) =
  let current = $gtk_editable_get_text(display)
  if newNumber or current == "0":
    gtk_editable_set_text(display, cstring(num))
    newNumber = false
  else:
    let combined = current & num
    gtk_editable_set_text(display, cstring(combined))

proc processOperation(op: string) =
  currentValue = parseFloat($gtk_editable_get_text(display))
  pendingOp = op
  pendingValue = currentValue
  newNumber = true

proc processEquals() =
  let value = parseFloat($gtk_editable_get_text(display))
  var result: float
  case pendingOp:
  of "+": result = pendingValue + value
  of "-": result = pendingValue - value
  of "*": result = pendingValue * value
  of "/": result = if value != 0: pendingValue / value else: 0.0
  else: result = value
  
  let resultText = $result
  gtk_editable_set_text(display, cstring(resultText))
  currentValue = result
  pendingOp = ""
  newNumber = true

proc processClear() =
  currentValue = 0.0
  pendingValue = 0.0
  pendingOp = ""
  newNumber = true
  gtk_editable_set_text(display, "0")

proc onNumberClick(btn: GtkButton, data: gpointer) {.cdecl.} =
  let label = $gtk_button_get_label(btn)
  processNumber(label)

proc onOpClick(btn: GtkButton, data: gpointer) {.cdecl.} =
  let op = $gtk_button_get_label(btn)
  processOperation(op)

proc onEquals(btn: GtkButton, data: gpointer) {.cdecl.} =
  processEquals()

proc onClear(btn: GtkButton, data: gpointer) {.cdecl.} =
  processClear()

proc onEntryActivate(entry: GtkEntry, userData: gpointer) {.cdecl.} =
  processEquals()

proc onKeyPress(controller: pointer, keyval: guint, keycode: guint, 
                state: pointer, userData: gpointer): gboolean {.cdecl.} =
  case keyval:
  of 48..57:  # 0-9 (основная клавиатура)
    let num = $(chr(int(keyval)))
    processNumber(num)
    return 1
  of 65456..65465:  # 0-9 (numpad)
    let digit = int(keyval - 65456)
    let num = $digit
    processNumber(num)
    return 1
  of 43, 65451:  # + (обычная и numpad)
    processOperation("+")
    return 1
  of 45, 65453:  # - (обычная и numpad)
    processOperation("-")
    return 1
  of 42, 65450:  # * (обычная и numpad)
    processOperation("*")
    return 1
  of 47, 65455:  # / (обычная и numpad)
    processOperation("/")
    return 1
  of 61, 65293:  # = или Enter
    processEquals()
    return 1
  of 99, 67, 65307:  # c, C или Esc
    processClear()
    return 1
  of 65288:  # Backspace
    let current = $gtk_editable_get_text(display)
    if current.len > 1:
      let newText = current[0..^2]
      gtk_editable_set_text(display, cstring(newText))
    else:
      gtk_editable_set_text(display, "0")
      newNumber = true
    return 1
  else:
    return 0

proc activate(app: GtkApplication, userData: gpointer) {.cdecl.} =
  let window = gtk_application_window_new(app)
  gtk_window_set_title(window, "Calculator")
  gtk_window_set_default_size(window, 300, 400)
  
  let mainBox = gtk_box_new(GTK_ORIENTATION_VERTICAL, 5)
  gtk_window_set_child(window, mainBox)
  
  # Display
  display = gtk_entry_new()
  gtk_editable_set_text(display, "0")
  gtk_editable_set_alignment(display, 1.0)  # Right align
  gtk_editable_set_editable(display, 0)  # Запрет редактирования - только вывод
  gtk_widget_set_hexpand(display, 1)
  gtk_box_append(mainBox, display)
  
  # Handle Enter key in Entry
  discard g_signal_connect_data(display, "activate",
                                cast[GCallback](onEntryActivate),
                                nil, nil, 0)
  
  # Keyboard event controller on Entry widget
  let keyController = gtk_event_controller_key_new()
  gtk_widget_add_controller(display, keyController)
  discard g_signal_connect_data(keyController, "key-pressed",
                                cast[GCallback](onKeyPress),
                                nil, nil, 0)
  
  # Button grid
  let grid = gtk_grid_new()
  gtk_grid_set_row_spacing(grid, 5)
  gtk_grid_set_column_spacing(grid, 5)
  gtk_box_append(mainBox, grid)
  
  # Number buttons
  let numbers = ["7", "8", "9", "4", "5", "6", "1", "2", "3", "0"]
  var row: gint = 0
  var col: gint = 0
  for num in numbers:
    let btn = gtk_button_new_with_label(cstring(num))
    gtk_grid_attach(grid, btn, col, row, 1, 1)
    discard g_signal_connect_data(btn, "clicked", 
                                  cast[GCallback](onNumberClick), 
                                  nil, nil, 0)
    col += 1
    if col > 2:
      col = 0
      row += 1
  
  # Operation buttons
  let ops = ["+", "-", "*", "/"]
  for i, op in ops:
    let btn = gtk_button_new_with_label(cstring(op))
    gtk_grid_attach(grid, btn, 3, gint(i), 1, 1)
    discard g_signal_connect_data(btn, "clicked", 
                                  cast[GCallback](onOpClick), 
                                  nil, nil, 0)
  
  # Equals and Clear
  let btnEquals = gtk_button_new_with_label("=")
  gtk_grid_attach(grid, btnEquals, 1, 3, 1, 1)
  discard g_signal_connect_data(btnEquals, "clicked", 
                                cast[GCallback](onEquals), 
                                nil, nil, 0)
  
  let btnClear = gtk_button_new_with_label("C")
  gtk_grid_attach(grid, btnClear, 2, 3, 1, 1)
  discard g_signal_connect_data(btnClear, "clicked", 
                                cast[GCallback](onClear), 
                                nil, nil, 0)
  
  gtk_window_present(window)

proc main() =
  let app = gtk_application_new("com.example.calculator", G_APPLICATION_DEFAULT_FLAGS)
  discard g_signal_connect_data(app, "activate", 
                                cast[GCallback](activate), 
                                nil, nil, 0)
  discard g_application_run(app, 0, nil)
  g_object_unref(app)

main()





# nim c -d:release Test_3_Calculator.nim


