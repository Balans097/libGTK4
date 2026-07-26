# nim c -d:release Test_5_App.nim
#
# Игра «Жизнь» Конвея (Conway's Game of Life).
#
# Клетки размещены на тороидальной сетке (края замкнуты сами на себя).
# Клик по холсту переключает клетку, пока симуляция остановлена.
# Кнопки: Старт / Стоп / Шаг / Случайно / Очистить.


import std/random

import libGTK4


# ============================================================================
# ПАРАМЕТРЫ СЕТКИ
# ============================================================================
const
  cellSize     = 16            ## размер одной клетки в пикселях
  gridCols     = 40            ## число столбцов сетки
  gridRows     = 30            ## число строк сетки
  canvasWidth  = cellSize * gridCols
  canvasHeight = cellSize * gridRows
  tickMs       = 150           ## интервал между поколениями, мс
  fillDensity  = 0.3           ## вероятность живой клетки при случайной заливке


type
  Grid = seq[seq[bool]]        ## grid[row][col] — true, если клетка жива


# ============================================================================
# ГЛОБАЛЬНОЕ СОСТОЯНИЕ
# ============================================================================
var
  grid:            Grid        ## текущее поколение
  drawingArea:     GtkDrawingArea
  statusLabel:     GtkLabel
  isRunning:       bool        ## идёт ли автоматическая симуляция
  timeoutId:       guint       ## id таймера GLib, чтобы можно было его снять
  generationCount: int


# ============================================================================
# ЛОГИКА ИГРЫ «ЖИЗНЬ»
# ============================================================================

proc newEmptyGrid(cols, rows: int): Grid =
  ## Создаёт сетку cols x rows, где все клетки мертвы.
  result = newSeq[seq[bool]](rows)
  for y in 0..<rows:
    result[y] = newSeq[bool](cols)


proc randomizeGrid(g: var Grid) =
  ## Заполняет сетку случайными живыми клетками с вероятностью fillDensity.
  for y in 0..<gridRows:
    for x in 0..<gridCols:
      g[y][x] = rand(1.0) < fillDensity


proc countLiveNeighbors(g: Grid, x, y: int): int =
  ## Считает живых соседей клетки (x, y) среди 8 окружающих её клеток.
  ## Сетка тороидальная: клетки у края соседствуют с клетками
  ## на противоположном краю (mod по размеру сетки).
  result = 0
  for dy in -1..1:
    for dx in -1..1:
      if dx == 0 and dy == 0:
        continue
      let
        nx = (x + dx + gridCols) mod gridCols
        ny = (y + dy + gridRows) mod gridRows
      if g[ny][nx]:
        inc(result)


proc nextGeneration(g: Grid): Grid =
  ## Строит следующее поколение по классическим правилам игры «Жизнь»:
  ##   – живая клетка с 2 или 3 живыми соседями выживает;
  ##   – мёртвая клетка ровно с 3 живыми соседями оживает;
  ##   – во всех остальных случаях клетка мертва в новом поколении.
  result = newEmptyGrid(gridCols, gridRows)
  for y in 0..<gridRows:
    for x in 0..<gridCols:
      let neighbors = countLiveNeighbors(g, x, y)
      if g[y][x]:
        result[y][x] = neighbors == 2 or neighbors == 3
      else:
        result[y][x] = neighbors == 3


proc updateStatus() =
  ## Обновляет строку состояния: текущий режим и номер поколения.
  let
    mode = if isRunning: "Идёт" else: "Остановлено"
    text = mode & " | Поколение: " & $generationCount
  gtk_label_set_text(statusLabel, text.cstring)


# ============================================================================
# ОТРИСОВКА
# ============================================================================

