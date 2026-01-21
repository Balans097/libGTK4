
################################################################
##             ПОЛНАЯ ОБЁРТКА GTK4 для Nim
##      Full-featured wrapper for the GTK4 library
## 
##          Прямые привязки к C API через FFI
## 
## 
## Версия:   1.0
## Дата:     2026-01-20
## Автор:    Balans097 — vasil.minsk@yahoo.com
################################################################


# 1.0 — начальная реализация библиотеки (2026-01-20)




{.passL: "-lgtk-4".}
{.passC: gorge("pkg-config --cflags gtk4").}
{.passL: gorge("pkg-config --libs gtk4").}


import sequtils


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

  # Cairo
  cairo_t* = pointer
  cairo_surface_t* = pointer

  # Pixbuf
  GdkPixbuf* = pointer
  GdkTexture* = pointer

  # Clipboard
  GdkClipboard* = pointer

  # Events
  GdkEvent* = pointer
  GdkEventType* = pointer

  # Стили и CSS
  GtkStyleContext* = pointer
  GtkCssProvider* = pointer

  # Прочие GObject типы
  GObject* = pointer
  GType* = uint
  GValue* = pointer
  GVariant* = pointer
  GVariantType* = pointer
  GError* = pointer

  # Callback типы
  GCallback* = pointer
  GDestroyNotify* = pointer
  GClosureNotify* = pointer

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

  GtkPolicyType* {.size: sizeof(cint).} = enum
    GTK_POLICY_ALWAYS = 0
    GTK_POLICY_AUTOMATIC = 1
    GTK_POLICY_NEVER = 2
    GTK_POLICY_EXTERNAL = 3

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
  G_APPLICATION_IS_SERVICE* = 1 shl 0
  G_APPLICATION_IS_LAUNCHER* = 1 shl 1
  G_APPLICATION_HANDLES_OPEN* = 1 shl 2
  G_APPLICATION_HANDLES_COMMAND_LINE* = 1 shl 3
  G_APPLICATION_SEND_ENVIRONMENT* = 1 shl 4
  G_APPLICATION_NON_UNIQUE* = 1 shl 5

  GTK_WINDOW_TOPLEVEL* = 0
  GTK_WINDOW_POPUP* = 1

  FALSE* = 0
  TRUE* = 1

  GTK_STYLE_PROVIDER_PRIORITY_FALLBACK* = 1
  GTK_STYLE_PROVIDER_PRIORITY_THEME* = 200
  GTK_STYLE_PROVIDER_PRIORITY_SETTINGS* = 400
  GTK_STYLE_PROVIDER_PRIORITY_APPLICATION* = 600
  GTK_STYLE_PROVIDER_PRIORITY_USER* = 800


# ============================================================================
# GTK INITIALIZATION
# ============================================================================
proc gtk_init*() {.importc.}
proc gtk_init_check*(): gboolean {.importc.}


# ============================================================================
# GTK APPLICATION
# ============================================================================
proc gtk_application_new*(applicationId: cstring, flags: gint): GtkApplication {.importc.}
proc gtk_application_window_new*(application: GtkApplication): GtkWindow {.importc.}
proc gtk_application_add_window*(application: GtkApplication, window: GtkWindow) {.importc.}
proc gtk_application_remove_window*(application: GtkApplication, window: GtkWindow) {.importc.}
proc gtk_application_get_windows*(application: GtkApplication): pointer {.importc.}
proc gtk_application_get_active_window*(application: GtkApplication): GtkWindow {.importc.}


# ============================================================================
# G APPLICATION
# ============================================================================
proc g_application_run*(application: GApplication, argc: gint, argv: pointer): gint {.importc.}
proc g_application_quit*(application: GApplication) {.importc.}
proc g_application_hold*(application: GApplication) {.importc.}
proc g_application_release*(application: GApplication) {.importc.}


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
proc gtk_box_set_baseline_position*(box: GtkBox, position: GtkPositionType) {.importc.}
proc gtk_box_get_baseline_position*(box: GtkBox): GtkPositionType {.importc.}

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

# ============================================================================
# BUTTON
# ============================================================================

