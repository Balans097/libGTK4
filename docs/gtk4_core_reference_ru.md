# GTK4 (core: Init / Application / Window / Widget / Box / Grid) — справочник модуля

> **Импорт:** `import libGTK4`
> **Область применения:** прямая FFI-обёртка над GTK4 (через `{.importc.}`) для построения десктопных приложений с графическим интерфейсом на Linux и Windows — окна, виджеты, компоновка, жизненный цикл приложения.

Этот справочник охватывает фундаментальный слой обёртки: с чего начинается любое GTK4-приложение (инициализация библиотеки, `GtkApplication`/`GApplication`, `GtkWindow`), базовый интерфейс, общий для всех виджетов (`GtkWidget`), и два самых ходовых контейнера компоновки — `GtkBox` и `GtkGrid`. Остальные виджеты (кнопки, поля ввода, списки и т.д.) разбираются в отдельных справочниках этой же серии.

Общие конвенции модуля:
— все функции — прямые C-биндинги через `{.importc.}`, поэтому вызываются в префиксной форме: `gtk_widget_show(w)`, а не `w.gtk_widget_show()`;
— почти каждое свойство виджета представлено парой процедур `get_X` / `set_X` — в этом справочнике такая пара разбирается одним подразделом;
— указатели на объекты GTK/GLib (`GtkWidget`, `GtkWindow`, `GApplication` и т.д.) в этой обёртке — непрозрачные алиасы `pointer`; типобезопасность на уровне Nim ограничена именем типа, реальную проверку типа делает сама GTK во время выполнения;
— `gboolean` — это `cint` (0/1), а не нативный Nim `bool`; для передачи булева значения используйте `1.gboolean`/`0.gboolean` или заведите свой конвертер (см. раздел IV, `gtk_widget_set_visible`).

---

## Оглавление

