################################################################
##  i18n.nim — локализация интерфейса (EN/RU)
##
##  Простая табличная локализация: строки интерфейса не
##  разбросаны по коду, а собраны здесь по ключам вида
##  "menu.file", "dialog.open.title" и т.п.
##
##  Использование в остальных модулях:
##    let lbl = gtk_label_new(tr("status.hint").cstring)
##
##  Переключение языка в рантайме — setLanguage(langRU).
##  Сама по себе она НЕ обновляет уже созданные виджеты — это
##  ответственность вызывающего кода (см. actions.switchLanguage,
##  который пересобирает меню и обновляет видимые подписи).
################################################################

import std/[tables, os, strutils]


# ============================================================================
# Поддерживаемые языки
# ============================================================================

type
  Lang* = enum
    langEN
    langRU


var currentLang*: Lang = langEN   ## текущий язык интерфейса


# ============================================================================
# Таблицы переводов
#
# Один ключ — один смысловой элемент интерфейса. Ключи вида
# "область.имя", чтобы не путать разные меню/диалоги между собой.
# Добавление нового языка = ещё одна такая таблица + case в tr().
# ============================================================================

let stringsEN = toTable({
  "app.title":                 "GTK4 Demo",
  "app.title.untitled":        "Untitled",
  "app.welcome":                "Ready. Welcome to GTK4 Demo.",

  "menu.file":                 "File",
  "menu.file.new":             "New",
  "menu.file.open":            "Open…",
  "menu.file.save":            "Save",
  "menu.file.saveAs":          "Save As…",
  "menu.file.export":          "Export",
  "menu.file.exportPdf":       "Export to PDF",
  "menu.file.exportHtml":      "Export to HTML",
  "menu.file.quit":            "Quit",

  "menu.edit":                 "Edit",
  "menu.edit.undo":            "Undo",
  "menu.edit.redo":            "Redo",
  "menu.edit.selectAll":       "Select All",

  "menu.tools":                "Tools",
  "menu.tools.wordCount":      "Word Count",
  "menu.tools.insertDemo":     "Insert Demo Line",

  "menu.settings":             "Settings",
  "menu.settings.langEn":      "English",
  "menu.settings.langRu":      "Russian",

  "menu.help":                 "Help",
  "menu.help.docs":            "Documentation",
  "menu.help.about":           "About",

  "status.editing":            "Editing…",
  "status.textAdded":          "Text added.",
  "status.cleared":            "Document cleared.",
  "status.newDoc":             "New document created.",
  "status.opened":             "Opened: ",
  "status.saved":              "Saved: ",
  "status.allSelected":        "All text selected.",
  "status.wordCount":          "Words: ",
  "status.docsOpened":         "Documentation opened.",
  "status.about":              "About.",
  "status.langChanged":        "Language switched to English.",
  "status.hint":               "F1 — help    F5 — words    Ctrl+S — save",

  "dialog.open.title":         "Open File",
  "dialog.open.cancel":        "Cancel",
  "dialog.open.accept":        "Open",

  "dialog.saveAs.title":       "Save As",
  "dialog.saveAs.cancel":      "Cancel",
  "dialog.saveAs.accept":      "Save",
  "dialog.saveAs.defaultName": "document.txt",

  "dialog.unsaved.title":      "Unsaved Changes",
  "dialog.unsaved.body":       "The document has unsaved changes.\nThey will be lost.",
  "dialog.unsaved.quit":       "The document has unsaved changes.",

  "dialog.wordCount.title":    "Word Count",
  "dialog.wordCount.body":     "Words in document: ",

  "dialog.docs.title":         "Documentation",
  "dialog.docs.body":          "Documentation is available at:\nhttps://docs.gtk.org/gtk4/",

  "dialog.error.write":        "Write Error",
  "dialog.error.read":         "Read Error",

  "about.comments":            "Demo application\nin Nim + GTK4",
})