proc gtk_button_new*(): GtkButton {.importc.}
proc gtk_button_new_with_label*(label: cstring): GtkButton {.importc.}
proc gtk_button_new_with_mnemonic*(label: cstring): GtkButton {.importc.}
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

# ============================================================================
# TOGGLE BUTTON
# ============================================================================

proc gtk_toggle_button_new*(): GtkToggleButton {.importc.}
proc gtk_toggle_button_new_with_label*(label: cstring): GtkToggleButton {.importc.}
proc gtk_toggle_button_new_with_mnemonic*(label: cstring): GtkToggleButton {.importc.}
proc gtk_toggle_button_set_active*(toggleButton: GtkToggleButton, isActive: gboolean) {.importc.}
proc gtk_toggle_button_get_active*(toggleButton: GtkToggleButton): gboolean {.importc.}
proc gtk_toggle_button_toggled*(toggleButton: GtkToggleButton) {.importc.}

# ============================================================================
# CHECK BUTTON
# ============================================================================

proc gtk_check_button_new*(): GtkCheckButton {.importc.}
proc gtk_check_button_new_with_label*(label: cstring): GtkCheckButton {.importc.}
proc gtk_check_button_new_with_mnemonic*(label: cstring): GtkCheckButton {.importc.}
proc gtk_check_button_set_active*(checkButton: GtkCheckButton, setting: gboolean) {.importc.}
proc gtk_check_button_get_active*(checkButton: GtkCheckButton): gboolean {.importc.}
proc gtk_check_button_set_inconsistent*(checkButton: GtkCheckButton, inconsistent: gboolean) {.importc.}
proc gtk_check_button_get_inconsistent*(checkButton: GtkCheckButton): gboolean {.importc.}

# ============================================================================
# SWITCH
# ============================================================================

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
proc gtk_label_set_wrap_mode*(label: GtkLabel, wrapMode: GtkWrapMode) {.importc.}
proc gtk_label_get_wrap_mode*(label: GtkLabel): GtkWrapMode {.importc.}
proc gtk_label_set_selectable*(label: GtkLabel, setting: gboolean) {.importc.}
proc gtk_label_get_selectable*(label: GtkLabel): gboolean {.importc.}
proc gtk_label_set_width_chars*(label: GtkLabel, nChars: gint) {.importc.}
proc gtk_label_get_width_chars*(label: GtkLabel): gint {.importc.}
proc gtk_label_set_max_width_chars*(label: GtkLabel, nChars: gint) {.importc.}
proc gtk_label_get_max_width_chars*(label: GtkLabel): gint {.importc.}
proc gtk_label_set_ellipsize*(label: GtkLabel, mode: gint) {.importc.}
proc gtk_label_get_ellipsize*(label: GtkLabel): gint {.importc.}

# ============================================================================
# ENTRY
# ============================================================================

proc gtk_entry_new*(): GtkEntry {.importc.}
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

# ============================================================================
# PASSWORD ENTRY
# ============================================================================

proc gtk_password_entry_new*(): GtkPasswordEntry {.importc.}
proc gtk_password_entry_set_show_peek_icon*(entry: GtkPasswordEntry, showPeekIcon: gboolean) {.importc.}
proc gtk_password_entry_get_show_peek_icon*(entry: GtkPasswordEntry): gboolean {.importc.}

# ============================================================================
# SEARCH ENTRY
# ============================================================================

proc gtk_search_entry_new*(): GtkSearchEntry {.importc.}

# ============================================================================
# TEXT VIEW
# ============================================================================

proc gtk_text_view_new*(): GtkTextView {.importc.}
proc gtk_text_view_new_with_buffer*(buffer: GtkTextBuffer): GtkTextView {.importc.}
proc gtk_text_view_get_buffer*(textView: GtkTextView): GtkTextBuffer {.importc.}
proc gtk_text_view_set_buffer*(textView: GtkTextView, buffer: GtkTextBuffer) {.importc.}
proc gtk_text_view_set_editable*(textView: GtkTextView, setting: gboolean) {.importc.}
proc gtk_text_view_get_editable*(textView: GtkTextView): gboolean {.importc.}
proc gtk_text_view_set_wrap_mode*(textView: GtkTextView, wrapMode: GtkWrapMode) {.importc.}
proc gtk_text_view_get_wrap_mode*(textView: GtkTextView): GtkWrapMode {.importc.}
proc gtk_text_view_set_cursor_visible*(textView: GtkTextView, setting: gboolean) {.importc.}
proc gtk_text_view_get_cursor_visible*(textView: GtkTextView): gboolean {.importc.}
proc gtk_text_view_set_monospace*(textView: GtkTextView, monospace: gboolean) {.importc.}
proc gtk_text_view_get_monospace*(textView: GtkTextView): gboolean {.importc.}