proc drawCallback(area: GtkDrawingArea, cr: cairo_t,
                   width: gint, height: gint, data: gpointer) {.cdecl.} =
  ## Рисует тёмный фон, живые клетки и тонкие направляющие линии сетки.

  # Фон холста
  cairo_set_source_rgb(cr, 0.10, 0.10, 0.12)
  cairo_paint(cr)

  # Живые клетки — cairo_fill/cairo_rectangle в обёртке не заведены,
  # поэтому заливка эмулируется частыми горизонтальными штрихами:
  # для каждой живой клетки добавляем по одной линии на строку пикселей,
  # затем рисуем всё одним вызовом cairo_stroke.
  cairo_set_source_rgb(cr, 0.20, 0.85, 0.40)
  cairo_set_line_width(cr, 1.0)
  for y in 0..<gridRows:
    for x in 0..<gridCols:
      if grid[y][x]:
        let
          px0 = float(x * cellSize)
          px1 = px0 + float(cellSize - 1)
          py0 = y * cellSize
          py1 = py0 + cellSize - 1
        for py in py0..py1:
          cairo_move_to(cr, px0, float(py))
          cairo_line_to(cr, px1, float(py))
  cairo_stroke(cr)

  # Линии сетки
  cairo_set_source_rgb(cr, 0.25, 0.25, 0.28)
  cairo_set_line_width(cr, 0.5)
  for x in 0..gridCols:
    cairo_move_to(cr, float(x * cellSize), 0.0)
    cairo_line_to(cr, float(x * cellSize), float(canvasHeight))
  for y in 0..gridRows:
    cairo_move_to(cr, 0.0, float(y * cellSize))
    cairo_line_to(cr, float(canvasWidth), float(y * cellSize))
  cairo_stroke(cr)


# ============================================================================
# ВЗАИМОДЕЙСТВИЕ С ПОЛЬЗОВАТЕЛЕМ
# ============================================================================

proc onCellClicked(gesture: GtkGesture, nPress: gint,
                    x: gdouble, y: gdouble, area: gpointer) {.cdecl.} =
  ## Переключает клетку под курсором по клику. Работает только пока
  ## симуляция остановлена — редактировать поле на ходу не даём.
  if isRunning:
    return
  let
    col = int(x) div cellSize
    row = int(y) div cellSize
  if col >= 0 and col < gridCols and row >= 0 and row < gridRows:
    grid[row][col] = not grid[row][col]
    discard gtk_widget_queue_draw(cast[GtkWidget](area))


proc onTimerTick(data: gpointer): bool {.cdecl.} =
  ## Вызывается таймером GLib на каждом шаге автоматической симуляции.
  ## Возвращает true, чтобы таймер продолжал вызываться дальше.
  grid = nextGeneration(grid)
  inc(generationCount)
  updateStatus()
  discard gtk_widget_queue_draw(cast[GtkWidget](drawingArea))
  return true


proc onStartClicked(button: GtkButton, userData: pointer) =
  ## Запускает автоматическую симуляцию.
  if not isRunning:
    isRunning = true
    timeoutId = g_timeout_add(guint(tickMs), cast[GSourceFunc](onTimerTick), nil)
    updateStatus()


proc onStopClicked(button: GtkButton, userData: pointer) =
  ## Останавливает автоматическую симуляцию и снимает таймер.
  if isRunning:
    isRunning = false
    discard g_source_remove(timeoutId)
    updateStatus()


proc onStepClicked(button: GtkButton, userData: pointer) =
  ## Выполняет ровно один шаг симуляции — удобно разбирать эволюцию,
  ## пока автоматический режим остановлен.
  if not isRunning:
    grid = nextGeneration(grid)
    inc(generationCount)
    updateStatus()
    discard gtk_widget_queue_draw(cast[GtkWidget](drawingArea))


proc onRandomClicked(button: GtkButton, userData: pointer) =
  ## Останавливает симуляцию (если шла) и заполняет сетку случайно.
  if isRunning:
    isRunning = false
    discard g_source_remove(timeoutId)
  randomizeGrid(grid)
  generationCount = 0
  updateStatus()
  discard gtk_widget_queue_draw(cast[GtkWidget](drawingArea))


