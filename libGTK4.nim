
################################################################
##             ПОЛНАЯ ОБЁРТКА GTK4 для Nim
##      Full-featured wrapper for the GTK4 library
## 
##          Прямые привязки к C API через FFI
## 
## 
## Версия:   1.2
## Дата:     2026-02-15
## Автор:    Balans097 — vasil.minsk@yahoo.com
################################################################


# 1.2 — дополнение библиотеки расширенными функциями (2026-02-15);
#       добавлено ~1780 дополнительных функций GTK4 API:
#       – Inspector API (gtk_inspector_*)
#       – Accessible API (gtk_accessible_*)
#       – Action API (gtk_action_*)
#       – Builder API (gtk_builder_*)
#       – Constraint API (gtk_constraint_*)
#       – вспомогательные функции Graph, Bitset, Roaring
#       – GSK (GskRenderNode, GskTransform и др.)
#       – GDK (события, дисплей, устройства)
# 1.1 — исправления критических проблем (2026-02-05):
#       – исправлен createListStore: использует gtk_list_store_newv вместо небезопасного varargs
#       – исправлены g_timeout_add/g_idle_add: теперь используют правильный тип GSourceFunc с user_data
#       – исправлен getClipboardText: использует GAsyncReadyCallback вместо некорректного callback
#       – исправлены gtk_text_view_get_rtl/ltr_context: возвращают PangoContext* вместо gboolean
#       – исправлен gtk_notebook_set_scrollable: принимает gboolean вместо bool
#       – исправлен GtkInscription: удалён несуществующий gtk_inscription_get_markup, 
#       – исправлены типы для get/set_wrap_mode (PangoWrapMode) и get/set_attributes (PangoAttrList*)
#       – добавлены guards GTK_DISABLE_DEPRECATED для устаревших GTK3 API (TreeView, ListStore, 
#         TreeStore, InfoBar, Statusbar, CellRenderer)
# 1.0 — начальная реализация библиотеки (2026-01-20)





import strutils




when defined(windows):
  # На Windows необходимо удалить символ новой строки из вывода pkg-config,
  # иначе линкер получает некорректные параметры командной строки.
  # Это делается так: pkg-config --libs gtk4 | tr -d '\n'
  {.passC: gorge("pkg-config --cflags gtk4").}
  {.passL: gorge("bash -c 'pkg-config --libs gtk4 | tr -d \"\\n\"'").}
else:
  {.passC: gorge("pkg-config --cflags gtk4").}
  {.passL: gorge("pkg-config --libs gtk4").}




# ============================================================================
# БАЗОВЫЕ ТИПЫ
# ============================================================================
type
  # GLib типы
  gboolean* = int32
  gint* = int32
  guint* = uint32
  gchar* = char
  guchar* = uint8
  gshort* = int16
  gushort* = uint16
  glong* = int
  gulong* = uint
  gint8* = int8
  guint8* = uint8
  gint16* = int16
  guint16* = uint16
  gint32* = int32
  guint32* = uint32
  gint64* = int64
  guint64* = uint64
  gfloat* = float32
  gdouble* = float64
  gsize* = uint
  gssize* = int
  goffset* = int64
  gpointer* = pointer
  gconstpointer* = pointer
  gunichar* = uint32

  # GTK основные типы
  GtkWidget* = pointer
  GtkWindow* = pointer
  GtkApplicationWindow* = pointer
  GtkDialog* = pointer
  GtkAboutDialog* = pointer
  GtkMessageDialog* = pointer
  GtkFileChooserDialog* = pointer
  GtkColorChooserDialog* = pointer
  GtkFontChooserDialog* = pointer
  GtkStackPage* = pointer

  # Контейнеры
  GtkBox* = pointer
  GtkGrid* = pointer
  GtkFixed* = pointer
  GtkPaned* = pointer
  GtkStack* = pointer
  GtkStackSwitcher* = pointer
  GtkNotebook* = pointer
  GtkExpander* = pointer
  GtkFrame* = pointer
  GtkAspectFrame* = pointer
  GtkOverlay* = pointer
  GtkScrolledWindow* = pointer
  GtkViewport* = pointer

  # Кнопки
  GtkButton* = pointer
  GtkToggleButton* = pointer
  GtkCheckButton* = pointer
  GtkRadioButton* = pointer
  GtkLinkButton* = pointer
  GtkMenuButton* = pointer
  GtkLockButton* = pointer
  GtkSwitch* = pointer
  GtkScaleButton* = pointer
  GtkVolumeButton* = pointer

  # Текстовые виджеты
  GtkLabel* = pointer
  GtkEntry* = pointer
  GtkPasswordEntry* = pointer
  GtkSearchEntry* = pointer
  GtkTextView* = pointer
  GtkTextBuffer* = pointer
  GtkTextMark* = pointer
  GtkTextTag* = pointer
  GtkTextTagTable* = pointer
  GtkTextChildAnchor* = pointer
  GtkTextIter* = object
    dummy1: pointer
    dummy2: pointer
    dummy3: gint
    dummy4: gint
    dummy5: gint
    dummy6: gint
    dummy7: gint
    dummy8: gint
    dummy9: pointer
    dummy10: pointer
    dummy11: gint
    dummy12: gint
    dummy13: gint
    dummy14: pointer

  # Выбор и списки
  GtkComboBox* = pointer
  GtkComboBoxText* = pointer
  GtkListBox* = pointer
  GtkListBoxRow* = pointer
  GtkFlowBox* = pointer
  GtkFlowBoxChild* = pointer
  GtkTreeView* = pointer
  GtkTreeModel* = pointer
  GtkTreeSelection* = pointer
  GtkTreeIter* = object
    stamp: gint
    userData: gpointer
    userData2: gpointer
    userData3: gpointer
  GtkTreePath* = pointer
  GtkListStore* = pointer
  GtkTreeStore* = pointer
  GtkCellRenderer* = pointer
  GtkCellRendererText* = pointer
  GtkCellRendererToggle* = pointer
  GtkCellRendererPixbuf* = pointer
  GtkTreeViewColumn* = pointer

  # Отображение
  GtkImage* = pointer
  GtkPicture* = pointer
  GtkSpinner* = pointer
  GtkProgressBar* = pointer
  GtkLevelBar* = pointer
  GtkStatusbar* = pointer
  GtkInfoBar* = pointer
  GtkSeparator* = pointer

  # Ввод чисел и диапазонов
  GtkSpinButton* = pointer
  GtkScale* = pointer
  GtkRange* = pointer
  GtkAdjustment* = pointer

  # Календарь и время
  GtkCalendar* = pointer

  # Меню и панели
  GtkMenuBar* = pointer
  GtkToolbar* = pointer
  GtkHeaderBar* = pointer
  GtkActionBar* = pointer
  GtkSearchBar* = pointer
  GtkPopover* = pointer
  GtkPopoverMenu* = pointer

  # Рисование
  GtkDrawingArea* = pointer
  GtkGLArea* = pointer

  # Разное
  GtkFileChooser* = pointer
  GtkColorChooser* = pointer
  GtkFontChooser* = pointer
  GtkRecentChooser* = pointer
  GtkAppChooser* = pointer

  # GIO типы
  GApplication* = pointer
  GtkApplication* = pointer
  GMenu* = pointer
  GMenuItem* = pointer
  GMenuModel* = pointer
  GSimpleAction* = pointer
  GAction* = pointer
  GActionMap* = pointer
  GFile* = pointer
  GBytes* = pointer

  # Cairo
  cairo_t* = pointer
  cairo_surface_t* = pointer

  # Pixbuf
  GdkDisplay* = pointer
  GdkPixbuf* = pointer
  GdkTexture* = pointer
  GdkPaintable* = pointer

  GdkRectangle* {.bycopy.} = object
    x*: gint
    y*: gint
    width*: gint
    height*: gint

  # Clipboard
  GdkClipboard* = pointer

  # Events
  GdkEvent* = pointer
  GdkEventType* = pointer

  # Стили и CSS
  GtkStyleContext* = pointer
  GtkCssProvider* = pointer
  GtkStyleProvider* = pointer

  # Прочие GObject типы
  GObject* = pointer
  GType* = uint
  GValue* = pointer
  GVariant* = pointer
  GVariantType* = pointer
  GError* = pointer
  GActionGroup* = pointer
  GSimpleActionGroup* = pointer
  GPropertyAction* = pointer

  # Callback типы
  GCallback* = pointer
  GDestroyNotify* = pointer
  GClosureNotify* = pointer
  GSourceFunc* = proc(userData: gpointer): gboolean {.cdecl.}
  GAsyncReadyCallback* = proc(sourceObject: pointer, res: pointer, userData: gpointer) {.cdecl.}

# ============================================================================
# ПЕРЕЧИСЛЕНИЯ (ENUMS)
# ============================================================================

type
  GtkOrientation* {.size: sizeof(cint).} = enum
    GTK_ORIENTATION_HORIZONTAL = 0
    GTK_ORIENTATION_VERTICAL = 1
  
  GtkAlign* {.size: sizeof(cint).} = enum
    GTK_ALIGN_FILL = 0
    GTK_ALIGN_START = 1
    GTK_ALIGN_END = 2
    GTK_ALIGN_CENTER = 3
    GTK_ALIGN_BASELINE = 4
  
  GtkJustification* {.size: sizeof(cint).} = enum
    GTK_JUSTIFY_LEFT = 0
    GTK_JUSTIFY_RIGHT = 1
    GTK_JUSTIFY_CENTER = 2
    GTK_JUSTIFY_FILL = 3
  
  GtkWrapMode* {.size: sizeof(cint).} = enum
    GTK_WRAP_NONE = 0
    GTK_WRAP_CHAR = 1
    GTK_WRAP_WORD = 2
    GTK_WRAP_WORD_CHAR = 3
  
  GtkPositionType* {.size: sizeof(cint).} = enum
    GTK_POS_LEFT = 0
    GTK_POS_RIGHT = 1
    GTK_POS_TOP = 2
    GTK_POS_BOTTOM = 3
  
  GtkBaselinePosition* {.size: sizeof(cint).} = enum
    GTK_BASELINE_POSITION_TOP = 0
    GTK_BASELINE_POSITION_CENTER = 1
    GTK_BASELINE_POSITION_BOTTOM = 2
  
  GtkMessageType* {.size: sizeof(cint).} = enum
    GTK_MESSAGE_INFO = 0
    GTK_MESSAGE_WARNING = 1
    GTK_MESSAGE_QUESTION = 2
    GTK_MESSAGE_ERROR = 3
    GTK_MESSAGE_OTHER = 4
  
  GtkButtonsType* {.size: sizeof(cint).} = enum
    GTK_BUTTONS_NONE = 0
    GTK_BUTTONS_OK = 1
    GTK_BUTTONS_CLOSE = 2
    GTK_BUTTONS_CANCEL = 3
    GTK_BUTTONS_YES_NO = 4
    GTK_BUTTONS_OK_CANCEL = 5
  
  GtkResponseType* {.size: sizeof(cint).} = enum
    GTK_RESPONSE_NONE = -1
    GTK_RESPONSE_REJECT = -2
    GTK_RESPONSE_ACCEPT = -3
    GTK_RESPONSE_DELETE_EVENT = -4
    GTK_RESPONSE_OK = -5
    GTK_RESPONSE_CANCEL = -6
    GTK_RESPONSE_CLOSE = -7
    GTK_RESPONSE_YES = -8
    GTK_RESPONSE_NO = -9
    GTK_RESPONSE_APPLY = -10
    GTK_RESPONSE_HELP = -11
  
  GtkSelectionMode* {.size: sizeof(cint).} = enum
    GTK_SELECTION_NONE = 0
    GTK_SELECTION_SINGLE = 1
    GTK_SELECTION_BROWSE = 2
    GTK_SELECTION_MULTIPLE = 3

  GtkFileChooserAction* {.size: sizeof(cint).} = enum
    GTK_FILE_CHOOSER_ACTION_OPEN = 0
    GTK_FILE_CHOOSER_ACTION_SAVE = 1
    GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER = 2

  GtkInputPurpose* {.size: sizeof(cint).} = enum
    GTK_INPUT_PURPOSE_FREE_FORM = 0
    GTK_INPUT_PURPOSE_ALPHA = 1
    GTK_INPUT_PURPOSE_DIGITS = 2
    GTK_INPUT_PURPOSE_NUMBER = 3
    GTK_INPUT_PURPOSE_PHONE = 4
    GTK_INPUT_PURPOSE_URL = 5
    GTK_INPUT_PURPOSE_EMAIL = 6
    GTK_INPUT_PURPOSE_NAME = 7
    GTK_INPUT_PURPOSE_PASSWORD = 8
    GTK_INPUT_PURPOSE_PIN = 9
    GTK_INPUT_PURPOSE_TERMINAL = 10

  GtkPolicyType* {.size: sizeof(cint).} = enum
    GTK_POLICY_ALWAYS = 0
    GTK_POLICY_AUTOMATIC = 1
    GTK_POLICY_NEVER = 2
    GTK_POLICY_EXTERNAL = 3

  GtkArrowType* {.size: sizeof(cint).} = enum
    GTK_ARROW_UP
    GTK_ARROW_DOWN
    GTK_ARROW_LEFT
    GTK_ARROW_RIGHT
    GTK_ARROW_NONE

  # Дополнительные типы
  GQuark* = uint32
  GBindingFlags* {.size: sizeof(cint).} = enum
    G_BINDING_DEFAULT = 0
    G_BINDING_BIDIRECTIONAL = 1
    G_BINDING_SYNC_CREATE = 2
    G_BINDING_INVERT_BOOLEAN = 4
 
  # Типы для направления текста
  GtkTextDirection* {.size: sizeof(cint).} = enum
    GTK_TEXT_DIR_NONE
    GTK_TEXT_DIR_LTR  # left to right
    GTK_TEXT_DIR_RTL  # right to left

  GtkApplicationInhibitFlags* {.size: sizeof(cint).} = enum
    # Предотвратить выход из системы
    GTK_APPLICATION_INHIBIT_LOGOUT = 1 shl 0
    # Предотвратить переключение пользователя
    GTK_APPLICATION_INHIBIT_SWITCH = 1 shl 1
    # Предотвратить переход в спящий режим
    GTK_APPLICATION_INHIBIT_SUSPEND = 1 shl 2
    # Предотвратить автоматическую блокировку
    GTK_APPLICATION_INHIBIT_IDLE = 1 shl 3
  
  GtkTextWindowType* {.size: sizeof(cint).} = enum
    GTK_TEXT_WINDOW_WIDGET = 1
    GTK_TEXT_WINDOW_TEXT = 2
    GTK_TEXT_WINDOW_LEFT = 3
    GTK_TEXT_WINDOW_RIGHT = 4
    GTK_TEXT_WINDOW_TOP = 5
    GTK_TEXT_WINDOW_BOTTOM = 6

  # Типы GApplication
  GApplicationFlags* {.size: sizeof(cint).} = enum
    G_APPLICATION_FLAGS_NONE = 0
    G_APPLICATION_IS_SERVICE = 1 shl 0
    G_APPLICATION_IS_LAUNCHER = 1 shl 1
    G_APPLICATION_HANDLES_OPEN = 1 shl 2
    G_APPLICATION_HANDLES_COMMAND_LINE = 1 shl 3
    G_APPLICATION_SEND_ENVIRONMENT = 1 shl 4
    G_APPLICATION_NON_UNIQUE = 1 shl 5
    G_APPLICATION_CAN_OVERRIDE_APP_ID = 1 shl 6
    G_APPLICATION_ALLOW_REPLACEMENT = 1 shl 7
    G_APPLICATION_REPLACE = 1 shl 8

  GOptionFlags* {.size: sizeof(cint).} = enum
    G_OPTION_FLAG_NONE = 0
    G_OPTION_FLAG_HIDDEN = 1 shl 0
    G_OPTION_FLAG_IN_MAIN = 1 shl 1
    G_OPTION_FLAG_REVERSE = 1 shl 2
    G_OPTION_FLAG_NO_ARG = 1 shl 3
    G_OPTION_FLAG_FILENAME = 1 shl 4
    G_OPTION_FLAG_OPTIONAL_ARG = 1 shl 5
    G_OPTION_FLAG_NOALIAS = 1 shl 6

  GOptionArg* {.size: sizeof(cint).} = enum
    G_OPTION_ARG_NONE
    G_OPTION_ARG_STRING
    G_OPTION_ARG_INT
    G_OPTION_ARG_CALLBACK
    G_OPTION_ARG_FILENAME
    G_OPTION_ARG_STRING_ARRAY
    G_OPTION_ARG_FILENAME_ARRAY
    G_OPTION_ARG_DOUBLE
    G_OPTION_ARG_INT64

  GSignalMatchType* {.size: sizeof(cint).} = enum
    G_SIGNAL_MATCH_ID = 1 shl 0
    G_SIGNAL_MATCH_DETAIL = 1 shl 1
    G_SIGNAL_MATCH_CLOSURE = 1 shl 2
    G_SIGNAL_MATCH_FUNC = 1 shl 3
    G_SIGNAL_MATCH_DATA = 1 shl 4
    G_SIGNAL_MATCH_UNBLOCKED = 1 shl 5

  GSignalFlags* {.size: sizeof(cint).} = enum
    G_SIGNAL_RUN_FIRST = 1 shl 0
    G_SIGNAL_RUN_LAST = 1 shl 1
    G_SIGNAL_RUN_CLEANUP = 1 shl 2
    G_SIGNAL_NO_RECURSE = 1 shl 3
    G_SIGNAL_DETAILED = 1 shl 4
    G_SIGNAL_ACTION = 1 shl 5
    G_SIGNAL_NO_HOOKS = 1 shl 6
    G_SIGNAL_MUST_COLLECT = 1 shl 7
    G_SIGNAL_DEPRECATED = 1 shl 8
    G_SIGNAL_ACCUMULATOR_FIRST_RUN = 1 shl 17

  GSignalQuery* {.pure, final.} = object
    signalId*: cuint
    signalName*: cstring
    itype*: GType
    signalFlags*: GSignalFlags
    returnType*: GType
    nParams*: cuint
    paramTypes*: ptr GType

  GActionEntry* = object
      name*: cstring
      activate*: proc(action: GSimpleAction, parameter: GVariant, user_data: gpointer) {.cdecl.}
      parameter_type*: cstring
      state*: cstring
      change_state*: proc(action: GSimpleAction, value: GVariant, user_data: gpointer) {.cdecl.}

  # Pango типы для Label
  PangoWrapMode* {.size: sizeof(cint).} = enum
    PANGO_WRAP_WORD = 0
    PANGO_WRAP_CHAR = 1
    PANGO_WRAP_WORD_CHAR = 2

  PangoEllipsizeMode* {.size: sizeof(cint).} = enum
    PANGO_ELLIPSIZE_NONE = 0
    PANGO_ELLIPSIZE_START = 1
    PANGO_ELLIPSIZE_MIDDLE = 2
    PANGO_ELLIPSIZE_END = 3

  GtkNaturalWrapMode* {.size: sizeof(cint).} = enum
    GTK_NATURAL_WRAP_INHERIT = 0
    GTK_NATURAL_WRAP_NONE = 1
    GTK_NATURAL_WRAP_WORD = 2

  # Непрозрачные типы Pango (opaque pointers)
  PangoAttrList* = distinct pointer
  PangoLayout* = distinct pointer
  PangoTabArray* = distinct pointer
  PangoContext* = distinct pointer


  # Для виджета Entry
  GtkEntryBuffer* = distinct pointer
  GtkEntryCompletion* = distinct pointer
  GIcon* = distinct pointer
  
  GtkEntryIconPosition* {.size: sizeof(cint).} = enum
    GTK_ENTRY_ICON_PRIMARY = 0
    GTK_ENTRY_ICON_SECONDARY = 1
  
  GtkImageType* {.size: sizeof(cint).} = enum
    GTK_IMAGE_EMPTY = 0
    GTK_IMAGE_ICON_NAME = 1
    GTK_IMAGE_GICON = 2
    GTK_IMAGE_PAINTABLE = 3

  GtkInputHints* {.size: sizeof(cint).} = enum
    GTK_INPUT_HINT_NONE = 0
    GTK_INPUT_HINT_SPELLCHECK = 1
    GTK_INPUT_HINT_NO_SPELLCHECK = 2
    GTK_INPUT_HINT_WORD_COMPLETION = 4
    GTK_INPUT_HINT_LOWERCASE = 8
    GTK_INPUT_HINT_UPPERCASE_CHARS = 16
    GTK_INPUT_HINT_UPPERCASE_WORDS = 32
    GTK_INPUT_HINT_UPPERCASE_SENTENCES = 64
    GTK_INPUT_HINT_INHIBIT_OSK = 128
    GTK_INPUT_HINT_VERTICAL_WRITING = 256
    GTK_INPUT_HINT_EMOJI = 512
    GTK_INPUT_HINT_NO_EMOJI = 1024
    GTK_INPUT_HINT_PRIVATE = 2048

  GtkStackTransitionType* = enum
    GTK_STACK_TRANSITION_TYPE_NONE = 0
    GTK_STACK_TRANSITION_TYPE_CROSSFADE = 1
    GTK_STACK_TRANSITION_TYPE_SLIDE_RIGHT = 2
    GTK_STACK_TRANSITION_TYPE_SLIDE_LEFT = 3
    GTK_STACK_TRANSITION_TYPE_SLIDE_UP = 4
    GTK_STACK_TRANSITION_TYPE_SLIDE_DOWN = 5
    GTK_STACK_TRANSITION_TYPE_SLIDE_LEFT_RIGHT = 6
    GTK_STACK_TRANSITION_TYPE_SLIDE_UP_DOWN = 7
    GTK_STACK_TRANSITION_TYPE_OVER_UP = 8
    GTK_STACK_TRANSITION_TYPE_OVER_DOWN = 9
    GTK_STACK_TRANSITION_TYPE_OVER_LEFT = 10
    GTK_STACK_TRANSITION_TYPE_OVER_RIGHT = 11
    GTK_STACK_TRANSITION_TYPE_UNDER_UP = 12
    GTK_STACK_TRANSITION_TYPE_UNDER_DOWN = 13
    GTK_STACK_TRANSITION_TYPE_UNDER_LEFT = 14
    GTK_STACK_TRANSITION_TYPE_UNDER_RIGHT = 15
    GTK_STACK_TRANSITION_TYPE_OVER_UP_DOWN = 16
    GTK_STACK_TRANSITION_TYPE_OVER_DOWN_UP = 17
    GTK_STACK_TRANSITION_TYPE_OVER_LEFT_RIGHT = 18
    GTK_STACK_TRANSITION_TYPE_OVER_RIGHT_LEFT = 19






# ============================================================================
# КОНСТАНТЫ
# ============================================================================

const
  G_TYPE_INVALID* = 0 shl 2
  G_TYPE_NONE* = 1 shl 2
  G_TYPE_INTERFACE* = 2 shl 2
  G_TYPE_CHAR* = 3 shl 2
  G_TYPE_UCHAR* = 4 shl 2
  G_TYPE_BOOLEAN* = 5 shl 2
  G_TYPE_INT* = 6 shl 2
  G_TYPE_UINT* = 7 shl 2
  G_TYPE_LONG* = 8 shl 2
  G_TYPE_ULONG* = 9 shl 2
  G_TYPE_INT64* = 10 shl 2
  G_TYPE_UINT64* = 11 shl 2
  G_TYPE_ENUM* = 12 shl 2
  G_TYPE_FLAGS* = 13 shl 2
  G_TYPE_FLOAT* = 14 shl 2
  G_TYPE_DOUBLE* = 15 shl 2
  G_TYPE_STRING* = 16 shl 2
  G_TYPE_POINTER* = 17 shl 2
  G_TYPE_BOXED* = 18 shl 2
  G_TYPE_PARAM* = 19 shl 2
  G_TYPE_OBJECT* = 20 shl 2
  G_TYPE_VARIANT* = 21 shl 2

  G_APPLICATION_DEFAULT_FLAGS* = 0

  GTK_WINDOW_TOPLEVEL* = 0
  GTK_WINDOW_POPUP* = 1

  FALSE* = 0
  TRUE* = 1

  GTK_STYLE_PROVIDER_PRIORITY_FALLBACK* = 1
  GTK_STYLE_PROVIDER_PRIORITY_THEME* = 200
  GTK_STYLE_PROVIDER_PRIORITY_SETTINGS* = 400
  GTK_STYLE_PROVIDER_PRIORITY_APPLICATION* = 600
  GTK_STYLE_PROVIDER_PRIORITY_USER* = 800

# Флаги отладки
  GTK_DEBUG_TEXT* = 1 shl 0
  GTK_DEBUG_TREE* = 1 shl 1
  GTK_DEBUG_KEYBINDINGS* = 1 shl 2
  GTK_DEBUG_MODULES* = 1 shl 3
  GTK_DEBUG_GEOMETRY* = 1 shl 4
  GTK_DEBUG_ICONTHEME* = 1 shl 5
  GTK_DEBUG_PRINTING* = 1 shl 6
  GTK_DEBUG_BUILDER* = 1 shl 7
  GTK_DEBUG_SIZE_REQUEST* = 1 shl 8
  GTK_DEBUG_NO_CSS_CACHE* = 1 shl 9
  GTK_DEBUG_INTERACTIVE* = 1 shl 10
  GTK_DEBUG_TOUCHSCREEN* = 1 shl 11
  GTK_DEBUG_ACTIONS* = 1 shl 12
  GTK_DEBUG_LAYOUT* = 1 shl 13
  GTK_DEBUG_SNAPSHOT* = 1 shl 14
  GTK_DEBUG_CONSTRAINTS* = 1 shl 15
  GTK_DEBUG_BUILDER_OBJECTS* = 1 shl 16
  GTK_DEBUG_A11Y* = 1 shl 17
  GTK_DEBUG_ICONFALLBACK* = 1 shl 18






# ============================================================================
# GTK INITIALIZATION
# ============================================================================
proc gtk_init*() {.importc.}
proc gtk_init_check*(): gboolean {.importc.}

# Проверка версии GTK
proc gtk_get_major_version*(): cuint {.importc.}
proc gtk_get_minor_version*(): cuint {.importc.}
proc gtk_get_micro_version*(): cuint {.importc.}
proc gtk_get_binary_age*(): cuint {.importc.}
proc gtk_get_interface_age*(): cuint {.importc.}
proc gtk_check_version*(requiredMajor: cuint, requiredMinor: cuint, requiredMicro: cuint): cstring {.importc.}

# Информация о сборке
proc gtk_get_locale_direction*(): GtkTextDirection {.importc.}
proc gtk_get_default_language*(): pointer {.importc.}  # PangoLanguage

# Проверка возможностей дисплея
proc gtk_is_initialized*(): gboolean {.importc.}

# Отладка и диагностика
proc gtk_disable_setlocale*() {.importc.}
proc gtk_set_debug_flags*(flags: cuint) {.importc.}
proc gtk_get_debug_flags*(): cuint {.importc.}



# ============================================================================
# GTK APPLICATION
# ============================================================================
proc gtk_application_new*(applicationId: cstring, flags: gint): GtkApplication {.importc.}
proc gtk_application_window_new*(application: GtkApplication): GtkWindow {.importc.}
proc gtk_application_add_window*(application: GtkApplication, window: GtkWindow) {.importc.}
proc gtk_application_remove_window*(application: GtkApplication, window: GtkWindow) {.importc.}
proc gtk_application_get_windows*(application: GtkApplication): pointer {.importc.}
proc gtk_application_get_active_window*(application: GtkApplication): GtkWindow {.importc.}

# Управление меню приложения
proc gtk_application_set_menubar*(application: GtkApplication, menubar: GMenuModel) {.importc.}
proc gtk_application_get_menubar*(application: GtkApplication): GMenuModel {.importc.}

# Управление акселераторами (горячие клавиши)
proc gtk_application_set_accels_for_action*(application: GtkApplication, detailedActionName: cstring, accels: ptr cstring) {.importc.}
proc gtk_application_get_accels_for_action*(application: GtkApplication, detailedActionName: cstring): ptr cstring {.importc.}
proc gtk_application_list_action_descriptions*(application: GtkApplication): ptr cstring {.importc.}

# Получение окна по ID
proc gtk_application_get_window_by_id*(application: GtkApplication, id: cuint): GtkWindow {.importc.}

# Управление меню действий
proc gtk_application_get_menu_by_id*(application: GtkApplication, id: cstring): GMenu {.importc.}

# Управление режимом регистрации
proc gtk_application_prefers_app_menu*(application: GtkApplication): gboolean {.importc.}

# Ингибирование (предотвращение завершения/сна)
proc gtk_application_inhibit*(application: GtkApplication, window: GtkWindow, flags: GtkApplicationInhibitFlags, reason: cstring): cuint {.importc.}
proc gtk_application_uninhibit*(application: GtkApplication, cookie: cuint) {.importc.}
proc gtk_application_is_inhibited*(application: GtkApplication, flags: GtkApplicationInhibitFlags): gboolean {.importc.}






# ============================================================================
# G APPLICATION
# ============================================================================
proc g_application_run*(application: GApplication, argc: gint, argv: pointer): gint {.importc.}
proc g_application_quit*(application: GApplication) {.importc.}
proc g_application_hold*(application: GApplication) {.importc.}
proc g_application_release*(application: GApplication) {.importc.}

# Управление жизненным циклом
proc g_application_activate*(application: GApplication) {.importc.}
proc g_application_open*(application: GApplication, files: pointer, nFiles: gint, hint: cstring) {.importc.}
proc g_application_register*(application: GApplication, cancellable: pointer, error: pointer): gboolean {.importc.}
proc g_application_unregister*(application: GApplication) {.importc.}

# Получение информации
proc g_application_get_application_id*(application: GApplication): cstring {.importc.}
proc g_application_set_application_id*(application: GApplication, applicationId: cstring) {.importc.}
proc g_application_get_flags*(application: GApplication): GApplicationFlags {.importc.}
proc g_application_set_flags*(application: GApplication, flags: GApplicationFlags) {.importc.}
proc g_application_get_inactivity_timeout*(application: GApplication): cuint {.importc.}
proc g_application_set_inactivity_timeout*(application: GApplication, inactivityTimeout: cuint) {.importc.}
proc g_application_get_is_registered*(application: GApplication): gboolean {.importc.}
proc g_application_get_is_remote*(application: GApplication): gboolean {.importc.}

# Управление действиями (Actions)
proc g_application_add_action*(application: GApplication, action: pointer) {.importc.}  # GAction
proc g_application_remove_action*(application: GApplication, actionName: cstring) {.importc.}
proc g_application_lookup_action*(application: GApplication, actionName: cstring): pointer {.importc.}  # GAction

# Управление опциями командной строки
proc g_application_add_main_option_entries*(application: GApplication, entries: pointer) {.importc.}  # GOptionEntry[]
proc g_application_add_main_option*(application: GApplication, longName: cstring, shortName: char, flags: GOptionFlags, arg: GOptionArg, description: cstring, argDescription: cstring) {.importc.}
proc g_application_add_option_group*(application: GApplication, group: pointer) {.importc.}  # GOptionGroup
proc g_application_set_option_context_parameter_string*(application: GApplication, parameterString: cstring) {.importc.}
proc g_application_set_option_context_summary*(application: GApplication, summary: cstring) {.importc.}
proc g_application_set_option_context_description*(application: GApplication, description: cstring) {.importc.}

# Управление ресурсами
proc g_application_set_resource_base_path*(application: GApplication, resourcePath: cstring) {.importc.}
proc g_application_get_resource_base_path*(application: GApplication): cstring {.importc.}

# D-Bus (для Linux)
proc g_application_get_dbus_connection*(application: GApplication): pointer {.importc.}  # GDBusConnection
proc g_application_get_dbus_object_path*(application: GApplication): cstring {.importc.}

# Отправка уведомлений
proc g_application_send_notification*(application: GApplication, id: cstring, notification: pointer) {.importc.}  # GNotification
proc g_application_withdraw_notification*(application: GApplication, id: cstring) {.importc.}

# Привязка к busy state
proc g_application_mark_busy*(application: GApplication) {.importc.}
proc g_application_unmark_busy*(application: GApplication) {.importc.}
proc g_application_get_is_busy*(application: GApplication): gboolean {.importc.}




# ============================================================================
# SIGNALS
# ============================================================================
proc g_signal_connect_data*(instance: gpointer, detailedSignal: cstring, 
                            cHandler: GCallback, data: gpointer,
                            destroyData: GClosureNotify, connectFlags: gint): gulong {.importc.}

template g_signal_connect*(instance, signal, callback, data: untyped): untyped =
  g_signal_connect_data(instance, signal, cast[GCallback](callback), data, nil, 0)

proc g_signal_handler_disconnect*(instance: gpointer, handlerId: gulong) {.importc.}
proc g_signal_handler_block*(instance: gpointer, handlerId: gulong) {.importc.}
proc g_signal_handler_unblock*(instance: gpointer, handlerId: gulong) {.importc.}
proc g_signal_emit_by_name*(instance: gpointer, detailedSignal: cstring) {.importc, varargs.}

# Проверка и поиск обработчиков
proc g_signal_handler_find*(instance: gpointer, mask: GSignalMatchType, signalId: cuint, 
                            detail: GQuark, closure: pointer, `func`: gpointer, 
                            data: gpointer): gulong {.importc.}
proc g_signal_handler_is_connected*(instance: gpointer, handlerId: gulong): gboolean {.importc.}
proc g_signal_handlers_block_matched*(instance: gpointer, mask: GSignalMatchType, 
                                      signalId: cuint, detail: GQuark, closure: pointer,
                                      `func`: gpointer, data: gpointer): cuint {.importc.}
proc g_signal_handlers_unblock_matched*(instance: gpointer, mask: GSignalMatchType,
                                        signalId: cuint, detail: GQuark, closure: pointer,
                                        `func`: gpointer, data: gpointer): cuint {.importc.}
proc g_signal_handlers_disconnect_matched*(instance: gpointer, mask: GSignalMatchType,
                                           signalId: cuint, detail: GQuark, closure: pointer,
                                           `func`: gpointer, data: gpointer): cuint {.importc.}

# Блокировка по callback
proc g_signal_handlers_block_by_func*(instance: gpointer, `func`: gpointer, data: gpointer) {.importc.}
proc g_signal_handlers_unblock_by_func*(instance: gpointer, `func`: gpointer, data: gpointer) {.importc.}
proc g_signal_handlers_disconnect_by_func*(instance: gpointer, `func`: gpointer, data: gpointer) {.importc.}
proc g_signal_handlers_disconnect_by_data*(instance: gpointer, data: gpointer) {.importc.}

# Информация о сигналах
proc g_signal_lookup*(name: cstring, itype: GType): cuint {.importc.}
proc g_signal_name*(signalId: cuint): cstring {.importc.}
proc g_signal_list_ids*(itype: GType, nIds: ptr cuint): ptr cuint {.importc.}
proc g_signal_query*(signalId: cuint, query: ptr GSignalQuery) {.importc.}

# Эмиссия сигналов
proc g_signal_emit*(instance: gpointer, signalId: cuint, detail: GQuark) {.importc, varargs.}
proc g_signal_emitv*(instanceAndParams: pointer, signalId: cuint, detail: GQuark, 
                     returnValue: pointer) {.importc.}

# Управление эмиссией
proc g_signal_stop_emission*(instance: gpointer, signalId: cuint, detail: GQuark) {.importc.}
proc g_signal_stop_emission_by_name*(instance: gpointer, detailedSignal: cstring) {.importc.}

# Проверка возможности эмиссии
proc g_signal_has_handler_pending*(instance: gpointer, signalId: cuint, detail: GQuark, 
                                   mayBeBlocked: gboolean): gboolean {.importc.}

# Аккумуляторы и преобразователи (для создания своих сигналов)
proc g_signal_new*(signalName: cstring, itype: GType, signalFlags: GSignalFlags,
                   classOffset: cuint, accumulator: pointer, accuData: gpointer,
                   cMarshaller: pointer, returnType: GType, nParams: cuint): cuint {.importc, varargs.}
proc g_signal_newv*(signalName: cstring, itype: GType, signalFlags: GSignalFlags,
                    classClosure: pointer, accumulator: pointer, accuData: gpointer,
                    cMarshaller: pointer, returnType: GType, nParams: cuint,
                    paramTypes: ptr GType): cuint {.importc.}

# Переопределение обработчиков класса
proc g_signal_override_class_handler*(signalName: cstring, instanceType: GType, 
                                      classHandler: GCallback) {.importc.}
proc g_signal_chain_from_overridden*(instanceAndParams: pointer, returnValue: pointer) {.importc.}

# Добавление emission hooks
proc g_signal_add_emission_hook*(signalId: cuint, detail: GQuark, hookFunc: pointer,
                                 hookData: gpointer, dataDestroy: pointer): gulong {.importc.}
proc g_signal_remove_emission_hook*(signalId: cuint, hookId: gulong) {.importc.}







# ============================================================================
# ACTIONS
# ============================================================================
proc g_simple_action_new*(name: cstring, parameterType: GVariantType): GSimpleAction {.importc.}
proc g_simple_action_new_stateful*(name: cstring, parameterType: GVariantType, state: GVariant): GSimpleAction {.importc.}
proc g_simple_action_set_enabled*(simple: GSimpleAction, enabled: gboolean) {.importc.}
proc g_simple_action_set_state*(simple: GSimpleAction, value: GVariant) {.importc.}

proc g_action_map_add_action*(actionMap: GActionMap, action: GAction) {.importc.}
proc g_action_map_remove_action*(actionMap: GActionMap, actionName: cstring) {.importc.}
proc g_action_map_lookup_action*(actionMap: GActionMap, actionName: cstring): GAction {.importc.}

# Массовое добавление действий
proc g_action_map_add_action_entries*(
  action_map: GActionMap,
  entries: ptr GActionEntry,
  n_entries: gint,
  user_data: gpointer) {.importc.}

# Получение информации о действии
proc g_action_get_name*(action: GAction): cstring {.importc.}
proc g_action_get_parameter_type*(action: GAction): GVariantType {.importc.}
proc g_action_get_state_type*(action: GAction): GVariantType {.importc.}
proc g_action_get_state*(action: GAction): GVariant {.importc.}
proc g_action_get_state_hint*(action: GAction): GVariant {.importc.}
proc g_action_get_enabled*(action: GAction): gboolean {.importc.}

# Активация действия
proc g_action_activate*(action: GAction, parameter: GVariant) {.importc.}
proc g_action_change_state*(action: GAction, value: GVariant) {.importc.}

# Проверки
proc g_action_name_is_valid*(action_name: cstring): gboolean {.importc.}
proc g_property_action_new*(name: cstring, obj: gpointer, property_name: cstring): GPropertyAction {.importc.}

# Установка действий для виджетов
proc gtk_widget_insert_action_group*(widget: GtkWidget, name: cstring, group: GActionGroup) {.importc.}
proc gtk_widget_action_set_enabled*(widget: GtkWidget, action_name: cstring, enabled: gboolean) {.importc.}

proc g_action_group_list_actions*(action_group: GActionGroup): ptr cstring {.importc.}
proc g_action_group_query_action*(
  action_group: GActionGroup,
  action_name: cstring,
  enabled: ptr gboolean,
  parameter_type: ptr GVariantType,
  state_type: ptr GVariantType,
  state_hint: ptr GVariant,
  state: ptr GVariant
): gboolean {.importc.}

proc g_action_group_has_action*(action_group: GActionGroup, action_name: cstring): gboolean {.importc.}
proc g_action_group_get_action_enabled*(action_group: GActionGroup, action_name: cstring): gboolean {.importc.}
proc g_action_group_get_action_parameter_type*(action_group: GActionGroup, action_name: cstring): GVariantType {.importc.}
proc g_action_group_get_action_state_type*(action_group: GActionGroup, action_name: cstring): GVariantType {.importc.}
proc g_action_group_get_action_state_hint*(action_group: GActionGroup, action_name: cstring): GVariant {.importc.}
proc g_action_group_get_action_state*(action_group: GActionGroup, action_name: cstring): GVariant {.importc.}

proc g_action_group_change_action_state*(action_group: GActionGroup, action_name: cstring, value: GVariant) {.importc.}
proc g_action_group_activate_action*(action_group: GActionGroup, action_name: cstring, parameter: GVariant) {.importc.}

# Сигналы GActionGroup:
# "action-added" (action_name: cstring)
# "action-removed" (action_name: cstring)
# "action-enabled-changed" (action_name: cstring, enabled: gboolean)
# "action-state-changed" (action_name: cstring, state: GVariant)

proc gtk_actionable_set_action_name*(actionable: pointer; action_name: cstring) {.importc.}
proc gtk_actionable_get_action_name*(actionable: pointer): cstring {.importc.}
proc gtk_actionable_set_action_target_value*(actionable: pointer; target_value: GVariant) {.importc.}
proc gtk_actionable_get_action_target_value*(actionable: pointer): GVariant {.importc.}





# ============================================================================
# MENU
# ============================================================================

proc g_menu_new*(): GMenu {.importc.}
proc g_menu_append*(menu: GMenu, label: cstring, detailedAction: cstring) {.importc.}
proc g_menu_prepend*(menu: GMenu, label: cstring, detailedAction: cstring) {.importc.}
proc g_menu_insert*(menu: GMenu, position: gint, label: cstring, detailedAction: cstring) {.importc.}
proc g_menu_append_section*(menu: GMenu, label: cstring, section: GMenuModel) {.importc.}
proc g_menu_append_submenu*(menu: GMenu, label: cstring, submenu: GMenuModel) {.importc.}
proc g_menu_remove*(menu: GMenu, position: gint) {.importc.}
proc g_menu_remove_all*(menu: GMenu) {.importc.}


# ============================================================================
# WINDOW
# ============================================================================

proc gtk_window_new*(): GtkWindow {.importc.}
proc gtk_window_set_title*(window: GtkWindow, title: cstring) {.importc.}
proc gtk_window_get_title*(window: GtkWindow): cstring {.importc.}
proc gtk_window_set_default_size*(window: GtkWindow, width: gint, height: gint) {.importc.}
proc gtk_window_get_default_size*(window: GtkWindow, width: ptr gint, height: ptr gint) {.importc.}
proc gtk_window_set_resizable*(window: GtkWindow, resizable: gboolean) {.importc.}
proc gtk_window_get_resizable*(window: GtkWindow): gboolean {.importc.}
proc gtk_window_set_modal*(window: GtkWindow, modal: gboolean) {.importc.}
proc gtk_window_get_modal*(window: GtkWindow): gboolean {.importc.}
proc gtk_window_set_decorated*(window: GtkWindow, setting: gboolean) {.importc.}
proc gtk_window_get_decorated*(window: GtkWindow): gboolean {.importc.}
proc gtk_window_set_deletable*(window: GtkWindow, setting: gboolean) {.importc.}
proc gtk_window_get_deletable*(window: GtkWindow): gboolean {.importc.}
proc gtk_window_set_transient_for*(window: GtkWindow, parent: GtkWindow) {.importc.}
proc gtk_window_get_transient_for*(window: GtkWindow): GtkWindow {.importc.}
proc gtk_window_set_child*(window: GtkWindow, child: GtkWidget) {.importc.}
proc gtk_window_get_child*(window: GtkWindow): GtkWidget {.importc.}
proc gtk_window_set_titlebar*(window: GtkWindow, titlebar: GtkWidget) {.importc.}
proc gtk_window_get_titlebar*(window: GtkWindow): GtkWidget {.importc.}
proc gtk_window_close*(window: GtkWindow) {.importc.}
proc gtk_window_destroy*(window: GtkWindow) {.importc.}
proc gtk_window_fullscreen*(window: GtkWindow) {.importc.}
proc gtk_window_unfullscreen*(window: GtkWindow) {.importc.}
proc gtk_window_maximize*(window: GtkWindow) {.importc.}
proc gtk_window_unmaximize*(window: GtkWindow) {.importc.}
proc gtk_window_minimize*(window: GtkWindow) {.importc.}
proc gtk_window_unminimize*(window: GtkWindow) {.importc.}
proc gtk_window_present*(window: GtkWindow) {.importc.}
proc gtk_window_set_default_icon_name*(name: cstring) {.importc.}
proc gtk_window_set_icon_name*(window: GtkWindow, name: cstring) {.importc.}
# Установка иконки через paintable (GTK4)
proc gtk_window_set_icon_paintable*(window: GtkWindow, paintable: pointer) {.importc.}
# Полноэкранный режим
proc gtk_window_is_fullscreen*(window: GtkWindow): gboolean {.importc.}




# ============================================================================
# WIDGET (базовые функции для всех виджетов)
# ============================================================================

proc gtk_widget_show*(widget: GtkWidget) {.importc.}
proc gtk_widget_hide*(widget: GtkWidget) {.importc.}
proc gtk_widget_set_visible*(widget: GtkWidget, visible: gboolean) {.importc.}
proc gtk_widget_get_visible*(widget: GtkWidget): gboolean {.importc.}
proc gtk_widget_set_sensitive*(widget: GtkWidget, sensitive: gboolean) {.importc.}
proc gtk_widget_get_sensitive*(widget: GtkWidget): gboolean {.importc.}
proc gtk_widget_set_can_focus*(widget: GtkWidget, canFocus: gboolean) {.importc.}
proc gtk_widget_get_can_focus*(widget: GtkWidget): gboolean {.importc.}
proc gtk_widget_grab_focus*(widget: GtkWidget): gboolean {.importc.}
proc gtk_widget_set_size_request*(widget: GtkWidget, width: gint, height: gint) {.importc.}
proc gtk_widget_get_size_request*(widget: GtkWidget, width: ptr gint, height: ptr gint) {.importc.}
proc gtk_widget_set_hexpand*(widget: GtkWidget, expand: gboolean) {.importc.}
proc gtk_widget_get_hexpand*(widget: GtkWidget): gboolean {.importc.}
proc gtk_widget_set_vexpand*(widget: GtkWidget, expand: gboolean) {.importc.}
proc gtk_widget_get_vexpand*(widget: GtkWidget): gboolean {.importc.}
proc gtk_widget_set_halign*(widget: GtkWidget, align: GtkAlign) {.importc.}
proc gtk_widget_get_halign*(widget: GtkWidget): GtkAlign {.importc.}
proc gtk_widget_set_valign*(widget: GtkWidget, align: GtkAlign) {.importc.}
proc gtk_widget_get_valign*(widget: GtkWidget): GtkAlign {.importc.}
proc gtk_widget_set_margin_start*(widget: GtkWidget, margin: gint) {.importc.}
proc gtk_widget_get_margin_start*(widget: GtkWidget): gint {.importc.}
proc gtk_widget_set_margin_end*(widget: GtkWidget, margin: gint) {.importc.}
proc gtk_widget_get_margin_end*(widget: GtkWidget): gint {.importc.}
proc gtk_widget_set_margin_top*(widget: GtkWidget, margin: gint) {.importc.}
proc gtk_widget_get_margin_top*(widget: GtkWidget): gint {.importc.}
proc gtk_widget_set_margin_bottom*(widget: GtkWidget, margin: gint) {.importc.}
proc gtk_widget_get_margin_bottom*(widget: GtkWidget): gint {.importc.}
proc gtk_widget_set_tooltip_text*(widget: GtkWidget, text: cstring) {.importc.}
proc gtk_widget_get_tooltip_text*(widget: GtkWidget): cstring {.importc.}
proc gtk_widget_set_tooltip_markup*(widget: GtkWidget, markup: cstring) {.importc.}
proc gtk_widget_get_tooltip_markup*(widget: GtkWidget): cstring {.importc.}
proc gtk_widget_set_name*(widget: GtkWidget, name: cstring) {.importc.}
proc gtk_widget_get_name*(widget: GtkWidget): cstring {.importc.}
proc gtk_widget_add_css_class*(widget: GtkWidget, cssClass: cstring) {.importc.}
proc gtk_widget_remove_css_class*(widget: GtkWidget, cssClass: cstring) {.importc.}
proc gtk_widget_has_css_class*(widget: GtkWidget, cssClass: cstring): gboolean {.importc.}
proc gtk_widget_get_parent*(widget: GtkWidget): GtkWidget {.importc.}
proc gtk_widget_get_first_child*(widget: GtkWidget): GtkWidget {.importc.}
proc gtk_widget_get_last_child*(widget: GtkWidget): GtkWidget {.importc.}
proc gtk_widget_get_next_sibling*(widget: GtkWidget): GtkWidget {.importc.}
proc gtk_widget_get_prev_sibling*(widget: GtkWidget): GtkWidget {.importc.}



# ============================================================================
# BOX
# ============================================================================

proc gtk_box_new*(orientation: GtkOrientation, spacing: gint): GtkBox {.importc.}
proc gtk_box_append*(box: GtkBox, child: GtkWidget) {.importc.}
proc gtk_box_prepend*(box: GtkBox, child: GtkWidget) {.importc.}
proc gtk_box_remove*(box: GtkBox, child: GtkWidget) {.importc.}
proc gtk_box_insert_child_after*(box: GtkBox, child: GtkWidget, sibling: GtkWidget) {.importc.}
proc gtk_box_reorder_child_after*(box: GtkBox, child: GtkWidget, sibling: GtkWidget) {.importc.}
proc gtk_box_set_spacing*(box: GtkBox, spacing: gint) {.importc.}
proc gtk_box_get_spacing*(box: GtkBox): gint {.importc.}
proc gtk_box_set_homogeneous*(box: GtkBox, homogeneous: gboolean) {.importc.}
proc gtk_box_get_homogeneous*(box: GtkBox): gboolean {.importc.}
proc gtk_box_set_baseline_position*(box: GtkBox, position: GtkBaselinePosition) {.importc.}
proc gtk_box_get_baseline_position*(box: GtkBox): GtkBaselinePosition {.importc.}
# Базовая ячейка (baseline child):
# позволяют указать индекс дочернего виджета, который будет использоваться
# для выравнивания по базовой линии (-1 означает отсутствие такого виджета)
proc gtk_box_set_baseline_child*(box: GtkBox, child: gint) {.importc.}
proc gtk_box_get_baseline_child*(box: GtkBox): gint {.importc.}



# ============================================================================
# GRID
# ============================================================================

proc gtk_grid_new*(): GtkGrid {.importc.}
proc gtk_grid_attach*(grid: GtkGrid, child: GtkWidget, column: gint, row: gint, width: gint, height: gint) {.importc.}
proc gtk_grid_attach_next_to*(grid: GtkGrid, child: GtkWidget, sibling: GtkWidget, side: GtkPositionType, width: gint, height: gint) {.importc.}
proc gtk_grid_remove*(grid: GtkGrid, child: GtkWidget) {.importc.}
proc gtk_grid_get_child_at*(grid: GtkGrid, column: gint, row: gint): GtkWidget {.importc.}
proc gtk_grid_set_row_spacing*(grid: GtkGrid, spacing: guint) {.importc.}
proc gtk_grid_get_row_spacing*(grid: GtkGrid): guint {.importc.}
proc gtk_grid_set_column_spacing*(grid: GtkGrid, spacing: guint) {.importc.}
proc gtk_grid_get_column_spacing*(grid: GtkGrid): guint {.importc.}
proc gtk_grid_set_row_homogeneous*(grid: GtkGrid, homogeneous: gboolean) {.importc.}
proc gtk_grid_get_row_homogeneous*(grid: GtkGrid): gboolean {.importc.}
proc gtk_grid_set_column_homogeneous*(grid: GtkGrid, homogeneous: gboolean) {.importc.}
proc gtk_grid_get_column_homogeneous*(grid: GtkGrid): gboolean {.importc.}

# Baseline
proc gtk_grid_set_row_baseline_position*(grid: GtkGrid, row: gint, pos: GtkBaselinePosition) {.importc.}
proc gtk_grid_get_row_baseline_position*(grid: GtkGrid, row: gint): GtkBaselinePosition {.importc.}
proc gtk_grid_set_baseline_row*(grid: GtkGrid, row: gint) {.importc.}
proc gtk_grid_get_baseline_row*(grid: GtkGrid): gint {.importc.}

# Динамическая вставка/удаление строк и столбцов
proc gtk_grid_insert_row*(grid: GtkGrid, position: gint) {.importc.}
proc gtk_grid_insert_column*(grid: GtkGrid, position: gint) {.importc.}
proc gtk_grid_remove_row*(grid: GtkGrid, position: gint) {.importc.}
proc gtk_grid_remove_column*(grid: GtkGrid, position: gint) {.importc.}
# Вставка строки или столбца рядом с виджетом
proc gtk_grid_insert_next_to*(grid: GtkGrid, sibling: GtkWidget, side: GtkPositionType) {.importc.}

# Запрос позиции и размера дочернего виджета
proc gtk_grid_query_child*(grid: GtkGrid, child: GtkWidget, column: ptr gint, row: ptr gint, width: ptr gint, height: ptr gint) {.importc.}



# ============================================================================
# BUTTON
# ============================================================================

proc gtk_button_new*(): GtkButton {.importc.}
proc gtk_button_new_with_label*(label: cstring): GtkButton {.importc.}
proc gtk_button_new_with_mnemonic*(label: cstring): GtkButton {.importc.}
# создание кнопки с иконкой по имени иконки
proc gtk_button_new_from_icon_name*(icon_name: cstring): GtkButton {.importc.}
proc gtk_button_set_label*(button: GtkButton, label: cstring) {.importc.}
proc gtk_button_get_label*(button: GtkButton): cstring {.importc.}
proc gtk_button_set_use_underline*(button: GtkButton, useUnderline: gboolean) {.importc.}
proc gtk_button_get_use_underline*(button: GtkButton): gboolean {.importc.}
proc gtk_button_set_child*(button: GtkButton, child: GtkWidget) {.importc.}
proc gtk_button_get_child*(button: GtkButton): GtkWidget {.importc.}
proc gtk_button_set_has_frame*(button: GtkButton, hasFrame: gboolean) {.importc.}
proc gtk_button_get_has_frame*(button: GtkButton): gboolean {.importc.}
proc gtk_button_set_icon_name*(button: GtkButton, iconName: cstring) {.importc.}
proc gtk_button_get_icon_name*(button: GtkButton): cstring {.importc.}
# Управление возможностью сжатия кнопки меньше естественного размера
proc gtk_button_set_can_shrink*(button: GtkButton, can_shrink: gboolean) {.importc.}
proc gtk_button_get_can_shrink*(button: GtkButton): gboolean {.importc.}
proc gtk_button_set_action_name*(button: GtkButton; action_name: cstring) {.importc.}
proc gtk_button_get_action_name*(button: GtkButton): cstring {.importc.}



# ============================================================================
# TOGGLE BUTTON
# ============================================================================

proc gtk_toggle_button_new*(): GtkToggleButton {.importc.}
proc gtk_toggle_button_new_with_label*(label: cstring): GtkToggleButton {.importc.}
proc gtk_toggle_button_new_with_mnemonic*(label: cstring): GtkToggleButton {.importc.}
proc gtk_toggle_button_set_active*(toggleButton: GtkToggleButton, isActive: gboolean) {.importc.}
proc gtk_toggle_button_get_active*(toggleButton: GtkToggleButton): gboolean {.importc.}
proc gtk_toggle_button_toggled*(toggleButton: GtkToggleButton) {.importc.}
# Группирование радиокнопок: позволяет создавать радиокнопки.
# Когда несколько toggle-кнопок в одной группе, только одна может быть активна одновременно.
# Передача nil удаляет кнопку из группы.
proc gtk_toggle_button_set_group*(toggle_button: GtkToggleButton, group: GtkToggleButton) {.importc.}



# ============================================================================
# CHECK BUTTON
# ============================================================================
# В GTK4 API был переработан — теперь GtkCheckButton используется
# и для обычных чекбоксов, и для радиокнопок через группирование.
proc gtk_check_button_new*(): GtkCheckButton {.importc.}
proc gtk_check_button_new_with_label*(label: cstring): GtkCheckButton {.importc.}
proc gtk_check_button_new_with_mnemonic*(label: cstring): GtkCheckButton {.importc.}
proc gtk_check_button_set_active*(checkButton: GtkCheckButton, setting: gboolean) {.importc.}
proc gtk_check_button_get_active*(checkButton: GtkCheckButton): gboolean {.importc.}
proc gtk_check_button_set_inconsistent*(checkButton: GtkCheckButton, inconsistent: gboolean) {.importc.}
proc gtk_check_button_get_inconsistent*(checkButton: GtkCheckButton): gboolean {.importc.}
# Группирование (для радиокнопок)
proc gtk_check_button_set_group*(check_button: GtkCheckButton, group: GtkCheckButton) {.importc.}
# Управление меткой и дочерним виджетом
proc gtk_check_button_set_label*(check_button: GtkCheckButton, label: cstring) {.importc.}
proc gtk_check_button_get_label*(check_button: GtkCheckButton): cstring {.importc.}
proc gtk_check_button_set_use_underline*(check_button: GtkCheckButton, use_underline: gboolean) {.importc.}
proc gtk_check_button_get_use_underline*(check_button: GtkCheckButton): gboolean {.importc.}
proc gtk_check_button_set_child*(check_button: GtkCheckButton, child: GtkWidget) {.importc.}
proc gtk_check_button_get_child*(check_button: GtkCheckButton): GtkWidget {.importc.}



# ============================================================================
# SWITCH
# ============================================================================
# active — немедленно переключает визуальное состояние;
# state — позволяет отложить изменение состояния,
# например, если нужно показать диалог подтверждения
# или выполнить асинхронную операцию перед фактическим переключением
proc gtk_switch_new*(): GtkSwitch {.importc.}
proc gtk_switch_set_active*(sw: GtkSwitch, isActive: gboolean) {.importc.}
proc gtk_switch_get_active*(sw: GtkSwitch): gboolean {.importc.}
proc gtk_switch_set_state*(sw: GtkSwitch, state: gboolean) {.importc.}
proc gtk_switch_get_state*(sw: GtkSwitch): gboolean {.importc.}




# ============================================================================
# LABEL
# ============================================================================
proc gtk_label_new*(str: cstring): GtkLabel {.importc.}
proc gtk_label_new_with_mnemonic*(str: cstring): GtkLabel {.importc.}
proc gtk_label_set_text*(label: GtkLabel, str: cstring) {.importc.}
proc gtk_label_get_text*(label: GtkLabel): cstring {.importc.}
proc gtk_label_set_markup*(label: GtkLabel, str: cstring) {.importc.}
proc gtk_label_set_use_markup*(label: GtkLabel, setting: gboolean) {.importc.}
proc gtk_label_get_use_markup*(label: GtkLabel): gboolean {.importc.}
proc gtk_label_set_use_underline*(label: GtkLabel, setting: gboolean) {.importc.}
proc gtk_label_get_use_underline*(label: GtkLabel): gboolean {.importc.}
proc gtk_label_set_justify*(label: GtkLabel, jtype: GtkJustification) {.importc.}
proc gtk_label_get_justify*(label: GtkLabel): GtkJustification {.importc.}
proc gtk_label_set_wrap*(label: GtkLabel, wrap: gboolean) {.importc.}
proc gtk_label_get_wrap*(label: GtkLabel): gboolean {.importc.}
proc gtk_label_set_wrap_mode*(label: GtkLabel, wrapMode: PangoWrapMode) {.importc.}
proc gtk_label_get_wrap_mode*(label: GtkLabel): PangoWrapMode {.importc.}
proc gtk_label_set_selectable*(label: GtkLabel, setting: gboolean) {.importc.}
proc gtk_label_get_selectable*(label: GtkLabel): gboolean {.importc.}
proc gtk_label_set_width_chars*(label: GtkLabel, nChars: gint) {.importc.}
proc gtk_label_get_width_chars*(label: GtkLabel): gint {.importc.}
proc gtk_label_set_max_width_chars*(label: GtkLabel, nChars: gint) {.importc.}
proc gtk_label_get_max_width_chars*(label: GtkLabel): gint {.importc.}
proc gtk_label_set_ellipsize*(label: GtkLabel, mode: PangoEllipsizeMode) {.importc.}
proc gtk_label_get_ellipsize*(label: GtkLabel): PangoEllipsizeMode {.importc.}

# Выделение текста
proc gtk_label_select_region*(label: GtkLabel, start_offset: gint, end_offset: gint) {.importc.}
proc gtk_label_get_selection_bounds*(label: GtkLabel, start: ptr gint, `end`: ptr gint): gboolean {.importc.}

# Атрибуты (Pango)
proc gtk_label_set_attributes*(label: GtkLabel, attrs: PangoAttrList) {.importc.}
proc gtk_label_get_attributes*(label: GtkLabel): PangoAttrList {.importc.}

# Виджет-мнемоник
proc gtk_label_set_mnemonic_widget*(label: GtkLabel, widget: GtkWidget) {.importc.}
proc gtk_label_get_mnemonic_widget*(label: GtkLabel): GtkWidget {.importc.}

# Дополнительные свойства текста
proc gtk_label_set_single_line_mode*(label: GtkLabel, single_line_mode: gboolean) {.importc.}
proc gtk_label_get_single_line_mode*(label: GtkLabel): gboolean {.importc.}
proc gtk_label_set_lines*(label: GtkLabel, lines: gint) {.importc.}
proc gtk_label_get_lines*(label: GtkLabel): gint {.importc.}

# XAlign и YAlign
proc gtk_label_set_xalign*(label: GtkLabel, xalign: cfloat) {.importc.}
proc gtk_label_get_xalign*(label: GtkLabel): cfloat {.importc.}
proc gtk_label_set_yalign*(label: GtkLabel, yalign: cfloat) {.importc.}
proc gtk_label_get_yalign*(label: GtkLabel): cfloat {.importc.}

# Extra menu (контекстное меню)
proc gtk_label_set_extra_menu*(label: GtkLabel, model: GMenuModel) {.importc.}
proc gtk_label_get_extra_menu*(label: GtkLabel): GMenuModel {.importc.}

# Естественное заполнение (natural wrap mode)
proc gtk_label_set_natural_wrap_mode*(label: GtkLabel, wrap_mode: GtkNaturalWrapMode) {.importc.}
proc gtk_label_get_natural_wrap_mode*(label: GtkLabel): GtkNaturalWrapMode {.importc.}

# Tabs (позиции табуляции)
proc gtk_label_set_tabs*(label: GtkLabel, tabs: PangoTabArray) {.importc.}
proc gtk_label_get_tabs*(label: GtkLabel): PangoTabArray {.importc.}

# Получение текущей URI (если кликнут на ссылку)
proc gtk_label_get_current_uri*(label: GtkLabel): cstring {.importc.}

# Markup с мнемоникой
proc gtk_label_set_markup_with_mnemonic*(label: GtkLabel, str: cstring) {.importc.}

# Получение layout (Pango)
proc gtk_label_get_layout*(label: GtkLabel): PangoLayout {.importc.}
proc gtk_label_get_layout_offsets*(label: GtkLabel, x: ptr gint, y: ptr gint) {.importc.}





# ============================================================================
# ENTRY
# ============================================================================
proc gtk_entry_new*(): GtkEntry {.importc.}
proc gtk_entry_new_with_buffer*(buffer: GtkEntryBuffer): GtkEntry {.importc.}
proc gtk_entry_set_text*(entry: GtkEntry, text: cstring) {.importc.}
proc gtk_entry_get_text*(entry: GtkEntry): cstring {.importc.}
proc gtk_entry_set_placeholder_text*(entry: GtkEntry, text: cstring) {.importc.}
proc gtk_entry_get_placeholder_text*(entry: GtkEntry): cstring {.importc.}
proc gtk_entry_set_visibility*(entry: GtkEntry, visible: gboolean) {.importc.}
proc gtk_entry_get_visibility*(entry: GtkEntry): gboolean {.importc.}
proc gtk_entry_set_max_length*(entry: GtkEntry, max: gint) {.importc.}
proc gtk_entry_get_max_length*(entry: GtkEntry): gint {.importc.}
proc gtk_entry_set_has_frame*(entry: GtkEntry, setting: gboolean) {.importc.}
proc gtk_entry_get_has_frame*(entry: GtkEntry): gboolean {.importc.}
proc gtk_entry_set_alignment*(entry: GtkEntry, xalign: gfloat) {.importc.}
proc gtk_entry_get_alignment*(entry: GtkEntry): gfloat {.importc.}

# Буфер текста
proc gtk_entry_set_buffer*(entry: GtkEntry, buffer: GtkEntryBuffer) {.importc.}
proc gtk_entry_get_buffer*(entry: GtkEntry): GtkEntryBuffer {.importc.}

# Невидимый символ для паролей
proc gtk_entry_set_invisible_char*(entry: GtkEntry, ch: gunichar) {.importc.}
proc gtk_entry_get_invisible_char*(entry: GtkEntry): gunichar {.importc.}
proc gtk_entry_unset_invisible_char*(entry: GtkEntry) {.importc.}

# Активация
proc gtk_entry_set_activates_default*(entry: GtkEntry, setting: gboolean) {.importc.}
proc gtk_entry_get_activates_default*(entry: GtkEntry): gboolean {.importc.}

# Ширина в символах
proc gtk_entry_set_width_chars*(entry: GtkEntry, n_chars: gint) {.importc.}
proc gtk_entry_get_width_chars*(entry: GtkEntry): gint {.importc.}
proc gtk_entry_set_max_width_chars*(entry: GtkEntry, n_chars: gint) {.importc.}
proc gtk_entry_get_max_width_chars*(entry: GtkEntry): gint {.importc.}

# Атрибуты (Pango)
proc gtk_entry_set_attributes*(entry: GtkEntry, attrs: PangoAttrList) {.importc.}
proc gtk_entry_get_attributes*(entry: GtkEntry): PangoAttrList {.importc.}

# Tabs (позиции табуляции)
proc gtk_entry_set_tabs*(entry: GtkEntry, tabs: PangoTabArray) {.importc.}
proc gtk_entry_get_tabs*(entry: GtkEntry): PangoTabArray {.importc.}

# Прогресс (progress bar в entry)
proc gtk_entry_set_progress_fraction*(entry: GtkEntry, fraction: gdouble) {.importc.}
proc gtk_entry_get_progress_fraction*(entry: GtkEntry): gdouble {.importc.}
proc gtk_entry_set_progress_pulse_step*(entry: GtkEntry, fraction: gdouble) {.importc.}
proc gtk_entry_get_progress_pulse_step*(entry: GtkEntry): gdouble {.importc.}
proc gtk_entry_progress_pulse*(entry: GtkEntry) {.importc.}

# Completion (автодополнение)
proc gtk_entry_set_completion*(entry: GtkEntry, completion: GtkEntryCompletion) {.importc.}
proc gtk_entry_get_completion*(entry: GtkEntry): GtkEntryCompletion {.importc.}

# Позиция курсора
proc gtk_entry_get_text_length*(entry: GtkEntry): guint16 {.importc.}

# Иконки
proc gtk_entry_set_icon_from_icon_name*(entry: GtkEntry, icon_pos: GtkEntryIconPosition, icon_name: cstring) {.importc.}
proc gtk_entry_set_icon_from_gicon*(entry: GtkEntry, icon_pos: GtkEntryIconPosition, icon: GIcon) {.importc.}
proc gtk_entry_set_icon_from_paintable*(entry: GtkEntry, icon_pos: GtkEntryIconPosition, paintable: GdkPaintable) {.importc.}
proc gtk_entry_get_icon_storage_type*(entry: GtkEntry, icon_pos: GtkEntryIconPosition): GtkImageType {.importc.}
proc gtk_entry_get_icon_name*(entry: GtkEntry, icon_pos: GtkEntryIconPosition): cstring {.importc.}
proc gtk_entry_get_icon_gicon*(entry: GtkEntry, icon_pos: GtkEntryIconPosition): GIcon {.importc.}
proc gtk_entry_get_icon_paintable*(entry: GtkEntry, icon_pos: GtkEntryIconPosition): GdkPaintable {.importc.}
proc gtk_entry_set_icon_activatable*(entry: GtkEntry, icon_pos: GtkEntryIconPosition, activatable: gboolean) {.importc.}
proc gtk_entry_get_icon_activatable*(entry: GtkEntry, icon_pos: GtkEntryIconPosition): gboolean {.importc.}
proc gtk_entry_set_icon_sensitive*(entry: GtkEntry, icon_pos: GtkEntryIconPosition, sensitive: gboolean) {.importc.}
proc gtk_entry_get_icon_sensitive*(entry: GtkEntry, icon_pos: GtkEntryIconPosition): gboolean {.importc.}
proc gtk_entry_set_icon_tooltip_text*(entry: GtkEntry, icon_pos: GtkEntryIconPosition, tooltip: cstring) {.importc.}
proc gtk_entry_get_icon_tooltip_text*(entry: GtkEntry, icon_pos: GtkEntryIconPosition): cstring {.importc.}
proc gtk_entry_set_icon_tooltip_markup*(entry: GtkEntry, icon_pos: GtkEntryIconPosition, tooltip: cstring) {.importc.}
proc gtk_entry_get_icon_tooltip_markup*(entry: GtkEntry, icon_pos: GtkEntryIconPosition): cstring {.importc.}
proc gtk_entry_get_icon_at_pos*(entry: GtkEntry, x: gint, y: gint): gint {.importc.}

# Input purpose и hints
proc gtk_entry_set_input_purpose*(entry: GtkEntry, purpose: GtkInputPurpose) {.importc.}
proc gtk_entry_get_input_purpose*(entry: GtkEntry): GtkInputPurpose {.importc.}
proc gtk_entry_set_input_hints*(entry: GtkEntry, hints: GtkInputHints) {.importc.}
proc gtk_entry_get_input_hints*(entry: GtkEntry): GtkInputHints {.importc.}

# Дополнительное меню
proc gtk_entry_set_extra_menu*(entry: GtkEntry, model: GMenuModel) {.importc.}
proc gtk_entry_get_extra_menu*(entry: GtkEntry): GMenuModel {.importc.}

# Сброс IM контекста
proc gtk_entry_reset_im_context*(entry: GtkEntry) {.importc.}

# Получение текущего emoji chooser
proc gtk_entry_get_current_icon_drag_source*(entry: GtkEntry): gint {.importc.}

# Grab focus без выделения
proc gtk_entry_grab_focus_without_selecting*(entry: GtkEntry): gboolean {.importc.}




# ============================================================================
# PASSWORD ENTRY
# ============================================================================

proc gtk_password_entry_new*(): GtkPasswordEntry {.importc.}
proc gtk_password_entry_set_show_peek_icon*(entry: GtkPasswordEntry, showPeekIcon: gboolean) {.importc.}
proc gtk_password_entry_get_show_peek_icon*(entry: GtkPasswordEntry): gboolean {.importc.}
# Дополнительное меню
proc gtk_password_entry_set_extra_menu*(entry: GtkPasswordEntry, model: GMenuModel) {.importc.}
proc gtk_password_entry_get_extra_menu*(entry: GtkPasswordEntry): GMenuModel {.importc.}




# ============================================================================
# SEARCH ENTRY
# ============================================================================

proc gtk_search_entry_new*(): GtkSearchEntry {.importc.}

# Placeholder text
proc gtk_search_entry_set_placeholder_text*(entry: GtkSearchEntry, text: cstring) {.importc.}
proc gtk_search_entry_get_placeholder_text*(entry: GtkSearchEntry): cstring {.importc.}

# Задержка поиска (search delay)
proc gtk_search_entry_set_search_delay*(entry: GtkSearchEntry, delay: guint) {.importc.}
proc gtk_search_entry_get_search_delay*(entry: GtkSearchEntry): guint {.importc.}

# Клавиша захвата фокуса
proc gtk_search_entry_set_key_capture_widget*(entry: GtkSearchEntry, widget: GtkWidget) {.importc.}
proc gtk_search_entry_get_key_capture_widget*(entry: GtkSearchEntry): GtkWidget {.importc.}

# Input purpose и hints
proc gtk_search_entry_set_input_purpose*(entry: GtkSearchEntry, purpose: GtkInputPurpose) {.importc.}
proc gtk_search_entry_get_input_purpose*(entry: GtkSearchEntry): GtkInputPurpose {.importc.}
proc gtk_search_entry_set_input_hints*(entry: GtkSearchEntry, hints: GtkInputHints) {.importc.}
proc gtk_search_entry_get_input_hints*(entry: GtkSearchEntry): GtkInputHints {.importc.}




# ============================================================================
# TEXT VIEW
# ============================================================================
proc gtk_text_view_new*(): GtkTextView {.importc.}
proc gtk_text_view_new_with_buffer*(buffer: GtkTextBuffer): GtkTextView {.importc.}
proc gtk_text_view_get_buffer*(textView: GtkTextView): GtkTextBuffer {.importc.}
proc gtk_text_view_set_buffer*(textView: GtkTextView, buffer: GtkTextBuffer) {.importc.}
proc gtk_text_view_set_editable*(textView: GtkTextView, setting: gboolean) {.importc.}
proc gtk_text_view_get_editable*(textView: GtkTextView): gboolean {.importc.}
proc gtk_text_view_set_wrap_mode*(textView: GtkTextView, wrap_mode: PangoWrapMode) {.importc.}
proc gtk_text_view_get_wrap_mode*(textView: GtkTextView): PangoWrapMode {.importc.}
proc gtk_text_view_set_cursor_visible*(textView: GtkTextView, setting: gboolean) {.importc.}
proc gtk_text_view_get_cursor_visible*(textView: GtkTextView): gboolean {.importc.}
proc gtk_text_view_set_monospace*(textView: GtkTextView, monospace: gboolean) {.importc.}
proc gtk_text_view_get_monospace*(textView: GtkTextView): gboolean {.importc.}

# Отступы и выравнивание
proc gtk_text_view_set_pixels_above_lines*(text_view: GtkTextView, pixels_above_lines: gint) {.importc.}
proc gtk_text_view_get_pixels_above_lines*(text_view: GtkTextView): gint {.importc.}
proc gtk_text_view_set_pixels_below_lines*(text_view: GtkTextView, pixels_below_lines: gint) {.importc.}
proc gtk_text_view_get_pixels_below_lines*(text_view: GtkTextView): gint {.importc.}
proc gtk_text_view_set_pixels_inside_wrap*(text_view: GtkTextView, pixels_inside_wrap: gint) {.importc.}
proc gtk_text_view_get_pixels_inside_wrap*(text_view: GtkTextView): gint {.importc.}
proc gtk_text_view_set_justification*(text_view: GtkTextView, justification: GtkJustification) {.importc.}
proc gtk_text_view_get_justification*(text_view: GtkTextView): GtkJustification {.importc.}
proc gtk_text_view_set_left_margin*(text_view: GtkTextView, left_margin: gint) {.importc.}
proc gtk_text_view_get_left_margin*(text_view: GtkTextView): gint {.importc.}
proc gtk_text_view_set_right_margin*(text_view: GtkTextView, right_margin: gint) {.importc.}
proc gtk_text_view_get_right_margin*(text_view: GtkTextView): gint {.importc.}
proc gtk_text_view_set_top_margin*(text_view: GtkTextView, top_margin: gint) {.importc.}
proc gtk_text_view_get_top_margin*(text_view: GtkTextView): gint {.importc.}
proc gtk_text_view_set_bottom_margin*(text_view: GtkTextView, bottom_margin: gint) {.importc.}
proc gtk_text_view_get_bottom_margin*(text_view: GtkTextView): gint {.importc.}
proc gtk_text_view_set_indent*(text_view: GtkTextView, indent: gint) {.importc.}
proc gtk_text_view_get_indent*(text_view: GtkTextView): gint {.importc.}

# Tabs
proc gtk_text_view_set_tabs*(text_view: GtkTextView, tabs: PangoTabArray) {.importc.}
proc gtk_text_view_get_tabs*(text_view: GtkTextView): PangoTabArray {.importc.}

# Accepts tab
proc gtk_text_view_set_accepts_tab*(text_view: GtkTextView, accepts_tab: gboolean) {.importc.}
proc gtk_text_view_get_accepts_tab*(text_view: GtkTextView): gboolean {.importc.}

# Overwrite mode
proc gtk_text_view_set_overwrite*(text_view: GtkTextView, overwrite: gboolean) {.importc.}
proc gtk_text_view_get_overwrite*(text_view: GtkTextView): gboolean {.importc.}

# Input purpose и hints
proc gtk_text_view_set_input_purpose*(text_view: GtkTextView, purpose: GtkInputPurpose) {.importc.}
proc gtk_text_view_get_input_purpose*(text_view: GtkTextView): GtkInputPurpose {.importc.}
proc gtk_text_view_set_input_hints*(text_view: GtkTextView, hints: GtkInputHints) {.importc.}
proc gtk_text_view_get_input_hints*(text_view: GtkTextView): GtkInputHints {.importc.}

# Прокрутка к маркеру/итератору
proc gtk_text_view_scroll_to_mark*(text_view: GtkTextView, mark: GtkTextMark, 
                                   within_margin: gdouble, use_align: gboolean,
                                   xalign: gdouble, yalign: gdouble) {.importc.}
proc gtk_text_view_scroll_to_iter*(text_view: GtkTextView, iter: ptr GtkTextIter,
                                   within_margin: gdouble, use_align: gboolean,
                                   xalign: gdouble, yalign: gdouble): gboolean {.importc.}
proc gtk_text_view_scroll_mark_onscreen*(text_view: GtkTextView, mark: GtkTextMark) {.importc.}

# Перемещение маркера на экран
proc gtk_text_view_move_mark_onscreen*(text_view: GtkTextView, mark: GtkTextMark): gboolean {.importc.}

# Видимость области
proc gtk_text_view_get_visible_rect*(text_view: GtkTextView, visible_rect: ptr GdkRectangle) {.importc.}

# Преобразование координат
proc gtk_text_view_get_iter_location*(text_view: GtkTextView, iter: ptr GtkTextIter, 
                                      location: ptr GdkRectangle) {.importc.}
proc gtk_text_view_get_iter_at_location*(text_view: GtkTextView, iter: ptr GtkTextIter,
                                         x: gint, y: gint): gboolean {.importc.}
proc gtk_text_view_get_iter_at_position*(text_view: GtkTextView, iter: ptr GtkTextIter,
                                         trailing: ptr gint, x: gint, y: gint): gboolean {.importc.}
proc gtk_text_view_get_line_at_y*(text_view: GtkTextView, target_iter: ptr GtkTextIter,
                                  y: gint, line_top: ptr gint) {.importc.}
proc gtk_text_view_get_line_yrange*(text_view: GtkTextView, iter: ptr GtkTextIter,
                                    y: ptr gint, height: ptr gint) {.importc.}
proc gtk_text_view_buffer_to_window_coords*(text_view: GtkTextView, win: GtkTextWindowType,
                                            buffer_x: gint, buffer_y: gint,
                                            window_x: ptr gint, window_y: ptr gint) {.importc.}
proc gtk_text_view_window_to_buffer_coords*(text_view: GtkTextView, win: GtkTextWindowType,
                                            window_x: gint, window_y: gint,
                                            buffer_x: ptr gint, buffer_y: ptr gint) {.importc.}

# Gutter (боковые области)
proc gtk_text_view_set_gutter*(text_view: GtkTextView, win: GtkTextWindowType, widget: GtkWidget) {.importc.}
proc gtk_text_view_get_gutter*(text_view: GtkTextView, win: GtkTextWindowType): GtkWidget {.importc.}

# Дополнительное меню
proc gtk_text_view_set_extra_menu*(text_view: GtkTextView, model: GMenuModel) {.importc.}
proc gtk_text_view_get_extra_menu*(text_view: GtkTextView): GMenuModel {.importc.}

# Добавление дочерних виджетов
proc gtk_text_view_add_child_at_anchor*(text_view: GtkTextView, child: GtkWidget, 
                                        anchor: GtkTextChildAnchor) {.importc.}
proc gtk_text_view_add_overlay*(text_view: GtkTextView, child: GtkWidget, xpos: gint, ypos: gint) {.importc.}
proc gtk_text_view_move_overlay*(text_view: GtkTextView, child: GtkWidget, xpos: gint, ypos: gint) {.importc.}
proc gtk_text_view_remove*(text_view: GtkTextView, child: GtkWidget) {.importc.}

# IM контекст
proc gtk_text_view_reset_im_context*(text_view: GtkTextView) {.importc.}

# RTL (right-to-left) контекст меню
proc gtk_text_view_get_rtl_context*(text_view: GtkTextView): PangoContext {.importc.}

# LTR (left-to-right) контекст меню  
proc gtk_text_view_get_ltr_context*(text_view: GtkTextView): PangoContext {.importc.}

# Начать выделение через drag
proc gtk_text_view_start_selection_drag*(text_view: GtkTextView, iter: ptr GtkTextIter,
                                         event: GdkEvent) {.importc.}

# Размещение курсора на экране
proc gtk_text_view_place_cursor_onscreen*(text_view: GtkTextView): gboolean {.importc.}

# Позиции курсора (strong и weak для bidirectional text)
proc gtk_text_view_get_cursor_locations*(text_view: GtkTextView, iter: ptr GtkTextIter, 
                                         strong: ptr GdkRectangle, weak: ptr GdkRectangle) {.importc.}

# Навигация по display lines (визуальным строкам с учетом переноса)
proc gtk_text_view_forward_display_line*(text_view: GtkTextView, iter: ptr GtkTextIter): gboolean {.importc.}
proc gtk_text_view_backward_display_line*(text_view: GtkTextView, iter: ptr GtkTextIter): gboolean {.importc.}
proc gtk_text_view_forward_display_line_end*(text_view: GtkTextView, iter: ptr GtkTextIter): gboolean {.importc.}
proc gtk_text_view_backward_display_line_start*(text_view: GtkTextView, iter: ptr GtkTextIter): gboolean {.importc.}
proc gtk_text_view_starts_display_line*(text_view: GtkTextView, iter: ptr GtkTextIter): gboolean {.importc.}
proc gtk_text_view_move_visually*(text_view: GtkTextView, iter: ptr GtkTextIter, count: gint): gboolean {.importc.}

# Input method context
proc gtk_text_view_im_context_filter_keypress*(text_view: GtkTextView, event: GdkEvent): gboolean {.importc.}




# ============================================================================
# TEXT BUFFER
# ============================================================================
proc gtk_text_buffer_new*(table: GtkTextTagTable): GtkTextBuffer {.importc.}
proc gtk_text_buffer_set_text*(buffer: GtkTextBuffer, text: cstring, len: gint) {.importc.}
proc gtk_text_buffer_get_text*(buffer: GtkTextBuffer, start: ptr GtkTextIter, `end`: ptr GtkTextIter, include_hidden_chars: gboolean): cstring {.importc.}
proc gtk_text_buffer_get_slice*(buffer: GtkTextBuffer, start: ptr GtkTextIter, `end`: ptr GtkTextIter, include_hidden_chars: gboolean): cstring {.importc.}
proc gtk_text_buffer_insert*(buffer: GtkTextBuffer, iter: ptr GtkTextIter, text: cstring, len: gint) {.importc.}
proc gtk_text_buffer_insert_at_cursor*(buffer: GtkTextBuffer, text: cstring, len: gint) {.importc.}
proc gtk_text_buffer_insert_range*(buffer: GtkTextBuffer, iter: ptr GtkTextIter, start: ptr GtkTextIter, `end`: ptr GtkTextIter) {.importc.}
proc gtk_text_buffer_insert_range_interactive*(buffer: GtkTextBuffer, iter: ptr GtkTextIter, start: ptr GtkTextIter, `end`: ptr GtkTextIter, default_editable: gboolean): gboolean {.importc.}
proc gtk_text_buffer_insert_interactive*(buffer: GtkTextBuffer, iter: ptr GtkTextIter, text: cstring, len: gint, default_editable: gboolean): gboolean {.importc.}
proc gtk_text_buffer_insert_interactive_at_cursor*(buffer: GtkTextBuffer, text: cstring, len: gint, default_editable: gboolean): gboolean {.importc.}
proc gtk_text_buffer_delete*(buffer: GtkTextBuffer, start: ptr GtkTextIter, `end`: ptr GtkTextIter) {.importc.}
proc gtk_text_buffer_delete_interactive*(buffer: GtkTextBuffer, start_iter: ptr GtkTextIter, end_iter: ptr GtkTextIter, default_editable: gboolean): gboolean {.importc.}
proc gtk_text_buffer_backspace*(buffer: GtkTextBuffer, iter: ptr GtkTextIter, interactive: gboolean, default_editable: gboolean): gboolean {.importc.}
proc gtk_text_buffer_get_char_count*(buffer: GtkTextBuffer): gint {.importc.}
proc gtk_text_buffer_get_line_count*(buffer: GtkTextBuffer): gint {.importc.}

# Итераторы
proc gtk_text_buffer_get_start_iter*(buffer: GtkTextBuffer, iter: ptr GtkTextIter) {.importc.}
proc gtk_text_buffer_get_end_iter*(buffer: GtkTextBuffer, iter: ptr GtkTextIter) {.importc.}
proc gtk_text_buffer_get_iter_at_line*(buffer: GtkTextBuffer, iter: ptr GtkTextIter, line_number: gint) {.importc.}
proc gtk_text_buffer_get_iter_at_offset*(buffer: GtkTextBuffer, iter: ptr GtkTextIter, char_offset: gint) {.importc.}
proc gtk_text_buffer_get_iter_at_line_offset*(buffer: GtkTextBuffer, iter: ptr GtkTextIter, line_number: gint, char_offset: gint) {.importc.}
proc gtk_text_buffer_get_iter_at_line_index*(buffer: GtkTextBuffer, iter: ptr GtkTextIter, line_number: gint, byte_index: gint) {.importc.}
proc gtk_text_buffer_get_iter_at_mark*(buffer: GtkTextBuffer, iter: ptr GtkTextIter, mark: GtkTextMark) {.importc.}
proc gtk_text_buffer_get_iter_at_child_anchor*(buffer: GtkTextBuffer, iter: ptr GtkTextIter, anchor: GtkTextChildAnchor) {.importc.}
proc gtk_text_buffer_get_bounds*(buffer: GtkTextBuffer, start: ptr GtkTextIter, `end`: ptr GtkTextIter) {.importc.}

# Маркеры (marks)
proc gtk_text_buffer_create_mark*(buffer: GtkTextBuffer, mark_name: cstring, where: ptr GtkTextIter, left_gravity: gboolean): GtkTextMark {.importc.}
proc gtk_text_buffer_add_mark*(buffer: GtkTextBuffer, mark: GtkTextMark, where: ptr GtkTextIter) {.importc.}
proc gtk_text_buffer_move_mark*(buffer: GtkTextBuffer, mark: GtkTextMark, where: ptr GtkTextIter) {.importc.}
proc gtk_text_buffer_move_mark_by_name*(buffer: GtkTextBuffer, name: cstring, where: ptr GtkTextIter) {.importc.}
proc gtk_text_buffer_delete_mark*(buffer: GtkTextBuffer, mark: GtkTextMark) {.importc.}
proc gtk_text_buffer_delete_mark_by_name*(buffer: GtkTextBuffer, name: cstring) {.importc.}
proc gtk_text_buffer_get_mark*(buffer: GtkTextBuffer, name: cstring): GtkTextMark {.importc.}
proc gtk_text_buffer_get_insert*(buffer: GtkTextBuffer): GtkTextMark {.importc.}
proc gtk_text_buffer_get_selection_bound*(buffer: GtkTextBuffer): GtkTextMark {.importc.}
proc gtk_text_buffer_place_cursor*(buffer: GtkTextBuffer, where: ptr GtkTextIter) {.importc.}
proc gtk_text_buffer_select_range*(buffer: GtkTextBuffer, ins: ptr GtkTextIter, bound: ptr GtkTextIter) {.importc.}

# Выделение
proc gtk_text_buffer_get_selection_bounds*(buffer: GtkTextBuffer, start: ptr GtkTextIter, `end`: ptr GtkTextIter): gboolean {.importc.}
proc gtk_text_buffer_get_has_selection*(buffer: GtkTextBuffer): gboolean {.importc.}
proc gtk_text_buffer_delete_selection*(buffer: GtkTextBuffer, interactive: gboolean, default_editable: gboolean): gboolean {.importc.}

# Теги
proc gtk_text_buffer_apply_tag*(buffer: GtkTextBuffer, tag: GtkTextTag, start: ptr GtkTextIter, `end`: ptr GtkTextIter) {.importc.}
proc gtk_text_buffer_remove_tag*(buffer: GtkTextBuffer, tag: GtkTextTag, start: ptr GtkTextIter, `end`: ptr GtkTextIter) {.importc.}
proc gtk_text_buffer_apply_tag_by_name*(buffer: GtkTextBuffer, name: cstring, start: ptr GtkTextIter, `end`: ptr GtkTextIter) {.importc.}
proc gtk_text_buffer_remove_tag_by_name*(buffer: GtkTextBuffer, name: cstring, start: ptr GtkTextIter, `end`: ptr GtkTextIter) {.importc.}
proc gtk_text_buffer_remove_all_tags*(buffer: GtkTextBuffer, start: ptr GtkTextIter, `end`: ptr GtkTextIter) {.importc.}
proc gtk_text_buffer_create_tag*(buffer: GtkTextBuffer, tag_name: cstring): GtkTextTag {.importc, varargs.}
proc gtk_text_buffer_get_tag_table*(buffer: GtkTextBuffer): GtkTextTagTable {.importc.}

# Вставка с тегами
proc gtk_text_buffer_insert_with_tags*(buffer: GtkTextBuffer, iter: ptr GtkTextIter, text: cstring, len: gint) {.importc, varargs.}
proc gtk_text_buffer_insert_with_tags_by_name*(buffer: GtkTextBuffer, iter: ptr GtkTextIter, text: cstring, len: gint) {.importc, varargs.}

# Якоря для дочерних виджетов
proc gtk_text_buffer_create_child_anchor*(buffer: GtkTextBuffer, iter: ptr GtkTextIter): GtkTextChildAnchor {.importc.}

# Вставка изображений и виджетов (через markup)
proc gtk_text_buffer_insert_markup*(buffer: GtkTextBuffer, iter: ptr GtkTextIter, markup: cstring, len: gint) {.importc.}
proc gtk_text_buffer_insert_paintable*(buffer: GtkTextBuffer, iter: ptr GtkTextIter, paintable: GdkPaintable) {.importc.}

# Clipboard
proc gtk_text_buffer_cut_clipboard*(buffer: GtkTextBuffer, clipboard: GdkClipboard, default_editable: gboolean) {.importc.}
proc gtk_text_buffer_copy_clipboard*(buffer: GtkTextBuffer, clipboard: GdkClipboard) {.importc.}
proc gtk_text_buffer_paste_clipboard*(buffer: GtkTextBuffer, clipboard: GdkClipboard, override_location: ptr GtkTextIter, default_editable: gboolean) {.importc.}

# Изменения (modified flag)
proc gtk_text_buffer_set_modified*(buffer: GtkTextBuffer, setting: gboolean) {.importc.}
proc gtk_text_buffer_get_modified*(buffer: GtkTextBuffer): gboolean {.importc.}

# Undo/Redo
proc gtk_text_buffer_set_enable_undo*(buffer: GtkTextBuffer, enable_undo: gboolean) {.importc.}
proc gtk_text_buffer_get_enable_undo*(buffer: GtkTextBuffer): gboolean {.importc.}
proc gtk_text_buffer_get_can_undo*(buffer: GtkTextBuffer): gboolean {.importc.}
proc gtk_text_buffer_get_can_redo*(buffer: GtkTextBuffer): gboolean {.importc.}
proc gtk_text_buffer_undo*(buffer: GtkTextBuffer) {.importc.}
proc gtk_text_buffer_redo*(buffer: GtkTextBuffer) {.importc.}
proc gtk_text_buffer_begin_irreversible_action*(buffer: GtkTextBuffer) {.importc.}
proc gtk_text_buffer_end_irreversible_action*(buffer: GtkTextBuffer) {.importc.}

# User action group (для группировки операций для undo)
proc gtk_text_buffer_begin_user_action*(buffer: GtkTextBuffer) {.importc.}
proc gtk_text_buffer_end_user_action*(buffer: GtkTextBuffer) {.importc.}

# Max undo levels
proc gtk_text_buffer_set_max_undo_levels*(buffer: GtkTextBuffer, max_undo_levels: guint) {.importc.}
proc gtk_text_buffer_get_max_undo_levels*(buffer: GtkTextBuffer): guint {.importc.}




# ============================================================================
# SCROLLED WINDOW
# ============================================================================

proc gtk_scrolled_window_new*(): GtkScrolledWindow {.importc.}
proc gtk_scrolled_window_set_child*(scrolledWindow: GtkScrolledWindow, child: GtkWidget) {.importc.}
proc gtk_scrolled_window_get_child*(scrolledWindow: GtkScrolledWindow): GtkWidget {.importc.}
proc gtk_scrolled_window_set_policy*(scrolledWindow: GtkScrolledWindow, hscrollbarPolicy: GtkPolicyType, vscrollbarPolicy: GtkPolicyType) {.importc.}
proc gtk_scrolled_window_get_policy*(scrolledWindow: GtkScrolledWindow, hscrollbarPolicy: ptr GtkPolicyType, vscrollbarPolicy: ptr GtkPolicyType) {.importc.}
proc gtk_scrolled_window_set_has_frame*(scrolledWindow: GtkScrolledWindow, hasFrame: gboolean) {.importc.}
proc gtk_scrolled_window_get_has_frame*(scrolledWindow: GtkScrolledWindow): gboolean {.importc.}


# ============================================================================
# FRAME
# ============================================================================

proc gtk_frame_new*(label: cstring): GtkFrame {.importc.}
proc gtk_frame_set_label*(frame: GtkFrame, label: cstring) {.importc.}
proc gtk_frame_get_label*(frame: GtkFrame): cstring {.importc.}
proc gtk_frame_set_child*(frame: GtkFrame, child: GtkWidget) {.importc.}
proc gtk_frame_get_child*(frame: GtkFrame): GtkWidget {.importc.}
# Label widget и alignment
# произвольный виджет вместо текстовой метки
proc gtk_frame_set_label_widget*(frame: GtkFrame, label_widget: GtkWidget) {.importc.}
proc gtk_frame_get_label_widget*(frame: GtkFrame): GtkWidget {.importc.}
# Выравнивание метки (0.0 = слева, 0.5 = по центру, 1.0 = справа)
proc gtk_frame_set_label_align*(frame: GtkFrame, xalign: cfloat) {.importc.}
proc gtk_frame_get_label_align*(frame: GtkFrame): cfloat {.importc.}



# ============================================================================
# SEPARATOR
# ============================================================================

proc gtk_separator_new*(orientation: GtkOrientation): GtkSeparator {.importc.}




# ============================================================================
# IMAGE
# ============================================================================

proc gtk_image_new*(): GtkImage {.importc.}
proc gtk_image_new_from_file*(filename: cstring): GtkImage {.importc.}
proc gtk_image_new_from_icon_name*(iconName: cstring): GtkImage {.importc.}
proc gtk_image_set_from_file*(image: GtkImage, filename: cstring) {.importc.}
proc gtk_image_set_from_icon_name*(image: GtkImage, iconName: cstring) {.importc.}
proc gtk_image_set_from_paintable*(image: GtkImage; paintable: GdkPaintable) {.importc.}
proc gtk_image_get_paintable*(image: GtkImage): GdkPaintable {.importc.}
proc gtk_image_set_pixel_size*(image: GtkImage, pixelSize: gint) {.importc.}
proc gtk_image_get_pixel_size*(image: GtkImage): gint {.importc.}

# Создание GtkImage из GdkPaintable (GdkTexture является подтипом GdkPaintable)
proc gtk_image_new_from_paintable*(paintable: GdkPaintable): GtkImage {.importc.}



# ============================================================================
# SPINNER
# ============================================================================

proc gtk_spinner_new*(): GtkSpinner {.importc.}
proc gtk_spinner_start*(spinner: GtkSpinner) {.importc.}
proc gtk_spinner_stop*(spinner: GtkSpinner) {.importc.}



# ============================================================================
# PROGRESS BAR
# ============================================================================

proc gtk_progress_bar_new*(): GtkProgressBar {.importc.}
proc gtk_progress_bar_set_fraction*(pbar: GtkProgressBar, fraction: gdouble) {.importc.}
proc gtk_progress_bar_get_fraction*(pbar: GtkProgressBar): gdouble {.importc.}
proc gtk_progress_bar_set_text*(pbar: GtkProgressBar, text: cstring) {.importc.}
proc gtk_progress_bar_get_text*(pbar: GtkProgressBar): cstring {.importc.}
proc gtk_progress_bar_set_show_text*(pbar: GtkProgressBar, showText: gboolean) {.importc.}
proc gtk_progress_bar_get_show_text*(pbar: GtkProgressBar): gboolean {.importc.}
proc gtk_progress_bar_pulse*(pbar: GtkProgressBar) {.importc.}

# ============================================================================
# SPIN BUTTON
# ============================================================================

proc gtk_spin_button_new*(adjustment: GtkAdjustment, climbRate: gdouble, digits: guint): GtkSpinButton {.importc.}
proc gtk_spin_button_new_with_range*(min: gdouble, max: gdouble, step: gdouble): GtkSpinButton {.importc.}
proc gtk_spin_button_set_adjustment*(spinButton: GtkSpinButton, adjustment: GtkAdjustment) {.importc.}
proc gtk_spin_button_get_adjustment*(spinButton: GtkSpinButton): GtkAdjustment {.importc.}
proc gtk_spin_button_set_digits*(spinButton: GtkSpinButton, digits: guint) {.importc.}
proc gtk_spin_button_get_digits*(spinButton: GtkSpinButton): guint {.importc.}
proc gtk_spin_button_set_value*(spinButton: GtkSpinButton, value: gdouble) {.importc.}
proc gtk_spin_button_get_value*(spinButton: GtkSpinButton): gdouble {.importc.}
proc gtk_spin_button_set_value_as_int*(spinButton: GtkSpinButton, value: gint) {.importc.}
proc gtk_spin_button_get_value_as_int*(spinButton: GtkSpinButton): gint {.importc.}
proc gtk_spin_button_set_range*(spinButton: GtkSpinButton, min: gdouble, max: gdouble) {.importc.}
proc gtk_spin_button_get_range*(spinButton: GtkSpinButton, min: ptr gdouble, max: ptr gdouble) {.importc.}

# ============================================================================
# ADJUSTMENT
# ============================================================================

proc gtk_adjustment_new*(value: gdouble, lower: gdouble, upper: gdouble, stepIncrement: gdouble, pageIncrement: gdouble, pageSize: gdouble): GtkAdjustment {.importc.}
proc gtk_adjustment_set_value*(adjustment: GtkAdjustment, value: gdouble) {.importc.}
proc gtk_adjustment_get_value*(adjustment: GtkAdjustment): gdouble {.importc.}
proc gtk_adjustment_set_lower*(adjustment: GtkAdjustment, lower: gdouble) {.importc.}
proc gtk_adjustment_get_lower*(adjustment: GtkAdjustment): gdouble {.importc.}
proc gtk_adjustment_set_upper*(adjustment: GtkAdjustment, upper: gdouble) {.importc.}
proc gtk_adjustment_get_upper*(adjustment: GtkAdjustment): gdouble {.importc.}


# ============================================================================
# SCALE
# ============================================================================
proc gtk_scale_new*(orientation: GtkOrientation, adjustment: GtkAdjustment): GtkScale {.importc.}
proc gtk_scale_new_with_range*(orientation: GtkOrientation, min: gdouble, max: gdouble, step: gdouble): GtkScale {.importc.}
proc gtk_scale_set_digits*(scale: GtkScale, digits: gint) {.importc.}
proc gtk_scale_get_digits*(scale: GtkScale): gint {.importc.}
proc gtk_scale_set_draw_value*(scale: GtkScale, drawValue: gboolean) {.importc.}
proc gtk_scale_get_draw_value*(scale: GtkScale): gboolean {.importc.}
proc gtk_scale_set_value_pos*(scale: GtkScale, pos: GtkPositionType) {.importc.}
proc gtk_scale_get_value_pos*(scale: GtkScale): GtkPositionType {.importc.}

proc gtk_range_set_value*(range: GtkRange; value: cdouble) {.importc.}


# ============================================================================
# COMBO BOX TEXT
# ============================================================================
proc gtk_combo_box_text_new*(): GtkComboBoxText {.importc.}
proc gtk_combo_box_text_new_with_entry*(): GtkComboBoxText {.importc.}
proc gtk_combo_box_text_append*(comboBox: GtkComboBoxText, id: cstring, text: cstring) {.importc.}
proc gtk_combo_box_text_prepend*(comboBox: GtkComboBoxText, id: cstring, text: cstring) {.importc.}
proc gtk_combo_box_text_insert*(comboBox: GtkComboBoxText, position: gint, id: cstring, text: cstring) {.importc.}
proc gtk_combo_box_text_append_text*(comboBox: GtkComboBoxText, text: cstring) {.importc.}
proc gtk_combo_box_text_prepend_text*(comboBox: GtkComboBoxText, text: cstring) {.importc.}
proc gtk_combo_box_text_insert_text*(comboBox: GtkComboBoxText, position: gint, text: cstring) {.importc.}
proc gtk_combo_box_text_remove*(comboBox: GtkComboBoxText, position: gint) {.importc.}
proc gtk_combo_box_text_remove_all*(comboBox: GtkComboBoxText) {.importc.}
proc gtk_combo_box_text_get_active_text*(comboBox: GtkComboBoxText): cstring {.importc.}

proc gtk_combo_box_set_active*(comboBox: GtkComboBox, index: gint) {.importc.}
proc gtk_combo_box_get_active*(comboBox: GtkComboBox): gint {.importc.}
proc gtk_combo_box_get_active_id*(comboBox: GtkComboBox): cstring {.importc.}
proc gtk_combo_box_set_active_id*(comboBox: GtkComboBox, activeId: cstring): gboolean {.importc.}

# ============================================================================
# LIST BOX
# ============================================================================

proc gtk_list_box_new*(): GtkListBox {.importc.}
proc gtk_list_box_prepend*(box: GtkListBox, child: GtkWidget) {.importc.}
proc gtk_list_box_append*(box: GtkListBox, child: GtkWidget) {.importc.}
proc gtk_list_box_insert*(box: GtkListBox, child: GtkWidget, position: gint) {.importc.}
proc gtk_list_box_remove*(box: GtkListBox, child: GtkWidget) {.importc.}
proc gtk_list_box_select_row*(box: GtkListBox, row: GtkListBoxRow) {.importc.}
proc gtk_list_box_unselect_row*(box: GtkListBox, row: GtkListBoxRow) {.importc.}
proc gtk_list_box_get_selected_row*(box: GtkListBox): GtkListBoxRow {.importc.}
proc gtk_list_box_set_selection_mode*(box: GtkListBox, mode: GtkSelectionMode) {.importc.}
proc gtk_list_box_get_selection_mode*(box: GtkListBox): GtkSelectionMode {.importc.}

proc gtk_list_box_row_new*(): GtkListBoxRow {.importc.}
proc gtk_list_box_row_set_child*(row: GtkListBoxRow, child: GtkWidget) {.importc.}
proc gtk_list_box_row_get_child*(row: GtkListBoxRow): GtkWidget {.importc.}
proc gtk_list_box_row_get_index*(row: GtkListBoxRow): gint {.importc.}



# ============================================================================
# NOTEBOOK
# ============================================================================

proc gtk_notebook_new*(): GtkNotebook {.importc.}
proc gtk_notebook_append_page*(notebook: GtkNotebook, child: GtkWidget, tabLabel: GtkWidget): gint {.importc.}
proc gtk_notebook_prepend_page*(notebook: GtkNotebook, child: GtkWidget, tabLabel: GtkWidget): gint {.importc.}
proc gtk_notebook_insert_page*(notebook: GtkNotebook, child: GtkWidget, tabLabel: GtkWidget, position: gint): gint {.importc.}
proc gtk_notebook_remove_page*(notebook: GtkNotebook, pageNum: gint) {.importc.}
proc gtk_notebook_get_current_page*(notebook: GtkNotebook): gint {.importc.}
proc gtk_notebook_set_current_page*(notebook: GtkNotebook, pageNum: gint) {.importc.}
proc gtk_notebook_get_nth_page*(notebook: GtkNotebook, pageNum: gint): GtkWidget {.importc.}
proc gtk_notebook_get_n_pages*(notebook: GtkNotebook): gint {.importc.}
proc gtk_notebook_set_tab_pos*(notebook: GtkNotebook, pos: GtkPositionType) {.importc.}
proc gtk_notebook_get_tab_pos*(notebook: GtkNotebook): GtkPositionType {.importc.}
proc gtk_notebook_set_show_tabs*(notebook: GtkNotebook, showTabs: gboolean) {.importc.}
proc gtk_notebook_get_show_tabs*(notebook: GtkNotebook): gboolean {.importc.}
proc gtk_notebook_set_scrollable*(notebook: GtkNotebook, scrollable: gboolean) {.importc.}


# ============================================================================
# PANED
# ============================================================================

proc gtk_paned_new*(orientation: GtkOrientation): GtkPaned {.importc.}
proc gtk_paned_set_start_child*(paned: GtkPaned, child: GtkWidget) {.importc.}
proc gtk_paned_get_start_child*(paned: GtkPaned): GtkWidget {.importc.}
proc gtk_paned_set_end_child*(paned: GtkPaned, child: GtkWidget) {.importc.}
proc gtk_paned_get_end_child*(paned: GtkPaned): GtkWidget {.importc.}
proc gtk_paned_set_position*(paned: GtkPaned, position: gint) {.importc.}
proc gtk_paned_get_position*(paned: GtkPaned): gint {.importc.}

# ============================================================================
# STACK
# ============================================================================

proc gtk_stack_new*(): GtkStack {.importc.}
proc gtk_stack_add_child*(stack: GtkStack, child: GtkWidget): GtkWidget {.importc.}
proc gtk_stack_add_named*(stack: GtkStack, child: GtkWidget, name: cstring): GtkWidget {.importc.}
proc gtk_stack_add_titled*(stack: GtkStack, child: GtkWidget, name: cstring, title: cstring): GtkWidget {.importc.}
proc gtk_stack_remove*(stack: GtkStack, child: GtkWidget) {.importc.}
proc gtk_stack_get_child_by_name*(stack: GtkStack, name: cstring): GtkWidget {.importc.}
proc gtk_stack_set_visible_child*(stack: GtkStack, child: GtkWidget) {.importc.}
proc gtk_stack_get_visible_child*(stack: GtkStack): GtkWidget {.importc.}
proc gtk_stack_set_visible_child_name*(stack: GtkStack, name: cstring) {.importc.}
proc gtk_stack_get_visible_child_name*(stack: GtkStack): cstring {.importc.}

proc gtk_stack_switcher_new*(): GtkStackSwitcher {.importc.}
proc gtk_stack_switcher_set_stack*(switcher: GtkStackSwitcher, stack: GtkStack) {.importc.}
proc gtk_stack_switcher_get_stack*(switcher: GtkStackSwitcher): GtkStack {.importc.}

proc gtk_stack_set_transition_type*(stack: GtkStack, transition: GtkStackTransitionType) {.importc.}
  ## Sets the type of animation that will be used for transitions between pages in stack.
  ## Available types include various kinds of fades and slides.

proc gtk_stack_set_transition_duration*(stack: GtkStack, duration: cuint) {.importc.}
  ## Sets the duration that transitions between pages in stack will take (in milliseconds).

# proc gtk_stack_add_named*(stack: GtkStack, child: GtkWidget, name: cstring): GtkStackPage {.importc.}
## Adds a child to stack. The child is identified by the name.
## Returns: The GtkStackPage for child.

proc gtk_stack_get_transition_type*(stack: GtkStack): GtkStackTransitionType {.importc.}
  ## Gets the type of animation that will be used for transitions between pages in stack.

proc gtk_stack_get_transition_duration*(stack: GtkStack): cuint {.importc.}
  ## Returns the amount of time (in milliseconds) that transitions between pages in stack will take.





# ============================================================================
# HEADER BAR
# ============================================================================

proc gtk_header_bar_new*(): GtkHeaderBar {.importc.}
proc gtk_header_bar_pack_start*(bar: GtkHeaderBar, child: GtkWidget) {.importc.}
proc gtk_header_bar_pack_end*(bar: GtkHeaderBar, child: GtkWidget) {.importc.}
proc gtk_header_bar_remove*(bar: GtkHeaderBar, child: GtkWidget) {.importc.}
proc gtk_header_bar_set_title_widget*(bar: GtkHeaderBar, titleWidget: GtkWidget) {.importc.}
proc gtk_header_bar_get_title_widget*(bar: GtkHeaderBar): GtkWidget {.importc.}
proc gtk_header_bar_set_show_title_buttons*(bar: GtkHeaderBar, setting: gboolean) {.importc.}
proc gtk_header_bar_get_show_title_buttons*(bar: GtkHeaderBar): gboolean {.importc.}
proc gtk_header_bar_set_decoration_layout*(bar: GtkHeaderBar, layout: cstring) {.importc.}
proc gtk_header_bar_get_decoration_layout*(bar: GtkHeaderBar): cstring {.importc.}

# ============================================================================
# MESSAGE DIALOG
# ============================================================================

proc gtk_message_dialog_new*(parent: GtkWindow, flags: gint, msgType: GtkMessageType, buttons: GtkButtonsType, messageFormat: cstring): GtkMessageDialog {.importc, varargs.}
proc gtk_message_dialog_set_markup*(messageDialog: GtkMessageDialog, str: cstring) {.importc.}

# ============================================================================
# DIALOG
# ============================================================================

proc gtk_dialog_new*(): GtkDialog {.importc.}
proc gtk_dialog_add_button*(dialog: GtkDialog, buttonText: cstring, responseId: gint): GtkWidget {.importc.}
proc gtk_dialog_add_action_widget*(dialog: GtkDialog, child: GtkWidget, responseId: gint) {.importc.}
proc gtk_dialog_set_default_response*(dialog: GtkDialog, responseId: gint) {.importc.}
proc gtk_dialog_get_content_area*(dialog: GtkDialog): GtkWidget {.importc.}
proc gtk_dialog_get_header_bar*(dialog: GtkDialog): GtkWidget {.importc.}
proc gtk_dialog_response*(dialog: GtkDialog, responseId: gint) {.importc.}

# ============================================================================
# FILE CHOOSER
# ============================================================================

proc gtk_file_chooser_dialog_new*(title: cstring, parent: GtkWindow, action: GtkFileChooserAction, firstButtonText: cstring): GtkFileChooserDialog {.importc, varargs.}
proc gtk_file_chooser_set_current_name*(chooser: GtkFileChooser, name: cstring) {.importc.}
proc gtk_file_chooser_get_file*(chooser: GtkFileChooser): GFile {.importc.}
proc gtk_file_chooser_set_file*(chooser: GtkFileChooser, file: GFile, error: ptr GError): gboolean {.importc.}
proc gtk_file_chooser_select_file*(chooser: GtkFileChooser, file: GFile, error: ptr GError): gboolean {.importc.}
proc gtk_file_chooser_set_current_folder*(chooser: GtkFileChooser, file: GFile, error: ptr GError): gboolean {.importc.}
proc gtk_file_chooser_get_current_folder*(chooser: GtkFileChooser): GFile {.importc.}

# ============================================================================
# DRAWING AREA
# ============================================================================

proc gtk_drawing_area_new*(): GtkDrawingArea {.importc.}
proc gtk_drawing_area_set_content_width*(area: GtkDrawingArea, width: gint) {.importc.}
proc gtk_drawing_area_get_content_width*(area: GtkDrawingArea): gint {.importc.}
proc gtk_drawing_area_set_content_height*(area: GtkDrawingArea, height: gint) {.importc.}
proc gtk_drawing_area_get_content_height*(area: GtkDrawingArea): gint {.importc.}
proc gtk_drawing_area_set_draw_func*(area: GtkDrawingArea, drawFunc: pointer, userData: gpointer, destroy: GDestroyNotify) {.importc.}



# ============================================================================
# CSS PROVIDER
# ============================================================================

proc gtk_css_provider_new*(): GtkCssProvider {.importc.}
proc gtk_css_provider_load_from_data*(cssProvider: GtkCssProvider, data: cstring, length: gssize) {.importc.}
proc gtk_css_provider_load_from_file*(cssProvider: GtkCssProvider, file: GFile) {.importc.}
proc gtk_css_provider_load_from_path*(cssProvider: GtkCssProvider, path: cstring) {.importc.}




# ============================================================================
# STYLE CONTEXT & DISPLAY
# ============================================================================

proc gtk_widget_get_style_context*(widget: GtkWidget): GtkStyleContext {.importc.}
proc gtk_style_context_add_provider*(context: GtkStyleContext, provider: pointer, priority: guint) {.importc.}
proc gtk_style_context_add_provider_for_display*(display: pointer, provider: pointer, priority: guint) {.importc.}

proc gtk_widget_get_display*(widget: GtkWidget): GdkDisplay {.importc.}
proc gtk_css_provider_load_from_string*(css_provider: GtkCssProvider, string: cstring) {.importc.}





# ============================================================================
# DISPLAY
# ============================================================================

proc gdk_display_get_default*(): pointer {.importc.}

# ============================================================================
# GFILE
# ============================================================================

proc g_file_new_for_path*(path: cstring): GFile {.importc.}
proc g_file_get_path*(file: GFile): cstring {.importc.}
proc g_file_get_basename*(file: GFile): cstring {.importc.}

# ============================================================================
# GERROR
# ============================================================================

proc g_error_free*(error: GError) {.importc.}

# ============================================================================
# GVARIANT
# ============================================================================

proc g_variant_new_string*(str: cstring): GVariant {.importc.}
proc g_variant_new_boolean*(value: gboolean): GVariant {.importc.}
proc g_variant_new_int32*(value: gint32): GVariant {.importc.}
proc g_variant_get_string*(value: GVariant, length: ptr gsize): cstring {.importc.}
proc g_variant_get_boolean*(value: GVariant): gboolean {.importc.}
proc g_variant_get_int32*(value: GVariant): gint32 {.importc.}

# ============================================================================
# GOBJECT
# ============================================================================

proc g_object_ref*(obj: gpointer): gpointer {.importc.}
proc g_object_unref*(obj: gpointer) {.importc.}
proc g_object_set_data*(obj: GObject, key: cstring, data: gpointer) {.importc.}
proc g_object_get_data*(obj: GObject, key: cstring): gpointer {.importc.}
# Управление свойствами
proc g_object_set*(obj: GObject, firstPropertyName: cstring) {.importc, varargs.}
proc g_object_get*(obj: GObject, firstPropertyName: cstring) {.importc, varargs.}
proc g_object_set_property*(obj: GObject, propertyName: cstring, value: pointer) {.importc.}
proc g_object_get_property*(obj: GObject, propertyName: cstring, value: pointer) {.importc.}
# Уведомления об изменениях свойств
proc g_object_notify*(obj: GObject, propertyName: cstring) {.importc.}
proc g_object_notify_by_pspec*(obj: GObject, pspec: pointer) {.importc.}
proc g_object_freeze_notify*(obj: GObject) {.importc.}
proc g_object_thaw_notify*(obj: GObject) {.importc.}
# Управление ссылками с данными
proc g_object_set_data_full*(obj: GObject, key: cstring, data: gpointer, destroy: pointer) {.importc.}
proc g_object_steal_data*(obj: GObject, key: cstring): gpointer {.importc.}
# Weak references (слабые ссылки)
proc g_object_weak_ref*(obj: GObject, notify: pointer, data: gpointer) {.importc.}
proc g_object_weak_unref*(obj: GObject, notify: pointer, data: gpointer) {.importc.}
proc g_object_add_weak_pointer*(obj: GObject, weakPointerLocation: ptr gpointer) {.importc.}
proc g_object_remove_weak_pointer*(obj: GObject, weakPointerLocation: ptr gpointer) {.importc.}
# Toggle references (для языковых биндингов)
proc g_object_add_toggle_ref*(obj: GObject, notify: pointer, data: gpointer) {.importc.}
proc g_object_remove_toggle_ref*(obj: GObject, notify: pointer, data: gpointer) {.importc.}
# Проверка типов
proc g_object_is_floating*(obj: GObject): gboolean {.importc.}
proc g_object_ref_sink*(obj: gpointer): gpointer {.importc.}
proc g_object_force_floating*(obj: GObject) {.importc.}
# Информация о типе
proc g_object_get_type*(): GType {.importc.}
proc g_object_class_find_property*(oclass: pointer, propertyName: cstring): pointer {.importc.}
proc g_object_class_list_properties*(oclass: pointer, nProperties: ptr cuint): ptr pointer {.importc.}
# Создание объектов
proc g_object_new*(objectType: GType, firstPropertyName: cstring): gpointer {.importc, varargs.}
proc g_object_newv*(objectType: GType, nParameters: cuint, parameters: pointer): gpointer {.importc.}
# Соединение данных с объектами
proc g_object_set_qdata*(obj: GObject, quark: GQuark, data: gpointer) {.importc.}
proc g_object_get_qdata*(obj: GObject, quark: GQuark): gpointer {.importc.}
proc g_object_set_qdata_full*(obj: GObject, quark: GQuark, data: gpointer, destroy: pointer) {.importc.}
proc g_object_steal_qdata*(obj: GObject, quark: GQuark): gpointer {.importc.}
# Связывание свойств (property binding)
proc g_object_bind_property*(source: GObject, sourceProperty: cstring, target: GObject, targetProperty: cstring, flags: GBindingFlags): pointer {.importc.}
proc g_object_bind_property_full*(source: GObject, sourceProperty: cstring, target: GObject, targetProperty: cstring, flags: GBindingFlags, transformTo: pointer, transformFrom: pointer, userData: gpointer, notify: pointer): pointer {.importc.}
# Функции для работы с GQuark
proc g_quark_from_string*(str: cstring): GQuark {.importc.}
proc g_quark_to_string*(quark: GQuark): cstring {.importc.}
proc g_quark_try_string*(str: cstring): GQuark {.importc.}


# ============================================================================
# POPOVER
# ============================================================================

proc gtk_popover_new*(): GtkPopover {.importc.}
proc gtk_popover_set_child*(popover: GtkPopover, child: GtkWidget) {.importc.}
proc gtk_popover_get_child*(popover: GtkPopover): GtkWidget {.importc.}
proc gtk_popover_popup*(popover: GtkPopover) {.importc.}
proc gtk_popover_popdown*(popover: GtkPopover) {.importc.}
proc gtk_popover_set_parent*(popover: GtkPopover, parent: GtkWidget) {.importc.}
proc gtk_widget_get_ancestor*(widget: GtkWidget, widget_type: GType): GtkWidget  {.importc.}
proc gtk_popover_get_type*(): GType {.importc.}




# ============================================================================
# MENU BUTTON
# ============================================================================

proc gtk_menu_button_new*(): GtkMenuButton {.importc.}
proc gtk_menu_button_set_label*(button: GtkMenuButton, label: cstring) {.importc.}
proc gtk_menu_button_set_popover*(menuButton: GtkMenuButton, popover: GtkWidget) {.importc.}
proc gtk_menu_button_get_popover*(menuButton: GtkMenuButton): GtkPopover {.importc.}
proc gtk_menu_button_set_menu_model*(menuButton: GtkMenuButton, menuModel: GMenuModel) {.importc.}
proc gtk_menu_button_get_menu_model*(menuButton: GtkMenuButton): GMenuModel {.importc.}
proc gtk_menu_button_set_icon_name*(menuButton: GtkMenuButton, iconName: cstring) {.importc.}
proc gtk_menu_button_get_icon_name*(menuButton: GtkMenuButton): cstring {.importc.}
proc gtk_menu_button_get_active*(menuButton: GtkMenuButton): gboolean {.importc.}
proc gtk_menu_button_set_active*(menuButton: GtkMenuButton, active: gboolean) {.importc.}
proc gtk_menu_button_popup*(menuButton: GtkMenuButton) {.importc.}
proc gtk_menu_button_popdown*(menuButton: GtkMenuButton) {.importc.}
# Направление открытия меню
proc gtk_menu_button_set_direction*(menuButton: GtkMenuButton, direction: GtkArrowType) {.importc.}
proc gtk_menu_button_get_direction*(menuButton: GtkMenuButton): GtkArrowType {.importc.}
# Использование underline для мнемоник
proc gtk_menu_button_set_use_underline*(menuButton: GtkMenuButton, useUnderline: gboolean) {.importc.}
proc gtk_menu_button_get_use_underline*(menuButton: GtkMenuButton): gboolean {.importc.}
# Установка дочернего виджета (вместо label/icon)
proc gtk_menu_button_set_child*(menuButton: GtkMenuButton, child: GtkWidget) {.importc.}
proc gtk_menu_button_get_child*(menuButton: GtkMenuButton): GtkWidget {.importc.}
# Установка виджета для отображения с иконкой
proc gtk_menu_button_set_has_frame*(menuButton: GtkMenuButton, hasFrame: gboolean) {.importc.}
proc gtk_menu_button_get_has_frame*(menuButton: GtkMenuButton): gboolean {.importc.}
# Основной виджет (для позиционирования popover относительно него)
proc gtk_menu_button_set_primary*(menuButton: GtkMenuButton, primary: gboolean) {.importc.}
proc gtk_menu_button_get_primary*(menuButton: GtkMenuButton): gboolean {.importc.}
# Создание popover из модели меню (альтернатива set_menu_model)
proc gtk_menu_button_set_create_popup_func*(menuButton: GtkMenuButton, callback: pointer, userData: pointer, destroyNotify: pointer) {.importc.}
# Управление отображением стрелки
proc gtk_menu_button_set_always_show_arrow*(menuButton: GtkMenuButton, alwaysShowArrow: gboolean) {.importc.}
proc gtk_menu_button_get_always_show_arrow*(menuButton: GtkMenuButton): gboolean {.importc.}


# ============================================================================
# EXPANDER
# ============================================================================

proc gtk_expander_new*(label: cstring): GtkExpander {.importc.}
proc gtk_expander_new_with_mnemonic*(label: cstring): GtkExpander {.importc.}
proc gtk_expander_set_expanded*(expander: GtkExpander, expanded: gboolean) {.importc.}
proc gtk_expander_get_expanded*(expander: GtkExpander): gboolean {.importc.}
proc gtk_expander_set_label*(expander: GtkExpander, label: cstring) {.importc.}
proc gtk_expander_get_label*(expander: GtkExpander): cstring {.importc.}
proc gtk_expander_set_child*(expander: GtkExpander, child: GtkWidget) {.importc.}
proc gtk_expander_get_child*(expander: GtkExpander): GtkWidget {.importc.}

# ============================================================================
# CALENDAR
# ============================================================================

proc gtk_calendar_new*(): GtkCalendar {.importc.}
proc gtk_calendar_select_day*(calendar: GtkCalendar, day: gint) {.importc.}
proc gtk_calendar_mark_day*(calendar: GtkCalendar, day: gint) {.importc.}
proc gtk_calendar_unmark_day*(calendar: GtkCalendar, day: gint) {.importc.}
proc gtk_calendar_clear_marks*(calendar: GtkCalendar) {.importc.}

# ============================================================================
# OVERLAY
# ============================================================================

proc gtk_overlay_new*(): GtkOverlay {.importc.}
proc gtk_overlay_set_child*(overlay: GtkOverlay, child: GtkWidget) {.importc.}
proc gtk_overlay_get_child*(overlay: GtkOverlay): GtkWidget {.importc.}
proc gtk_overlay_add_overlay*(overlay: GtkOverlay, widget: GtkWidget) {.importc.}
proc gtk_overlay_remove_overlay*(overlay: GtkOverlay, widget: GtkWidget) {.importc.}

# ============================================================================
# FIXED
# ============================================================================

proc gtk_fixed_new*(): GtkFixed {.importc.}
proc gtk_fixed_put*(fixed: GtkFixed, widget: GtkWidget, x: gdouble, y: gdouble) {.importc.}
proc gtk_fixed_move*(fixed: GtkFixed, widget: GtkWidget, x: gdouble, y: gdouble) {.importc.}
proc gtk_fixed_remove*(fixed: GtkFixed, widget: GtkWidget) {.importc.}

# ============================================================================
# ASPECT FRAME
# ============================================================================

proc gtk_aspect_frame_new*(xalign: gfloat, yalign: gfloat, ratio: gfloat, obeyChild: gboolean): GtkAspectFrame {.importc.}
proc gtk_aspect_frame_set_xalign*(aspectFrame: GtkAspectFrame, xalign: gfloat) {.importc.}
proc gtk_aspect_frame_get_xalign*(aspectFrame: GtkAspectFrame): gfloat {.importc.}
proc gtk_aspect_frame_set_yalign*(aspectFrame: GtkAspectFrame, yalign: gfloat) {.importc.}
proc gtk_aspect_frame_get_yalign*(aspectFrame: GtkAspectFrame): gfloat {.importc.}
proc gtk_aspect_frame_set_ratio*(aspectFrame: GtkAspectFrame, ratio: gfloat) {.importc.}
proc gtk_aspect_frame_get_ratio*(aspectFrame: GtkAspectFrame): gfloat {.importc.}
proc gtk_aspect_frame_set_obey_child*(aspectFrame: GtkAspectFrame, obeyChild: gboolean) {.importc.}
proc gtk_aspect_frame_get_obey_child*(aspectFrame: GtkAspectFrame): gboolean {.importc.}
proc gtk_aspect_frame_set_child*(aspectFrame: GtkAspectFrame, child: GtkWidget) {.importc.}
proc gtk_aspect_frame_get_child*(aspectFrame: GtkAspectFrame): GtkWidget {.importc.}

# ============================================================================
# INFO BAR
# WARNING: InfoBar is deprecated in GTK4.
# ============================================================================

when not defined(GTK_DISABLE_DEPRECATED):
  proc gtk_info_bar_new*(): GtkInfoBar {.importc.}
  proc gtk_info_bar_add_button*(infoBar: GtkInfoBar, buttonText: cstring, responseId: gint) {.importc.}
  proc gtk_info_bar_add_child*(infoBar: GtkInfoBar, widget: GtkWidget) {.importc.}
  proc gtk_info_bar_remove_child*(infoBar: GtkInfoBar, widget: GtkWidget) {.importc.}
  proc gtk_info_bar_set_message_type*(infoBar: GtkInfoBar, messageType: GtkMessageType) {.importc.}
  proc gtk_info_bar_get_message_type*(infoBar: GtkInfoBar): GtkMessageType {.importc.}
  proc gtk_info_bar_set_show_close_button*(infoBar: GtkInfoBar, setting: gboolean) {.importc.}
  proc gtk_info_bar_get_show_close_button*(infoBar: GtkInfoBar): gboolean {.importc.}
  proc gtk_info_bar_set_revealed*(infoBar: GtkInfoBar, revealed: gboolean) {.importc.}
  proc gtk_info_bar_get_revealed*(infoBar: GtkInfoBar): gboolean {.importc.}

# ============================================================================
# STATUSBAR
# WARNING: Statusbar is deprecated in GTK4.
# ============================================================================

when not defined(GTK_DISABLE_DEPRECATED):
  proc gtk_statusbar_new*(): GtkStatusbar {.importc.}
  proc gtk_statusbar_get_context_id*(statusbar: GtkStatusbar, contextDescription: cstring): guint {.importc.}
  proc gtk_statusbar_push*(statusbar: GtkStatusbar, contextId: guint, text: cstring): guint {.importc.}
  proc gtk_statusbar_pop*(statusbar: GtkStatusbar, contextId: guint) {.importc.}
  proc gtk_statusbar_remove*(statusbar: GtkStatusbar, contextId: guint, messageId: guint) {.importc.}
  proc gtk_statusbar_remove_all*(statusbar: GtkStatusbar, contextId: guint) {.importc.}

# ============================================================================
# LEVEL BAR
# ============================================================================

proc gtk_level_bar_new*(): GtkLevelBar {.importc.}
proc gtk_level_bar_new_for_interval*(minValue: gdouble, maxValue: gdouble): GtkLevelBar {.importc.}
proc gtk_level_bar_set_value*(levelBar: GtkLevelBar, value: gdouble) {.importc.}
proc gtk_level_bar_get_value*(levelBar: GtkLevelBar): gdouble {.importc.}
proc gtk_level_bar_set_min_value*(levelBar: GtkLevelBar, value: gdouble) {.importc.}
proc gtk_level_bar_get_min_value*(levelBar: GtkLevelBar): gdouble {.importc.}
proc gtk_level_bar_set_max_value*(levelBar: GtkLevelBar, value: gdouble) {.importc.}
proc gtk_level_bar_get_max_value*(levelBar: GtkLevelBar): gdouble {.importc.}

# ============================================================================
# LINK BUTTON
# ============================================================================

proc gtk_link_button_new*(uri: cstring): GtkLinkButton {.importc.}
proc gtk_link_button_new_with_label*(uri: cstring, label: cstring): GtkLinkButton {.importc.}
proc gtk_link_button_set_uri*(linkButton: GtkLinkButton, uri: cstring) {.importc.}
proc gtk_link_button_get_uri*(linkButton: GtkLinkButton): cstring {.importc.}
proc gtk_link_button_set_visited*(linkButton: GtkLinkButton, visited: gboolean) {.importc.}
proc gtk_link_button_get_visited*(linkButton: GtkLinkButton): gboolean {.importc.}

# ============================================================================
# ACTION BAR
# ============================================================================

proc gtk_action_bar_new*(): GtkActionBar {.importc.}
proc gtk_action_bar_pack_start*(actionBar: GtkActionBar, child: GtkWidget) {.importc.}
proc gtk_action_bar_pack_end*(actionBar: GtkActionBar, child: GtkWidget) {.importc.}
proc gtk_action_bar_remove*(actionBar: GtkActionBar, child: GtkWidget) {.importc.}
proc gtk_action_bar_set_center_widget*(actionBar: GtkActionBar, centerWidget: GtkWidget) {.importc.}
proc gtk_action_bar_get_center_widget*(actionBar: GtkActionBar): GtkWidget {.importc.}

# ============================================================================
# SEARCH BAR
# ============================================================================

proc gtk_search_bar_new*(): GtkSearchBar {.importc.}
proc gtk_search_bar_set_child*(searchBar: GtkSearchBar, child: GtkWidget) {.importc.}
proc gtk_search_bar_get_child*(searchBar: GtkSearchBar): GtkWidget {.importc.}
proc gtk_search_bar_set_search_mode*(searchBar: GtkSearchBar, searchMode: gboolean) {.importc.}
proc gtk_search_bar_get_search_mode*(searchBar: GtkSearchBar): gboolean {.importc.}
proc gtk_search_bar_set_show_close_button*(searchBar: GtkSearchBar, visible: gboolean) {.importc.}
proc gtk_search_bar_get_show_close_button*(searchBar: GtkSearchBar): gboolean {.importc.}

# ============================================================================
# PICTURE
# ============================================================================

proc gtk_picture_new*(): GtkPicture {.importc.}
proc gtk_picture_new_for_file*(file: GFile): GtkPicture {.importc.}
proc gtk_picture_new_for_filename*(filename: cstring): GtkPicture {.importc.}
proc gtk_picture_set_file*(picture: GtkPicture, file: GFile) {.importc.}
proc gtk_picture_get_file*(picture: GtkPicture): GFile {.importc.}
proc gtk_picture_set_filename*(picture: GtkPicture, filename: cstring) {.importc.}
proc gtk_picture_set_pixbuf*(picture: GtkPicture, pixbuf: GdkPixbuf) {.importc.}
proc gtk_picture_set_paintable*(picture: GtkPicture, paintable: pointer) {.importc.}
proc gtk_picture_set_can_shrink*(picture: GtkPicture, canShrink: gboolean) {.importc.}
proc gtk_picture_get_can_shrink*(picture: GtkPicture): gboolean {.importc.}

# ============================================================================
# FLOW BOX
# ============================================================================

proc gtk_flow_box_new*(): GtkFlowBox {.importc.}
proc gtk_flow_box_insert*(box: GtkFlowBox, widget: GtkWidget, position: gint) {.importc.}
proc gtk_flow_box_append*(box: GtkFlowBox, widget: GtkWidget) {.importc.}
proc gtk_flow_box_prepend*(box: GtkFlowBox, widget: GtkWidget) {.importc.}
proc gtk_flow_box_remove*(box: GtkFlowBox, widget: GtkWidget) {.importc.}
proc gtk_flow_box_set_homogeneous*(box: GtkFlowBox, homogeneous: gboolean) {.importc.}
proc gtk_flow_box_get_homogeneous*(box: GtkFlowBox): gboolean {.importc.}
proc gtk_flow_box_set_row_spacing*(box: GtkFlowBox, spacing: guint) {.importc.}
proc gtk_flow_box_get_row_spacing*(box: GtkFlowBox): guint {.importc.}
proc gtk_flow_box_set_column_spacing*(box: GtkFlowBox, spacing: guint) {.importc.}
proc gtk_flow_box_get_column_spacing*(box: GtkFlowBox): guint {.importc.}
proc gtk_flow_box_set_min_children_per_line*(box: GtkFlowBox, nChildren: guint) {.importc.}
proc gtk_flow_box_get_min_children_per_line*(box: GtkFlowBox): guint {.importc.}
proc gtk_flow_box_set_max_children_per_line*(box: GtkFlowBox, nChildren: guint) {.importc.}
proc gtk_flow_box_get_max_children_per_line*(box: GtkFlowBox): guint {.importc.}
proc gtk_flow_box_set_selection_mode*(box: GtkFlowBox, mode: GtkSelectionMode) {.importc.}
proc gtk_flow_box_get_selection_mode*(box: GtkFlowBox): GtkSelectionMode {.importc.}

proc gtk_flow_box_child_new*(): GtkFlowBoxChild {.importc.}
proc gtk_flow_box_child_set_child*(child: GtkFlowBoxChild, widget: GtkWidget) {.importc.}
proc gtk_flow_box_child_get_child*(child: GtkFlowBoxChild): GtkWidget {.importc.}
proc gtk_flow_box_child_get_index*(child: GtkFlowBoxChild): gint {.importc.}

# ============================================================================
# VIEWPORT
# ============================================================================

proc gtk_viewport_new*(hadjustment: GtkAdjustment, vadjustment: GtkAdjustment): GtkViewport {.importc.}
proc gtk_viewport_set_child*(viewport: GtkViewport, child: GtkWidget) {.importc.}
proc gtk_viewport_get_child*(viewport: GtkViewport): GtkWidget {.importc.}
proc gtk_viewport_set_scroll_to_focus*(viewport: GtkViewport, scrollToFocus: gboolean) {.importc.}
proc gtk_viewport_get_scroll_to_focus*(viewport: GtkViewport): gboolean {.importc.}

# ============================================================================
# ABOUT DIALOG
# ============================================================================

proc gtk_about_dialog_new*(): GtkAboutDialog {.importc.}
proc gtk_about_dialog_set_program_name*(about: GtkAboutDialog, name: cstring) {.importc.}
proc gtk_about_dialog_get_program_name*(about: GtkAboutDialog): cstring {.importc.}
proc gtk_about_dialog_set_version*(about: GtkAboutDialog, version: cstring) {.importc.}
proc gtk_about_dialog_get_version*(about: GtkAboutDialog): cstring {.importc.}
proc gtk_about_dialog_set_copyright*(about: GtkAboutDialog, copyright: cstring) {.importc.}
proc gtk_about_dialog_get_copyright*(about: GtkAboutDialog): cstring {.importc.}
proc gtk_about_dialog_set_comments*(about: GtkAboutDialog, comments: cstring) {.importc.}
proc gtk_about_dialog_get_comments*(about: GtkAboutDialog): cstring {.importc.}
proc gtk_about_dialog_set_license*(about: GtkAboutDialog, license: cstring) {.importc.}
proc gtk_about_dialog_get_license*(about: GtkAboutDialog): cstring {.importc.}
proc gtk_about_dialog_set_website*(about: GtkAboutDialog, website: cstring) {.importc.}
proc gtk_about_dialog_get_website*(about: GtkAboutDialog): cstring {.importc.}
proc gtk_about_dialog_set_website_label*(about: GtkAboutDialog, websiteLabel: cstring) {.importc.}
proc gtk_about_dialog_get_website_label*(about: GtkAboutDialog): cstring {.importc.}
proc gtk_about_dialog_set_authors*(about: GtkAboutDialog, authors: ptr cstring) {.importc.}
proc gtk_about_dialog_get_authors*(about: GtkAboutDialog): ptr cstring {.importc.}
proc gtk_about_dialog_set_logo*(about: GtkAboutDialog, logo: pointer) {.importc.}
proc gtk_about_dialog_get_logo*(about: GtkAboutDialog): pointer {.importc.}
proc gtk_about_dialog_set_logo_icon_name*(about: GtkAboutDialog, iconName: cstring) {.importc.}
proc gtk_about_dialog_get_logo_icon_name*(about: GtkAboutDialog): cstring {.importc.}

# ============================================================================
# COLOR CHOOSER DIALOG
# ============================================================================

proc gtk_color_chooser_dialog_new*(title: cstring, parent: GtkWindow): GtkColorChooserDialog {.importc.}
proc gtk_color_chooser_get_rgba*(chooser: GtkColorChooser, color: pointer) {.importc.}
proc gtk_color_chooser_set_rgba*(chooser: GtkColorChooser, color: pointer) {.importc.}
proc gtk_color_chooser_set_use_alpha*(chooser: GtkColorChooser, useAlpha: gboolean) {.importc.}
proc gtk_color_chooser_get_use_alpha*(chooser: GtkColorChooser): gboolean {.importc.}

# ============================================================================
# FONT CHOOSER DIALOG
# ============================================================================

proc gtk_font_chooser_dialog_new*(title: cstring, parent: GtkWindow): GtkFontChooserDialog {.importc.}
proc gtk_font_chooser_get_font*(fontchooser: GtkFontChooser): cstring {.importc.}
proc gtk_font_chooser_set_font*(fontchooser: GtkFontChooser, fontname: cstring) {.importc.}
proc gtk_font_chooser_get_font_desc*(fontchooser: GtkFontChooser): pointer {.importc.}
proc gtk_font_chooser_set_font_desc*(fontchooser: GtkFontChooser, fontDesc: pointer) {.importc.}
proc gtk_font_chooser_get_preview_text*(fontchooser: GtkFontChooser): cstring {.importc.}
proc gtk_font_chooser_set_preview_text*(fontchooser: GtkFontChooser, text: cstring) {.importc.}

# ============================================================================
# GL AREA
# ============================================================================

proc gtk_gl_area_new*(): GtkGLArea {.importc.}
proc gtk_gl_area_make_current*(area: GtkGLArea) {.importc.}
proc gtk_gl_area_queue_render*(area: GtkGLArea) {.importc.}
proc gtk_gl_area_attach_buffers*(area: GtkGLArea) {.importc.}
proc gtk_gl_area_set_required_version*(area: GtkGLArea, major: gint, minor: gint) {.importc.}
proc gtk_gl_area_get_required_version*(area: GtkGLArea, major: ptr gint, minor: ptr gint) {.importc.}
proc gtk_gl_area_set_has_depth_buffer*(area: GtkGLArea, hasDepthBuffer: gboolean) {.importc.}
proc gtk_gl_area_get_has_depth_buffer*(area: GtkGLArea): gboolean {.importc.}
proc gtk_gl_area_set_has_stencil_buffer*(area: GtkGLArea, hasStencilBuffer: gboolean) {.importc.}
proc gtk_gl_area_get_has_stencil_buffer*(area: GtkGLArea): gboolean {.importc.}

# ============================================================================
# CLIPBOARD
# ============================================================================

proc gdk_display_get_clipboard*(display: pointer): GdkClipboard {.importc.}
proc gdk_clipboard_set_text*(clipboard: GdkClipboard, text: cstring) {.importc.}
proc gdk_clipboard_read_text_async*(clipboard: GdkClipboard, cancellable: pointer, callback: GAsyncReadyCallback, userData: gpointer) {.importc.}
proc gdk_clipboard_read_text_finish*(clipboard: GdkClipboard, res: pointer, error: ptr GError): cstring {.importc.}



# ============================================================================
# PIXBUF
# ============================================================================

proc gdk_pixbuf_new*(colorspace: gint, hasAlpha: gboolean, bitsPerSample: gint, width: gint, height: gint): GdkPixbuf {.importc.}
proc gdk_pixbuf_new_from_file*(filename: cstring, error: ptr GError): GdkPixbuf {.importc.}
proc gdk_pixbuf_get_width*(pixbuf: GdkPixbuf): gint {.importc.}
proc gdk_pixbuf_get_height*(pixbuf: GdkPixbuf): gint {.importc.}
proc gdk_pixbuf_scale_simple*(src: GdkPixbuf, destWidth: gint, destHeight: gint, interpType: gint): GdkPixbuf {.importc.}
proc gdk_pixbuf_savev*(pixbuf: GdkPixbuf, filename: cstring, `type`: cstring, optionKeys: ptr cstring, optionValues: ptr cstring, error: ptr GError): gboolean {.importc.}
proc g_memory_input_stream_new_from_bytes*(bytes: GBytes): pointer {.importc.}
proc gdk_pixbuf_new_from_stream*(stream: pointer, cancellable: pointer, error: ptr GError): GdkPixbuf {.importc.}
proc gtk_window_set_default_icon_list*(list: openArray[GdkPixbuf]) {.importc.}

# Для загрузки изображений из памяти
proc gdk_pixbuf_loader_new*(): pointer {.importc.}
proc gdk_pixbuf_loader_write*(loader: pointer, buf: ptr uint8, count: csize_t, 
                               error: ptr GError): gboolean {.importc.}
proc gdk_pixbuf_loader_close*(loader: pointer, error: ptr GError): gboolean {.importc.}
proc gdk_pixbuf_loader_get_pixbuf*(loader: pointer): GdkPixbuf {.importc.}





# ============================================================================
# TEXTURE
# ============================================================================

proc gdk_texture_new_for_pixbuf*(pixbuf: GdkPixbuf): GdkTexture {.importc.}
proc gdk_texture_new_from_file*(file: GFile, error: ptr GError): GdkTexture {.importc.}
proc gdk_texture_get_width*(texture: GdkTexture): gint {.importc.}
proc gdk_texture_get_height*(texture: GdkTexture): gint {.importc.}
proc gdk_texture_new_from_bytes*(bytes: GBytes, error: ptr GError): GdkTexture {.importc.}
proc g_bytes_new_static*(data: pointer, size: csize_t): GBytes {.importc.}
proc g_bytes_unref*(bytes: GBytes) {.importc.}
proc gdk_texture_new_from_filename*(filename: cstring; error: pointer): GdkTexture {.importc.}



# ============================================================================
# GLIB UTILITIES
# ============================================================================

proc g_free*(mem: gpointer) {.importc.}
proc g_malloc*(nBytes: gsize): gpointer {.importc.}
proc g_malloc0*(nBytes: gsize): gpointer {.importc.}
proc g_strdup*(str: cstring): cstring {.importc.}
proc g_strdup_printf*(format: cstring): cstring {.importc, varargs.}
proc g_strcmp0*(str1: cstring, str2: cstring): gint {.importc.}

# ============================================================================
# IDLE AND TIMEOUT FUNCTIONS
# ============================================================================

proc g_timeout_add*(interval: guint, function: GSourceFunc, data: gpointer): guint {.importc.}
proc g_timeout_add_seconds*(interval: guint, function: GSourceFunc, data: gpointer): guint {.importc.}
proc g_idle_add*(function: GSourceFunc, data: gpointer): guint {.importc.}
proc g_source_remove*(tag: guint): gboolean {.importc.}

# ============================================================================
# MAIN LOOP
# ============================================================================

proc g_main_loop_new*(context: pointer, isRunning: gboolean): pointer {.importc.}
proc g_main_loop_run*(loop: pointer) {.importc.}
proc g_main_loop_quit*(loop: pointer) {.importc.}

# ============================================================================
# TREE MODEL & STORE
# WARNING: These APIs are deprecated in GTK4 and removed when GTK_DISABLE_DEPRECATED is defined.
# Consider using GtkListView, GtkColumnView, or GtkTreeExpander instead.
# ============================================================================

when not defined(GTK_DISABLE_DEPRECATED):
  proc gtk_list_store_new*(nColumns: gint): GtkListStore {.importc, varargs.}
  proc gtk_list_store_newv*(nColumns: gint, types: ptr GType): GtkListStore {.importc.}
  proc gtk_list_store_append*(listStore: GtkListStore, iter: ptr GtkTreeIter) {.importc.}
  proc gtk_list_store_prepend*(listStore: GtkListStore, iter: ptr GtkTreeIter) {.importc.}
  proc gtk_list_store_insert*(listStore: GtkListStore, iter: ptr GtkTreeIter, position: gint) {.importc.}
  proc gtk_list_store_remove*(listStore: GtkListStore, iter: ptr GtkTreeIter): gboolean {.importc.}
  proc gtk_list_store_clear*(listStore: GtkListStore) {.importc.}
  proc gtk_list_store_set*(listStore: GtkListStore, iter: ptr GtkTreeIter) {.importc, varargs.}
  proc gtk_tree_store_new*(nColumns: gint): GtkTreeStore {.importc, varargs.}
  proc gtk_tree_store_append*(treeStore: GtkTreeStore, iter: ptr GtkTreeIter, parent: ptr GtkTreeIter) {.importc.}
  proc gtk_tree_store_prepend*(treeStore: GtkTreeStore, iter: ptr GtkTreeIter, parent: ptr GtkTreeIter) {.importc.}
  proc gtk_tree_store_insert*(treeStore: GtkTreeStore, iter: ptr GtkTreeIter, parent: ptr GtkTreeIter, position: gint) {.importc.}
  proc gtk_tree_store_remove*(treeStore: GtkTreeStore, iter: ptr GtkTreeIter): gboolean {.importc.}
  proc gtk_tree_store_clear*(treeStore: GtkTreeStore) {.importc.}
  proc gtk_tree_store_set*(treeStore: GtkTreeStore, iter: ptr GtkTreeIter) {.importc, varargs.}

# ============================================================================
# TREE VIEW
# WARNING: TreeView is deprecated in GTK4. Use GtkColumnView instead.
# ============================================================================

when not defined(GTK_DISABLE_DEPRECATED):
  proc gtk_tree_view_new*(): GtkTreeView {.importc.}
  proc gtk_tree_view_new_with_model*(model: GtkTreeModel): GtkTreeView {.importc.}
  proc gtk_tree_view_get_model*(treeView: GtkTreeView): GtkTreeModel {.importc.}
  proc gtk_tree_view_set_model*(treeView: GtkTreeView, model: GtkTreeModel) {.importc.}
  proc gtk_tree_view_append_column*(treeView: GtkTreeView, column: GtkTreeViewColumn): gint {.importc.}
  proc gtk_tree_view_remove_column*(treeView: GtkTreeView, column: GtkTreeViewColumn): gint {.importc.}
  proc gtk_tree_view_insert_column*(treeView: GtkTreeView, column: GtkTreeViewColumn, position: gint): gint {.importc.}
  proc gtk_tree_view_get_selection*(treeView: GtkTreeView): GtkTreeSelection {.importc.}
  proc gtk_tree_view_set_headers_visible*(treeView: GtkTreeView, headersVisible: gboolean) {.importc.}
  proc gtk_tree_view_get_headers_visible*(treeView: GtkTreeView): gboolean {.importc.}
  proc gtk_tree_view_collapse_all*(treeView: GtkTreeView) {.importc.}
  proc gtk_tree_view_expand_all*(treeView: GtkTreeView) {.importc.}

# ============================================================================
# TREE VIEW COLUMN
# WARNING: TreeViewColumn is deprecated in GTK4.
# ============================================================================

when not defined(GTK_DISABLE_DEPRECATED):
  proc gtk_tree_view_column_new*(): GtkTreeViewColumn {.importc.}
  proc gtk_tree_view_column_new_with_attributes*(title: cstring, cell: GtkCellRenderer): GtkTreeViewColumn {.importc, varargs.}
  proc gtk_tree_view_column_pack_start*(treeColumn: GtkTreeViewColumn, cell: GtkCellRenderer, expand: gboolean) {.importc.}
  proc gtk_tree_view_column_pack_end*(treeColumn: GtkTreeViewColumn, cell: GtkCellRenderer, expand: gboolean) {.importc.}
  proc gtk_tree_view_column_clear*(treeColumn: GtkTreeViewColumn) {.importc.}
  proc gtk_tree_view_column_add_attribute*(treeColumn: GtkTreeViewColumn, cellRenderer: GtkCellRenderer, attribute: cstring, column: gint) {.importc.}
  proc gtk_tree_view_column_set_title*(treeColumn: GtkTreeViewColumn, title: cstring) {.importc.}
  proc gtk_tree_view_column_get_title*(treeColumn: GtkTreeViewColumn): cstring {.importc.}
  proc gtk_tree_view_column_set_resizable*(treeColumn: GtkTreeViewColumn, resizable: gboolean) {.importc.}
  proc gtk_tree_view_column_get_resizable*(treeColumn: GtkTreeViewColumn): gboolean {.importc.}
  proc gtk_tree_view_column_set_visible*(treeColumn: GtkTreeViewColumn, visible: gboolean) {.importc.}
  proc gtk_tree_view_column_get_visible*(treeColumn: GtkTreeViewColumn): gboolean {.importc.}

# ============================================================================
# CELL RENDERER
# WARNING: CellRenderer is deprecated in GTK4.
# ============================================================================

when not defined(GTK_DISABLE_DEPRECATED):
  proc gtk_cell_renderer_text_new*(): GtkCellRendererText {.importc.}
  proc gtk_cell_renderer_toggle_new*(): GtkCellRendererToggle {.importc.}
  proc gtk_cell_renderer_pixbuf_new*(): GtkCellRendererPixbuf {.importc.}

proc gtk_cell_renderer_toggle_set_active*(toggle: GtkCellRendererToggle, setting: gboolean) {.importc.}
proc gtk_cell_renderer_toggle_get_active*(toggle: GtkCellRendererToggle): gboolean {.importc.}
proc gtk_cell_renderer_toggle_set_radio*(toggle: GtkCellRendererToggle, radio: gboolean) {.importc.}
proc gtk_cell_renderer_toggle_get_radio*(toggle: GtkCellRendererToggle): gboolean {.importc.}

# ============================================================================
# TREE SELECTION
# ============================================================================

proc gtk_tree_selection_set_mode*(selection: GtkTreeSelection, `type`: GtkSelectionMode) {.importc.}
proc gtk_tree_selection_get_mode*(selection: GtkTreeSelection): GtkSelectionMode {.importc.}
proc gtk_tree_selection_get_selected*(selection: GtkTreeSelection, model: ptr GtkTreeModel, iter: ptr GtkTreeIter): gboolean {.importc.}
proc gtk_tree_selection_select_iter*(selection: GtkTreeSelection, iter: ptr GtkTreeIter) {.importc.}
proc gtk_tree_selection_unselect_iter*(selection: GtkTreeSelection, iter: ptr GtkTreeIter) {.importc.}
proc gtk_tree_selection_select_all*(selection: GtkTreeSelection) {.importc.}
proc gtk_tree_selection_unselect_all*(selection: GtkTreeSelection) {.importc.}

# ============================================================================
# TREE PATH
# ============================================================================

proc gtk_tree_path_new*(): GtkTreePath {.importc.}
proc gtk_tree_path_new_from_string*(path: cstring): GtkTreePath {.importc.}
proc gtk_tree_path_free*(path: GtkTreePath) {.importc.}
proc gtk_tree_path_to_string*(path: GtkTreePath): cstring {.importc.}

# ============================================================================
# TREE MODEL
# ============================================================================

proc gtk_tree_model_get_iter*(treeModel: GtkTreeModel, iter: ptr GtkTreeIter, path: GtkTreePath): gboolean {.importc.}
proc gtk_tree_model_get_path*(treeModel: GtkTreeModel, iter: ptr GtkTreeIter): GtkTreePath {.importc.}
proc gtk_tree_model_get_value*(treeModel: GtkTreeModel, iter: ptr GtkTreeIter, column: gint, value: GValue) {.importc.}
proc gtk_tree_model_iter_next*(treeModel: GtkTreeModel, iter: ptr GtkTreeIter): gboolean {.importc.}
proc gtk_tree_model_iter_previous*(treeModel: GtkTreeModel, iter: ptr GtkTreeIter): gboolean {.importc.}
proc gtk_tree_model_iter_children*(treeModel: GtkTreeModel, iter: ptr GtkTreeIter, parent: ptr GtkTreeIter): gboolean {.importc.}
proc gtk_tree_model_iter_has_child*(treeModel: GtkTreeModel, iter: ptr GtkTreeIter): gboolean {.importc.}
proc gtk_tree_model_iter_n_children*(treeModel: GtkTreeModel, iter: ptr GtkTreeIter): gint {.importc.}
proc gtk_tree_model_iter_nth_child*(treeModel: GtkTreeModel, iter: ptr GtkTreeIter, parent: ptr GtkTreeIter, n: gint): gboolean {.importc.}
proc gtk_tree_model_iter_parent*(treeModel: GtkTreeModel, iter: ptr GtkTreeIter, child: ptr GtkTreeIter): gboolean {.importc.}
proc gtk_tree_model_get_iter_first*(treeModel: GtkTreeModel, iter: ptr GtkTreeIter): gboolean {.importc.}
proc gtk_tree_model_get_string_from_iter*(treeModel: GtkTreeModel, iter: ptr GtkTreeIter): cstring {.importc.}

# ============================================================================
# RADIO BUTTON
# ============================================================================

proc gtk_radio_button_new*(group: pointer): GtkRadioButton {.importc.}
proc gtk_radio_button_new_with_label*(group: pointer, label: cstring): GtkRadioButton {.importc.}
proc gtk_radio_button_new_with_mnemonic*(group: pointer, label: cstring): GtkRadioButton {.importc.}
proc gtk_radio_button_new_from_widget*(radioGroupMember: GtkRadioButton): GtkRadioButton {.importc.}
proc gtk_radio_button_new_with_label_from_widget*(radioGroupMember: GtkRadioButton, label: cstring): GtkRadioButton {.importc.}
proc gtk_radio_button_new_with_mnemonic_from_widget*(radioGroupMember: GtkRadioButton, label: cstring): GtkRadioButton {.importc.}
proc gtk_radio_button_set_group*(radioButton: GtkRadioButton, group: pointer) {.importc.}
proc gtk_radio_button_get_group*(radioButton: GtkRadioButton): pointer {.importc.}

# ============================================================================
# SCALE BUTTON & VOLUME BUTTON
# ============================================================================

proc gtk_scale_button_new*(min: gdouble, max: gdouble, step: gdouble, icons: ptr cstring): GtkScaleButton {.importc.}
proc gtk_scale_button_set_adjustment*(button: GtkScaleButton, adjustment: GtkAdjustment) {.importc.}
proc gtk_scale_button_get_adjustment*(button: GtkScaleButton): GtkAdjustment {.importc.}
proc gtk_scale_button_set_value*(button: GtkScaleButton, value: gdouble) {.importc.}
proc gtk_scale_button_get_value*(button: GtkScaleButton): gdouble {.importc.}

proc gtk_volume_button_new*(): GtkVolumeButton {.importc.}

# ============================================================================
# LOCK BUTTON
# ============================================================================

proc gtk_lock_button_new*(permission: pointer): GtkLockButton {.importc.}
proc gtk_lock_button_get_permission*(button: GtkLockButton): pointer {.importc.}
proc gtk_lock_button_set_permission*(button: GtkLockButton, permission: pointer) {.importc.}

# ============================================================================
# TEXT TAG
# ============================================================================

proc gtk_text_tag_new*(name: cstring): GtkTextTag {.importc.}
proc gtk_text_tag_set_priority*(tag: GtkTextTag, priority: gint) {.importc.}
proc gtk_text_tag_get_priority*(tag: GtkTextTag): gint {.importc.}

proc gtk_text_tag_table_new*(): GtkTextTagTable {.importc.}
proc gtk_text_tag_table_add*(table: GtkTextTagTable, tag: GtkTextTag): gboolean {.importc.}
proc gtk_text_tag_table_remove*(table: GtkTextTagTable, tag: GtkTextTag) {.importc.}
proc gtk_text_tag_table_lookup*(table: GtkTextTagTable, name: cstring): GtkTextTag {.importc.}
proc gtk_text_tag_table_get_size*(table: GtkTextTagTable): gint {.importc.}

# ============================================================================
# TEXT MARK
# ============================================================================

proc gtk_text_mark_new*(name: cstring, leftGravity: gboolean): GtkTextMark {.importc.}
proc gtk_text_mark_set_visible*(mark: GtkTextMark, setting: gboolean) {.importc.}
proc gtk_text_mark_get_visible*(mark: GtkTextMark): gboolean {.importc.}
proc gtk_text_mark_get_deleted*(mark: GtkTextMark): gboolean {.importc.}
proc gtk_text_mark_get_name*(mark: GtkTextMark): cstring {.importc.}
proc gtk_text_mark_get_buffer*(mark: GtkTextMark): GtkTextBuffer {.importc.}
proc gtk_text_mark_get_left_gravity*(mark: GtkTextMark): gboolean {.importc.}



# ============================================================================
# TEXT ITER
# ============================================================================

proc gtk_text_iter_get_offset*(iter: ptr GtkTextIter): gint {.importc.}
proc gtk_text_iter_get_line*(iter: ptr GtkTextIter): gint {.importc.}
proc gtk_text_iter_get_line_offset*(iter: ptr GtkTextIter): gint {.importc.}
proc gtk_text_iter_get_line_index*(iter: ptr GtkTextIter): gint {.importc.}
proc gtk_text_iter_get_visible_line_index*(iter: ptr GtkTextIter): gint {.importc.}
proc gtk_text_iter_get_visible_line_offset*(iter: ptr GtkTextIter): gint {.importc.}
proc gtk_text_iter_get_char*(iter: ptr GtkTextIter): gunichar {.importc.}
proc gtk_text_iter_get_slice*(start: ptr GtkTextIter, `end`: ptr GtkTextIter): cstring {.importc.}
proc gtk_text_iter_get_text*(start: ptr GtkTextIter, `end`: ptr GtkTextIter): cstring {.importc.}
proc gtk_text_iter_get_visible_slice*(start: ptr GtkTextIter, `end`: ptr GtkTextIter): cstring {.importc.}
proc gtk_text_iter_get_visible_text*(start: ptr GtkTextIter, `end`: ptr GtkTextIter): cstring {.importc.}
proc gtk_text_iter_forward_char*(iter: ptr GtkTextIter): gboolean {.importc.}
proc gtk_text_iter_backward_char*(iter: ptr GtkTextIter): gboolean {.importc.}
proc gtk_text_iter_forward_chars*(iter: ptr GtkTextIter, count: gint): gboolean {.importc.}
proc gtk_text_iter_backward_chars*(iter: ptr GtkTextIter, count: gint): gboolean {.importc.}
proc gtk_text_iter_forward_line*(iter: ptr GtkTextIter): gboolean {.importc.}
proc gtk_text_iter_backward_line*(iter: ptr GtkTextIter): gboolean {.importc.}
proc gtk_text_iter_forward_lines*(iter: ptr GtkTextIter, count: gint): gboolean {.importc.}
proc gtk_text_iter_backward_lines*(iter: ptr GtkTextIter, count: gint): gboolean {.importc.}
proc gtk_text_iter_forward_word_end*(iter: ptr GtkTextIter): gboolean {.importc.}
proc gtk_text_iter_backward_word_start*(iter: ptr GtkTextIter): gboolean {.importc.}
proc gtk_text_iter_forward_word_ends*(iter: ptr GtkTextIter, count: gint): gboolean {.importc.}
proc gtk_text_iter_backward_word_starts*(iter: ptr GtkTextIter, count: gint): gboolean {.importc.}
proc gtk_text_iter_forward_visible_word_end*(iter: ptr GtkTextIter): gboolean {.importc.}
proc gtk_text_iter_backward_visible_word_start*(iter: ptr GtkTextIter): gboolean {.importc.}
proc gtk_text_iter_forward_visible_word_ends*(iter: ptr GtkTextIter, count: gint): gboolean {.importc.}
proc gtk_text_iter_backward_visible_word_starts*(iter: ptr GtkTextIter, count: gint): gboolean {.importc.}
proc gtk_text_iter_forward_sentence_end*(iter: ptr GtkTextIter): gboolean {.importc.}
proc gtk_text_iter_backward_sentence_start*(iter: ptr GtkTextIter): gboolean {.importc.}
proc gtk_text_iter_forward_sentence_ends*(iter: ptr GtkTextIter, count: gint): gboolean {.importc.}
proc gtk_text_iter_backward_sentence_starts*(iter: ptr GtkTextIter, count: gint): gboolean {.importc.}
proc gtk_text_iter_forward_cursor_position*(iter: ptr GtkTextIter): gboolean {.importc.}
proc gtk_text_iter_backward_cursor_position*(iter: ptr GtkTextIter): gboolean {.importc.}
proc gtk_text_iter_forward_cursor_positions*(iter: ptr GtkTextIter, count: gint): gboolean {.importc.}
proc gtk_text_iter_backward_cursor_positions*(iter: ptr GtkTextIter, count: gint): gboolean {.importc.}
proc gtk_text_iter_forward_visible_cursor_position*(iter: ptr GtkTextIter): gboolean {.importc.}
proc gtk_text_iter_backward_visible_cursor_position*(iter: ptr GtkTextIter): gboolean {.importc.}
proc gtk_text_iter_forward_visible_cursor_positions*(iter: ptr GtkTextIter, count: gint): gboolean {.importc.}
proc gtk_text_iter_backward_visible_cursor_positions*(iter: ptr GtkTextIter, count: gint): gboolean {.importc.}
proc gtk_text_iter_set_offset*(iter: ptr GtkTextIter, charOffset: gint) {.importc.}
proc gtk_text_iter_set_line*(iter: ptr GtkTextIter, lineNumber: gint) {.importc.}
proc gtk_text_iter_set_line_offset*(iter: ptr GtkTextIter, charOnLine: gint) {.importc.}
proc gtk_text_iter_set_line_index*(iter: ptr GtkTextIter, byteOnLine: gint) {.importc.}
proc gtk_text_iter_set_visible_line_index*(iter: ptr GtkTextIter, byteOnLine: gint) {.importc.}
proc gtk_text_iter_set_visible_line_offset*(iter: ptr GtkTextIter, charOnLine: gint) {.importc.}
proc gtk_text_iter_forward_to_end*(iter: ptr GtkTextIter) {.importc.}
proc gtk_text_iter_forward_to_line_end*(iter: ptr GtkTextIter): gboolean {.importc.}
proc gtk_text_iter_forward_to_tag_toggle*(iter: ptr GtkTextIter, tag: GtkTextTag): gboolean {.importc.}
proc gtk_text_iter_backward_to_tag_toggle*(iter: ptr GtkTextIter, tag: GtkTextTag): gboolean {.importc.}
proc gtk_text_iter_forward_search*(iter: ptr GtkTextIter, str: cstring, flags: gint, matchStart: ptr GtkTextIter, matchEnd: ptr GtkTextIter, limit: ptr GtkTextIter): gboolean {.importc.}
proc gtk_text_iter_backward_search*(iter: ptr GtkTextIter, str: cstring, flags: gint, matchStart: ptr GtkTextIter, matchEnd: ptr GtkTextIter, limit: ptr GtkTextIter): gboolean {.importc.}
proc gtk_text_iter_equal*(lhs: ptr GtkTextIter, rhs: ptr GtkTextIter): gboolean {.importc.}
proc gtk_text_iter_compare*(lhs: ptr GtkTextIter, rhs: ptr GtkTextIter): gint {.importc.}
proc gtk_text_iter_in_range*(iter: ptr GtkTextIter, start: ptr GtkTextIter, `end`: ptr GtkTextIter): gboolean {.importc.}
proc gtk_text_iter_starts_word*(iter: ptr GtkTextIter): gboolean {.importc.}
proc gtk_text_iter_ends_word*(iter: ptr GtkTextIter): gboolean {.importc.}
proc gtk_text_iter_inside_word*(iter: ptr GtkTextIter): gboolean {.importc.}
proc gtk_text_iter_starts_line*(iter: ptr GtkTextIter): gboolean {.importc.}
proc gtk_text_iter_ends_line*(iter: ptr GtkTextIter): gboolean {.importc.}
proc gtk_text_iter_starts_sentence*(iter: ptr GtkTextIter): gboolean {.importc.}
proc gtk_text_iter_ends_sentence*(iter: ptr GtkTextIter): gboolean {.importc.}
proc gtk_text_iter_inside_sentence*(iter: ptr GtkTextIter): gboolean {.importc.}
proc gtk_text_iter_is_cursor_position*(iter: ptr GtkTextIter): gboolean {.importc.}
proc gtk_text_iter_get_chars_in_line*(iter: ptr GtkTextIter): gint {.importc.}
proc gtk_text_iter_get_bytes_in_line*(iter: ptr GtkTextIter): gint {.importc.}
proc gtk_text_iter_is_end*(iter: ptr GtkTextIter): gboolean {.importc.}
proc gtk_text_iter_is_start*(iter: ptr GtkTextIter): gboolean {.importc.}
proc gtk_text_iter_can_insert*(iter: ptr GtkTextIter, defaultEditability: gboolean): gboolean {.importc.}
proc gtk_text_iter_editable*(iter: ptr GtkTextIter, defaultSetting: gboolean): gboolean {.importc.}

# ============================================================================
# TEXT BUFFER (дополнительные функции)
# ============================================================================

proc gtk_text_buffer_add_selection_clipboard*(buffer: GtkTextBuffer, clipboard: GdkClipboard) {.importc.}
proc gtk_text_buffer_remove_selection_clipboard*(buffer: GtkTextBuffer, clipboard: GdkClipboard) {.importc.}
proc gtk_text_buffer_insert_with_tags*(buffer: GtkTextBuffer, iter: ptr GtkTextIter, text: cstring, len: gint, firstTag: GtkTextTag) {.importc, varargs.}
proc gtk_text_buffer_insert_with_tags_by_name*(buffer: GtkTextBuffer, iter: ptr GtkTextIter, text: cstring, len: gint, firstTagName: cstring) {.importc, varargs.}
proc gtk_text_buffer_create_tag*(buffer: GtkTextBuffer, tagName: cstring, firstPropertyName: cstring): GtkTextTag {.importc, varargs.}




# ============================================================================
# EDITABLE
# ============================================================================
proc gtk_editable_get_text*(editable: pointer): cstring {.importc.}
proc gtk_editable_set_text*(editable: pointer, text: cstring) {.importc.}
proc gtk_editable_get_chars*(editable: pointer, startPos: gint, endPos: gint): cstring {.importc.}
proc gtk_editable_insert_text*(editable: pointer, text: cstring, length: gint, position: ptr gint) {.importc.}
proc gtk_editable_delete_text*(editable: pointer, startPos: gint, endPos: gint) {.importc.}
proc gtk_editable_get_selection_bounds*(editable: pointer, startPos: ptr gint, endPos: ptr gint): gboolean {.importc.}
proc gtk_editable_delete_selection*(editable: pointer) {.importc.}
proc gtk_editable_set_position*(editable: pointer, position: gint) {.importc.}
proc gtk_editable_get_position*(editable: pointer): gint {.importc.}
proc gtk_editable_get_editable*(editable: pointer): gboolean {.importc.}
proc gtk_editable_set_editable*(editable: pointer, isEditable: gboolean) {.importc.}
proc gtk_editable_select_region*(editable: pointer, startPos: gint, endPos: gint) {.importc.}
proc gtk_editable_get_alignment*(editable: pointer): gfloat {.importc.}
proc gtk_editable_set_alignment*(editable: pointer, xalign: gfloat) {.importc.}
proc gtk_editable_get_width_chars*(editable: pointer): gint {.importc.}
proc gtk_editable_set_width_chars*(editable: pointer, nChars: gint) {.importc.}
proc gtk_editable_get_max_width_chars*(editable: pointer): gint {.importc.}
proc gtk_editable_set_max_width_chars*(editable: pointer, nChars: gint) {.importc.}
proc gtk_editable_get_enable_undo*(editable: pointer): gboolean {.importc.}
proc gtk_editable_set_enable_undo*(editable: pointer, enableUndo: gboolean) {.importc.}


# ============================================================================
# MENU MODEL & POPOVER MENU
# ============================================================================
proc gtk_popover_menu_new_from_model*(model: GMenuModel): GtkPopoverMenu {.importc.}
proc gtk_popover_menu_new_from_model_full*(model: GMenuModel, flags: gint): GtkPopoverMenu {.importc.}
proc gtk_popover_menu_set_menu_model*(popover: GtkPopoverMenu, model: GMenuModel) {.importc.}
proc gtk_popover_menu_get_menu_model*(popover: GtkPopoverMenu): GMenuModel {.importc.}
proc gtk_popover_menu_add_child*(popover: GtkPopoverMenu, child: GtkWidget, id: cstring): gboolean {.importc.}
proc gtk_popover_menu_remove_child*(popover: GtkPopoverMenu, child: GtkWidget): gboolean {.importc.}
proc g_menu_item_new*(label: cstring, detailedAction: cstring): GMenuItem {.importc.}
proc g_menu_item_new_section*(label: cstring, section: GMenuModel): GMenuItem {.importc.}
proc g_menu_item_new_submenu*(label: cstring, submenu: GMenuModel): GMenuItem {.importc.}
proc g_menu_item_set_label*(menuItem: GMenuItem, label: cstring) {.importc.}
proc g_menu_item_set_action_and_target_value*(menuItem: GMenuItem, action: cstring, targetValue: GVariant) {.importc.}
proc g_menu_item_set_detailed_action*(menuItem: GMenuItem, detailedAction: cstring) {.importc.}
proc g_menu_item_set_section*(menuItem: GMenuItem, section: GMenuModel) {.importc.}
proc g_menu_item_set_submenu*(menuItem: GMenuItem, submenu: GMenuModel) {.importc.}
proc g_menu_item_get_attribute_value*(menuItem: GMenuItem, attribute: cstring, expectedType: GVariantType): GVariant {.importc.}
proc g_menu_item_get_link*(menuItem: GMenuItem, link: cstring): GMenuModel {.importc.}
proc g_menu_item_set_attribute_value*(menuItem: GMenuItem, attribute: cstring, value: GVariant) {.importc.}
proc g_menu_item_set_link*(menuItem: GMenuItem, link: cstring, model: GMenuModel) {.importc.}


# ============================================================================
# REVEALER
# ============================================================================
type
  GtkRevealer* = pointer
  GtkRevealerTransitionType* {.size: sizeof(cint).} = enum
    GTK_REVEALER_TRANSITION_TYPE_NONE = 0
    GTK_REVEALER_TRANSITION_TYPE_CROSSFADE = 1
    GTK_REVEALER_TRANSITION_TYPE_SLIDE_RIGHT = 2
    GTK_REVEALER_TRANSITION_TYPE_SLIDE_LEFT = 3
    GTK_REVEALER_TRANSITION_TYPE_SLIDE_UP = 4
    GTK_REVEALER_TRANSITION_TYPE_SLIDE_DOWN = 5
    GTK_REVEALER_TRANSITION_TYPE_SWING_RIGHT = 6
    GTK_REVEALER_TRANSITION_TYPE_SWING_LEFT = 7
    GTK_REVEALER_TRANSITION_TYPE_SWING_UP = 8
    GTK_REVEALER_TRANSITION_TYPE_SWING_DOWN = 9
proc gtk_revealer_new*(): GtkRevealer {.importc.}
proc gtk_revealer_set_reveal_child*(revealer: GtkRevealer, revealChild: gboolean) {.importc.}
proc gtk_revealer_get_reveal_child*(revealer: GtkRevealer): gboolean {.importc.}
proc gtk_revealer_get_child_revealed*(revealer: GtkRevealer): gboolean {.importc.}
proc gtk_revealer_set_transition_duration*(revealer: GtkRevealer, duration: guint) {.importc.}
proc gtk_revealer_get_transition_duration*(revealer: GtkRevealer): guint {.importc.}
proc gtk_revealer_set_transition_type*(revealer: GtkRevealer, transition: GtkRevealerTransitionType) {.importc.}
proc gtk_revealer_get_transition_type*(revealer: GtkRevealer): GtkRevealerTransitionType {.importc.}
proc gtk_revealer_set_child*(revealer: GtkRevealer, child: GtkWidget) {.importc.}
proc gtk_revealer_get_child*(revealer: GtkRevealer): GtkWidget {.importc.}


# ============================================================================
# GESTURE & EVENT CONTROLLERS
# ============================================================================
type
  GtkEventController* = pointer
  GtkGesture* = pointer
  GtkGestureSingle* = pointer
  GtkGestureClick* = pointer
  GtkGestureDrag* = pointer
  GtkGestureLongPress* = pointer
  GtkGestureSwipe* = pointer
  GtkGestureRotate* = pointer
  GtkGestureZoom* = pointer
  GtkEventControllerKey* = pointer
  GtkEventControllerFocus* = pointer
  GtkEventControllerMotion* = pointer
  GtkEventControllerScroll* = pointer
  GtkDropTarget* = pointer
  GtkDragSource* = pointer
proc gtk_gesture_click_new*(): GtkGestureClick {.importc.}
proc gtk_gesture_click_set_button*(gesture: GtkGestureClick, button: guint) {.importc.}
proc gtk_gesture_click_get_button*(gesture: GtkGestureClick): guint {.importc.}
proc gtk_gesture_drag_new*(): GtkGestureDrag {.importc.}
proc gtk_gesture_drag_get_start_point*(gesture: GtkGestureDrag, x: ptr gdouble, y: ptr gdouble): gboolean {.importc.}
proc gtk_gesture_drag_get_offset*(gesture: GtkGestureDrag, x: ptr gdouble, y: ptr gdouble): gboolean {.importc.}
proc gtk_gesture_long_press_new*(): GtkGestureLongPress {.importc.}
proc gtk_gesture_long_press_set_delay_factor*(gesture: GtkGestureLongPress, delayFactor: gdouble) {.importc.}
proc gtk_gesture_long_press_get_delay_factor*(gesture: GtkGestureLongPress): gdouble {.importc.}
proc gtk_gesture_swipe_new*(): GtkGestureSwipe {.importc.}
proc gtk_gesture_swipe_get_velocity*(gesture: GtkGestureSwipe, velocityX: ptr gdouble, velocityY: ptr gdouble): gboolean {.importc.}
proc gtk_gesture_rotate_new*(): GtkGestureRotate {.importc.}
proc gtk_gesture_rotate_get_angle_delta*(gesture: GtkGestureRotate): gdouble {.importc.}
proc gtk_gesture_zoom_new*(): GtkGestureZoom {.importc.}
proc gtk_gesture_zoom_get_scale_delta*(gesture: GtkGestureZoom): gdouble {.importc.}
proc gtk_event_controller_key_new*(): GtkEventControllerKey {.importc.}
proc gtk_event_controller_key_set_im_context*(controller: GtkEventControllerKey, imContext: pointer) {.importc.}
proc gtk_event_controller_key_get_im_context*(controller: GtkEventControllerKey): pointer {.importc.}
proc gtk_event_controller_key_forward*(controller: GtkEventControllerKey, widget: GtkWidget): gboolean {.importc.}
proc gtk_event_controller_key_get_group*(controller: GtkEventControllerKey): guint {.importc.}
proc gtk_event_controller_focus_new*(): GtkEventControllerFocus {.importc.}
proc gtk_event_controller_focus_contains_focus*(controller: GtkEventControllerFocus): gboolean {.importc.}
proc gtk_event_controller_focus_is_focus*(controller: GtkEventControllerFocus): gboolean {.importc.}
proc gtk_event_controller_motion_new*(): GtkEventControllerMotion {.importc.}
proc gtk_event_controller_motion_contains_pointer*(controller: GtkEventControllerMotion): gboolean {.importc.}
proc gtk_event_controller_motion_is_pointer*(controller: GtkEventControllerMotion): gboolean {.importc.}
proc gtk_event_controller_scroll_new*(flags: gint): GtkEventControllerScroll {.importc.}
proc gtk_event_controller_scroll_set_flags*(controller: GtkEventControllerScroll, flags: gint) {.importc.}
proc gtk_event_controller_scroll_get_flags*(controller: GtkEventControllerScroll): gint {.importc.}
proc gtk_event_controller_scroll_get_unit*(controller: GtkEventControllerScroll): gint {.importc.}
proc gtk_widget_add_controller*(widget: GtkWidget, controller: GtkEventController) {.importc.}
proc gtk_widget_remove_controller*(widget: GtkWidget, controller: GtkEventController) {.importc.}
proc gtk_event_controller_get_widget*(controller: GtkEventController): GtkWidget {.importc.}
proc gtk_event_controller_reset*(controller: GtkEventController) {.importc.}
proc gtk_event_controller_get_propagation_phase*(controller: GtkEventController): gint {.importc.}
proc gtk_event_controller_set_propagation_phase*(controller: GtkEventController, phase: gint) {.importc.}
proc gtk_event_controller_get_propagation_limit*(controller: GtkEventController): gint {.importc.}
proc gtk_event_controller_set_propagation_limit*(controller: GtkEventController, limit: gint) {.importc.}
proc gtk_event_controller_get_name*(controller: GtkEventController): cstring {.importc.}
proc gtk_event_controller_set_name*(controller: GtkEventController, name: cstring) {.importc.}
proc gtk_gesture_get_device*(gesture: GtkGesture): pointer {.importc.}
proc gtk_gesture_is_active*(gesture: GtkGesture): gboolean {.importc.}
proc gtk_gesture_is_recognized*(gesture: GtkGesture): gboolean {.importc.}
proc gtk_gesture_get_sequence_state*(gesture: GtkGesture, sequence: pointer): gint {.importc.}
proc gtk_gesture_set_sequence_state*(gesture: GtkGesture, sequence: pointer, state: gint): gboolean {.importc.}
proc gtk_gesture_set_state*(gesture: GtkGesture, state: gint): gboolean {.importc.}
proc gtk_gesture_get_sequences*(gesture: GtkGesture): pointer {.importc.}
proc gtk_gesture_get_last_updated_sequence*(gesture: GtkGesture): pointer {.importc.}
proc gtk_gesture_get_last_event*(gesture: GtkGesture, sequence: pointer): GdkEvent {.importc.}
proc gtk_gesture_get_point*(gesture: GtkGesture, sequence: pointer, x: ptr gdouble, y: ptr gdouble): gboolean {.importc.}
proc gtk_gesture_get_bounding_box*(gesture: GtkGesture, rect: pointer): gboolean {.importc.}
proc gtk_gesture_get_bounding_box_center*(gesture: GtkGesture, x: ptr gdouble, y: ptr gdouble): gboolean {.importc.}
proc gtk_gesture_group*(groupGesture: GtkGesture, gesture: GtkGesture) {.importc.}
proc gtk_gesture_ungroup*(gesture: GtkGesture) {.importc.}
proc gtk_gesture_get_group*(gesture: GtkGesture): pointer {.importc.}
proc gtk_gesture_is_grouped_with*(gesture: GtkGesture, other: GtkGesture): gboolean {.importc.}
proc gtk_gesture_single_get_touch_only*(gesture: GtkGestureSingle): gboolean {.importc.}
proc gtk_gesture_single_set_touch_only*(gesture: GtkGestureSingle, touchOnly: gboolean) {.importc.}
proc gtk_gesture_single_get_exclusive*(gesture: GtkGestureSingle): gboolean {.importc.}
proc gtk_gesture_single_set_exclusive*(gesture: GtkGestureSingle, exclusive: gboolean) {.importc.}
proc gtk_gesture_single_get_button*(gesture: GtkGestureSingle): guint {.importc.}
proc gtk_gesture_single_set_button*(gesture: GtkGestureSingle, button: guint) {.importc.}
proc gtk_gesture_single_get_current_button*(gesture: GtkGestureSingle): guint {.importc.}
proc gtk_gesture_single_get_current_sequence*(gesture: GtkGestureSingle): pointer {.importc.}


# ============================================================================
# DRAG AND DROP
# ============================================================================
proc gtk_drag_source_new*(): GtkDragSource {.importc.}
proc gtk_drag_source_set_actions*(source: GtkDragSource, actions: gint) {.importc.}
proc gtk_drag_source_get_actions*(source: GtkDragSource): gint {.importc.}
proc gtk_drag_source_set_content*(source: GtkDragSource, content: pointer) {.importc.}
proc gtk_drag_source_get_content*(source: GtkDragSource): pointer {.importc.}
proc gtk_drag_source_set_icon*(source: GtkDragSource, paintable: pointer, hotX: gint, hotY: gint) {.importc.}
proc gtk_drag_source_drag_cancel*(source: GtkDragSource) {.importc.}
proc gtk_drag_source_get_drag*(source: GtkDragSource): pointer {.importc.}
proc gtk_drop_target_new*(contentType: GType, actions: gint): GtkDropTarget {.importc.}
proc gtk_drop_target_set_gtypes*(target: GtkDropTarget, types: ptr GType, nTypes: gsize) {.importc.}
proc gtk_drop_target_get_gtypes*(target: GtkDropTarget, nTypes: ptr gsize): ptr GType {.importc.}
proc gtk_drop_target_set_actions*(target: GtkDropTarget, actions: gint) {.importc.}
proc gtk_drop_target_get_actions*(target: GtkDropTarget): gint {.importc.}
proc gtk_drop_target_set_preload*(target: GtkDropTarget, preload: gboolean) {.importc.}
proc gtk_drop_target_get_preload*(target: GtkDropTarget): gboolean {.importc.}
proc gtk_drop_target_get_drop*(target: GtkDropTarget): pointer {.importc.}
proc gtk_drop_target_get_value*(target: GtkDropTarget): GValue {.importc.}
proc gtk_drop_target_get_formats*(target: GtkDropTarget): pointer {.importc.}
proc gtk_drop_target_get_current_drop*(target: GtkDropTarget): pointer {.importc.}
proc gtk_drop_target_reject*(target: GtkDropTarget) {.importc.}


# ============================================================================
# SHORTCUTS
# ============================================================================
type
  GtkShortcut* = pointer
  GtkShortcutController* = pointer
  GtkShortcutTrigger* = pointer
  GtkShortcutAction* = pointer
proc gtk_shortcut_controller_new*(): GtkShortcutController {.importc.}
proc gtk_shortcut_controller_new_for_model*(model: pointer): GtkShortcutController {.importc.}
proc gtk_shortcut_controller_set_mnemonics_modifiers*(controller: GtkShortcutController, modifiers: gint) {.importc.}
proc gtk_shortcut_controller_get_mnemonics_modifiers*(controller: GtkShortcutController): gint {.importc.}
proc gtk_shortcut_controller_set_scope*(controller: GtkShortcutController, scope: gint) {.importc.}
proc gtk_shortcut_controller_get_scope*(controller: GtkShortcutController): gint {.importc.}
proc gtk_shortcut_controller_add_shortcut*(controller: GtkShortcutController, shortcut: GtkShortcut) {.importc.}
proc gtk_shortcut_controller_remove_shortcut*(controller: GtkShortcutController, shortcut: GtkShortcut) {.importc.}
proc gtk_shortcut_new*(trigger: GtkShortcutTrigger, action: GtkShortcutAction): GtkShortcut {.importc.}
proc gtk_shortcut_get_trigger*(shortcut: GtkShortcut): GtkShortcutTrigger {.importc.}
proc gtk_shortcut_set_trigger*(shortcut: GtkShortcut, trigger: GtkShortcutTrigger) {.importc.}
proc gtk_shortcut_get_action*(shortcut: GtkShortcut): GtkShortcutAction {.importc.}
proc gtk_shortcut_set_action*(shortcut: GtkShortcut, action: GtkShortcutAction) {.importc.}
proc gtk_shortcut_get_arguments*(shortcut: GtkShortcut): GVariant {.importc.}
proc gtk_shortcut_set_arguments*(shortcut: GtkShortcut, args: GVariant) {.importc.}
proc gtk_shortcut_trigger_parse_string*(string: cstring): GtkShortcutTrigger {.importc.}
proc gtk_shortcut_action_parse_string*(string: cstring): GtkShortcutAction {.importc.}


# ============================================================================
# CONSTRAINT LAYOUT
# ============================================================================
type
  GtkConstraintLayout* = pointer
  GtkConstraint* = pointer
  GtkConstraintGuide* = pointer
proc gtk_constraint_layout_new*(): GtkConstraintLayout {.importc.}
proc gtk_constraint_layout_add_constraint*(layout: GtkConstraintLayout, constraint: GtkConstraint) {.importc.}
proc gtk_constraint_layout_remove_constraint*(layout: GtkConstraintLayout, constraint: GtkConstraint) {.importc.}
proc gtk_constraint_layout_add_guide*(layout: GtkConstraintLayout, guide: GtkConstraintGuide) {.importc.}
proc gtk_constraint_layout_remove_guide*(layout: GtkConstraintLayout, guide: GtkConstraintGuide) {.importc.}
proc gtk_constraint_layout_remove_all_constraints*(layout: GtkConstraintLayout) {.importc.}
proc gtk_constraint_new*(target: pointer, targetAttribute: gint, relation: gint, source: pointer, sourceAttribute: gint, multiplier: gdouble, constant: gdouble, strength: gint): GtkConstraint {.importc.}
proc gtk_constraint_new_constant*(target: pointer, targetAttribute: gint, relation: gint, constant: gdouble, strength: gint): GtkConstraint {.importc.}
proc gtk_constraint_get_target*(constraint: GtkConstraint): pointer {.importc.}
proc gtk_constraint_get_target_attribute*(constraint: GtkConstraint): gint {.importc.}
proc gtk_constraint_get_source*(constraint: GtkConstraint): pointer {.importc.}
proc gtk_constraint_get_source_attribute*(constraint: GtkConstraint): gint {.importc.}
proc gtk_constraint_get_relation*(constraint: GtkConstraint): gint {.importc.}
proc gtk_constraint_get_multiplier*(constraint: GtkConstraint): gdouble {.importc.}
proc gtk_constraint_get_constant*(constraint: GtkConstraint): gdouble {.importc.}
proc gtk_constraint_get_strength*(constraint: GtkConstraint): gint {.importc.}
proc gtk_constraint_is_required*(constraint: GtkConstraint): gboolean {.importc.}
proc gtk_constraint_is_attached*(constraint: GtkConstraint): gboolean {.importc.}
proc gtk_constraint_guide_new*(): GtkConstraintGuide {.importc.}
proc gtk_constraint_guide_set_min_size*(guide: GtkConstraintGuide, width: gint, height: gint) {.importc.}
proc gtk_constraint_guide_get_min_size*(guide: GtkConstraintGuide, width: ptr gint, height: ptr gint) {.importc.}
proc gtk_constraint_guide_set_nat_size*(guide: GtkConstraintGuide, width: gint, height: gint) {.importc.}
proc gtk_constraint_guide_get_nat_size*(guide: GtkConstraintGuide, width: ptr gint, height: ptr gint) {.importc.}
proc gtk_constraint_guide_set_max_size*(guide: GtkConstraintGuide, width: gint, height: gint) {.importc.}
proc gtk_constraint_guide_get_max_size*(guide: GtkConstraintGuide, width: ptr gint, height: ptr gint) {.importc.}
proc gtk_constraint_guide_get_strength*(guide: GtkConstraintGuide): gint {.importc.}
proc gtk_constraint_guide_set_strength*(guide: GtkConstraintGuide, strength: gint) {.importc.}
proc gtk_constraint_guide_set_name*(guide: GtkConstraintGuide, name: cstring) {.importc.}
proc gtk_constraint_guide_get_name*(guide: GtkConstraintGuide): cstring {.importc.}


# ============================================================================
# WINDOW GROUP
# ============================================================================
type
  GtkWindowGroup* = pointer
proc gtk_window_group_new*(): GtkWindowGroup {.importc.}
proc gtk_window_group_add_window*(windowGroup: GtkWindowGroup, window: GtkWindow) {.importc.}
proc gtk_window_group_remove_window*(windowGroup: GtkWindowGroup, window: GtkWindow) {.importc.}
proc gtk_window_group_list_windows*(windowGroup: GtkWindowGroup): pointer {.importc.}


# ============================================================================
# NATIVE DIALOG
# ============================================================================
type
  GtkNativeDialog* = pointer
proc gtk_native_dialog_show*(nativeDialog: GtkNativeDialog) {.importc.}
proc gtk_native_dialog_hide*(nativeDialog: GtkNativeDialog) {.importc.}
proc gtk_native_dialog_destroy*(nativeDialog: GtkNativeDialog) {.importc.}
proc gtk_native_dialog_get_visible*(nativeDialog: GtkNativeDialog): gboolean {.importc.}
proc gtk_native_dialog_set_modal*(nativeDialog: GtkNativeDialog, modal: gboolean) {.importc.}
proc gtk_native_dialog_get_modal*(nativeDialog: GtkNativeDialog): gboolean {.importc.}
proc gtk_native_dialog_set_title*(nativeDialog: GtkNativeDialog, title: cstring) {.importc.}
proc gtk_native_dialog_get_title*(nativeDialog: GtkNativeDialog): cstring {.importc.}
proc gtk_native_dialog_set_transient_for*(nativeDialog: GtkNativeDialog, parent: GtkWindow) {.importc.}
proc gtk_native_dialog_get_transient_for*(nativeDialog: GtkNativeDialog): GtkWindow {.importc.}
proc gtk_native_get_surface*(window: GtkWindow): pointer {.importc.}


# ============================================================================
# ALERT DIALOG
# ============================================================================
type
  GtkAlertDialog* = pointer
proc gtk_alert_dialog_new*(format: cstring): GtkAlertDialog {.importc, varargs.}
proc gtk_alert_dialog_get_message*(dialog: GtkAlertDialog): cstring {.importc.}
proc gtk_alert_dialog_set_message*(dialog: GtkAlertDialog, message: cstring) {.importc.}
proc gtk_alert_dialog_get_detail*(dialog: GtkAlertDialog): cstring {.importc.}
proc gtk_alert_dialog_set_detail*(dialog: GtkAlertDialog, detail: cstring) {.importc.}
proc gtk_alert_dialog_get_buttons*(dialog: GtkAlertDialog): ptr cstring {.importc.}
proc gtk_alert_dialog_set_buttons*(dialog: GtkAlertDialog, labels: ptr cstring) {.importc.}
proc gtk_alert_dialog_get_cancel_button*(dialog: GtkAlertDialog): gint {.importc.}
proc gtk_alert_dialog_set_cancel_button*(dialog: GtkAlertDialog, button: gint) {.importc.}
proc gtk_alert_dialog_get_default_button*(dialog: GtkAlertDialog): gint {.importc.}
proc gtk_alert_dialog_set_default_button*(dialog: GtkAlertDialog, button: gint) {.importc.}
proc gtk_alert_dialog_get_modal*(dialog: GtkAlertDialog): gboolean {.importc.}
proc gtk_alert_dialog_set_modal*(dialog: GtkAlertDialog, modal: gboolean) {.importc.}
proc gtk_alert_dialog_choose*(dialog: GtkAlertDialog, parent: GtkWindow, cancellable: pointer, callback: pointer, userData: gpointer) {.importc.}
proc gtk_alert_dialog_choose_finish*(dialog: GtkAlertDialog, result: pointer, error: ptr GError): gint {.importc.}


# ============================================================================
# PRINT OPERATION
# ============================================================================
type
  GtkPrintOperation* = pointer
  GtkPrintSettings* = pointer
  GtkPageSetup* = pointer
  GtkPrintContext* = pointer
proc gtk_print_operation_new*(): GtkPrintOperation {.importc.}
proc gtk_print_operation_set_print_settings*(op: GtkPrintOperation, printSettings: GtkPrintSettings) {.importc.}
proc gtk_print_operation_get_print_settings*(op: GtkPrintOperation): GtkPrintSettings {.importc.}
proc gtk_print_operation_set_default_page_setup*(op: GtkPrintOperation, defaultPageSetup: GtkPageSetup) {.importc.}
proc gtk_print_operation_get_default_page_setup*(op: GtkPrintOperation): GtkPageSetup {.importc.}
proc gtk_print_operation_set_n_pages*(op: GtkPrintOperation, nPages: gint) {.importc.}
proc gtk_print_operation_get_n_pages_to_print*(op: GtkPrintOperation): gint {.importc.}
proc gtk_print_operation_set_current_page*(op: GtkPrintOperation, currentPage: gint) {.importc.}
proc gtk_print_operation_set_use_full_page*(op: GtkPrintOperation, fullPage: gboolean) {.importc.}
proc gtk_print_operation_set_unit*(op: GtkPrintOperation, unit: gint) {.importc.}
proc gtk_print_operation_set_export_filename*(op: GtkPrintOperation, filename: cstring) {.importc.}
proc gtk_print_operation_set_show_progress*(op: GtkPrintOperation, showProgress: gboolean) {.importc.}
proc gtk_print_operation_set_track_print_status*(op: GtkPrintOperation, trackStatus: gboolean) {.importc.}
proc gtk_print_operation_set_custom_tab_label*(op: GtkPrintOperation, label: cstring) {.importc.}
proc gtk_print_operation_run*(op: GtkPrintOperation, action: gint, parent: GtkWindow, error: ptr GError): gint {.importc.}
proc gtk_print_operation_cancel*(op: GtkPrintOperation) {.importc.}
proc gtk_print_operation_draw_page_finish*(op: GtkPrintOperation) {.importc.}
proc gtk_print_operation_set_defer_drawing*(op: GtkPrintOperation) {.importc.}
proc gtk_print_operation_get_status*(op: GtkPrintOperation): gint {.importc.}
proc gtk_print_operation_get_status_string*(op: GtkPrintOperation): cstring {.importc.}
proc gtk_print_operation_is_finished*(op: GtkPrintOperation): gboolean {.importc.}
proc gtk_print_operation_set_support_selection*(op: GtkPrintOperation, supportSelection: gboolean) {.importc.}
proc gtk_print_operation_get_support_selection*(op: GtkPrintOperation): gboolean {.importc.}
proc gtk_print_operation_set_has_selection*(op: GtkPrintOperation, hasSelection: gboolean) {.importc.}
proc gtk_print_operation_get_has_selection*(op: GtkPrintOperation): gboolean {.importc.}
proc gtk_print_operation_set_embed_page_setup*(op: GtkPrintOperation, embed: gboolean) {.importc.}
proc gtk_print_operation_get_embed_page_setup*(op: GtkPrintOperation): gboolean {.importc.}
proc gtk_print_settings_new*(): GtkPrintSettings {.importc.}
proc gtk_print_settings_copy*(other: GtkPrintSettings): GtkPrintSettings {.importc.}
proc gtk_print_settings_has_key*(settings: GtkPrintSettings, key: cstring): gboolean {.importc.}
proc gtk_print_settings_get*(settings: GtkPrintSettings, key: cstring): cstring {.importc.}
proc gtk_print_settings_set*(settings: GtkPrintSettings, key: cstring, value: cstring) {.importc.}
proc gtk_print_settings_unset*(settings: GtkPrintSettings, key: cstring) {.importc.}
proc gtk_page_setup_new*(): GtkPageSetup {.importc.}
proc gtk_page_setup_copy*(other: GtkPageSetup): GtkPageSetup {.importc.}
proc gtk_page_setup_get_orientation*(setup: GtkPageSetup): gint {.importc.}
proc gtk_page_setup_set_orientation*(setup: GtkPageSetup, orientation: gint) {.importc.}
proc gtk_print_context_get_cairo_context*(context: GtkPrintContext): cairo_t {.importc.}
proc gtk_print_context_get_page_setup*(context: GtkPrintContext): GtkPageSetup {.importc.}
proc gtk_print_context_get_width*(context: GtkPrintContext): gdouble {.importc.}
proc gtk_print_context_get_height*(context: GtkPrintContext): gdouble {.importc.}
proc gtk_print_context_get_dpi_x*(context: GtkPrintContext): gdouble {.importc.}
proc gtk_print_context_get_dpi_y*(context: GtkPrintContext): gdouble {.importc.}


# ============================================================================
# BUILDER
# ============================================================================
type
  GtkBuilder* = pointer
proc gtk_builder_new*(): GtkBuilder {.importc.}
proc gtk_builder_new_from_file*(filename: cstring): GtkBuilder {.importc.}
proc gtk_builder_new_from_resource*(resourcePath: cstring): GtkBuilder {.importc.}
proc gtk_builder_new_from_string*(string: cstring, length: gssize): GtkBuilder {.importc.}
proc gtk_builder_add_from_file*(builder: GtkBuilder, filename: cstring, error: ptr GError): gboolean {.importc.}
proc gtk_builder_add_from_resource*(builder: GtkBuilder, resourcePath: cstring, error: ptr GError): gboolean {.importc.}
proc gtk_builder_add_from_string*(builder: GtkBuilder, buffer: cstring, length: gssize, error: ptr GError): gboolean {.importc.}
proc gtk_builder_add_objects_from_file*(builder: GtkBuilder, filename: cstring, objectIds: ptr cstring, error: ptr GError): gboolean {.importc.}
proc gtk_builder_add_objects_from_resource*(builder: GtkBuilder, resourcePath: cstring, objectIds: ptr cstring, error: ptr GError): gboolean {.importc.}
proc gtk_builder_add_objects_from_string*(builder: GtkBuilder, buffer: cstring, length: gssize, objectIds: ptr cstring, error: ptr GError): gboolean {.importc.}
proc gtk_builder_extend_with_template*(builder: GtkBuilder, obj: GObject, templateType: GType, buffer: cstring, length: gssize, error: ptr GError): gboolean {.importc.}
proc gtk_builder_get_object*(builder: GtkBuilder, name: cstring): GObject {.importc.}
proc gtk_builder_get_objects*(builder: GtkBuilder): pointer {.importc.}
proc gtk_builder_expose_object*(builder: GtkBuilder, name: cstring, obj: GObject) {.importc.}
proc gtk_builder_get_current_object*(builder: GtkBuilder): GObject {.importc.}
proc gtk_builder_set_current_object*(builder: GtkBuilder, currentObject: GObject) {.importc.}
proc gtk_builder_get_type_from_name*(builder: GtkBuilder, typeName: cstring): GType {.importc.}
proc gtk_builder_value_from_string*(builder: GtkBuilder, pspec: pointer, string: cstring, value: GValue, error: ptr GError): gboolean {.importc.}
proc gtk_builder_value_from_string_type*(builder: GtkBuilder, contentType: GType, string: cstring, value: GValue, error: ptr GError): gboolean {.importc.}
proc gtk_builder_set_scope*(builder: GtkBuilder, scope: pointer) {.importc.}
proc gtk_builder_get_scope*(builder: GtkBuilder): pointer {.importc.}
proc gtk_builder_set_translation_domain*(builder: GtkBuilder, domain: cstring) {.importc.}
proc gtk_builder_get_translation_domain*(builder: GtkBuilder): cstring {.importc.}
proc gtk_builder_create_closure*(builder: GtkBuilder, functionName: cstring, flags: gint, obj: GObject, error: ptr GError): pointer {.importc.}


# ============================================================================
# SETTINGS
# ============================================================================
type
  GtkSettings* = pointer
proc gtk_settings_get_default*(): GtkSettings {.importc.}
proc gtk_settings_get_for_display*(display: pointer): GtkSettings {.importc.}
proc gtk_settings_reset_property*(settings: GtkSettings, name: cstring) {.importc.}


# ============================================================================
# SIZE GROUP
# ============================================================================
type
  GtkSizeGroup* = pointer
  GtkSizeGroupMode* {.size: sizeof(cint).} = enum
    GTK_SIZE_GROUP_NONE = 0
    GTK_SIZE_GROUP_HORIZONTAL = 1
    GTK_SIZE_GROUP_VERTICAL = 2
    GTK_SIZE_GROUP_BOTH = 3
proc gtk_size_group_new*(mode: GtkSizeGroupMode): GtkSizeGroup {.importc.}
proc gtk_size_group_set_mode*(sizeGroup: GtkSizeGroup, mode: GtkSizeGroupMode) {.importc.}
proc gtk_size_group_get_mode*(sizeGroup: GtkSizeGroup): GtkSizeGroupMode {.importc.}
proc gtk_size_group_add_widget*(sizeGroup: GtkSizeGroup, widget: GtkWidget) {.importc.}
proc gtk_size_group_remove_widget*(sizeGroup: GtkSizeGroup, widget: GtkWidget) {.importc.}
proc gtk_size_group_get_widgets*(sizeGroup: GtkSizeGroup): pointer {.importc.}


# ============================================================================
# KEY VAL
# ============================================================================
proc gdk_keyval_from_name*(keyvalName: cstring): guint {.importc.}
proc gdk_keyval_name*(keyval: guint): cstring {.importc.}
proc gdk_keyval_to_unicode*(keyval: guint): gunichar {.importc.}
proc gdk_unicode_to_keyval*(wc: gunichar): guint {.importc.}
proc gdk_keyval_to_upper*(keyval: guint): guint {.importc.}
proc gdk_keyval_to_lower*(keyval: guint): guint {.importc.}
proc gdk_keyval_is_upper*(keyval: guint): gboolean {.importc.}
proc gdk_keyval_is_lower*(keyval: guint): gboolean {.importc.}


# ============================================================================
# GIO - FILE OPERATIONS
# ============================================================================
proc g_file_new_for_uri*(uri: cstring): GFile {.importc.}
proc g_file_new_for_commandline_arg*(arg: cstring): GFile {.importc.}
proc g_file_new_tmp*(tmpl: cstring, iostream: pointer, error: ptr GError): GFile {.importc.}
proc g_file_parse_name*(parseName: cstring): GFile {.importc.}
proc g_file_dup*(file: GFile): GFile {.importc.}
proc g_file_hash*(file: GFile): guint {.importc.}
proc g_file_equal*(file1: GFile, file2: GFile): gboolean {.importc.}
proc g_file_get_uri*(file: GFile): cstring {.importc.}
proc g_file_get_parse_name*(file: GFile): cstring {.importc.}
proc g_file_get_parent*(file: GFile): GFile {.importc.}
proc g_file_has_parent*(file: GFile, parent: GFile): gboolean {.importc.}
proc g_file_get_child*(file: GFile, name: cstring): GFile {.importc.}
proc g_file_get_child_for_display_name*(file: GFile, displayName: cstring, error: ptr GError): GFile {.importc.}
proc g_file_has_prefix*(file: GFile, prefix: GFile): gboolean {.importc.}
proc g_file_get_relative_path*(parent: GFile, descendant: GFile): cstring {.importc.}
proc g_file_resolve_relative_path*(file: GFile, relativePath: cstring): GFile {.importc.}
proc g_file_is_native*(file: GFile): gboolean {.importc.}
proc g_file_has_uri_scheme*(file: GFile, uriScheme: cstring): gboolean {.importc.}
proc g_file_get_uri_scheme*(file: GFile): cstring {.importc.}
proc g_file_query_exists*(file: GFile, cancellable: pointer): gboolean {.importc.}
proc g_file_query_file_type*(file: GFile, flags: gint, cancellable: pointer): gint {.importc.}


# ============================================================================
# MISCELLANEOUS UTILITIES
# ============================================================================
proc gtk_show_uri*(parent: GtkWindow, uri: cstring, timestamp: guint32, error: ptr GError) {.importc.}
proc gtk_show_uri_full*(parent: GtkWindow, uri: cstring, timestamp: guint32, cancellable: pointer, callback: pointer, userData: gpointer) {.importc.}
proc gtk_show_uri_full_finish*(parent: GtkWindow, result: pointer, error: ptr GError): gboolean {.importc.}



# ============================================================================
# TOOLTIP
# ============================================================================
type
  GtkTooltip* = pointer
proc gtk_tooltip_set_markup*(tooltip: GtkTooltip, markup: cstring) {.importc.}
proc gtk_tooltip_set_text*(tooltip: GtkTooltip, text: cstring) {.importc.}
proc gtk_tooltip_set_icon*(tooltip: GtkTooltip, paintable: pointer) {.importc.}
proc gtk_tooltip_set_icon_from_icon_name*(tooltip: GtkTooltip, iconName: cstring) {.importc.}
proc gtk_tooltip_set_icon_from_gicon*(tooltip: GtkTooltip, gicon: pointer) {.importc.}
proc gtk_tooltip_set_custom*(tooltip: GtkTooltip, customWidget: GtkWidget) {.importc.}
proc gtk_tooltip_set_tip_area*(tooltip: GtkTooltip, rect: pointer) {.importc.}


# ============================================================================
# SELECTION MODEL
# ============================================================================
type
  GtkSelectionModel* = pointer
  GtkSingleSelection* = pointer
  GtkMultiSelection* = pointer
  GtkNoSelection* = pointer
proc gtk_selection_model_is_selected*(model: GtkSelectionModel, position: guint): gboolean {.importc.}
proc gtk_selection_model_get_selection*(model: GtkSelectionModel): pointer {.importc.}
proc gtk_selection_model_get_selection_in_range*(model: GtkSelectionModel, position: guint, nItems: guint): pointer {.importc.}
proc gtk_selection_model_select_item*(model: GtkSelectionModel, position: guint, unselectRest: gboolean): gboolean {.importc.}
proc gtk_selection_model_unselect_item*(model: GtkSelectionModel, position: guint): gboolean {.importc.}
proc gtk_selection_model_select_range*(model: GtkSelectionModel, position: guint, nItems: guint, unselectRest: gboolean): gboolean {.importc.}
proc gtk_selection_model_unselect_range*(model: GtkSelectionModel, position: guint, nItems: guint): gboolean {.importc.}
proc gtk_selection_model_select_all*(model: GtkSelectionModel): gboolean {.importc.}
proc gtk_selection_model_unselect_all*(model: GtkSelectionModel): gboolean {.importc.}
proc gtk_selection_model_set_selection*(model: GtkSelectionModel, selected: pointer, mask: pointer): gboolean {.importc.}
proc gtk_single_selection_new*(model: pointer): GtkSingleSelection {.importc.}
proc gtk_single_selection_get_model*(self: GtkSingleSelection): pointer {.importc.}
proc gtk_single_selection_set_model*(self: GtkSingleSelection, model: pointer) {.importc.}
proc gtk_single_selection_get_selected*(self: GtkSingleSelection): guint {.importc.}
proc gtk_single_selection_set_selected*(self: GtkSingleSelection, position: guint) {.importc.}
proc gtk_single_selection_get_selected_item*(self: GtkSingleSelection): gpointer {.importc.}
proc gtk_single_selection_get_autoselect*(self: GtkSingleSelection): gboolean {.importc.}
proc gtk_single_selection_set_autoselect*(self: GtkSingleSelection, autoselect: gboolean) {.importc.}
proc gtk_single_selection_get_can_unselect*(self: GtkSingleSelection): gboolean {.importc.}
proc gtk_single_selection_set_can_unselect*(self: GtkSingleSelection, canUnselect: gboolean) {.importc.}
proc gtk_multi_selection_new*(model: pointer): GtkMultiSelection {.importc.}
proc gtk_multi_selection_get_model*(self: GtkMultiSelection): pointer {.importc.}
proc gtk_multi_selection_set_model*(self: GtkMultiSelection, model: pointer) {.importc.}
proc gtk_no_selection_new*(model: pointer): GtkNoSelection {.importc.}
proc gtk_no_selection_get_model*(self: GtkNoSelection): pointer {.importc.}
proc gtk_no_selection_set_model*(self: GtkNoSelection, model: pointer) {.importc.}


# ============================================================================
# LIST VIEW & COLUMN VIEW (GTK4 Modern List Widgets)
# ============================================================================
type
  GtkListView* = pointer
  GtkColumnView* = pointer
  GtkColumnViewColumn* = pointer
  GtkListItem* = pointer
  GtkListItemFactory* = pointer
  GtkSignalListItemFactory* = pointer
proc gtk_list_view_new*(model: GtkSelectionModel, factory: GtkListItemFactory): GtkListView {.importc.}
proc gtk_list_view_get_model*(self: GtkListView): GtkSelectionModel {.importc.}
proc gtk_list_view_set_model*(self: GtkListView, model: GtkSelectionModel) {.importc.}
proc gtk_list_view_get_factory*(self: GtkListView): GtkListItemFactory {.importc.}
proc gtk_list_view_set_factory*(self: GtkListView, factory: GtkListItemFactory) {.importc.}
proc gtk_list_view_get_show_separators*(self: GtkListView): gboolean {.importc.}
proc gtk_list_view_set_show_separators*(self: GtkListView, showSeparators: gboolean) {.importc.}
proc gtk_list_view_get_single_click_activate*(self: GtkListView): gboolean {.importc.}
proc gtk_list_view_set_single_click_activate*(self: GtkListView, singleClickActivate: gboolean) {.importc.}
proc gtk_list_view_get_enable_rubberband*(self: GtkListView): gboolean {.importc.}
proc gtk_list_view_set_enable_rubberband*(self: GtkListView, enableRubberband: gboolean) {.importc.}
proc gtk_column_view_new*(model: GtkSelectionModel): GtkColumnView {.importc.}
proc gtk_column_view_get_columns*(self: GtkColumnView): pointer {.importc.}
proc gtk_column_view_append_column*(self: GtkColumnView, column: GtkColumnViewColumn) {.importc.}
proc gtk_column_view_remove_column*(self: GtkColumnView, column: GtkColumnViewColumn) {.importc.}
proc gtk_column_view_insert_column*(self: GtkColumnView, position: guint, column: GtkColumnViewColumn) {.importc.}
proc gtk_column_view_get_model*(self: GtkColumnView): GtkSelectionModel {.importc.}
proc gtk_column_view_set_model*(self: GtkColumnView, model: GtkSelectionModel) {.importc.}
proc gtk_column_view_get_show_row_separators*(self: GtkColumnView): gboolean {.importc.}
proc gtk_column_view_set_show_row_separators*(self: GtkColumnView, showRowSeparators: gboolean) {.importc.}
proc gtk_column_view_get_show_column_separators*(self: GtkColumnView): gboolean {.importc.}
proc gtk_column_view_set_show_column_separators*(self: GtkColumnView, showColumnSeparators: gboolean) {.importc.}
proc gtk_column_view_get_enable_rubberband*(self: GtkColumnView): gboolean {.importc.}
proc gtk_column_view_set_enable_rubberband*(self: GtkColumnView, enableRubberband: gboolean) {.importc.}
proc gtk_column_view_get_reorderable*(self: GtkColumnView): gboolean {.importc.}
proc gtk_column_view_set_reorderable*(self: GtkColumnView, reorderable: gboolean) {.importc.}
proc gtk_column_view_get_single_click_activate*(self: GtkColumnView): gboolean {.importc.}
proc gtk_column_view_set_single_click_activate*(self: GtkColumnView, singleClickActivate: gboolean) {.importc.}
proc gtk_column_view_column_new*(title: cstring, factory: GtkListItemFactory): GtkColumnViewColumn {.importc.}
proc gtk_column_view_column_get_column_view*(self: GtkColumnViewColumn): GtkColumnView {.importc.}
proc gtk_column_view_column_get_factory*(self: GtkColumnViewColumn): GtkListItemFactory {.importc.}
proc gtk_column_view_column_set_factory*(self: GtkColumnViewColumn, factory: GtkListItemFactory) {.importc.}
proc gtk_column_view_column_get_title*(self: GtkColumnViewColumn): cstring {.importc.}
proc gtk_column_view_column_set_title*(self: GtkColumnViewColumn, title: cstring) {.importc.}
proc gtk_column_view_column_get_visible*(self: GtkColumnViewColumn): gboolean {.importc.}
proc gtk_column_view_column_set_visible*(self: GtkColumnViewColumn, visible: gboolean) {.importc.}
proc gtk_column_view_column_get_resizable*(self: GtkColumnViewColumn): gboolean {.importc.}
proc gtk_column_view_column_set_resizable*(self: GtkColumnViewColumn, resizable: gboolean) {.importc.}
proc gtk_column_view_column_get_expand*(self: GtkColumnViewColumn): gboolean {.importc.}
proc gtk_column_view_column_set_expand*(self: GtkColumnViewColumn, expand: gboolean) {.importc.}
proc gtk_column_view_column_get_fixed_width*(self: GtkColumnViewColumn): gint {.importc.}
proc gtk_column_view_column_set_fixed_width*(self: GtkColumnViewColumn, fixedWidth: gint) {.importc.}
proc gtk_list_item_get_item*(self: GtkListItem): gpointer {.importc.}
proc gtk_list_item_get_position*(self: GtkListItem): guint {.importc.}
proc gtk_list_item_get_selected*(self: GtkListItem): gboolean {.importc.}
proc gtk_list_item_get_selectable*(self: GtkListItem): gboolean {.importc.}
proc gtk_list_item_set_selectable*(self: GtkListItem, selectable: gboolean) {.importc.}
proc gtk_list_item_get_activatable*(self: GtkListItem): gboolean {.importc.}
proc gtk_list_item_set_activatable*(self: GtkListItem, activatable: gboolean) {.importc.}
proc gtk_list_item_get_child*(self: GtkListItem): GtkWidget {.importc.}
proc gtk_list_item_set_child*(self: GtkListItem, child: GtkWidget) {.importc.}
proc gtk_signal_list_item_factory_new*(): GtkSignalListItemFactory {.importc.}


# ============================================================================
# GRID VIEW
# ============================================================================
type
  GtkGridView* = pointer
proc gtk_grid_view_new*(model: GtkSelectionModel, factory: GtkListItemFactory): GtkGridView {.importc.}
proc gtk_grid_view_get_model*(self: GtkGridView): GtkSelectionModel {.importc.}
proc gtk_grid_view_set_model*(self: GtkGridView, model: GtkSelectionModel) {.importc.}
proc gtk_grid_view_get_factory*(self: GtkGridView): GtkListItemFactory {.importc.}
proc gtk_grid_view_set_factory*(self: GtkGridView, factory: GtkListItemFactory) {.importc.}
proc gtk_grid_view_get_min_columns*(self: GtkGridView): guint {.importc.}
proc gtk_grid_view_set_min_columns*(self: GtkGridView, minColumns: guint) {.importc.}
proc gtk_grid_view_get_max_columns*(self: GtkGridView): guint {.importc.}
proc gtk_grid_view_set_max_columns*(self: GtkGridView, maxColumns: guint) {.importc.}
proc gtk_grid_view_get_enable_rubberband*(self: GtkGridView): gboolean {.importc.}
proc gtk_grid_view_set_enable_rubberband*(self: GtkGridView, enableRubberband: gboolean) {.importc.}
proc gtk_grid_view_get_single_click_activate*(self: GtkGridView): gboolean {.importc.}
proc gtk_grid_view_set_single_click_activate*(self: GtkGridView, singleClickActivate: gboolean) {.importc.}


# ============================================================================
# DROP DOWN
# ============================================================================
type
  GtkDropDown* = pointer
proc gtk_drop_down_new*(model: pointer, expression: pointer): GtkDropDown {.importc.}
proc gtk_drop_down_new_from_strings*(strings: ptr cstring): GtkDropDown {.importc.}
proc gtk_drop_down_get_model*(self: GtkDropDown): pointer {.importc.}
proc gtk_drop_down_set_model*(self: GtkDropDown, model: pointer) {.importc.}
proc gtk_drop_down_get_selected*(self: GtkDropDown): guint {.importc.}
proc gtk_drop_down_set_selected*(self: GtkDropDown, position: guint) {.importc.}
proc gtk_drop_down_get_selected_item*(self: GtkDropDown): gpointer {.importc.}
proc gtk_drop_down_get_factory*(self: GtkDropDown): GtkListItemFactory {.importc.}
proc gtk_drop_down_set_factory*(self: GtkDropDown, factory: GtkListItemFactory) {.importc.}
proc gtk_drop_down_get_list_factory*(self: GtkDropDown): GtkListItemFactory {.importc.}
proc gtk_drop_down_set_list_factory*(self: GtkDropDown, factory: GtkListItemFactory) {.importc.}
proc gtk_drop_down_get_enable_search*(self: GtkDropDown): gboolean {.importc.}
proc gtk_drop_down_set_enable_search*(self: GtkDropDown, enableSearch: gboolean) {.importc.}
proc gtk_drop_down_get_expression*(self: GtkDropDown): pointer {.importc.}
proc gtk_drop_down_set_expression*(self: GtkDropDown, expression: pointer) {.importc.}
proc gtk_drop_down_get_show_arrow*(self: GtkDropDown): gboolean {.importc.}
proc gtk_drop_down_set_show_arrow*(self: GtkDropDown, showArrow: gboolean) {.importc.}


# ============================================================================
# STRING LIST
# ============================================================================
type
  GtkStringList* = pointer
  GtkStringObject* = pointer
proc gtk_string_list_new*(strings: ptr cstring): GtkStringList {.importc.}
proc gtk_string_list_append*(self: GtkStringList, string: cstring) {.importc.}
proc gtk_string_list_take*(self: GtkStringList, string: cstring) {.importc.}
proc gtk_string_list_remove*(self: GtkStringList, position: guint) {.importc.}
proc gtk_string_list_splice*(self: GtkStringList, position: guint, nRemovals: guint, additions: ptr cstring) {.importc.}
proc gtk_string_list_get_string*(self: GtkStringList, position: guint): cstring {.importc.}
proc gtk_string_object_new*(string: cstring): GtkStringObject {.importc.}
proc gtk_string_object_get_string*(self: GtkStringObject): cstring {.importc.}


# ============================================================================
# WINDOW CONTROLS
# ============================================================================
type
  GtkWindowControls* = pointer
  GtkWindowHandle* = pointer
  GtkCenterBox* = pointer
proc gtk_window_controls_new*(side: gint): GtkWindowControls {.importc.}
proc gtk_window_controls_get_side*(self: GtkWindowControls): gint {.importc.}
proc gtk_window_controls_set_side*(self: GtkWindowControls, side: gint) {.importc.}
proc gtk_window_controls_get_decoration_layout*(self: GtkWindowControls): cstring {.importc.}
proc gtk_window_controls_set_decoration_layout*(self: GtkWindowControls, layout: cstring) {.importc.}
proc gtk_window_controls_get_empty*(self: GtkWindowControls): gboolean {.importc.}
proc gtk_window_handle_new*(): GtkWindowHandle {.importc.}
proc gtk_window_handle_get_child*(self: GtkWindowHandle): GtkWidget {.importc.}
proc gtk_window_handle_set_child*(self: GtkWindowHandle, child: GtkWidget) {.importc.}
proc gtk_center_box_new*(): GtkCenterBox {.importc.}
proc gtk_center_box_set_start_widget*(self: GtkCenterBox, child: GtkWidget) {.importc.}
proc gtk_center_box_get_start_widget*(self: GtkCenterBox): GtkWidget {.importc.}
proc gtk_center_box_set_center_widget*(self: GtkCenterBox, child: GtkWidget) {.importc.}
proc gtk_center_box_get_center_widget*(self: GtkCenterBox): GtkWidget {.importc.}
proc gtk_center_box_set_end_widget*(self: GtkCenterBox, child: GtkWidget) {.importc.}
proc gtk_center_box_get_end_widget*(self: GtkCenterBox): GtkWidget {.importc.}
proc gtk_center_box_set_baseline_position*(self: GtkCenterBox, position: GtkPositionType) {.importc.}
proc gtk_center_box_get_baseline_position*(self: GtkCenterBox): GtkPositionType {.importc.}


# ============================================================================
# INSCRIPTION (GTK 4.8+)
# ============================================================================
type
  GtkInscription* = pointer
proc gtk_inscription_new*(text: cstring): GtkInscription {.importc.}
proc gtk_inscription_get_text*(self: GtkInscription): cstring {.importc.}
proc gtk_inscription_set_text*(self: GtkInscription, text: cstring) {.importc.}
proc gtk_inscription_set_markup*(self: GtkInscription, markup: cstring) {.importc.}
proc gtk_inscription_get_attributes*(self: GtkInscription): PangoAttrList {.importc.}
proc gtk_inscription_set_attributes*(self: GtkInscription, attrs: PangoAttrList) {.importc.}
proc gtk_inscription_get_min_chars*(self: GtkInscription): guint {.importc.}
proc gtk_inscription_set_min_chars*(self: GtkInscription, minChars: guint) {.importc.}
proc gtk_inscription_get_nat_chars*(self: GtkInscription): guint {.importc.}
proc gtk_inscription_set_nat_chars*(self: GtkInscription, natChars: guint) {.importc.}
proc gtk_inscription_get_min_lines*(self: GtkInscription): guint {.importc.}
proc gtk_inscription_set_min_lines*(self: GtkInscription, minLines: guint) {.importc.}
proc gtk_inscription_get_nat_lines*(self: GtkInscription): guint {.importc.}
proc gtk_inscription_set_nat_lines*(self: GtkInscription, natLines: guint) {.importc.}
proc gtk_inscription_get_xalign*(self: GtkInscription): gfloat {.importc.}
proc gtk_inscription_set_xalign*(self: GtkInscription, xalign: gfloat) {.importc.}
proc gtk_inscription_get_yalign*(self: GtkInscription): gfloat {.importc.}
proc gtk_inscription_set_yalign*(self: GtkInscription, yalign: gfloat) {.importc.}
proc gtk_inscription_get_text_overflow*(self: GtkInscription): gint {.importc.}
proc gtk_inscription_set_text_overflow*(self: GtkInscription, overflow: gint) {.importc.}
proc gtk_inscription_get_wrap_mode*(self: GtkInscription): PangoWrapMode {.importc.}
proc gtk_inscription_set_wrap_mode*(self: GtkInscription, wrapMode: PangoWrapMode) {.importc.}


# ============================================================================
# EDITABLE LABEL (GTK 4.10+)
# ============================================================================
type
  GtkEditableLabel* = pointer
proc gtk_editable_label_new*(str: cstring): GtkEditableLabel {.importc.}
proc gtk_editable_label_get_editing*(self: GtkEditableLabel): gboolean {.importc.}
proc gtk_editable_label_start_editing*(self: GtkEditableLabel) {.importc.}
proc gtk_editable_label_stop_editing*(self: GtkEditableLabel, commit: gboolean) {.importc.}






# ============================================================================
# PASSWORD ENTRY BUFFER
# ============================================================================
proc gtk_entry_buffer_new*(initialChars: cstring, nInitialChars: gint): GtkEntryBuffer {.importc.}
proc gtk_entry_buffer_get_text*(buffer: GtkEntryBuffer): cstring {.importc.}
proc gtk_entry_buffer_set_text*(buffer: GtkEntryBuffer, chars: cstring, nChars: gint) {.importc.}
proc gtk_entry_buffer_get_bytes*(buffer: GtkEntryBuffer): gsize {.importc.}
proc gtk_entry_buffer_get_length*(buffer: GtkEntryBuffer): guint {.importc.}
proc gtk_entry_buffer_get_max_length*(buffer: GtkEntryBuffer): gint {.importc.}
proc gtk_entry_buffer_set_max_length*(buffer: GtkEntryBuffer, maxLength: gint) {.importc.}
proc gtk_entry_buffer_insert_text*(buffer: GtkEntryBuffer, position: guint, chars: cstring, nChars: gint): guint {.importc.}
proc gtk_entry_buffer_delete_text*(buffer: GtkEntryBuffer, position: guint, nChars: gint): guint {.importc.}
proc gtk_entry_buffer_emit_deleted_text*(buffer: GtkEntryBuffer, position: guint, nChars: guint) {.importc.}
proc gtk_entry_buffer_emit_inserted_text*(buffer: GtkEntryBuffer, position: guint, chars: cstring, nChars: guint) {.importc.}


# ============================================================================
# FILTER & SORT MODELS
# ============================================================================
type
  GtkFilter* = pointer
  GtkFilterListModel* = pointer
  GtkSortListModel* = pointer
  GtkSorter* = pointer
  GtkCustomFilter* = pointer
  GtkCustomSorter* = pointer
  GtkStringFilter* = pointer
  GtkStringSorter* = pointer
  GtkNumericSorter* = pointer
  GtkMultiSorter* = pointer
proc gtk_filter_list_model_new*(model: pointer, filter: GtkFilter): GtkFilterListModel {.importc.}
proc gtk_filter_list_model_set_filter*(self: GtkFilterListModel, filter: GtkFilter) {.importc.}
proc gtk_filter_list_model_get_filter*(self: GtkFilterListModel): GtkFilter {.importc.}
proc gtk_filter_list_model_set_model*(self: GtkFilterListModel, model: pointer) {.importc.}
proc gtk_filter_list_model_get_model*(self: GtkFilterListModel): pointer {.importc.}
proc gtk_filter_list_model_set_incremental*(self: GtkFilterListModel, incremental: gboolean) {.importc.}
proc gtk_filter_list_model_get_incremental*(self: GtkFilterListModel): gboolean {.importc.}
proc gtk_filter_list_model_get_pending*(self: GtkFilterListModel): guint {.importc.}
proc gtk_sort_list_model_new*(model: pointer, sorter: GtkSorter): GtkSortListModel {.importc.}
proc gtk_sort_list_model_set_sorter*(self: GtkSortListModel, sorter: GtkSorter) {.importc.}
proc gtk_sort_list_model_get_sorter*(self: GtkSortListModel): GtkSorter {.importc.}
proc gtk_sort_list_model_set_model*(self: GtkSortListModel, model: pointer) {.importc.}
proc gtk_sort_list_model_get_model*(self: GtkSortListModel): pointer {.importc.}
proc gtk_sort_list_model_set_incremental*(self: GtkSortListModel, incremental: gboolean) {.importc.}
proc gtk_sort_list_model_get_incremental*(self: GtkSortListModel): gboolean {.importc.}
proc gtk_sort_list_model_get_pending*(self: GtkSortListModel): guint {.importc.}
proc gtk_custom_filter_new*(matchFunc: pointer, userData: gpointer, userDestroy: GDestroyNotify): GtkCustomFilter {.importc.}
proc gtk_custom_filter_set_filter_func*(self: GtkCustomFilter, matchFunc: pointer, userData: gpointer, userDestroy: GDestroyNotify) {.importc.}
proc gtk_string_filter_new*(expression: pointer): GtkStringFilter {.importc.}
proc gtk_string_filter_get_search*(self: GtkStringFilter): cstring {.importc.}
proc gtk_string_filter_set_search*(self: GtkStringFilter, search: cstring) {.importc.}
proc gtk_string_filter_get_expression*(self: GtkStringFilter): pointer {.importc.}
proc gtk_string_filter_set_expression*(self: GtkStringFilter, expression: pointer) {.importc.}
proc gtk_string_filter_get_ignore_case*(self: GtkStringFilter): gboolean {.importc.}
proc gtk_string_filter_set_ignore_case*(self: GtkStringFilter, ignoreCase: gboolean) {.importc.}
proc gtk_string_filter_get_match_mode*(self: GtkStringFilter): gint {.importc.}
proc gtk_string_filter_set_match_mode*(self: GtkStringFilter, mode: gint) {.importc.}
proc gtk_custom_sorter_new*(sortFunc: pointer, userData: gpointer, userDestroy: GDestroyNotify): GtkCustomSorter {.importc.}
proc gtk_custom_sorter_set_sort_func*(self: GtkCustomSorter, sortFunc: pointer, userData: gpointer, userDestroy: GDestroyNotify) {.importc.}
proc gtk_string_sorter_new*(expression: pointer): GtkStringSorter {.importc.}
proc gtk_string_sorter_get_expression*(self: GtkStringSorter): pointer {.importc.}
proc gtk_string_sorter_set_expression*(self: GtkStringSorter, expression: pointer) {.importc.}
proc gtk_string_sorter_get_ignore_case*(self: GtkStringSorter): gboolean {.importc.}
proc gtk_string_sorter_set_ignore_case*(self: GtkStringSorter, ignoreCase: gboolean) {.importc.}
proc gtk_numeric_sorter_new*(expression: pointer): GtkNumericSorter {.importc.}
proc gtk_numeric_sorter_get_expression*(self: GtkNumericSorter): pointer {.importc.}
proc gtk_numeric_sorter_set_expression*(self: GtkNumericSorter, expression: pointer) {.importc.}
proc gtk_numeric_sorter_get_sort_order*(self: GtkNumericSorter): gint {.importc.}
proc gtk_numeric_sorter_set_sort_order*(self: GtkNumericSorter, sortOrder: gint) {.importc.}
proc gtk_multi_sorter_new*(): GtkMultiSorter {.importc.}
proc gtk_multi_sorter_append*(self: GtkMultiSorter, sorter: GtkSorter) {.importc.}
proc gtk_multi_sorter_remove*(self: GtkMultiSorter, position: guint) {.importc.}
proc gtk_filter_changed*(self: GtkFilter, change: gint) {.importc.}
proc gtk_sorter_changed*(self: GtkSorter, change: gint) {.importc.}


# ============================================================================
# EXPRESSIONS (GTK 4 Property Bindings)
# ============================================================================
type
  GtkExpression* = pointer
  GtkPropertyExpression* = pointer
  GtkConstantExpression* = pointer
  GtkObjectExpression* = pointer
  GtkClosureExpression* = pointer
proc gtk_property_expression_new*(thisType: GType, expression: GtkExpression, propertyName: cstring): GtkPropertyExpression {.importc.}
proc gtk_property_expression_get_expression*(expression: GtkPropertyExpression): GtkExpression {.importc.}
proc gtk_property_expression_get_pspec*(expression: GtkPropertyExpression): pointer {.importc.}
proc gtk_constant_expression_new*(valueType: GType): GtkConstantExpression {.importc.}
proc gtk_constant_expression_new_for_value*(value: GValue): GtkConstantExpression {.importc.}
proc gtk_constant_expression_get_value*(expression: GtkConstantExpression): GValue {.importc.}
proc gtk_object_expression_new*(obj: GObject): GtkObjectExpression {.importc.}
proc gtk_object_expression_get_object*(expression: GtkObjectExpression): GObject {.importc.}
proc gtk_closure_expression_new*(valueType: GType, closure: pointer, nParams: guint, params: ptr GtkExpression): GtkClosureExpression {.importc.}
proc gtk_expression_ref*(self: GtkExpression): GtkExpression {.importc.}
proc gtk_expression_unref*(self: GtkExpression) {.importc.}
proc gtk_expression_get_value_type*(self: GtkExpression): GType {.importc.}
proc gtk_expression_is_static*(self: GtkExpression): gboolean {.importc.}
proc gtk_expression_evaluate*(self: GtkExpression, this: gpointer, value: GValue): gboolean {.importc.}
proc gtk_expression_watch*(self: GtkExpression, this: gpointer, notify: pointer, userData: gpointer, userDestroy: GDestroyNotify): pointer {.importc.}
proc gtk_expression_bind*(self: GtkExpression, target: gpointer, property: cstring, this: gpointer): pointer {.importc.}


# ============================================================================
# VIDEO (GTK 4)
# ============================================================================
type
  GtkVideo* = pointer
  GtkMediaStream* = pointer
  GtkMediaFile* = pointer
proc gtk_video_new*(): GtkVideo {.importc.}
proc gtk_video_new_for_media_stream*(stream: GtkMediaStream): GtkVideo {.importc.}
proc gtk_video_new_for_file*(file: GFile): GtkVideo {.importc.}
proc gtk_video_new_for_filename*(filename: cstring): GtkVideo {.importc.}
proc gtk_video_new_for_resource*(resourcePath: cstring): GtkVideo {.importc.}
proc gtk_video_get_media_stream*(self: GtkVideo): GtkMediaStream {.importc.}
proc gtk_video_set_media_stream*(self: GtkVideo, stream: GtkMediaStream) {.importc.}
proc gtk_video_get_file*(self: GtkVideo): GFile {.importc.}
proc gtk_video_set_file*(self: GtkVideo, file: GFile) {.importc.}
proc gtk_video_set_filename*(self: GtkVideo, filename: cstring) {.importc.}
proc gtk_video_set_resource*(self: GtkVideo, resourcePath: cstring) {.importc.}
proc gtk_video_get_autoplay*(self: GtkVideo): gboolean {.importc.}
proc gtk_video_set_autoplay*(self: GtkVideo, autoplay: gboolean) {.importc.}
proc gtk_video_get_loop*(self: GtkVideo): gboolean {.importc.}
proc gtk_video_set_loop*(self: GtkVideo, loop: gboolean) {.importc.}
proc gtk_media_stream_is_prepared*(self: GtkMediaStream): gboolean {.importc.}
proc gtk_media_stream_get_error*(self: GtkMediaStream): GError {.importc.}
proc gtk_media_stream_has_audio*(self: GtkMediaStream): gboolean {.importc.}
proc gtk_media_stream_has_video*(self: GtkMediaStream): gboolean {.importc.}
proc gtk_media_stream_play*(self: GtkMediaStream) {.importc.}
proc gtk_media_stream_pause*(self: GtkMediaStream) {.importc.}
proc gtk_media_stream_get_playing*(self: GtkMediaStream): gboolean {.importc.}
proc gtk_media_stream_set_playing*(self: GtkMediaStream, playing: gboolean) {.importc.}
proc gtk_media_stream_get_ended*(self: GtkMediaStream): gboolean {.importc.}
proc gtk_media_stream_get_timestamp*(self: GtkMediaStream): gint64 {.importc.}
proc gtk_media_stream_get_duration*(self: GtkMediaStream): gint64 {.importc.}
proc gtk_media_stream_is_seekable*(self: GtkMediaStream): gboolean {.importc.}
proc gtk_media_stream_is_seeking*(self: GtkMediaStream): gboolean {.importc.}
proc gtk_media_stream_seek*(self: GtkMediaStream, timestamp: gint64) {.importc.}
proc gtk_media_stream_get_loop*(self: GtkMediaStream): gboolean {.importc.}
proc gtk_media_stream_set_loop*(self: GtkMediaStream, loop: gboolean) {.importc.}
proc gtk_media_stream_get_muted*(self: GtkMediaStream): gboolean {.importc.}
proc gtk_media_stream_set_muted*(self: GtkMediaStream, muted: gboolean) {.importc.}
proc gtk_media_stream_get_volume*(self: GtkMediaStream): gdouble {.importc.}
proc gtk_media_stream_set_volume*(self: GtkMediaStream, volume: gdouble) {.importc.}
proc gtk_media_stream_realize*(self: GtkMediaStream, surface: pointer) {.importc.}
proc gtk_media_stream_unrealize*(self: GtkMediaStream, surface: pointer) {.importc.}
proc gtk_media_file_new*(): GtkMediaFile {.importc.}
proc gtk_media_file_new_for_filename*(filename: cstring): GtkMediaFile {.importc.}
proc gtk_media_file_new_for_resource*(resourcePath: cstring): GtkMediaFile {.importc.}
proc gtk_media_file_new_for_file*(file: GFile): GtkMediaFile {.importc.}
proc gtk_media_file_clear*(self: GtkMediaFile) {.importc.}
proc gtk_media_file_set_filename*(self: GtkMediaFile, filename: cstring) {.importc.}
proc gtk_media_file_set_resource*(self: GtkMediaFile, resourcePath: cstring) {.importc.}
proc gtk_media_file_set_file*(self: GtkMediaFile, file: GFile) {.importc.}
proc gtk_media_file_get_file*(self: GtkMediaFile): GFile {.importc.}
proc gtk_media_file_set_input_stream*(self: GtkMediaFile, stream: pointer) {.importc.}
proc gtk_media_file_get_input_stream*(self: GtkMediaFile): pointer {.importc.}


# ============================================================================
# MEDIA CONTROLS
# ============================================================================
type
  GtkMediaControls* = pointer
proc gtk_media_controls_new*(stream: GtkMediaStream): GtkMediaControls {.importc.}
proc gtk_media_controls_get_media_stream*(self: GtkMediaControls): GtkMediaStream {.importc.}
proc gtk_media_controls_set_media_stream*(self: GtkMediaControls, stream: GtkMediaStream) {.importc.}


# ============================================================================
# SNAPSHOT (Drawing API)
# ============================================================================
type
  GtkSnapshot* = pointer
  GdkRGBA* = object
    red*: gdouble
    green*: gdouble
    blue*: gdouble
    alpha*: gdouble
proc gtk_snapshot_new*(): GtkSnapshot {.importc.}
proc gtk_snapshot_free_to_node*(snapshot: GtkSnapshot): pointer {.importc.}
proc gtk_snapshot_free_to_paintable*(snapshot: GtkSnapshot, size: pointer): pointer {.importc.}
proc gtk_snapshot_to_node*(snapshot: GtkSnapshot): pointer {.importc.}
proc gtk_snapshot_to_paintable*(snapshot: GtkSnapshot, size: pointer): pointer {.importc.}
proc gtk_snapshot_append_node*(snapshot: GtkSnapshot, node: pointer) {.importc.}
proc gtk_snapshot_append_cairo*(snapshot: GtkSnapshot, bounds: pointer): cairo_t {.importc.}
proc gtk_snapshot_append_color*(snapshot: GtkSnapshot, color: ptr GdkRGBA, bounds: pointer) {.importc.}
proc gtk_snapshot_append_texture*(snapshot: GtkSnapshot, texture: GdkTexture, bounds: pointer) {.importc.}
proc gtk_snapshot_append_border*(snapshot: GtkSnapshot, outline: pointer, borderWidth: ptr gfloat, borderColor: ptr GdkRGBA) {.importc.}
proc gtk_snapshot_push_opacity*(snapshot: GtkSnapshot, opacity: gdouble) {.importc.}
proc gtk_snapshot_push_blur*(snapshot: GtkSnapshot, radius: gdouble) {.importc.}
proc gtk_snapshot_push_clip*(snapshot: GtkSnapshot, bounds: pointer) {.importc.}
proc gtk_snapshot_push_cross_fade*(snapshot: GtkSnapshot, progress: gdouble) {.importc.}
proc gtk_snapshot_pop*(snapshot: GtkSnapshot) {.importc.}
proc gtk_snapshot_save*(snapshot: GtkSnapshot) {.importc.}
proc gtk_snapshot_restore*(snapshot: GtkSnapshot) {.importc.}
proc gtk_snapshot_transform*(snapshot: GtkSnapshot, transform: pointer) {.importc.}
proc gtk_snapshot_translate*(snapshot: GtkSnapshot, point: pointer) {.importc.}
proc gtk_snapshot_rotate*(snapshot: GtkSnapshot, angle: gfloat) {.importc.}
proc gtk_snapshot_scale*(snapshot: GtkSnapshot, factorX: gfloat, factorY: gfloat) {.importc.}


# ============================================================================
# COLOR UTILITIES
# ============================================================================
proc gdk_rgba_parse*(rgba: ptr GdkRGBA, spec: cstring): gboolean {.importc.}
proc gdk_rgba_to_string*(rgba: ptr GdkRGBA): cstring {.importc.}
proc gdk_rgba_copy*(rgba: ptr GdkRGBA): ptr GdkRGBA {.importc.}
proc gdk_rgba_free*(rgba: ptr GdkRGBA) {.importc.}
proc gdk_rgba_equal*(p1: ptr GdkRGBA, p2: ptr GdkRGBA): gboolean {.importc.}
proc gdk_rgba_hash*(p: ptr GdkRGBA): guint {.importc.}


# ============================================================================
# ADDITIONAL GLIB LIST FUNCTIONS
# ============================================================================
type
  GList* = object
    data*: gpointer
    next*: ptr GList
    prev*: ptr GList
  GSList* = object
    data*: gpointer
    next*: ptr GSList
proc g_list_append*(list: ptr GList, data: gpointer): ptr GList {.importc.}
proc g_list_prepend*(list: ptr GList, data: gpointer): ptr GList {.importc.}
proc g_list_insert*(list: ptr GList, data: gpointer, position: gint): ptr GList {.importc.}
proc g_list_remove*(list: ptr GList, data: gconstpointer): ptr GList {.importc.}
proc g_list_remove_link*(list: ptr GList, llink: ptr GList): ptr GList {.importc.}
proc g_list_delete_link*(list: ptr GList, linkList: ptr GList): ptr GList {.importc.}
proc g_list_remove_all*(list: ptr GList, data: gconstpointer): ptr GList {.importc.}
proc g_list_free*(list: ptr GList) {.importc.}
proc g_list_free_full*(list: ptr GList, freeFunc: GDestroyNotify) {.importc.}
proc g_list_length*(list: ptr GList): guint {.importc.}
proc g_list_copy*(list: ptr GList): ptr GList {.importc.}
proc g_list_nth*(list: ptr GList, n: guint): ptr GList {.importc.}
proc g_list_nth_data*(list: ptr GList, n: guint): gpointer {.importc.}
proc g_list_find*(list: ptr GList, data: gconstpointer): ptr GList {.importc.}
proc g_list_position*(list: ptr GList, llink: ptr GList): gint {.importc.}
proc g_list_index*(list: ptr GList, data: gconstpointer): gint {.importc.}
proc g_list_last*(list: ptr GList): ptr GList {.importc.}
proc g_list_first*(list: ptr GList): ptr GList {.importc.}
proc g_list_reverse*(list: ptr GList): ptr GList {.importc.}
proc g_list_sort*(list: ptr GList, compareFunc: pointer): ptr GList {.importc.}
proc g_list_concat*(list1: ptr GList, list2: ptr GList): ptr GList {.importc.}
proc g_list_foreach*(list: ptr GList, callback: pointer, userData: gpointer) {.importc.}
proc g_slist_append*(list: ptr GSList, data: gpointer): ptr GSList {.importc.}
proc g_slist_prepend*(list: ptr GSList, data: gpointer): ptr GSList {.importc.}
proc g_slist_free*(list: ptr GSList) {.importc.}
proc g_slist_length*(list: ptr GSList): guint {.importc.}




# ============================================================================
# ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ и ШАБЛОНЫ
# ============================================================================
template gtk_widget_destroy*(widget: GtkWidget) =
  g_object_unref(widget)
template gtk_main_quit*() =
  discard # В GTK4 используется g_application_quit


# ----------------------------------------------------------------------------
# Преобразование типов
# ----------------------------------------------------------------------------

template toGtkWidget*(w: pointer): GtkWidget = cast[GtkWidget](w)
template toGtkWindow*(w: pointer): GtkWindow = cast[GtkWindow](w)
template toGtkButton*(w: pointer): GtkButton = cast[GtkButton](w)
template toGtkLabel*(w: pointer): GtkLabel = cast[GtkLabel](w)
template toGtkEntry*(w: pointer): GtkEntry = cast[GtkEntry](w)
template toGtkBox*(w: pointer): GtkBox = cast[GtkBox](w)
template toGtkGrid*(w: pointer): GtkGrid = cast[GtkGrid](w)
template toGtkApplication*(a: pointer): GtkApplication = cast[GtkApplication](a)
template toGApplication*(a: pointer): GApplication = cast[GApplication](a)
template toGObject*(o: pointer): GObject = cast[GObject](o)

# Обратные преобразования
template toPointer*(w: typed): pointer = cast[pointer](w)

# ----------------------------------------------------------------------------
# Работа со строками (безопасное преобразование)
# ----------------------------------------------------------------------------

proc toGtkString*(s: string): cstring =
  ## Безопасное преобразование Nim string в cstring для GTK
  if s.len > 0:
    result = cstring(s)
  else:
    result = nil

proc fromGtkString*(s: cstring): string =
  ## Безопасное преобразование cstring из GTK в Nim string
  if s != nil:
    result = $s
  else:
    result = ""

proc freeGtkString*(s: cstring) =
  ## Освобождение строки, выделенной GTK
  if s != nil:
    g_free(cast[gpointer](s))


# ----------------------------------------------------------------------------
# Callback-хелперы
# ----------------------------------------------------------------------------
type
  GtkCallback0* = proc() {.cdecl.}
  GtkCallback1*[T] = proc(arg: T) {.cdecl.}
  GtkCallback2*[T, U] = proc(arg1: T, arg2: U) {.cdecl.}
  GtkCallback3*[T, U, V] = proc(arg1: T, arg2: U, arg3: V) {.cdecl.}

# Обёртки для удобного подключения сигналов
proc connect*(widget: GtkWidget, signal: string, callback: GCallback, data: pointer = nil): gulong =
  ## Упрощенное подключение сигнала
  result = g_signal_connect(widget, signal.cstring, callback, data)

proc disconnect*(widget: GtkWidget, handlerId: gulong) =
  ## Отключение сигнала
  g_signal_handler_disconnect(widget, handlerId)

proc connectAfter*(widget: GtkWidget, signal: string, callback: GCallback, data: pointer = nil): gulong =
  ## Подключение сигнала, который вызывается после основного обработчика
  result = g_signal_connect_data(widget, signal.cstring, callback, data, nil, 1)

# Макрос для создания безопасных callback'ов
template makeCallback*(name: untyped, body: untyped): untyped =
  proc name() {.cdecl.} =
    try:
      body
    except:
      echo "Error in callback: ", getCurrentExceptionMsg()

# ----------------------------------------------------------------------------
# Работа с boolean значениями
# ----------------------------------------------------------------------------
proc toGboolean*(b: bool): gboolean =
  if b: TRUE else: FALSE

proc fromGboolean*(gb: gboolean): bool =
  gb != FALSE

converter boolToGboolean*(b: bool): gboolean = toGboolean(b)
converter gbooleanToBool*(gb: gboolean): bool = fromGboolean(gb)

# ----------------------------------------------------------------------------
# Утилиты для работы с виджетами
# ----------------------------------------------------------------------------
proc setMargins*(widget: GtkWidget, top, right, bottom, left: int) =
  ## Установка отступов со всех сторон
  gtk_widget_set_margin_top(widget, top.gint)
  gtk_widget_set_margin_end(widget, right.gint)
  gtk_widget_set_margin_bottom(widget, bottom.gint)
  gtk_widget_set_margin_start(widget, left.gint)

proc setMargins*(widget: GtkWidget, all: int) =
  ## Установка одинаковых отступов со всех сторон
  setMargins(widget, all, all, all, all)

proc setSizeHints*(widget: GtkWidget, width, height: int) =
  ## Установка минимального размера виджета
  gtk_widget_set_size_request(widget, width.gint, height.gint)

proc setExpand*(widget: GtkWidget, horizontal, vertical: bool) =
  ## Установка расширения по осям
  gtk_widget_set_hexpand(widget, horizontal.toGboolean)
  gtk_widget_set_vexpand(widget, vertical.toGboolean)

proc setAlign*(widget: GtkWidget, halign, valign: GtkAlign) =
  ## Установка выравнивания
  gtk_widget_set_halign(widget, halign)
  gtk_widget_set_valign(widget, valign)

proc addCssClass*(widget: GtkWidget, classes: varargs[string]) =
  ## Добавление нескольких CSS классов
  for class in classes:
    gtk_widget_add_css_class(widget, class.cstring)

proc removeCssClass*(widget: GtkWidget, classes: varargs[string]) =
  ## Удаление нескольких CSS классов
  for class in classes:
    gtk_widget_remove_css_class(widget, class.cstring)


# ----------------------------------------------------------------------------
# Хелперы для контейнеров
# ----------------------------------------------------------------------------

proc addChildren*(box: GtkBox, children: varargs[GtkWidget]) =
  ## Добавление нескольких дочерних элементов в Box
  for child in children:
    gtk_box_append(box, child)

proc packStart*(box: GtkBox, child: GtkWidget, expand: bool = false) =
  ## Старый стиль добавления в начало (совместимость с GTK3)
  gtk_box_prepend(box, child)
  if expand:
    gtk_widget_set_hexpand(child, TRUE)
    gtk_widget_set_vexpand(child, TRUE)

proc packEnd*(box: GtkBox, child: GtkWidget, expand: bool = false) =
  ## Старый стиль добавления в конец (совместимость с GTK3)
  gtk_box_append(box, child)
  if expand:
    gtk_widget_set_hexpand(child, TRUE)
    gtk_widget_set_vexpand(child, TRUE)

proc attachGrid*(grid: GtkGrid, child: GtkWidget,
            x = 1, y = 1, width = 1, height = 1) =
  ## Упрощенное добавление в Grid
  gtk_grid_attach(grid, child, x.gint, y.gint, width.gint, height.gint)

# ----------------------------------------------------------------------------
# Работа с окнами
# ----------------------------------------------------------------------------

proc createWindow*(title: string, width = 400, height = 300): GtkWindow =
  ## Создание окна с базовыми настройками
  result = gtk_window_new()
  gtk_window_set_title(result, title.cstring)
  gtk_window_set_default_size(result, width.gint, height.gint)

proc createAppWindow*(app: GtkApplication, title: string, width = 400, height = 300): GtkWindow =
  ## Создание окна приложения
  result = gtk_application_window_new(app)
  gtk_window_set_title(result, title.cstring)
  gtk_window_set_default_size(result, width.gint, height.gint)

proc centerWindow*(window: GtkWindow) =
  ## Центрирование окна (устанавливает position в center через CSS или свойства)
  # В GTK4 центрирование делается через default-width/height автоматически
  discard

# ----------------------------------------------------------------------------
# Создание распространенных виджетов
# ----------------------------------------------------------------------------

proc createButton*(label: string, onClick: GCallback = nil, data: pointer = nil): GtkButton =
  ## Создание кнопки с текстом и опциональным обработчиком
  result = gtk_button_new_with_label(label.cstring)
  if onClick != nil:
    discard g_signal_connect(result, "clicked", onClick, data)

proc createLabel*(text: string, markup = false): GtkLabel =
  ## Создание метки
  result = gtk_label_new(text.cstring)
  if markup:
    gtk_label_set_use_markup(result, TRUE)

proc createEntry*(placeholder = "", maxLength = 0): GtkEntry =
  ## Создание поля ввода
  result = gtk_entry_new()
  if placeholder.len > 0:
    gtk_entry_set_placeholder_text(result, placeholder.cstring)
  if maxLength > 0:
    gtk_entry_set_max_length(result, maxLength.gint)

proc createPasswordEntry*(placeholder = ""): GtkPasswordEntry =
  ## Создание поля для пароля
  result = gtk_password_entry_new()
  if placeholder.len > 0:
    gtk_entry_set_placeholder_text(cast[GtkEntry](result), placeholder.cstring)

proc createCheckButton*(label: string, active = false): GtkCheckButton =
  ## Создание чекбокса
  result = gtk_check_button_new_with_label(label.cstring)
  gtk_check_button_set_active(result, active.toGboolean)

proc createSwitch*(active = false): GtkSwitch =
  ## Создание переключателя
  result = gtk_switch_new()
  gtk_switch_set_active(result, active.toGboolean)

proc createSpinButton*(min, max, step: float, value = 0.0, digits = 0): GtkSpinButton =
  ## Создание числового поля
  result = gtk_spin_button_new_with_range(min, max, step)
  gtk_spin_button_set_value(result, value)
  gtk_spin_button_set_digits(result, digits.guint)

proc createScale*(min, max, step: float, value = 0.0, orientation = GTK_ORIENTATION_HORIZONTAL): GtkScale =
  ## Создание ползунка
  result = gtk_scale_new_with_range(orientation, min, max, step)
  gtk_range_set_value(cast[GtkRange](result), value)

proc createProgressBar*(fraction = 0.0, showText = false): GtkProgressBar =
  ## Создание прогресс-бара
  result = gtk_progress_bar_new()
  gtk_progress_bar_set_fraction(result, fraction)
  gtk_progress_bar_set_show_text(result, showText.toGboolean)

# ----------------------------------------------------------------------------
# Создание контейнеров
# ----------------------------------------------------------------------------

proc createHBox*(spacing = 0, homogeneous = false): GtkBox =
  ## Создание горизонтального контейнера
  result = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, spacing.gint)
  gtk_box_set_homogeneous(result, homogeneous.toGboolean)

proc createVBox*(spacing = 0, homogeneous = false): GtkBox =
  ## Создание вертикального контейнера
  result = gtk_box_new(GTK_ORIENTATION_VERTICAL, spacing.gint)
  gtk_box_set_homogeneous(result, homogeneous.toGboolean)

proc createGrid*(rowSpacing = 0, columnSpacing = 0, homogeneous = false): GtkGrid =
  ## Создание сетки
  result = gtk_grid_new()
  gtk_grid_set_row_spacing(result, rowSpacing.guint)
  gtk_grid_set_column_spacing(result, columnSpacing.guint)
  gtk_grid_set_row_homogeneous(result, homogeneous.toGboolean)
  gtk_grid_set_column_homogeneous(result, homogeneous.toGboolean)

proc createScrolledWindow*(child: GtkWidget = nil, hpolicy = GTK_POLICY_AUTOMATIC, vpolicy = GTK_POLICY_AUTOMATIC): GtkScrolledWindow =
  ## Создание прокручиваемого окна
  result = gtk_scrolled_window_new()
  gtk_scrolled_window_set_policy(result, hpolicy, vpolicy)
  if child != nil:
    gtk_scrolled_window_set_child(result, child)

proc createFrame*(label = "", child: GtkWidget = nil): GtkFrame =
  ## Создание рамки
  result = gtk_frame_new(if label.len > 0: label.cstring else: nil)
  if child != nil:
    gtk_frame_set_child(result, child)

proc createNotebook*(): GtkNotebook =
  ## Создание вкладок
  result = gtk_notebook_new()

proc addTab*(notebook: GtkNotebook, child: GtkWidget, label: string): int =
  ## Добавление вкладки
  let tabLabel = gtk_label_new(label.cstring)
  result = gtk_notebook_append_page(notebook, child, tabLabel).int

proc createPaned*(orientation = GTK_ORIENTATION_HORIZONTAL): GtkPaned =
  ## Создание разделяемой панели
  result = gtk_paned_new(orientation)

proc createStack*(): GtkStack =
  ## Создание стека
  result = gtk_stack_new()

proc addToStack*(stack: GtkStack, child: GtkWidget, name, title: string): GtkWidget =
  ## Добавление виджета в стек
  result = gtk_stack_add_titled(stack, child, name.cstring, title.cstring)



# ----------------------------------------------------------------------------
# Диалоги
# ----------------------------------------------------------------------------

proc showMessageDialog*(parent: GtkWindow, title, message: string, msgType = GTK_MESSAGE_INFO) =
  ## Показать простое сообщение
  let dialog = gtk_message_dialog_new(parent, 0, msgType, GTK_BUTTONS_OK, message.cstring)
  gtk_window_set_title(cast[GtkWindow](dialog), title.cstring)
  discard g_signal_connect(dialog, "response", cast[GCallback](gtk_window_destroy), nil)
  gtk_window_present(cast[GtkWindow](dialog))

proc showErrorDialog*(parent: GtkWindow, title, message: string) =
  ## Показать диалог ошибки
  showMessageDialog(parent, title, message, GTK_MESSAGE_ERROR)

proc showWarningDialog*(parent: GtkWindow, title, message: string) =
  ## Показать диалог предупреждения
  showMessageDialog(parent, title, message, GTK_MESSAGE_WARNING)

proc showInfoDialog*(parent: GtkWindow, title, message: string) =
  ## Показать информационный диалог
  showMessageDialog(parent, title, message, GTK_MESSAGE_INFO)

# ----------------------------------------------------------------------------
# Работа с CSS
# ----------------------------------------------------------------------------

proc loadCssFromString*(css: string): GtkCssProvider =
  ## Загрузка CSS из строки
  result = gtk_css_provider_new()
  gtk_css_provider_load_from_data(result, css.cstring, css.len.gssize)
  let display = gdk_display_get_default()
  gtk_style_context_add_provider_for_display(display, cast[pointer](result), 
                                               GTK_STYLE_PROVIDER_PRIORITY_APPLICATION.guint)

proc loadCssFromFile*(filename: string): GtkCssProvider =
  ## Загрузка CSS из файла
  result = gtk_css_provider_new()
  gtk_css_provider_load_from_path(result, filename.cstring)
  let display = gdk_display_get_default()
  gtk_style_context_add_provider_for_display(display, cast[pointer](result), 
                                               GTK_STYLE_PROVIDER_PRIORITY_APPLICATION.guint)

proc applyCss*(widget: GtkWidget, css: string) =
  ## Применение CSS к конкретному виджету
  let provider = gtk_css_provider_new()
  gtk_css_provider_load_from_data(provider, css.cstring, css.len.gssize)
  let context = gtk_widget_get_style_context(widget)
  gtk_style_context_add_provider(context, cast[pointer](provider), 
                                  GTK_STYLE_PROVIDER_PRIORITY_APPLICATION.guint)

# ----------------------------------------------------------------------------
# Работа с изображениями
# ----------------------------------------------------------------------------

proc createImage*(filename: string): GtkImage =
  ## Создание изображения из файла
  result = gtk_image_new_from_file(filename.cstring)

proc createImageFromIcon*(iconName: string, size = 32): GtkImage =
  ## Создание изображения из иконки
  result = gtk_image_new_from_icon_name(iconName.cstring)
  gtk_image_set_pixel_size(result, size.gint)

proc setImageFromFile*(image: GtkImage, filename: string) =
  ## Установка изображения из файла
  gtk_image_set_from_file(image, filename.cstring)

# ----------------------------------------------------------------------------
# Работа с цветами
# ----------------------------------------------------------------------------

proc parseColor*(colorStr: string): GdkRGBA =
  ## Парсинг цвета из строки (например, "#FF0000", "red", "rgb(255,0,0)")
  discard gdk_rgba_parse(addr result, colorStr.cstring)

proc rgba*(r, g, b: float, a = 1.0): GdkRGBA =
  ## Создание цвета из компонентов (0.0 - 1.0)
  result.red = r
  result.green = g
  result.blue = b
  result.alpha = a

proc rgb*(r, g, b: int): GdkRGBA =
  ## Создание цвета из компонентов (0 - 255)
  result.red = r.float / 255.0
  result.green = g.float / 255.0
  result.blue = b.float / 255.0
  result.alpha = 1.0

# ----------------------------------------------------------------------------
# Таймеры и задержки
# ----------------------------------------------------------------------------

proc addTimeout*(interval: int, callback: GSourceFunc, data: pointer = nil): guint =
  ## Добавление таймера (интервал в миллисекундах)
  result = g_timeout_add(interval.guint, callback, data)

proc addTimeoutSeconds*(interval: int, callback: GSourceFunc, data: pointer = nil): guint =
  ## Добавление таймера (интервал в секундах)
  result = g_timeout_add_seconds(interval.guint, callback, data)

proc removeTimeout*(timeoutId: guint): bool =
  ## Удаление таймера
  result = g_source_remove(timeoutId) != 0

proc addIdle*(callback: GSourceFunc, data: pointer = nil): guint =
  ## Добавление idle callback (вызывается когда система не занята)
  result = g_idle_add(callback, data)

# ----------------------------------------------------------------------------
# Работа с буфером обмена
# ----------------------------------------------------------------------------

proc setClipboardText*(text: string) =
  ## Копирование текста в буфер обмена
  let display = gdk_display_get_default()
  let clipboard = gdk_display_get_clipboard(display)
  gdk_clipboard_set_text(clipboard, text.cstring)

proc getClipboardText*(callback: GAsyncReadyCallback, userData: pointer = nil) =
  ## Получение текста из буфера обмена (асинхронно)
  ## Callback получает (sourceObject: pointer, res: pointer, userData: gpointer)
  ## Используйте gdk_clipboard_read_text_finish для получения текста из res
  let display = gdk_display_get_default()
  let clipboard = gdk_display_get_clipboard(display)
  gdk_clipboard_read_text_async(clipboard, nil, callback, userData)

# ----------------------------------------------------------------------------
# Утилиты для TreeView (совместимость с GTK3)
# WARNING: These utilities are for deprecated GTK3 TreeView API
# ----------------------------------------------------------------------------

when not defined(GTK_DISABLE_DEPRECATED):
  proc createListStore*(columnTypes: varargs[GType]): GtkListStore =
    ## Создание ListStore
    var types = newSeq[GType](columnTypes.len)
    for i, t in columnTypes:
      types[i] = t
    result = gtk_list_store_newv(columnTypes.len.gint, types[0].addr)

  proc createTreeView*(model: GtkTreeModel = nil): GtkTreeView =
    ## Создание TreeView
    if model != nil:
      result = gtk_tree_view_new_with_model(model)
    else:
      result = gtk_tree_view_new()

  proc addColumn*(treeView: GtkTreeView, title: string, columnIndex: int): GtkTreeViewColumn =
    ## Добавление текстовой колонки
    let renderer = gtk_cell_renderer_text_new()
    result = gtk_tree_view_column_new_with_attributes(title.cstring, renderer, "text", columnIndex.gint, nil)
    discard gtk_tree_view_append_column(treeView, result)

proc appendRow*(listStore: GtkListStore): GtkTreeIter =
  ## Добавление строки в ListStore
  gtk_list_store_append(listStore, addr result)

# ----------------------------------------------------------------------------
# Работа с файлами
# ----------------------------------------------------------------------------

proc createFile*(path: string): GFile =
  ## Создание GFile из пути
  result = g_file_new_for_path(path.cstring)

proc getFilePath*(file: GFile): string =
  ## Получение пути из GFile
  let path = g_file_get_path(file)
  if path != nil:
    result = $path
    g_free(cast[gpointer](path))
  else:
    result = ""

# ----------------------------------------------------------------------------
# Утилиты для отладки
# ----------------------------------------------------------------------------

proc printWidgetTree*(widget: GtkWidget, indent = 0) =
  ## Вывод дерева виджетов (для отладки)
  let name = gtk_widget_get_name(widget)
  echo "  ".repeat(indent), if name != nil: $name else: "unnamed"
  
  var child = gtk_widget_get_first_child(widget)
  while child != nil:
    printWidgetTree(child, indent + 1)
    child = gtk_widget_get_next_sibling(child)

proc dumpWidgetInfo*(widget: GtkWidget) =
  ## Вывод информации о виджете
  echo "Widget Info:"
  echo "  Name: ", gtk_widget_get_name(widget)
  echo "  Visible: ", gtk_widget_get_visible(widget)
  echo "  Sensitive: ", gtk_widget_get_sensitive(widget)
  echo "  Can Focus: ", gtk_widget_get_can_focus(widget)
  
  var w, h: gint
  gtk_widget_get_size_request(widget, addr w, addr h)
  echo "  Size Request: ", w, "x", h

# ----------------------------------------------------------------------------
# Builder утилиты
# ----------------------------------------------------------------------------

proc loadBuilder*(filename: string): GtkBuilder =
  ## Загрузка UI из файла
  result = gtk_builder_new_from_file(filename.cstring)

proc loadBuilderFromString*(uiDefinition: string): GtkBuilder =
  ## Загрузка UI из строки
  result = gtk_builder_new_from_string(uiDefinition.cstring, uiDefinition.len.gssize)

proc getWidget*(builder: GtkBuilder, name: string): GtkWidget =
  ## Получение виджета по имени из Builder
  result = cast[GtkWidget](gtk_builder_get_object(builder, name.cstring))

proc getObject*[T](builder: GtkBuilder, name: string): T =
  ## Получение объекта по имени из Builder с приведением типа
  result = cast[T](gtk_builder_get_object(builder, name.cstring))

# ----------------------------------------------------------------------------
# Gesture утилиты
# ----------------------------------------------------------------------------

proc addClickGesture*(widget: GtkWidget, button = 1'u): GtkGestureClick =
  ## Добавление обработчика кликов
  result = gtk_gesture_click_new()
  gtk_gesture_click_set_button(result, button.guint)
  gtk_widget_add_controller(widget, cast[GtkEventController](result))

proc addDragGesture*(widget: GtkWidget): GtkGestureDrag =
  ## Добавление обработчика перетаскивания
  result = gtk_gesture_drag_new()
  gtk_widget_add_controller(widget, cast[GtkEventController](result))

proc addKeyController*(widget: GtkWidget): GtkEventControllerKey =
  ## Добавление обработчика клавиатуры
  result = gtk_event_controller_key_new()
  gtk_widget_add_controller(widget, cast[GtkEventController](result))

# ----------------------------------------------------------------------------
# Удобные константы
# ----------------------------------------------------------------------------

const
  # Стандартные иконки
  ICON_DOCUMENT_NEW* = "document-new"
  ICON_DOCUMENT_OPEN* = "document-open"
  ICON_DOCUMENT_SAVE* = "document-save"
  ICON_DOCUMENT_SAVE_AS* = "document-save-as"
  ICON_EDIT_COPY* = "edit-copy"
  ICON_EDIT_CUT* = "edit-cut"
  ICON_EDIT_PASTE* = "edit-paste"
  ICON_EDIT_DELETE* = "edit-delete"
  ICON_EDIT_UNDO* = "edit-undo"
  ICON_EDIT_REDO* = "edit-redo"
  ICON_EDIT_FIND* = "edit-find"
  ICON_GO_HOME* = "go-home"
  ICON_GO_PREVIOUS* = "go-previous"
  ICON_GO_NEXT* = "go-next"
  ICON_GO_UP* = "go-up"
  ICON_GO_DOWN* = "go-down"
  ICON_LIST_ADD* = "list-add"
  ICON_LIST_REMOVE* = "list-remove"
  ICON_DIALOG_ERROR* = "dialog-error"
  ICON_DIALOG_WARNING* = "dialog-warning"
  ICON_DIALOG_INFORMATION* = "dialog-information"
  ICON_DIALOG_QUESTION* = "dialog-question"







# ----------------------------------------------------------------------------
# Экспортируемые шаблоны для упрощения кода
# ----------------------------------------------------------------------------

template withSignalBlock*(widget: GtkWidget, handlerId: gulong, body: untyped) =
  ## Временная блокировка сигнала
  g_signal_handler_block(widget, handlerId)
  try:
    body
  finally:
    g_signal_handler_unblock(widget, handlerId)

template connectSimple*(widget: GtkWidget, signal: string, code: untyped): gulong =
  ## Упрощенное подключение сигнала с inline кодом
  block:
    proc callback(w: GtkWidget, userData: pointer) {.cdecl.} =
      try:
        code
      except:
        echo "Error in signal handler: ", getCurrentExceptionMsg()
    g_signal_connect(widget, signal.cstring, cast[GCallback](callback), nil)

# G_CONNECT_AFTER
template g_signal_connect_after*(instance, signal, callback, data: untyped): untyped =
  g_signal_connect_data(instance, signal, cast[GCallback](callback), data, nil, 1)

# G_CONNECT_SWAPPED
template g_signal_connect_swapped*(instance, signal, callback, data: untyped): untyped =
  g_signal_connect_data(instance, signal, cast[GCallback](callback), data, nil, 2)





# ============================================================================
# ДОПОЛНИТЕЛЬНЫЕ ФУНКЦИИ GTK4 И ВСПОМОГАТЕЛЬНЫЕ API
# ============================================================================


# ============================================================================
# GTK API
# ============================================================================

{.push importc, cdecl.}
proc gtk_inspector_a11y_get_type*(): pointer
proc gtk_a11y_overlay_new*(): pointer
proc gtk_inspector_action_editor_get_type*(): pointer
proc gtk_inspector_action_editor_update*(self: pointer)

{.pop.}

# ============================================================================
# ACTION API
# ============================================================================

{.push importc, cdecl.}
proc action_holder_changed*(holder: pointer)

{.pop.}

# ============================================================================
# GTK API
# ============================================================================

{.push importc, cdecl.}
proc gtk_inspector_actions_get_type*(): pointer
proc gtk_baseline_overlay_new*(): pointer
proc gtk_inspector_clipboard_get_type*(): pointer
proc gtk_inspector_css_editor_get_type*(): pointer
proc gtk_inspector_css_node_tree_get_type*(): pointer
proc gtk_inspector_css_node_tree_get_node*(cnt: pointer): pointer
proc gtk_inspector_event_recording_get_type*(): GType
proc gtk_inspector_event_recording_get_event*(recording: pointer): pointer
proc gtk_inspector_event_recording_get_target_type*(recording: pointer): GType
proc gtk_focus_overlay_new*(): pointer
proc gtk_fps_overlay_new*(): pointer
proc gtk_inspector_general_get_type*(): pointer

{.pop.}

# ============================================================================
# GRAPH API
# ============================================================================

{.push importc, cdecl.}
proc graph_data_get_n_values*(data: pointer): guint
proc graph_data_get_minimum*(data: pointer): pointer
proc graph_data_get_maximum*(data: pointer): pointer

{.pop.}

# ============================================================================
# GSK API
# ============================================================================

{.push importc, cdecl.}
proc gsk_pango_renderer_release*(crenderer: pointer)

{.pop.}

# ============================================================================
# GTK API
# ============================================================================

{.push importc, cdecl.}
proc gtk_about_dialog_get_license_type*(about: pointer): pointer
proc gtk_about_dialog_get_wrap_license*(about: pointer): pointer
proc gtk_about_dialog_get_system_information*(about: pointer): pointer
proc gtk_about_dialog_get_documenters*(about: pointer): pointer
proc gtk_about_dialog_get_artists*(about: pointer): pointer
proc gtk_about_dialog_get_translator_credits*(about: pointer): pointer
proc gtk_accessible_attribute_set_ref*(self: pointer): pointer
proc gtk_accessible_attribute_set_unref*(self: pointer)
proc gtk_accessible_attribute_set_get_length*(self: pointer): gsize
proc gtk_accessible_attribute_set_get_changed*(self: pointer): guint
proc gtk_accessible_attribute_set_to_string*(self: pointer): cstring
proc gtk_accessible_get_at_context*(self: pointer): pointer
proc gtk_accessible_get_accessible_parent*(self: pointer): pointer
proc gtk_accessible_get_first_accessible_child*(self: pointer): pointer
proc gtk_accessible_get_next_accessible_sibling*(self: pointer): pointer
proc gtk_accessible_get_accessible_id*(self: pointer): pointer
proc gtk_accessible_get_accessible_role*(self: pointer): pointer
proc gtk_accessible_list_get_type*(): pointer
proc gtk_accessible_list_get_objects*(accessible_list: pointer): pointer
proc gtk_accessible_list_new_from_list*(list: pointer): pointer
proc gtk_accessible_hypertext_get_n_links*(self: pointer): pointer
proc gtk_accessible_hyperlink_get_index*(self: pointer): pointer
proc gtk_accessible_hyperlink_get_uri*(self: pointer): cstring
proc gtk_accessible_role_is_range_subclass*(role: pointer): gboolean
proc gtk_accessible_role_is_abstract*(role: pointer): gboolean
proc gtk_accessible_should_present*(self: pointer): gboolean
proc gtk_accessible_bounds_changed*(self: pointer)
proc gtk_accessible_is_password_text*(accessible: pointer): gboolean
proc gtk_accessible_text_update_caret_position*(self: pointer): pointer
proc gtk_accessible_text_update_selection_bound*(self: pointer): pointer
proc gtk_accessible_text_get_character_count*(self: pointer): pointer
proc gtk_accessible_text_get_caret_position*(self: pointer): pointer
proc gtk_accessible_value_error_quark*(): pointer
proc gtk_accessible_value_alloc*(klass: pointer): pointer
proc gtk_accessible_value_ref*(self: pointer): pointer
proc gtk_accessible_value_unref*(self: pointer)
proc gtk_accessible_value_to_string*(self: pointer): cstring
proc gtk_accessible_value_get_default_for_state*(state: pointer): pointer
proc gtk_accessible_value_get_default_for_property*(property: pointer): pointer
proc gtk_accessible_value_get_default_for_relation*(relation: pointer): pointer
proc gtk_undefined_accessible_value_new*(): pointer
proc gtk_undefined_accessible_value_get*(value: pointer): pointer
proc gtk_boolean_accessible_value_new*(value: gboolean): pointer
proc gtk_boolean_accessible_value_get*(value: pointer): gboolean
proc gtk_tristate_accessible_value_new*(value: pointer): pointer
proc gtk_tristate_accessible_value_get*(value: pointer): pointer
proc gtk_int_accessible_value_new*(value: pointer): pointer
proc gtk_int_accessible_value_get*(value: pointer): pointer
proc gtk_number_accessible_value_new*(value: pointer): pointer
proc gtk_number_accessible_value_get*(value: pointer): pointer
proc gtk_string_accessible_value_new*(value: cstring): pointer
proc gtk_string_accessible_value_get*(value: pointer): cstring
proc gtk_reference_accessible_value_new*(value: pointer): pointer
proc gtk_reference_accessible_value_get*(value: pointer): pointer
proc gtk_reference_list_accessible_value_new*(value: pointer): pointer
proc gtk_reference_list_accessible_value_get*(value: pointer): pointer
proc gtk_invalid_accessible_value_new*(value: pointer): pointer
proc gtk_invalid_accessible_value_get*(value: pointer): pointer
proc gtk_invalid_accessible_value_init_value*(value: pointer)
proc gtk_autocomplete_accessible_value_new*(value: pointer): pointer
proc gtk_autocomplete_accessible_value_get*(value: pointer): pointer
proc gtk_autocomplete_accessible_value_init_value*(value: pointer)
proc gtk_orientation_accessible_value_new*(value: pointer): pointer
proc gtk_orientation_accessible_value_get*(value: pointer): pointer
proc gtk_orientation_accessible_value_init_value*(value: pointer)
proc gtk_sort_accessible_value_new*(value: pointer): pointer
proc gtk_sort_accessible_value_get*(value: pointer): pointer
proc gtk_sort_accessible_value_init_value*(value: pointer)
proc gtk_accesskit_context_get_id*(self: pointer): pointer
proc gtk_accesskit_context_update_tree*(self: pointer)
proc gtk_accesskit_root_new*(root_widget: pointer): pointer
proc gtk_accesskit_root_new_id*(self: pointer): pointer
proc gtk_accesskit_root_remove_context*(self: pointer, id: pointer)
proc gtk_accesskit_root_update_tree*(self: pointer)
proc gtk_action_bar_get_revealed*(action_bar: pointer): pointer
proc gtk_action_helper_get_type*(): GType
proc gtk_action_helper_new*(widget: pointer): pointer
proc gtk_action_helper_get_action_name*(helper: pointer): cstring
proc gtk_action_helper_get_action_target_value*(helper: pointer): pointer
proc gtk_action_helper_get_enabled*(helper: pointer): gboolean
proc gtk_action_helper_get_active*(helper: pointer): gboolean
proc gtk_action_helper_activate*(helper: pointer)
proc gtk_action_helper_get_role*(helper: pointer): pointer
proc gtk_action_muxer_get_type*(): GType
proc gtk_action_muxer_new*(widget: GtkWidget): pointer
proc gtk_action_muxer_get_parent*(muxer: pointer): pointer
proc gtk_action_muxer_connect_class_actions*(muxer: pointer)
proc gtk_normalise_detailed_action_name*(detailed_action_name: cstring): cstring
proc gtk_action_observable_get_type*(): GType
proc gtk_action_observer_get_type*(): GType
proc gtk_adjustment_get_step_increment*(adjustment: pointer): pointer
proc gtk_adjustment_get_page_increment*(adjustment: pointer): pointer
proc gtk_adjustment_get_page_size*(adjustment: pointer): pointer
proc gtk_adjustment_get_minimum_increment*(adjustment: pointer): pointer
proc gtk_adjustment_get_bounded_upper*(self: pointer): pointer
proc gtk_adjustment_get_animation_duration*(adjustment: pointer): guint
proc gtk_adjustment_get_target_value*(adjustment: pointer): pointer
proc gtk_adjustment_is_animating*(adjustment: pointer): gboolean
proc gtk_allocated_bitmask_copy*(mask: pointer): pointer {.importc: "_gtk_allocated_bitmask_copy".}
proc gtk_allocated_bitmask_free*(mask: pointer) {.importc: "_gtk_allocated_bitmask_free".}
proc gtk_allocated_bitmask_to_string*(mask: pointer): cstring {.importc: "_gtk_allocated_bitmask_to_string".}
proc gtk_application_accels_new*(): pointer
proc gtk_application_accels_list_action_descriptions*(accels: pointer): pointer
proc gtk_application_accels_get_shortcuts*(accels: pointer): pointer
proc gtk_application_window_get_action_group*(window: pointer): pointer
proc gtk_application_get_parent_muxer_for_window*(window: pointer): pointer
proc gtk_application_get_action_muxer*(application: pointer): pointer
proc gtk_application_get_application_accels*(application: pointer): pointer
proc gtk_application_save*(application: pointer)
proc gtk_application_forget*(application: pointer)
proc gtk_application_impl_get_type*(): GType
proc gtk_application_impl_dbus_get_type*(): GType
proc gtk_application_impl_x11_get_type*(): GType
proc gtk_application_impl_wayland_get_type*(): GType
proc gtk_application_impl_quartz_get_type*(): GType
proc gtk_application_impl_android_get_type*(): GType
proc gtk_application_impl_win32_get_type*(): GType
proc gtk_application_impl_shutdown*(impl: pointer)
proc gtk_application_impl_get_restore_reason*(impl: pointer): pointer
proc gtk_application_impl_clear_restore_reason*(impl: pointer)
proc gtk_application_impl_forget_state*(impl: pointer)
proc gtk_application_impl_retrieve_state*(impl: pointer): pointer
proc gtk_application_window_get_show_menubar*(window: pointer): pointer
proc gtk_application_window_get_id*(window: pointer): pointer
proc gtk_application_window_get_help_overlay*(window: pointer): pointer
proc gtk_at_context_get_accessible*(self: pointer): pointer
proc gtk_at_context_get_accessible_role*(self: pointer): pointer
proc gtk_at_context_get_display*(self: pointer): pointer
proc gtk_at_context_realize*(self: pointer)
proc gtk_at_context_unrealize*(self: pointer)
proc gtk_at_context_is_realized*(self: pointer): gboolean
proc gtk_at_context_update*(self: pointer)
proc gtk_at_context_get_name*(self: pointer): cstring
proc gtk_at_context_get_description*(self: pointer): cstring
proc gtk_at_context_bounds_changed*(self: pointer)
proc gtk_accessible_property_get_attribute_name*(property: pointer): cstring
proc gtk_accessible_relation_get_attribute_name*(relation: pointer): cstring
proc gtk_accessible_state_get_attribute_name*(state: pointer): cstring
proc gtk_at_context_get_accessible_parent*(self: pointer): pointer
proc gtk_at_context_get_next_accessible_sibling*(self: pointer): pointer
proc gtk_at_context_update_caret_position*(self: pointer)
proc gtk_at_context_update_selection_bound*(self: pointer)
proc gtk_at_context_is_nested_button*(self: pointer): gboolean
proc gtk_at_spi_context_get_context_path*(self: pointer): cstring
proc gtk_at_spi_context_to_ref*(self: pointer): pointer
proc gtk_at_spi_context_get_root*(self: pointer): pointer
proc gtk_at_spi_context_get_parent_ref*(self: pointer): pointer
proc gtk_at_spi_context_get_interfaces*(self: pointer): pointer
proc gtk_at_spi_context_get_states*(self: pointer): pointer
proc gtk_at_spi_context_get_index_in_parent*(self: pointer): pointer
proc gtk_at_spi_context_get_child_count*(self: pointer): pointer
proc gtk_at_spi_root_new*(bus_address: cstring): pointer
proc gtk_at_spi_root_get_connection*(self: pointer): pointer
proc gtk_at_spi_root_get_cache*(self: pointer): pointer
proc gtk_at_spi_root_get_base_path*(self: pointer): cstring
proc gtk_at_spi_root_to_ref*(self: pointer): pointer
proc gtk_at_spi_root_has_event_listeners*(self: pointer): gboolean
proc gtk_atspi_disconnect_selection_signals*(accessible: pointer)
proc gtk_at_spi_socket_get_bus_name*(self: pointer): pointer
proc gtk_at_spi_socket_get_object_path*(self: pointer): pointer
proc gtk_at_spi_socket_to_ref*(self: pointer): pointer
proc gtk_atspi_disconnect_text_signals*(accessible: pointer)
proc gtk_atspi_role_for_context*(context: pointer): pointer
proc gtk_at_spi_null_ref*(): pointer
proc gtk_bin_layout_new*(): pointer
proc gtk_bitmask_new*(): pointer {.importc: "_gtk_bitmask_new".}
proc gtk_bitmask_copy*(mask: pointer): pointer {.importc: "_gtk_bitmask_copy".}
proc gtk_bitmask_free*(mask: pointer): pointer {.importc: "_gtk_bitmask_free".}
proc gtk_bitmask_to_string*(mask: pointer): pointer {.importc: "_gtk_bitmask_to_string".}
proc gtk_bitmask_is_empty*(mask: pointer): pointer {.importc: "_gtk_bitmask_is_empty".}
proc gtk_bitmask_from_bits*(): pointer {.importc: "_gtk_bitmask_from_bits".}
proc gtk_allocated_bitmask_copy*(): pointer {.importc: "_gtk_allocated_bitmask_copy".}

{.pop.}

# ============================================================================
# G API
# ============================================================================

{.push importc, cdecl.}
proc g_string_free*(): pointer

{.pop.}

# ============================================================================
# GTK API
# ============================================================================

{.push importc, cdecl.}
proc gtk_allocated_bitmask_intersect*(): pointer {.importc: "_gtk_allocated_bitmask_intersect".}
proc gtk_allocated_bitmask_union*(): pointer {.importc: "_gtk_allocated_bitmask_union".}
proc gtk_allocated_bitmask_subtract*(): pointer {.importc: "_gtk_allocated_bitmask_subtract".}
proc gtk_allocated_bitmask_get*(): pointer {.importc: "_gtk_allocated_bitmask_get".}
proc gtk_allocated_bitmask_set*(): pointer {.importc: "_gtk_allocated_bitmask_set".}
proc gtk_allocated_bitmask_invert_range*(): pointer {.importc: "_gtk_allocated_bitmask_invert_range".}
proc gtk_bitmask_from_bits*(invert: pointer): pointer {.importc: "_gtk_bitmask_from_bits".}
proc gtk_allocated_bitmask_equals*(): pointer {.importc: "_gtk_allocated_bitmask_equals".}
proc gtk_allocated_bitmask_intersects*(): pointer {.importc: "_gtk_allocated_bitmask_intersects".}
proc gtk_bitset_ref*(self: pointer): pointer
proc gtk_bitset_unref*(self: pointer): pointer
proc gtk_bitset_is_empty*(self: pointer): pointer
proc gtk_bitset_get_size*(self: pointer): pointer
proc gtk_bitset_get_minimum*(self: pointer): pointer
proc gtk_bitset_get_maximum*(self: pointer): pointer
proc gtk_bitset_new_empty*(): pointer
proc gtk_bitset_copy*(self: pointer): pointer
proc gtk_bitset_remove_all*(self: pointer): pointer
proc gtk_bitset_iter_get_value*(iter: pointer): pointer
proc gtk_bitset_iter_is_valid*(iter: pointer): pointer
proc gtk_bookmark_list_get_filename*(self: pointer): pointer
proc gtk_bookmark_list_get_attributes*(self: pointer): pointer
proc gtk_bookmark_list_get_io_priority*(self: pointer): pointer
proc gtk_bookmark_list_is_loading*(self: pointer): pointer
proc gtk_bookmarks_manager_free*(manager: pointer) {.importc: "_gtk_bookmarks_manager_free".}
proc gtk_bookmarks_manager_get_is_xdg_dir_builtin*(xdg_type: pointer): gboolean {.importc: "_gtk_bookmarks_manager_get_is_xdg_dir_builtin".}
proc gtk_bool_filter_new*(expression: pointer): pointer
proc gtk_bool_filter_get_expression*(self: pointer): pointer
proc gtk_bool_filter_get_invert*(self: pointer): pointer
proc gtk_border_free*(border: pointer): pointer
proc gtk_box_layout_new*(orientation: pointer): pointer
proc gtk_box_layout_get_homogeneous*(box_layout: pointer): pointer
proc gtk_box_layout_get_spacing*(box_layout: pointer): pointer
proc gtk_box_layout_get_baseline_position*(box_layout: pointer): pointer
proc gtk_box_layout_get_baseline_child*(box_layout: pointer): pointer
proc gtk_buildable_get_buildable_id*(buildable: pointer): pointer
proc gtk_buildable_parse_context_pop*(context: pointer): pointer
proc gtk_buildable_parse_context_get_element*(context: pointer): pointer
proc gtk_builder_error_quark*(): pointer

{.pop.}

# ============================================================================
# FREE API
# ============================================================================

{.push importc, cdecl.}
proc free_binding_expression_info*(info: pointer)

{.pop.}

# ============================================================================
# GTK API
# ============================================================================

{.push importc, cdecl.}
proc gtk_builder_menu_end*(parser_data: pointer): cstring {.importc: "_gtk_builder_menu_end".}
proc gtk_builder_cscope_new*(): pointer
proc gtk_builtin_icon_new*(css_name: cstring): ptr GtkWidget
proc gtk_button_get_gesture*(button: pointer): pointer
proc gtk_button_get_action_helper*(button: pointer): pointer
proc gtk_calendar_get_show_week_numbers*(self: pointer): pointer
proc gtk_calendar_get_show_heading*(self: pointer): pointer
proc gtk_calendar_get_show_day_names*(self: pointer): pointer
proc gtk_calendar_get_day*(self: pointer): pointer
proc gtk_calendar_get_month*(self: pointer): pointer
proc gtk_calendar_get_year*(self: pointer): pointer
proc gtk_calendar_get_date*(self: pointer): pointer
proc gtk_center_box_get_shrink_center_last*(self: pointer): pointer
proc gtk_center_layout_new*(): pointer
proc gtk_center_layout_get_orientation*(self: pointer): pointer
proc gtk_center_layout_get_baseline_position*(self: pointer): pointer
proc gtk_center_layout_get_start_widget*(self: pointer): pointer
proc gtk_center_layout_get_center_widget*(self: pointer): pointer
proc gtk_center_layout_get_end_widget*(self: pointer): pointer
proc gtk_center_layout_get_shrink_center_last*(self: pointer): pointer
proc gtk_color_dialog_button_new*(dialog: pointer): pointer
proc gtk_color_dialog_button_get_rgba*(self: pointer): pointer
proc gtk_color_dialog_get_title*(self: pointer): pointer
proc gtk_color_dialog_get_modal*(self: pointer): pointer
proc gtk_color_dialog_get_with_alpha*(self: pointer): pointer
proc gtk_color_editor_new*(): ptr GtkWidget
proc gtk_color_picker_kwin_new*(): pointer
proc gtk_color_picker_portal_new*(): pointer
proc gtk_color_picker_new*(): pointer
proc gtk_color_picker_quartz_new*(): pointer
proc gtk_color_picker_shell_new*(): pointer
proc gtk_color_picker_win32_new*(): pointer
proc gtk_color_swatch_new*(): ptr GtkWidget
proc gtk_color_swatch_get_selectable*(swatch: pointer): gboolean
proc gtk_color_swatch_select*(swatch: pointer)
proc gtk_color_swatch_activate*(swatch: pointer)
proc gtk_color_swatch_customize*(swatch: pointer)
proc gtk_column_view_cell_get_item*(self: pointer): pointer
proc gtk_column_view_cell_get_child*(self: pointer): pointer
proc gtk_column_view_cell_new*(): pointer
proc gtk_column_view_cell_widget_remove*(self: pointer)
proc gtk_column_view_cell_widget_get_next*(self: pointer): pointer
proc gtk_column_view_cell_widget_get_prev*(self: pointer): pointer
proc gtk_column_view_cell_widget_get_column*(self: pointer): pointer
proc gtk_column_view_cell_widget_unset_column*(self: pointer)
proc gtk_column_view_column_get_sorter*(self: pointer): pointer
proc gtk_column_view_column_get_header_menu*(self: pointer): pointer
proc gtk_column_view_column_get_id*(self: pointer): pointer
proc gtk_column_view_column_get_first_cell*(self: pointer): pointer
proc gtk_column_view_column_get_header*(self: pointer): ptr GtkWidget
proc gtk_column_view_column_queue_resize*(self: pointer)
proc gtk_column_view_column_notify_sort*(self: pointer)
proc gtk_column_view_get_sorter*(self: pointer): pointer
proc gtk_column_view_get_tab_behavior*(self: pointer): pointer
proc gtk_column_view_get_row_factory*(self: pointer): pointer
proc gtk_column_view_get_header_factory*(self: pointer): pointer
proc gtk_column_view_is_inert*(self: pointer): gboolean
proc gtk_column_view_get_list_view*(self: pointer): pointer
proc gtk_column_view_get_focus_column*(self: pointer): pointer
proc gtk_column_view_row_get_item*(self: pointer): pointer
proc gtk_column_view_row_get_accessible_description*(self: pointer): pointer
proc gtk_column_view_row_get_accessible_label*(self: pointer): pointer
proc gtk_column_view_row_new*(): pointer
proc gtk_column_view_sorter_get_primary_sort_column*(self: pointer): pointer
proc gtk_column_view_sorter_get_primary_sort_order*(self: pointer): pointer
proc gtk_column_view_sorter_get_n_sort_columns*(self: pointer): pointer
proc gtk_column_view_sorter_new*(): pointer
proc gtk_column_view_sorter_clear*(self: pointer)
proc gtk_column_view_title_new*(column: pointer): ptr GtkWidget
proc gtk_column_view_title_update_sort*(self: pointer)
proc gtk_column_view_title_get_column*(self: pointer): pointer
proc gtk_compose_table_new_with_file*(compose_file: cstring): pointer
proc gtk_compose_table_get_x11_compose_file_dir*(): cstring
proc gtk_constraint_variable_new_dummy*(name: cstring): pointer
proc gtk_constraint_variable_new_objective*(name: cstring): pointer
proc gtk_constraint_variable_new_slack*(name: cstring): pointer
proc gtk_constraint_variable_ref*(variable: pointer): pointer
proc gtk_constraint_variable_unref*(variable: pointer)
proc gtk_constraint_variable_get_value*(variable: pointer): pointer
proc gtk_constraint_variable_to_string*(variable: pointer): cstring
proc gtk_constraint_variable_is_external*(variable: pointer): gboolean
proc gtk_constraint_variable_is_pivotable*(variable: pointer): gboolean
proc gtk_constraint_variable_is_restricted*(variable: pointer): gboolean
proc gtk_constraint_variable_is_dummy*(variable: pointer): gboolean
proc gtk_constraint_variable_pair_free*(pair: pointer)
proc gtk_constraint_variable_set_new*(): pointer
proc gtk_constraint_variable_set_free*(set: pointer)
proc gtk_constraint_variable_set_is_empty*(set: pointer): gboolean
proc gtk_constraint_variable_set_is_singleton*(set: pointer): gboolean
proc gtk_constraint_variable_set_size*(set: pointer): pointer
proc gtk_constraint_expression_new*(constant: pointer): pointer
proc gtk_constraint_expression_new_from_variable*(variable: pointer): pointer
proc gtk_constraint_expression_ref*(expression: pointer): pointer
proc gtk_constraint_expression_unref*(expression: pointer)
proc gtk_constraint_expression_clone*(expression: pointer): pointer
proc gtk_constraint_expression_get_constant*(expression: pointer): pointer
proc gtk_constraint_expression_is_constant*(expression: pointer): gboolean
proc gtk_constraint_expression_to_string*(expression: pointer): cstring
proc gtk_constraint_expression_get_pivotable_variable*(expression: pointer): pointer
proc gtk_constraint_expression_builder_plus*(builder: pointer)
proc gtk_constraint_expression_builder_minus*(builder: pointer)
proc gtk_constraint_expression_builder_divide_by*(builder: pointer)
proc gtk_constraint_expression_builder_multiply_by*(builder: pointer)
proc gtk_constraint_guide_update*(guide: pointer): pointer
proc gtk_constraint_guide_detach*(guide: pointer)
proc gtk_constraint_is_constant*(constraint: pointer): pointer
proc gtk_constraint_vfl_parser_error_quark*(): pointer
proc gtk_constraint_layout_observe_constraints*(layout: pointer): pointer
proc gtk_constraint_layout_observe_guides*(layout: pointer): pointer
proc gtk_constraint_layout_get_solver*(layout: pointer): pointer
proc gtk_constraint_detach*(constraint: pointer)
proc gtk_constraint_solver_new*(): pointer
proc gtk_constraint_solver_freeze*(solver: pointer)
proc gtk_constraint_solver_thaw*(solver: pointer)
proc gtk_constraint_solver_resolve*(solver: pointer)
proc gtk_constraint_solver_begin_edit*(solver: pointer)
proc gtk_constraint_solver_end_edit*(solver: pointer)
proc gtk_constraint_solver_clear*(solver: pointer)
proc gtk_constraint_solver_to_string*(solver: pointer): cstring
proc gtk_constraint_solver_statistics*(solver: pointer): cstring
proc gtk_constraint_vfl_parser_new*(): pointer
proc gtk_constraint_vfl_parser_free*(parser: pointer)
proc gtk_constraint_vfl_parser_get_error_offset*(parser: pointer): pointer
proc gtk_constraint_vfl_parser_get_error_range*(parser: pointer): pointer
proc gtk_css_animated_style_recompute*(style: pointer)
proc gtk_css_animated_style_get_base_style*(style: pointer): pointer
proc gtk_css_animated_style_get_parent_style*(style: pointer): pointer
proc gtk_css_animated_style_get_provider*(style: pointer): pointer
proc gtk_css_animation_get_name*(animation: pointer): cstring {.importc: "_gtk_css_animation_get_name".}
proc gtk_css_animation_is_animation*(animation: pointer): gboolean {.importc: "_gtk_css_animation_is_animation".}
proc gtk_css_array_value_new*(content: pointer): pointer {.importc: "_gtk_css_array_value_new".}
proc gtk_css_bg_size_value_parse*(parser: pointer): pointer {.importc: "_gtk_css_bg_size_value_parse".}
proc gtk_css_border_value_get_top*(value: pointer): pointer {.importc: "_gtk_css_border_value_get_top".}
proc gtk_css_border_value_get_right*(value: pointer): pointer {.importc: "_gtk_css_border_value_get_right".}
proc gtk_css_border_value_get_bottom*(value: pointer): pointer {.importc: "_gtk_css_border_value_get_bottom".}
proc gtk_css_border_value_get_left*(value: pointer): pointer {.importc: "_gtk_css_border_value_get_left".}
proc gtk_css_boxes_compute_padding_rect*(boxes: pointer): pointer
proc gtk_css_boxes_get_border_rect*(): pointer
proc gtk_css_boxes_get_padding_rect*(): pointer
proc gtk_css_boxes_get_content_rect*(): pointer
proc gtk_css_boxes_get_border_box*(): pointer
proc gtk_css_boxes_get_padding_box*(): pointer
proc gtk_css_boxes_get_content_box*(): pointer
proc gtk_css_boxes_get_margin_rect*(boxes: pointer): pointer
proc gtk_css_boxes_get_border_rect*(boxes: pointer): pointer
proc gtk_css_boxes_get_padding_rect*(boxes: pointer): pointer
proc gtk_css_boxes_get_content_rect*(boxes: pointer): pointer
proc gtk_css_boxes_get_outline_rect*(boxes: pointer): pointer
proc gtk_css_boxes_get_border_box*(boxes: pointer): pointer
proc gtk_css_boxes_get_padding_box*(boxes: pointer): pointer
proc gtk_css_boxes_get_content_box*(boxes: pointer): pointer
proc gtk_css_boxes_get_outline_box*(boxes: pointer): pointer
proc gtk_css_color_to_string*(color: pointer): cstring
proc gtk_css_color_interpolation_method_can_parse*(parser: pointer): gboolean
proc gtk_css_hue_interpolation_to_hue_interpolation*(interp: pointer): pointer
proc gtk_css_color_value_can_parse*(parser: pointer): gboolean
proc gtk_css_color_value_parse*(parser: pointer): pointer
proc gtk_css_corner_value_parse*(parser: pointer): pointer {.importc: "_gtk_css_corner_value_parse".}
proc gtk_css_dynamic_new*(timestamp: gint64): pointer
proc gtk_css_ease_value_can_parse*(parser: pointer): gboolean {.importc: "_gtk_css_ease_value_can_parse".}
proc gtk_css_ease_value_parse*(parser: pointer): pointer {.importc: "_gtk_css_ease_value_parse".}
proc gtk_css_blend_mode_value_new*(blend_mode: pointer): pointer {.importc: "_gtk_css_blend_mode_value_new".}
proc gtk_css_blend_mode_value_try_parse*(parser: pointer): pointer {.importc: "_gtk_css_blend_mode_value_try_parse".}
proc gtk_css_blend_mode_value_get*(value: pointer): pointer {.importc: "_gtk_css_blend_mode_value_get".}
proc gtk_css_border_style_value_new*(border_style: pointer): pointer {.importc: "_gtk_css_border_style_value_new".}
proc gtk_css_border_style_value_try_parse*(parser: pointer): pointer {.importc: "_gtk_css_border_style_value_try_parse".}
proc gtk_css_border_style_value_get*(value: pointer): pointer {.importc: "_gtk_css_border_style_value_get".}
proc gtk_css_font_size_value_new*(size: pointer): pointer {.importc: "_gtk_css_font_size_value_new".}
proc gtk_css_font_size_value_try_parse*(parser: pointer): pointer {.importc: "_gtk_css_font_size_value_try_parse".}
proc gtk_css_font_size_value_get*(value: pointer): pointer {.importc: "_gtk_css_font_size_value_get".}
proc gtk_css_font_style_value_new*(style: pointer): pointer {.importc: "_gtk_css_font_style_value_new".}
proc gtk_css_font_style_value_try_parse*(parser: pointer): pointer {.importc: "_gtk_css_font_style_value_try_parse".}
proc gtk_css_font_style_value_get*(value: pointer): pointer {.importc: "_gtk_css_font_style_value_get".}
proc gtk_css_font_weight_value_try_parse*(parser: pointer): pointer
proc gtk_css_font_weight_value_get*(value: pointer): pointer
proc gtk_css_font_stretch_value_new*(stretch: pointer): pointer {.importc: "_gtk_css_font_stretch_value_new".}
proc gtk_css_font_stretch_value_try_parse*(parser: pointer): pointer {.importc: "_gtk_css_font_stretch_value_try_parse".}
proc gtk_css_font_stretch_value_get*(value: pointer): pointer {.importc: "_gtk_css_font_stretch_value_get".}
proc gtk_css_text_decoration_line_value_new*(line: pointer): pointer {.importc: "_gtk_css_text_decoration_line_value_new".}
proc gtk_css_text_decoration_line_value_get*(value: pointer): pointer {.importc: "_gtk_css_text_decoration_line_value_get".}
proc gtk_css_text_decoration_style_value_new*(style: pointer): pointer {.importc: "_gtk_css_text_decoration_style_value_new".}
proc gtk_css_text_decoration_style_value_try_parse*(parser: pointer): pointer {.importc: "_gtk_css_text_decoration_style_value_try_parse".}
proc gtk_css_text_decoration_style_value_get*(value: pointer): pointer {.importc: "_gtk_css_text_decoration_style_value_get".}
proc gtk_css_area_value_new*(area: pointer): pointer {.importc: "_gtk_css_area_value_new".}
proc gtk_css_area_value_try_parse*(parser: pointer): pointer {.importc: "_gtk_css_area_value_try_parse".}
proc gtk_css_area_value_get*(value: pointer): pointer {.importc: "_gtk_css_area_value_get".}
proc gtk_css_direction_value_new*(direction: pointer): pointer {.importc: "_gtk_css_direction_value_new".}
proc gtk_css_direction_value_try_parse*(parser: pointer): pointer {.importc: "_gtk_css_direction_value_try_parse".}
proc gtk_css_direction_value_get*(value: pointer): pointer {.importc: "_gtk_css_direction_value_get".}
proc gtk_css_play_state_value_new*(play_state: pointer): pointer {.importc: "_gtk_css_play_state_value_new".}
proc gtk_css_play_state_value_try_parse*(parser: pointer): pointer {.importc: "_gtk_css_play_state_value_try_parse".}
proc gtk_css_play_state_value_get*(value: pointer): pointer {.importc: "_gtk_css_play_state_value_get".}
proc gtk_css_fill_mode_value_new*(fill_mode: pointer): pointer {.importc: "_gtk_css_fill_mode_value_new".}
proc gtk_css_fill_mode_value_try_parse*(parser: pointer): pointer {.importc: "_gtk_css_fill_mode_value_try_parse".}
proc gtk_css_fill_mode_value_get*(value: pointer): pointer {.importc: "_gtk_css_fill_mode_value_get".}
proc gtk_css_icon_style_value_new*(icon_style: pointer): pointer {.importc: "_gtk_css_icon_style_value_new".}
proc gtk_css_icon_style_value_try_parse*(parser: pointer): pointer {.importc: "_gtk_css_icon_style_value_try_parse".}
proc gtk_css_icon_style_value_get*(value: pointer): pointer {.importc: "_gtk_css_icon_style_value_get".}
proc gtk_css_font_kerning_value_new*(kerning: pointer): pointer {.importc: "_gtk_css_font_kerning_value_new".}
proc gtk_css_font_kerning_value_try_parse*(parser: pointer): pointer {.importc: "_gtk_css_font_kerning_value_try_parse".}
proc gtk_css_font_kerning_value_get*(value: pointer): pointer {.importc: "_gtk_css_font_kerning_value_get".}
proc gtk_css_font_variant_position_value_new*(position: pointer): pointer {.importc: "_gtk_css_font_variant_position_value_new".}
proc gtk_css_font_variant_position_value_try_parse*(parser: pointer): pointer {.importc: "_gtk_css_font_variant_position_value_try_parse".}
proc gtk_css_font_variant_position_value_get*(value: pointer): pointer {.importc: "_gtk_css_font_variant_position_value_get".}
proc gtk_css_font_variant_caps_value_new*(caps: pointer): pointer {.importc: "_gtk_css_font_variant_caps_value_new".}
proc gtk_css_font_variant_caps_value_try_parse*(parser: pointer): pointer {.importc: "_gtk_css_font_variant_caps_value_try_parse".}
proc gtk_css_font_variant_caps_value_get*(value: pointer): pointer {.importc: "_gtk_css_font_variant_caps_value_get".}
proc gtk_css_font_variant_alternate_value_new*(alternates: pointer): pointer {.importc: "_gtk_css_font_variant_alternate_value_new".}
proc gtk_css_font_variant_alternate_value_try_parse*(parser: pointer): pointer {.importc: "_gtk_css_font_variant_alternate_value_try_parse".}
proc gtk_css_font_variant_alternate_value_get*(value: pointer): pointer {.importc: "_gtk_css_font_variant_alternate_value_get".}
proc gtk_css_font_variant_ligature_value_new*(ligatures: pointer): pointer {.importc: "_gtk_css_font_variant_ligature_value_new".}
proc gtk_css_font_variant_ligature_value_get*(value: pointer): pointer {.importc: "_gtk_css_font_variant_ligature_value_get".}
proc gtk_css_font_variant_numeric_value_new*(numeric: pointer): pointer {.importc: "_gtk_css_font_variant_numeric_value_new".}
proc gtk_css_font_variant_numeric_value_get*(value: pointer): pointer {.importc: "_gtk_css_font_variant_numeric_value_get".}
proc gtk_css_font_variant_east_asian_value_new*(east_asian: pointer): pointer {.importc: "_gtk_css_font_variant_east_asian_value_new".}
proc gtk_css_font_variant_east_asian_value_get*(value: pointer): pointer {.importc: "_gtk_css_font_variant_east_asian_value_get".}
proc gtk_css_text_transform_value_new*(transform: pointer): pointer {.importc: "_gtk_css_text_transform_value_new".}
proc gtk_css_text_transform_value_try_parse*(parser: pointer): pointer {.importc: "_gtk_css_text_transform_value_try_parse".}
proc gtk_css_text_transform_value_get*(value: pointer): pointer {.importc: "_gtk_css_text_transform_value_get".}
proc gtk_css_parser_error_quark*(): pointer
proc gtk_css_parser_warning_quark*(): pointer
proc gtk_css_filter_value_new_none*(): pointer
proc gtk_css_filter_value_parse*(parser: pointer): pointer
proc gtk_css_filter_value_is_none*(filter: pointer): gboolean
proc gtk_css_font_features_value_new_default*(): pointer
proc gtk_css_font_features_value_parse*(parser: pointer): pointer
proc gtk_css_font_features_value_get_features*(value: pointer): cstring
proc gtk_css_font_variations_value_new_default*(): pointer
proc gtk_css_font_variations_value_parse*(parser: pointer): pointer
proc gtk_css_font_variations_value_get_variations*(value: pointer): cstring
proc gtk_css_image_invalid_new*(): pointer
proc gtk_css_image_can_parse*(parser: pointer): gboolean {.importc: "_gtk_css_image_can_parse".}
proc gtk_css_image_new_parse*(parser: pointer): pointer {.importc: "_gtk_css_image_new_parse".}
proc gtk_css_image_to_string*(image: pointer): cstring
proc gtk_css_image_value_new*(image: pointer): pointer {.importc: "_gtk_css_image_value_new".}
proc gtk_css_image_value_get_image*(image: pointer): pointer {.importc: "_gtk_css_image_value_get_image".}
proc gtk_css_inherit_value_new*(): pointer {.importc: "_gtk_css_inherit_value_new".}
proc gtk_css_inherit_value_get*(): pointer {.importc: "_gtk_css_inherit_value_get".}
proc gtk_css_initial_value_new*(): pointer {.importc: "_gtk_css_initial_value_new".}
proc gtk_css_initial_value_get*(): pointer {.importc: "_gtk_css_initial_value_get".}
proc gtk_css_keyframes_parse*(parser: pointer): pointer {.importc: "_gtk_css_keyframes_parse".}
proc gtk_css_keyframes_ref*(keyframes: pointer): pointer {.importc: "_gtk_css_keyframes_ref".}
proc gtk_css_keyframes_unref*(keyframes: pointer) {.importc: "_gtk_css_keyframes_unref".}
proc gtk_css_keyframes_get_n_variables*(keyframes: pointer): guint {.importc: "_gtk_css_keyframes_get_n_variables".}
proc gtk_css_line_height_value_get_default*(): pointer
proc gtk_css_line_height_value_parse*(parser: pointer): pointer
proc gtk_css_line_height_value_get*(value: pointer): pointer
proc gtk_css_lookup_init*(lookup: pointer) {.importc: "_gtk_css_lookup_init".}
proc gtk_css_lookup_destroy*(lookup: pointer) {.importc: "_gtk_css_lookup_destroy".}
proc gtk_css_node_declaration_new*(): pointer
proc gtk_css_node_declaration_ref*(decl: pointer): pointer
proc gtk_css_node_declaration_unref*(decl: pointer)
proc gtk_css_node_declaration_get_name*(decl: pointer): pointer
proc gtk_css_node_declaration_get_id*(decl: pointer): pointer
proc gtk_css_node_declaration_get_state*(decl: pointer): pointer
proc gtk_css_node_declaration_clear_classes*(decl: pointer): gboolean
proc gtk_css_node_declaration_hash*(elem: gconstpointer): guint
proc gtk_css_node_declaration_to_string*(decl: pointer): cstring
proc gtk_css_node_new*(): pointer
proc gtk_css_node_get_classes*(cssnode: pointer): pointer
proc gtk_css_node_invalidate_style_provider*(cssnode: pointer)
proc gtk_css_node_validate*(cssnode: pointer)
proc gtk_css_node_observe_children*(cssnode: pointer): pointer
proc gtk_css_node_style_cache_new*(style: pointer): pointer
proc gtk_css_node_style_cache_ref*(cache: pointer): pointer
proc gtk_css_node_style_cache_unref*(cache: pointer)
proc gtk_css_node_style_cache_get_style*(cache: pointer): pointer
proc gtk_css_number_value_can_parse*(parser: pointer): gboolean
proc gtk_css_palette_value_new_default*(): pointer
proc gtk_css_palette_value_parse*(parser: pointer): pointer
proc gtk_css_parser_ref*(self: pointer): pointer
proc gtk_css_parser_unref*(self: pointer)
proc gtk_css_parser_peek_token*(self: pointer): pointer
proc gtk_css_parser_get_token*(self: pointer): pointer
proc gtk_css_parser_consume_token*(self: pointer)
proc gtk_css_parser_start_block*(self: pointer)
proc gtk_css_parser_end_block_prelude*(self: pointer)
proc gtk_css_parser_end_block*(self: pointer)
proc gtk_css_parser_skip*(self: pointer)
proc gtk_css_parser_skip_whitespace*(self: pointer)
proc gtk_css_parser_has_url*(self: pointer): gboolean
proc gtk_css_parser_has_number*(self: pointer): gboolean
proc gtk_css_parser_has_integer*(self: pointer): gboolean
proc gtk_css_parser_has_percentage*(self: pointer): gboolean
proc gtk_css_parser_has_references*(parser: pointer): gboolean
proc gtk_css_parser_parse_value_into_token_stream*(parser: pointer): pointer
proc gtk_css_position_value_parse*(parser: pointer): pointer {.importc: "_gtk_css_position_value_parse".}
proc gtk_css_position_value_try_parse*(parser: pointer): pointer {.importc: "_gtk_css_position_value_try_parse".}
proc gtk_css_position_value_parse_spacing*(parser: pointer): pointer
proc gtk_css_provider_to_string*(provider: pointer): pointer
proc gtk_css_provider_set_keep_css_sections*()
proc gtk_css_background_repeat_value_try_parse*(parser: pointer): pointer {.importc: "_gtk_css_background_repeat_value_try_parse".}
proc gtk_css_background_repeat_value_get_x*(repeat: pointer): pointer {.importc: "_gtk_css_background_repeat_value_get_x".}
proc gtk_css_background_repeat_value_get_y*(repeat: pointer): pointer {.importc: "_gtk_css_background_repeat_value_get_y".}
proc gtk_css_border_repeat_value_try_parse*(parser: pointer): pointer {.importc: "_gtk_css_border_repeat_value_try_parse".}
proc gtk_css_border_repeat_value_get_x*(repeat: pointer): pointer {.importc: "_gtk_css_border_repeat_value_get_x".}
proc gtk_css_border_repeat_value_get_y*(repeat: pointer): pointer {.importc: "_gtk_css_border_repeat_value_get_y".}
proc gtk_css_section_ref*(section: pointer): pointer
proc gtk_css_section_unref*(section: pointer): pointer
proc gtk_css_section_to_string*(section: pointer): pointer
proc gtk_css_section_get_parent*(section: pointer): pointer
proc gtk_css_section_get_file*(section: pointer): pointer
proc gtk_css_section_get_bytes*(section: pointer): pointer
proc gtk_css_section_get_start_location*(section: pointer): pointer
proc gtk_css_section_get_end_location*(section: pointer): pointer
proc gtk_css_selector_parse*(parser: pointer): pointer {.importc: "_gtk_css_selector_parse".}
proc gtk_css_selector_free*(selector: pointer) {.importc: "_gtk_css_selector_free".}
proc gtk_css_selector_to_string*(selector: pointer): cstring {.importc: "_gtk_css_selector_to_string".}
proc gtk_css_selector_get_change*(selector: pointer): pointer {.importc: "_gtk_css_selector_get_change".}
proc gtk_css_selector_tree_free*(tree: pointer) {.importc: "_gtk_css_selector_tree_free".}
proc gtk_css_selector_tree_builder_build*(builder: pointer): pointer {.importc: "_gtk_css_selector_tree_builder_build".}
proc gtk_css_selector_tree_builder_free*(builder: pointer) {.importc: "_gtk_css_selector_tree_builder_free".}
proc gtk_css_shadow_value_new_none*(): pointer
proc gtk_css_shadow_value_new_filter*(other: pointer): pointer
proc gtk_css_shadow_value_parse_filter*(parser: pointer): pointer
proc gtk_css_shadow_value_get_n_shadows*(value: pointer): guint
proc gtk_css_shorthand_property_init_properties*() {.importc: "_gtk_css_shorthand_property_init_properties".}
proc gtk_css_static_style_get_default*(): pointer
proc gtk_css_static_style_get_change*(style: pointer): pointer
proc gtk_css_ident_value_new*(ident: cstring): pointer {.importc: "_gtk_css_ident_value_new".}
proc gtk_css_ident_value_new_take*(ident: cstring): pointer {.importc: "_gtk_css_ident_value_new_take".}
proc gtk_css_ident_value_try_parse*(parser: pointer): pointer {.importc: "_gtk_css_ident_value_try_parse".}
proc gtk_css_ident_value_get*(ident: pointer): cstring {.importc: "_gtk_css_ident_value_get".}
proc gtk_css_string_value_new*(string: cstring): pointer {.importc: "_gtk_css_string_value_new".}
proc gtk_css_string_value_new_take*(string: cstring): pointer {.importc: "_gtk_css_string_value_new_take".}
proc gtk_css_string_value_parse*(parser: pointer): pointer {.importc: "_gtk_css_string_value_parse".}
proc gtk_css_string_value_get*(string: pointer): cstring {.importc: "_gtk_css_string_value_get".}
proc gtk_css_style_change_finish*(change: pointer)
proc gtk_css_style_change_get_old_style*(change: pointer): pointer
proc gtk_css_style_change_get_new_style*(change: pointer): pointer
proc gtk_css_style_change_has_change*(change: pointer): gboolean
proc gtk_css_style_change_print*(change: pointer, string: pointer)
proc gtk_css_style_change_to_string*(change: pointer): cstring
proc gtk_css_style_get_static_style*(style: pointer): pointer
proc gtk_css_style_to_string*(style: pointer): cstring
proc gtk_css_style_get_pango_text_transform*(style: pointer): pointer
proc gtk_css_style_compute_font_features*(style: pointer): cstring
proc gtk_css_style_get_pango_attributes*(style: pointer): pointer
proc gtk_css_style_get_pango_font*(style: pointer): pointer
proc gtk_css_style_list_custom_properties*(style: pointer): pointer
proc gtk_css_values_unref*(values: pointer)
proc gtk_css_style_property_init_properties*() {.importc: "_gtk_css_style_property_init_properties".}
proc gtk_css_style_property_lookup_by_id*(id: guint): pointer {.importc: "_gtk_css_style_property_lookup_by_id".}
proc gtk_css_style_property_is_inherit*(property: pointer): gboolean {.importc: "_gtk_css_style_property_is_inherit".}
proc gtk_css_style_property_is_animated*(property: pointer): gboolean {.importc: "_gtk_css_style_property_is_animated".}
proc gtk_css_style_property_get_affects*(property: pointer): pointer {.importc: "_gtk_css_style_property_get_affects".}
proc gtk_css_style_property_affects_size*(property: pointer): gboolean {.importc: "_gtk_css_style_property_affects_size".}
proc gtk_css_style_property_affects_font*(property: pointer): gboolean {.importc: "_gtk_css_style_property_affects_font".}
proc gtk_css_style_property_get_id*(property: pointer): guint {.importc: "_gtk_css_style_property_get_id".}
proc gtk_css_style_property_get_initial_value*(property: pointer): pointer {.importc: "_gtk_css_style_property_get_initial_value".}
proc gtk_css_font_family_value_parse*(parser: pointer): pointer
proc gtk_css_font_size_value_parse*(parser: pointer): pointer
proc gtk_css_token_clear*(token: pointer)
proc gtk_css_token_to_string*(token: pointer): cstring
proc gtk_css_tokenizer_new*(bytes: pointer): pointer
proc gtk_css_tokenizer_ref*(tokenizer: pointer): pointer
proc gtk_css_tokenizer_unref*(tokenizer: pointer)
proc gtk_css_tokenizer_get_bytes*(tokenizer: pointer): pointer
proc gtk_css_tokenizer_save*(tokenizer: pointer)
proc gtk_css_tokenizer_restore*(tokenizer: pointer)
proc gtk_css_transform_value_new_none*(): pointer {.importc: "_gtk_css_transform_value_new_none".}
proc gtk_css_transform_value_parse*(parser: pointer): pointer {.importc: "_gtk_css_transform_value_parse".}
proc gtk_css_transform_value_get_transform*(transform: pointer): pointer
proc gtk_css_transient_node_new*(parent: pointer): pointer
proc gtk_css_transition_get_property*(transition: pointer): guint {.importc: "_gtk_css_transition_get_property".}
proc gtk_css_transition_is_transition*(animation: pointer): gboolean {.importc: "_gtk_css_transition_is_transition".}
proc gtk_css_unset_value_new*(): pointer {.importc: "_gtk_css_unset_value_new".}
proc gtk_css_value_to_string*(value: pointer): cstring
proc gtk_css_variable_set_new*(): pointer
proc gtk_css_variable_set_ref*(self: pointer): pointer
proc gtk_css_variable_set_unref*(self: pointer)
proc gtk_css_variable_set_copy*(self: pointer): pointer
proc gtk_css_variable_set_resolve_cycles*(self: pointer)
proc gtk_css_variable_set_list_ids*(self: pointer): pointer
proc gtk_css_variable_value_unref*(self: pointer)
proc gtk_css_variable_value_to_string*(self: pointer): cstring
proc gtk_css_variable_value_taint*(self: pointer)
proc gtk_css_widget_node_new*(widget: GtkWidget): pointer
proc gtk_css_widget_node_widget_destroyed*(node: pointer)
proc gtk_css_widget_node_get_widget*(node: pointer): ptr GtkWidget
proc gtk_cups_request_get_poll_state*(request: pointer): pointer
proc gtk_cups_request_free*(request: pointer)
proc gtk_cups_request_get_result*(request: pointer): pointer
proc gtk_cups_request_is_done*(request: pointer): gboolean
proc gtk_cups_result_is_error*(result: pointer): gboolean
proc gtk_cups_result_get_response*(result: pointer): pointer
proc gtk_cups_result_get_error_type*(result: pointer): pointer
proc gtk_cups_result_get_error_status*(result: pointer): pointer
proc gtk_cups_result_get_error_code*(result: pointer): pointer
proc gtk_cups_result_get_error_string*(result: pointer): cstring
proc gtk_cups_connection_test_get_state*(test: pointer): pointer
proc gtk_cups_connection_test_free*(test: pointer)

{.pop.}



# ============================================================================
# GTK API
# ============================================================================

{.push importc, cdecl.}
proc gtk_print_get_default_user_units*(): pointer {.importc: "_gtk_print_get_default_user_units".}
proc gtk_print_load_custom_papers*(store: pointer)
proc gtk_load_custom_papers*(): pointer {.importc: "_gtk_load_custom_papers".}
proc gtk_data_viewer_new*(): ptr GtkWidget
proc gtk_data_viewer_is_loading*(self: pointer): gboolean
proc gtk_data_viewer_reset*(self: pointer)
proc gtk_dialog_error_quark*(): pointer
proc gtk_directory_list_get_file*(self: pointer): pointer
proc gtk_directory_list_get_attributes*(self: pointer): pointer
proc gtk_directory_list_get_io_priority*(self: pointer): pointer
proc gtk_directory_list_is_loading*(self: pointer): pointer
proc gtk_directory_list_get_error*(self: pointer): pointer
proc gtk_directory_list_get_monitored*(self: pointer): pointer
proc gtk_drag_icon_get_for_drag*(drag: pointer): pointer
proc gtk_drag_icon_get_child*(self: pointer): pointer
proc gtk_drag_icon_create_widget_for_value*(value: pointer): pointer
proc gtk_drop_controller_motion_new*(): pointer
proc gtk_drop_controller_motion_contains_pointer*(self: pointer): pointer
proc gtk_drop_controller_motion_get_drop*(self: pointer): pointer
proc gtk_drop_controller_motion_is_pointer*(self: pointer): pointer
proc gtk_drop_down_get_header_factory*(self: pointer): pointer
proc gtk_drop_down_get_search_match_mode*(self: pointer): pointer
proc gtk_drop_end_event*(drop: pointer)
proc gtk_drop_target_async_get_formats*(self: pointer): pointer
proc gtk_drop_target_async_get_actions*(self: pointer): pointer
proc gtk_editable_init_delegate*(editable: pointer): pointer
proc gtk_editable_finish_delegate*(editable: pointer): pointer
proc gtk_entry_get_overwrite_mode*(entry: pointer): pointer
proc gtk_entry_completion_resize_popup*(completion: pointer) {.importc: "_gtk_entry_completion_resize_popup".}
proc gtk_entry_completion_popdown*(completion: pointer) {.importc: "_gtk_entry_completion_popdown".}
proc gtk_entry_completion_disconnect*(completion: pointer) {.importc: "_gtk_entry_completion_disconnect".}
proc gtk_entry_get_key_controller*(entry: pointer): pointer
proc gtk_ordering_from_cmpfunc*(cmpfunc_result: pointer): pointer
proc gtk_event_controller_get_current_event*(controller: pointer): pointer
proc gtk_event_controller_get_current_event_time*(controller: pointer): pointer
proc gtk_event_controller_get_current_event_device*(controller: pointer): pointer
proc gtk_event_controller_get_current_event_state*(controller: pointer): pointer
proc gtk_event_controller_get_target*(controller: pointer): ptr GtkWidget
proc gtk_expander_get_use_underline*(expander: pointer): pointer
proc gtk_expander_get_use_markup*(expander: pointer): pointer
proc gtk_expander_get_resize_toplevel*(expander: pointer): pointer
proc gtk_expression_watch_ref*(watch: pointer): pointer
proc gtk_expression_watch_unref*(watch: pointer): pointer
proc gtk_expression_watch_unwatch*(watch: pointer): pointer
proc gtk_value_get_expression*(value: pointer): pointer
proc gtk_value_dup_expression*(value: pointer): pointer
proc gtk_file_chooser_cell_new*(): pointer
proc gtk_file_chooser_entry_get_action*(chooser_entry: pointer): pointer {.importc: "_gtk_file_chooser_entry_get_action".}
proc gtk_file_chooser_entry_get_current_folder*(chooser_entry: pointer): pointer {.importc: "_gtk_file_chooser_entry_get_current_folder".}
proc gtk_file_chooser_entry_get_file_part*(chooser_entry: pointer): cstring {.importc: "_gtk_file_chooser_entry_get_file_part".}
proc gtk_file_chooser_entry_select_filename*(chooser_entry: pointer) {.importc: "_gtk_file_chooser_entry_select_filename".}
proc gtk_file_chooser_native_win32_show*(self: pointer): gboolean
proc gtk_file_chooser_native_win32_hide*(self: pointer)
proc gtk_file_chooser_native_quartz_show*(self: pointer): gboolean
proc gtk_file_chooser_native_quartz_hide*(self: pointer)
proc gtk_file_chooser_native_android_show*(self: pointer): gboolean
proc gtk_file_chooser_native_android_hide*(self: pointer)
proc gtk_file_chooser_native_portal_show*(self: pointer): gboolean
proc gtk_file_chooser_native_portal_hide*(self: pointer)
proc gtk_file_chooser_select_all*(chooser: pointer)
proc gtk_file_chooser_unselect_all*(chooser: pointer)
proc gtk_file_chooser_install_properties*(klass: pointer) {.importc: "_gtk_file_chooser_install_properties".}
proc gtk_file_chooser_delegate_iface_init*(iface: pointer) {.importc: "_gtk_file_chooser_delegate_iface_init".}
proc gtk_file_chooser_label_for_file*(file: pointer): cstring {.importc: "_gtk_file_chooser_label_for_file".}
proc gtk_file_info_consider_as_directory*(info: pointer): gboolean {.importc: "_gtk_file_info_consider_as_directory".}
proc gtk_file_has_native_path*(file: pointer): gboolean {.importc: "_gtk_file_has_native_path".}
proc gtk_file_consider_as_remote*(file: pointer): gboolean {.importc: "_gtk_file_consider_as_remote".}
proc gtk_file_info_get_file*(info: pointer): pointer {.importc: "_gtk_file_info_get_file".}
proc gtk_file_chooser_widget_should_respond*(chooser: pointer): gboolean
proc gtk_file_chooser_widget_initial_focus*(chooser: pointer)
proc gtk_file_chooser_widget_get_selected_files*(impl: pointer): pointer
proc gtk_file_chooser_widget_get_selection_model*(chooser: pointer): pointer
proc gtk_file_dialog_new*(): pointer
proc gtk_file_dialog_get_title*(self: pointer): pointer
proc gtk_file_dialog_get_modal*(self: pointer): pointer
proc gtk_file_dialog_get_filters*(self: pointer): pointer
proc gtk_file_dialog_get_default_filter*(self: pointer): pointer
proc gtk_file_dialog_get_initial_folder*(self: pointer): pointer
proc gtk_file_dialog_get_initial_name*(self: pointer): pointer
proc gtk_file_dialog_get_initial_file*(self: pointer): pointer
proc gtk_file_dialog_get_accept_label*(self: pointer): pointer
proc gtk_file_filter_new*(): pointer
proc gtk_file_filter_get_name*(filter: pointer): pointer
proc gtk_file_filter_add_pixbuf_formats*(filter: pointer): pointer
proc gtk_file_filter_get_attributes*(filter: pointer): pointer
proc gtk_file_filter_to_gvariant*(filter: pointer): pointer
proc gtk_file_filter_new_from_gvariant*(variant: pointer): pointer
proc gtk_file_filter_get_as_patterns*(filter: pointer): pointer {.importc: "_gtk_file_filter_get_as_patterns".}
proc gtk_file_filter_get_as_pattern_nsstrings*(filter: pointer): pointer {.importc: "_gtk_file_filter_get_as_pattern_nsstrings".}
proc gtk_file_filter_store_types_in_list*(filter: pointer, list: pointer) {.importc: "_gtk_file_filter_store_types_in_list".}
proc gtk_file_launcher_new*(file: pointer): pointer
proc gtk_file_launcher_get_file*(self: pointer): pointer
proc gtk_file_launcher_get_always_ask*(self: pointer): pointer
proc gtk_file_launcher_get_writable*(self: pointer): pointer
proc gtk_file_system_model_get_directory*(model: pointer): pointer {.importc: "_gtk_file_system_model_get_directory".}
proc gtk_file_system_model_get_cancellable*(model: pointer): pointer {.importc: "_gtk_file_system_model_get_cancellable".}
proc gtk_file_thumbnail_get_icon_size*(self: pointer): pointer {.importc: "_gtk_file_thumbnail_get_icon_size".}
proc gtk_filter_get_strictness*(self: pointer): pointer
proc gtk_filter_list_model_get_watch_items*(self: pointer): pointer
proc gtk_fixed_layout_new*(): pointer
proc gtk_fixed_layout_child_get_transform*(child: pointer): pointer
proc gtk_flatten_list_model_new*(model: pointer): pointer
proc gtk_flatten_list_model_get_model*(self: pointer): pointer
proc gtk_flow_box_child_is_selected*(child: pointer): pointer
proc gtk_flow_box_child_changed*(child: pointer): pointer
proc gtk_flow_box_get_activate_on_single_click*(box: pointer): pointer
proc gtk_flow_box_remove_all*(box: pointer): pointer
proc gtk_flow_box_select_all*(box: pointer): pointer
proc gtk_flow_box_unselect_all*(box: pointer): pointer
proc gtk_flow_box_invalidate_filter*(box: pointer): pointer
proc gtk_flow_box_invalidate_sort*(box: pointer): pointer
proc gtk_flow_box_disable_move_cursor*(box: pointer)
proc gtk_font_chooser_install_properties*(klass: pointer) {.importc: "_gtk_font_chooser_install_properties".}
proc gtk_font_chooser_delegate_iface_init*(iface: pointer) {.importc: "_gtk_font_chooser_delegate_iface_init".}
proc gtk_font_dialog_button_new*(dialog: pointer): pointer
proc gtk_font_dialog_button_get_dialog*(self: pointer): pointer
proc gtk_font_dialog_button_get_level*(self: pointer): pointer
proc gtk_font_dialog_button_get_font_desc*(self: pointer): pointer
proc gtk_font_dialog_button_get_font_features*(self: pointer): pointer
proc gtk_font_dialog_button_get_language*(self: pointer): pointer
proc gtk_font_dialog_button_get_use_font*(self: pointer): pointer
proc gtk_font_dialog_button_get_use_size*(self: pointer): pointer
proc gtk_font_dialog_new*(): pointer
proc gtk_font_dialog_get_title*(self: pointer): pointer
proc gtk_font_dialog_get_modal*(self: pointer): pointer
proc gtk_font_dialog_get_language*(self: pointer): pointer
proc gtk_font_dialog_get_font_map*(self: pointer): pointer
proc gtk_font_dialog_get_filter*(self: pointer): pointer
proc gtk_font_filter_new*(): pointer {.importc: "_gtk_font_filter_new".}
proc gtk_font_filter_get_monospace*(self: pointer): gboolean {.importc: "_gtk_font_filter_get_monospace".}
proc gtk_font_filter_get_language*(self: pointer): pointer {.importc: "_gtk_font_filter_get_language".}
proc gtk_gesture_pan_new*(orientation: pointer): pointer
proc gtk_gesture_pan_get_orientation*(gesture: pointer): pointer
proc gtk_gesture_check*(gesture: pointer): pointer {.importc: "_gtk_gesture_check".}
proc gtk_gesture_stylus_new*(): pointer
proc gtk_gesture_stylus_get_stylus_only*(gesture: pointer): pointer
proc gtk_gesture_stylus_get_device_tool*(gesture: pointer): pointer
proc gtk_gl_area_get_allowed_apis*(area: pointer): pointer
proc gtk_gl_area_get_api*(area: pointer): pointer
proc gtk_gl_area_get_use_es*(area: pointer): gboolean
proc gtk_gl_area_get_auto_render*(area: pointer): pointer
proc gtk_gl_area_get_context*(area: pointer): pointer
proc gtk_gl_area_get_error*(area: pointer): pointer
proc gtk_graphics_offload_new*(child: GtkWidget): pointer
proc gtk_graphics_offload_get_child*(self: pointer): pointer
proc gtk_graphics_offload_get_enabled*(self: pointer): pointer
proc gtk_graphics_offload_get_black_background*(self: pointer): pointer
proc gtk_grid_layout_new*(): pointer
proc gtk_grid_layout_get_row_homogeneous*(grid: pointer): pointer
proc gtk_grid_layout_get_row_spacing*(grid: pointer): pointer
proc gtk_grid_layout_get_column_homogeneous*(grid: pointer): pointer
proc gtk_grid_layout_get_column_spacing*(grid: pointer): pointer
proc gtk_grid_layout_get_baseline_row*(grid: pointer): pointer
proc gtk_grid_layout_child_get_row*(child: pointer): pointer
proc gtk_grid_layout_child_get_column*(child: pointer): pointer
proc gtk_grid_layout_child_get_column_span*(child: pointer): pointer
proc gtk_grid_layout_child_get_row_span*(child: pointer): pointer
proc gtk_grid_view_get_tab_behavior*(self: pointer): pointer
proc gtk_gst_paintable_new*(): pointer
proc gtk_gst_sink_get_type*(): GType
proc gtk_header_bar_get_use_native_controls*(bar: pointer): pointer
proc gtk_header_bar_track_default_decoration*(bar: pointer): pointer {.importc: "_gtk_header_bar_track_default_decoration".}
proc gtk_icon_cache_unref*(cache: pointer)
proc gtk_icon_cache_validate*(info: pointer): gboolean
proc gtk_icon_helper_clear*(self: pointer) {.importc: "_gtk_icon_helper_clear".}
proc gtk_icon_helper_get_is_empty*(self: pointer): gboolean {.importc: "_gtk_icon_helper_get_is_empty".}
proc gtk_icon_helper_get_storage_type*(self: pointer): pointer {.importc: "_gtk_icon_helper_get_storage_type".}
proc gtk_icon_helper_get_pixel_size*(self: pointer): pointer {.importc: "_gtk_icon_helper_get_pixel_size".}
proc gtk_icon_helper_get_use_fallback*(self: pointer): gboolean {.importc: "_gtk_icon_helper_get_use_fallback".}
proc gtk_icon_helper_get_size*(self: pointer): pointer
proc gtk_icon_helper_invalidate*(self: pointer)
proc gtk_icon_paintable_get_file*(self: pointer): pointer
proc gtk_icon_paintable_get_icon_name*(self: pointer): pointer
proc gtk_icon_paintable_is_symbolic*(self: pointer): pointer
proc gtk_icon_paintable_load_in_thread*(self: pointer)
proc gtk_icon_theme_error_quark*(): pointer
proc gtk_icon_theme_get_display*(self: pointer): pointer
proc gtk_icon_theme_get_search_path*(self: pointer): pointer
proc gtk_icon_theme_get_resource_path*(self: pointer): pointer
proc gtk_icon_theme_get_theme_name*(self: pointer): pointer
proc gtk_icon_theme_get_icon_names*(self: pointer): pointer
proc gtk_icon_theme_get_serial*(self: pointer): pointer

{.pop.}

# ============================================================================
# ICON API
# ============================================================================

{.push importc, cdecl.}
proc icon_cache_remove*(icon: pointer)
proc icon_cache_mark_used_if_cached*(icon: pointer)

{.pop.}

# ============================================================================
# GTK API
# ============================================================================

{.push importc, cdecl.}
proc gtk_image_definition_new_empty*(): pointer
proc gtk_image_definition_new_icon_name*(icon_name: cstring): pointer
proc gtk_image_definition_new_gicon*(gicon: pointer): pointer
proc gtk_image_definition_new_paintable*(paintable: pointer): pointer
proc gtk_image_definition_ref*(def: pointer): pointer
proc gtk_image_definition_unref*(def: pointer)
proc gtk_image_definition_get_storage_type*(def: pointer): pointer
proc gtk_image_definition_get_scale*(def: pointer): pointer
proc gtk_image_definition_get_icon_name*(def: pointer): cstring
proc gtk_image_definition_get_gicon*(def: pointer): pointer
proc gtk_image_definition_get_paintable*(def: pointer): pointer
proc gtk_image_new_from_resource*(resource_path: cstring): pointer
proc gtk_image_new_from_pixbuf*(pixbuf: pointer): ptr GtkWidget
proc gtk_image_new_from_gicon*(icon: pointer): pointer
proc gtk_image_clear*(image: pointer): pointer
proc gtk_image_get_storage_type*(image: pointer): pointer
proc gtk_image_get_gicon*(image: pointer): pointer
proc gtk_image_get_icon_size*(image: pointer): pointer
proc gtk_image_get_definition*(image: pointer): pointer
proc gtk_im_context_focus_in*(context: pointer): pointer
proc gtk_im_context_focus_out*(context: pointer): pointer
proc gtk_im_context_reset*(context: pointer): pointer
proc gtk_im_context_ime_register_type*(type_module: pointer)
proc gtk_im_modules_init*(): pointer
proc gtk_im_module_ensure_extension_point*()
proc gtk_im_module_create*(context_id: cstring): pointer {.importc: "_gtk_im_module_create".}
proc gtk_im_module_get_default_context_id*(display: pointer): cstring {.importc: "_gtk_im_module_get_default_context_id".}
proc gtk_im_multicontext_get_context_id*(context: pointer): pointer
proc gtk_inscription_get_layout*(self: pointer): pointer

{.pop.}

# ============================================================================
# G API
# ============================================================================

{.push importc, cdecl.}
proc g_clear_pointer*(): pointer
proc g_ascii_isspace*(s: pointer): pointer
proc g_unichar_isspace*(str: pointer): pointer

{.pop.}

# ============================================================================
# GTK API
# ============================================================================

{.push importc, cdecl.}
proc gtk_joined_menu_get_n_joined*(self: pointer): guint
proc gtk_kinetic_scrolling_free*(kinetic: pointer)
proc gtk_kinetic_scrolling_stop*(data: pointer)
proc gtk_label_get_label*(self: pointer): pointer
proc gtk_label_get_mnemonic_keyval*(self: pointer): pointer
proc gtk_label_get_cursor_position*(label: pointer): pointer {.importc: "_gtk_label_get_cursor_position".}
proc gtk_label_get_selection_bound*(label: pointer): pointer {.importc: "_gtk_label_get_selection_bound".}
proc gtk_layout_child_get_layout_manager*(layout_child: pointer): pointer
proc gtk_layout_child_get_child_widget*(layout_child: pointer): pointer
proc gtk_layout_manager_get_request_mode*(manager: pointer): pointer
proc gtk_layout_manager_get_widget*(manager: pointer): pointer
proc gtk_layout_manager_layout_changed*(manager: pointer): pointer
proc gtk_level_bar_get_mode*(self: pointer): pointer
proc gtk_level_bar_get_inverted*(self: pointer): pointer
proc gtk_list_base_get_orientation*(self: pointer): pointer
proc gtk_list_base_get_manager*(self: pointer): pointer
proc gtk_list_base_get_n_items*(self: pointer): guint
proc gtk_list_base_get_model*(self: pointer): pointer
proc gtk_list_base_get_anchor*(self: pointer): guint
proc gtk_list_base_get_enable_rubberband*(self: pointer): gboolean
proc gtk_list_base_get_tab_behavior*(self: pointer): pointer
proc gtk_list_base_allocate*(self: pointer)
proc gtk_list_box_row_get_header*(row: pointer): pointer
proc gtk_list_box_row_changed*(row: pointer): pointer
proc gtk_list_box_row_is_selected*(row: pointer): pointer
proc gtk_list_box_row_get_selectable*(row: pointer): pointer
proc gtk_list_box_row_get_activatable*(row: pointer): pointer
proc gtk_list_box_remove_all*(box: pointer): pointer
proc gtk_list_box_select_all*(box: pointer): pointer
proc gtk_list_box_unselect_all*(box: pointer): pointer
proc gtk_list_box_invalidate_filter*(box: pointer): pointer
proc gtk_list_box_invalidate_sort*(box: pointer): pointer
proc gtk_list_box_invalidate_headers*(box: pointer): pointer
proc gtk_list_box_get_activate_on_single_click*(box: pointer): pointer
proc gtk_list_box_drag_unhighlight_row*(box: pointer): pointer
proc gtk_list_box_get_show_separators*(box: pointer): pointer
proc gtk_list_box_get_tab_behavior*(box: pointer): pointer
proc gtk_list_factory_widget_get_object*(self: pointer): gpointer
proc gtk_list_factory_widget_get_factory*(self: pointer): pointer
proc gtk_list_factory_widget_get_single_click_activate*(self: pointer): gboolean
proc gtk_list_factory_widget_get_activatable*(self: pointer): gboolean
proc gtk_list_factory_widget_get_selectable*(self: pointer): gboolean
proc gtk_list_header_base_get_start*(self: pointer): guint
proc gtk_list_header_base_get_end*(self: pointer): guint
proc gtk_list_header_base_get_item*(self: pointer): gpointer
proc gtk_list_header_get_item*(self: pointer): pointer
proc gtk_list_header_get_child*(self: pointer): pointer
proc gtk_list_header_new*(): pointer
proc gtk_list_header_widget_new*(factory: pointer): ptr GtkWidget
proc gtk_list_header_widget_get_factory*(self: pointer): pointer
proc gtk_list_item_base_get_position*(self: pointer): guint
proc gtk_list_item_base_get_item*(self: pointer): gpointer
proc gtk_list_item_base_get_selected*(self: pointer): gboolean
proc gtk_list_item_get_accessible_description*(self: pointer): pointer
proc gtk_list_item_get_accessible_label*(self: pointer): pointer
proc gtk_list_item_manager_get_root*(self: pointer): gpointer
proc gtk_list_item_manager_get_first*(self: pointer): gpointer
proc gtk_list_item_manager_get_last*(self: pointer): gpointer
proc gtk_list_item_manager_gc_tiles*(self: pointer)
proc gtk_list_item_manager_get_model*(self: pointer): pointer
proc gtk_list_item_manager_get_has_sections*(self: pointer): gboolean
proc gtk_list_item_tracker_new*(self: pointer): pointer
proc gtk_list_item_new*(): pointer
proc gtk_list_list_model_clear*(self: pointer)
proc gtk_list_view_get_header_factory*(self: pointer): pointer
proc gtk_list_view_get_tab_behavior*(self: pointer): pointer
proc gtk_magnifier_new*(inspected: GtkWidget): ptr GtkWidget {.importc: "_gtk_magnifier_new".}
proc gtk_magnifier_get_inspected*(magnifier: pointer): ptr GtkWidget {.importc: "_gtk_magnifier_get_inspected".}
proc gtk_magnifier_get_magnification*(magnifier: pointer): pointer {.importc: "_gtk_magnifier_get_magnification".}
proc gtk_magnifier_get_resize*(magnifier: pointer): gboolean {.importc: "_gtk_magnifier_get_resize".}
proc gtk_disable_portals*(): pointer
proc gtk_disable_portal_interfaces*(portal_interfaces: cstring): pointer
proc gtk_map_list_model_get_model*(self: pointer): pointer
proc gtk_map_list_model_has_map*(self: pointer): pointer
proc gtk_media_file_new_for_input_stream*(stream: pointer): pointer
proc gtk_media_file_extension_init*()
proc gtk_media_file_get_extension*(): pointer
proc gtk_media_stream_unprepared*(self: pointer)
proc gtk_media_stream_stream_unprepared*(self: pointer): pointer
proc gtk_media_stream_ended*(self: pointer)
proc gtk_media_stream_stream_ended*(self: pointer): pointer
proc gtk_media_stream_seek_success*(self: pointer): pointer
proc gtk_media_stream_seek_failed*(self: pointer): pointer
proc gtk_menu_button_get_label*(menu_button: pointer): pointer
proc gtk_menu_button_get_can_shrink*(menu_button: pointer): pointer
proc gtk_menu_tracker_item_get_action_name*(self: pointer): cstring
proc gtk_menu_tracker_item_get_action_target*(self: pointer): pointer
proc gtk_menu_tracker_item_get_special*(self: pointer): cstring
proc gtk_menu_tracker_item_get_custom*(self: pointer): cstring
proc gtk_menu_tracker_item_get_display_hint*(self: pointer): cstring
proc gtk_menu_tracker_item_get_text_direction*(self: pointer): cstring
proc gtk_menu_tracker_item_get_observable*(self: pointer): pointer {.importc: "_gtk_menu_tracker_item_get_observable".}
proc gtk_menu_tracker_item_get_is_separator*(self: pointer): gboolean
proc gtk_menu_tracker_item_get_label*(self: pointer): cstring
proc gtk_menu_tracker_item_get_use_markup*(self: pointer): gboolean
proc gtk_menu_tracker_item_get_icon*(self: pointer): pointer
proc gtk_menu_tracker_item_get_verb_icon*(self: pointer): pointer
proc gtk_menu_tracker_item_get_sensitive*(self: pointer): gboolean
proc gtk_menu_tracker_item_get_role*(self: pointer): pointer
proc gtk_menu_tracker_item_get_toggled*(self: pointer): gboolean
proc gtk_menu_tracker_item_get_accel*(self: pointer): cstring
proc gtk_menu_tracker_item_get_link_namespace*(self: pointer): cstring {.importc: "_gtk_menu_tracker_item_get_link_namespace".}
proc gtk_menu_tracker_item_may_disappear*(self: pointer): gboolean
proc gtk_menu_tracker_item_get_is_visible*(self: pointer): gboolean
proc gtk_menu_tracker_item_get_should_request_show*(self: pointer): gboolean
proc gtk_menu_tracker_item_activated*(self: pointer)
proc gtk_menu_tracker_item_get_submenu_shown*(self: pointer): gboolean
proc gtk_menu_tracker_free*(tracker: pointer)
proc gtk_model_button_new*(): ptr GtkWidget
proc gtk_get_module_path*(`type`: cstring): pointer {.importc: "_gtk_get_module_path".}
proc gtk_mount_operation_get_type*(): pointer
proc gtk_mount_operation_is_showing*(op: pointer): pointer
proc gtk_mount_operation_get_parent*(op: pointer): pointer
proc gtk_mount_operation_get_display*(op: pointer): pointer
proc gtk_mount_operation_lookup_context_free*(context: pointer) {.importc: "_gtk_mount_operation_lookup_context_free".}
proc gtk_any_filter_new*(): pointer
proc gtk_every_filter_new*(): pointer
proc gtk_native_realize*(self: pointer): pointer
proc gtk_native_unrealize*(self: pointer): pointer
proc gtk_native_get_for_surface*(surface: pointer): pointer
proc gtk_native_queue_relayout*(native: pointer)
proc gtk_notebook_next_page*(notebook: pointer): pointer
proc gtk_notebook_prev_page*(notebook: pointer): pointer
proc gtk_notebook_get_show_border*(notebook: pointer): pointer
proc gtk_notebook_get_scrollable*(notebook: pointer): pointer
proc gtk_notebook_popup_enable*(notebook: pointer): pointer
proc gtk_notebook_popup_disable*(notebook: pointer): pointer
proc gtk_openuri_portal_is_available*(): pointer
proc gtk_openuri_portal_can_open*(uri: cstring): gboolean
proc gtk_orientable_get_orientation*(orientable: pointer): pointer
proc gtk_overlay_layout_new*(): pointer
proc gtk_overlay_layout_child_get_measure*(child: pointer): pointer
proc gtk_overlay_layout_child_get_clip_overlay*(child: pointer): pointer
proc gtk_page_setup_get_paper_size*(setup: pointer): pointer
proc gtk_page_setup_unix_dialog_get_page_setup*(dialog: pointer): pointer
proc gtk_page_thumbnail_new*(): pointer
proc gtk_page_thumbnail_get_page_num*(self: pointer): pointer
proc gtk_paned_get_resize_start_child*(paned: pointer): pointer
proc gtk_paned_get_shrink_start_child*(paned: pointer): pointer
proc gtk_paned_get_resize_end_child*(paned: pointer): pointer
proc gtk_paned_get_shrink_end_child*(paned: pointer): pointer
proc gtk_paned_get_wide_handle*(paned: pointer): pointer
proc gtk_pango_glyph_item_has_color_glyphs*(item: pointer): gboolean
proc gtk_pango_layout_has_color_glyphs*(layout: pointer): gboolean
proc gtk_paper_size_free*(size: pointer): pointer
proc gtk_paper_size_get_width*(size: pointer, unit: pointer): pointer
proc gtk_paper_size_get_height*(size: pointer, unit: pointer): pointer
proc gtk_paper_size_is_custom*(size: pointer): pointer
proc gtk_paper_size_is_ipp*(size: pointer): pointer
proc gtk_password_entry_buffer_new*(): pointer
proc gtk_password_entry_get_text_widget*(entry: pointer): pointer
proc gtk_password_entry_toggle_peek*(entry: pointer)
proc gtk_path_bar_up*(path_bar: pointer) {.importc: "_gtk_path_bar_up".}
proc gtk_path_bar_down*(path_bar: pointer) {.importc: "_gtk_path_bar_down".}
proc gtk_picture_new_for_paintable*(paintable: pointer): pointer
proc gtk_picture_new_for_pixbuf*(pixbuf: pointer): ptr GtkWidget
proc gtk_picture_new_for_resource*(resource_path: cstring): pointer
proc gtk_picture_get_paintable*(self: pointer): pointer
proc gtk_picture_get_keep_aspect_ratio*(self: pointer): gboolean
proc gtk_picture_get_content_fit*(self: pointer): pointer
proc gtk_picture_get_isolate_contents*(self: pointer): pointer
proc gtk_picture_get_alternative_text*(self: pointer): pointer
proc gtk_places_sidebar_new*(): ptr GtkWidget
proc gtk_places_sidebar_get_open_flags*(sidebar: pointer): pointer
proc gtk_places_sidebar_get_location*(sidebar: pointer): pointer
proc gtk_places_sidebar_get_show_recent*(sidebar: pointer): gboolean
proc gtk_places_sidebar_get_show_desktop*(sidebar: pointer): gboolean
proc gtk_places_sidebar_get_show_enter_location*(sidebar: pointer): gboolean
proc gtk_places_sidebar_get_shortcuts*(sidebar: pointer): pointer
proc gtk_places_sidebar_get_show_trash*(sidebar: pointer): gboolean
proc gtk_places_sidebar_get_show_other_locations*(sidebar: pointer): gboolean
proc gtk_places_sidebar_get_show_starred_location*(sidebar: pointer): gboolean
proc gtk_places_view_get_open_flags*(view: pointer): pointer
proc gtk_places_view_get_search_query*(view: pointer): cstring
proc gtk_places_view_get_loading*(view: pointer): gboolean
proc gtk_places_view_new*(): ptr GtkWidget
proc gtk_places_view_row_get_eject_button*(row: pointer): ptr GtkWidget
proc gtk_places_view_row_get_mount*(row: pointer): pointer
proc gtk_places_view_row_get_volume*(row: pointer): pointer
proc gtk_places_view_row_get_file*(row: pointer): pointer
proc gtk_places_view_row_get_is_network*(row: pointer): gboolean
proc gtk_pointer_focus_ref*(focus: pointer): pointer
proc gtk_pointer_focus_unref*(focus: pointer)
proc gtk_pointer_focus_get_target*(focus: pointer): ptr GtkWidget
proc gtk_pointer_focus_get_implicit_grab*(focus: pointer): ptr GtkWidget
proc gtk_pointer_focus_get_effective_target*(focus: pointer): ptr GtkWidget
proc gtk_pointer_focus_repick_target*(focus: pointer)

{.pop.}


# ============================================================================
#  API
# ============================================================================

{.push importc, cdecl.}
proc popcnt*(): pointer {.importc: "__popcnt".}


# ============================================================================
# GTK API
# ============================================================================

{.push importc, cdecl.}
proc gtk_popover_bin_new*(): pointer
proc gtk_popover_bin_get_child*(self: pointer): pointer
proc gtk_popover_bin_get_menu_model*(self: pointer): pointer
proc gtk_popover_bin_get_popover*(self: pointer): pointer
proc gtk_popover_bin_popup*(self: pointer): pointer
proc gtk_popover_bin_popdown*(self: pointer): pointer
proc gtk_popover_bin_get_handle_input*(self: pointer): pointer
proc gtk_popover_get_position*(popover: pointer): pointer
proc gtk_popover_get_autohide*(popover: pointer): pointer
proc gtk_popover_get_has_arrow*(popover: pointer): pointer
proc gtk_popover_get_mnemonics_visible*(popover: pointer): pointer
proc gtk_popover_get_cascade_popdown*(popover: pointer): pointer
proc gtk_popover_present*(popover: pointer): pointer
proc gtk_popover_menu_bar_new_from_model*(model: pointer): pointer
proc gtk_popover_menu_bar_get_menu_model*(bar: pointer): pointer
proc gtk_popover_menu_bar_select_first*(bar: pointer): pointer
proc gtk_popover_menu_bar_get_viewable_menu_bars*(window: pointer): pointer
proc gtk_popover_menu_get_flags*(popover: pointer): pointer
proc gtk_popover_menu_close_submenus*(menu: pointer)
proc gtk_popover_menu_new*(): ptr GtkWidget
proc gtk_popover_menu_get_stack*(menu: pointer): ptr GtkWidget
proc gtk_print_backend_error_quark*(): pointer
proc gtk_print_backend_printer_list_is_done*(print_backend: pointer): pointer
proc gtk_print_backend_load_modules*(): pointer
proc gtk_print_backend_destroy*(print_backend: pointer): pointer
proc gtk_print_backend_set_list_done*(backend: pointer): pointer
proc gtk_printer_is_new*(printer: pointer): pointer
proc gtk_print_backends_init*()

{.pop.}

# ============================================================================
# SUPPORTS API
# ============================================================================

{.push importc, cdecl.}
proc supports_am_pm*(): gboolean

{.pop.}

# ============================================================================
# GTK API
# ============================================================================

{.push importc, cdecl.}
proc gtk_print_setup_unref*(setup: pointer): pointer
proc gtk_print_setup_get_print_settings*(setup: pointer): pointer
proc gtk_print_setup_get_page_setup*(setup: pointer): pointer
proc gtk_print_dialog_get_title*(self: pointer): pointer
proc gtk_print_dialog_get_accept_label*(self: pointer): pointer
proc gtk_print_dialog_get_modal*(self: pointer): pointer
proc gtk_print_dialog_get_page_setup*(self: pointer): pointer
proc gtk_print_dialog_get_print_settings*(self: pointer): pointer
proc gtk_printer_cpdb_register_type*(module: pointer)
proc gtk_printer_cups_register_type*(module: pointer)
proc gtk_printer_get_name*(printer: pointer): pointer
proc gtk_printer_get_state_message*(printer: pointer): pointer
proc gtk_printer_get_description*(printer: pointer): pointer
proc gtk_printer_get_location*(printer: pointer): pointer
proc gtk_printer_get_icon_name*(printer: pointer): pointer
proc gtk_printer_get_job_count*(printer: pointer): pointer
proc gtk_printer_is_active*(printer: pointer): pointer
proc gtk_printer_is_paused*(printer: pointer): pointer
proc gtk_printer_is_accepting_jobs*(printer: pointer): pointer
proc gtk_printer_is_virtual*(printer: pointer): pointer
proc gtk_printer_is_default*(printer: pointer): pointer
proc gtk_printer_accepts_pdf*(printer: pointer): pointer
proc gtk_printer_accepts_ps*(printer: pointer): pointer
proc gtk_printer_has_details*(printer: pointer): pointer
proc gtk_printer_request_details*(printer: pointer): pointer
proc gtk_printer_get_capabilities*(printer: pointer): pointer
proc gtk_printer_option_clear_has_conflict*(option: pointer): pointer
proc gtk_printer_option_get_activates_default*(option: pointer): pointer
proc gtk_printer_option_set_clear_conflicts*(set: pointer): pointer
proc gtk_printer_option_set_get_groups*(set: pointer): pointer
proc gtk_printer_option_widget_has_external_label*(setting: pointer): pointer
proc gtk_printer_get_custom_widgets*(printer: pointer): pointer {.importc: "_gtk_printer_get_custom_widgets".}
proc gtk_printer_find*(name: cstring): pointer
proc gtk_print_job_get_title*(job: pointer): pointer
proc gtk_print_job_get_status*(job: pointer): pointer
proc gtk_print_job_get_track_print_status*(job: pointer): pointer
proc gtk_print_job_get_pages*(job: pointer): pointer
proc gtk_print_job_get_page_set*(job: pointer): pointer
proc gtk_print_job_get_num_copies*(job: pointer): pointer
proc gtk_print_job_get_scale*(job: pointer): pointer
proc gtk_print_job_get_n_up*(job: pointer): pointer
proc gtk_print_job_get_n_up_layout*(job: pointer): pointer
proc gtk_print_job_get_rotate*(job: pointer): pointer
proc gtk_print_job_get_collate*(job: pointer): pointer
proc gtk_print_job_get_reverse*(job: pointer): pointer
proc gtk_print_error_quark*(): pointer
proc gtk_print_operation_preview_end_preview*(preview: pointer): pointer
proc gtk_print_context_translate_into_margin*(context: pointer) {.importc: "_gtk_print_context_translate_into_margin".}
proc gtk_print_context_rotate_according_to_orientation*(context: pointer) {.importc: "_gtk_print_context_rotate_according_to_orientation".}
proc gtk_print_context_reverse_according_to_orientation*(context: pointer) {.importc: "_gtk_print_context_reverse_according_to_orientation".}
proc gtk_print_settings_get_printer*(settings: pointer): pointer
proc gtk_print_settings_get_orientation*(settings: pointer): pointer
proc gtk_print_settings_get_paper_size*(settings: pointer): pointer
proc gtk_print_settings_get_use_color*(settings: pointer): pointer
proc gtk_print_settings_get_collate*(settings: pointer): pointer
proc gtk_print_settings_get_reverse*(settings: pointer): pointer
proc gtk_print_settings_get_duplex*(settings: pointer): pointer
proc gtk_print_settings_get_quality*(settings: pointer): pointer
proc gtk_print_settings_get_n_copies*(settings: pointer): pointer
proc gtk_print_settings_get_number_up*(settings: pointer): pointer
proc gtk_print_settings_get_number_up_layout*(settings: pointer): pointer
proc gtk_print_settings_get_resolution*(settings: pointer): pointer
proc gtk_print_settings_get_resolution_x*(settings: pointer): pointer
proc gtk_print_settings_get_resolution_y*(settings: pointer): pointer
proc gtk_print_settings_get_printer_lpi*(settings: pointer): pointer
proc gtk_print_settings_get_scale*(settings: pointer): pointer
proc gtk_print_settings_get_print_pages*(settings: pointer): pointer
proc gtk_print_settings_get_page_set*(settings: pointer): pointer
proc gtk_print_settings_get_default_source*(settings: pointer): pointer
proc gtk_print_settings_get_media_type*(settings: pointer): pointer
proc gtk_print_settings_get_dither*(settings: pointer): pointer
proc gtk_print_settings_get_finishings*(settings: pointer): pointer
proc gtk_print_settings_get_output_bin*(settings: pointer): pointer
proc gtk_print_unix_dialog_get_page_setup*(dialog: pointer): pointer
proc gtk_print_unix_dialog_get_current_page*(dialog: pointer): pointer
proc gtk_print_unix_dialog_get_settings*(dialog: pointer): pointer
proc gtk_print_unix_dialog_get_selected_printer*(dialog: pointer): pointer
proc gtk_print_unix_dialog_get_manual_capabilities*(dialog: pointer): pointer
proc gtk_print_unix_dialog_get_support_selection*(dialog: pointer): pointer
proc gtk_print_unix_dialog_get_has_selection*(dialog: pointer): pointer
proc gtk_print_unix_dialog_get_embed_page_setup*(dialog: pointer): pointer
proc gtk_print_unix_dialog_get_page_setup_set*(dialog: pointer): pointer
proc gtk_print_convert_to_mm*(len: pointer, unit: pointer): pointer {.importc: "_gtk_print_convert_to_mm".}
proc gtk_print_convert_from_mm*(len: pointer, unit: pointer): pointer {.importc: "_gtk_print_convert_from_mm".}
proc gtk_print_win32_devnames_free*(devnames: pointer): pointer
proc gtk_print_win32_devnames_to_win32*(devnames: pointer): pointer
proc gtk_print_win32_devnames_to_win32_from_printer_name*(printer: cstring): pointer
proc gtk_make_ci_glob_pattern*(pattern: cstring): cstring {.importc: "_gtk_make_ci_glob_pattern".}
proc gtk_ensure_resources*() {.importc: "_gtk_ensure_resources".}
proc gtk_main_sync*()
proc gtk_window_group_get_current_grab*(window_group: pointer): ptr GtkWidget
proc gtk_grab_add*(widget: GtkWidget)
proc gtk_grab_remove*(widget: GtkWidget)
proc gtk_main_do_event*(event: pointer): gboolean
proc gtk_get_current_event_time*(): pointer
proc gtk_get_slowdown*(): pointer {.importc: "_gtk_get_slowdown".}
proc gtk_set_slowdown*(slowdown_factor: pointer) {.importc: "_gtk_set_slowdown".}
proc gtk_get_display_debug_flags*(display: pointer): pointer
proc gtk_get_any_display_debug_flag_set*(): gboolean
proc gtk_elide_underscores*(original: cstring): cstring {.importc: "_gtk_elide_underscores".}

{.pop.}

# ============================================================================
# SETLOCALE API
# ============================================================================

{.push importc, cdecl.}
proc setlocale_initialization*()

{.pop.}

# ============================================================================
# GTK API
# ============================================================================

{.push importc, cdecl.}
proc gtk_load_dll_with_libgtk3_manifest*(dllname: pointer) {.importc: "_gtk_load_dll_with_libgtk3_manifest".}
proc gtk_progress_bar_get_pulse_step*(pbar: pointer): pointer
proc gtk_progress_bar_get_inverted*(pbar: pointer): pointer
proc gtk_progress_bar_get_ellipsize*(pbar: pointer): pointer
proc gtk_progress_tracker_finish*(tracker: pointer)
proc gtk_progress_tracker_get_state*(tracker: pointer): pointer
proc gtk_progress_tracker_get_iteration*(tracker: pointer): pointer
proc gtk_progress_tracker_get_iteration_cycle*(tracker: pointer): guint64
proc gtk_property_lookup_list_model_get_object*(self: pointer): gpointer
proc gtk_query_get_type*(): GType
proc gtk_range_get_adjustment*(range: pointer): pointer
proc gtk_range_get_inverted*(range: pointer): pointer
proc gtk_range_get_flippable*(range: pointer): pointer
proc gtk_range_get_slider_size_fixed*(range: pointer): pointer
proc gtk_range_get_value*(range: pointer): pointer
proc gtk_range_get_show_fill_level*(range: pointer): pointer
proc gtk_range_get_restrict_to_fill_level*(range: pointer): pointer
proc gtk_range_get_fill_level*(range: pointer): pointer
proc gtk_range_get_round_digits*(range: pointer): pointer
proc gtk_range_get_has_origin*(range: pointer): gboolean {.importc: "_gtk_range_get_has_origin".}
proc gtk_range_stop_autoscroll*(range: pointer)
proc gtk_rb_tree_ref*(tree: pointer): pointer
proc gtk_rb_tree_unref*(tree: pointer)
proc gtk_rb_tree_get_root*(tree: pointer): gpointer
proc gtk_rb_tree_get_first*(tree: pointer): gpointer
proc gtk_rb_tree_get_last*(tree: pointer): gpointer
proc gtk_rb_tree_node_get_previous*(node: gpointer): gpointer
proc gtk_rb_tree_node_get_next*(node: gpointer): gpointer
proc gtk_rb_tree_node_get_parent*(node: gpointer): gpointer
proc gtk_rb_tree_node_get_left*(node: gpointer): gpointer
proc gtk_rb_tree_node_get_right*(node: gpointer): gpointer
proc gtk_rb_tree_node_get_tree*(node: gpointer): pointer
proc gtk_rb_tree_node_mark_dirty*(node: gpointer)
proc gtk_rb_tree_remove_all*(tree: pointer)
proc gtk_recent_manager_error_quark*(): pointer
proc gtk_recent_manager_get_items*(manager: pointer): pointer
proc gtk_recent_info_ref*(info: pointer): pointer
proc gtk_recent_info_unref*(info: pointer): pointer
proc gtk_recent_info_get_uri*(info: pointer): pointer
proc gtk_recent_info_get_display_name*(info: pointer): pointer
proc gtk_recent_info_get_description*(info: pointer): pointer
proc gtk_recent_info_get_mime_type*(info: pointer): pointer
proc gtk_recent_info_get_added*(info: pointer): pointer
proc gtk_recent_info_get_modified*(info: pointer): pointer
proc gtk_recent_info_get_visited*(info: pointer): pointer
proc gtk_recent_info_get_private_hint*(info: pointer): pointer
proc gtk_recent_info_get_gicon*(info: pointer): pointer
proc gtk_recent_info_get_age*(info: pointer): pointer
proc gtk_recent_info_is_local*(info: pointer): pointer
proc gtk_recent_info_exists*(info: pointer): pointer
proc gtk_recent_manager_sync*() {.importc: "_gtk_recent_manager_sync".}
proc gtk_render_node_paintable_get_render_node*(self: pointer): pointer
proc gtk_root_get_display*(self: pointer): pointer
proc gtk_root_get_focus*(self: pointer): pointer
proc gtk_root_get_constraint_solver*(self: pointer): pointer
proc gtk_root_start_layout*(self: pointer)
proc gtk_root_stop_layout*(self: pointer)
proc gtk_root_queue_restyle*(self: pointer)
proc gtk_scale_button_get_plus_button*(button: pointer): pointer
proc gtk_scale_button_get_minus_button*(button: pointer): pointer
proc gtk_scale_button_get_popup*(button: pointer): pointer
proc gtk_scale_button_get_active*(button: pointer): pointer
proc gtk_scale_button_get_has_frame*(button: pointer): pointer
proc gtk_scale_get_has_origin*(scale: pointer): pointer
proc gtk_scale_get_layout*(scale: pointer): pointer
proc gtk_scale_clear_marks*(scale: pointer): pointer
proc gtk_scrollable_get_hscroll_policy*(scrollable: pointer): pointer
proc gtk_scrollable_get_vscroll_policy*(scrollable: pointer): pointer
proc gtk_scrolled_window_get_hadjustment*(scrolled_window: pointer): pointer
proc gtk_scrolled_window_get_vadjustment*(scrolled_window: pointer): pointer
proc gtk_scrolled_window_get_hscrollbar*(scrolled_window: pointer): pointer
proc gtk_scrolled_window_get_vscrollbar*(scrolled_window: pointer): pointer
proc gtk_scrolled_window_unset_placement*(scrolled_window: pointer): pointer
proc gtk_scrolled_window_get_placement*(scrolled_window: pointer): pointer
proc gtk_scrolled_window_get_min_content_width*(scrolled_window: pointer): pointer
proc gtk_scrolled_window_get_min_content_height*(scrolled_window: pointer): pointer
proc gtk_scrolled_window_get_kinetic_scrolling*(scrolled_window: pointer): pointer
proc gtk_scrolled_window_get_overlay_scrolling*(scrolled_window: pointer): pointer
proc gtk_scrolled_window_get_max_content_width*(scrolled_window: pointer): pointer
proc gtk_scrolled_window_get_max_content_height*(scrolled_window: pointer): pointer
proc gtk_scrolled_window_get_propagate_natural_width*(scrolled_window: pointer): pointer
proc gtk_scrolled_window_get_propagate_natural_height*(scrolled_window: pointer): pointer
proc gtk_scroll_info_new*(): pointer
proc gtk_scroll_info_ref*(self: pointer): pointer
proc gtk_scroll_info_unref*(self: pointer): pointer
proc gtk_scroll_info_get_enable_horizontal*(self: pointer): pointer
proc gtk_scroll_info_get_enable_vertical*(self: pointer): pointer
proc gtk_search_bar_get_key_capture_widget*(bar: pointer): pointer
proc gtk_search_engine_model_get_type*(): GType {.importc: "_gtk_search_engine_model_get_type".}
proc gtk_search_engine_get_type*(): GType {.importc: "_gtk_search_engine_get_type".}
proc gtk_search_engine_new*(): pointer {.importc: "_gtk_search_engine_new".}
proc gtk_search_engine_start*(engine: pointer) {.importc: "_gtk_search_engine_start".}
proc gtk_search_engine_stop*(engine: pointer) {.importc: "_gtk_search_engine_stop".}
proc gtk_search_hit_free*(hit: pointer) {.importc: "_gtk_search_hit_free".}
proc gtk_search_engine_quartz_get_type*(): GType {.importc: "_gtk_search_engine_quartz_get_type".}
proc gtk_search_engine_tracker3_new*(): pointer
proc gtk_search_entry_get_key_controller*(entry: pointer): pointer
proc gtk_selection_filter_model_new*(model: pointer): pointer
proc gtk_selection_filter_model_get_model*(self: pointer): pointer
proc gtk_settings_get_font_options*(settings: pointer): pointer
proc gtk_settings_get_enable_animations*(settings: pointer): gboolean
proc gtk_settings_get_dnd_drag_threshold*(settings: pointer): pointer
proc gtk_settings_get_font_size*(settings: pointer): pointer
proc gtk_settings_get_font_size_is_absolute*(settings: pointer): gboolean
proc gtk_shortcut_action_to_string*(self: pointer): pointer
proc gtk_nothing_action_get*(): pointer
proc gtk_mnemonic_action_get*(): pointer
proc gtk_activate_action_get*(): pointer
proc gtk_signal_action_new*(signal_name: cstring): pointer
proc gtk_signal_action_get_signal_name*(self: pointer): pointer
proc gtk_named_action_new*(name: cstring): pointer
proc gtk_named_action_get_action_name*(self: pointer): pointer
proc gtk_shortcut_controller_root*(controller: pointer)
proc gtk_shortcut_controller_unroot*(controller: pointer)
proc gtk_shortcut_controller_update_accels*(self: pointer)
proc gtk_shortcut_manager_create_controllers*(widget: GtkWidget): pointer
proc gtk_shortcut_trigger_to_string*(self: pointer): pointer
proc gtk_shortcut_trigger_hash*(trigger: gconstpointer): pointer
proc gtk_never_trigger_get*(): pointer
proc gtk_keyval_trigger_get_modifiers*(self: pointer): pointer
proc gtk_keyval_trigger_get_keyval*(self: pointer): pointer
proc gtk_mnemonic_trigger_new*(keyval: guint): pointer
proc gtk_mnemonic_trigger_get_keyval*(self: pointer): pointer
proc gtk_alternative_trigger_get_first*(self: pointer): pointer
proc gtk_alternative_trigger_get_second*(self: pointer): pointer
proc gtk_sidebar_row_reveal*(self: pointer)
proc gtk_size_request_cache_init*(cache: pointer) {.importc: "_gtk_size_request_cache_init".}
proc gtk_size_request_cache_free*(cache: pointer) {.importc: "_gtk_size_request_cache_free".}
proc gtk_size_request_cache_clear*(cache: pointer) {.importc: "_gtk_size_request_cache_clear".}
proc gtk_slice_list_model_get_model*(self: pointer): pointer
proc gtk_slice_list_model_get_offset*(self: pointer): pointer
proc gtk_slice_list_model_get_size*(self: pointer): pointer
proc gtk_snapshot_push_copy*(snapshot: pointer): pointer
proc gtk_snapshot_gl_shader_pop_texture*(snapshot: pointer)
proc gtk_snapshot_push_collect*(snapshot: pointer)
proc gtk_snapshot_pop_collect*(snapshot: pointer): pointer
proc gtk_sorter_get_order*(self: pointer): pointer
proc gtk_sorter_get_keys*(self: pointer): pointer
proc gtk_sort_keys_ref*(self: pointer): pointer
proc gtk_sort_keys_unref*(self: pointer)
proc gtk_sort_keys_new_equal*(): pointer
proc gtk_sort_keys_get_key_size*(self: pointer): gsize
proc gtk_sort_keys_get_key_align*(self: pointer): gsize
proc gtk_sort_keys_get_key_compare_func*(self: pointer): pointer
proc gtk_sort_keys_needs_clear_key*(self: pointer): gboolean
proc gtk_sort_list_model_get_section_sorter*(self: pointer): pointer
proc gtk_spin_button_get_activates_default*(spin_button: pointer): pointer
proc gtk_spin_button_get_update_policy*(spin_button: pointer): pointer
proc gtk_spin_button_get_numeric*(spin_button: pointer): pointer
proc gtk_spin_button_get_wrap*(spin_button: pointer): pointer
proc gtk_spin_button_get_snap_to_ticks*(spin_button: pointer): pointer
proc gtk_spin_button_get_climb_rate*(spin_button: pointer): pointer
proc gtk_spin_button_update*(spin_button: pointer): pointer
proc gtk_spinner_get_spinning*(spinner: pointer): pointer
proc gtk_stack_page_get_child*(self: pointer): pointer
proc gtk_stack_page_get_visible*(self: pointer): pointer
proc gtk_stack_page_get_needs_attention*(self: pointer): pointer
proc gtk_stack_page_get_use_underline*(self: pointer): pointer
proc gtk_stack_page_get_name*(self: pointer): pointer
proc gtk_stack_page_get_title*(self: pointer): pointer
proc gtk_stack_page_get_icon_name*(self: pointer): pointer
proc gtk_stack_get_hhomogeneous*(stack: pointer): pointer
proc gtk_stack_get_vhomogeneous*(stack: pointer): pointer
proc gtk_stack_get_transition_running*(stack: pointer): pointer
proc gtk_stack_get_interpolate_size*(stack: pointer): pointer
proc gtk_stack_get_pages*(stack: pointer): pointer
proc gtk_stack_sidebar_new*(): pointer
proc gtk_stack_sidebar_get_stack*(self: pointer): pointer
proc gtk_statusbar_get_message*(statusbar: pointer): pointer
proc gtk_string_pair_get_id*(pair: pointer): cstring
proc gtk_string_pair_get_string*(pair: pointer): cstring
proc gtk_string_sorter_get_collation*(self: pointer): pointer
proc gtk_style_animation_is_finished*(animation: pointer): gboolean {.importc: "_gtk_style_animation_is_finished".}
proc gtk_style_animation_is_static*(animation: pointer): gboolean {.importc: "_gtk_style_animation_is_static".}
proc gtk_style_animation_ref*(animation: pointer): pointer
proc gtk_style_animation_unref*(animation: pointer): pointer
proc gtk_style_cascade_new*(): pointer {.importc: "_gtk_style_cascade_new".}
proc gtk_style_cascade_get_scale*(cascade: pointer): pointer {.importc: "_gtk_style_cascade_get_scale".}
proc gtk_style_property_init_properties*() {.importc: "_gtk_style_property_init_properties".}
proc gtk_style_property_lookup*(name: cstring): pointer {.importc: "_gtk_style_property_lookup".}
proc gtk_style_property_get_name*(property: pointer): cstring {.importc: "_gtk_style_property_get_name".}
proc gtk_style_provider_get_settings*(provider: pointer): pointer
proc gtk_style_provider_get_scale*(provider: pointer): pointer
proc gtk_style_provider_changed*(provider: pointer)
proc gtk_svg_new*(): pointer
proc gtk_svg_new_from_bytes*(bytes: pointer): pointer
proc gtk_svg_new_from_resource*(path: cstring): pointer
proc gtk_svg_serialize*(self: pointer): pointer
proc gtk_svg_get_weight*(self: pointer): pointer
proc gtk_svg_get_state*(self: pointer): pointer
proc gtk_svg_get_n_states*(self: pointer): pointer
proc gtk_svg_play*(self: pointer): pointer
proc gtk_svg_pause*(self: pointer): pointer
proc gtk_svg_get_features*(self: pointer): pointer
proc gtk_svg_error_quark*(): pointer
proc gtk_svg_error_get_element*(error: pointer): pointer
proc gtk_svg_error_get_attribute*(error: pointer): pointer
proc gtk_svg_error_get_start*(error: pointer): pointer
proc gtk_svg_error_get_end*(error: pointer): pointer

{.pop.}

# ============================================================================
# SVG API
# ============================================================================

{.push importc, cdecl.}
proc svg_value_ref*(value: pointer): pointer
proc svg_value_unref*(value: pointer)
proc svg_value_to_string*(self: pointer): cstring
proc svg_number_new*(value: pointer): pointer
proc svg_linecap_new*(value: pointer): pointer
proc svg_linejoin_new*(value: pointer): pointer
proc svg_fill_rule_new*(rule: pointer): pointer
proc svg_paint_order_new*(order: pointer): pointer
proc svg_paint_new_none*(): pointer
proc svg_paint_new_symbolic*(symbolic: pointer): pointer
proc svg_paint_new_rgba*(rgba: pointer): pointer
proc svg_view_box_new*(box: pointer): pointer
proc svg_path_new*(path: pointer): pointer
proc svg_clip_new_none*(): pointer
proc svg_clip_new_path*(string: cstring): pointer
proc svg_transform_parse*(value: cstring): pointer
proc svg_transform_get_n_transforms*(value: pointer): pointer
proc svg_transform_new_none*(): pointer
proc svg_transform_new_skew_x*(angle: pointer): pointer
proc svg_transform_new_skew_y*(angle: pointer): pointer
proc svg_transform_new_matrix*(params6: pointer): pointer
proc svg_filter_parse*(value: cstring): pointer
proc svg_shape_delete*(shape: pointer)

{.pop.}

# ============================================================================
# GTK API
# ============================================================================

{.push importc, cdecl.}
proc gtk_svg_copy*(orig: pointer): pointer
proc gtk_svg_clear_content*(self: pointer)
proc gtk_svg_get_overflow*(self: pointer): pointer
proc gtk_svg_get_run_mode*(self: pointer): pointer
proc gtk_svg_get_next_update*(self: pointer): pointer
proc gtk_test_register_all_types*(): pointer
proc gtk_test_list_all_types*(n_types: guint): pointer
proc gtk_test_widget_wait_for_draw*(widget: GtkWidget): pointer
proc gtk_text_attributes_new*(): pointer
proc gtk_text_attributes_copy*(src: pointer): pointer
proc gtk_text_attributes_unref*(values: pointer)
proc gtk_text_btree_ref*(tree: pointer) {.importc: "_gtk_text_btree_ref".}
proc gtk_text_btree_unref*(tree: pointer) {.importc: "_gtk_text_btree_unref".}
proc gtk_text_btree_get_chars_changed_stamp*(tree: pointer): guint {.importc: "_gtk_text_btree_get_chars_changed_stamp".}
proc gtk_text_btree_get_segments_changed_stamp*(tree: pointer): guint {.importc: "_gtk_text_btree_get_segments_changed_stamp".}
proc gtk_text_btree_segments_changed*(tree: pointer) {.importc: "_gtk_text_btree_segments_changed".}
proc gtk_text_btree_unregister_child_anchor*(anchor: pointer) {.importc: "_gtk_text_btree_unregister_child_anchor".}
proc gtk_text_btree_get_end_iter_line*(tree: pointer): pointer {.importc: "_gtk_text_btree_get_end_iter_line".}
proc gtk_text_btree_get_tags*(iter: pointer): pointer {.importc: "_gtk_text_btree_get_tags".}
proc gtk_text_btree_line_count*(tree: pointer): pointer {.importc: "_gtk_text_btree_line_count".}
proc gtk_text_btree_char_count*(tree: pointer): pointer {.importc: "_gtk_text_btree_char_count".}
proc gtk_text_btree_char_is_invisible*(iter: pointer): gboolean {.importc: "_gtk_text_btree_char_is_invisible".}
proc gtk_text_line_get_number*(line: pointer): pointer {.importc: "_gtk_text_line_get_number".}
proc gtk_text_line_next*(line: pointer): pointer {.importc: "_gtk_text_line_next".}
proc gtk_text_line_next_excluding_last*(line: pointer): pointer {.importc: "_gtk_text_line_next_excluding_last".}
proc gtk_text_line_previous*(line: pointer): pointer {.importc: "_gtk_text_line_previous".}
proc gtk_text_line_char_count*(line: pointer): pointer {.importc: "_gtk_text_line_char_count".}
proc gtk_text_line_byte_count*(line: pointer): pointer {.importc: "_gtk_text_line_byte_count".}
proc gtk_text_line_char_index*(line: pointer): pointer {.importc: "_gtk_text_line_char_index".}
proc gtk_text_btree_check*(tree: pointer) {.importc: "_gtk_text_btree_check".}
proc gtk_text_btree_spew*(tree: pointer) {.importc: "_gtk_text_btree_spew".}
proc gtk_text_buffer_get_selection_content*(buffer: pointer): pointer
proc gtk_text_buffer_spew*(buffer: pointer): pointer {.importc: "_gtk_text_buffer_spew".}
proc gtk_text_buffer_get_btree*(buffer: pointer): pointer {.importc: "_gtk_text_buffer_get_btree".}
proc gtk_text_child_anchor_get_deleted*(anchor: pointer): pointer
proc gtk_widget_segment_ref*(widget_segment: pointer) {.importc: "_gtk_widget_segment_ref".}
proc gtk_widget_segment_unref*(widget_segment: pointer) {.importc: "_gtk_widget_segment_unref".}
proc gtk_anchored_child_get_layout*(child: GtkWidget): pointer {.importc: "_gtk_anchored_child_get_layout".}
proc gtk_text_child_anchor_get_replacement*(anchor: pointer): cstring
proc gtk_text_encoding_get_names*(): pointer
proc gtk_text_encoding_get_labels*(): pointer
proc gtk_text_encoding_from_name*(name: cstring): cstring
proc gtk_line_ending_get_names*(): pointer
proc gtk_line_ending_get_labels*(): pointer
proc gtk_line_ending_from_name*(name: cstring): cstring
proc gtk_text_new*(): pointer
proc gtk_text_new_with_buffer*(buffer: pointer): pointer
proc gtk_text_get_visibility*(self: pointer): pointer
proc gtk_text_get_invisible_char*(self: pointer): pointer
proc gtk_text_unset_invisible_char*(self: pointer): pointer
proc gtk_text_get_overwrite_mode*(self: pointer): pointer
proc gtk_text_get_max_length*(self: pointer): pointer
proc gtk_text_get_text_length*(self: pointer): pointer
proc gtk_text_get_activates_default*(self: pointer): pointer
proc gtk_text_get_placeholder_text*(self: pointer): pointer
proc gtk_text_get_input_purpose*(self: pointer): pointer
proc gtk_text_get_input_hints*(self: pointer): pointer
proc gtk_text_get_attributes*(self: pointer): pointer
proc gtk_text_get_tabs*(self: pointer): pointer
proc gtk_text_grab_focus_without_selecting*(self: pointer): pointer
proc gtk_text_get_extra_menu*(self: pointer): pointer
proc gtk_text_get_enable_emoji_completion*(self: pointer): pointer
proc gtk_text_get_propagate_text_width*(self: pointer): pointer
proc gtk_text_get_truncate_multiline*(self: pointer): pointer
proc gtk_text_handle_new*(parent: GtkWidget): pointer
proc gtk_text_handle_present*(handle: pointer)
proc gtk_text_handle_get_role*(handle: pointer): pointer
proc gtk_text_handle_get_is_dragged*(handle: pointer): gboolean
proc gtk_text_history_begin_user_action*(self: pointer)
proc gtk_text_history_end_user_action*(self: pointer)
proc gtk_text_history_begin_irreversible_action*(self: pointer)
proc gtk_text_history_end_irreversible_action*(self: pointer)
proc gtk_text_history_get_can_undo*(self: pointer): gboolean
proc gtk_text_history_get_can_redo*(self: pointer): gboolean
proc gtk_text_history_undo*(self: pointer)
proc gtk_text_history_redo*(self: pointer)
proc gtk_text_history_get_max_undo_levels*(self: pointer): guint
proc gtk_text_history_get_enabled*(self: pointer): gboolean
proc gtk_text_iter_free*(iter: pointer): pointer
proc gtk_text_iter_get_child_anchor*(iter: pointer): pointer
proc gtk_text_iter_get_language*(iter: pointer): pointer
proc gtk_text_iter_forward_visible_line*(iter: pointer): pointer
proc gtk_text_iter_backward_visible_line*(iter: pointer): pointer
proc gtk_text_iter_get_text_line*(iter: pointer): pointer {.importc: "_gtk_text_iter_get_text_line".}
proc gtk_text_iter_get_btree*(iter: pointer): pointer {.importc: "_gtk_text_iter_get_btree".}
proc gtk_text_iter_forward_indexable_segment*(iter: pointer): gboolean {.importc: "_gtk_text_iter_forward_indexable_segment".}
proc gtk_text_iter_backward_indexable_segment*(iter: pointer): gboolean {.importc: "_gtk_text_iter_backward_indexable_segment".}
proc gtk_text_iter_get_segment_byte*(iter: pointer): pointer {.importc: "_gtk_text_iter_get_segment_byte".}
proc gtk_text_iter_get_segment_char*(iter: pointer): pointer {.importc: "_gtk_text_iter_get_segment_char".}
proc gtk_text_iter_check*(iter: pointer) {.importc: "_gtk_text_iter_check".}
proc gtk_text_layout_new*(): pointer
proc gtk_text_layout_default_style_changed*(layout: pointer)
proc gtk_text_layout_get_cursor_visible*(layout: pointer): gboolean
proc gtk_text_layout_wrap_loop_start*(layout: pointer)
proc gtk_text_layout_wrap_loop_end*(layout: pointer)
proc gtk_text_line_display_unref*(display: pointer)
proc gtk_text_layout_invalidate_selection*(layout: pointer)
proc gtk_text_layout_is_valid*(layout: pointer): gboolean
proc gtk_text_layout_spew*(layout: pointer)
proc gtk_text_line_display_cache_free*(cache: pointer)
proc gtk_text_line_display_cache_delay_eviction*(cache: pointer)
proc gtk_text_line_display_cache_invalidate*(cache: pointer)
proc gtk_text_get_layout*(entry: pointer): pointer
proc gtk_text_reset_im_context*(entry: pointer)
proc gtk_toggle_segment_free*(seg: pointer) {.importc: "_gtk_toggle_segment_free".}
proc gtk_text_tag_array_sort*(tags: pointer) {.importc: "_gtk_text_tag_array_sort".}
proc gtk_text_tag_affects_size*(tag: pointer): gboolean {.importc: "_gtk_text_tag_affects_size".}
proc gtk_text_tag_affects_nonsize_appearance*(tag: pointer): gboolean {.importc: "_gtk_text_tag_affects_nonsize_appearance".}
proc gtk_text_tag_table_affects_visibility*(table: pointer): gboolean {.importc: "_gtk_text_tag_table_affects_visibility".}
proc gtk_text_byte_begins_utf8_char*(byte: cstring): pointer
proc gtk_text_view_child_get_window_type*(self: pointer): pointer
proc gtk_text_view_reset_cursor_blink*(text_view: pointer): pointer
proc gtk_text_view_get_text_node*(text_view: pointer): pointer
proc gtk_text_view_get_selection_node*(text_view: pointer): pointer
proc gtk_text_view_get_default_attributes*(text_view: pointer): pointer
proc gtk_text_view_get_layout*(text_view: pointer): pointer
proc gtk_tim_sort_finish*(self: pointer)
proc gtk_tim_sort_get_progress*(self: pointer): gsize
proc gtk_tooltip_get_type*(): pointer
proc gtk_tooltip_hide*(widget: GtkWidget) {.importc: "_gtk_tooltip_hide".}
proc gtk_tooltip_trigger_tooltip_query*(widget: GtkWidget)
proc gtk_tooltip_maybe_allocate*(native: pointer)
proc gtk_tooltip_unset_surface*(native: pointer)
proc gtk_tooltip_window_new*(): ptr GtkWidget
proc gtk_tooltip_window_present*(window: pointer)
proc gtk_trash_monitor_get_type*(): GType {.importc: "_gtk_trash_monitor_get_type".}
proc gtk_trash_monitor_get_has_trash*(monitor: pointer): gboolean {.importc: "_gtk_trash_monitor_get_has_trash".}
proc gtk_tree_expander_new*(): pointer
proc gtk_tree_expander_get_child*(self: pointer): pointer
proc gtk_tree_expander_get_item*(self: pointer): pointer
proc gtk_tree_expander_get_list_row*(self: pointer): pointer
proc gtk_tree_expander_get_indent_for_depth*(self: pointer): pointer
proc gtk_tree_expander_get_indent_for_icon*(self: pointer): pointer
proc gtk_tree_expander_get_hide_expander*(self: pointer): pointer
proc gtk_tree_list_model_get_model*(self: pointer): pointer
proc gtk_tree_list_model_get_passthrough*(self: pointer): pointer
proc gtk_tree_list_model_get_autoexpand*(self: pointer): pointer
proc gtk_tree_list_row_get_item*(self: pointer): pointer
proc gtk_tree_list_row_get_expanded*(self: pointer): pointer
proc gtk_tree_list_row_is_expandable*(self: pointer): pointer
proc gtk_tree_list_row_get_position*(self: pointer): pointer
proc gtk_tree_list_row_get_depth*(self: pointer): pointer
proc gtk_tree_list_row_get_children*(self: pointer): pointer
proc gtk_tree_list_row_get_parent*(self: pointer): pointer
proc gtk_tree_list_row_sorter_new*(sorter: pointer): pointer
proc gtk_tree_list_row_sorter_get_sorter*(self: pointer): pointer
proc gtk_uri_launcher_new*(uri: cstring): pointer
proc gtk_uri_launcher_get_uri*(self: pointer): pointer
proc gtk_video_get_graphics_offload*(self: pointer): pointer
proc gtk_widget_unparent*(widget: GtkWidget): pointer
proc gtk_widget_map*(widget: GtkWidget): pointer
proc gtk_widget_unmap*(widget: GtkWidget): pointer
proc gtk_widget_realize*(widget: GtkWidget): pointer
proc gtk_widget_unrealize*(widget: GtkWidget): pointer
proc gtk_widget_queue_draw*(widget: GtkWidget): pointer
proc gtk_widget_queue_resize*(widget: GtkWidget): pointer
proc gtk_widget_queue_allocate*(widget: GtkWidget): pointer
proc gtk_widget_get_frame_clock*(widget: GtkWidget): pointer
proc gtk_widget_get_request_mode*(widget: GtkWidget): pointer
proc gtk_widget_get_layout_manager*(widget: GtkWidget): pointer
proc gtk_widget_class_get_layout_manager_type*(widget_class: pointer): pointer
proc gtk_widget_class_get_activate_signal*(widget_class: pointer): pointer
proc gtk_widget_activate*(widget: GtkWidget): pointer
proc gtk_widget_get_focusable*(widget: GtkWidget): pointer
proc gtk_widget_has_focus*(widget: GtkWidget): pointer
proc gtk_widget_is_focus*(widget: GtkWidget): pointer
proc gtk_widget_has_visible_focus*(widget: GtkWidget): pointer
proc gtk_widget_get_focus_on_click*(widget: GtkWidget): pointer
proc gtk_widget_get_can_target*(widget: GtkWidget): pointer
proc gtk_widget_has_default*(widget: GtkWidget): pointer
proc gtk_widget_get_receives_default*(widget: GtkWidget): pointer
proc gtk_widget_get_state_flags*(widget: GtkWidget): pointer
proc gtk_widget_is_sensitive*(widget: GtkWidget): pointer
proc gtk_widget_is_visible*(widget: GtkWidget): pointer
proc gtk_widget_is_drawable*(widget: GtkWidget): pointer
proc gtk_widget_get_realized*(widget: GtkWidget): pointer
proc gtk_widget_get_mapped*(widget: GtkWidget): pointer
proc gtk_widget_get_root*(widget: GtkWidget): pointer
proc gtk_widget_get_native*(widget: GtkWidget): pointer
proc gtk_widget_get_child_visible*(widget: GtkWidget): pointer
proc gtk_widget_get_allocated_width*(widget: GtkWidget): pointer
proc gtk_widget_get_allocated_height*(widget: GtkWidget): pointer
proc gtk_widget_get_allocated_baseline*(widget: GtkWidget): pointer
proc gtk_widget_get_width*(widget: GtkWidget): pointer
proc gtk_widget_get_height*(widget: GtkWidget): pointer
proc gtk_widget_get_baseline*(widget: GtkWidget): pointer
proc gtk_widget_error_bell*(widget: GtkWidget): pointer
proc gtk_widget_get_opacity*(widget: GtkWidget): pointer
proc gtk_widget_get_overflow*(widget: GtkWidget): pointer
proc gtk_widget_get_scale_factor*(widget: GtkWidget): pointer
proc gtk_widget_get_settings*(widget: GtkWidget): pointer
proc gtk_widget_get_hexpand_set*(widget: GtkWidget): pointer
proc gtk_widget_get_vexpand_set*(widget: GtkWidget): pointer
proc gtk_widget_get_direction*(widget: GtkWidget): pointer
proc gtk_widget_set_default_direction*(dir: pointer): pointer
proc gtk_widget_get_default_direction*(): pointer
proc gtk_widget_get_cursor*(widget: GtkWidget): pointer
proc gtk_widget_list_mnemonic_labels*(widget: GtkWidget): pointer
proc gtk_widget_trigger_tooltip_query*(widget: GtkWidget): pointer
proc gtk_widget_get_has_tooltip*(widget: GtkWidget): pointer
proc gtk_requisition_free*(requisition: pointer): pointer
proc gtk_widget_in_destruction*(widget: GtkWidget): pointer
proc gtk_widget_class_get_css_name*(widget_class: pointer): pointer
proc gtk_widget_init_template*(widget: GtkWidget): pointer
proc gtk_widget_activate_default*(widget: GtkWidget): pointer
proc gtk_widget_get_font_map*(widget: GtkWidget): pointer
proc gtk_widget_observe_children*(widget: GtkWidget): pointer
proc gtk_widget_observe_controllers*(widget: GtkWidget): pointer
proc gtk_widget_get_focus_child*(widget: GtkWidget): pointer
proc gtk_widget_should_layout*(widget: GtkWidget): pointer
proc gtk_widget_get_css_classes*(widget: GtkWidget): pointer
proc gtk_widget_class_get_accessible_role*(widget_class: pointer): pointer
proc gtk_widget_get_limit_events*(widget: GtkWidget): pointer
proc gtk_widget_paintable_new*(widget: GtkWidget): pointer
proc gtk_widget_paintable_get_widget*(self: pointer): pointer
proc gtk_widget_paintable_update_image*(self: pointer)
proc gtk_widget_paintable_push_snapshot_count*(self: pointer)
proc gtk_widget_paintable_pop_snapshot_count*(self: pointer)
proc gtk_widget_root*(widget: GtkWidget)
proc gtk_widget_unroot*(widget: GtkWidget)
proc gtk_widget_get_css_node*(widget: GtkWidget): pointer
proc gtk_widget_get_alloc_needed*(widget: GtkWidget): gboolean {.importc: "_gtk_widget_get_alloc_needed".}
proc gtk_widget_needs_allocate*(widget: GtkWidget): gboolean
proc gtk_widget_clear_resize_queued*(widget: GtkWidget)
proc gtk_widget_ensure_allocate*(widget: GtkWidget)
proc gtk_widget_scale_changed*(widget: GtkWidget) {.importc: "_gtk_widget_scale_changed".}
proc gtk_widget_monitor_changed*(widget: GtkWidget)
proc gtk_widget_get_surface*(widget: GtkWidget): pointer
proc gtk_widget_has_grab*(widget: GtkWidget): gboolean
proc gtk_widget_peek_style_context*(widget: GtkWidget): pointer {.importc: "_gtk_widget_peek_style_context".}
proc gtk_widget_update_parent_muxer*(widget: GtkWidget) {.importc: "_gtk_widget_update_parent_muxer".}
proc gtk_widget_has_tick_callback*(widget: GtkWidget): gboolean
proc gtk_widget_has_size_request*(widget: GtkWidget): gboolean
proc gtk_widget_reset_controllers*(widget: GtkWidget)
proc gtk_widget_can_activate*(widget: GtkWidget): gboolean
proc gtk_widget_grab_focus_child*(widget: GtkWidget): gboolean
proc gtk_widget_grab_focus_self*(widget: GtkWidget): gboolean
proc gtk_widget_realize_at_context*(widget: GtkWidget)
proc gtk_widget_unrealize_at_context*(widget: GtkWidget)
proc gtk_root_get_display*(): pointer
proc gtk_window_controls_get_use_native_controls*(self: pointer): pointer
proc gtk_window_get_destroy_with_parent*(window: pointer): pointer
proc gtk_window_get_hide_on_close*(window: pointer): pointer
proc gtk_window_get_mnemonics_visible*(window: pointer): pointer
proc gtk_window_get_focus_visible*(window: pointer): pointer
proc gtk_window_is_active*(window: pointer): pointer
proc gtk_window_get_icon_name*(window: pointer): pointer
proc gtk_window_get_default_icon_name*(): pointer
proc gtk_window_set_auto_startup_notification*(setting: gboolean): pointer
proc gtk_window_list_toplevels*(): pointer
proc gtk_window_has_group*(window: pointer): pointer
proc gtk_window_is_maximized*(window: pointer): pointer
proc gtk_window_is_suspended*(window: pointer): pointer
proc gtk_window_set_interactive_debugging*(enable: gboolean): pointer
proc gtk_window_get_handle_menubar_accel*(window: pointer): pointer
proc gtk_window_get_gravity*(window: pointer): pointer
proc gtk_window_emit_close_request*(window: pointer): gboolean
proc gtk_window_schedule_mnemonics_visible*(window: pointer) {.importc: "_gtk_window_schedule_mnemonics_visible".}
proc gtk_window_notify_keys_changed*(window: pointer) {.importc: "_gtk_window_notify_keys_changed".}
proc gtk_window_toggle_maximized*(window: pointer) {.importc: "_gtk_window_toggle_maximized".}
proc gtk_highlight_overlay_new*(widget: GtkWidget): pointer
proc gtk_highlight_overlay_get_widget*(self: pointer): ptr GtkWidget
proc gtk_inspector_init*(): pointer
proc gtk_inspector_register_extension*()
proc gtk_inspector_overlay_queue_draw*(self: pointer)

{.pop.}

# ============================================================================
# GET API
# ============================================================================

{.push importc, cdecl.}
proc get_language_name*(language: pointer): pointer
proc get_language_name_for_tag*(tag: pointer): cstring

{.pop.}

# ============================================================================
# GTK API
# ============================================================================

{.push importc, cdecl.}
proc gtk_layout_overlay_new*(): pointer
proc gtk_inspector_logs_get_type*(): pointer
proc gtk_inspector_magnifier_get_type*(): pointer
proc gtk_inspector_measure_graph_new*(): pointer
proc gtk_inspector_measure_graph_clear*(self: pointer)
proc gtk_inspector_measure_graph_get_texture*(self: pointer): pointer
proc gtk_inspector_menu_get_type*(): pointer
proc gtk_inspector_misc_info_get_type*(): pointer
proc gtk_inspector_node_wrapper_get_node*(self: pointer): pointer
proc gtk_inspector_node_wrapper_get_draw_node*(self: pointer): pointer
proc gtk_inspector_node_wrapper_get_profile_node*(self: pointer): pointer
proc gtk_inspector_node_wrapper_get_profile*(self: pointer): pointer
proc gtk_inspector_node_wrapper_get_role*(self: pointer): cstring
proc gtk_inspector_node_wrapper_create_children_model*(self: pointer): pointer

{.pop.}


# ============================================================================
# GTK API
# ============================================================================

{.push importc, cdecl.}
proc gtk_inspector_object_tree_get_type*(): pointer
proc gtk_inspector_get_object_title*(`object`: GObject): cstring
proc gtk_inspector_prop_editor_should_expand*(editor: pointer): gboolean
proc gtk_inspector_prop_list_get_type*(): pointer
proc gtk_inspector_recorder_get_type*(): pointer
proc gtk_inspector_recorder_is_recording*(recorder: pointer): gboolean
proc gtk_inspector_recording_get_type*(): pointer
proc gtk_inspector_recording_get_timestamp*(recording: pointer): gint64
proc gtk_inspector_render_recording_get_type*(): GType
proc gtk_inspector_render_recording_get_node*(recording: pointer): pointer
proc gtk_inspector_render_recording_get_profile_node*(recording: pointer): pointer
proc gtk_inspector_render_recording_get_clip_region*(recording: pointer): pointer
proc gtk_inspector_render_recording_get_area*(recording: pointer): pointer
proc gtk_inspector_render_recording_get_surface*(recording: pointer): gpointer

{.pop.}

# ============================================================================
# RESOURCE API
# ============================================================================

{.push importc, cdecl.}
proc resource_holder_get_count*(holder: pointer): pointer
proc resource_holder_get_size*(holder: pointer): gsize

{.pop.}

# ============================================================================
# GTK API
# ============================================================================

{.push importc, cdecl.}
proc gtk_inspector_resource_list_get_type*(): pointer

{.pop.}



# ============================================================================
# BITSET API
# ============================================================================

{.push importc, cdecl.}
proc bitset_free*(bitset: pointer): pointer
proc bitset_clear*(bitset: pointer): pointer
proc bitset_fill*(bitset: pointer): pointer
proc bitset_resize*(bitset: pointer, newarraysize: pointer, padwithzeroes: pointer): pointer
proc bitset_grow*(bitset: pointer, newarraysize: pointer): pointer
proc bitset_trim*(bitset: pointer): pointer
proc bitset_shift_left*(bitset: pointer, s: pointer): pointer
proc bitset_shift_right*(bitset: pointer, s: pointer): pointer
proc bitset_count*(bitset: pointer): pointer
proc bitset_empty*(bitset: pointer): pointer
proc bitset_minimum*(bitset: pointer): pointer
proc bitset_maximum*(bitset: pointer): pointer

{.pop.}

# ============================================================================
# ROARING API
# ============================================================================

{.push importc, cdecl.}
proc roaring_bitmap_create_with_capacity*(): pointer
proc roaring_bitmap_init_with_capacity*(r: pointer, cap: pointer): pointer
proc roaring_bitmap_printf_describe*(r: pointer): pointer
proc roaring_bitmap_printf*(r: pointer): pointer
proc roaring_bitmap_free*(r: pointer): pointer
proc roaring_bitmap_add*(r: pointer, x: pointer): pointer
proc roaring_bitmap_add_checked*(r: pointer, x: pointer): pointer
proc roaring_bitmap_remove*(r: pointer, x: pointer): pointer
proc roaring_bitmap_remove_checked*(r: pointer, x: pointer): pointer
proc roaring_bitmap_contains*(r: pointer, val: pointer): pointer
proc roaring_bitmap_get_cardinality*(r: pointer): pointer
proc roaring_bitmap_is_empty*(r: pointer): pointer
proc roaring_bitmap_clear*(r: pointer): pointer
proc roaring_bitmap_to_uint32_array*(r: pointer, ans: pointer): pointer
proc roaring_bitmap_to_bitset*(r: pointer, bitset: pointer): pointer
proc roaring_bitmap_remove_run_compression*(r: pointer): pointer
proc roaring_bitmap_run_optimize*(r: pointer): pointer
proc roaring_bitmap_shrink_to_fit*(r: pointer): pointer
proc roaring_bitmap_serialize*(r: pointer, buf: cstring): pointer
proc roaring_bitmap_size_in_bytes*(r: pointer): pointer
proc roaring_bitmap_portable_size_in_bytes*(r: pointer): pointer
proc roaring_bitmap_portable_serialize*(r: pointer, buf: cstring): pointer
proc roaring_bitmap_frozen_size_in_bytes*(r: pointer): pointer
proc roaring_bitmap_frozen_serialize*(r: pointer, buf: cstring): pointer
proc roaring_bitmap_repair_after_lazy*(r1: pointer): pointer
proc roaring_bitmap_rank*(r: pointer, x: pointer): pointer
proc roaring_bitmap_get_index*(r: pointer, x: pointer): pointer
proc roaring_bitmap_minimum*(r: pointer): pointer
proc roaring_bitmap_maximum*(r: pointer): pointer
proc roaring_iterator_create*(): pointer
proc roaring_uint32_iterator_advance*(it: pointer): pointer
proc roaring_uint32_iterator_advance*(): pointer
proc roaring_uint32_iterator_previous*(it: pointer): pointer
proc roaring_uint32_iterator_previous*(): pointer
proc roaring_uint32_iterator_move_equalorlarger*(): pointer
proc roaring_uint32_iterator_copy*(): pointer
proc roaring_uint32_iterator_free*(it: pointer): pointer
proc roaring_uint32_iterator_read*(): pointer
proc roaring_init_memory_hook*(memory_hook: pointer): pointer
proc roaring_malloc*(): pointer
proc roaring_realloc*(): pointer
proc roaring_calloc*(): pointer
proc roaring_free*(): pointer
proc roaring_aligned_malloc*(): pointer
proc roaring_aligned_free*(): pointer

{.pop.}

# ============================================================================
# ROARING64 API
# ============================================================================

{.push importc, cdecl.}
proc roaring64_bitmap_free*(r: pointer): pointer
proc roaring64_bitmap_add*(r: pointer, val: pointer): pointer
proc roaring64_bitmap_add_checked*(r: pointer, val: pointer): pointer
proc roaring64_bitmap_remove*(r: pointer, val: pointer): pointer
proc roaring64_bitmap_remove_checked*(r: pointer, val: pointer): pointer
proc roaring64_bitmap_clear*(r: pointer): pointer
proc roaring64_bitmap_contains*(r: pointer, val: pointer): pointer
proc roaring64_bitmap_rank*(r: pointer, val: pointer): pointer
proc roaring64_bitmap_get_cardinality*(r: pointer): pointer
proc roaring64_bitmap_is_empty*(r: pointer): pointer
proc roaring64_bitmap_minimum*(r: pointer): pointer
proc roaring64_bitmap_maximum*(r: pointer): pointer
proc roaring64_bitmap_run_optimize*(r: pointer): pointer
proc roaring64_bitmap_shrink_to_fit*(r: pointer): pointer
proc roaring64_bitmap_portable_size_in_bytes*(r: pointer): pointer
proc roaring64_bitmap_frozen_size_in_bytes*(r: pointer): pointer
proc roaring64_iterator_free*(it: pointer): pointer
proc roaring64_iterator_has_value*(it: pointer): pointer
proc roaring64_iterator_value*(it: pointer): pointer
proc roaring64_iterator_advance*(it: pointer): pointer
proc roaring64_iterator_previous*(it: pointer): pointer

{.pop.}

# ============================================================================
# GTK API
# ============================================================================

{.push importc, cdecl.}
proc gtk_inspector_size_groups_get_type*(): pointer
proc gtk_inspector_start_recording_get_type*(): GType
proc gtk_inspector_start_recording_new*(): pointer
proc gtk_inspector_statistics_get_type*(): pointer
proc gtk_inspector_strv_editor_get_type*(): pointer
proc gtk_subsurface_overlay_new*(): pointer
proc gtk_updates_overlay_new*(): pointer
proc gtk_inspector_variant_editor_get_type*(): GType
proc gtk_inspector_variant_editor_get_value*(editor: GtkWidget): pointer
proc gtk_inspector_visual_get_type*(): pointer
proc gtk_inspector_window_get_type*(): pointer
proc gtk_inspector_window_select_widget_under_pointer*(iw: pointer)
proc gtk_inspector_window_get_inspected_display*(iw: pointer): pointer
proc gtk_inspector_window_pop_object*(iw: pointer)
proc gtk_inspector_is_recording*(widget: GtkWidget): gboolean
proc gtk_inspector_handle_event*(event: pointer): gboolean

{.pop.}
# ----------------------------------------------------------------------------
# Работа с настройками приложения
# ----------------------------------------------------------------------------

proc getDefaultSettings*(): GtkSettings =
  ## Получение настроек по умолчанию
  result = gtk_settings_get_default()

proc isDarkTheme*(): bool =
  ## Проверка, используется ли темная тема
  # Это упрощенная проверка через GtkSettings
  let settings = getDefaultSettings()
  # В реальном коде нужно проверить свойство prefer-dark-theme
  result = false # Заглушка



# ----------------------------------------------------------------------------
# Утилиты для работы с памятью
# ----------------------------------------------------------------------------

proc safeUnref*[T](obj: var T) =
  ## Безопасное уменьшение счетчика ссылок
  if obj != nil:
    g_object_unref(obj)
    obj = nil

proc safeRef*[T](obj: T): T =
  ## Увеличение счетчика ссылок
  if obj != nil:
    result = cast[T](g_object_ref(obj))
  else:
    result = nil


