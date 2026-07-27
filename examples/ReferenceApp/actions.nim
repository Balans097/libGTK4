################################################################
##  actions.nim — обработчики действий приложения
##
##  Это тонкий связующий слой: каждый обработчик отвечает на
##  сигнал GSimpleAction и вызывает готовые функции из docmodel.nim /
##  fileio.nim / dialogs.nim / i18n.nim. Сам модуль НЕ строит
##  виджеты и НЕ содержит файлового I/O — только их вызывает.
##
##  Смена языка (switchLanguage) — особый случай: обработчику нужно
##  попросить gui.nim перестроить меню, но actions.nim не должен
##  импортировать gui.nim (иначе выйдет цикл gui <-> actions).
##  Решение — инверсия зависимости через хук `onLanguageChanged`:
##  gui.nim при инициализации окна сам подставляет туда нужный
##  ему код (см. gui.setupWindow).
################################################################

import libGTK4
import i18n
import docmodel
import fileio
import dialogs


# ============================================================================
# Хук на смену языка — заполняется в gui.setupWindow
# ============================================================================

var onLanguageChanged*: proc() {.closure.} = nil


proc switchLanguage(lang: Lang) =
  setLanguage(lang)
  refreshHint()
  markModified(state.isModified)     # чтобы заголовок окна тоже перевёлся
  if onLanguageChanged != nil:
    onLanguageChanged()
  setStatus(tr("status.langChanged"))


# ============================================================================
# Файл
# ============================================================================

proc onNew(action: GSimpleAction, param: GVariant, userData: gpointer) {.cdecl.} =
  if state.isModified:
    showInfoDialog(state.window, tr("dialog.unsaved.title"), tr("dialog.unsaved.body"))
  clearText()
  setStatus(tr("status.newDoc"))


proc onOpen(action: GSimpleAction, param: GVariant, userData: gpointer) {.cdecl.} =
  runOpenDialog()


proc onSave(action: GSimpleAction, param: GVariant, userData: gpointer) {.cdecl.} =
  if state.docPath == "":
    runSaveAsDialog()
  else:
    let res = saveToPath(state.docPath, bufferText())
    if res.ok:
      markModified(false)
      setStatus(tr("status.saved") & state.docTitle)
    else:
      showErrorDialog(state.window, tr("dialog.error.write"), res.error)


proc onSaveAs(action: GSimpleAction, param: GVariant, userData: gpointer) {.cdecl.} =
  runSaveAsDialog()


proc onQuit(action: GSimpleAction, param: GVariant, userData: gpointer) {.cdecl.} =
  if state.isModified:
    showInfoDialog(state.window, tr("dialog.unsaved.title"), tr("dialog.unsaved.quit"))
  g_application_quit(cast[GApplication](state.app))


# ============================================================================
# Правка
# ============================================================================

proc onSelectAll(action: GSimpleAction, param: GVariant, userData: gpointer) {.cdecl.} =
  var startIter, endIter: GtkTextIter
  gtk_text_buffer_get_start_iter(state.textBuffer, addr startIter)
  gtk_text_buffer_get_end_iter(state.textBuffer,   addr endIter)
  gtk_text_buffer_select_range(state.textBuffer, addr startIter, addr endIter)
  setStatus(tr("status.allSelected"))


# ============================================================================
# Инструменты
# ============================================================================

proc onWordCount(action: GSimpleAction, param: GVariant, userData: gpointer) {.cdecl.} =
  let n = countWords()
  showInfoDialog(state.window, tr("dialog.wordCount.title"),
    tr("dialog.wordCount.body") & $n)
  setStatus(tr("status.wordCount") & $n)


proc onInsertDemo(action: GSimpleAction, param: GVariant, userData: gpointer) {.cdecl.} =
  appendText("Nim + GTK4\n")


# ============================================================================
# Настройки — переключение языка
#
# Одно stateful-действие "app.language" вместо двух отдельных: пункты
# меню "English"/"Русский" — это один и тот же action с разным target
# (GVariant-строка "en"/"ru"). Пока состояние действия совпадает с
# target конкретного пункта — GTK сам рисует его отмеченным (радио-
# кнопка), обновлять "галочку" вручную не нужно нигде, кроме
# g_simple_action_set_state ниже, которая и задаёт это состояние.
# ============================================================================

proc onLanguageAction(action: GSimpleAction, param: GVariant, userData: gpointer) {.cdecl.} =
  let raw  = g_variant_get_string(param, nil)
  let code = if raw != nil: $raw else: "en"
  switchLanguage(langFromCode(code))
  g_simple_action_set_state(action, param)


# ============================================================================
# Справка
# ============================================================================

proc onDocs(action: GSimpleAction, param: GVariant, userData: gpointer) {.cdecl.} =
  showInfoDialog(state.window, tr("dialog.docs.title"), tr("dialog.docs.body"))
  setStatus(tr("status.docsOpened"))


proc onAbout(action: GSimpleAction, param: GVariant, userData: gpointer) {.cdecl.} =
  runAboutDialog()
  setStatus(tr("status.about"))


# ============================================================================
# Регистрация действий в приложении
#
# Табличный подход: одно место, где перечислены все пары
# "имя действия" -> обработчик — вместо повторяющихся вызовов
# g_simple_action_new/g_signal_connect/g_action_map_add_action.
# ============================================================================

type
  ActionDef = tuple[name: string, callback: GCallback]

const actionDefs: array[10, ActionDef] = [
  ("new",        cast[GCallback](onNew)),
  ("open",       cast[GCallback](onOpen)),
  ("save",       cast[GCallback](onSave)),
  ("saveAs",     cast[GCallback](onSaveAs)),
  ("quit",       cast[GCallback](onQuit)),
  ("selectAll",  cast[GCallback](onSelectAll)),
  ("wordCount",  cast[GCallback](onWordCount)),
  ("insertDemo", cast[GCallback](onInsertDemo)),
  ("docs",       cast[GCallback](onDocs)),
  ("about",      cast[GCallback](onAbout)),
]

proc registerActions*(app: GtkApplication) =
  for ad in actionDefs:
    let action = g_simple_action_new(ad.name.cstring, nil)
    discard g_signal_connect(action, "activate", ad.callback, nil)
    g_action_map_add_action(cast[GActionMap](app), cast[GAction](action))

  # "app.language" — отдельно от таблицы выше: это stateful-действие
  # (у него есть параметр и текущее состояние), а не простой обработчик
  # без аргументов.
  #
  # GVariantType для параметра/состояния строится вручную:
  # библиотека не оборачивает g_variant_type_new/G_VARIANT_TYPE_STRING,
  # но в GLib GVariantType для базовых типов — это буквально указатель
  # на строку формата ("s" для строки), поэтому cast[GVariantType]
  # от cstring "s" даёт ровно то же значение, что и настоящий
  # G_VARIANT_TYPE_STRING в C.
  let stringType   = cast[GVariantType]("s".cstring)
  let initialState = g_variant_new_string(langCode(currentLang).cstring)
  let langAction   = g_simple_action_new_stateful("language".cstring, stringType, initialState)
  discard g_signal_connect(langAction, "activate", cast[GCallback](onLanguageAction), nil)
  g_action_map_add_action(cast[GActionMap](app), cast[GAction](langAction))