proc onClearClicked(button: GtkButton, userData: pointer) =
  ## Останавливает симуляцию (если шла) и полностью очищает сетку.
  if isRunning:
    isRunning = false
    discard g_source_remove(timeoutId)
  grid = newEmptyGrid(gridCols, gridRows)
  generationCount = 0
  updateStatus()
  discard gtk_widget_queue_draw(cast[GtkWidget](drawingArea))


# ============================================================================
# ПОСТРОЕНИЕ ИНТЕРФЕЙСА
# ============================================================================

proc activate(app: GtkApplication, userData: gpointer) {.cdecl.} =
  ## Строит окно: холст с сеткой сверху, панель кнопок и строка состояния снизу.
  randomize()  # инициализация ГПСЧ системным временем

  grid = newEmptyGrid(gridCols, gridRows)
  randomizeGrid(grid)

  let window = gtk_application_window_new(app)
  gtk_window_set_title(window, "Игра «Жизнь»")
  gtk_window_set_default_size(window, canvasWidth, canvasHeight + 80)

  let mainBox = gtk_box_new(GtkOrientation.GTK_ORIENTATION_VERTICAL, 6)
  gtk_widget_set_margin_top(mainBox, 6)
  gtk_widget_set_margin_bottom(mainBox, 6)
  gtk_widget_set_margin_start(mainBox, 6)
  gtk_widget_set_margin_end(mainBox, 6)
  gtk_window_set_child(window, mainBox)

  # Холст с сеткой
  drawingArea = gtk_drawing_area_new()
  gtk_widget_set_size_request(drawingArea, canvasWidth, canvasHeight)
  gtk_drawing_area_set_draw_func(drawingArea, drawCallback, nil, nil)
  gtk_box_append(mainBox, drawingArea)

  # Клик по холсту переключает клетку
  let clickGesture = gtk_gesture_click_new()
  discard g_signal_connect_data(clickGesture, "pressed",
                                 cast[GCallback](onCellClicked),
                                 drawingArea, nil, 0)
  gtk_widget_add_controller(drawingArea, clickGesture)

  # Панель кнопок управления
  let buttonBox = gtk_box_new(GtkOrientation.GTK_ORIENTATION_HORIZONTAL, 6)
  gtk_box_append(mainBox, buttonBox)

  let
    btnStart  = gtk_button_new_with_label("▶ Старт")
    btnStop   = gtk_button_new_with_label("⏸ Стоп")
    btnStep   = gtk_button_new_with_label("⏭ Шаг")
    btnRandom = gtk_button_new_with_label("🎲 Случайно")
    btnClear  = gtk_button_new_with_label("🗑 Очистить")

  discard g_signal_connect_data(btnStart, "clicked", cast[GCallback](onStartClicked), nil, nil, 0)
  discard g_signal_connect_data(btnStop, "clicked", cast[GCallback](onStopClicked), nil, nil, 0)
  discard g_signal_connect_data(btnStep, "clicked", cast[GCallback](onStepClicked), nil, nil, 0)
  discard g_signal_connect_data(btnRandom, "clicked", cast[GCallback](onRandomClicked), nil, nil, 0)
  discard g_signal_connect_data(btnClear, "clicked", cast[GCallback](onClearClicked), nil, nil, 0)

  gtk_box_append(buttonBox, btnStart)
  gtk_box_append(buttonBox, btnStop)
  gtk_box_append(buttonBox, btnStep)
  gtk_box_append(buttonBox, btnRandom)
  gtk_box_append(buttonBox, btnClear)

  # Строка состояния
  statusLabel = gtk_label_new("Остановлено | Поколение: 0")
  gtk_widget_set_margin_top(statusLabel, 4)
  gtk_box_append(mainBox, statusLabel)

  gtk_window_present(window)


proc main() =
  let app = gtk_application_new("com.example.gameoflife", G_APPLICATION_DEFAULT_FLAGS)
  discard g_signal_connect_data(app, "activate", cast[GCallback](activate), nil, nil, 0)
  let status = g_application_run(cast[GApplication](app), 0, nil)
  g_object_unref(app)
  quit(status)

main()


# nim c -d:release Test_5_App.nim