let stringsRU = toTable({
  "app.title":                 "GTK4 Demo",
  "app.title.untitled":        "Без имени",
  "app.welcome":                "Готово. Добро пожаловать в GTK4 Demo.",

  "menu.file":                 "Файл",
  "menu.file.new":             "Создать",
  "menu.file.open":            "Открыть…",
  "menu.file.save":            "Сохранить",
  "menu.file.saveAs":          "Сохранить как…",
  "menu.file.export":          "Экспорт",
  "menu.file.exportPdf":       "Экспорт в PDF",
  "menu.file.exportHtml":      "Экспорт в HTML",
  "menu.file.quit":            "Выход",

  "menu.edit":                 "Правка",
  "menu.edit.undo":            "Отменить",
  "menu.edit.redo":            "Повторить",
  "menu.edit.selectAll":       "Выделить всё",

  "menu.tools":                "Инструменты",
  "menu.tools.wordCount":      "Подсчёт слов",
  "menu.tools.insertDemo":     "Вставить демо-строку",

  "menu.settings":             "Настройки",
  "menu.settings.langEn":      "Английский",
  "menu.settings.langRu":      "Русский",

  "menu.help":                 "Справка",
  "menu.help.docs":            "Документация",
  "menu.help.about":           "О программе",

  "status.editing":            "Редактирование…",
  "status.textAdded":          "Текст добавлен.",
  "status.cleared":            "Документ очищен.",
  "status.newDoc":             "Новый документ создан.",
  "status.opened":             "Открыт: ",
  "status.saved":              "Сохранён: ",
  "status.allSelected":        "Весь текст выделен.",
  "status.wordCount":          "Слов: ",
  "status.docsOpened":         "Открыта документация.",
  "status.about":              "О программе.",
  "status.langChanged":        "Язык переключён на русский.",
  "status.hint":               "F1 — справка    F5 — слова    Ctrl+S — сохранить",

  "dialog.open.title":         "Открыть файл",
  "dialog.open.cancel":        "Отмена",
  "dialog.open.accept":        "Открыть",

  "dialog.saveAs.title":       "Сохранить как",
  "dialog.saveAs.cancel":      "Отмена",
  "dialog.saveAs.accept":      "Сохранить",
  "dialog.saveAs.defaultName": "документ.txt",

  "dialog.unsaved.title":      "Несохранённые изменения",
  "dialog.unsaved.body":       "Документ изменён и не сохранён.\nИзменения будут потеряны.",
  "dialog.unsaved.quit":       "Документ изменён и не сохранён.",

  "dialog.wordCount.title":    "Подсчёт слов",
  "dialog.wordCount.body":     "Слов в документе: ",

  "dialog.docs.title":         "Документация",
  "dialog.docs.body":          "Документация доступна на:\nhttps://docs.gtk.org/gtk4/",

  "dialog.error.write":        "Ошибка записи",
  "dialog.error.read":         "Ошибка чтения",

  "about.comments":            "Демонстрационное приложение\nна Nim + GTK4",
})


# ============================================================================
# Получение перевода
# ============================================================================

proc tr*(key: string): string =
  ## Вернуть перевод строки `key` для текущего языка.
  ## Если ключ не найден — вернуть сам ключ: это заметно прямо в
  ## интерфейсе и облегчает отладку недостающих переводов.
  let table = case currentLang
    of langEN: stringsEN
    of langRU: stringsRU
  result = getOrDefault(table, key, key)


# ============================================================================
# Переключение языка
# ============================================================================

proc setLanguage*(lang: Lang) =
  ## Сменить текущий язык интерфейса. Сама по себе НЕ обновляет уже
  ## созданные виджеты — их обновление делает вызывающий код
  ## (см. actions.switchLanguage).
  currentLang = lang


# ============================================================================
# Короткие коды языка — нужны для состояния действия в меню
# (GVariant-значение вида "en"/"ru", по которому GTK решает, какой
# пункт меню "Настройки" показать отмеченным).
# ============================================================================

proc langCode*(lang: Lang): string =
  case lang
  of langEN: "en"
  of langRU: "ru"


proc langFromCode*(code: string): Lang =
  case code
  of "ru": langRU
  else: langEN


# ============================================================================
# Определение языка системы (вызывается один раз при старте)
# ============================================================================

proc detectSystemLocale*(): Lang =
  ## Прочитать переменные окружения LC_ALL/LANG и вернуть подходящий
  ## поддерживаемый язык. По умолчанию, если локаль не распознана
  ## или не поддерживается — английский.
  let localeEnv = getEnv("LC_ALL", getEnv("LANG", ""))
  result = if startsWith(toLowerAscii(localeEnv), "ru"): langRU
           else: langEN
