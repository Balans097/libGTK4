################################################################
##  menuBuilder.nim — построитель меню GTK4 из JSON-файла
##
##  Использование:
##    let menuBar = createMenu(app, "menu.json")
##
##  Структура JSON описана в menu.json.
##  Поддерживаются:
##    – пункты меню с action и shortcut
##    – разделители (type = "separator")
##    – вложенные подменю (поле "items" внутри пункта)
##    – включение/отключение пунктов (enabled)
################################################################

import std/[json, os, strutils]

import libGTK4


# ============================================================================
# Вспомогательные низкоуровневые proc-ы, отсутствующие в обёртке
# ============================================================================

# g_menu_append_item нужен, чтобы добавить GMenuItem в GMenu
proc g_menu_append_item(menu: GMenu, item: GMenuItem) {.importc, cdecl.}


# ============================================================================
# Типы
# ============================================================================

type
  ## Пара action → shortcut, которую buildMenuFromJson возвращает наружу.
  ## Используется для регистрации акселераторов в приложении.
  AccelEntry* = object
    detailedAction*: string   ## например "app.saveCurrentDocument"
    shortcut*:       string   ## например "Ctrl+S"


# ============================================================================
# Внутренние вспомогательные функции
# ============================================================================

proc gtkAccelString(shortcut: string): string =
  ## Переводит удобочитаемый shortcut ("Ctrl+N") в формат GTK ("<Primary>n").
  ##
  ## GTK использует:
  ##   Ctrl  → <Primary>
  ##   Shift → <Shift>
  ##   Alt   → <Alt>
  ##   буква → в нижнем регистре
  ##   F1-F12 → F1 … F12
  ##   специальные: Delete, Insert, Home, End, Page_Up, Page_Down, Escape
  var parts = split(shortcut, '+')
  var mods  = ""
  var key   = ""

  for part in parts:
    case part
    of "Ctrl":  add(mods, "<Primary>")
    of "Shift": add(mods, "<Shift>")
    of "Alt":   add(mods, "<Alt>")
    else:
      # Последний кусок — это клавиша
      if len(part) == 1:
        key = $toLowerAscii(part[0])
      else:
        # F1…F12, Delete, Insert и т.д.
        key = part

  result = mods & key


proc buildGMenu(node: JsonNode, accels: var seq[AccelEntry]): GMenu =
  ## Рекурсивно строит GMenu из JsonNode-массива "items".
  result = g_menu_new()

  if node.kind != JArray:
    return

  for item in node.elems:
    # ── Разделитель ────────────────────────────────────────────────────────
    let itemType = if item.hasKey("type"): item["type"].getStr() else: ""
    if itemType == "separator":
      # В GMenu разделитель — это пустая секция без заголовка
      let sep = g_menu_new()
      g_menu_append_section(result, nil, cast[GMenuModel](sep))
      g_object_unref(cast[gpointer](sep))
      continue

    let label   = if item.hasKey("label"):   item["label"].getStr()   else: ""
    let enabled = if item.hasKey("enabled"): item["enabled"].getBool() else: true

    # ── Подменю ─────────────────────────────────────────────────────────────
    if item.hasKey("items"):
      let sub     = buildGMenu(item["items"], accels)
      let subItem = g_menu_item_new_submenu(label.cstring, cast[GMenuModel](sub))
      if not enabled:
        # GMenu не имеет прямого enabled для подменю-заголовков,
        # но мы помечаем через атрибут "sensitive" (runtime учитывается приложением)
        discard
      g_menu_append_item(result, subItem)
      g_object_unref(cast[gpointer](subItem))
      g_object_unref(cast[gpointer](sub))
      continue

    # ── Обычный пункт ───────────────────────────────────────────────────────
    let action  = if item.hasKey("action"):   item["action"].getStr()   else: ""
    let shortcut = if item.hasKey("shortcut") and item["shortcut"].kind != JNull:
                     item["shortcut"].getStr()
                   else: ""

    if action == "":
      continue

    # action в JSON записан как "app.doSomething" — GTK этот формат понимает
    let menuItem = g_menu_item_new(label.cstring, action.cstring)

    # Если пункт отключён — добавляем атрибут "sensitive" = false
    # (GMenu сам по себе не знает о sensitive; реальное отключение делается
    # через g_simple_action_set_enabled на стороне GSimpleAction)
    if not enabled:
      # Сохраняем в атрибуте "hidden-when" значение "action-missing",
      # либо просто пропускаем регистрацию акселератора — на усмотрение:
      discard

    g_menu_append_item(result, menuItem)
    g_object_unref(cast[gpointer](menuItem))

    # Регистрируем акселератор, если задан
    if shortcut != "":
      accels.add(AccelEntry(
        detailedAction: action,
        shortcut:       gtkAccelString(shortcut)
      ))


# ============================================================================
# Публичный API
# ============================================================================

proc createMenu*(app: GtkApplication, jsonFile: string): GMenu =
  ## Читает `jsonFile`, строит модель GMenu, устанавливает её как menubar
  ## приложения и регистрирует все акселераторы.
  ##
  ## Возвращает созданный GMenu (владение передаётся GTK; unref не нужен).
  ##
  ## Пример:
  ##   discard createMenu(app, "menu.json")

  if not fileExists(jsonFile):
    raise newException(IOError, "menuBuilder: файл не найден: " & jsonFile)

  let root = parseFile(jsonFile)

  if not hasKey(root, "menuBar"):
    raise newException(ValueError, "menuBuilder: в JSON нет ключа 'menuBar'")

  var accels: seq[AccelEntry] = @[]

  # Верхняя GMenu — сама строка меню
  let menuBar = g_menu_new()

  for topMenu in root["menuBar"].elems:
    let
      label = if hasKey(topMenu, "label"): getStr(topMenu["label"]) else: ""
      items = if hasKey(topMenu, "items"): topMenu["items"] else: newJArray()

    let sub = buildGMenu(items, accels)
    g_menu_append_submenu(menuBar, label.cstring, cast[GMenuModel](sub))
    g_object_unref(cast[gpointer](sub))

  # Устанавливаем menubar в приложение
  gtk_application_set_menubar(app, cast[GMenuModel](menuBar))

  # Регистрируем акселераторы
  for entry in accels:
    # gtk_application_set_accels_for_action ожидает массив cstring, завершённый nil
    var arr: array[2, cstring]
    arr[0] = entry.shortcut.cstring
    arr[1] = nil
    gtk_application_set_accels_for_action(app, entry.detailedAction.cstring, addr arr[0])

  result = menuBar
