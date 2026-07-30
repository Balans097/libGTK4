# GTK4 (bars & misc: InfoBar / Statusbar / LevelBar / LinkButton / ActionBar / SearchBar / Picture / FlowBox / Viewport) — module reference

> **Import:** `import libGTK4`
> **Scope:** various bars (info bar, status bar, action bar, search bar), level indicator, link button, the modern image widget, a flow of uniform cards, and an auxiliary scrolling container. This is the eleventh part of the wrapper reference series; it assumes familiarity with earlier parts, especially `gtk4_core_reference_ru.md` (layout, `GtkWidget`).

Two widgets in this reference — `GtkInfoBar` and `GtkStatusbar` — are marked **deprecated** in GTK4: they are still present and functional, but new code should not rely on them if a modern alternative exists (for informational messages — `GtkBanner`/a custom widget built on `GtkRevealer`, neither of which is part of this wrapper; for status — an arbitrary string in the header bar or in text). In this wrapper, both procedure groups are wrapped in `when not defined(GTK_DISABLE_DEPRECATED):` — they compile by default but drop out of the build when `-d:GTK_DISABLE_DEPRECATED` is specified, letting you check in advance whether your code depends on the deprecated API.

---

## Table of Contents

I. [GtkInfoBar (deprecated)](#gtkinfobar-deprecated)
&nbsp;&nbsp;1. [`gtk_info_bar_new`](#gtk_info_bar_new)
&nbsp;&nbsp;2. [`gtk_info_bar_add_button`](#gtk_info_bar_add_button)
&nbsp;&nbsp;3. [`gtk_info_bar_add_child` / `gtk_info_bar_remove_child`](#gtk_info_bar_add_child--gtk_info_bar_remove_child)
&nbsp;&nbsp;4. [`gtk_info_bar_set_message_type` / `gtk_info_bar_get_message_type`](#gtk_info_bar_set_message_type--gtk_info_bar_get_message_type)
&nbsp;&nbsp;5. [`gtk_info_bar_set_show_close_button` / `gtk_info_bar_get_show_close_button`](#gtk_info_bar_set_show_close_button--gtk_info_bar_get_show_close_button)
&nbsp;&nbsp;6. [`gtk_info_bar_set_revealed` / `gtk_info_bar_get_revealed`](#gtk_info_bar_set_revealed--gtk_info_bar_get_revealed)

II. [GtkStatusbar (deprecated)](#gtkstatusbar-deprecated)
&nbsp;&nbsp;1. [`gtk_statusbar_new`](#gtk_statusbar_new)
&nbsp;&nbsp;2. [`gtk_statusbar_get_context_id`](#gtk_statusbar_get_context_id)
&nbsp;&nbsp;3. [`gtk_statusbar_push` / `gtk_statusbar_pop` / `gtk_statusbar_remove` / `gtk_statusbar_remove_all`](#gtk_statusbar_push--gtk_statusbar_pop--gtk_statusbar_remove--gtk_statusbar_remove_all)

III. [GtkLevelBar](#gtklevelbar)
&nbsp;&nbsp;1. [`gtk_level_bar_new` / `gtk_level_bar_new_for_interval`](#gtk_level_bar_new--gtk_level_bar_new_for_interval)
&nbsp;&nbsp;2. [`gtk_level_bar_set_value` / `gtk_level_bar_get_value`](#gtk_level_bar_set_value--gtk_level_bar_get_value)
&nbsp;&nbsp;3. [`gtk_level_bar_set_min_value` / `get_min_value` / `set_max_value` / `get_max_value`](#gtk_level_bar_set_min_value--get_min_value--set_max_value--get_max_value)

IV. [GtkLinkButton](#gtklinkbutton)
&nbsp;&nbsp;1. [`gtk_link_button_new` / `gtk_link_button_new_with_label`](#gtk_link_button_new--gtk_link_button_new_with_label)
&nbsp;&nbsp;2. [`gtk_link_button_set_uri` / `gtk_link_button_get_uri`](#gtk_link_button_set_uri--gtk_link_button_get_uri)
&nbsp;&nbsp;3. [`gtk_link_button_set_visited` / `gtk_link_button_get_visited`](#gtk_link_button_set_visited--gtk_link_button_get_visited)

V. [GtkActionBar](#gtkactionbar)
&nbsp;&nbsp;1. [`gtk_action_bar_new`](#gtk_action_bar_new)
&nbsp;&nbsp;2. [`gtk_action_bar_pack_start` / `gtk_action_bar_pack_end` / `gtk_action_bar_remove`](#gtk_action_bar_pack_start--gtk_action_bar_pack_end--gtk_action_bar_remove)
&nbsp;&nbsp;3. [`gtk_action_bar_set_center_widget` / `gtk_action_bar_get_center_widget`](#gtk_action_bar_set_center_widget--gtk_action_bar_get_center_widget)

VI. [GtkSearchBar](#gtksearchbar)
&nbsp;&nbsp;1. [`gtk_search_bar_new`](#gtk_search_bar_new)
&nbsp;&nbsp;2. [`gtk_search_bar_set_child` / `gtk_search_bar_get_child`](#gtk_search_bar_set_child--gtk_search_bar_get_child)
&nbsp;&nbsp;3. [`gtk_search_bar_set_search_mode` / `gtk_search_bar_get_search_mode`](#gtk_search_bar_set_search_mode--gtk_search_bar_get_search_mode)
&nbsp;&nbsp;4. [`gtk_search_bar_set_show_close_button` / `gtk_search_bar_get_show_close_button`](#gtk_search_bar_set_show_close_button--gtk_search_bar_get_show_close_button)

VII. [GtkPicture](#gtkpicture)
&nbsp;&nbsp;1. [`gtk_picture_new` / `gtk_picture_new_for_file` / `gtk_picture_new_for_filename`](#gtk_picture_new--gtk_picture_new_for_file--gtk_picture_new_for_filename)
&nbsp;&nbsp;2. [`gtk_picture_set_file` / `gtk_picture_get_file` / `set_filename` / `set_pixbuf` / `set_paintable`](#gtk_picture_set_file--gtk_picture_get_file--set_filename--set_pixbuf--set_paintable)
&nbsp;&nbsp;3. [`gtk_picture_set_can_shrink` / `gtk_picture_get_can_shrink`](#gtk_picture_set_can_shrink--gtk_picture_get_can_shrink)

VIII. [GtkFlowBox](#gtkflowbox)
&nbsp;&nbsp;1. [`gtk_flow_box_new`](#gtk_flow_box_new)
&nbsp;&nbsp;2. [`gtk_flow_box_insert` / `gtk_flow_box_append` / `gtk_flow_box_prepend` / `gtk_flow_box_remove`](#gtk_flow_box_insert--gtk_flow_box_append--gtk_flow_box_prepend--gtk_flow_box_remove)
&nbsp;&nbsp;3. [`gtk_flow_box_set_homogeneous` / `gtk_flow_box_get_homogeneous`](#gtk_flow_box_set_homogeneous--gtk_flow_box_get_homogeneous)
&nbsp;&nbsp;4. [`gtk_flow_box_set_row_spacing` / `get_row_spacing` / `set_column_spacing` / `get_column_spacing`](#gtk_flow_box_set_row_spacing--get_row_spacing--set_column_spacing--get_column_spacing)
&nbsp;&nbsp;5. [`gtk_flow_box_set_min_children_per_line` / `get_min_children_per_line` / `set_max_children_per_line` / `get_max_children_per_line`](#gtk_flow_box_set_min_children_per_line--get_min_children_per_line--set_max_children_per_line--get_max_children_per_line)
&nbsp;&nbsp;6. [`gtk_flow_box_set_selection_mode` / `gtk_flow_box_get_selection_mode`](#gtk_flow_box_set_selection_mode--gtk_flow_box_get_selection_mode)
&nbsp;&nbsp;7. [`gtk_flow_box_child_new` / `set_child` / `get_child` / `get_index`](#gtk_flow_box_child_new--set_child--get_child--get_index)

IX. [GtkViewport](#gtkviewport)
&nbsp;&nbsp;1. [`gtk_viewport_new`](#gtk_viewport_new)
&nbsp;&nbsp;2. [`gtk_viewport_set_child` / `gtk_viewport_get_child`](#gtk_viewport_set_child--gtk_viewport_get_child)
&nbsp;&nbsp;3. [`gtk_viewport_set_scroll_to_focus` / `gtk_viewport_get_scroll_to_focus`](#gtk_viewport_set_scroll_to_focus--gtk_viewport_get_scroll_to_focus)

X. [Practical recipes](#practical-recipes)
&nbsp;&nbsp;1. [A search bar that expands with Ctrl+F](#a-search-bar-that-expands-with-ctrlf)
&nbsp;&nbsp;2. [A segmented battery level indicator](#a-segmented-battery-level-indicator)
&nbsp;&nbsp;3. [An image preview gallery built on GtkFlowBox](#an-image-preview-gallery-built-on-gtkflowbox)
&nbsp;&nbsp;4. [An action bar at the bottom of a window with buttons on the edges](#an-action-bar-at-the-bottom-of-a-window-with-buttons-on-the-edges)
&nbsp;&nbsp;5. [A link to an external resource in descriptive text](#a-link-to-an-external-resource-in-descriptive-text)

XI. [Quick reference table](#quick-reference-table)

XII. [Summary: which procedure to choose](#summary-which-procedure-to-choose)

---

## GtkInfoBar (deprecated)

`GtkInfoBar` is a horizontal bar carrying a message, an icon based on the message type (like `GtkMessageDialog`), and optional buttons — typically shown at the top or bottom of a window's content rather than as a separate popup/dialog window. Marked deprecated in GTK4.

### `gtk_info_bar_new`

```nim
proc gtk_info_bar_new*(): GtkInfoBar
```

**What it does.** Creates an info bar with no buttons and no extra content.

- No parameters.

```nim
let infoBar = gtk_info_bar_new()
echo "Info bar created"
```

---

### `gtk_info_bar_add_button`

```nim
proc gtk_info_bar_add_button*(infoBar: GtkInfoBar, buttonText: cstring, responseId: gint)
```

**What it does.** Adds an action button to the bar — the same response-code logic (`responseId`) as `gtk_dialog_add_button` from the window chrome reference, since `GtkInfoBar` emits the same `"response"` signal.

- `infoBar` — the info bar.
- `buttonText` — the button's text.
- `responseId` — the response code reported by the `"response"` signal.

```nim
gtk_info_bar_add_button(infoBar, "Close", ord(GTK_RESPONSE_CLOSE).gint)
echo "Close button added to the info bar"
```

---

### `gtk_info_bar_add_child` / `gtk_info_bar_remove_child`

```nim
proc gtk_info_bar_add_child*(infoBar: GtkInfoBar, widget: GtkWidget)
proc gtk_info_bar_remove_child*(infoBar: GtkInfoBar, widget: GtkWidget)
```

**What it does.** Add/remove an arbitrary widget in the bar's main content area (not the button area) — for example, a label carrying the message text itself.

- `infoBar` — the info bar.
- `widget` — the widget to add/remove.

```nim
gtk_info_bar_add_child(infoBar, gtk_label_new("Connection to the server was lost"))
echo "Message text added to the info bar"
```

---

### `gtk_info_bar_set_message_type` / `gtk_info_bar_get_message_type`

```nim
proc gtk_info_bar_set_message_type*(infoBar: GtkInfoBar, messageType: GtkMessageType)
proc gtk_info_bar_get_message_type*(infoBar: GtkInfoBar): GtkMessageType
```

**What it does.** Set the message type — the same logic and the same `GtkMessageType` values as `GtkMessageDialog` (window chrome reference): it affects the bar's background color and icon (`GTK_MESSAGE_WARNING` gives a warning-style yellow/orange look, `_ERROR` gives red, and so on).

- `infoBar` — the info bar.
- `messageType` — a `GtkMessageType` value.

```nim
gtk_info_bar_set_message_type(infoBar, GTK_MESSAGE_WARNING)
echo "Bar colored as a warning"
```

---

### `gtk_info_bar_set_show_close_button` / `gtk_info_bar_get_show_close_button`

```nim
proc gtk_info_bar_set_show_close_button*(infoBar: GtkInfoBar, setting: gboolean)
proc gtk_info_bar_get_show_close_button*(infoBar: GtkInfoBar): gboolean
```

**What it does.** Show/hide the built-in close button (the "X"), separate from any buttons added via `add_button` — a quick way to let the user dismiss the bar without adding a separate "Close" button by hand.

- `infoBar` — the info bar.
- `setting` — `1.gboolean` to show the built-in close button.

```nim
gtk_info_bar_set_show_close_button(infoBar, 1.gboolean)
echo "Close button (X) is now visible"
```

---

### `gtk_info_bar_set_revealed` / `gtk_info_bar_get_revealed`

```nim
proc gtk_info_bar_set_revealed*(infoBar: GtkInfoBar, revealed: gboolean)
proc gtk_info_bar_get_revealed*(infoBar: GtkInfoBar): gboolean
```

**What it does.** Show/hide the bar with a smooth reveal/collapse animation (unlike the abrupt `gtk_widget_set_visible` from the core reference) — the preferred way to show/hide a `GtkInfoBar` precisely because it has dedicated animation, rather than the generic visibility function.

- `infoBar` — the info bar.
- `revealed` — `1.gboolean` to show the bar with animation.

```nim
gtk_info_bar_set_revealed(infoBar, 1.gboolean)
echo "Info bar is smoothly appearing"
```

---

## GtkStatusbar (deprecated)

`GtkStatusbar` is a narrow bar at the bottom of a window for short status messages, with support for a "stack" of messages per context — a new message can be pushed, and once it's no longer relevant, popped back to the previous one without losing history. Marked deprecated in GTK4 — modern applications more often show status in the header bar, or forgo a separate status line altogether.

### `gtk_statusbar_new`

```nim
proc gtk_statusbar_new*(): GtkStatusbar
```

**What it does.** Creates an empty status bar.

- No parameters.

```nim
let statusbar = gtk_statusbar_new()
echo "Status bar created"
```

---

### `gtk_statusbar_get_context_id`

```nim
proc gtk_statusbar_get_context_id*(statusbar: GtkStatusbar, contextDescription: cstring): guint
```

**What it does.** Returns a numeric message "context" identifier from its textual description — calls with the same `contextDescription` always return the same `contextId`, which lets you group related messages (for example, all messages about file operations, separate from messages about network connectivity) and work with each group independently through `push`/`pop`/`remove` (next subsection).

- `statusbar` — the status bar.
- `contextDescription` — an arbitrary textual description of the context (used only as a key to obtain `contextId`; not shown to the user).

```nim
let fileContextId = gtk_statusbar_get_context_id(statusbar, "file-operations")
echo "Context identifier for file-operation messages obtained"
```

---

### `gtk_statusbar_push` / `gtk_statusbar_pop` / `gtk_statusbar_remove` / `gtk_statusbar_remove_all`

```nim
proc gtk_statusbar_push*(statusbar: GtkStatusbar, contextId: guint, text: cstring): guint
proc gtk_statusbar_pop*(statusbar: GtkStatusbar, contextId: guint)
proc gtk_statusbar_remove*(statusbar: GtkStatusbar, contextId: guint, messageId: guint)
proc gtk_statusbar_remove_all*(statusbar: GtkStatusbar, contextId: guint)
```

**What it does.** `push` adds a new message to the given context's stack and displays it as the current one (it returns a unique `messageId` for that specific message — for later targeted removal via `remove`, independent of the context's other messages). `pop` removes the topmost message of the context, making the previous one in that context's stack visible again (if there was one). `remove` removes a specific message by its `messageId`, even if it isn't the topmost one. `remove_all` clears the entire stack of the given context at once.

- `statusbar` — the status bar.
- `contextId` — the context identifier obtained from `get_context_id`.
- `text` — the message text (for `push`).
- `messageId` — the identifier of a specific message previously returned by `push` (for `remove`).

```nim
let msgId = gtk_statusbar_push(statusbar, fileContextId, "Copying files: 3 of 10")
# ... once the operation completes ...
gtk_statusbar_pop(statusbar, fileContextId)
echo "Copy message removed, previous message of this context shown (if any)"
```

---

## GtkLevelBar

`GtkLevelBar` is a horizontal bar indicating a value's level within a range, visually similar to `GtkProgressBar`, but intended to show a **static level** rather than the progress of an ongoing operation — battery charge, volume, signal strength.

### `gtk_level_bar_new` / `gtk_level_bar_new_for_interval`

```nim
proc gtk_level_bar_new*(): GtkLevelBar
proc gtk_level_bar_new_for_interval*(minValue: gdouble, maxValue: gdouble): GtkLevelBar
```

**What it does.** `gtk_level_bar_new` creates an indicator with the standard `0.0`–`1.0` range. `gtk_level_bar_new_for_interval` sets an arbitrary range right away — more convenient when the value's natural units aren't `0.0`–`1.0` (for example, volume in the familiar `0`–`100`).

- `minValue`, `maxValue` — the range bounds (for `new_for_interval`).

```nim
let batteryLevel = gtk_level_bar_new_for_interval(0.0, 100.0)
echo "Battery level indicator created with a 0-100 range"
```

---

### `gtk_level_bar_set_value` / `gtk_level_bar_get_value`

```nim
proc gtk_level_bar_set_value*(levelBar: GtkLevelBar, value: gdouble)
proc gtk_level_bar_get_value*(levelBar: GtkLevelBar): gdouble
```

**What it does.** Set and read the currently displayed level.

- `levelBar` — the level indicator.
- `value` — a value within the current range.

```nim
gtk_level_bar_set_value(batteryLevel, 72.0)
echo "Current charge level: ", gtk_level_bar_get_value(batteryLevel), "%"
```

---

### `gtk_level_bar_set_min_value` / `get_min_value` / `set_max_value` / `get_max_value`

```nim
proc gtk_level_bar_set_min_value*(levelBar: GtkLevelBar, value: gdouble)
proc gtk_level_bar_get_min_value*(levelBar: GtkLevelBar): gdouble
proc gtk_level_bar_set_max_value*(levelBar: GtkLevelBar, value: gdouble)
proc gtk_level_bar_get_max_value*(levelBar: GtkLevelBar): gdouble
```

**What it does.** Change the range bounds after creation.

- `levelBar` — the level indicator.
- `value` — the new bound.

```nim
gtk_level_bar_set_max_value(signalStrengthBar, 5.0)
echo "Signal indicator range: from ", gtk_level_bar_get_min_value(signalStrengthBar), " to ", gtk_level_bar_get_max_value(signalStrengthBar)
```

---

## GtkLinkButton

`GtkLinkButton` is a button that visually looks like a hyperlink and opens the given URI in an external application when clicked — built-in widget behavior, with no need to wire up a handler manually.

### `gtk_link_button_new` / `gtk_link_button_new_with_label`

```nim
proc gtk_link_button_new*(uri: cstring): GtkLinkButton
proc gtk_link_button_new_with_label*(uri: cstring, label: cstring): GtkLinkButton
```

**What it does.** Create a link button. `gtk_link_button_new` shows the URI itself as the visible text. `gtk_link_button_new_with_label` shows arbitrary text instead of the URI.

- `uri` — the address opened on click.
- `label` — the button's visible text (for the `_with_label` variant).

```nim
let docsLink = gtk_link_button_new_with_label("https://example.com/docs", "Project documentation")
echo "Link button to the documentation created"
```

---

### `gtk_link_button_set_uri` / `gtk_link_button_get_uri`

```nim
proc gtk_link_button_set_uri*(linkButton: GtkLinkButton, uri: cstring)
proc gtk_link_button_get_uri*(linkButton: GtkLinkButton): cstring
```

**What it does.** Change and read the target address after the button has already been created.

- `linkButton` — the link button.
- `uri` — the new address.

```nim
gtk_link_button_set_uri(docsLink, "https://example.com/docs/v2")
echo "Link updated: ", $gtk_link_button_get_uri(docsLink)
```

---

### `gtk_link_button_set_visited` / `gtk_link_button_get_visited`

```nim
proc gtk_link_button_set_visited*(linkButton: GtkLinkButton, visited: gboolean)
proc gtk_link_button_get_visited*(linkButton: GtkLinkButton): gboolean
```

**What it does.** Control the link's visual "visited" state — GTK does not track visit history itself; the state is set manually by the application.

- `linkButton` — the link button.
- `visited` — `1.gboolean` to display it as "visited".

```nim
gtk_link_button_set_visited(docsLink, 1.gboolean)
echo "Documentation link is now shown as already visited"
```

---

## GtkActionBar

`GtkActionBar` is a narrow horizontal bar, typically placed at the bottom of a window, with widgets on the edges and an optional widget in the center — similar to `GtkHeaderBar`, but for the bottom of the window and without system window-control buttons.

### `gtk_action_bar_new`

```nim
proc gtk_action_bar_new*(): GtkActionBar
```

**What it does.** Creates an empty action bar.

- No parameters.

```nim
let bottomBar = gtk_action_bar_new()
echo "Action bar at the bottom of the window created"
```

---

### `gtk_action_bar_pack_start` / `gtk_action_bar_pack_end` / `gtk_action_bar_remove`

```nim
proc gtk_action_bar_pack_start*(actionBar: GtkActionBar, child: GtkWidget)
proc gtk_action_bar_pack_end*(actionBar: GtkActionBar, child: GtkWidget)
proc gtk_action_bar_remove*(actionBar: GtkActionBar, child: GtkWidget)
```

**What it does.** Add/remove a widget at the start or end of the bar — the same `start`/`end` logic as `gtk_header_bar_pack_start`/`pack_end`.

- `actionBar` — the action bar.
- `child` — the widget to add/remove.

```nim
gtk_action_bar_pack_start(bottomBar, gtk_button_new_from_icon_name("edit-select-all-symbolic"))
gtk_action_bar_pack_end(bottomBar, gtk_button_new_with_label("Done"))
echo "Select-all button on the left, 'Done' button on the right"
```

---

### `gtk_action_bar_set_center_widget` / `gtk_action_bar_get_center_widget`

```nim
proc gtk_action_bar_set_center_widget*(actionBar: GtkActionBar, centerWidget: GtkWidget)
proc gtk_action_bar_get_center_widget*(actionBar: GtkActionBar): GtkWidget
```

**What it does.** Set and read the widget placed in the center of the bar — for example, a "3 of 12 selected" counter in a multi-select mode.

- `actionBar` — the action bar.
- `centerWidget` — the widget for the center area.

```nim
gtk_action_bar_set_center_widget(bottomBar, gtk_label_new("3 selected"))
echo "Selected-item counter shown in the center of the action bar"
```

---

## GtkSearchBar

`GtkSearchBar` is a search bar that can be hidden and appear on demand with a smooth animation, containing a search entry (`GtkSearchEntry` from the text-input reference) inside.

### `gtk_search_bar_new`

```nim
proc gtk_search_bar_new*(): GtkSearchBar
```

**What it does.** Creates a search bar, collapsed by default.

- No parameters.

```nim
let searchBar = gtk_search_bar_new()
echo "Search bar created in a hidden state"
```

---

### `gtk_search_bar_set_child` / `gtk_search_bar_get_child`

```nim
proc gtk_search_bar_set_child*(searchBar: GtkSearchBar, child: GtkWidget)
proc gtk_search_bar_get_child*(searchBar: GtkSearchBar): GtkWidget
```

**What it does.** Set and read the bar's content — usually a `GtkSearchEntry`, but it can also be a composite container with additional elements.

- `searchBar` — the search bar.
- `child` — the content widget.

```nim
let searchEntry = gtk_search_entry_new()
gtk_search_bar_set_child(searchBar, searchEntry)
echo "Search entry set as the bar's content"
```

---

### `gtk_search_bar_set_search_mode` / `gtk_search_bar_get_search_mode`

```nim
proc gtk_search_bar_set_search_mode*(searchBar: GtkSearchBar, searchMode: gboolean)
proc gtk_search_bar_get_search_mode*(searchBar: GtkSearchBar): gboolean
```

**What it does.** Show/hide the search bar with a smooth animation, and read whether it is currently shown — the primary way to control its visibility, for example via `Ctrl+F`.

- `searchBar` — the search bar.
- `searchMode` — `1.gboolean` to show the bar.

```nim
proc onSearchShortcut() =
  gtk_search_bar_set_search_mode(searchBar, 1.gboolean)
  echo "Search bar shown via Ctrl+F"
```

---

### `gtk_search_bar_set_show_close_button` / `gtk_search_bar_get_show_close_button`

```nim
proc gtk_search_bar_set_show_close_button*(searchBar: GtkSearchBar, visible: gboolean)
proc gtk_search_bar_get_show_close_button*(searchBar: GtkSearchBar): gboolean
```

**What it does.** Show/hide the search bar's built-in close button.

- `searchBar` — the search bar.
- `visible` — `1.gboolean` to show the close button.

```nim
gtk_search_bar_set_show_close_button(searchBar, 1.gboolean)
echo "Search bar's close button is now visible"
```

---

## GtkPicture

`GtkPicture` is the modern image widget in GTK4 (unlike `GtkImage` from the helper-widgets reference, which is geared primarily toward icons at fixed standard sizes): it's intended for showing photos and images of arbitrary size, with flexible scaling and preserved aspect ratio. The choice between `GtkImage` and `GtkPicture` typically comes down to: `GtkImage` for theme icons, `GtkPicture` for photos and user content.

### `gtk_picture_new` / `gtk_picture_new_for_file` / `gtk_picture_new_for_filename`

```nim
proc gtk_picture_new*(): GtkPicture
proc gtk_picture_new_for_file*(file: GFile): GtkPicture
proc gtk_picture_new_for_filename*(filename: cstring): GtkPicture
```

**What it does.** Create an image widget — empty, from a `GFile` object (see the GFile section in the drawing and GLib-utilities reference), or directly from a file-path string (shorter, without an intermediate `GFile`).

- `file` — a `GFile` object.
- `filename` — the path to the image file.

```nim
let photoView = gtk_picture_new_for_filename("/home/user/Pictures/vacation.jpg")
echo "Photo image loaded from file"
```

---

### `gtk_picture_set_file` / `gtk_picture_get_file` / `set_filename` / `set_pixbuf` / `set_paintable`

```nim
proc gtk_picture_set_file*(picture: GtkPicture, file: GFile)
proc gtk_picture_get_file*(picture: GtkPicture): GFile
proc gtk_picture_set_filename*(picture: GtkPicture, filename: cstring)
proc gtk_picture_set_pixbuf*(picture: GtkPicture, pixbuf: GdkPixbuf)
proc gtk_picture_set_paintable*(picture: GtkPicture, paintable: pointer)
```

**What it does.** Change the content of an already existing `GtkPicture` widget from any of four sources — a `GFile`, a file path, a ready-made `GdkPixbuf` (an image decoded in memory — for example, obtained after programmatic processing), or an arbitrary `GdkPaintable` (the most general option — the same thing accepted by `gtk_image_new_from_paintable` from the helper-widgets reference, including, for example, a video frame). `get_file` reads the current source back, if the content was set via a file specifically.

- `picture` — the image widget.
- `file` / `filename` / `pixbuf` / `paintable` — the new image source.

```nim
gtk_picture_set_filename(photoView, "/home/user/Pictures/other-photo.jpg")
echo "Displayed photo replaced with another one"
```

---

### `gtk_picture_set_can_shrink` / `gtk_picture_get_can_shrink`

```nim
proc gtk_picture_set_can_shrink*(picture: GtkPicture, canShrink: gboolean)
proc gtk_picture_get_can_shrink*(picture: GtkPicture): gboolean
```

**What it does.** Allow the image to shrink below its own natural size if there isn't enough room (enabled by default — `GtkPicture`, unlike `GtkImage`, is designed from the outset for scalable, variable-size images rather than fixed-size icons). Disabling it (`0.gboolean`) forces the container the image is placed in to always allocate it at least the image's natural size — when space is short, the container is more likely to show scrollbars or clip the image at the edges than to shrink it.

- `picture` — the image widget.
- `canShrink` — `0.gboolean` to forbid shrinking below the natural size.

```nim
gtk_picture_set_can_shrink(photoView, 1.gboolean)  # the default value, given explicitly for clarity
echo "Image will scale to fit the available space while preserving its aspect ratio"
```

---

## GtkFlowBox

`GtkFlowBox` is a container that lays out uniform "cards" in a flow, automatically wrapping them onto a new row/column as space runs out (analogous to CSS `flexbox`/`flex-wrap` from web layout) — typical uses: an image preview gallery, an app-icon grid, a tag cloud.

### `gtk_flow_box_new`

```nim
proc gtk_flow_box_new*(): GtkFlowBox
```

**What it does.** Creates an empty flow.

- No parameters.

```nim
let gallery = gtk_flow_box_new()
echo "Gallery container created"
```

---

### `gtk_flow_box_insert` / `gtk_flow_box_append` / `gtk_flow_box_prepend` / `gtk_flow_box_remove`

```nim
proc gtk_flow_box_insert*(box: GtkFlowBox, widget: GtkWidget, position: gint)
proc gtk_flow_box_append*(box: GtkFlowBox, widget: GtkWidget)
proc gtk_flow_box_prepend*(box: GtkFlowBox, widget: GtkWidget)
proc gtk_flow_box_remove*(box: GtkFlowBox, widget: GtkWidget)
```

**What it does.** Add and remove flow items — the same insertion-order logic as `gtk_box_append`/`prepend`/`insert` from the core reference. Like `GtkListBox` (multi-view containers reference), `GtkFlowBox` automatically wraps an added widget in a `GtkFlowBoxChild` if one wasn't created explicitly (see the last subsection).

- `box` — the flow.
- `widget` — the widget to add/remove.
- `position` (for `insert`) — the insertion index.

```nim
for photoPath in ["photo1.jpg", "photo2.jpg", "photo3.jpg"]:
  gtk_flow_box_append(gallery, gtk_picture_new_for_filename(photoPath.cstring))
echo "Three previews added to the gallery"
```

---

### `gtk_flow_box_set_homogeneous` / `gtk_flow_box_get_homogeneous`

```nim
proc gtk_flow_box_set_homogeneous*(box: GtkFlowBox, homogeneous: gboolean)
proc gtk_flow_box_get_homogeneous*(box: GtkFlowBox): gboolean
```

**What it does.** Force all flow items to have the same size (matching the largest one) — the same logic as `gtk_box_set_homogeneous`/`gtk_grid_set_row/column_homogeneous`. For a preview gallery this is usually enabled so the cards line up visually into a neat, even grid.

- `box` — the flow.
- `homogeneous` — `1.gboolean` for equal sizing of all items.

```nim
gtk_flow_box_set_homogeneous(gallery, 1.gboolean)
echo "All previews in the gallery are now the same size"
```

---

### `gtk_flow_box_set_row_spacing` / `get_row_spacing` / `set_column_spacing` / `get_column_spacing`

```nim
proc gtk_flow_box_set_row_spacing*(box: GtkFlowBox, spacing: guint)
proc gtk_flow_box_get_row_spacing*(box: GtkFlowBox): guint
proc gtk_flow_box_set_column_spacing*(box: GtkFlowBox, spacing: guint)
proc gtk_flow_box_get_column_spacing*(box: GtkFlowBox): guint
```

**What it does.** Set the spacing between rows and between columns of the flow independently — the same logic as `gtk_grid_set_row_spacing`/`set_column_spacing`.

- `box` — the flow.
- `spacing` — the spacing in pixels.

```nim
gtk_flow_box_set_row_spacing(gallery, 12)
gtk_flow_box_set_column_spacing(gallery, 12)
echo "Spacing between previews in the gallery set"
```

---

### `gtk_flow_box_set_min_children_per_line` / `get_min_children_per_line` / `set_max_children_per_line` / `get_max_children_per_line`

```nim
proc gtk_flow_box_set_min_children_per_line*(box: GtkFlowBox, nChildren: guint)
proc gtk_flow_box_get_min_children_per_line*(box: GtkFlowBox): guint
proc gtk_flow_box_set_max_children_per_line*(box: GtkFlowBox, nChildren: guint)
proc gtk_flow_box_get_max_children_per_line*(box: GtkFlowBox): guint
```

**What it does.** Constrain how many items fit in a single row/column of the flow, regardless of how many would actually fit purely by width. `min_children_per_line` is the minimum below which GTK will not reduce the number of items per row, even if there is categorically not enough space (items will be clipped/require scrolling if needed, rather than being wrapped onto additional rows beyond this row-count constraint). `max_children_per_line` is a ceiling beyond which any remaining free width space is simply left empty rather than filled with even more items per row.

- `box` — the flow.
- `nChildren` — the number of items per row.

```nim
gtk_flow_box_set_min_children_per_line(gallery, 2)
gtk_flow_box_set_max_children_per_line(gallery, 6)
echo "The gallery will show 2 to 6 previews per row depending on the window's width"
```

---

### `gtk_flow_box_set_selection_mode` / `gtk_flow_box_get_selection_mode`

```nim
proc gtk_flow_box_set_selection_mode*(box: GtkFlowBox, mode: GtkSelectionMode)
proc gtk_flow_box_get_selection_mode*(box: GtkFlowBox): GtkSelectionMode
```

**What it does.** Set the flow's item-selection mode — the same logic and the same `GtkSelectionMode` values as `gtk_list_box_set_selection_mode` from the multi-view containers reference.

- `box` — the flow.
- `mode` — a `GtkSelectionMode` value.

```nim
gtk_flow_box_set_selection_mode(gallery, GTK_SELECTION_MULTIPLE)
echo "Multiple photos can now be selected in the gallery at once"
```

---

### `gtk_flow_box_child_new` / `set_child` / `get_child` / `get_index`

```nim
proc gtk_flow_box_child_new*(): GtkFlowBoxChild
proc gtk_flow_box_child_set_child*(child: GtkFlowBoxChild, widget: GtkWidget)
proc gtk_flow_box_child_get_child*(child: GtkFlowBoxChild): GtkWidget
proc gtk_flow_box_child_get_index*(child: GtkFlowBoxChild): gint
```

**What it does.** Explicit creation of a flow item separate from adding it — the same logic as `gtk_list_box_row_new`/`row_set_child`/`row_get_child`/`row_get_index` from the multi-view containers reference, but for `GtkFlowBox` instead of `GtkListBox`. Needed when something must be done to the item before or in addition to setting its content (for example, setting `gtk_widget_set_name` for targeted CSS styling of a specific card).

- `child` — the flow item.
- `widget` — the item's content.

```nim
let customChild = gtk_flow_box_child_new()
gtk_flow_box_child_set_child(customChild, gtk_picture_new_for_filename("cover.jpg"))
gtk_flow_box_append(gallery, customChild)
echo "Flow item created explicitly, with index ", gtk_flow_box_child_get_index(customChild)
```

---

## GtkViewport

`GtkViewport` is an auxiliary container that makes its single child widget scrollable, even if that widget doesn't support scrolling on its own. `GtkScrolledWindow` (helper-widgets reference) in practice uses `GtkViewport` automatically "under the hood" for widgets that don't natively support scrolling — so in most scenarios there's no need to create a `GtkViewport` by hand. Explicit use is mainly needed for fine-tuning focus behavior during scrolling.

### `gtk_viewport_new`

```nim
proc gtk_viewport_new*(hadjustment: GtkAdjustment, vadjustment: GtkAdjustment): GtkViewport
```

**What it does.** Creates a viewport with explicitly given horizontal and vertical `GtkAdjustment` objects (numeric and range-control widgets reference) — usually `nil`/`nil` is passed, and the `GtkScrolledWindow` the viewport is nested in creates and wires up its own adjustments automatically.

- `hadjustment`, `vadjustment` — scroll-range adjustment objects, or `nil` for automatically created ones.

```nim
let viewport = gtk_viewport_new(nil, nil)
echo "Viewport created with automatically wired-up adjustments"
```

---

### `gtk_viewport_set_child` / `gtk_viewport_get_child`

```nim
proc gtk_viewport_set_child*(viewport: GtkViewport, child: GtkWidget)
proc gtk_viewport_get_child*(viewport: GtkViewport): GtkWidget
```

**What it does.** Set and read the single child widget that the viewport makes scrollable — the same "one content slot" pattern seen in most containers throughout this reference series.

- `viewport` — the viewport.
- `child` — the content widget.

```nim
gtk_viewport_set_child(viewport, gtk_fixed_new())  # GtkFixed itself can't scroll on its own
echo "The absolute-positioning container now scrolls via the viewport"
```

---

### `gtk_viewport_set_scroll_to_focus` / `gtk_viewport_get_scroll_to_focus`

```nim
proc gtk_viewport_set_scroll_to_focus*(viewport: GtkViewport, scrollToFocus: gboolean)
proc gtk_viewport_get_scroll_to_focus*(viewport: GtkViewport): gboolean
```

**What it does.** Control whether the content is automatically scrolled to reveal the widget that received keyboard focus (for example, when tabbing between fields of a long form inside a scrollable area) — enabled by default. Disabling it may be needed for non-standard scrolling scenarios where the application manages the scroll position entirely on its own and the automatic behavior would get in the way.

- `viewport` — the viewport.
- `scrollToFocus` — `0.gboolean` to disable auto-scrolling to the focused widget.

```nim
echo "Auto-scroll to the focused field: ", gtk_viewport_get_scroll_to_focus(viewport) != 0.gboolean
```

---

## Practical recipes

### A search bar that expands with Ctrl+F

The full `GtkSearchBar` + `GtkSearchEntry` combination, embedded above a window's content.

```nim
proc buildSearchableView(content: GtkWidget): GtkBox =
  result = gtk_box_new(GTK_ORIENTATION_VERTICAL, 0)

  let searchBar = gtk_search_bar_new()
  let searchEntry = gtk_search_entry_new()
  gtk_search_bar_set_child(searchBar, searchEntry)
  gtk_search_bar_set_show_close_button(searchBar, 1.gboolean)

  gtk_box_append(result, searchBar)
  gtk_box_append(result, content)

  proc onSearchChanged(entry: GtkSearchEntry, userData: gpointer) {.cdecl.} =
    echo "Filtering by query: ", $gtk_editable_get_text(entry)
  discard g_signal_connect(searchEntry, "search-changed", onSearchChanged, nil)

  echo "Search bar embedded above the main content, initially hidden"

# Showing the bar via Ctrl+F is done by calling gtk_search_bar_set_search_mode(searchBar, 1.gboolean)
# from the handler for the corresponding key combination (see the actions and signals reference).
```

---

### A segmented battery level indicator

A `GtkLevelBar` in a status area, updated as the real battery charge changes.

```nim
proc buildBatteryIndicator(): GtkBox =
  result = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 6)

  let icon = gtk_image_new_from_icon_name("battery-symbolic")
  let level = gtk_level_bar_new_for_interval(0.0, 100.0)
  gtk_widget_set_size_request(level, 80, -1)

  gtk_box_append(result, icon)
  gtk_box_append(result, level)
  echo "Battery indicator with icon and level bar assembled"

proc updateBatteryLevel(level: GtkLevelBar, percent: float) =
  gtk_level_bar_set_value(level, percent)
```

---

### An image preview gallery built on GtkFlowBox

An adaptive preview grid that automatically adjusts how many cards fit per row to the window's width.

```nim
proc buildPhotoGallery(photoPaths: openArray[string]): GtkFlowBox =
  result = gtk_flow_box_new()
  gtk_flow_box_set_homogeneous(result, 1.gboolean)
  gtk_flow_box_set_row_spacing(result, 8)
  gtk_flow_box_set_column_spacing(result, 8)
  gtk_flow_box_set_min_children_per_line(result, 2)
  gtk_flow_box_set_max_children_per_line(result, 8)
  gtk_flow_box_set_selection_mode(result, GTK_SELECTION_SINGLE)

  for path in photoPaths:
    let picture = gtk_picture_new_for_filename(path.cstring)
    gtk_widget_set_size_request(picture, 120, 120)
    gtk_flow_box_append(result, picture)

  echo "Gallery of ", photoPaths.len, " previews assembled with an adaptive 2-8 per row grid"

let gallery = buildPhotoGallery(["1.jpg", "2.jpg", "3.jpg", "4.jpg", "5.jpg"])
```

---

### An action bar at the bottom of a window with buttons on the edges

A `GtkActionBar` for a multi-select mode with a counter in the center.

```nim
proc buildSelectionActionBar(): GtkActionBar =
  result = gtk_action_bar_new()

  let cancelButton = gtk_button_new_with_label("Cancel")
  gtk_action_bar_pack_start(result, cancelButton)

  let countLabel = gtk_label_new("0 selected")
  gtk_action_bar_set_center_widget(result, countLabel)

  let deleteButton = gtk_button_new_with_label("Delete")
  gtk_widget_add_css_class(deleteButton, "destructive-action")
  gtk_action_bar_pack_end(result, deleteButton)

  echo "Selection-mode action bar assembled: Cancel / counter / Delete"

proc updateSelectionCount(bar: GtkActionBar, count: int) =
  let countLabel = gtk_action_bar_get_center_widget(bar)
  gtk_label_set_text(cast[GtkLabel](countLabel), (($count) & " selected").cstring)

let selectionBar = buildSelectionActionBar()
```

---

### A link to an external resource in descriptive text

A link button embedded in a form's ordinary layout flow, next to a description.

```nim
proc buildLicenseNotice(): GtkBox =
  result = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 4)
  gtk_box_append(result, gtk_label_new("Distributed under the MIT license."))

  let licenseLink = gtk_link_button_new_with_label("https://opensource.org/licenses/MIT", "Learn more")
  gtk_widget_add_css_class(licenseLink, "flat")
  gtk_box_append(result, licenseLink)

  echo "License-notice line with a clickable link assembled"

let licenseNotice = buildLicenseNotice()
```

---

## Quick reference table

| Procedure(s) | Category | Brief description |
|---|---|---|
| `gtk_info_bar_new` | InfoBar (deprecated) | Create an info bar |
| `gtk_info_bar_add_button` | InfoBar (deprecated) | Add a button with a response code |
| `gtk_info_bar_add/remove_child` | InfoBar (deprecated) | Bar content (not buttons) |
| `gtk_info_bar_set/get_message_type` | InfoBar (deprecated) | Message type (color/icon) |
| `gtk_info_bar_set/get_show_close_button` | InfoBar (deprecated) | Built-in close button |
| `gtk_info_bar_set/get_revealed` | InfoBar (deprecated) | Show/hide with animation |
| `gtk_statusbar_new` | Statusbar (deprecated) | Create a status bar |
| `gtk_statusbar_get_context_id` | Statusbar (deprecated) | Message-group identifier |
| `gtk_statusbar_push/pop/remove/remove_all` | Statusbar (deprecated) | Per-context message stack |
| `gtk_level_bar_new`, `_for_interval` | LevelBar | Create a level indicator |
| `gtk_level_bar_set/get_value` | LevelBar | Current level |
| `gtk_level_bar_set/get_min/max_value` | LevelBar | Range bounds |
| `gtk_link_button_new`, `_with_label` | LinkButton | Create a link button |
| `gtk_link_button_set/get_uri` | LinkButton | Target address |
| `gtk_link_button_set/get_visited` | LinkButton | "Visited" visual state |
| `gtk_action_bar_new` | ActionBar | Create an action bar |
| `gtk_action_bar_pack_start/end`, `remove` | ActionBar | Widgets at the bar's edges |
| `gtk_action_bar_set/get_center_widget` | ActionBar | Widget in the bar's center |
| `gtk_search_bar_new` | SearchBar | Create a search bar |
| `gtk_search_bar_set/get_child` | SearchBar | Bar content |
| `gtk_search_bar_set/get_search_mode` | SearchBar | Show/hide the bar |
| `gtk_search_bar_set/get_show_close_button` | SearchBar | Built-in close button |
| `gtk_picture_new`, `_for_file`, `_for_filename` | Picture | Create an image widget |
| `gtk_picture_set/get_file`, `set_filename/pixbuf/paintable` | Picture | Change the image source |
| `gtk_picture_set/get_can_shrink` | Picture | Allow shrinking below natural size |
| `gtk_flow_box_new` | FlowBox | Create a flow of uniform cards |
| `gtk_flow_box_insert/append/prepend/remove` | FlowBox | Add/remove an item |
| `gtk_flow_box_set/get_homogeneous` | FlowBox | Equal size for all items |
| `gtk_flow_box_set/get_row/column_spacing` | FlowBox | Spacing between rows/columns |
| `gtk_flow_box_set/get_min/max_children_per_line` | FlowBox | Min/max items per row |
| `gtk_flow_box_set/get_selection_mode` | FlowBox | Item selection mode |
| `gtk_flow_box_child_new`, `set/get_child`, `get_index` | FlowBox | Explicit creation of a flow item |
| `gtk_viewport_new` | Viewport | Create a scrolling viewport |
| `gtk_viewport_set/get_child` | Viewport | Scrollable content |
| `gtk_viewport_set/get_scroll_to_focus` | Viewport | Auto-scroll to the focused widget |

---

## Summary: which procedure to choose

- **Status message or warning at the top of a window's content** → in new code, a custom widget built on `GtkRevealer` or a banner is preferable to `GtkInfoBar`/`GtkStatusbar` — both are deprecated; if you still need `GtkInfoBar` specifically (for example, for compatibility with existing code), use `gtk_info_bar_set_revealed` to show/hide it rather than `gtk_widget_set_visible`, so you don't lose the built-in animation.
- **An icon from the system theme** → `GtkImage` (helper-widgets reference). **A photo or a variable-size image with preserved aspect ratio** → `GtkPicture`, not `GtkImage` — it's designed specifically for that case.
- **A static level of a value** (charge, volume, signal) → `GtkLevelBar`. **The progress of an ongoing operation** → `GtkProgressBar` (helper-widgets reference) — the two look similar but signal a different meaning to the user.
- **A clickable link to an external resource** → `GtkLinkButton`, which opens the URI itself on click, rather than an ordinary `GtkButton` with a hand-written handler that calls a system URI-opening function.
- **A grid of uniform cards of a variable count** (gallery, tag cloud, icons) → `GtkFlowBox`, not a `GtkGrid` with a fixed number of columns — the flow wraps items on its own as space runs short, adapting to the window's width.
- **A search bar that appears on demand** (`Ctrl+F`) → `GtkSearchBar`, which wraps a `GtkSearchEntry` and provides a built-in show/hide animation, rather than manually controlling an ordinary `GtkSearchEntry`'s visibility via `gtk_widget_set_visible`.
- **A bar of action buttons at the bottom of a window** (not system buttons, but contextual actions — for example, a selection mode) → `GtkActionBar`, visually consistent in style with `GtkHeaderBar`, rather than a `GtkBox` manually styled to look like a bar.
- **A widget that doesn't scroll on its own needs to be placed in a scrollable area** → usually it's enough to simply wrap it directly in a `GtkScrolledWindow` — `GtkScrolledWindow` creates a `GtkViewport` automatically when needed; creating a `GtkViewport` by hand is only necessary for fine-tuning (for example, `scroll_to_focus`).