# ============================================================================
# TEXT BUFFER
# ============================================================================

proc gtk_text_buffer_new*(table: GtkTextTagTable): GtkTextBuffer {.importc.}
proc gtk_text_buffer_set_text*(buffer: GtkTextBuffer, text: cstring, len: gint) {.importc.}
proc gtk_text_buffer_get_text*(buffer: GtkTextBuffer, start: ptr GtkTextIter, `end`: ptr GtkTextIter, includeHiddenChars: gboolean): cstring {.importc.}
proc gtk_text_buffer_insert*(buffer: GtkTextBuffer, iter: ptr GtkTextIter, text: cstring, len: gint) {.importc.}
proc gtk_text_buffer_insert_at_cursor*(buffer: GtkTextBuffer, text: cstring, len: gint) {.importc.}
proc gtk_text_buffer_delete*(buffer: GtkTextBuffer, start: ptr GtkTextIter, `end`: ptr GtkTextIter) {.importc.}
proc gtk_text_buffer_get_char_count*(buffer: GtkTextBuffer): gint {.importc.}
proc gtk_text_buffer_get_line_count*(buffer: GtkTextBuffer): gint {.importc.}
proc gtk_text_buffer_get_start_iter*(buffer: GtkTextBuffer, iter: ptr GtkTextIter) {.importc.}
proc gtk_text_buffer_get_end_iter*(buffer: GtkTextBuffer, iter: ptr GtkTextIter) {.importc.}
proc gtk_text_buffer_get_iter_at_line*(buffer: GtkTextBuffer, iter: ptr GtkTextIter, lineNumber: gint) {.importc.}
proc gtk_text_buffer_get_iter_at_offset*(buffer: GtkTextBuffer, iter: ptr GtkTextIter, charOffset: gint) {.importc.}

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
proc gtk_image_set_pixel_size*(image: GtkImage, pixelSize: gint) {.importc.}
proc gtk_image_get_pixel_size*(image: GtkImage): gint {.importc.}

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
# STYLE CONTEXT
# ============================================================================

proc gtk_widget_get_style_context*(widget: GtkWidget): GtkStyleContext {.importc.}
proc gtk_style_context_add_provider*(context: GtkStyleContext, provider: pointer, priority: guint) {.importc.}
proc gtk_style_context_add_provider_for_display*(display: pointer, provider: pointer, priority: guint) {.importc.}

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

# ============================================================================
# POPOVER
# ============================================================================

proc gtk_popover_new*(): GtkPopover {.importc.}
proc gtk_popover_set_child*(popover: GtkPopover, child: GtkWidget) {.importc.}
proc gtk_popover_get_child*(popover: GtkPopover): GtkWidget {.importc.}
proc gtk_popover_popup*(popover: GtkPopover) {.importc.}
proc gtk_popover_popdown*(popover: GtkPopover) {.importc.}
proc gtk_popover_set_parent*(popover: GtkPopover, parent: GtkWidget) {.importc.}

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
# ============================================================================

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
# ============================================================================

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
proc gdk_clipboard_read_text_async*(clipboard: GdkClipboard, cancellable: pointer, callback: pointer, userData: gpointer) {.importc.}

# ============================================================================
# PIXBUF
# ============================================================================