I. [Инициализация и версия GTK](#инициализация-и-версия-gtk)
&nbsp;&nbsp;1. [`gtk_init` / `gtk_init_check`](#gtk_init--gtk_init_check)
&nbsp;&nbsp;2. [`gtk_is_initialized`](#gtk_is_initialized)
&nbsp;&nbsp;3. [`gtk_get_major_version` / `gtk_get_minor_version` / `gtk_get_micro_version`](#gtk_get_major_version--gtk_get_minor_version--gtk_get_micro_version)
&nbsp;&nbsp;4. [`gtk_check_version`](#gtk_check_version)
&nbsp;&nbsp;5. [`gtk_get_binary_age` / `gtk_get_interface_age`](#gtk_get_binary_age--gtk_get_interface_age)
&nbsp;&nbsp;6. [`gtk_get_locale_direction`](#gtk_get_locale_direction)
&nbsp;&nbsp;7. [`gtk_get_default_language`](#gtk_get_default_language)
&nbsp;&nbsp;8. [`gtk_disable_setlocale`](#gtk_disable_setlocale)
&nbsp;&nbsp;9. [`gtk_set_debug_flags` / `gtk_get_debug_flags`](#gtk_set_debug_flags--gtk_get_debug_flags)

II. [GtkApplication и GApplication](#gtkapplication-и-gapplication)
&nbsp;&nbsp;1. [`gtk_application_new`](#gtk_application_new)
&nbsp;&nbsp;2. [`g_signal_connect` (справка для примеров этого раздела)](#g_signal_connect-справка-для-примеров-этого-раздела)
&nbsp;&nbsp;3. [`g_application_run`](#g_application_run)
&nbsp;&nbsp;4. [`gtk_application_window_new`](#gtk_application_window_new)
&nbsp;&nbsp;5. [`gtk_application_add_window` / `gtk_application_remove_window`](#gtk_application_add_window--gtk_application_remove_window)
&nbsp;&nbsp;6. [`gtk_application_get_windows` / `gtk_application_get_active_window`](#gtk_application_get_windows--gtk_application_get_active_window)
&nbsp;&nbsp;7. [`gtk_application_get_window_by_id`](#gtk_application_get_window_by_id)
&nbsp;&nbsp;8. [`gtk_application_set_menubar` / `gtk_application_get_menubar`](#gtk_application_set_menubar--gtk_application_get_menubar)
&nbsp;&nbsp;9. [`gtk_application_get_menu_by_id`](#gtk_application_get_menu_by_id)
&nbsp;&nbsp;10. [`gtk_application_set_accels_for_action` / `gtk_application_get_accels_for_action`](#gtk_application_set_accels_for_action--gtk_application_get_accels_for_action)
&nbsp;&nbsp;11. [`gtk_application_list_action_descriptions`](#gtk_application_list_action_descriptions)
&nbsp;&nbsp;12. [`gtk_application_inhibit` / `gtk_application_uninhibit`](#gtk_application_inhibit--gtk_application_uninhibit)
&nbsp;&nbsp;13. [`g_application_activate` / `g_application_quit`](#g_application_activate--g_application_quit)
&nbsp;&nbsp;14. [`g_application_hold` / `g_application_release`](#g_application_hold--g_application_release)
&nbsp;&nbsp;15. [`g_application_register` / `g_application_get_is_registered` / `g_application_get_is_remote`](#g_application_register--g_application_get_is_registered--g_application_get_is_remote)
&nbsp;&nbsp;16. [`g_application_get_application_id` / `g_application_set_application_id`](#g_application_get_application_id--g_application_set_application_id)
&nbsp;&nbsp;17. [`g_application_get_flags` / `g_application_set_flags`](#g_application_get_flags--g_application_set_flags)
&nbsp;&nbsp;18. [`g_application_get_inactivity_timeout` / `g_application_set_inactivity_timeout`](#g_application_get_inactivity_timeout--g_application_set_inactivity_timeout)
&nbsp;&nbsp;19. [`g_application_open`](#g_application_open)
&nbsp;&nbsp;20. [`g_application_mark_busy` / `g_application_unmark_busy` / `g_application_get_is_busy`](#g_application_mark_busy--g_application_unmark_busy--g_application_get_is_busy)
&nbsp;&nbsp;21. [`g_application_send_notification` / `g_application_withdraw_notification`](#g_application_send_notification--g_application_withdraw_notification)
&nbsp;&nbsp;22. [`g_application_set_resource_base_path` / `g_application_get_resource_base_path`](#g_application_set_resource_base_path--g_application_get_resource_base_path)

III. [GtkWindow](#gtkwindow)
&nbsp;&nbsp;1. [`gtk_window_new`](#gtk_window_new)
&nbsp;&nbsp;2. [`gtk_window_set_title` / `gtk_window_get_title`](#gtk_window_set_title--gtk_window_get_title)
&nbsp;&nbsp;3. [`gtk_window_set_default_size` / `gtk_window_get_default_size`](#gtk_window_set_default_size--gtk_window_get_default_size)
&nbsp;&nbsp;4. [`gtk_window_set_resizable` / `gtk_window_get_resizable`](#gtk_window_set_resizable--gtk_window_get_resizable)
&nbsp;&nbsp;5. [`gtk_window_set_modal` / `gtk_window_get_modal`](#gtk_window_set_modal--gtk_window_get_modal)
&nbsp;&nbsp;6. [`gtk_window_set_decorated` / `gtk_window_get_decorated`](#gtk_window_set_decorated--gtk_window_get_decorated)
&nbsp;&nbsp;7. [`gtk_window_set_deletable` / `gtk_window_get_deletable`](#gtk_window_set_deletable--gtk_window_get_deletable)
&nbsp;&nbsp;8. [`gtk_window_set_transient_for` / `gtk_window_get_transient_for`](#gtk_window_set_transient_for--gtk_window_get_transient_for)
&nbsp;&nbsp;9. [`gtk_window_set_child` / `gtk_window_get_child`](#gtk_window_set_child--gtk_window_get_child)
&nbsp;&nbsp;10. [`gtk_window_set_titlebar` / `gtk_window_get_titlebar`](#gtk_window_set_titlebar--gtk_window_get_titlebar)
&nbsp;&nbsp;11. [`gtk_window_close` / `gtk_window_destroy`](#gtk_window_close--gtk_window_destroy)
&nbsp;&nbsp;12. [`gtk_window_present`](#gtk_window_present)
&nbsp;&nbsp;13. [`gtk_window_fullscreen` / `gtk_window_unfullscreen` / `gtk_window_is_fullscreen`](#gtk_window_fullscreen--gtk_window_unfullscreen--gtk_window_is_fullscreen)
&nbsp;&nbsp;14. [`gtk_window_maximize` / `gtk_window_unmaximize`](#gtk_window_maximize--gtk_window_unmaximize)
&nbsp;&nbsp;15. [`gtk_window_minimize` / `gtk_window_unminimize`](#gtk_window_minimize--gtk_window_unminimize)
&nbsp;&nbsp;16. [`gtk_window_set_icon_name` / `gtk_window_set_default_icon_name`](#gtk_window_set_icon_name--gtk_window_set_default_icon_name)

IV. [GtkWidget (базовый интерфейс всех виджетов)](#gtkwidget-базовый-интерфейс-всех-виджетов)
&nbsp;&nbsp;1. [`gtk_widget_show` / `gtk_widget_hide` / `gtk_widget_set_visible` / `gtk_widget_get_visible`](#gtk_widget_show--gtk_widget_hide--gtk_widget_set_visible--gtk_widget_get_visible)
&nbsp;&nbsp;2. [`gtk_widget_set_sensitive` / `gtk_widget_get_sensitive`](#gtk_widget_set_sensitive--gtk_widget_get_sensitive)
&nbsp;&nbsp;3. [`gtk_widget_set_can_focus` / `gtk_widget_get_can_focus` / `gtk_widget_grab_focus`](#gtk_widget_set_can_focus--gtk_widget_get_can_focus--gtk_widget_grab_focus)
&nbsp;&nbsp;4. [`gtk_widget_set_size_request` / `gtk_widget_get_size_request`](#gtk_widget_set_size_request--gtk_widget_get_size_request)
&nbsp;&nbsp;5. [`gtk_widget_set_hexpand` / `gtk_widget_get_hexpand` / `gtk_widget_set_vexpand` / `gtk_widget_get_vexpand`](#gtk_widget_set_hexpand--gtk_widget_get_hexpand--gtk_widget_set_vexpand--gtk_widget_get_vexpand)
&nbsp;&nbsp;6. [`gtk_widget_set_halign` / `gtk_widget_get_halign` / `gtk_widget_set_valign` / `gtk_widget_get_valign`](#gtk_widget_set_halign--gtk_widget_get_halign--gtk_widget_set_valign--gtk_widget_get_valign)
&nbsp;&nbsp;7. [`gtk_widget_set_margin_start` / `_end` / `_top` / `_bottom` (и геттеры)](#gtk_widget_set_margin_start--_end--_top--_bottom-и-геттеры)
&nbsp;&nbsp;8. [`gtk_widget_set_tooltip_text` / `gtk_widget_get_tooltip_text` / `gtk_widget_set_tooltip_markup` / `gtk_widget_get_tooltip_markup`](#gtk_widget_set_tooltip_text--gtk_widget_get_tooltip_text--gtk_widget_set_tooltip_markup--gtk_widget_get_tooltip_markup)
&nbsp;&nbsp;9. [`gtk_widget_set_name` / `gtk_widget_get_name`](#gtk_widget_set_name--gtk_widget_get_name)
&nbsp;&nbsp;10. [`gtk_widget_add_css_class` / `gtk_widget_remove_css_class` / `gtk_widget_has_css_class`](#gtk_widget_add_css_class--gtk_widget_remove_css_class--gtk_widget_has_css_class)
&nbsp;&nbsp;11. [`gtk_widget_get_parent` / `gtk_widget_get_first_child` / `gtk_widget_get_last_child` / `gtk_widget_get_next_sibling` / `gtk_widget_get_prev_sibling`](#gtk_widget_get_parent--gtk_widget_get_first_child--gtk_widget_get_last_child--gtk_widget_get_next_sibling--gtk_widget_get_prev_sibling)

V. [GtkBox](#gtkbox)
&nbsp;&nbsp;1. [`gtk_box_new`](#gtk_box_new)
&nbsp;&nbsp;2. [`gtk_box_append` / `gtk_box_prepend` / `gtk_box_remove`](#gtk_box_append--gtk_box_prepend--gtk_box_remove)
&nbsp;&nbsp;3. [`gtk_box_insert_child_after` / `gtk_box_reorder_child_after`](#gtk_box_insert_child_after--gtk_box_reorder_child_after)
&nbsp;&nbsp;4. [`gtk_box_set_spacing` / `gtk_box_get_spacing`](#gtk_box_set_spacing--gtk_box_get_spacing)
&nbsp;&nbsp;5. [`gtk_box_set_homogeneous` / `gtk_box_get_homogeneous`](#gtk_box_set_homogeneous--gtk_box_get_homogeneous)
&nbsp;&nbsp;6. [`gtk_box_set_baseline_position` / `gtk_box_get_baseline_position` / `gtk_box_set_baseline_child` / `gtk_box_get_baseline_child`](#gtk_box_set_baseline_position--gtk_box_get_baseline_position--gtk_box_set_baseline_child--gtk_box_get_baseline_child)

VI. [GtkGrid](#gtkgrid)
&nbsp;&nbsp;1. [`gtk_grid_new`](#gtk_grid_new)
&nbsp;&nbsp;2. [`gtk_grid_attach` / `gtk_grid_attach_next_to`](#gtk_grid_attach--gtk_grid_attach_next_to)
&nbsp;&nbsp;3. [`gtk_grid_remove` / `gtk_grid_get_child_at`](#gtk_grid_remove--gtk_grid_get_child_at)
&nbsp;&nbsp;4. [`gtk_grid_set_row_spacing` / `gtk_grid_get_row_spacing` / `gtk_grid_set_column_spacing` / `gtk_grid_get_column_spacing`](#gtk_grid_set_row_spacing--gtk_grid_get_row_spacing--gtk_grid_set_column_spacing--gtk_grid_get_column_spacing)
&nbsp;&nbsp;5. [`gtk_grid_set_row_homogeneous` / `gtk_grid_get_row_homogeneous` / `gtk_grid_set_column_homogeneous` / `gtk_grid_get_column_homogeneous`](#gtk_grid_set_row_homogeneous--gtk_grid_get_row_homogeneous--gtk_grid_set_column_homogeneous--gtk_grid_get_column_homogeneous)
&nbsp;&nbsp;6. [`gtk_grid_insert_row` / `gtk_grid_insert_column` / `gtk_grid_remove_row` / `gtk_grid_remove_column`](#gtk_grid_insert_row--gtk_grid_insert_column--gtk_grid_remove_row--gtk_grid_remove_column)
&nbsp;&nbsp;7. [`gtk_grid_insert_next_to`](#gtk_grid_insert_next_to)
&nbsp;&nbsp;8. [`gtk_grid_query_child`](#gtk_grid_query_child)
&nbsp;&nbsp;9. [`gtk_grid_set_baseline_row` / `gtk_grid_get_baseline_row` / `gtk_grid_set_row_baseline_position` / `gtk_grid_get_row_baseline_position`](#gtk_grid_set_baseline_row--gtk_grid_get_baseline_row--gtk_grid_set_row_baseline_position--gtk_grid_get_row_baseline_position)

VII. [Практические рецепты](#практические-рецепты)
&nbsp;&nbsp;1. [Минимальное окно с кнопкой ("Hello, GTK4")](#минимальное-окно-с-кнопкой-hello-gtk4)
&nbsp;&nbsp;2. [Форма из подписанных полей на GtkGrid](#форма-из-подписанных-полей-на-gtkgrid)
&nbsp;&nbsp;3. [Панель инструментов на GtkBox с растягивающимся разделителем](#панель-инструментов-на-gtkbox-с-растягивающимся-разделителем)
&nbsp;&nbsp;4. [Диалог подтверждения закрытия окна](#диалог-подтверждения-закрытия-окна)
&nbsp;&nbsp;5. [Обход дерева виджетов через `get_first_child`/`get_next_sibling`](#обход-дерева-виджетов-через-get_first_childget_next_sibling)

VIII. [Краткая таблица](#краткая-таблица)

IX. [Сводка: какую процедуру выбрать](#сводка-какую-процедуру-выбрать)

---

## Инициализация и версия GTK

Прежде чем создавать любые виджеты, библиотеку GTK нужно инициализировать. На практике `gtk_init` вызывать вручную почти никогда не приходится: `gtk_application_new` (раздел II) инициализирует GTK автоматически при активации приложения. Прямой вызов `gtk_init`/`gtk_init_check` нужен только для нестандартных сценариев — например, встраивания GTK в приложение без `GtkApplication`, тестов или диагностических утилит.

### `gtk_init` / `gtk_init_check`

```nim
proc gtk_init*()
proc gtk_init_check*(): gboolean
```

**Что делает.** Инициализирует внутреннее состояние GTK: подключается к дисплею (X11/Wayland/Windows), разбирает специфичные для GTK аргументы командной строки, настраивает локаль. `gtk_init` не сообщает об ошибке — если подключиться к дисплею не удалось (например, программа запущена без графической сессии), процесс будет аварийно завершён самой библиотекой. `gtk_init_check` делает то же самое, но возвращает `0` вместо аварийного завершения, если инициализация не удалась, — это единственная причина предпочесть его напрямую вместо `gtk_init`.

- **Реализация.** Обе процедуры идемпотентны: повторный вызов после успешной инициализации ничего не ломает и просто возвращается сразу — это позволяет безопасно вызывать `gtk_init_check` "на всякий случай" перед операциями, которые требуют инициализированной GTK, даже если `GtkApplication` уже сделал это неявно.

- Параметров нет — GTK4 (в отличие от GTK3) больше не принимает `argc`/`argv` в `gtk_init`, разбор аргументов командной строки перенесён в `GApplication`/`GOptionContext`.

```nim
# Прямая инициализация без GtkApplication — например, в консольной утилите,
# которая иногда показывает GUI-диалог.
if gtk_init_check() == 0.gboolean:
  echo "Не удалось инициализировать GTK — нет доступа к дисплею"
  quit(1)
echo "GTK готова к работе"  # выводит строку "GTK готова к работе"
```

---

### `gtk_is_initialized`

```nim
proc gtk_is_initialized*(): gboolean
```

**Что делает.** Сообщает, была ли GTK уже инициализирована (вызовом `gtk_init`, `gtk_init_check` или косвенно через `GtkApplication`). Полезно в библиотечном коде, который может быть подключён как к полноценному GTK-приложению, так и вызван из окружения, где GTK ещё не поднята, — чтобы не инициализировать её повторно и не полагаться на порядок вызовов.

- Параметров нет; возвращает `gboolean` (`1`, если инициализация уже произошла).

```nim
if gtk_is_initialized() == 0.gboolean:
  discard gtk_init_check()
echo "Инициализация проверена"  # выводит строку "Инициализация проверена"
```

---

### `gtk_get_major_version` / `gtk_get_minor_version` / `gtk_get_micro_version`

```nim
proc gtk_get_major_version*(): cuint
proc gtk_get_minor_version*(): cuint
proc gtk_get_micro_version*(): cuint
```

**Что делает.** Возвращают компоненты версии GTK, с которой приложение **реально слинковано во время выполнения** (а не версии, под которую компилировался код). Это важно на Linux, где пользователь может собрать программу на одной версии GTK, а запустить на системе с другой — минорная версия влияет на доступность отдельных функций (в этом справочнике такие функции помечены "GTK 4.8+", "GTK 4.10+" и т.п. там, где это применимо).

- Параметров нет; каждая возвращает `cuint`.

```nim
echo "GTK версии ", gtk_get_major_version(), ".", gtk_get_minor_version(), ".", gtk_get_micro_version()
# выводит что-то вроде "GTK версии 4.14.5"
```

---

### `gtk_check_version`

```nim
proc gtk_check_version*(requiredMajor: cuint, requiredMinor: cuint, requiredMicro: cuint): cstring
```

**Что делает.** Проверяет, что версия GTK, с которой слинковано приложение, не старше указанной. Если версия подходит — возвращает `nil` (в Nim это будет `cstring` со значением `nil`, проверяемым через `isNil`). Если версия старше требуемой — возвращает указатель на строку с человекочитаемым объяснением несоответствия, которую можно вывести пользователю или в лог.

- **Реализация.** В отличие от простого сравнения трёх чисел, версии GTK сравниваются с оглядкой на политику обратной совместимости внутри одной мажорной ветки (4.x) — поэтому лучше пользоваться этой процедурой, а не писать сравнение `gtk_get_minor_version() >= N` вручную.

- `requiredMajor`, `requiredMinor`, `requiredMicro` — минимально требуемая версия.

```nim
let versionProblem = gtk_check_version(4, 10, 0)
if isNil(versionProblem):
  echo "Версия GTK подходит"
else:
  echo "Проблема с версией: ", $versionProblem
  # выводит, например: "Проблема с версией: GTK+ version too old (micro mismatch)"
```

---

### `gtk_get_binary_age` / `gtk_get_interface_age`

```nim
proc gtk_get_binary_age*(): cuint
proc gtk_get_interface_age*(): cuint
```

**Что делает.** Низкоуровневые счётчики версионирования библиотеки в терминах libtool (`binary age` — сколько версий ABI прошло с последнего несовместимого изменения, `interface age` — сколько из них были только добавлением новых функций без изменения существующих). На практике эти два числа нужны только при сборке пакетов/дистрибутивов, где важна бинарная совместимость .so-файлов; для прикладного кода они почти никогда не используются — предпочитайте `gtk_get_major/minor/micro_version` и `gtk_check_version`.

- Параметров нет; обе возвращают `cuint`.

```nim
echo "binary age: ", gtk_get_binary_age(), ", interface age: ", gtk_get_interface_age()
# выводит два числа, специфичных для конкретной сборки GTK
```

---

### `gtk_get_locale_direction`

```nim
proc gtk_get_locale_direction*(): GtkTextDirection
```

**Что делает.** Возвращает направление письма (слева-направо или справа-налево), которое GTK определила по текущей локали системы (LC_MESSAGES). Значение — один из вариантов `GtkTextDirection` (`GTK_TEXT_DIR_LTR`, `GTK_TEXT_DIR_RTL`, `GTK_TEXT_DIR_NONE`). Используется, когда интерфейс должен явно подстроиться под RTL-локали (арабский, иврит) — например, чтобы вручную зеркалировать нестандартный виджет, который не наследует направление автоматически.

- Параметров нет.

```nim
case gtk_get_locale_direction()
of GTK_TEXT_DIR_RTL:
  echo "Локаль требует письма справа налево"
of GTK_TEXT_DIR_LTR:
  echo "Локаль требует письма слева направо"  # выводит эту строку в большинстве локалей
else:
  echo "Направление не определено"
```

---

### `gtk_get_default_language`

```nim
proc gtk_get_default_language*(): pointer  # PangoLanguage
```

**Что делает.** Возвращает язык по умолчанию (тип `PangoLanguage*` из Pango, в этой обёртке представлен как непрозрачный `pointer`), вычисленный из текущей локали. Используется в первую очередь для передачи в функции Pango, отвечающие за подбор шрифтов и правил переноса, специфичных для языка (например, при работе с `PangoAttrList`) — самостоятельной ценности для типового GTK-кода, работающего с виджетами напрямую, не представляет.

- Параметров нет; результат — непрозрачный `pointer` на `PangoLanguage`, предназначенный для передачи в API Pango, а не для чтения напрямую.

```nim
let lang = gtk_get_default_language()
echo "Указатель на язык по умолчанию получен: ", not isNil(lang)
# выводит "Указатель на язык по умолчанию получен: true"
```

---

### `gtk_disable_setlocale`

```nim
proc gtk_disable_setlocale*()
```

**Что делает.** Запрещает GTK самостоятельно вызывать `setlocale(LC_ALL, "")` при инициализации. По умолчанию GTK делает это сама, подхватывая локаль из переменных окружения; вызов этой процедуры **до** `gtk_init`/`gtk_init_check` нужен только если приложение хочет полностью управлять локалью вручную (например, принудительно работать в `C`-локали независимо от окружения пользователя).

- Параметров нет. Вызывать нужно строго до инициализации GTK — после неё эффекта не имеет.

```nim
gtk_disable_setlocale()  # GTK не будет трогать локаль процесса
discard gtk_init_check()
echo "GTK инициализирована с локалью, заданной приложением"
```

---

### `gtk_set_debug_flags` / `gtk_get_debug_flags`

```nim
proc gtk_set_debug_flags*(flags: cuint)
proc gtk_get_debug_flags*(): cuint
```

**Что делает.** Устанавливают и читают битовую маску отладочных флагов GTK (те же, что задаются переменной окружения `GTK_DEBUG`) — подробное логирование операций компоновки, отрисовки, взаимодействия с темами и т.п. Флаги предназначены для отладки самой GTK и её взаимодействия с системой, а не логики приложения; конкретные значения битов в этой обёртке не заведены отдельным enum-типом — при необходимости их нужно свериться со значениями `GTK_DEBUG_*` из заголовков GTK и передавать как "магические числа" через `cuint`.

- `flags` — битовая маска (`cuint`), которую нужно установить.

```nim
let currentFlags = gtk_get_debug_flags()
echo "Текущие отладочные флаги GTK: ", currentFlags
# выводит "Текущие отладочные флаги GTK: 0" при отсутствии GTK_DEBUG в окружении
```

---

## GtkApplication и GApplication

`GtkApplication` — это точка входа для любого GTK4-приложения: она инкапсулирует главный цикл событий, регистрацию в D-Bus (для запуска "одного экземпляра" приложения), меню и глобальные горячие клавиши. `GtkApplication` наследует `GApplication` из GIO, поэтому часть функциональности (запуск, флаги, регистрация, busy-состояние) идёт через процедуры `g_application_*`, а часть, специфичная для GUI (окна, меню, акселераторы), — через `gtk_application_*`. В примерах этого раздела используется `g_signal_connect` (сигналы разбираются подробно в отдельном справочнике) — минимальная справка по нему приведена ниже, чтобы примеры были рабочими сами по себе.

### `gtk_application_new`

```nim
proc gtk_application_new*(applicationId: cstring, flags: gint): GtkApplication
```

**Что делает.** Создаёт объект приложения. `applicationId` — уникальный идентификатор в формате обратного DNS (например, `"org.example.MyApp"`), используется для D-Bus-регистрации и определения "уже запущенного" экземпляра. Само по себе создание `GtkApplication` не показывает никаких окон и не инициализирует GTK — реальная работа начинается только внутри обработчика сигнала `"activate"`, который вызывается позже, при запуске главного цикла через `g_application_run`.

- **Реализация.** `applicationId` может быть пустой строкой (`""`) — тогда приложение будет анонимным (без D-Bus-регистрации и защиты от повторного запуска); это удобно для тестов и утилит, но не рекомендуется для реальных приложений.

- `applicationId: cstring` — идентификатор приложения в стиле обратного DNS, либо пустая строка.
- `flags: gint` — битовая маска значений `GApplicationFlags` (например, `G_APPLICATION_DEFAULT_FLAGS`, `G_APPLICATION_HANDLES_OPEN` для приёма файлов через командную строку).

```nim
let app = gtk_application_new("org.example.HelloApp", 0)
echo "Приложение создано: ", not isNil(app)  # выводит "Приложение создано: true"
```

---

### `g_signal_connect` (справка для примеров этого раздела)

```nim
template g_signal_connect*(instance, signal, callback, data: untyped): untyped
```

**Что делает.** Подключает функцию-обработчик к именованному сигналу GObject-совместимого объекта (`GtkApplication`, `GtkWindow`, `GtkButton` и т.д.). Каждый раз, когда объект эмитирует этот сигнал, GTK вызывает обработчик. Полный разбор системы сигналов — в отдельном справочнике; здесь приведён минимум, необходимый для примеров с `GtkApplication`/`GtkWindow`.

- `instance` — объект-источник сигнала (приводится к `gpointer`).
- `signal` — имя сигнала строкой, например `"activate"`, `"clicked"`, `"close-request"`.
- `callback` — указатель на C-совместимую функцию-обработчик; сигнатура зависит от конкретного сигнала.
- `data` — произвольные пользовательские данные (`gpointer`), которые будут переданы обработчику последним аргументом.

```nim
proc onActivate(app: GtkApplication, userData: gpointer) {.cdecl.} =
  let window = gtk_application_window_new(app)
  gtk_window_set_title(window, "Пример")
  gtk_window_present(window)

let app = gtk_application_new("org.example.HelloApp", 0)
discard g_signal_connect(app, "activate", onActivate, nil)
echo "Обработчик activate подключён"  # выводит "Обработчик activate подключён"
```

---

### `g_application_run`

```nim
proc g_application_run*(application: GApplication, argc: gint, argv: pointer): gint
```

**Что делает.** Запускает главный цикл событий приложения и блокирует выполнение, пока приложение не завершится (все окна закрыты и не удерживается ни одного `hold()`, либо был вызван `g_application_quit`). Именно этот вызов инициализирует GTK, регистрирует приложение в D-Bus и в итоге эмитирует сигнал `"activate"` (или `"open"`, если переданы файлы и выставлен флаг `G_APPLICATION_HANDLES_OPEN`). Возвращаемое значение — код возврата процесса, который принято передавать в `quit()`/возвращать из `main`.

- **Реализация.** `GtkApplication` — это `GApplication`, поэтому `g_application_run` вызывается с ним напрямую, без отдельной "gtk"-версии функции.

- `application` — объект приложения (`GtkApplication` подходит напрямую, приведение типов не требуется, так как в этой обёртке оба — `pointer`).
- `argc`, `argv` — аргументы командной строки; если их не нужно передавать в GTK (разбор опций через `GOptionContext` не используется), можно передать `0` и `nil`.

```nim
let app = gtk_application_new("org.example.HelloApp", 0)
discard g_signal_connect(app, "activate", onActivate, nil)
let exitCode = g_application_run(app, 0, nil)
echo "Приложение завершилось с кодом ", exitCode
# строка выводится только после закрытия всех окон приложения
```

---

### `gtk_application_window_new`

```nim
proc gtk_application_window_new*(application: GtkApplication): GtkWindow
```

**Что делает.** Создаёт окно, привязанное к приложению (`GtkApplicationWindow` — подтип `GtkWindow`), и автоматически регистрирует его в приложении (эквивалент последующего вызова `gtk_application_add_window`). Такое окно поддерживает интеграцию с меню приложения и получает доступ к действиям (Actions), зарегистрированным на уровне приложения через `g_action_map_add_action`. Для большинства приложений это предпочтительный способ создания главного окна вместо голого `gtk_window_new`.

- `application` — приложение, к которому будет привязано окно.

```nim
proc onActivate(app: GtkApplication, userData: gpointer) {.cdecl.} =
  let window = gtk_application_window_new(app)
  gtk_window_set_title(window, "Главное окно")
  gtk_window_set_default_size(window, 640, 480)
  gtk_window_present(window)
  echo "Окно приложения создано и показано"  # выводит эту строку при активации
```

---

### `gtk_application_add_window` / `gtk_application_remove_window`

```nim
proc gtk_application_add_window*(application: GtkApplication, window: GtkWindow)
proc gtk_application_remove_window*(application: GtkApplication, window: GtkWindow)
```

**Что делает.** Регистрирует существующее окно (созданное через обычный `gtk_window_new`, а не `gtk_application_window_new`) в приложении, либо снимает такую регистрацию. Пока у приложения есть хотя бы одно зарегистрированное открытое окно, главный цикл (`g_application_run`) не завершается. `gtk_application_remove_window` вызывается редко вручную — обычно окно автоматически снимается с регистрации при закрытии.

- `application` — приложение.
- `window` — окно, которое нужно связать с приложением или отвязать от него.

```nim
let extraWindow = gtk_window_new()
gtk_application_add_window(app, extraWindow)
echo "Дополнительное окно зарегистрировано в приложении"
gtk_application_remove_window(app, extraWindow)
echo "Дополнительное окно снято с регистрации"
```

---

### `gtk_application_get_windows` / `gtk_application_get_active_window`

```nim
proc gtk_application_get_windows*(application: GtkApplication): pointer  # GList[GtkWindow]
proc gtk_application_get_active_window*(application: GtkApplication): GtkWindow
```

**Что делает.** `gtk_application_get_windows` возвращает список всех окон приложения (в виде `GList*`, в этой обёртке — непрозрачный `pointer`; для перебора элементов нужны функции работы с `GList` из раздела GLib-утилит). `gtk_application_get_active_window` возвращает окно, которое в данный момент имеет фокус ввода (или было активным последним) — удобно, когда обработчику действия (Action) нужно знать, к какому окну он относится, не передавая окно явным параметром.

- `application` — приложение, чьи окна запрашиваются.

```nim
let active = gtk_application_get_active_window(app)
if not isNil(active):
  echo "Заголовок активного окна: ", $gtk_window_get_title(active)
```

---

### `gtk_application_get_window_by_id`

```nim
proc gtk_application_get_window_by_id*(application: GtkApplication, id: cuint): GtkWindow
```

**Что делает.** Находит окно по его числовому идентификатору `GtkApplicationWindow.id` — стабильному числу, которое GTK присваивает окну при регистрации (в отличие от указателя, оно годится, например, для сериализации в файл сессии или передачи через D-Bus-активацию). Если окна с таким `id` нет, возвращает `nil`.

- `application` — приложение.
- `id` — числовой идентификатор окна.

```nim
let win = gtk_application_get_window_by_id(app, 1)
echo "Окно с id=1 найдено: ", not isNil(win)
```

---

### `gtk_application_set_menubar` / `gtk_application_get_menubar`

```nim
proc gtk_application_set_menubar*(application: GtkApplication, menubar: GMenuModel)
proc gtk_application_get_menubar*(application: GtkApplication): GMenuModel
```

**Что делает.** Устанавливает и читает модель меню приложения верхнего уровня (`GMenuModel`, обычно строится через `GtkBuilder` из XML-описания или вручную через `g_menu_new`/`g_menu_append` — раздел MENU в отдельном справочнике). На Linux с некоторыми окружениями рабочего стола (GNOME) это меню показывается в глобальной панели, а не внутри окна.

- `application` — приложение.
- `menubar` — модель меню (`GMenuModel`).

```nim
# Требует предварительно собранной модели меню (см. справочник по MENU/GMenu)
gtk_application_set_menubar(app, menuModel)
echo "Меню приложения установлено"
```

---

### `gtk_application_get_menu_by_id`

```nim
proc gtk_application_get_menu_by_id*(application: GtkApplication, id: cstring): GMenu
```

**Что делает.** Находит подменю по идентификатору `id`, заданному атрибутом `id=` в XML-описании меню, загруженном через `GtkBuilder`. Позволяет затем модифицировать это подменю программно (добавлять/удалять пункты) уже после загрузки статичного описания.

- `application` — приложение.
- `id` — строковый идентификатор подменю из разметки `GtkBuilder`.

```nim
let submenu = gtk_application_get_menu_by_id(app, "file-menu")
echo "Подменю 'file-menu' найдено: ", not isNil(submenu)
```

---

### `gtk_application_set_accels_for_action` / `gtk_application_get_accels_for_action`

```nim
proc gtk_application_set_accels_for_action*(application: GtkApplication, detailedActionName: cstring, accels: ptr cstring)
proc gtk_application_get_accels_for_action*(application: GtkApplication, detailedActionName: cstring): ptr cstring
```

**Что делает.** Назначает горячие клавиши (акселераторы) действию (Action) приложения. `detailedActionName` — строка вида `"win.close"` или `"app.quit"`. `accels` — `NULL`-терминированный массив строк-акселераторов в формате GTK (например, `"<Control>q"`); чтобы снять все акселераторы с действия, передаётся массив из одного `nil`-элемента.

- **Реализация.** Массив `accels` в Nim нужно строить вручную как `ptr cstring` на массив `cstring`, заканчивающийся `nil` — сырой C-протокол, аналогичный `argv`; для однократного назначения удобнее завести небольшой хелпер, собирающий такой массив из `seq[string]`.

- `application` — приложение.
- `detailedActionName` — имя действия вида `"группа.имя"`.
- `accels` — массив строк-акселераторов, завершённый `nil`.

```nim
var accelArray = [cstring("<Control>q"), nil]
gtk_application_set_accels_for_action(app, "app.quit", addr accelArray[0])
echo "Горячая клавиша Ctrl+Q назначена действию app.quit"
```

---

### `gtk_application_list_action_descriptions`

```nim
proc gtk_application_list_action_descriptions*(application: GtkApplication): ptr cstring
```

**Что делает.** Возвращает `NULL`-терминированный массив всех "детализированных" имён действий (в формате `"группа.имя"`), для которых назначен хотя бы один акселератор через `gtk_application_set_accels_for_action`. Используется, например, для построения экрана "список горячих клавиш" в приложении.

- `application` — приложение.

```nim
let descriptions = gtk_application_list_action_descriptions(app)
echo "Список описаний действий с акселераторами получен: ", not isNil(descriptions)
```

---

### `gtk_application_inhibit` / `gtk_application_uninhibit`

```nim
proc gtk_application_inhibit*(application: GtkApplication, window: GtkWindow, flags: GtkApplicationInhibitFlags, reason: cstring): cuint
proc gtk_application_uninhibit*(application: GtkApplication, cookie: cuint)
```

**Что делает.** Просит окружение рабочего стола временно не выполнять указанные действия (`flags` — не переходить в спящий режим, не показывать заставку, не позволять выход из сессии и т.п.) — например, пока идёт длительный экспорт файла. `gtk_application_inhibit` возвращает "cookie" (числовой идентификатор запроса), который нужно передать в `gtk_application_uninhibit`, когда ограничение больше не нужно; если запрет не удалось установить, возвращается `0`.

- `application` — приложение.
- `window` — окно, от имени которого делается запрос (может быть `nil`).
- `flags` — что именно ингибировать (значения `GtkApplicationInhibitFlags`).
- `reason` — человекочитаемая причина, которую окружение рабочего стола может показать пользователю.
- `cookie` (для `uninhibit`) — идентификатор, полученный от `inhibit`.

```nim
let cookie = gtk_application_inhibit(app, mainWindow, GTK_APPLICATION_INHIBIT_IDLE, "Экспорт видео")
if cookie != 0:
  echo "Переход в спящий режим заблокирован на время экспорта"
  # ... длительная операция ...
  gtk_application_uninhibit(app, cookie)
  echo "Блокировка снята"
```

---

### `g_application_activate` / `g_application_quit`

```nim
proc g_application_activate*(application: GApplication)
proc g_application_quit*(application: GApplication)
```

**Что делает.** `g_application_activate` вручную эмитирует сигнал `"activate"` — то же самое, что происходит автоматически при первом запуске через `g_application_run`, если приложение было запущено без аргументов-файлов. Полезно для повторной активации уже запущенного приложения (например, чтобы вывести на передний план уже открытое окно при повторном запуске программы). `g_application_quit` принудительно завершает главный цикл, закрывая все окна приложения, независимо от количества активных `hold()`.

- `application` — приложение.

```nim
# В обработчике действия "показать окно" — поднять уже открытое окно на передний план
g_application_activate(app)
echo "Приложение переактивировано"
```

---

### `g_application_hold` / `g_application_release`

```nim
proc g_application_hold*(application: GApplication)
proc g_application_release*(application: GApplication)
```

**Что делает.** Увеличивает/уменьшает внутренний счётчик "удержаний" приложения. Пока счётчик больше нуля, главный цикл не завершается, даже если закрыты все окна, — это нужно для фоновых операций без окна (например, приложение-демон или синхронизация в фоне, инициированная из другого процесса через D-Bus-активацию).

- **Реализация.** Каждый `hold()` обязан быть парным с последующим `release()` — иначе главный цикл никогда не завершится сам, и процесс будет "висеть" даже после закрытия всех окон.

- `application` — приложение.

```nim
g_application_hold(app)  # приложение не завершится, даже если закрыть все окна
# ... фоновая операция без UI ...
g_application_release(app)  # теперь приложение может завершиться штатно
echo "Удержание снято"
```

---

### `g_application_register` / `g_application_get_is_registered` / `g_application_get_is_remote`

```nim
proc g_application_register*(application: GApplication, cancellable: pointer, error: pointer): gboolean
proc g_application_get_is_registered*(application: GApplication): gboolean
proc g_application_get_is_remote*(application: GApplication): gboolean
```

**Что делает.** `g_application_register` регистрирует приложение в D-Bus вручную (обычно это делает сам `g_application_run`, явный вызов нужен, если требуется проверить, не запущен ли уже другой экземпляр, **до** запуска главного цикла). После регистрации `g_application_get_is_remote` сообщает, оказалось ли приложение "первичным" (`false`) или было обнаружено, что уже работает другой экземпляр, и текущий процесс лишь передал ему команду и должен завершиться (`true`). `g_application_get_is_registered` — просто флаг, была ли регистрация выполнена вообще.

- `application` — приложение.
- `cancellable` — объект отмены операции (`GCancellable*`, можно передать `nil`).
- `error` — указатель для получения ошибки (`ptr GError`, можно передать `nil`, если детали ошибки не нужны).

```nim
if g_application_register(app, nil, nil) != 0.gboolean:
  if g_application_get_is_remote(app) != 0.gboolean:
    echo "Уже запущен другой экземпляр — завершаем текущий процесс"
    quit(0)
  echo "Это первый (основной) экземпляр приложения"
```

---

### `g_application_get_application_id` / `g_application_set_application_id`

```nim
proc g_application_get_application_id*(application: GApplication): cstring
proc g_application_set_application_id*(application: GApplication, applicationId: cstring)
```

**Что делает.** Читает и (до первой регистрации) изменяет идентификатор приложения, изначально заданный в `gtk_application_new`. Изменение `applicationId` после того, как приложение уже зарегистрировано в D-Bus (см. `g_application_register`), не имеет смысла и обычно является ошибкой использования API.

- `application` — приложение.
- `applicationId` — новый идентификатор в формате обратного DNS.

```nim
echo "Текущий id приложения: ", $g_application_get_application_id(app)
# выводит "Текущий id приложения: org.example.HelloApp"
```

---

### `g_application_get_flags` / `g_application_set_flags`

```nim
proc g_application_get_flags*(application: GApplication): GApplicationFlags
proc g_application_set_flags*(application: GApplication, flags: GApplicationFlags)
```

**Что делает.** Читает и (также только до регистрации) изменяет флаги приложения (`G_APPLICATION_HANDLES_OPEN`, `G_APPLICATION_HANDLES_COMMAND_LINE`, `G_APPLICATION_IS_SERVICE` и т.п.), определяющие, как приложение реагирует на повторный запуск с аргументами командной строки.

- `application` — приложение.
- `flags` — битовая маска `GApplicationFlags`.

```nim
echo "Флаги приложения: ", g_application_get_flags(app)
```

---

### `g_application_get_inactivity_timeout` / `g_application_set_inactivity_timeout`

```nim
proc g_application_get_inactivity_timeout*(application: GApplication): cuint
proc g_application_set_inactivity_timeout*(application: GApplication, inactivityTimeout: cuint)
```

**Что делает.** Задают время (в миллисекундах) простоя без активных окон и удержаний (`hold`), после которого приложение-служба (`G_APPLICATION_IS_SERVICE`) автоматически завершится. Для обычных GUI-приложений с окнами эта настройка не имеет практического значения — они и так завершаются, когда закрыто последнее окно.

- `application` — приложение.
- `inactivityTimeout` — тайм-аут в миллисекундах.

```nim
g_application_set_inactivity_timeout(app, 30_000)  # завершиться через 30 секунд простоя
echo "Тайм-аут неактивности установлен: ", g_application_get_inactivity_timeout(app), " мс"
```

---

### `g_application_open`

```nim
proc g_application_open*(application: GApplication, files: pointer, nFiles: gint, hint: cstring)
```

**Что делает.** Просит приложение открыть список файлов — эмитирует сигнал `"open"` вместо `"activate"`. Работает только если приложение создано с флагом `G_APPLICATION_HANDLES_OPEN`. Используется как при первом запуске программы с файлами в аргументах командной строки, так и для передачи файлов уже запущенному экземпляру (в связке с `g_application_get_is_remote`).

- `application` — приложение.
- `files` — массив указателей на `GFile*` (`ptr UncheckedArray[GFile]` по смыслу, в этой обёртке — сырой `pointer`).
- `nFiles` — количество элементов в `files`.
- `hint` — произвольная строка-подсказка, передаваемая обработчику сигнала `"open"` (может быть пустой строкой).

```nim
# files должен быть подготовлен как массив GFile* — см. справочник GFILE
g_application_open(app, addr filesArray[0], gint(len(filesArray)), "")
echo "Запрос на открытие файлов отправлен"
```

---

### `g_application_mark_busy` / `g_application_unmark_busy` / `g_application_get_is_busy`

```nim
proc g_application_mark_busy*(application: GApplication)
proc g_application_unmark_busy*(application: GApplication)
proc g_application_get_is_busy*(application: GApplication): gboolean
```

**Что делает.** Помечают приложение как "занятое" — GTK автоматически показывает курсор ожидания (песочные часы/крутящийся индикатор) поверх всех окон приложения, пока busy-счётчик больше нуля. В отличие от `hold`/`release`, это влияет только на визуальную индикацию, а не на жизненный цикл главного цикла событий. Вызовы `mark_busy`/`unmark_busy` должны быть парными — счётчик внутри суммирует вложенные вызовы.

- `application` — приложение.

```nim
g_application_mark_busy(app)
echo "Занято: ", g_application_get_is_busy(app) != 0.gboolean  # выводит "Занято: true"
# ... длительная синхронная операция ...
g_application_unmark_busy(app)
echo "Занято: ", g_application_get_is_busy(app) != 0.gboolean  # выводит "Занято: false"
```

---

### `g_application_send_notification` / `g_application_withdraw_notification`

```nim
proc g_application_send_notification*(application: GApplication, id: cstring, notification: pointer)  # GNotification
proc g_application_withdraw_notification*(application: GApplication, id: cstring)
```

**Что делает.** Показывают системное уведомление (в трее/центре уведомлений ОС) и отзывают ранее показанное уведомление по его идентификатору. `notification` — заранее собранный объект `GNotification` (создаётся и настраивается функциями `g_notification_*`, в этот справочник не входят). `id` — произвольная строка, которую приложение само придумывает, чтобы иметь возможность потом отозвать именно это уведомление или заменить его новым с тем же `id`.

- `application` — приложение.
- `id` — идентификатор уведомления, придуманный приложением.
- `notification` — объект `GNotification`.

```nim
# notification собирается заранее через g_notification_new/g_notification_set_body и т.п.
g_application_send_notification(app, "export-done", notification)
echo "Уведомление отправлено"
# ... позже, если нужно убрать уведомление вручную ...
g_application_withdraw_notification(app, "export-done")
```

---

### `g_application_set_resource_base_path` / `g_application_get_resource_base_path`

```nim
proc g_application_set_resource_base_path*(application: GApplication, resourcePath: cstring)
proc g_application_get_resource_base_path*(application: GApplication): cstring
```

**Что делает.** Задают базовый путь внутри скомпилированных GResource-ресурсов (`.gresource`-файлы, встроенные в бинарник или подключаемые отдельно), от которого приложение по умолчанию ищет свои иконки, файлы `GtkBuilder`-разметки и CSS. Если явно не задать, GTK пытается вывести путь из `applicationId`, заменяя точки на слэши (например, `org.example.HelloApp` → `/org/example/HelloApp`).

- `application` — приложение.
- `resourcePath` — путь внутри ресурсов, например `"/org/example/HelloApp"`.

```nim
g_application_set_resource_base_path(app, "/org/example/HelloApp")
echo "Базовый путь ресурсов: ", $g_application_get_resource_base_path(app)
```

---

## GtkWindow

`GtkWindow` — окно верхнего уровня. В GTK4 окно почти всегда содержит **ровно один** дочерний виджет (`gtk_window_set_child`) — чтобы разместить несколько элементов внутри, этим единственным дочерним виджетом делают контейнер (`GtkBox`, `GtkGrid` — разделы V, VI). В отличие от GTK3, окна GTK4 не имеют собственного размера "по умолчанию" при первом показе, если он не задан явно — см. `gtk_window_set_default_size`.

### `gtk_window_new`

```nim
proc gtk_window_new*(): GtkWindow
```

**Что делает.** Создаёт голое окно верхнего уровня, не привязанное ни к какому `GtkApplication`. Валидное использование — вспомогательные/служебные окна, либо приложения, не использующие `GtkApplication` вообще. Для главного окна типового приложения предпочтительнее `gtk_application_window_new` (раздел II) — оно сразу интегрировано с меню и действиями приложения.

- Параметров нет.

```nim
let window = gtk_window_new()
gtk_window_set_title(window, "Служебное окно")
gtk_window_present(window)
echo "Окно создано без привязки к приложению"
```

---

### `gtk_window_set_title` / `gtk_window_get_title`

```nim
proc gtk_window_set_title*(window: GtkWindow, title: cstring)
proc gtk_window_get_title*(window: GtkWindow): cstring
```

**Что делает.** Устанавливают и читают заголовок окна, отображаемый в заголовочной панели (или в панели задач ОС, если заголовочная панель скрыта — см. `gtk_window_set_decorated`). Если заголовок не задан, используется имя исполняемого файла.

- `window` — окно.
- `title` — строка заголовка.

```nim
gtk_window_set_title(window, "Редактор проекта")
echo "Текущий заголовок: ", $gtk_window_get_title(window)
# выводит "Текущий заголовок: Редактор проекта"
```

---

### `gtk_window_set_default_size` / `gtk_window_get_default_size`

```nim
proc gtk_window_set_default_size*(window: GtkWindow, width: gint, height: gint)
proc gtk_window_get_default_size*(window: GtkWindow, width: ptr gint, height: ptr gint)
```

**Что делает.** Задают размер, с которым окно будет показано **при первом отображении**, если пользователь ещё не изменял его размер вручную (после первого ручного изменения размера GTK запоминает пользовательский размер, и `default_size` больше не применяется). Без явного вызова `set_default_size` окно при первом показе сжимается до минимального размера, вмещающего его содержимое, — для окна со сложным интерфейсом это обычно выглядит некорректно, поэтому вызов почти обязателен для главных окон.

- **Реализация.** `gtk_window_get_default_size` — не геттер "текущего" размера окна (для этого нужны функции `GtkWidget`, работающие с фактическим allocation), а именно того значения, которое было задано через `set_default_size`; отрицательное значение (`-1`) в любом из параметров означает "использовать естественный размер по этой оси".

- `window` — окно.
- `width`, `height` — размеры в пикселях (логических, не физических — с учётом масштабирования HiDPI), либо `-1` для естественного размера по соответствующей оси.

```nim
gtk_window_set_default_size(window, 800, 600)
var w, h: gint
gtk_window_get_default_size(window, addr w, addr h)
echo "Размер по умолчанию: ", w, "×", h  # выводит "Размер по умолчанию: 800×600"
```

---

### `gtk_window_set_resizable` / `gtk_window_get_resizable`

```nim
proc gtk_window_set_resizable*(window: GtkWindow, resizable: gboolean)
proc gtk_window_get_resizable*(window: GtkWindow): gboolean
```

**Что делает.** Разрешают или запрещают пользователю менять размер окна перетаскиванием границ. Полезно для диалогов фиксированного размера (например, окно "О программе"), где произвольное изменение размера ломает вёрстку.

- `window` — окно.
- `resizable` — `1.gboolean`, чтобы разрешить изменение размера (значение по умолчанию), `0.gboolean` — чтобы запретить.

```nim
gtk_window_set_resizable(aboutWindow, 0.gboolean)
echo "Можно менять размер: ", gtk_window_get_resizable(aboutWindow) != 0.gboolean
# выводит "Можно менять размер: false"
```

---

### `gtk_window_set_modal` / `gtk_window_get_modal`

```nim
proc gtk_window_set_modal*(window: GtkWindow, modal: gboolean)
proc gtk_window_get_modal*(window: GtkWindow): gboolean
```

**Что делает.** Делают окно модальным относительно его родителя (см. `gtk_window_set_transient_for`) — пока модальное окно открыто, взаимодействие с родительским окном блокируется. Типичное применение — диалоги подтверждения, требующие явного ответа пользователя перед продолжением работы с главным окном.

- `window` — окно.
- `modal` — `1.gboolean` для модального поведения.

```nim
gtk_window_set_transient_for(confirmDialog, mainWindow)
gtk_window_set_modal(confirmDialog, 1.gboolean)
gtk_window_present(confirmDialog)
echo "Диалог показан модально поверх главного окна"
```

---

### `gtk_window_set_decorated` / `gtk_window_get_decorated`

```nim
proc gtk_window_set_decorated*(window: GtkWindow, setting: gboolean)
proc gtk_window_get_decorated*(window: GtkWindow): gboolean
```

**Что делает.** Показывают/скрывают стандартную рамку окна, нарисованную оконным менеджером (заголовок, кнопки свернуть/развернуть/закрыть). Отключение декораций используется для полностью кастомных окон (например, экрана-заставки или окна выбора, оформленного без стандартной рамки) — но тогда приложение само отвечает за перемещение и закрытие окна.

- `window` — окно.
- `setting` — `0.gboolean`, чтобы убрать стандартную рамку.

```nim
gtk_window_set_decorated(splashWindow, 0.gboolean)
echo "Окно без декораций: ", gtk_window_get_decorated(splashWindow) == 0.gboolean
```

---

### `gtk_window_set_deletable` / `gtk_window_get_deletable`

```nim
proc gtk_window_set_deletable*(window: GtkWindow, setting: gboolean)
proc gtk_window_get_deletable*(window: GtkWindow): gboolean
```

**Что делает.** Показывает/скрывает кнопку закрытия окна в заголовочной панели (и, где применимо, пункт "Закрыть" в системном меню окна). Не запрещает закрытие окна программно или через `Alt+F4`/системные средства — только убирает штатную UI-кнопку, если приложению нужно принудительно провести пользователя через собственный сценарий завершения работы.

- `window` — окно.
- `setting` — `0.gboolean`, чтобы скрыть кнопку закрытия.

```nim
gtk_window_set_deletable(wizardWindow, 0.gboolean)
echo "Кнопка закрытия скрыта: ", gtk_window_get_deletable(wizardWindow) == 0.gboolean
```

---

### `gtk_window_set_transient_for` / `gtk_window_get_transient_for`

```nim
proc gtk_window_set_transient_for*(window: GtkWindow, parent: GtkWindow)
proc gtk_window_get_transient_for*(window: GtkWindow): GtkWindow
```

**Что делает.** Помечают окно как логически подчинённое родительскому — оконный менеджер держит такое окно поверх родителя, центрирует его относительно родителя при показе и минимизирует/восстанавливает вместе с ним. Это обязательная настройка перед `gtk_window_set_modal`: без указания родителя модальность не имеет смысла (непонятно, какое окно блокировать).

- `window` — дочернее (например, диалоговое) окно.
- `parent` — родительское окно.

```nim
gtk_window_set_transient_for(settingsDialog, mainWindow)
echo "Родитель диалога настроек установлен: ", not isNil(gtk_window_get_transient_for(settingsDialog))
```

---

### `gtk_window_set_child` / `gtk_window_get_child`

```nim
proc gtk_window_set_child*(window: GtkWindow, child: GtkWidget)
proc gtk_window_get_child*(window: GtkWindow): GtkWidget
```

**Что делает.** Устанавливают единственный дочерний виджет окна — всё содержимое окна в GTK4 подвешивается именно так (в отличие от GTK3, где было отдельное понятие "контейнер" с несколькими детьми у самого окна). Чтобы показать в окне несколько элементов, единственным child'ом делают компоновочный контейнер (`GtkBox`/`GtkGrid` из этого справочника, либо `GtkStack`/`GtkPaned` и др. из смежных справочников).

- `window` — окно.
- `child` — виджет, который станет содержимым окна (передача `nil` убирает текущее содержимое).

```nim
let root = gtk_box_new(GTK_ORIENTATION_VERTICAL, 8)
gtk_window_set_child(window, root)
echo "Корневой контейнер установлен как содержимое окна: ", gtk_window_get_child(window) == root
```

---

### `gtk_window_set_titlebar` / `gtk_window_get_titlebar`

```nim
proc gtk_window_set_titlebar*(window: GtkWindow, titlebar: GtkWidget)
proc gtk_window_get_titlebar*(window: GtkWindow): GtkWidget
```

**Что делает.** Заменяют стандартную заголовочную панель окна на произвольный виджет — типично `GtkHeaderBar` (отдельный справочник), в который можно поместить кнопки, переключатели режимов, поле поиска и т.п. прямо в заголовок окна, вместо простого текста заголовка.

- `window` — окно.
- `titlebar` — виджет, который станет заголовочной панелью (чаще всего `GtkHeaderBar`).

```nim
# headerBar собирается заранее через gtk_header_bar_new и настраивается отдельно
gtk_window_set_titlebar(window, headerBar)
echo "Пользовательская заголовочная панель установлена"
```

---

### `gtk_window_close` / `gtk_window_destroy`

```nim
proc gtk_window_close*(window: GtkWindow)
proc gtk_window_destroy*(window: GtkWindow)
```

**Что делает.** `gtk_window_close` инициирует штатное закрытие окна — так же, как если бы пользователь нажал системную кнопку закрытия: сначала эмитируется сигнал `"close-request"`, и если ни один обработчик не вернул "остановить закрытие", окно уничтожается. `gtk_window_destroy` уничтожает окно немедленно, без эмиссии `"close-request"` — обработчики, которые могли бы предотвратить закрытие (например, диалог "сохранить изменения?"), в этом случае не вызываются.

- **Реализация.** Для реакции на попытку закрытия окна пользователем (а не только программного закрытия) нужно подключаться именно к сигналу `"close-request"`, а не пытаться перехватить сам вызов `gtk_window_close`.

- `window` — окно, которое нужно закрыть.

```nim
proc onCloseRequest(win: GtkWindow, userData: gpointer): gboolean {.cdecl.} =
  echo "Пользователь пытается закрыть окно"
  result = 0.gboolean  # 0 — разрешить закрытие; 1 — отменить закрытие

discard g_signal_connect(window, "close-request", onCloseRequest, nil)
gtk_window_close(window)  # запускает described выше проверку через close-request
```

---

### `gtk_window_present`

```nim
proc gtk_window_present*(window: GtkWindow)
```

**Что делает.** Показывает окно и выводит его на передний план с фокусом ввода — это предпочтительный способ показать окно в GTK4 (вместо унаследованного от `GtkWidget` `gtk_widget_show`, который тоже работает, но не гарантирует вывод окна поверх остальных и передачу фокуса). Если окно уже видимо, повторный вызов просто поднимает его на передний план — удобно для сценария "повторная активация уже открытого окна".

- `window` — окно, которое нужно показать/поднять на передний план.

```nim
gtk_window_present(window)
echo "Окно показано и получило фокус"
```

---

### `gtk_window_fullscreen` / `gtk_window_unfullscreen` / `gtk_window_is_fullscreen`

```nim
proc gtk_window_fullscreen*(window: GtkWindow)
proc gtk_window_unfullscreen*(window: GtkWindow)
proc gtk_window_is_fullscreen*(window: GtkWindow): gboolean
```

**Что делает.** Переводят окно в полноэкранный режим и обратно; `gtk_window_is_fullscreen` сообщает текущее состояние. Переключение полноэкранного режима асинхронно (запрос идёт через оконный менеджер/композитор) — состояние, возвращаемое `is_fullscreen`, может обновиться не мгновенно после вызова `fullscreen`, а на следующей итерации главного цикла; для надёжной реакции на фактическое изменение состояния стоит подписываться на соответствующее уведомление об изменении свойства (`"notify::fullscreened"`), а не проверять `is_fullscreen` сразу после вызова.

- `window` — окно.

```nim
gtk_window_fullscreen(playerWindow)
echo "Запрос на полноэкранный режим отправлен"
# ... позже, например по нажатию Escape ...
gtk_window_unfullscreen(playerWindow)
```

---

### `gtk_window_maximize` / `gtk_window_unmaximize`

```nim
proc gtk_window_maximize*(window: GtkWindow)
proc gtk_window_unmaximize*(window: GtkWindow)
```

**Что делает.** Разворачивают окно на весь экран, оставляя видимой заголовочную панель и панель задач (в отличие от полноэкранного режима), и возвращают окно к предыдущему размеру. Как и `fullscreen`/`unfullscreen`, изменение асинхронно.

- `window` — окно.

```nim
gtk_window_maximize(window)
echo "Запрос на разворачивание окна отправлен"
```

---

### `gtk_window_minimize` / `gtk_window_unminimize`

```nim
proc gtk_window_minimize*(window: GtkWindow)
proc gtk_window_unminimize*(window: GtkWindow)
```

**Что делает.** Сворачивают окно в панель задач и восстанавливают его обратно программно — эквивалент нажатия пользователем кнопки сворачивания.

- `window` — окно.

```nim
gtk_window_minimize(window)
echo "Окно свёрнуто"
# ... позже, например по клику на иконку в трее ...
gtk_window_unminimize(window)
gtk_window_present(window)
```

---

### `gtk_window_set_icon_name` / `gtk_window_set_default_icon_name`

```nim
proc gtk_window_set_icon_name*(window: GtkWindow, name: cstring)
proc gtk_window_set_default_icon_name*(name: cstring)
```

**Что делает.** `gtk_window_set_icon_name` задаёт иконку конкретного окна по имени из иконочной темы (`GtkIconTheme`) — используется для окон, которым нужна иконка, отличная от основной иконки приложения. `gtk_window_set_default_icon_name` — статическая процедура (не принимает объект окна), задаёт иконку по умолчанию сразу для всех окон приложения, у которых иконка не задана явно. На практике на Wayland/X11-окружениях с современными GNOME/KDE иконку окна чаще определяет `.desktop`-файл приложения, а не этот вызов, — тем не менее его стоит вызывать для явности и совместимости с окружениями, где `.desktop`-файла нет (например, при запуске напрямую из терминала во время разработки).

- `window` (только для `set_icon_name`) — конкретное окно.
- `name` — имя иконки в теме (например, `"applications-graphics"` или собственное имя иконки приложения, установленной в тему).

```nim
gtk_window_set_default_icon_name("org.example.HelloApp")
echo "Иконка по умолчанию для всех окон приложения установлена"
```

---

## GtkWidget (базовый интерфейс всех виджетов)

`GtkWidget` — базовый класс для всех элементов интерфейса в GTK4: окон, кнопок, полей ввода, контейнеров. Все процедуры этого раздела применимы к любому объекту-виджету обёртки (в Nim это просто означает, что первый параметр можно передать как `GtkWidget`, либо привести из более конкретного типа — все типы виджетов в этой обёртке являются алиасами `pointer`, поэтому явное приведение типов не требуется, важно лишь передавать корректный объект).

### `gtk_widget_show` / `gtk_widget_hide` / `gtk_widget_set_visible` / `gtk_widget_get_visible`

```nim
proc gtk_widget_show*(widget: GtkWidget)
proc gtk_widget_hide*(widget: GtkWidget)
proc gtk_widget_set_visible*(widget: GtkWidget, visible: gboolean)
proc gtk_widget_get_visible*(widget: GtkWidget): gboolean
```

**Что делает.** Управляют видимостью виджета. `gtk_widget_show`/`gtk_widget_hide` — это просто удобные обёртки над `gtk_widget_set_visible(widget, 1.gboolean)`/`gtk_widget_set_visible(widget, 0.gboolean)`. Важно отличать видимость от присутствия в дереве виджетов: скрытый виджет остаётся дочерним элементом своего контейнера и продолжает занимать место в объектной модели (его можно снова показать), просто не рисуется и не участвует в раскладке.

- **Реализация.** В GTK4 виджеты по умолчанию видимы сразу после создания (в отличие от GTK3, где нужно было вызывать `show()` для каждого виджета вручную) — явный `gtk_widget_show`/`set_visible(true)` обычно нужен только для того, чтобы снова показать ранее скрытый виджет.

- `widget` — виджет.
- `visible` — `1.gboolean`/`0.gboolean`.

```nim
gtk_widget_hide(progressBar)
echo "Индикатор прогресса скрыт: ", gtk_widget_get_visible(progressBar) == 0.gboolean
# ... когда операция началась ...
gtk_widget_show(progressBar)
echo "Индикатор прогресса показан: ", gtk_widget_get_visible(progressBar) != 0.gboolean
```

---

### `gtk_widget_set_sensitive` / `gtk_widget_get_sensitive`

```nim
proc gtk_widget_set_sensitive*(widget: GtkWidget, sensitive: gboolean)
proc gtk_widget_get_sensitive*(widget: GtkWidget): gboolean
```

**Что делает.** Включают/отключают виджет для взаимодействия (нечувствительный виджет обычно отрисовывается "приглушённым" и не реагирует на клики/ввод), не убирая его из вида, — в отличие от `hide`, где виджет пропадает совсем. Типичный сценарий: кнопка "Сохранить" неактивна, пока в форме есть несохранённые ошибки валидации.

- `widget` — виджет.
- `sensitive` — `1.gboolean` — включить, `0.gboolean` — отключить.

```nim
gtk_widget_set_sensitive(saveButton, 0.gboolean)
echo "Кнопка 'Сохранить' отключена: ", gtk_widget_get_sensitive(saveButton) == 0.gboolean
# ... после успешной валидации формы ...
gtk_widget_set_sensitive(saveButton, 1.gboolean)
```

---

### `gtk_widget_set_can_focus` / `gtk_widget_get_can_focus` / `gtk_widget_grab_focus`

```nim
proc gtk_widget_set_can_focus*(widget: GtkWidget, canFocus: gboolean)
proc gtk_widget_get_can_focus*(widget: GtkWidget): gboolean
proc gtk_widget_grab_focus*(widget: GtkWidget): gboolean
```

**Что делает.** `set_can_focus`/`get_can_focus` определяют, способен ли виджет в принципе принимать клавиатурный фокус (например, обычная надпись `GtkLabel` по умолчанию не может, а поле ввода `GtkEntry` — может). `gtk_widget_grab_focus` немедленно запрашивает фокус ввода для конкретного виджета — например, чтобы курсор сразу оказался в первом поле формы при открытии диалога. Возвращает `gboolean`, сообщающий, удался ли захват фокуса (может не удаться, если у виджета `can_focus == false` либо он не видим/не чувствителен).

- `widget` — виджет.
- `canFocus` — `1.gboolean`/`0.gboolean`.

```nim
discard gtk_widget_grab_focus(usernameEntry)
echo "Фокус ввода передан полю имени пользователя"
```

---

### `gtk_widget_set_size_request` / `gtk_widget_get_size_request`

```nim
proc gtk_widget_set_size_request*(widget: GtkWidget, width: gint, height: gint)
proc gtk_widget_get_size_request*(widget: GtkWidget, width: ptr gint, height: ptr gint)
```

**Что делает.** Задают **минимальный** размер, который виджет запрашивает у системы компоновки (не путать с `gtk_window_set_default_size` — это про начальный размер окна, а `size_request` — про минимальный размер отдельного виджета внутри любой раскладки). Реальный размер виджета в итоге может оказаться больше этого минимума, если родительский контейнер выделяет ему больше места (особенно при включённом `hexpand`/`vexpand`, см. ниже), но не меньше.

- `widget` — виджет.
- `width`, `height` — минимальный размер в пикселях, либо `-1`, чтобы не задавать минимум по соответствующей оси (использовать "естественный" размер, вычисленный самим виджетом).

```nim
gtk_widget_set_size_request(previewArea, 320, 240)
var w, h: gint
gtk_widget_get_size_request(previewArea, addr w, addr h)
echo "Минимальный размер области предпросмотра: ", w, "×", h
```

---

### `gtk_widget_set_hexpand` / `gtk_widget_get_hexpand` / `gtk_widget_set_vexpand` / `gtk_widget_get_vexpand`

```nim
proc gtk_widget_set_hexpand*(widget: GtkWidget, expand: gboolean)
proc gtk_widget_get_hexpand*(widget: GtkWidget): gboolean
proc gtk_widget_set_vexpand*(widget: GtkWidget, expand: gboolean)
proc gtk_widget_get_vexpand*(widget: GtkWidget): gboolean
```

**Что делает.** Сообщают родительскому контейнеру, должен ли виджет забирать себе всё лишнее свободное место по горизонтали (`hexpand`) и/или вертикали (`vexpand`), когда контейнер больше, чем сумма минимальных размеров его детей. Без `expand` виджет получает ровно свой минимальный/естественный размер и "прилипает" к выравниванию (`halign`/`valign`, см. ниже), а всё лишнее место остаётся пустым.

- **Реализация.** Это единственный по-настоящему надёжный способ заставить, например, текстовое поле в `GtkBox` растягиваться на всю доступную ширину — без `set_hexpand(true)` поле ввода будет оставаться маленьким, даже если у него `halign = GTK_ALIGN_FILL`.

- `widget` — виджет.
- `expand` — `1.gboolean`/`0.gboolean`.

```nim
gtk_widget_set_hexpand(searchEntry, 1.gboolean)  # поле поиска займёт всю доступную ширину
echo "hexpand включён: ", gtk_widget_get_hexpand(searchEntry) != 0.gboolean
```

---

### `gtk_widget_set_halign` / `gtk_widget_get_halign` / `gtk_widget_set_valign` / `gtk_widget_get_valign`

```nim
proc gtk_widget_set_halign*(widget: GtkWidget, align: GtkAlign)
proc gtk_widget_get_halign*(widget: GtkWidget): GtkAlign
proc gtk_widget_set_valign*(widget: GtkWidget, align: GtkAlign)
proc gtk_widget_get_valign*(widget: GtkWidget): GtkAlign
```

**Что делает.** Задают, как виджет выравнивается **внутри выделенного ему места**, если это место больше его естественного размера (`GTK_ALIGN_START`, `GTK_ALIGN_END`, `GTK_ALIGN_CENTER`, `GTK_ALIGN_FILL`). Работает в паре с `hexpand`/`vexpand`: `expand` определяет, сколько места контейнер выделит виджету, а `align` — как виджет расположится внутри этого места, если оно больше его собственного размера.

- `widget` — виджет.
- `align` — значение `GtkAlign`.

```nim
gtk_widget_set_halign(okButton, GTK_ALIGN_END)  # кнопка прижимается к правому краю
gtk_widget_set_valign(okButton, GTK_ALIGN_CENTER)
echo "Выравнивание кнопки: halign=", gtk_widget_get_halign(okButton)
```

---

### `gtk_widget_set_margin_start` / `_end` / `_top` / `_bottom` (и геттеры)

```nim
proc gtk_widget_set_margin_start*(widget: GtkWidget, margin: gint)
proc gtk_widget_get_margin_start*(widget: GtkWidget): gint
proc gtk_widget_set_margin_end*(widget: GtkWidget, margin: gint)
proc gtk_widget_get_margin_end*(widget: GtkWidget): gint
proc gtk_widget_set_margin_top*(widget: GtkWidget, margin: gint)
proc gtk_widget_get_margin_top*(widget: GtkWidget): gint
proc gtk_widget_set_margin_bottom*(widget: GtkWidget, margin: gint)
proc gtk_widget_get_margin_bottom*(widget: GtkWidget): gint
```

**Что делает.** Задают внешние отступы виджета с каждой из четырёх сторон — то, что в CSS называлось бы `margin`. `start`/`end` — это логические "начало"/"конец" по направлению письма (при LTR-локали `start` соответствует левому краю, `end` — правому; при RTL — наоборот), а не фиксированно "левый"/"правый"; это позволяет вёрстке автоматически корректно зеркалироваться для RTL-языков (см. `gtk_get_locale_direction` в разделе I). Отдельной процедуры "задать все четыре отступа сразу" в этой обёртке нет — для этого нужно вызвать все четыре сеттера.

- `widget` — виджет.
- `margin` — отступ в пикселях.

```nim
gtk_widget_set_margin_start(formGrid, 12)
gtk_widget_set_margin_end(formGrid, 12)
gtk_widget_set_margin_top(formGrid, 12)
gtk_widget_set_margin_bottom(formGrid, 12)
echo "Отступы формы: ", gtk_widget_get_margin_top(formGrid), " со всех сторон"
```

---

### `gtk_widget_set_tooltip_text` / `gtk_widget_get_tooltip_text` / `gtk_widget_set_tooltip_markup` / `gtk_widget_get_tooltip_markup`

```nim
proc gtk_widget_set_tooltip_text*(widget: GtkWidget, text: cstring)
proc gtk_widget_get_tooltip_text*(widget: GtkWidget): cstring
proc gtk_widget_set_tooltip_markup*(widget: GtkWidget, markup: cstring)
proc gtk_widget_get_tooltip_markup*(widget: GtkWidget): cstring
```

**Что делает.** Задают всплывающую подсказку, показываемую при наведении курсора на виджет. `_text`-вариант принимает обычный текст (спецсимволы `<`, `>`, `&` экранируются автоматически); `_markup`-вариант принимает разметку Pango (`<b>`, `<i>`, `<span>` и т.п.) для форматированной подсказки — использовать оба варианта одновременно для одного виджета не нужно, последний вызванный сеттер определяет итоговую подсказку.

- `widget` — виджет.
- `text` — обычный текст подсказки.
- `markup` — текст подсказки с разметкой Pango.

```nim
gtk_widget_set_tooltip_text(deleteButton, "Удалить выбранный элемент безвозвратно")
echo "Подсказка установлена: ", $gtk_widget_get_tooltip_text(deleteButton)
```

---

### `gtk_widget_set_name` / `gtk_widget_get_name`

```nim
proc gtk_widget_set_name*(widget: GtkWidget, name: cstring)
proc gtk_widget_get_name*(widget: GtkWidget): cstring
```

**Что делает.** Задают уникальное для приложения имя виджета — используется как селектор `#имя` в CSS для точечной стилизации конкретного экземпляра виджета (в отличие от `add_css_class`, который применяет стиль ко всем виджетам с данным классом). Не путать с `label`/текстом виджета — `name` не отображается пользователю, это чисто техническая метка.

- `widget` — виджет.
- `name` — уникальное имя (обычно в стиле `kebab-case`, как принято в CSS-селекторах).

```nim
gtk_widget_set_name(dangerButton, "danger-action-button")
echo "Имя для CSS-селектора #danger-action-button установлено: ", $gtk_widget_get_name(dangerButton)
```

---

### `gtk_widget_add_css_class` / `gtk_widget_remove_css_class` / `gtk_widget_has_css_class`

```nim
proc gtk_widget_add_css_class*(widget: GtkWidget, cssClass: cstring)
proc gtk_widget_remove_css_class*(widget: GtkWidget, cssClass: cstring)
proc gtk_widget_has_css_class*(widget: GtkWidget, cssClass: cstring): gboolean
```

**Что делает.** Управляют набором CSS-классов виджета — основной механизм стилизации в GTK4 (заменяет прямую установку цветов/шрифтов кодом). GTK поставляет ряд встроенных именованных классов с готовым видом в теме (например, `"destructive-action"` — для кнопок опасных действий с красным акцентом, `"suggested-action"` — для основной/рекомендуемой кнопки, `"flat"`, `"circular"` и т.п.) — использование этих готовых классов вместо ручной покраски виджетов даёт консистентный с системной темой вид.

- `widget` — виджет.
- `cssClass` — имя класса без ведущей точки (точка добавляется автоматически в терминах CSS-селектора `.имя`).

```nim
gtk_widget_add_css_class(deleteButton, "destructive-action")
echo "У кнопки есть класс destructive-action: ", gtk_widget_has_css_class(deleteButton, "destructive-action") != 0.gboolean
gtk_widget_remove_css_class(deleteButton, "destructive-action")
```

---

### `gtk_widget_get_parent` / `gtk_widget_get_first_child` / `gtk_widget_get_last_child` / `gtk_widget_get_next_sibling` / `gtk_widget_get_prev_sibling`

```nim
proc gtk_widget_get_parent*(widget: GtkWidget): GtkWidget
proc gtk_widget_get_first_child*(widget: GtkWidget): GtkWidget
proc gtk_widget_get_last_child*(widget: GtkWidget): GtkWidget
proc gtk_widget_get_next_sibling*(widget: GtkWidget): GtkWidget
proc gtk_widget_get_prev_sibling*(widget: GtkWidget): GtkWidget
```

**Что делает.** Позволяют обходить дерево виджетов вручную — от родителя к первому/последнему ребёнку, от одного виджета к соседнему в списке детей одного родителя. Это универсальный, не зависящий от конкретного типа контейнера способ обхода (в GTK4 все контейнеры организуют детей в связный список, доступный именно через эти процедуры `GtkWidget`, а не через отдельный API каждого типа контейнера, как было в GTK3). Если дочернего элемента / соседа нет, соответствующая процедура возвращает `nil`.

- `widget` — виджет, относительно которого выполняется навигация.

```nim
# Полный пример обхода — см. раздел VII, "Обход дерева виджетов"
var child = gtk_widget_get_first_child(container)
var count = 0
while not isNil(child):
  count += 1
  child = gtk_widget_get_next_sibling(child)
echo "Прямых дочерних виджетов: ", count
```

---

## GtkBox

`GtkBox` — простейший линейный контейнер: раскладывает дочерние виджеты в один ряд (горизонтально) или один столбец (вертикально). Это самый частый выбор для панелей инструментов, строк формы, групп кнопок — везде, где элементы идут друг за другом в одном направлении. Для табличной раскладки в несколько строк и столбцов сразу используется `GtkGrid` (следующий раздел).

### `gtk_box_new`

```nim
proc gtk_box_new*(orientation: GtkOrientation, spacing: gint): GtkBox
```

**Что делает.** Создаёт контейнер `GtkBox` с заданной ориентацией и промежутком между соседними дочерними виджетами.

- `orientation` — `GTK_ORIENTATION_HORIZONTAL` или `GTK_ORIENTATION_VERTICAL`.
- `spacing` — расстояние в пикселях между соседними дочерними виджетами (не путать с внешними отступами самого `GtkBox` — за них отвечает `gtk_widget_set_margin_*` из раздела IV).

```nim
let toolbar = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 6)
echo "Горизонтальная панель с промежутком 6px создана"
```

---

### `gtk_box_append` / `gtk_box_prepend` / `gtk_box_remove`

```nim
proc gtk_box_append*(box: GtkBox, child: GtkWidget)
proc gtk_box_prepend*(box: GtkBox, child: GtkWidget)
proc gtk_box_remove*(box: GtkBox, child: GtkWidget)
```

**Что делает.** Добавляют виджет в конец (`append`) или в начало (`prepend`) списка дочерних элементов контейнера, либо убирают виджет из контейнера (`remove`, сам виджет при этом не уничтожается, а просто отсоединяется — если на него нет других ссылок, он будет освобождён сборщиком ссылок GObject). Порядок вызовов `append` определяет порядок отображения слева направо (или сверху вниз для вертикального `GtkBox`).

- `box` — контейнер.
- `child` — виджет, который нужно добавить/убрать.

```nim
let box = gtk_box_new(GTK_ORIENTATION_VERTICAL, 8)
gtk_box_append(box, titleLabel)
gtk_box_append(box, descriptionLabel)
gtk_box_prepend(box, iconImage)  # окажется перед titleLabel, т.е. первым
echo "В контейнере три виджета: иконка, заголовок, описание"
# ... позже, если описание больше не нужно ...
gtk_box_remove(box, descriptionLabel)
```

---

### `gtk_box_insert_child_after` / `gtk_box_reorder_child_after`

```nim
proc gtk_box_insert_child_after*(box: GtkBox, child: GtkWidget, sibling: GtkWidget)
proc gtk_box_reorder_child_after*(box: GtkBox, child: GtkWidget, sibling: GtkWidget)
```

**Что делает.** `insert_child_after` вставляет **новый** виджет `child` сразу после уже существующего в контейнере виджета `sibling` (если `sibling` равен `nil` — виджет вставляется в самое начало, аналогично `prepend`). `reorder_child_after` меняет порядок уже присутствующего в контейнере виджета `child`, перемещая его сразу после `sibling`, не убирая и не добавляя его заново.

- `box` — контейнер.
- `child` — вставляемый/перемещаемый виджет.
- `sibling` — виджет, после которого должен оказаться `child` (или `nil` для начала списка).

```nim
gtk_box_insert_child_after(box, subtitleLabel, titleLabel)
echo "Подзаголовок вставлен сразу после заголовка"
# Позже решили поменять местами иконку и заголовок:
gtk_box_reorder_child_after(box, iconImage, titleLabel)
echo "Иконка перемещена после заголовка"
```

---

### `gtk_box_set_spacing` / `gtk_box_get_spacing`

```nim
proc gtk_box_set_spacing*(box: GtkBox, spacing: gint)
proc gtk_box_get_spacing*(box: GtkBox): gint
```

**Что делает.** Изменяют и читают промежуток между дочерними виджетами уже после создания контейнера (тот же параметр, что передаётся в `gtk_box_new`, но доступный для изменения "на лету" — например, при переключении плотной/просторной темы интерфейса).

- `box` — контейнер.
- `spacing` — промежуток в пикселях.

```nim
gtk_box_set_spacing(toolbar, 12)
echo "Новый промежуток между кнопками панели: ", gtk_box_get_spacing(toolbar)
```

---

### `gtk_box_set_homogeneous` / `gtk_box_get_homogeneous`

```nim
proc gtk_box_set_homogeneous*(box: GtkBox, homogeneous: gboolean)
proc gtk_box_get_homogeneous*(box: GtkBox): gboolean
```

**Что делает.** Включает режим, в котором все дочерние виджеты получают **одинаковый** размер по оси раскладки (ширину — для горизонтального `GtkBox`, высоту — для вертикального), равный размеру самого требовательного из них, вместо того, чтобы каждый занимал только свой естественный размер. Удобно для рядов одинаковых кнопок (например, "Отмена"/"ОК"), где визуально хочется, чтобы кнопки были одной ширины независимо от длины текста на них.

- `box` — контейнер.
- `homogeneous` — `1.gboolean` для одинакового размера всех детей.

```nim
let buttonRow = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 8)
gtk_box_set_homogeneous(buttonRow, 1.gboolean)
gtk_box_append(buttonRow, cancelButton)
gtk_box_append(buttonRow, okButton)
echo "Кнопки Отмена и ОК теперь одной ширины"
```

---

### `gtk_box_set_baseline_position` / `gtk_box_get_baseline_position` / `gtk_box_set_baseline_child` / `gtk_box_get_baseline_child`

```nim
proc gtk_box_set_baseline_position*(box: GtkBox, position: GtkBaselinePosition)
proc gtk_box_get_baseline_position*(box: GtkBox): GtkBaselinePosition
proc gtk_box_set_baseline_child*(box: GtkBox, child: gint)
proc gtk_box_get_baseline_child*(box: GtkBox): gint
```

**Что делает.** Управляют выравниванием по базовой линии текста (baseline) — тонкой настройкой, актуальной, когда в одном горизонтальном `GtkBox` соседствуют виджеты с текстом разного размера шрифта (например, крупная цифра рядом с мелкой подписью единиц измерения), и нужно, чтобы они визуально выравнивались "по низу букв", а не по верхней/нижней границе виджета. `baseline_position` задаёт, к какому краю тяготеет базовая линия, когда высот виджетов недостаточно, чтобы выровнять их естественно; `baseline_child` — индекс конкретного дочернего виджета (начиная с `0`), чья базовая линия считается опорной для всего ряда, `-1` означает "нет выделенного опорного виджета".

- `box` — контейнер (должен быть горизонтальным — выравнивание по базовой линии имеет смысл только для горизонтальной раскладки текста).
- `position` — значение `GtkBaselinePosition` (`GTK_BASELINE_POSITION_TOP`, `_CENTER`, `_BOTTOM`).
- `child` — индекс опорного дочернего виджета, либо `-1`.

```nim
let priceRow = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 4)
gtk_box_append(priceRow, bigPriceLabel)     # индекс 0, крупный шрифт
gtk_box_append(priceRow, currencyLabel)     # индекс 1, мелкий шрифт
gtk_box_set_baseline_child(priceRow, 0)     # выравниваем по базовой линии крупной цены
echo "Опорный дочерний виджет для базовой линии: ", gtk_box_get_baseline_child(priceRow)
```

---

## GtkGrid

`GtkGrid` — табличный контейнер: виджеты размещаются по явно заданным координатам (столбец, строка) и могут занимать несколько ячеек по ширине/высоте. В отличие от `GtkBox`, который лишь выстраивает элементы в один ряд/столбец, `GtkGrid` подходит там, где нужна настоящая двумерная раскладка — классический пример: форма "подпись слева — поле ввода справа" в несколько строк.

### `gtk_grid_new`

```nim
proc gtk_grid_new*(): GtkGrid
```

**Что делает.** Создаёт пустой контейнер-таблицу. Число строк и столбцов заранее не фиксируется — сетка расширяется автоматически по мере добавления виджетов в новые координаты через `gtk_grid_attach`.

- Параметров нет.

```nim
let formGrid = gtk_grid_new()
echo "Пустая сетка для формы создана"
```

---

### `gtk_grid_attach` / `gtk_grid_attach_next_to`

```nim
proc gtk_grid_attach*(grid: GtkGrid, child: GtkWidget, column: gint, row: gint, width: gint, height: gint)
proc gtk_grid_attach_next_to*(grid: GtkGrid, child: GtkWidget, sibling: GtkWidget, side: GtkPositionType, width: gint, height: gint)
```

**Что делает.** `gtk_grid_attach` размещает виджет по явным координатам (столбец, строка — обе начиная с `0`), с возможностью растянуть его на несколько ячеек через `width`/`height` (в ячейках, а не в пикселях). `gtk_grid_attach_next_to` — альтернативный способ, размещающий виджет рядом с уже существующим в сетке виджетом `sibling`, с указанной стороны (`side`) — удобно, когда точные числовые координаты неважны, а важен порядок относительно уже добавленных элементов (например, "добавить ещё одну строку формы после последней").

- `grid` — контейнер-сетка.
- `child` — добавляемый виджет.
- `column`, `row` — координаты левой верхней ячейки, занимаемой виджетом (для `attach`).
- `width`, `height` — сколько столбцов/строк виджет занимает (обычно `1`, `1`).
- `sibling`, `side` (для `attach_next_to`) — уже размещённый виджет-ориентир и сторона (`GTK_POS_LEFT`, `GTK_POS_RIGHT`, `GTK_POS_TOP`, `GTK_POS_BOTTOM`).

```nim
let grid = gtk_grid_new()
gtk_grid_attach(grid, nameLabel, 0, 0, 1, 1)   # столбец 0, строка 0
gtk_grid_attach(grid, nameEntry, 1, 0, 1, 1)   # столбец 1, строка 0 — рядом с подписью
gtk_grid_attach_next_to(grid, emailLabel, nameLabel, GTK_POS_BOTTOM, 1, 1)  # новая строка под nameLabel
gtk_grid_attach_next_to(grid, emailEntry, emailLabel, GTK_POS_RIGHT, 1, 1)
echo "Форма из двух строк (Имя, Email) собрана на сетке"
```

---

### `gtk_grid_remove` / `gtk_grid_get_child_at`

```nim
proc gtk_grid_remove*(grid: GtkGrid, child: GtkWidget)
proc gtk_grid_get_child_at*(grid: GtkGrid, column: gint, row: gint): GtkWidget
```

**Что делает.** `gtk_grid_remove` убирает виджет из сетки (аналогично `gtk_box_remove` — сам виджет не уничтожается, лишь отсоединяется). `gtk_grid_get_child_at` находит, какой виджет (если есть) занимает указанную ячейку сетки — возвращает `nil`, если ячейка пуста.

- `grid` — контейнер-сетка.
- `child` (для `remove`) — виджет, который нужно убрать.
- `column`, `row` (для `get_child_at`) — координаты искомой ячейки.

```nim
let widgetInCell = gtk_grid_get_child_at(grid, 1, 0)
if not isNil(widgetInCell):
  echo "В ячейке (1, 0) уже есть виджет — удаляем перед заменой"
  gtk_grid_remove(grid, widgetInCell)
```

---

### `gtk_grid_set_row_spacing` / `gtk_grid_get_row_spacing` / `gtk_grid_set_column_spacing` / `gtk_grid_get_column_spacing`

```nim
proc gtk_grid_set_row_spacing*(grid: GtkGrid, spacing: guint)
proc gtk_grid_get_row_spacing*(grid: GtkGrid): guint
proc gtk_grid_set_column_spacing*(grid: GtkGrid, spacing: guint)
proc gtk_grid_get_column_spacing*(grid: GtkGrid): guint
```

**Что делает.** Задают промежутки между строками и между столбцами независимо друг от друга (в отличие от `GtkBox`, где промежуток один, так как раскладка одномерная).

- `grid` — контейнер-сетка.
- `spacing` — промежуток в пикселях.

```nim
gtk_grid_set_row_spacing(formGrid, 8)
gtk_grid_set_column_spacing(formGrid, 12)
echo "Промежутки формы: строки=", gtk_grid_get_row_spacing(formGrid), ", столбцы=", gtk_grid_get_column_spacing(formGrid)
```

---

### `gtk_grid_set_row_homogeneous` / `gtk_grid_get_row_homogeneous` / `gtk_grid_set_column_homogeneous` / `gtk_grid_get_column_homogeneous`

```nim
proc gtk_grid_set_row_homogeneous*(grid: GtkGrid, homogeneous: gboolean)
proc gtk_grid_get_row_homogeneous*(grid: GtkGrid): gboolean
proc gtk_grid_set_column_homogeneous*(grid: GtkGrid, homogeneous: gboolean)
proc gtk_grid_get_column_homogeneous*(grid: GtkGrid): gboolean
```

**Что делает.** Аналог `gtk_box_set_homogeneous`, но раздельно по строкам и по столбцам: если включено для столбцов, все столбцы получают одинаковую ширину (по самому широкому содержимому), независимо для строк — та же логика по высоте.

- `grid` — контейнер-сетка.
- `homogeneous` — `1.gboolean`/`0.gboolean`.

```nim
gtk_grid_set_column_homogeneous(formGrid, 1.gboolean)  # оба столбца формы одной ширины
echo "Столбцы выровнены по ширине: ", gtk_grid_get_column_homogeneous(formGrid) != 0.gboolean
```

---

### `gtk_grid_insert_row` / `gtk_grid_insert_column` / `gtk_grid_remove_row` / `gtk_grid_remove_column`

```nim
proc gtk_grid_insert_row*(grid: GtkGrid, position: gint)
proc gtk_grid_insert_column*(grid: GtkGrid, position: gint)
proc gtk_grid_remove_row*(grid: GtkGrid, position: gint)
proc gtk_grid_remove_column*(grid: GtkGrid, position: gint)
```

**Что делает.** Вставляют новую пустую строку/столбец в указанной позиции, сдвигая все последующие строки/столбцы (и виджеты в них) на одну позицию, либо удаляют строку/столбец целиком вместе со всеми виджетами, которые в нём находились (сдвигая последующие обратно). Полезно для динамических форм, где строки добавляются/убираются во время работы программы (например, список полей "адрес доставки", где пользователь может добавить ещё один адрес).

- `grid` — контейнер-сетка.
- `position` — индекс строки/столбца, перед которым выполняется вставка, либо который удаляется.

```nim
gtk_grid_insert_row(formGrid, 1)  # освобождаем строку 1 под новое поле, всё что было ниже — сдвинулось
gtk_grid_attach(formGrid, phoneLabel, 0, 1, 1, 1)
gtk_grid_attach(formGrid, phoneEntry, 1, 1, 1, 1)
echo "В форму вставлена новая строка 'Телефон'"
```

---

### `gtk_grid_insert_next_to`

```nim
proc gtk_grid_insert_next_to*(grid: GtkGrid, sibling: GtkWidget, side: GtkPositionType)
```

**Что делает.** Вставляет новую пустую строку или столбец (в зависимости от `side`) рядом с той строкой/столбцом, где расположен виджет `sibling`, — комбинация удобства `attach_next_to` (не нужно вручную считать координаты) с эффектом `insert_row`/`insert_column` (существующие виджеты сдвигаются, а не перезаписываются).

- `grid` — контейнер-сетка.
- `sibling` — виджет-ориентир, уже находящийся в сетке.
- `side` — с какой стороны от `sibling` вставить новую строку/столбец (`GTK_POS_TOP`/`_BOTTOM` — вставляют строку, `GTK_POS_LEFT`/`_RIGHT` — столбец).

```nim
gtk_grid_insert_next_to(formGrid, emailLabel, GTK_POS_BOTTOM)
echo "Новая пустая строка вставлена сразу под строкой Email"
```

---

### `gtk_grid_query_child`

```nim
proc gtk_grid_query_child*(grid: GtkGrid, child: GtkWidget, column: ptr gint, row: ptr gint, width: ptr gint, height: ptr gint)
```

**Что делает.** Обратная операция к `gtk_grid_attach`: по уже размещённому в сетке виджету возвращает его текущие координаты и размер в ячейках. Полезно, когда позиция виджета в сетке не хранится отдельно в логике приложения, а нужно узнать её "по факту" — например, при обработке события, где известен только сам виджет.

- `grid` — контейнер-сетка.
- `child` — виджет, чьи координаты нужно узнать.
- `column`, `row`, `width`, `height` — указатели, в которые будут записаны результаты.

```nim
var col, row, w, h: gint
gtk_grid_query_child(formGrid, emailEntry, addr col, addr row, addr w, addr h)
echo "Поле email находится в столбце ", col, ", строке ", row
```

---

### `gtk_grid_set_baseline_row` / `gtk_grid_get_baseline_row` / `gtk_grid_set_row_baseline_position` / `gtk_grid_get_row_baseline_position`

```nim
proc gtk_grid_set_baseline_row*(grid: GtkGrid, row: gint)
proc gtk_grid_get_baseline_row*(grid: GtkGrid): gint
proc gtk_grid_set_row_baseline_position*(grid: GtkGrid, row: gint, pos: GtkBaselinePosition)
proc gtk_grid_get_row_baseline_position*(grid: GtkGrid, row: gint): GtkBaselinePosition
```

**Что делает.** Аналог выравнивания по базовой линии из `GtkBox` (см. `gtk_box_set_baseline_position`), но применительно к сетке: `baseline_row` задаёт, какая строка сетки в целом считается опорной по вертикали, а `row_baseline_position` — позицию базовой линии **внутри конкретной строки** (по умолчанию каждая строка выравнивается независимо). Как и для `GtkBox`, это тонкая типографская настройка, нужная только когда в соседних ячейках одной строки текст разного размера шрифта и важно визуальное выравнивание "по низу букв".

- `grid` — контейнер-сетка.
- `row` — индекс строки.
- `pos` — значение `GtkBaselinePosition`.

```nim
gtk_grid_set_row_baseline_position(formGrid, 0, GTK_BASELINE_POSITION_CENTER)
echo "Базовая линия строки 0 выровнена по центру"
```

---

## Практические рецепты

### Минимальное окно с кнопкой ("Hello, GTK4")

Полный жизненный цикл приложения — от создания `GtkApplication` до показа окна с одной кнопкой, меняющей текст на себе по клику.

```nim
import libGTK4

proc onButtonClicked(button: GtkButton, userData: gpointer) {.cdecl.} =
  gtk_button_set_label(button, "Нажали!")
  echo "Кнопка нажата"

proc onActivate(app: GtkApplication, userData: gpointer) {.cdecl.} =
  let window = gtk_application_window_new(app)
  gtk_window_set_title(window, "Hello, GTK4")
  gtk_window_set_default_size(window, 320, 200)

  let button = gtk_button_new_with_label("Нажми меня")
  gtk_widget_set_halign(button, GTK_ALIGN_CENTER)
  gtk_widget_set_valign(button, GTK_ALIGN_CENTER)
  discard g_signal_connect(button, "clicked", onButtonClicked, nil)

  gtk_window_set_child(window, button)
  gtk_window_present(window)

let app = gtk_application_new("org.example.HelloApp", 0)
discard g_signal_connect(app, "activate", onActivate, nil)
let exitCode = g_application_run(app, 0, nil)
echo "Приложение завершилось с кодом ", exitCode
```

---

### Форма из подписанных полей на GtkGrid

Типичная форма "подпись слева — поле справа" в несколько строк с растягивающимися полями ввода.

```nim
proc buildForm(): GtkGrid =
  result = gtk_grid_new()
  gtk_grid_set_row_spacing(result, 8)
  gtk_grid_set_column_spacing(result, 12)
  gtk_widget_set_margin_start(result, 16)
  gtk_widget_set_margin_end(result, 16)
  gtk_widget_set_margin_top(result, 16)
  gtk_widget_set_margin_bottom(result, 16)

  let nameLabel = gtk_label_new("Имя:")
  gtk_widget_set_halign(nameLabel, GTK_ALIGN_END)
  let nameEntry = gtk_entry_new()
  gtk_widget_set_hexpand(nameEntry, 1.gboolean)
  gtk_grid_attach(result, nameLabel, 0, 0, 1, 1)
  gtk_grid_attach(result, nameEntry, 1, 0, 1, 1)

  let emailLabel = gtk_label_new("Email:")
  gtk_widget_set_halign(emailLabel, GTK_ALIGN_END)
  let emailEntry = gtk_entry_new()
  gtk_widget_set_hexpand(emailEntry, 1.gboolean)
  gtk_grid_attach_next_to(result, emailLabel, nameLabel, GTK_POS_BOTTOM, 1, 1)
  gtk_grid_attach_next_to(result, emailEntry, emailLabel, GTK_POS_RIGHT, 1, 1)

  echo "Форма с двумя растягивающимися полями собрана"

let form = buildForm()
```

---

### Панель инструментов на GtkBox с растягивающимся разделителем

Классический паттерн "кнопки слева — кнопка справа" на одном горизонтальном `GtkBox`: между группами вставляется пустой виджет с `hexpand`, который забирает всё свободное место.

```nim
proc buildToolbar(): GtkBox =
  result = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 6)
  gtk_widget_set_margin_start(result, 8)
  gtk_widget_set_margin_end(result, 8)
  gtk_widget_set_margin_top(result, 8)
  gtk_widget_set_margin_bottom(result, 8)

  let openButton = gtk_button_new_with_label("Открыть")
  let saveButton = gtk_button_new_with_label("Сохранить")
  gtk_box_append(result, openButton)
  gtk_box_append(result, saveButton)

  # "Пружина" — пустой виджет-контейнер без содержимого, забирающий всё свободное место
  let spacer = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 0)
  gtk_widget_set_hexpand(spacer, 1.gboolean)
  gtk_box_append(result, spacer)

  let settingsButton = gtk_button_new_with_label("Настройки")
  gtk_widget_add_css_class(settingsButton, "flat")
  gtk_box_append(result, settingsButton)

  echo "Панель инструментов собрана: [Открыть] [Сохранить] ... [Настройки]"

let toolbar = buildToolbar()
```

---

### Диалог подтверждения закрытия окна

Перехват попытки закрытия окна через `"close-request"`, чтобы показать диалог, если есть несохранённые изменения (в этом рецепте состояние "изменено" моделируется простой переменной).

```nim
var hasUnsavedChanges = true

proc onCloseRequest(win: GtkWindow, userData: gpointer): gboolean {.cdecl.} =
  if hasUnsavedChanges:
    echo "Есть несохранённые изменения — показываем диалог подтверждения"
    let confirmDialog = gtk_window_new()
    gtk_window_set_transient_for(confirmDialog, win)
    gtk_window_set_modal(confirmDialog, 1.gboolean)
    gtk_window_set_resizable(confirmDialog, 0.gboolean)
    gtk_window_set_title(confirmDialog, "Закрыть без сохранения?")
    gtk_window_present(confirmDialog)
    result = 1.gboolean  # 1 — отменить закрытие исходного окна, решение за диалогом
  else:
    result = 0.gboolean  # 0 — несохранённых данных нет, закрываем сразу

discard g_signal_connect(mainWindow, "close-request", onCloseRequest, nil)
```

---

### Обход дерева виджетов через `get_first_child`/`get_next_sibling`

Рекурсивный обход всего поддерева виджетов начиная с произвольного контейнера — например, для отладочной печати структуры интерфейса или для поиска всех виджетов определённого CSS-класса.

```nim
import strutils  # для repeat() — обёртка не реэкспортирует strutils автоматически

proc printWidgetTree(widget: GtkWidget, depth: int = 0) =
  echo repeat("  ", depth), "виджет на глубине ", depth
  var child = gtk_widget_get_first_child(widget)
  while not isNil(child):
    printWidgetTree(child, depth + 1)
    child = gtk_widget_get_next_sibling(child)

printWidgetTree(rootContainer)
# выводит дерево вида:
# виджет на глубине 0
#   виджет на глубине 1
#   виджет на глубине 1
#     виджет на глубине 2
```

---

## Краткая таблица

| Процедура(ы) | Категория | Что делает вкратце |
|---|---|---|
| `gtk_init`, `gtk_init_check` | Инициализация | Ручная инициализация GTK без `GtkApplication` |
| `gtk_is_initialized` | Инициализация | Была ли GTK уже инициализирована |
| `gtk_get_major/minor/micro_version` | Инициализация | Версия GTK, с которой слинковано приложение |
| `gtk_check_version` | Инициализация | Проверка минимально требуемой версии |
| `gtk_get_binary_age`, `gtk_get_interface_age` | Инициализация | Счётчики ABI-совместимости (для сборки пакетов) |
| `gtk_get_locale_direction` | Инициализация | LTR/RTL направление письма по локали |
| `gtk_get_default_language` | Инициализация | Язык по умолчанию для Pango |
| `gtk_disable_setlocale` | Инициализация | Запретить GTK трогать локаль процесса |
| `gtk_set/get_debug_flags` | Инициализация | Отладочные флаги GTK (аналог `GTK_DEBUG`) |
| `gtk_application_new` | Приложение | Создать `GtkApplication` |
| `g_application_run` | Приложение | Запустить главный цикл (блокирует до завершения) |
| `gtk_application_window_new` | Приложение | Создать окно, привязанное к приложению |
| `gtk_application_add/remove_window` | Приложение | Вручную (от)регистрировать окно в приложении |
| `gtk_application_get_windows`, `get_active_window` | Приложение | Список окон / активное окно |
| `gtk_application_get_window_by_id` | Приложение | Найти окно по числовому id |
| `gtk_application_set/get_menubar` | Приложение | Меню приложения верхнего уровня |
| `gtk_application_get_menu_by_id` | Приложение | Найти подменю по id из разметки Builder |
| `gtk_application_set/get_accels_for_action` | Приложение | Горячие клавиши для действия |
| `gtk_application_list_action_descriptions` | Приложение | Список действий с назначенными акселераторами |
| `gtk_application_inhibit/uninhibit` | Приложение | Запретить сон/выход из сессии на время операции |
| `g_application_activate` | Приложение | Вручную эмитировать `"activate"` |
| `g_application_quit` | Приложение | Принудительно завершить главный цикл |
| `g_application_hold/release` | Приложение | Не дать циклу завершиться без открытых окон |
| `g_application_register` | Приложение | Зарегистрировать в D-Bus вручную |
| `g_application_get_is_registered/is_remote` | Приложение | Зарегистрировано ли / это повторный запуск? |
| `g_application_get/set_application_id` | Приложение | Идентификатор приложения (до регистрации) |
| `g_application_get/set_flags` | Приложение | Флаги `GApplicationFlags` (до регистрации) |
| `g_application_get/set_inactivity_timeout` | Приложение | Тайм-аут автозавершения службы |
| `g_application_open` | Приложение | Эмитировать `"open"` со списком файлов |
| `g_application_mark/unmark_busy`, `get_is_busy` | Приложение | Курсор ожидания поверх окон приложения |
| `g_application_send/withdraw_notification` | Приложение | Системные уведомления |
| `g_application_set/get_resource_base_path` | Приложение | Базовый путь GResource |
| `gtk_window_new` | Окно | Создать голое окно без приложения |
| `gtk_window_set/get_title` | Окно | Заголовок окна |
| `gtk_window_set/get_default_size` | Окно | Размер при первом показе |
| `gtk_window_set/get_resizable` | Окно | Можно ли менять размер вручную |
| `gtk_window_set/get_modal` | Окно | Модальность относительно родителя |
| `gtk_window_set/get_decorated` | Окно | Стандартная рамка окна |
| `gtk_window_set/get_deletable` | Окно | Кнопка закрытия в заголовке |
| `gtk_window_set/get_transient_for` | Окно | Родительское окно |
| `gtk_window_set/get_child` | Окно | Единственный дочерний виджет-содержимое |
| `gtk_window_set/get_titlebar` | Окно | Пользовательская заголовочная панель |
| `gtk_window_close` | Окно | Штатное закрытие через `"close-request"` |
| `gtk_window_destroy` | Окно | Немедленное уничтожение без запроса подтверждения |
| `gtk_window_present` | Окно | Показать и вывести на передний план |
| `gtk_window_fullscreen/unfullscreen/is_fullscreen` | Окно | Полноэкранный режим |
| `gtk_window_maximize/unmaximize` | Окно | Развернуть на весь экран (с рамкой) |
| `gtk_window_minimize/unminimize` | Окно | Свернуть в панель задач |
| `gtk_window_set_icon_name`, `set_default_icon_name` | Окно | Иконка окна / всех окон приложения |
| `gtk_widget_show/hide`, `set/get_visible` | Виджет | Видимость виджета |
| `gtk_widget_set/get_sensitive` | Виджет | Доступность для взаимодействия |
| `gtk_widget_set/get_can_focus`, `grab_focus` | Виджет | Способность и захват клавиатурного фокуса |
| `gtk_widget_set/get_size_request` | Виджет | Минимальный размер виджета |
| `gtk_widget_set/get_hexpand`, `set/get_vexpand` | Виджет | Растягивание в контейнере |
| `gtk_widget_set/get_halign`, `set/get_valign` | Виджет | Выравнивание внутри выделенного места |
| `gtk_widget_set/get_margin_start/end/top/bottom` | Виджет | Внешние отступы с каждой стороны |
| `gtk_widget_set/get_tooltip_text/markup` | Виджет | Всплывающая подсказка |
| `gtk_widget_set/get_name` | Виджет | Имя для CSS-селектора `#имя` |
| `gtk_widget_add/remove/has_css_class` | Виджет | CSS-классы виджета |
| `gtk_widget_get_parent/first_child/last_child/next_sibling/prev_sibling` | Виджет | Навигация по дереву виджетов |
| `gtk_box_new` | Box | Создать линейный контейнер |
| `gtk_box_append/prepend/remove` | Box | Добавить/убрать дочерний виджет |
| `gtk_box_insert_child_after/reorder_child_after` | Box | Вставка/перемещение относительно соседа |
| `gtk_box_set/get_spacing` | Box | Промежуток между детьми |
| `gtk_box_set/get_homogeneous` | Box | Одинаковый размер всех детей |
| `gtk_box_set/get_baseline_position`, `set/get_baseline_child` | Box | Выравнивание по базовой линии текста |
| `gtk_grid_new` | Grid | Создать табличный контейнер |
| `gtk_grid_attach`, `attach_next_to` | Grid | Разместить виджет по координатам/рядом с соседом |
| `gtk_grid_remove`, `get_child_at` | Grid | Убрать виджет / найти виджет в ячейке |
| `gtk_grid_set/get_row_spacing`, `set/get_column_spacing` | Grid | Промежутки между строками/столбцами |
| `gtk_grid_set/get_row_homogeneous`, `set/get_column_homogeneous` | Grid | Одинаковый размер строк/столбцов |
| `gtk_grid_insert/remove_row`, `insert/remove_column` | Grid | Динамическая вставка/удаление строк и столбцов |
| `gtk_grid_insert_next_to` | Grid | Вставка строки/столбца рядом с виджетом |
| `gtk_grid_query_child` | Grid | Координаты и размер виджета в сетке |
| `gtk_grid_set/get_baseline_row`, `set/get_row_baseline_position` | Grid | Выравнивание по базовой линии в сетке |

---

## Сводка: какую процедуру выбрать

- **Нужно первым делом создать приложение** → `gtk_application_new`, затем `g_signal_connect(app, "activate", ...)`, затем `g_application_run` — а не `gtk_init` напрямую (последнее — только для сценариев без `GtkApplication`).
- **Нужно создать главное окно** → `gtk_application_window_new`, а не голый `gtk_window_new` — так окно сразу интегрировано с меню и действиями приложения. `gtk_window_new` — для вспомогательных окон и сценариев без `GtkApplication`.
- **Нужно, чтобы окно при первом показе не сжалось в точку** → обязательно вызвать `gtk_window_set_default_size`.
- **Нужно показать/поднять окно** → `gtk_window_present`, а не унаследованный от `GtkWidget` `gtk_widget_show` — `present` гарантированно даёт окну фокус и поднимает его на передний план.
- **Нужно поместить в окно несколько элементов** → сначала оборачиваем их в `GtkBox`/`GtkGrid`, и уже этот контейнер передаём в `gtk_window_set_child` — окно принимает только один дочерний виджет.
- **Выбор между `GtkBox` и `GtkGrid`** → если элементы идут строго в один ряд/столбец — `GtkBox`; если нужна настоящая раскладка по строкам и столбцам (в частности, форма "подпись — поле") — `GtkGrid`.
- **Виджет не растягивается, хотя место есть** → почти всегда не хватает `gtk_widget_set_hexpand`/`set_vexpand` — одного `halign = GTK_ALIGN_FILL` недостаточно, `expand` определяет, сколько места контейнер вообще выделит виджету.
- **Нужно отреагировать на попытку пользователя закрыть окно** (например, спросить про несохранённые изменения) → подключаться к сигналу `"close-request"`, а не пытаться перехватывать вызов `gtk_window_close`/`gtk_window_destroy`.
- **Нужно временно заблокировать элемент интерфейса, но не прятать его** → `gtk_widget_set_sensitive(widget, 0.gboolean)`, а не `gtk_widget_hide` — виджет остаётся на месте, но не реагирует на ввод.
- **Нужно стилизовать виджет** → предпочитать встроенные CSS-классы (`gtk_widget_add_css_class`, например `"destructive-action"`/`"suggested-action"`) вместо ручной покраски — так вид остаётся согласован с системной темой. `gtk_widget_set_name` — только когда нужен уникальный CSS-селектор для конкретного экземпляра.
- **Нужно обойти все дочерние виджеты контейнера без привязки к конкретному типу контейнера** → универсальная пара `gtk_widget_get_first_child`/`gtk_widget_get_next_sibling`, работает одинаково для `GtkBox`, `GtkGrid` и любого другого контейнера.
- **Нужно временно не дать компьютеру уйти в сон** (например, во время долгой операции) → `gtk_application_inhibit`/`gtk_application_uninhibit`, а не `g_application_hold`/`release` — `hold`/`release` управляют только жизненным циклом главного цикла приложения, а не поведением ОС.
