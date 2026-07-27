# GTK4 (window chrome & dialogs: HeaderBar / MessageDialog / Dialog / FileChooser) — module reference

> **Import:** `import libGTK4`
> **Scope:** custom window header bar and three kinds of dialogs — message dialog, arbitrary dialog with buttons, file chooser dialog. Eighth part of the wrapper reference series; assumes familiarity with previous parts, especially `gtk4_core_reference_ru.md` (window, `gtk_window_set_titlebar`) and `gtk4_basic_controls_reference_ru.md` (buttons).

`GtkHeaderBar` is the widget that, in the previous reference, replaced the window's standard header bar via `gtk_window_set_titlebar`; here it is covered in detail. The three remaining widgets are dialogs of varying complexity: `GtkMessageDialog` — a ready-made "text + set of standard buttons" dialog for simple messages, `GtkDialog` — a builder for an arbitrary dialog with its own content and buttons, `GtkFileChooserDialog` — a specialized system dialog for choosing a file/folder.

---

## Table of Contents

I. [GtkHeaderBar](#gtkheaderbar)
&nbsp;&nbsp;1. [`gtk_header_bar_new`](#gtk_header_bar_new)
&nbsp;&nbsp;2. [`gtk_header_bar_pack_start` / `gtk_header_bar_pack_end` / `gtk_header_bar_remove`](#gtk_header_bar_pack_start--gtk_header_bar_pack_end--gtk_header_bar_remove)
&nbsp;&nbsp;3. [`gtk_header_bar_set_title_widget` / `gtk_header_bar_get_title_widget`](#gtk_header_bar_set_title_widget--gtk_header_bar_get_title_widget)
&nbsp;&nbsp;4. [`gtk_header_bar_set_show_title_buttons` / `gtk_header_bar_get_show_title_buttons`](#gtk_header_bar_set_show_title_buttons--gtk_header_bar_get_show_title_buttons)
&nbsp;&nbsp;5. [`gtk_header_bar_set_decoration_layout` / `gtk_header_bar_get_decoration_layout`](#gtk_header_bar_set_decoration_layout--gtk_header_bar_get_decoration_layout)

II. [GtkMessageDialog](#gtkmessagedialog)
&nbsp;&nbsp;1. [`gtk_message_dialog_new`](#gtk_message_dialog_new)
&nbsp;&nbsp;2. [`gtk_message_dialog_set_markup`](#gtk_message_dialog_set_markup)

III. [GtkDialog](#gtkdialog)
&nbsp;&nbsp;1. [`gtk_dialog_new`](#gtk_dialog_new)
&nbsp;&nbsp;2. [`gtk_dialog_add_button` / `gtk_dialog_add_action_widget`](#gtk_dialog_add_button--gtk_dialog_add_action_widget)
&nbsp;&nbsp;3. [`gtk_dialog_set_default_response`](#gtk_dialog_set_default_response)
&nbsp;&nbsp;4. [`gtk_dialog_get_content_area` / `gtk_dialog_get_header_bar`](#gtk_dialog_get_content_area--gtk_dialog_get_header_bar)
&nbsp;&nbsp;5. [`gtk_dialog_response`](#gtk_dialog_response)

IV. [GtkFileChooserDialog](#gtkfilechooserdialog)
&nbsp;&nbsp;1. [`gtk_file_chooser_dialog_new`](#gtk_file_chooser_dialog_new)
&nbsp;&nbsp;2. [`gtk_file_chooser_set_current_name`](#gtk_file_chooser_set_current_name)
&nbsp;&nbsp;3. [`gtk_file_chooser_get_file` / `gtk_file_chooser_set_file`](#gtk_file_chooser_get_file--gtk_file_chooser_set_file)
&nbsp;&nbsp;4. [`gtk_file_chooser_set_current_folder` / `gtk_file_chooser_get_current_folder`](#gtk_file_chooser_set_current_folder--gtk_file_chooser_get_current_folder)

V. [Practical recipes](#practical-recipes)
&nbsp;&nbsp;1. [Header bar with action buttons at the edges](#header-bar-with-action-buttons-at-the-edges)
&nbsp;&nbsp;2. [Delete-confirmation dialog](#delete-confirmation-dialog)
&nbsp;&nbsp;3. [Custom settings dialog with Cancel/Apply buttons](#custom-settings-dialog-with-cancelapply-buttons)
&nbsp;&nbsp;4. [Save-file dialog with a default name](#save-file-dialog-with-a-default-name)
&nbsp;&nbsp;5. [Header bar without standard buttons and with its own title widget](#header-bar-without-standard-buttons-and-with-its-own-title-widget)

VI. [Quick-reference table](#quick-reference-table)

VII. [Summary: which procedure to choose](#summary-which-procedure-to-choose)

---

## GtkHeaderBar

`GtkHeaderBar` replaces the window's standard header bar (see `gtk_window_set_titlebar` in the core reference) with a bar holding arbitrary widgets at the edges — action buttons, mode switches, a search field — while keeping the system window-control buttons (minimize/maximize/close) in the corner.

### `gtk_header_bar_new`

```nim
proc gtk_header_bar_new*(): GtkHeaderBar
```

**What it does.** Creates an empty header bar. It is not attached to any window by itself — attachment happens via a separate call to `gtk_window_set_titlebar(window, headerBar)` (core reference).

- No parameters.

```nim
let headerBar = gtk_header_bar_new()
gtk_window_set_titlebar(mainWindow, headerBar)
echo "Custom header bar created and set on the window"
```

---

### `gtk_header_bar_pack_start` / `gtk_header_bar_pack_end` / `gtk_header_bar_remove`

```nim
proc gtk_header_bar_pack_start*(bar: GtkHeaderBar, child: GtkWidget)
proc gtk_header_bar_pack_end*(bar: GtkHeaderBar, child: GtkWidget)
proc gtk_header_bar_remove*(bar: GtkHeaderBar, child: GtkWidget)
```

**What it does.** Adds a widget to the left (`pack_start`) or right (`pack_end`) part of the header bar — independent of the locale's writing direction (`start`/`end`, not literally "left"/"right", same as with `GtkWidget` margins in the core reference). Either side can hold several widgets — they line up in the order they were added, closer to the corresponding edge of the bar, leaving the title area (or `title_widget`, see below) in the center.

- `bar` — the header bar.
- `child` — the widget to add/remove.

```nim
gtk_header_bar_pack_start(headerBar, gtk_button_new_from_icon_name("document-new-symbolic"))
gtk_header_bar_pack_end(headerBar, gtk_button_new_from_icon_name("open-menu-symbolic"))
echo "New-document button on the left, menu button on the right"
```

---

### `gtk_header_bar_set_title_widget` / `gtk_header_bar_get_title_widget`

```nim
proc gtk_header_bar_set_title_widget*(bar: GtkHeaderBar, titleWidget: GtkWidget)
proc gtk_header_bar_get_title_widget*(bar: GtkHeaderBar): GtkWidget
```

**What it does.** Replaces the central title area (which by default shows the window title set by `gtk_window_set_title` — core reference) with an arbitrary widget — typically a `GtkStackSwitcher` (multi-view container reference) for applications where tabs/modes are switched right in the window's header, or a `GtkSearchEntry` (text-input reference) for applications where search is the central action.

- `bar` — the header bar.
- `titleWidget` — the widget for the central area.

```nim
let modeSwitcher = gtk_stack_switcher_new()
gtk_stack_switcher_set_stack(modeSwitcher, viewStack)
gtk_header_bar_set_title_widget(headerBar, modeSwitcher)
echo "View-mode switcher now occupies the central title area instead of text"
```

---

### `gtk_header_bar_set_show_title_buttons` / `gtk_header_bar_get_show_title_buttons`

```nim
proc gtk_header_bar_set_show_title_buttons*(bar: GtkHeaderBar, setting: gboolean)
proc gtk_header_bar_get_show_title_buttons*(bar: GtkHeaderBar): gboolean
```

**What it does.** Shows/hides the system window-control buttons (minimize/maximize/close), normally placed in a corner of the header bar — enabled by default. Turning them off makes sense for extra `GtkHeaderBar`s embedded not in the window itself but, say, inside a side panel or a dialog, where the system window buttons would be out of place or would duplicate the ones already shown on the main window.

- `bar` — the header bar.
- `setting` — `0.gboolean` to hide the system buttons.

```nim
let sidebarHeader = gtk_header_bar_new()
gtk_header_bar_set_show_title_buttons(sidebarHeader, 0.gboolean)
echo "Extra sidebar header bar built without the window's system buttons"
```

---

### `gtk_header_bar_set_decoration_layout` / `gtk_header_bar_get_decoration_layout`

```nim
proc gtk_header_bar_set_decoration_layout*(bar: GtkHeaderBar, layout: cstring)
proc gtk_header_bar_get_decoration_layout*(bar: GtkHeaderBar): cstring
```

**What it does.** Sets which system buttons to show and on which side, using a special-format string: items to the left of the colon are placed at the start of the bar, items to the right at the end; the items themselves are `close`, `minimize`, `maximize`, comma-separated (for example, `"close:minimize,maximize"` — close button on the left, minimize and maximize on the right). Passing `nil` returns the button layout defined by the desktop environment's settings — the default, which in most cases does not need to be changed, since that is what makes the header look native for the user's particular OS.

- `bar` — the header bar.
- `layout` — the layout string, or `nil` for the system default.

```nim
gtk_header_bar_set_decoration_layout(headerBar, "close:minimize,maximize")
echo "System button layout: ", $gtk_header_bar_get_decoration_layout(headerBar)
```

---

## GtkMessageDialog

`GtkMessageDialog` is a ready-made dialog for simple messages to the user: an icon matching the message type, text, a standard set of buttons — with no need to assemble the content by hand as with `GtkDialog` (section III).

### `gtk_message_dialog_new`

```nim
proc gtk_message_dialog_new*(parent: GtkWindow, flags: gint, msgType: GtkMessageType, buttons: GtkButtonsType, messageFormat: cstring): GtkMessageDialog {.varargs.}
```

**What it does.** Creates a message dialog. `msgType` determines the icon shown (`GTK_MESSAGE_INFO`, `_WARNING`, `_QUESTION`, `_ERROR`, `_OTHER` — no icon). `buttons` sets a ready-made button set with a single value (`GTK_BUTTONS_OK`, `_CLOSE`, `_CANCEL`, `_YES_NO`, `_OK_CANCEL`, `_NONE` — no buttons, added later by hand via `gtk_dialog_add_button`, since `GtkMessageDialog` is a subtype of `GtkDialog`). `messageFormat` and the subsequent variadic arguments form a `printf`-style format string (the same behavior as the C `printf` function) — the parameter is declared with `{.varargs.}`, so in Nim it is called with ordinary extra arguments following the format string.

- **Implementation note.** Since `messageFormat` is interpreted as a `printf` format string on the C side, if the message text is built from user data (for example, a file name), it must not contain stray `%` characters — it is safer to pass a ready Nim string with a single `%s` specifier rather than substituting user input directly into the format string itself.

- `parent` — the parent window.
- `flags` — a reserved bit flag (usually `0`).
- `msgType` — a `GtkMessageType` value.
- `buttons` — a `GtkButtonsType` value.
- `messageFormat` — a `printf`-style format string, followed by arguments as needed.

```nim
let confirmDialog = gtk_message_dialog_new(mainWindow, 0, GTK_MESSAGE_QUESTION, GTK_BUTTONS_YES_NO,
                                            "Delete the file \"%s\" permanently?", "report.pdf".cstring)
gtk_window_set_modal(confirmDialog, 1.gboolean)
gtk_window_present(confirmDialog)
echo "Delete-confirmation dialog shown"
```

---

### `gtk_message_dialog_set_markup`

```nim
proc gtk_message_dialog_set_markup*(messageDialog: GtkMessageDialog, str: cstring)
```

**What it does.** Replaces the main message text with text using Pango markup (analogous to `gtk_label_set_markup` from the basic-controls reference) — for example, to bold a key part of the message against otherwise plain text.

- `messageDialog` — the message dialog.
- `str` — text with Pango markup.

```nim
gtk_message_dialog_set_markup(confirmDialog, "Delete the file <b>report.pdf</b> permanently?")
echo "The file name in the dialog text is now bold"
```

---

## GtkDialog

`GtkDialog` is a builder for an arbitrary dialog: its own content area plus a row of action buttons, each of which, when clicked, reports the user's choice as a numeric response code via the `"response"` signal. Unlike `GtkMessageDialog`, the content and button set are assembled by hand, giving full control over the layout.

### `gtk_dialog_new`

```nim
proc gtk_dialog_new*(): GtkDialog
```

**What it does.** Creates an empty dialog with no buttons and no content — both are added by subsequent calls.

- No parameters.

```nim
let settingsDialog = gtk_dialog_new()
gtk_window_set_title(settingsDialog, "Export settings")
echo "Empty settings dialog created"
```

---

### `gtk_dialog_add_button` / `gtk_dialog_add_action_widget`

```nim
proc gtk_dialog_add_button*(dialog: GtkDialog, buttonText: cstring, responseId: gint): GtkWidget
proc gtk_dialog_add_action_widget*(dialog: GtkDialog, child: GtkWidget, responseId: gint)
```

**What it does.** Adds an action button to the dialog. `gtk_dialog_add_button` is the short form: it creates a plain text button itself and returns it (for example, so it can then be styled via `gtk_widget_add_css_class` with the `"suggested-action"`/`"destructive-action"` class). `gtk_dialog_add_action_widget` is the more general form, accepting an already-built arbitrary widget as the action element. `responseId` is the numeric code with which the `"response"` signal will report which button was pressed; it is convenient to use the ready-made `GtkResponseType` values (all negative, so they don't collide with arbitrary positive codes for custom buttons).

- `dialog` — the dialog.
- `buttonText` — the button text (for `add_button`).
- `child` — the arbitrary action widget (for `add_action_widget`).
- `responseId` — the response code reported by the `"response"` signal.

```nim
discard gtk_dialog_add_button(settingsDialog, "Cancel", ord(GTK_RESPONSE_CANCEL).gint)
let applyButton = gtk_dialog_add_button(settingsDialog, "Apply", ord(GTK_RESPONSE_APPLY).gint)
gtk_widget_add_css_class(applyButton, "suggested-action")
echo "'Cancel' button and highlighted 'Apply' button added to the dialog"
```

---

### `gtk_dialog_set_default_response`

```nim
proc gtk_dialog_set_default_response*(dialog: GtkDialog, responseId: gint)
```

**What it does.** Designates which of the already-added action buttons is activated by pressing Enter — the same "window default button" logic as `gtk_entry_set_activates_default` from the text-input reference, but expressed via the response code rather than the button widget itself directly.

- `dialog` — the dialog.
- `responseId` — the response code of the button that should become the default.

```nim
gtk_dialog_set_default_response(settingsDialog, ord(GTK_RESPONSE_APPLY).gint)
echo "Enter in the settings dialog now activates the 'Apply' button"
```

---

### `gtk_dialog_get_content_area` / `gtk_dialog_get_header_bar`

```nim
proc gtk_dialog_get_content_area*(dialog: GtkDialog): GtkWidget
proc gtk_dialog_get_header_bar*(dialog: GtkDialog): GtkWidget
```

**What it does.** `get_content_area` returns the container into which the dialog's own content should be added (via `gtk_box_append`, as with an ordinary `GtkBox`) — this container already exists on any `GtkDialog` right after creation. `get_header_bar` returns the dialog's header bar (section I), if the dialog uses one instead of the classic bottom button area — it may return `nil` if the dialog uses the traditional style.

- `dialog` — the dialog.

```nim
let contentArea = gtk_dialog_get_content_area(settingsDialog)
gtk_box_append(cast[GtkBox](contentArea), gtk_label_new("Choose the export format:"))
gtk_box_append(cast[GtkBox](contentArea), formatCombo)
echo "Content added to the dialog's content area"
```

---

### `gtk_dialog_response`

```nim
proc gtk_dialog_response*(dialog: GtkDialog, responseId: gint)
```

**What it does.** Programmatically emits the `"response"` signal with the given response code, as if the user had pressed the corresponding button — for example, to close the dialog after background validation, or for a test scenario that emulates a button press without an actual click.

- `dialog` — the dialog.
- `responseId` — the response code to emit.

```nim
proc onDialogResponse(dialog: GtkDialog, responseId: gint, userData: gpointer) {.cdecl.} =
  if responseId == ord(GTK_RESPONSE_APPLY).gint:
    echo "User pressed 'Apply' — saving export settings"
  gtk_window_destroy(cast[GtkWindow](dialog))

discard g_signal_connect(settingsDialog, "response", onDialogResponse, nil)
gtk_dialog_response(settingsDialog, ord(GTK_RESPONSE_CANCEL).gint)
```

---

## GtkFileChooserDialog

`GtkFileChooserDialog` is the system dialog for choosing a file or folder, implementing the `GtkFileChooser` interface on top of `GtkDialog` (so `gtk_dialog_add_button`/`response` from section III apply to it directly as well).

### `gtk_file_chooser_dialog_new`

```nim
proc gtk_file_chooser_dialog_new*(title: cstring, parent: GtkWindow, action: GtkFileChooserAction, firstButtonText: cstring): GtkFileChooserDialog {.varargs.}
```

**What it does.** Creates a file-chooser dialog. `action` determines the mode: `GTK_FILE_CHOOSER_ACTION_OPEN` (choosing an existing file), `_SAVE` (choosing a name and location to save — the file-name field is editable), `_SELECT_FOLDER` (choosing a folder rather than a file). After `firstButtonText` come variadic arguments — alternating "button text"/"response code" pairs, terminated by a mandatory `nil` in place of a button text — the same protocol as classic C variadic functions.

- **Implementation note.** Omitting the trailing `nil` is a common mistake: without it, GTK keeps reading memory past the arguments passed in, looking for a nonexistent next pair, which leads to undefined behavior.

- `title` — the dialog title.
- `parent` — the parent window.
- `action` — a `GtkFileChooserAction` value.
- `firstButtonText`, followed by (text, response code) pairs, mandatorily terminated by `nil`.

```nim
let openDialog = gtk_file_chooser_dialog_new("Open document", mainWindow, GTK_FILE_CHOOSER_ACTION_OPEN,
                                              "Cancel".cstring, ord(GTK_RESPONSE_CANCEL).gint,
                                              "Open".cstring, ord(GTK_RESPONSE_ACCEPT).gint,
                                              nil)
gtk_window_present(openDialog)
echo "Open-file dialog shown with Cancel/Open buttons"
```

---

### `gtk_file_chooser_set_current_name`

```nim
proc gtk_file_chooser_set_current_name*(chooser: GtkFileChooser, name: cstring)
```

**What it does.** Sets the suggested file name in the name-entry field — only works in `GTK_FILE_CHOOSER_ACTION_SAVE` mode. Typical use is to suggest a sensible default name when saving a new document.

- `chooser` — the file-chooser dialog (or any other `GtkFileChooser`).
- `name` — the suggested file name.

```nim
let saveDialog = gtk_file_chooser_dialog_new("Save as", mainWindow, GTK_FILE_CHOOSER_ACTION_SAVE,
                                              "Cancel".cstring, ord(GTK_RESPONSE_CANCEL).gint,
                                              "Save".cstring, ord(GTK_RESPONSE_ACCEPT).gint,
                                              nil)
gtk_file_chooser_set_current_name(saveDialog, "New document.txt")
echo "Save dialog shown with the suggested file name"
```

---

### `gtk_file_chooser_get_file` / `gtk_file_chooser_set_file`

```nim
proc gtk_file_chooser_get_file*(chooser: GtkFileChooser): GFile
proc gtk_file_chooser_set_file*(chooser: GtkFileChooser, file: GFile, error: ptr GError): gboolean
```

**What it does.** Reads the file chosen by the user (typically inside the `"response"` signal handler with the `GTK_RESPONSE_ACCEPT` code) and pre-sets the currently selected file programmatically. The value is a `GFile` object from GIO, not a path string directly; getting the path itself requires the separate `g_file_get_path`/`g_file_get_uri` functions, which are outside the scope of this reference.

- `chooser` — the file-chooser dialog.
- `file` — a `GFile` object (for `set_file`).
- `error` — a pointer to receive an error (`nil` may be passed).

```nim
proc onOpenDialogResponse(dialog: GtkFileChooserDialog, responseId: gint, userData: gpointer) {.cdecl.} =
  if responseId == ord(GTK_RESPONSE_ACCEPT).gint:
    let chosenFile = gtk_file_chooser_get_file(dialog)
    echo "File selected, GFile object obtained: ", not isNil(chosenFile)
  gtk_window_destroy(cast[GtkWindow](dialog))

discard g_signal_connect(openDialog, "response", onOpenDialogResponse, nil)
```

---

### `gtk_file_chooser_set_current_folder` / `gtk_file_chooser_get_current_folder`

```nim
proc gtk_file_chooser_set_current_folder*(chooser: GtkFileChooser, file: GFile, error: ptr GError): gboolean
proc gtk_file_chooser_get_current_folder*(chooser: GtkFileChooser): GFile
```

**What it does.** Sets and reads the folder currently open in the dialog — separate from the selected file itself (`get_file`). Useful so that each subsequent dialog opens in the same folder the user last worked in.

- `chooser` — the file-chooser dialog.
- `file` — a `GFile` object pointing to a folder (for `set_current_folder`).
- `error` — a pointer to receive an error (`nil` may be passed).

```nim
discard gtk_file_chooser_set_current_folder(openDialog, lastUsedFolder, nil)
echo "The dialog will open in the same folder the user last picked a file from"
```

---

## Practical recipes

### Header bar with action buttons at the edges

A typical setup for a main window: an add button on the left, a menu button on the right, the window title in the center (default).

```nim
proc buildMainHeaderBar(window: GtkWindow): GtkHeaderBar =
  result = gtk_header_bar_new()

  let addButton = gtk_button_new_from_icon_name("list-add-symbolic")
  gtk_header_bar_pack_start(result, addButton)

  let menuButton = gtk_button_new_from_icon_name("open-menu-symbolic")
  gtk_header_bar_pack_end(result, menuButton)

  gtk_window_set_titlebar(window, result)
  echo "Header bar with add and menu buttons set on the window"

# let headerBar = buildMainHeaderBar(mainWindow)
```

---

### Delete-confirmation dialog

A complete `GtkMessageDialog` build with user-response handling and correct dialog closing in every case.

```nim
proc confirmDeletion(parent: GtkWindow, itemName: string, onConfirmed: proc()) =
  let dialog = gtk_message_dialog_new(parent, 0, GTK_MESSAGE_WARNING, GTK_BUTTONS_NONE,
                                       "Delete \"%s\"?", itemName.cstring)
  discard gtk_dialog_add_button(cast[GtkDialog](dialog), "Cancel", ord(GTK_RESPONSE_CANCEL).gint)
  let deleteButton = gtk_dialog_add_button(cast[GtkDialog](dialog), "Delete", ord(GTK_RESPONSE_ACCEPT).gint)
  gtk_widget_add_css_class(deleteButton, "destructive-action")
  gtk_window_set_modal(dialog, 1.gboolean)

  proc onResponse(d: GtkDialog, responseId: gint, userData: gpointer) {.cdecl.} =
    if responseId == ord(GTK_RESPONSE_ACCEPT).gint:
      echo "User confirmed the deletion"
    gtk_window_destroy(cast[GtkWindow](d))

  discard g_signal_connect(dialog, "response", onResponse, nil)
  gtk_window_present(dialog)

# confirmDeletion(mainWindow, "report.pdf", proc() = echo "file deleted")
```

---

### Custom settings dialog with Cancel/Apply buttons

A `GtkDialog` with its own form inside and an explicitly assigned default button.

```nim
proc buildExportSettingsDialog(parent: GtkWindow): GtkDialog =
  result = cast[GtkDialog](gtk_dialog_new())
  gtk_window_set_title(result, "Export settings")
  gtk_window_set_transient_for(result, parent)
  gtk_window_set_modal(result, 1.gboolean)

  discard gtk_dialog_add_button(result, "Cancel", ord(GTK_RESPONSE_CANCEL).gint)
  let applyButton = gtk_dialog_add_button(result, "Apply", ord(GTK_RESPONSE_APPLY).gint)
  gtk_widget_add_css_class(applyButton, "suggested-action")
  gtk_dialog_set_default_response(result, ord(GTK_RESPONSE_APPLY).gint)

  let contentArea = gtk_dialog_get_content_area(result)
  let formatCombo = gtk_combo_box_text_new()
  gtk_combo_box_text_append_text(formatCombo, "PNG")
  gtk_combo_box_text_append_text(formatCombo, "JPEG")
  gtk_combo_box_set_active(formatCombo, 0)
  gtk_box_append(cast[GtkBox](contentArea), formatCombo)

  echo "Export settings dialog with format choice built"

let exportDialog = buildExportSettingsDialog(mainWindow)
```

---

### Save-file dialog with a default name

A complete `GtkFileChooserDialog` setup in save mode with a suggested name and result handling.

```nim
proc showSaveDialog(parent: GtkWindow, suggestedName: string) =
  let dialog = gtk_file_chooser_dialog_new("Save document", parent, GTK_FILE_CHOOSER_ACTION_SAVE,
                                            "Cancel".cstring, ord(GTK_RESPONSE_CANCEL).gint,
                                            "Save".cstring, ord(GTK_RESPONSE_ACCEPT).gint,
                                            nil)
  gtk_file_chooser_set_current_name(dialog, suggestedName.cstring)

  proc onResponse(d: GtkFileChooserDialog, responseId: gint, userData: gpointer) {.cdecl.} =
    if responseId == ord(GTK_RESPONSE_ACCEPT).gint:
      let target = gtk_file_chooser_get_file(d)
      echo "File will be saved, GFile obtained: ", not isNil(target)
    gtk_window_destroy(cast[GtkWindow](d))

  discard g_signal_connect(dialog, "response", onResponse, nil)
  gtk_window_present(dialog)

showSaveDialog(mainWindow, "New document.txt")
```

---

### Header bar without standard buttons and with its own title widget

A dialog header with a central tab switcher instead of plain text, and without the window's system buttons.

```nim
proc buildDialogHeaderWithSwitcher(stack: GtkStack): GtkHeaderBar =
  result = gtk_header_bar_new()
  gtk_header_bar_set_show_title_buttons(result, 0.gboolean)

  let switcher = gtk_stack_switcher_new()
  gtk_stack_switcher_set_stack(switcher, stack)
  gtk_header_bar_set_title_widget(result, switcher)

  echo "Dialog header with a tab switcher instead of text and without system buttons built"

# let dialogHeader = buildDialogHeaderWithSwitcher(settingsStack)
```

---

## Quick-reference table

| Procedure(s) | Category | What it does, briefly |
|---|---|---|
| `gtk_header_bar_new` | HeaderBar | Create a header bar |
| `gtk_header_bar_pack_start/end`, `remove` | HeaderBar | Add/remove a widget at the bar's edge |
| `gtk_header_bar_set/get_title_widget` | HeaderBar | Arbitrary widget instead of the title text |
| `gtk_header_bar_set/get_show_title_buttons` | HeaderBar | Whether to show the window's system buttons |
| `gtk_header_bar_set/get_decoration_layout` | HeaderBar | Which system buttons, and on which side |
| `gtk_message_dialog_new` | MessageDialog | Ready-made message dialog with icon and buttons |
| `gtk_message_dialog_set_markup` | MessageDialog | Message text with Pango markup |
| `gtk_dialog_new` | Dialog | Create an empty custom dialog |
| `gtk_dialog_add_button`, `add_action_widget` | Dialog | Add a button/custom action widget |
| `gtk_dialog_set_default_response` | Dialog | Button activated by Enter |
| `gtk_dialog_get_content_area` | Dialog | Container for the dialog's own content |
| `gtk_dialog_get_header_bar` | Dialog | The dialog's header bar, if used |
| `gtk_dialog_response` | Dialog | Programmatically emit the "response" signal |
| `gtk_file_chooser_dialog_new` | FileChooserDialog | Create a file/folder chooser dialog |
| `gtk_file_chooser_set_current_name` | FileChooserDialog | Suggested file name (save mode) |
| `gtk_file_chooser_get_file`, `set_file` | FileChooserDialog | The selected file as a GFile object |
| `gtk_file_chooser_set/get_current_folder` | FileChooserDialog | The folder currently open in the dialog |

---

## Summary: which procedure to choose

- **A simple message to the user with a ready-made button set** (error, warning, yes/no question) → `GtkMessageDialog`, rather than assembling a `GtkDialog` by hand for a typical case — the icon and buttons are already provided.
- **A dialog with its own form, fields, non-standard content** → `GtkDialog` + `gtk_dialog_get_content_area`, rather than trying to squeeze complex layout into a `GtkMessageDialog`.
- **Choosing an existing file** → `GTK_FILE_CHOOSER_ACTION_OPEN`. **Choosing a location and name to save a new file** → `GTK_FILE_CHOOSER_ACTION_SAVE` together with `gtk_file_chooser_set_current_name`. **Choosing a folder rather than a file** → `GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER`.
- **Customizing the window title bar's appearance** → `GtkHeaderBar` + `gtk_window_set_titlebar` (core reference), rather than trying to place these elements directly inside the window content below the title.
- **A dangerous action in a dialog** (deletion, an irreversible operation) → a button with the `"destructive-action"` CSS class, while the recommended action gets `"suggested-action"`.
- **Reacting to the user's choice in any `GtkDialog`-based dialog** (including `GtkMessageDialog`/`GtkFileChooserDialog`) → the `"response"` signal, checking `responseId`.
- **A dialog header without the window's system buttons, but with its own title widget** → `gtk_header_bar_set_show_title_buttons(bar, 0.gboolean)` — dialogs are usually closed by their own action buttons rather than the system close icon.