proc gdk_pixbuf_new*(colorspace: gint, hasAlpha: gboolean, bitsPerSample: gint, width: gint, height: gint): GdkPixbuf {.importc.}
proc gdk_pixbuf_new_from_file*(filename: cstring, error: ptr GError): GdkPixbuf {.importc.}
proc gdk_pixbuf_get_width*(pixbuf: GdkPixbuf): gint {.importc.}
proc gdk_pixbuf_get_height*(pixbuf: GdkPixbuf): gint {.importc.}
proc gdk_pixbuf_scale_simple*(src: GdkPixbuf, destWidth: gint, destHeight: gint, interpType: gint): GdkPixbuf {.importc.}
proc gdk_pixbuf_savev*(pixbuf: GdkPixbuf, filename: cstring, `type`: cstring, optionKeys: ptr cstring, optionValues: ptr cstring, error: ptr GError): gboolean {.importc.}

# ============================================================================
# TEXTURE
# ============================================================================

proc gdk_texture_new_for_pixbuf*(pixbuf: GdkPixbuf): GdkTexture {.importc.}
proc gdk_texture_new_from_file*(file: GFile, error: ptr GError): GdkTexture {.importc.}
proc gdk_texture_get_width*(texture: GdkTexture): gint {.importc.}
proc gdk_texture_get_height*(texture: GdkTexture): gint {.importc.}

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

proc g_timeout_add*(interval: guint, function: pointer, data: gpointer): guint {.importc.}
proc g_timeout_add_seconds*(interval: guint, function: pointer, data: gpointer): guint {.importc.}
proc g_idle_add*(function: pointer, data: gpointer): guint {.importc.}
proc g_source_remove*(tag: guint): gboolean {.importc.}

# ============================================================================
# MAIN LOOP
# ============================================================================

proc g_main_loop_new*(context: pointer, isRunning: gboolean): pointer {.importc.}
proc g_main_loop_run*(loop: pointer) {.importc.}
proc g_main_loop_quit*(loop: pointer) {.importc.}

# ============================================================================
# TREE MODEL & STORE
# ============================================================================

proc gtk_list_store_new*(nColumns: gint): GtkListStore {.importc, varargs.}
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
# ============================================================================

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
# ============================================================================

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
# ============================================================================

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

proc gtk_text_buffer_add_mark*(buffer: GtkTextBuffer, mark: GtkTextMark, where: ptr GtkTextIter) {.importc.}
proc gtk_text_buffer_create_mark*(buffer: GtkTextBuffer, markName: cstring, where: ptr GtkTextIter, leftGravity: gboolean): GtkTextMark {.importc.}
proc gtk_text_buffer_move_mark*(buffer: GtkTextBuffer, mark: GtkTextMark, where: ptr GtkTextIter) {.importc.}
proc gtk_text_buffer_delete_mark*(buffer: GtkTextBuffer, mark: GtkTextMark) {.importc.}
proc gtk_text_buffer_get_mark*(buffer: GtkTextBuffer, name: cstring): GtkTextMark {.importc.}
proc gtk_text_buffer_get_insert*(buffer: GtkTextBuffer): GtkTextMark {.importc.}
proc gtk_text_buffer_get_selection_bound*(buffer: GtkTextBuffer): GtkTextMark {.importc.}
proc gtk_text_buffer_place_cursor*(buffer: GtkTextBuffer, where: ptr GtkTextIter) {.importc.}
proc gtk_text_buffer_select_range*(buffer: GtkTextBuffer, ins: ptr GtkTextIter, bound: ptr GtkTextIter) {.importc.}

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

