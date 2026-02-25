# calculator.nim
# GUI-приложение сложения двух чисел на Nim + libGTK4 (GTK4)

import libGTK4, strutils

# Глобальные ссылки на виджеты
var entryA, entryB, entryResult: GtkEntry

# Обработчик нажатия кнопки "Сложить"
proc onAddClicked(widget: GtkWidget; userData: pointer): bool =
  let textA = $gtk_editable_get_text(entryA)
  let textB = $gtk_editable_get_text(entryB)
  
  var resultText: string
  try:
    let numA = parseFloat(textA)
    let numB = parseFloat(textB)
    resultText = $(numA + numB)
  except ValueError:
    resultText = "Ошибка: введите числа"
  
  gtk_editable_set_text(entryResult, resultText.cstring)
  return true

# Обработчик активации приложения
proc onActivate(app: GtkApplication; userData: pointer) =
  let window = gtk_application_window_new(app)
  gtk_window_set_title(window, "Калькулятор сложения")
  gtk_window_set_default_size(window, 400, 300)
  
  let vbox = gtk_box_new(GtkOrientation.GTK_ORIENTATION_VERTICAL, 12)
  gtk_widget_set_margin_top(vbox, 24)
  gtk_widget_set_margin_bottom(vbox, 24)
  gtk_widget_set_margin_start(vbox, 24)
  gtk_widget_set_margin_end(vbox, 24)
  
  let labelTitle = gtk_label_new("Введите два числа для сложения")
  gtk_box_append(vbox, labelTitle)
  
  entryA = gtk_entry_new()
  gtk_entry_set_placeholder_text(entryA, "Первое число")
  gtk_widget_set_hexpand(entryA, true)
  gtk_box_append(vbox, entryA)
  
  entryB = gtk_entry_new()
  gtk_entry_set_placeholder_text(entryB, "Второе число")
  gtk_widget_set_hexpand(entryB, true)
  gtk_box_append(vbox, entryB)
  
  let addButton = gtk_button_new_with_label("Сложить")
  gtk_widget_set_margin_top(addButton, 12)
  gtk_box_append(vbox, addButton)
  
  entryResult = gtk_entry_new()
  gtk_entry_set_placeholder_text(entryResult, "Результат")
  gtk_editable_set_editable(entryResult, false)
  gtk_widget_set_margin_top(entryResult, 12)
  gtk_box_append(vbox, entryResult)

  discard g_signal_connect(addButton, "clicked", onAddClicked, nil)

  gtk_window_set_child(window, vbox)
  gtk_widget_show(window)

# Главная функция
proc main =
  let app = gtk_application_new("org.example.calculator", G_APPLICATION_DEFAULT_FLAGS)
  discard g_signal_connect(app, "activate", onActivate, nil)
  discard g_application_run(app, 0, nil)
  g_object_unref(app)

main()