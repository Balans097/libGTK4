################################################################
##  docmodel.nim — модель документа и состояние приложения
##
##  Раньше назывался state.nim — переименован, потому что модуль
##  с тем же именем, что и его главная экспортируемая переменная
##  (`state`), даёт неоднозначность: `state.window` из другого
##  модуля Nim трактует как "искать символ window в модуле state",
##  а не как обращение к полю переменной. Сама переменная и все
##  вызовы вида state.window/state.docPath и т.п. не изменились —
##  поменялось только имя файла/модуля, который её содержит.
##
##  Здесь хранится единственный источник истины о текущем
##  документе (буфер, путь, флаг изменений) и о виджетах,
##  которые показывают его статус (заголовок окна, статусбар).
##
##  Модуль работает с GtkTextBuffer напрямую — без этого не
##  обойтись, буфер и есть модель текста в GTK, — но НЕ строит
##  диалоги и не содержит обработчиков действий: это задача
##  dialogs.nim и actions.nim соответственно.
################################################################

import libGTK4
import i18n


# ============================================================================
# Состояние приложения
# ============================================================================

type
  AppState* = object
    app*:          GtkApplication  ## само GTK-приложение
    window*:       GtkWindow       ## главное окно
    mainBox*:      GtkBox          ## вертикальный контейнер верхнего уровня
                                     ## (меню + редактор + статусбар) — нужен,
                                     ## чтобы заменить виджет меню на лету
    menuBarWidget*: GtkWidget      ## текущий виджет меню (GtkPopoverMenuBar),
                                     ## пересобирается при смене языка
    textBuffer*:   GtkTextBuffer   ## буфер текстового редактора
    statusLabel*:  GtkLabel        ## строка состояния — левая часть статусбара
    hintLabel*:    GtkLabel        ## подсказка — правая часть; хранится отдельно,
                                     ## чтобы её можно было перевести при смене языка
    isModified*:   bool            ## документ изменён с последнего сохранения?
    docTitle*:     string          ## отображаемое имя (basename либо "Без имени")
    docPath*:      string          ## полный путь к файлу; "" — ещё не сохранён


var state*: AppState              ## глобальный синглтон состояния приложения


# ============================================================================
# Статус и заголовок окна
# ============================================================================

proc setStatus*(msg: string) =
  ## Показать сообщение в левой части статусбара.
  if state.statusLabel != nil:
    gtk_label_set_text(state.statusLabel, msg.cstring)


proc markModified*(modified: bool) =
  ## Обновить флаг изменений и, вместе с ним, заголовок окна
  ## (звёздочка "*" — признак несохранённых изменений).
  state.isModified = modified
  let star  = if modified: " *" else: ""
  let title = tr("app.title") & " — " & state.docTitle & star
  gtk_window_set_title(state.window, title.cstring)


proc refreshHint*() =
  ## Обновить текст подсказки в статусбаре текущим переводом.
  ## Вызывается после смены языка (см. actions.switchLanguage).
  if state.hintLabel != nil:
    gtk_label_set_text(state.hintLabel, tr("status.hint").cstring)


# ============================================================================
# Работа с текстовым буфером
# ============================================================================

proc bufferText*(): string =
  ## Вернуть всё содержимое текстового буфера одной строкой.
  var startIter, endIter: GtkTextIter
  gtk_text_buffer_get_start_iter(state.textBuffer, addr startIter)
  gtk_text_buffer_get_end_iter(state.textBuffer,   addr endIter)
  let raw = gtk_text_buffer_get_text(
    state.textBuffer, addr startIter, addr endIter, FALSE)
  result = if raw != nil: $raw else: ""


proc setBufferText*(text: string) =
  gtk_text_buffer_set_text(state.textBuffer, text.cstring, text.len.gint)


proc appendText*(text: string) =
  var iter: GtkTextIter
  gtk_text_buffer_get_end_iter(state.textBuffer, addr iter)
  gtk_text_buffer_insert(state.textBuffer, addr iter, text.cstring, -1)
  markModified(true)
  setStatus(tr("status.textAdded"))


proc clearText*() =
  setBufferText("")
  state.docTitle = tr("app.title.untitled")
  state.docPath  = ""
  markModified(false)
  setStatus(tr("status.cleared"))


proc countWords*(): int =
  ## Простой подсчёт слов — разделитель: пробел, таб, перевод строки.
  var count  = 0
  var inWord = false
  for ch in bufferText():
    if ch in {' ', '\n', '\t', '\r'}:
      inWord = false
    else:
      if not inWord:
        inc count
        inWord = true
  result = count