proc gtk_text_buffer_get_modified*(buffer: GtkTextBuffer): gboolean {.importc.}
proc gtk_text_buffer_set_modified*(buffer: GtkTextBuffer, setting: gboolean) {.importc.}
proc gtk_text_buffer_delete_selection*(buffer: GtkTextBuffer, interactive: gboolean, defaultEditable: gboolean): gboolean {.importc.}
proc gtk_text_buffer_paste_clipboard*(buffer: GtkTextBuffer, clipboard: GdkClipboard, overrideLocation: ptr GtkTextIter, defaultEditable: gboolean) {.importc.}
proc gtk_text_buffer_copy_clipboard*(buffer: GtkTextBuffer, clipboard: GdkClipboard) {.importc.}
proc gtk_text_buffer_cut_clipboard*(buffer: GtkTextBuffer, clipboard: GdkClipboard, defaultEditable: gboolean) {.importc.}
proc gtk_text_buffer_get_selection_bounds*(buffer: GtkTextBuffer, start: ptr GtkTextIter, `end`: ptr GtkTextIter): gboolean {.importc.}
proc gtk_text_buffer_begin_user_action*(buffer: GtkTextBuffer) {.importc.}
proc gtk_text_buffer_end_user_action*(buffer: GtkTextBuffer) {.importc.}
proc gtk_text_buffer_add_selection_clipboard*(buffer: GtkTextBuffer, clipboard: GdkClipboard) {.importc.}
proc gtk_text_buffer_remove_selection_clipboard*(buffer: GtkTextBuffer, clipboard: GdkClipboard) {.importc.}
proc gtk_text_buffer_insert_range*(buffer: GtkTextBuffer, iter: ptr GtkTextIter, start: ptr GtkTextIter, `end`: ptr GtkTextIter) {.importc.}
proc gtk_text_buffer_insert_range_interactive*(buffer: GtkTextBuffer, iter: ptr GtkTextIter, start: ptr GtkTextIter, `end`: ptr GtkTextIter, defaultEditable: gboolean): gboolean {.importc.}
proc gtk_text_buffer_insert_with_tags*(buffer: GtkTextBuffer, iter: ptr GtkTextIter, text: cstring, len: gint, firstTag: GtkTextTag) {.importc, varargs.}
proc gtk_text_buffer_insert_with_tags_by_name*(buffer: GtkTextBuffer, iter: ptr GtkTextIter, text: cstring, len: gint, firstTagName: cstring) {.importc, varargs.}
proc gtk_text_buffer_create_tag*(buffer: GtkTextBuffer, tagName: cstring, firstPropertyName: cstring): GtkTextTag {.importc, varargs.}
proc gtk_text_buffer_apply_tag*(buffer: GtkTextBuffer, tag: GtkTextTag, start: ptr GtkTextIter, `end`: ptr GtkTextIter) {.importc.}
proc gtk_text_buffer_remove_tag*(buffer: GtkTextBuffer, tag: GtkTextTag, start: ptr GtkTextIter, `end`: ptr GtkTextIter) {.importc.}
proc gtk_text_buffer_apply_tag_by_name*(buffer: GtkTextBuffer, name: cstring, start: ptr GtkTextIter, `end`: ptr GtkTextIter) {.importc.}
proc gtk_text_buffer_remove_tag_by_name*(buffer: GtkTextBuffer, name: cstring, start: ptr GtkTextIter, `end`: ptr GtkTextIter) {.importc.}
proc gtk_text_buffer_remove_all_tags*(buffer: GtkTextBuffer, start: ptr GtkTextIter, `end`: ptr GtkTextIter) {.importc.}
proc gtk_text_buffer_get_tag_table*(buffer: GtkTextBuffer): GtkTextTagTable {.importc.}
proc gtk_text_buffer_get_bounds*(buffer: GtkTextBuffer, start: ptr GtkTextIter, `end`: ptr GtkTextIter) {.importc.}

# ============================================================================
# TEXT VIEW (дополнительные функции)
# ============================================================================

proc gtk_text_view_scroll_to_iter*(textView: GtkTextView, iter: ptr GtkTextIter, withinMargin: gdouble, useAlign: gboolean, xalign: gdouble, yalign: gdouble): gboolean {.importc.}
proc gtk_text_view_scroll_to_mark*(textView: GtkTextView, mark: GtkTextMark, withinMargin: gdouble, useAlign: gboolean, xalign: gdouble, yalign: gdouble) {.importc.}
proc gtk_text_view_scroll_mark_onscreen*(textView: GtkTextView, mark: GtkTextMark) {.importc.}
proc gtk_text_view_move_mark_onscreen*(textView: GtkTextView, mark: GtkTextMark): gboolean {.importc.}
proc gtk_text_view_place_cursor_onscreen*(textView: GtkTextView): gboolean {.importc.}
proc gtk_text_view_get_visible_rect*(textView: GtkTextView, visibleRect: pointer) {.importc.}
proc gtk_text_view_get_iter_location*(textView: GtkTextView, iter: ptr GtkTextIter, location: pointer) {.importc.}
proc gtk_text_view_get_cursor_locations*(textView: GtkTextView, iter: ptr GtkTextIter, strong: pointer, weak: pointer) {.importc.}
proc gtk_text_view_get_line_at_y*(textView: GtkTextView, targetIter: ptr GtkTextIter, y: gint, lineTop: ptr gint) {.importc.}
proc gtk_text_view_get_line_yrange*(textView: GtkTextView, iter: ptr GtkTextIter, y: ptr gint, height: ptr gint) {.importc.}
proc gtk_text_view_get_iter_at_location*(textView: GtkTextView, iter: ptr GtkTextIter, x: gint, y: gint): gboolean {.importc.}
proc gtk_text_view_get_iter_at_position*(textView: GtkTextView, iter: ptr GtkTextIter, trailing: ptr gint, x: gint, y: gint): gboolean {.importc.}
proc gtk_text_view_buffer_to_window_coords*(textView: GtkTextView, win: gint, bufferX: gint, bufferY: gint, windowX: ptr gint, windowY: ptr gint) {.importc.}
proc gtk_text_view_window_to_buffer_coords*(textView: GtkTextView, win: gint, windowX: gint, windowY: gint, bufferX: ptr gint, bufferY: ptr gint) {.importc.}
proc gtk_text_view_forward_display_line*(textView: GtkTextView, iter: ptr GtkTextIter): gboolean {.importc.}
proc gtk_text_view_backward_display_line*(textView: GtkTextView, iter: ptr GtkTextIter): gboolean {.importc.}
proc gtk_text_view_forward_display_line_end*(textView: GtkTextView, iter: ptr GtkTextIter): gboolean {.importc.}
proc gtk_text_view_backward_display_line_start*(textView: GtkTextView, iter: ptr GtkTextIter): gboolean {.importc.}
proc gtk_text_view_starts_display_line*(textView: GtkTextView, iter: ptr GtkTextIter): gboolean {.importc.}
proc gtk_text_view_move_visually*(textView: GtkTextView, iter: ptr GtkTextIter, count: gint): gboolean {.importc.}
proc gtk_text_view_im_context_filter_keypress*(textView: GtkTextView, event: GdkEvent): gboolean {.importc.}
proc gtk_text_view_reset_im_context*(textView: GtkTextView) {.importc.}
proc gtk_text_view_get_gutter*(textView: GtkTextView, win: gint): GtkWidget {.importc.}
proc gtk_text_view_set_gutter*(textView: GtkTextView, win: gint, widget: GtkWidget) {.importc.}
proc gtk_text_view_set_left_margin*(textView: GtkTextView, leftMargin: gint) {.importc.}
proc gtk_text_view_get_left_margin*(textView: GtkTextView): gint {.importc.}
proc gtk_text_view_set_right_margin*(textView: GtkTextView, rightMargin: gint) {.importc.}
proc gtk_text_view_get_right_margin*(textView: GtkTextView): gint {.importc.}
proc gtk_text_view_set_top_margin*(textView: GtkTextView, topMargin: gint) {.importc.}
proc gtk_text_view_get_top_margin*(textView: GtkTextView): gint {.importc.}
proc gtk_text_view_set_bottom_margin*(textView: GtkTextView, bottomMargin: gint) {.importc.}
proc gtk_text_view_get_bottom_margin*(textView: GtkTextView): gint {.importc.}
proc gtk_text_view_set_indent*(textView: GtkTextView, indent: gint) {.importc.}
proc gtk_text_view_get_indent*(textView: GtkTextView): gint {.importc.}
proc gtk_text_view_set_tabs*(textView: GtkTextView, tabs: pointer) {.importc.}
proc gtk_text_view_get_tabs*(textView: GtkTextView): pointer {.importc.}
proc gtk_text_view_set_accepts_tab*(textView: GtkTextView, acceptsTab: gboolean) {.importc.}
proc gtk_text_view_get_accepts_tab*(textView: GtkTextView): gboolean {.importc.}
proc gtk_text_view_set_pixels_above_lines*(textView: GtkTextView, pixelsAboveLines: gint) {.importc.}
proc gtk_text_view_get_pixels_above_lines*(textView: GtkTextView): gint {.importc.}
proc gtk_text_view_set_pixels_below_lines*(textView: GtkTextView, pixelsBelowLines: gint) {.importc.}
proc gtk_text_view_get_pixels_below_lines*(textView: GtkTextView): gint {.importc.}
proc gtk_text_view_set_pixels_inside_wrap*(textView: GtkTextView, pixelsInsideWrap: gint) {.importc.}
proc gtk_text_view_get_pixels_inside_wrap*(textView: GtkTextView): gint {.importc.}
proc gtk_text_view_set_justification*(textView: GtkTextView, justification: GtkJustification) {.importc.}
proc gtk_text_view_get_justification*(textView: GtkTextView): GtkJustification {.importc.}
proc gtk_text_view_set_overwrite*(textView: GtkTextView, overwrite: gboolean) {.importc.}
proc gtk_text_view_get_overwrite*(textView: GtkTextView): gboolean {.importc.}
proc gtk_text_view_set_input_purpose*(textView: GtkTextView, purpose: GtkInputPurpose) {.importc.}
proc gtk_text_view_get_input_purpose*(textView: GtkTextView): GtkInputPurpose {.importc.}
proc gtk_text_view_set_extra_menu*(textView: GtkTextView, model: GMenuModel) {.importc.}
proc gtk_text_view_get_extra_menu*(textView: GtkTextView): GMenuModel {.importc.}

# ============================================================================
# ENTRY (дополнительные функции)
# ============================================================================

proc gtk_entry_get_buffer*(entry: GtkEntry): pointer {.importc.}
proc gtk_entry_set_buffer*(entry: GtkEntry, buffer: pointer) {.importc.}
proc gtk_entry_get_text_length*(entry: GtkEntry): guint16 {.importc.}
proc gtk_entry_set_icon_from_icon_name*(entry: GtkEntry, iconPos: gint, iconName: cstring) {.importc.}
proc gtk_entry_set_icon_from_pixbuf*(entry: GtkEntry, iconPos: gint, pixbuf: GdkPixbuf) {.importc.}
proc gtk_entry_set_icon_from_paintable*(entry: GtkEntry, iconPos: gint, paintable: pointer) {.importc.}
proc gtk_entry_get_icon_storage_type*(entry: GtkEntry, iconPos: gint): gint {.importc.}
proc gtk_entry_get_icon_name*(entry: GtkEntry, iconPos: gint): cstring {.importc.}
proc gtk_entry_get_icon_pixbuf*(entry: GtkEntry, iconPos: gint): GdkPixbuf {.importc.}
proc gtk_entry_get_icon_paintable*(entry: GtkEntry, iconPos: gint): pointer {.importc.}
proc gtk_entry_set_icon_activatable*(entry: GtkEntry, iconPos: gint, activatable: gboolean) {.importc.}
proc gtk_entry_get_icon_activatable*(entry: GtkEntry, iconPos: gint): gboolean {.importc.}
proc gtk_entry_set_icon_sensitive*(entry: GtkEntry, iconPos: gint, sensitive: gboolean) {.importc.}
proc gtk_entry_get_icon_sensitive*(entry: GtkEntry, iconPos: gint): gboolean {.importc.}
proc gtk_entry_get_icon_at_pos*(entry: GtkEntry, x: gint, y: gint): gint {.importc.}
proc gtk_entry_set_icon_tooltip_text*(entry: GtkEntry, iconPos: gint, tooltip: cstring) {.importc.}
proc gtk_entry_get_icon_tooltip_text*(entry: GtkEntry, iconPos: gint): cstring {.importc.}
proc gtk_entry_set_icon_tooltip_markup*(entry: GtkEntry, iconPos: gint, tooltip: cstring) {.importc.}
proc gtk_entry_get_icon_tooltip_markup*(entry: GtkEntry, iconPos: gint): cstring {.importc.}
proc gtk_entry_set_input_purpose*(entry: GtkEntry, purpose: GtkInputPurpose) {.importc.}
proc gtk_entry_get_input_purpose*(entry: GtkEntry): GtkInputPurpose {.importc.}
proc gtk_entry_set_completion*(entry: GtkEntry, completion: pointer) {.importc.}
proc gtk_entry_get_completion*(entry: GtkEntry): pointer {.importc.}
proc gtk_entry_set_progress_fraction*(entry: GtkEntry, fraction: gdouble) {.importc.}
proc gtk_entry_get_progress_fraction*(entry: GtkEntry): gdouble {.importc.}
proc gtk_entry_set_progress_pulse_step*(entry: GtkEntry, fraction: gdouble) {.importc.}
proc gtk_entry_get_progress_pulse_step*(entry: GtkEntry): gdouble {.importc.}
proc gtk_entry_progress_pulse*(entry: GtkEntry) {.importc.}
proc gtk_entry_reset_im_context*(entry: GtkEntry) {.importc.}
proc gtk_entry_set_attributes*(entry: GtkEntry, attrs: pointer) {.importc.}
proc gtk_entry_get_attributes*(entry: GtkEntry): pointer {.importc.}
proc gtk_entry_set_tabs*(entry: GtkEntry, tabs: pointer) {.importc.}
proc gtk_entry_get_tabs*(entry: GtkEntry): pointer {.importc.}
proc gtk_entry_grab_focus_without_selecting*(entry: GtkEntry): gboolean {.importc.}


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
proc gtk_is_initialized*(): gboolean {.importc.}
proc gtk_disable_setlocale*() {.importc.}
proc gtk_get_default_language*(): pointer {.importc.}
proc gtk_get_locale_direction*(): gint {.importc.}


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
proc gtk_inscription_get_markup*(self: GtkInscription): cstring {.importc.}
proc gtk_inscription_set_markup*(self: GtkInscription, markup: cstring) {.importc.}
proc gtk_inscription_get_attributes*(self: GtkInscription): pointer {.importc.}
proc gtk_inscription_set_attributes*(self: GtkInscription, attrs: pointer) {.importc.}
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
proc gtk_inscription_get_wrap_mode*(self: GtkInscription): GtkWrapMode {.importc.}
proc gtk_inscription_set_wrap_mode*(self: GtkInscription, wrapMode: GtkWrapMode) {.importc.}


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
type
  GtkEntryBuffer* = pointer
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

type
  TimeoutProc* = proc(): bool {.cdecl.}

proc addTimeout*(interval: int, callback: TimeoutProc, data: pointer = nil): guint =
  ## Добавление таймера (интервал в миллисекундах)
  result = g_timeout_add(interval.guint, cast[pointer](callback), data)

proc addTimeoutSeconds*(interval: int, callback: TimeoutProc, data: pointer = nil): guint =
  ## Добавление таймера (интервал в секундах)
  result = g_timeout_add_seconds(interval.guint, cast[pointer](callback), data)

proc removeTimeout*(timeoutId: guint): bool =
  ## Удаление таймера
  result = g_source_remove(timeoutId) != 0

proc addIdle*(callback: TimeoutProc, data: pointer = nil): guint =
  ## Добавление idle callback (вызывается когда система не занята)
  result = g_idle_add(cast[pointer](callback), data)

# ----------------------------------------------------------------------------
# Работа с буфером обмена
# ----------------------------------------------------------------------------

proc setClipboardText*(text: string) =
  ## Копирование текста в буфер обмена
  let display = gdk_display_get_default()
  let clipboard = gdk_display_get_clipboard(display)
  gdk_clipboard_set_text(clipboard, text.cstring)

# Callback для получения текста из буфера
type ClipboardTextCallback* = proc(text: cstring, userData: pointer) {.cdecl.}

proc getClipboardText*(callback: ClipboardTextCallback, userData: pointer = nil) =
  ## Получение текста из буфера обмена (асинхронно)
  let display = gdk_display_get_default()
  let clipboard = gdk_display_get_clipboard(display)
  gdk_clipboard_read_text_async(clipboard, nil, cast[pointer](callback), userData)

# ----------------------------------------------------------------------------
# Утилиты для TreeView (совместимость с GTK3)
# ----------------------------------------------------------------------------

proc createListStore*(columnTypes: varargs[GType]): GtkListStore =
  ## Создание ListStore
  result = gtk_list_store_new(columnTypes.len.gint, columnTypes[0].unsafeAddr)

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
# Экспортируемые макросы для упрощения кода
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


