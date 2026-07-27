# GTK4 (popups & auxiliary containers: Popover / MenuButton / Expander / Calendar / Overlay / Fixed / AspectFrame) — module reference

> **Import:** `import libGTK4`
> **Scope:** popup windows, a button with a menu, a collapsible section, a calendar, overlaying widgets on top of each other, absolute positioning, and preserving aspect ratio. The tenth part of the wrapper reference series; assumes familiarity with the previous parts, especially `gtk4_core_reference_ru.md` (layout, `GtkWidget`) and `gtk4_window_chrome_dialogs_reference_ru.md` (dialogs, `GMenuModel`-level menus).

The seven widgets in this reference don't form a single thematic group; rather, they're gathered as "things that are often needed but didn't fit into the previous thematic sections": `GtkPopover` — a popup window anchored to a widget; `GtkMenuButton` — a button that opens a `GtkPopover` or a menu on click (a ready-made pairing, often used together); `GtkExpander` — a collapsible/expandable content section; `GtkCalendar` — a date-picker widget; `GtkOverlay` — overlaying widgets on top of the main content; `GtkFixed` — a container with absolute positioning by pixel coordinates; `GtkAspectFrame` — a container that maintains a given aspect ratio for its content.

---

## Table of Contents

I. [GtkPopover](#gtkpopover)
&nbsp;&nbsp;1. [`gtk_popover_new`](#gtk_popover_new)
&nbsp;&nbsp;2. [`gtk_popover_set_child` / `gtk_popover_get_child`](#gtk_popover_set_child--gtk_popover_get_child)
&nbsp;&nbsp;3. [`gtk_popover_popup` / `gtk_popover_popdown`](#gtk_popover_popup--gtk_popover_popdown)
&nbsp;&nbsp;4. [`gtk_widget_get_ancestor`](#gtk_widget_get_ancestor)

II. [GtkMenuButton](#gtkmenubutton)
&nbsp;&nbsp;1. [`gtk_menu_button_new`](#gtk_menu_button_new)
&nbsp;&nbsp;2. [`gtk_menu_button_set_label` / `gtk_menu_button_set_icon_name` / `get_icon_name` / `set_child` / `get_child`](#gtk_menu_button_set_label--gtk_menu_button_set_icon_name--get_icon_name--set_child--get_child)
&nbsp;&nbsp;3. [`gtk_menu_button_set_popover` / `gtk_menu_button_get_popover`](#gtk_menu_button_set_popover--gtk_menu_button_get_popover)
&nbsp;&nbsp;4. [`gtk_menu_button_set_menu_model` / `gtk_menu_button_get_menu_model`](#gtk_menu_button_set_menu_model--gtk_menu_button_get_menu_model)
&nbsp;&nbsp;5. [`gtk_menu_button_get_active` / `gtk_menu_button_set_active` / `popup` / `popdown`](#gtk_menu_button_get_active--gtk_menu_button_set_active--popup--popdown)
&nbsp;&nbsp;6. [`gtk_menu_button_set_direction` / `gtk_menu_button_get_direction`](#gtk_menu_button_set_direction--gtk_menu_button_get_direction)
&nbsp;&nbsp;7. [`gtk_menu_button_set_use_underline` / `gtk_menu_button_get_use_underline`](#gtk_menu_button_set_use_underline--gtk_menu_button_get_use_underline)
&nbsp;&nbsp;8. [`gtk_menu_button_set_has_frame` / `gtk_menu_button_get_has_frame`](#gtk_menu_button_set_has_frame--gtk_menu_button_get_has_frame)
&nbsp;&nbsp;9. [`gtk_menu_button_set_primary` / `gtk_menu_button_get_primary`](#gtk_menu_button_set_primary--gtk_menu_button_get_primary)
&nbsp;&nbsp;10. [`gtk_menu_button_set_create_popup_func`](#gtk_menu_button_set_create_popup_func)
&nbsp;&nbsp;11. [`gtk_menu_button_set_always_show_arrow` / `gtk_menu_button_get_always_show_arrow`](#gtk_menu_button_set_always_show_arrow--gtk_menu_button_get_always_show_arrow)

III. [GtkExpander](#gtkexpander)
&nbsp;&nbsp;1. [`gtk_expander_new` / `gtk_expander_new_with_mnemonic`](#gtk_expander_new--gtk_expander_new_with_mnemonic)
&nbsp;&nbsp;2. [`gtk_expander_set_expanded` / `gtk_expander_get_expanded`](#gtk_expander_set_expanded--gtk_expander_get_expanded)
&nbsp;&nbsp;3. [`gtk_expander_set_label` / `gtk_expander_get_label`](#gtk_expander_set_label--gtk_expander_get_label)
&nbsp;&nbsp;4. [`gtk_expander_set_child` / `gtk_expander_get_child`](#gtk_expander_set_child--gtk_expander_get_child)

IV. [GtkCalendar](#gtkcalendar)
&nbsp;&nbsp;1. [`gtk_calendar_new`](#gtk_calendar_new)
&nbsp;&nbsp;2. [`gtk_calendar_select_day`](#gtk_calendar_select_day)
&nbsp;&nbsp;3. [`gtk_calendar_mark_day` / `gtk_calendar_unmark_day` / `gtk_calendar_clear_marks`](#gtk_calendar_mark_day--gtk_calendar_unmark_day--gtk_calendar_clear_marks)

V. [GtkOverlay](#gtkoverlay)
&nbsp;&nbsp;1. [`gtk_overlay_new`](#gtk_overlay_new)
&nbsp;&nbsp;2. [`gtk_overlay_set_child` / `gtk_overlay_get_child`](#gtk_overlay_set_child--gtk_overlay_get_child)
&nbsp;&nbsp;3. [`gtk_overlay_add_overlay` / `gtk_overlay_remove_overlay`](#gtk_overlay_add_overlay--gtk_overlay_remove_overlay)

VI. [GtkFixed](#gtkfixed)
&nbsp;&nbsp;1. [`gtk_fixed_new`](#gtk_fixed_new)
&nbsp;&nbsp;2. [`gtk_fixed_put` / `gtk_fixed_move` / `gtk_fixed_remove`](#gtk_fixed_put--gtk_fixed_move--gtk_fixed_remove)

VII. [GtkAspectFrame](#gtkaspectframe)
&nbsp;&nbsp;1. [`gtk_aspect_frame_new`](#gtk_aspect_frame_new)
&nbsp;&nbsp;2. [`gtk_aspect_frame_set_xalign` / `get_xalign` / `set_yalign` / `get_yalign`](#gtk_aspect_frame_set_xalign--get_xalign--set_yalign--get_yalign)
&nbsp;&nbsp;3. [`gtk_aspect_frame_set_ratio` / `gtk_aspect_frame_get_ratio`](#gtk_aspect_frame_set_ratio--gtk_aspect_frame_get_ratio)
&nbsp;&nbsp;4. [`gtk_aspect_frame_set_obey_child` / `gtk_aspect_frame_get_obey_child`](#gtk_aspect_frame_set_obey_child--gtk_aspect_frame_get_obey_child)
&nbsp;&nbsp;5. [`gtk_aspect_frame_set_child` / `gtk_aspect_frame_get_child`](#gtk_aspect_frame_set_child--gtk_aspect_frame_get_child)

VIII. [Practical recipes](#practical-recipes)
&nbsp;&nbsp;1. [A button with a dropdown actions menu](#a-button-with-a-dropdown-actions-menu)
&nbsp;&nbsp;2. [A button with arbitrary popup content (not a menu)](#a-button-with-arbitrary-popup-content-not-a-menu)
&nbsp;&nbsp;3. [A collapsed-by-default "Advanced options" section](#a-collapsed-by-default-advanced-options-section)
&nbsp;&nbsp;4. [A badge icon over an image via GtkOverlay](#a-badge-icon-over-an-image-via-gtkoverlay)
&nbsp;&nbsp;5. [Video/image preserving a 16:9 aspect ratio](#videoimage-preserving-a-169-aspect-ratio)

IX. [Quick reference table](#quick-reference-table)

X. [Summary: which procedure to choose](#summary-which-procedure-to-choose)

---

## GtkPopover

`GtkPopover` is a popup window visually anchored to a specific widget (it appears next to it, with a pointer arrow toward that widget) and closes automatically on an outside click or loss of focus. It's used as a building block for more specialized widgets (`GtkMenuButton` in section II uses `GtkPopover` under the hood), but it can also be used directly for arbitrary popup content — not necessarily a menu.

### `gtk_popover_new`

```nim
proc gtk_popover_new*(): GtkPopover
```

**What it does.** Creates a popover with no parent and no content. The parent is set separately via the general `gtk_widget_set_parent(popover, parent)` function (core reference — `GtkPopover` has no dedicated parent setter); the content is set via `gtk_popover_set_child` below.

- No parameters.

```nim
let infoPopover = gtk_popover_new()
gtk_widget_set_parent(infoPopover, infoButton)
echo "Popover created and anchored to the info button"
```

---

### `gtk_popover_set_child` / `gtk_popover_get_child`

```nim
proc gtk_popover_set_child*(popover: GtkPopover, child: GtkWidget)
proc gtk_popover_get_child*(popover: GtkPopover): GtkWidget
```

**What it does.** Sets and reads the popover's single child widget — the same "one content slot" pattern as `gtk_window_set_child`. For multiple elements inside the popover, a container (`GtkBox`/`GtkGrid` from the core reference) is made the single child.

- `popover` — the popover.
- `child` — the content widget.

```nim
let infoContent = gtk_box_new(GTK_ORIENTATION_VERTICAL, 8)
gtk_box_append(infoContent, gtk_label_new("App version: 1.3"))
gtk_popover_set_child(infoPopover, infoContent)
echo "Popover content set"
```

---

### `gtk_popover_popup` / `gtk_popover_popdown`

```nim
proc gtk_popover_popup*(popover: GtkPopover)
proc gtk_popover_popdown*(popover: GtkPopover)
```

**What it does.** Programmatically shows and hides the popover — for example, to show a tooltip or mini-panel on a click on an arbitrary widget (not necessarily a button) that the `GtkPopover` was anchored to via `gtk_widget_set_parent`.

- `popover` — the popover.

```nim
proc onInfoButtonClicked(button: GtkButton, userData: gpointer) {.cdecl.} =
  gtk_popover_popup(infoPopover)
  echo "Info popover shown"

discard g_signal_connect(infoButton, "clicked", onInfoButtonClicked, nil)
```

---

### `gtk_widget_get_ancestor`

```nim
proc gtk_widget_get_ancestor*(widget: GtkWidget, widget_type: GType): GtkWidget
```

**What it does.** Although formally this is a `GtkWidget` function, not a `GtkPopover` one, it's especially useful in the context of popovers: it finds the nearest ancestor of a widget of a given type, walking up the tree of parents — for example, to get the `GtkPopover` object itself from a click handler inside the popover's content, without passing it separately via the signal's `userData`.

- `widget` — the widget to start the upward search from.
- `widget_type` — the type to search for (`GType`, obtained e.g. via `gtk_popover_get_type()`).

```nim
let popoverAncestor = gtk_widget_get_ancestor(someButtonInsidePopover, gtk_popover_get_type())
if not isNil(popoverAncestor):
  gtk_popover_popdown(cast[GtkPopover](popoverAncestor))
  echo "Popover containing this button found and closed"
```

---

## GtkMenuButton

`GtkMenuButton` is a button that opens a menu or an arbitrary popup when clicked — the most common way to show a menu in GTK4 (the "hamburger"/three-dot button in a window's title bar, a button with a triangular arrow next to some text). It already contains and manages its own `GtkPopover` internally — there's no need to create one separately if a standard menu or arbitrary content via `set_popover` is enough.

### `gtk_menu_button_new`

```nim
proc gtk_menu_button_new*(): GtkMenuButton
```

**What it does.** Creates a menu button with no content (text/icon) and no menu/popover assigned — both are configured separately by subsequent calls.

- No parameters.

```nim
let menuButton = gtk_menu_button_new()
echo "Menu button created"
```

---

### `gtk_menu_button_set_label` / `gtk_menu_button_set_icon_name` / `get_icon_name` / `set_child` / `get_child`

```nim
proc gtk_menu_button_set_label*(button: GtkMenuButton, label: cstring)
proc gtk_menu_button_set_icon_name*(menuButton: GtkMenuButton, iconName: cstring)
proc gtk_menu_button_get_icon_name*(menuButton: GtkMenuButton): cstring
proc gtk_menu_button_set_child*(menuButton: GtkMenuButton, child: GtkWidget)
proc gtk_menu_button_get_child*(menuButton: GtkMenuButton): GtkWidget
```

**What it does.** Three mutually exclusive ways to set the button's visible content — the same choice logic as an ordinary `GtkButton` (core controls reference): plain text (`set_label`), an icon by name from the theme (`set_icon_name`/`get_icon_name`), or a fully arbitrary widget (`set_child`/`get_child`) for complex cases like an icon together with text.

- `button`/`menuButton` — the menu button.
- `label` — the button text.
- `iconName` — the icon name in the theme.
- `child` — an arbitrary content widget.

```nim
gtk_menu_button_set_icon_name(menuButton, "open-menu-symbolic")
echo "Menu button shows the standard 'hamburger' icon"
```

---

### `gtk_menu_button_set_popover` / `gtk_menu_button_get_popover`

```nim
proc gtk_menu_button_set_popover*(menuButton: GtkMenuButton, popover: GtkWidget)
proc gtk_menu_button_get_popover*(menuButton: GtkMenuButton): GtkPopover
```

**What it does.** Links the button to an arbitrary `GtkPopover` (section I) as the popup content opened on click — used when what's needed isn't a ready-made menu but fully arbitrary content (a form, a preview list, anything). There's no need to separately create and position a `GtkPopover` manually via `gtk_widget_set_parent` — `GtkMenuButton` takes care of that after `set_popover`.

- `menuButton` — the menu button.
- `popover` — the popover (accepts a `GtkWidget`, though a `GtkPopover` is expected specifically — in this wrapper both types are interchangeable as `pointer`).

```nim
let customPopover = gtk_popover_new()
gtk_popover_set_child(customPopover, gtk_calendar_new())
gtk_menu_button_set_popover(menuButton, customPopover)
echo "The button now opens a popup calendar instead of an ordinary menu"
```

---

### `gtk_menu_button_set_menu_model` / `gtk_menu_button_get_menu_model`

```nim
proc gtk_menu_button_set_menu_model*(menuButton: GtkMenuButton, menuModel: GMenuModel)
proc gtk_menu_button_get_menu_model*(menuButton: GtkMenuButton): GMenuModel
```

**What it does.** Links the button to a menu model (`GMenuModel`, the same model used in `gtk_application_set_menubar` from the window chrome reference) — GTK automatically builds a `GtkPopover` with menu items from this model, with no need to manually assemble the item list out of widgets. This is the preferred way to show a classic menu with items (as opposed to `set_popover`, which is needed for non-standard content).

- `menuButton` — the menu button.
- `menuModel` — the menu model.

```nim
# actionsMenuModel is built beforehand via g_menu_new/g_menu_append
# (window chrome reference, the GtkApplication section)
gtk_menu_button_set_menu_model(menuButton, actionsMenuModel)
echo "Menu button automatically built a dropdown item list from the model"
```

---

### `gtk_menu_button_get_active` / `gtk_menu_button_set_active` / `popup` / `popdown`

```nim
proc gtk_menu_button_get_active*(menuButton: GtkMenuButton): gboolean
proc gtk_menu_button_set_active*(menuButton: GtkMenuButton, active: gboolean)
proc gtk_menu_button_popup*(menuButton: GtkMenuButton)
proc gtk_menu_button_popdown*(menuButton: GtkMenuButton)
```

**What it does.** Programmatically opens/closes the menu and checks whether it's currently open. `set_active`/`get_active` work via a boolean state property (consistent with the other "active" states of toggle-style widgets in this wrapper); `popup`/`popdown` are direct open/close commands, functionally equivalent to `set_active(true)`/`set_active(false)`.

- `menuButton` — the menu button.
- `active` — `1.gboolean` for the open state.

```nim
gtk_menu_button_popup(menuButton)
echo "Menu opened programmatically, without a user click"
```

---

### `gtk_menu_button_set_direction` / `gtk_menu_button_get_direction`

```nim
proc gtk_menu_button_set_direction*(menuButton: GtkMenuButton, direction: GtkArrowType)
proc gtk_menu_button_get_direction*(menuButton: GtkMenuButton): GtkArrowType
```

**What it does.** Sets which side of the button the popup menu appears on, and at the same time the direction of the arrow indicator on the button itself (if it's shown, see `set_always_show_arrow` below): `GTK_ARROW_DOWN` (the default), `_UP`, `_LEFT`, `_RIGHT`.

- `menuButton` — the menu button.
- `direction` — a `GtkArrowType` value.

```nim
gtk_menu_button_set_direction(bottomToolbarMenuButton, GTK_ARROW_UP)
echo "The menu of the button at the bottom of the screen now opens upward"
```

---

### `gtk_menu_button_set_use_underline` / `gtk_menu_button_get_use_underline`

```nim
proc gtk_menu_button_set_use_underline*(menuButton: GtkMenuButton, useUnderline: gboolean)
proc gtk_menu_button_get_use_underline*(menuButton: GtkMenuButton): gboolean
```

**What it does.** Enables/disables interpreting the `_` character in the button's text (`set_label`) as a mnemonic marker — the same logic as `gtk_button_set_use_underline` from the core controls reference.

- `menuButton` — the menu button.
- `useUnderline` — `1.gboolean` to enable mnemonic interpretation.

```nim
gtk_menu_button_set_use_underline(menuButton, 1.gboolean)
gtk_menu_button_set_label(menuButton, "_File")  # Alt+F opens the menu
```

---

### `gtk_menu_button_set_has_frame` / `gtk_menu_button_get_has_frame`

```nim
proc gtk_menu_button_set_has_frame*(menuButton: GtkMenuButton, hasFrame: gboolean)
proc gtk_menu_button_get_has_frame*(menuButton: GtkMenuButton): gboolean
```

**What it does.** Removes/restores the button's standard frame — the same logic as `gtk_button_set_has_frame`. Often disabled for menu buttons in a header bar (`GtkHeaderBar`), where a flat look is visually more fitting.

- `menuButton` — the menu button.
- `hasFrame` — `0.gboolean` to remove the frame.

```nim
gtk_menu_button_set_has_frame(menuButton, 0.gboolean)
echo "The menu button in the window title bar is now flat, with no frame"
```

---

### `gtk_menu_button_set_primary` / `gtk_menu_button_get_primary`

```nim
proc gtk_menu_button_set_primary*(menuButton: GtkMenuButton, primary: gboolean)
proc gtk_menu_button_get_primary*(menuButton: GtkMenuButton): gboolean
```

**What it does.** Marks the menu button as "primary" for the window — affects positioning and behavior in the context of the header bar (for example, the app's main menu button, usually the only one of its kind per window, as opposed to auxiliary menu buttons that open context menus for individual interface elements).

- `menuButton` — the menu button.
- `primary` — `1.gboolean` for the window's primary menu button.

```nim
gtk_menu_button_set_primary(appMenuButton, 1.gboolean)
echo "Button marked as the application's primary menu"
```

---

### `gtk_menu_button_set_create_popup_func`

```nim
proc gtk_menu_button_set_create_popup_func*(menuButton: GtkMenuButton, callback: pointer, userData: pointer, destroyNotify: pointer)
```

**What it does.** Assigns a function called immediately before every menu opening — lets you dynamically rebuild the popup's content (for example, refresh a recent-files list) right before it's shown, instead of keeping it up to date all the time. An alternative to the static `set_menu_model`/`set_popover` set once in advance.

- `menuButton` — the menu button.
- `callback` — pointer to a C-compatible function called before opening.
- `userData` — user data passed to `callback`.
- `destroyNotify` — cleanup function for `userData` (`nil` can be passed).

```nim
proc onCreatePopup(button: GtkMenuButton, userData: gpointer) {.cdecl.} =
  let freshPopover = gtk_popover_new()
  # ... populate with fresh data, e.g. a list of recent files ...
  gtk_menu_button_set_popover(button, freshPopover)
  echo "Menu content rebuilt right before opening"

gtk_menu_button_set_create_popup_func(recentFilesButton, onCreatePopup, nil, nil)
```

---

### `gtk_menu_button_set_always_show_arrow` / `gtk_menu_button_get_always_show_arrow`

```nim
proc gtk_menu_button_set_always_show_arrow*(menuButton: GtkMenuButton, alwaysShowArrow: gboolean)
proc gtk_menu_button_get_always_show_arrow*(menuButton: GtkMenuButton): gboolean
```

**What it does.** Controls whether a small arrow indicator is shown next to the button's content, signaling to the user that this is a dropdown-menu button rather than an ordinary action button. For icon-only buttons (e.g. a "hamburger"), the arrow is usually redundant and isn't shown by default; for buttons with text, it's the opposite — often expected by the user.

- `menuButton` — the menu button.
- `alwaysShowArrow` — `1.gboolean` to always show the arrow.

```nim
gtk_menu_button_set_always_show_arrow(fileMenuButton, 1.gboolean)
echo "The menu indicator arrow is now always visible next to the 'File' text"
```

---

## GtkExpander

`GtkExpander` is a collapsible section: a clickable header with a triangular indicator and content underneath that can be hidden/shown. A typical use is "Advanced options" in a form, collapsed by default.

### `gtk_expander_new` / `gtk_expander_new_with_mnemonic`

```nim
proc gtk_expander_new*(label: cstring): GtkExpander
proc gtk_expander_new_with_mnemonic*(label: cstring): GtkExpander
```

**What it does.** Creates a section, collapsed by default, with a text header. The `_with_mnemonic` variant interprets `_` before a letter as a mnemonic marker — the same logic as `gtk_button_new_with_mnemonic`.

- `label` — the header text.

```nim
let advancedExpander = gtk_expander_new("Advanced options")
echo "Collapsed 'Advanced options' section created"
```

---

### `gtk_expander_set_expanded` / `gtk_expander_get_expanded`

```nim
proc gtk_expander_set_expanded*(expander: GtkExpander, expanded: gboolean)
proc gtk_expander_get_expanded*(expander: GtkExpander): gboolean
```

**What it does.** Programmatically expands/collapses the section and reads its current state — for example, to remember between application runs whether the section was expanded last time.

- `expander` — the section.
- `expanded` — `1.gboolean` for the expanded state.

```nim
gtk_expander_set_expanded(advancedExpander, 1.gboolean)
echo "Section expanded: ", gtk_expander_get_expanded(advancedExpander) != 0.gboolean
```

---

### `gtk_expander_set_label` / `gtk_expander_get_label`

```nim
proc gtk_expander_set_label*(expander: GtkExpander, label: cstring)
proc gtk_expander_get_label*(expander: GtkExpander): cstring
```

**What it does.** Sets and reads the header text after the section has already been created.

- `expander` — the section.
- `label` — the new header text.

```nim
gtk_expander_set_label(advancedExpander, "Advanced options (3)")
echo "Section header updated: ", $gtk_expander_get_label(advancedExpander)
```

---

### `gtk_expander_set_child` / `gtk_expander_get_child`

```nim
proc gtk_expander_set_child*(expander: GtkExpander, child: GtkWidget)
proc gtk_expander_get_child*(expander: GtkExpander): GtkWidget
```

**What it does.** Sets and reads the single child widget — the content that gets hidden/shown when the section is collapsed/expanded. For multiple elements, a container is made the single child.

- `expander` — the section.
- `child` — the content widget.

```nim
let advancedOptions = gtk_box_new(GTK_ORIENTATION_VERTICAL, 8)
gtk_box_append(advancedOptions, gtk_check_button_new_with_label("Verbose logging"))
gtk_expander_set_child(advancedExpander, advancedOptions)
echo "Section content set — will be hidden while the section is collapsed"
```

---

## GtkCalendar

`GtkCalendar` is a date-picker widget shown as a monthly calendar, with the ability to mark individual days.

### `gtk_calendar_new`

```nim
proc gtk_calendar_new*(): GtkCalendar
```

**What it does.** Creates a calendar initially showing the current month with today's date selected.

- No parameters.

```nim
let eventCalendar = gtk_calendar_new()
echo "Calendar created, showing the current month"
```

---

### `gtk_calendar_select_day`

```nim
proc gtk_calendar_select_day*(calendar: GtkCalendar, day: gint)
```

**What it does.** Programmatically selects a day **within the currently displayed month** — this function only accepts the day-of-month number (1–31), not a full date with year and month.

- `calendar` — the calendar.
- `day` — the day-of-month number.

```nim
gtk_calendar_select_day(eventCalendar, 15)
echo "Day 15 of the currently displayed month selected"
```

---

### `gtk_calendar_mark_day` / `gtk_calendar_unmark_day` / `gtk_calendar_clear_marks`

```nim
proc gtk_calendar_mark_day*(calendar: GtkCalendar, day: gint)
proc gtk_calendar_unmark_day*(calendar: GtkCalendar, day: gint)
proc gtk_calendar_clear_marks*(calendar: GtkCalendar)
```

**What it does.** Marks/unmarks a specific day with a visual indicator (usually a dot under the number) — independent of the day selection. `clear_marks` removes all marks for the current month at once. A typical use is showing days with scheduled events separately from the selected day.

- `calendar` — the calendar.
- `day` — the day-of-month number.

```nim
for eventDay in [3, 10, 22]:
  gtk_calendar_mark_day(eventCalendar, gint(eventDay))
echo "Days with scheduled events marked with dots"
gtk_calendar_clear_marks(eventCalendar)
```

---

## GtkOverlay

`GtkOverlay` shows one main child widget and an arbitrary number of additional widgets layered on top of it. A typical use is a badge icon over an icon, a watermark over an image, a floating button over a map.

### `gtk_overlay_new`

```nim
proc gtk_overlay_new*(): GtkOverlay
```

**What it does.** Creates an empty overlay container.

- No parameters.

```nim
let overlay = gtk_overlay_new()
echo "Overlay container created"
```

---

### `gtk_overlay_set_child` / `gtk_overlay_get_child`

```nim
proc gtk_overlay_set_child*(overlay: GtkOverlay, child: GtkWidget)
proc gtk_overlay_get_child*(overlay: GtkOverlay): GtkWidget
```

**What it does.** Sets and reads the main (bottom, background) widget — the one over which the widgets added via `add_overlay` are shown. It's the main widget that determines the size of the whole container.

- `overlay` — the overlay container.
- `child` — the main widget.

```nim
let mapImage = gtk_image_new_from_file("/usr/share/myapp/map.png")
gtk_overlay_set_child(overlay, mapImage)
echo "Map image set as the main (background) content"
```

---

### `gtk_overlay_add_overlay` / `gtk_overlay_remove_overlay`

```nim
proc gtk_overlay_add_overlay*(overlay: GtkOverlay, widget: GtkWidget)
proc gtk_overlay_remove_overlay*(overlay: GtkOverlay, widget: GtkWidget)
```

**What it does.** Adds/removes a widget layered on top of the main content. Several overlaid widgets can be added — each positioned independently via `gtk_widget_set_halign`/`set_valign`/`set_margin_*`.

- `overlay` — the overlay container.
- `widget` — the widget being added/removed.

```nim
let locationButton = gtk_button_new_from_icon_name("find-location-symbolic")
gtk_widget_set_halign(locationButton, GTK_ALIGN_END)
gtk_widget_set_valign(locationButton, GTK_ALIGN_END)
gtk_widget_set_margin_end(locationButton, 16)
gtk_widget_set_margin_bottom(locationButton, 16)
gtk_overlay_add_overlay(overlay, locationButton)
echo "Floating location button placed in the bottom-right corner over the map"
```

---

## GtkFixed

`GtkFixed` is a container with absolute positioning: each child widget is placed at explicit pixel coordinates, with no automatic layout. Unlike the other containers in this reference series, `GtkFixed` **does not adapt** to changes in window size, font, or localization — the GTK documentation doesn't recommend using it for ordinary interfaces, preferring it for specialized scenarios (canvas-like editors).

### `gtk_fixed_new`

```nim
proc gtk_fixed_new*(): GtkFixed
```

**What it does.** Creates an empty absolute-positioning container.

- No parameters.

```nim
let canvas = gtk_fixed_new()
echo "Absolute-positioning container created"
```

---

### `gtk_fixed_put` / `gtk_fixed_move` / `gtk_fixed_remove`

```nim
proc gtk_fixed_put*(fixed: GtkFixed, widget: GtkWidget, x: gdouble, y: gdouble)
proc gtk_fixed_move*(fixed: GtkFixed, widget: GtkWidget, x: gdouble, y: gdouble)
proc gtk_fixed_remove*(fixed: GtkFixed, widget: GtkWidget)
```

**What it does.** `put` adds a new widget at the given coordinates (from the container's top-left corner). `move` moves an already-added widget to new coordinates. `remove` removes the widget.

- `fixed` — the container.
- `widget` — the widget being added/moved/removed.
- `x`, `y` — coordinates in pixels.

```nim
let draggableNode = gtk_button_new_with_label("Node A")
gtk_fixed_put(canvas, draggableNode, 50.0, 80.0)
echo "Node placed at coordinates (50, 80)"
gtk_fixed_move(canvas, draggableNode, 120.0, 200.0)
echo "Node moved to new coordinates (120, 200)"
```

---

## GtkAspectFrame

`GtkAspectFrame` is a container that maintains a given aspect ratio for its single child widget regardless of the space allocated — the content stays fitted while preserving its proportions (like a video player with black bars).

### `gtk_aspect_frame_new`

```nim
proc gtk_aspect_frame_new*(xalign: gfloat, yalign: gfloat, ratio: gfloat, obeyChild: gboolean): GtkAspectFrame
```

**What it does.** Creates a container with the given initial parameters. `xalign`/`yalign` — the position of the content within the allocated area (from `0.0` to `1.0`, the same logic as `gtk_label_set_xalign`). `ratio` — the desired width-to-height ratio (e.g. `16.0/9.0` for video). `obeyChild`: `1.gboolean` — use the child widget's natural aspect ratio, ignoring `ratio`; `0.gboolean` — use exactly the specified `ratio` value.

- `xalign`, `yalign` — content alignment from `0.0` to `1.0`.
- `ratio` — the width/height aspect ratio.
- `obeyChild` — `1.gboolean` to use the content's own proportions.

```nim
let videoFrame = gtk_aspect_frame_new(0.5, 0.5, 16.0 / 9.0, 0.gboolean)
echo "Container with a fixed 16:9 aspect ratio created, content centered"
```

---

### `gtk_aspect_frame_set_xalign` / `get_xalign` / `set_yalign` / `get_yalign`

```nim
proc gtk_aspect_frame_set_xalign*(aspectFrame: GtkAspectFrame, xalign: gfloat)
proc gtk_aspect_frame_get_xalign*(aspectFrame: GtkAspectFrame): gfloat
proc gtk_aspect_frame_set_yalign*(aspectFrame: GtkAspectFrame, yalign: gfloat)
proc gtk_aspect_frame_get_yalign*(aspectFrame: GtkAspectFrame): gfloat
```

**What it does.** Changes the alignment of the content within the allocated area after the container has already been created.

- `aspectFrame` — the container.
- `xalign`, `yalign` — values from `0.0` to `1.0`.

```nim
gtk_aspect_frame_set_yalign(videoFrame, 0.0)
echo "The video is now pinned to the top edge of the allocated area"
```

---

### `gtk_aspect_frame_set_ratio` / `gtk_aspect_frame_get_ratio`

```nim
proc gtk_aspect_frame_set_ratio*(aspectFrame: GtkAspectFrame, ratio: gfloat)
proc gtk_aspect_frame_get_ratio*(aspectFrame: GtkAspectFrame): gfloat
```

**What it does.** Changes the desired aspect ratio after the container has already been created — for example, when switching the displayed video to a different aspect ratio.

- `aspectFrame` — the container.
- `ratio` — the width/height aspect ratio.

```nim
gtk_aspect_frame_set_ratio(videoFrame, 21.0 / 9.0)
echo "Aspect ratio switched to widescreen 21:9"
```

---

### `gtk_aspect_frame_set_obey_child` / `gtk_aspect_frame_get_obey_child`

```nim
proc gtk_aspect_frame_set_obey_child*(aspectFrame: GtkAspectFrame, obeyChild: gboolean)
proc gtk_aspect_frame_get_obey_child*(aspectFrame: GtkAspectFrame): gboolean
```

**What it does.** Switches the source of the aspect ratio between an explicit `ratio` value and the child widget's natural proportions.

- `aspectFrame` — the container.
- `obeyChild` — `1.gboolean` to use the content's own proportions.

```nim
gtk_aspect_frame_set_obey_child(videoFrame, 1.gboolean)
echo "The aspect ratio is now determined by the image itself, not by the given ratio"
```

---

### `gtk_aspect_frame_set_child` / `gtk_aspect_frame_get_child`

```nim
proc gtk_aspect_frame_set_child*(aspectFrame: GtkAspectFrame, child: GtkWidget)
proc gtk_aspect_frame_get_child*(aspectFrame: GtkAspectFrame): GtkWidget
```

**What it does.** Sets and reads the single child widget — the same "one content slot" pattern.

- `aspectFrame` — the container.
- `child` — the content widget.

```nim
gtk_aspect_frame_set_child(videoFrame, videoPlayerWidget)
echo "Video player fitted into the container while preserving the aspect ratio"
```

---

## Practical recipes

### A button with a dropdown actions menu

The classic "hamburger" button in a window's title bar, opening a menu built from a `GMenuModel`.

```nim
proc buildAppMenuButton(): GtkMenuButton =
  result = gtk_menu_button_new()
  gtk_menu_button_set_icon_name(result, "open-menu-symbolic")
  gtk_menu_button_set_primary(result, 1.gboolean)

  let menu = g_menu_new()
  g_menu_append(menu, "Preferences", "app.preferences")
  g_menu_append(menu, "About", "app.about")
  gtk_menu_button_set_menu_model(result, cast[GMenuModel](menu))

  echo "Application menu button with 'Preferences' and 'About' items assembled"

let appMenuButton = buildAppMenuButton()
```

---

### A button with arbitrary popup content (not a menu)

A button that opens a quick-settings mini-form instead of a standard menu with items.

```nim
proc buildQuickSettingsButton(): GtkMenuButton =
  result = gtk_menu_button_new()
  gtk_menu_button_set_icon_name(result, "preferences-system-symbolic")

  let popover = gtk_popover_new()
  let content = gtk_box_new(GTK_ORIENTATION_VERTICAL, 8)
  gtk_widget_set_margin_start(content, 12)
  gtk_widget_set_margin_end(content, 12)
  gtk_widget_set_margin_top(content, 12)
  gtk_widget_set_margin_bottom(content, 12)

  let brightnessScale = gtk_scale_new_with_range(GTK_ORIENTATION_HORIZONTAL, 0.0, 100.0, 5.0)
  gtk_box_append(content, gtk_label_new("Brightness"))
  gtk_box_append(content, brightnessScale)

  gtk_popover_set_child(popover, content)
  gtk_menu_button_set_popover(result, popover)
  echo "Quick-settings button with a brightness slider inside a popover assembled"

let quickSettingsButton = buildQuickSettingsButton()
```

---

### A collapsed-by-default "Advanced options" section

A form with required fields immediately visible, and optional ones hidden inside a `GtkExpander`.

```nim
proc buildExportForm(): GtkBox =
  result = gtk_box_new(GTK_ORIENTATION_VERTICAL, 12)

  let formatCombo = gtk_combo_box_text_new()
  gtk_combo_box_text_append_text(formatCombo, "PNG")
  gtk_combo_box_text_append_text(formatCombo, "JPEG")
  gtk_combo_box_set_active(formatCombo, 0)
  gtk_box_append(result, formatCombo)

  let advanced = gtk_expander_new("Advanced options")
  let advancedContent = gtk_box_new(GTK_ORIENTATION_VERTICAL, 6)
  gtk_box_append(advancedContent, gtk_check_button_new_with_label("Preserve metadata"))
  gtk_box_append(advancedContent, gtk_check_button_new_with_label("Optimize file size"))
  gtk_expander_set_child(advanced, advancedContent)
  gtk_box_append(result, advanced)

  echo "Export form: format visible right away, rare options hidden in a collapsed section"

let exportForm = buildExportForm()
```

---

### A badge icon over an image via GtkOverlay

An unread-notifications counter shown as a small circle over an icon.

```nim
proc buildIconWithBadge(iconName: string, count: int): GtkOverlay =
  result = gtk_overlay_new()

  let icon = gtk_image_new_from_icon_name(iconName.cstring)
  gtk_image_set_pixel_size(icon, 32)
  gtk_overlay_set_child(result, icon)

  if count > 0:
    let badge = gtk_label_new($count)
    gtk_widget_add_css_class(badge, "badge")
    gtk_widget_set_halign(badge, GTK_ALIGN_END)
    gtk_widget_set_valign(badge, GTK_ALIGN_START)
    gtk_overlay_add_overlay(result, badge)

  echo "Icon with a count badge (", count, ") assembled"

let notificationsIcon = buildIconWithBadge("mail-symbolic", 5)
```

---

### Video/image preserving a 16:9 aspect ratio

A video preview area that never distorts the frame's proportions regardless of window size.

```nim
proc buildVideoPreviewArea(): GtkAspectFrame =
  result = gtk_aspect_frame_new(0.5, 0.5, 16.0 / 9.0, 0.gboolean)
  gtk_widget_add_css_class(result, "video-frame-background")

  let videoDrawing = gtk_drawing_area_new()
  gtk_aspect_frame_set_child(result, videoDrawing)
  echo "Video preview area with a fixed 16:9 aspect ratio ready"

let videoPreview = buildVideoPreviewArea()
```

---

## Quick reference table

| Procedure(s) | Category | What it does, briefly |
|---|---|---|
| `gtk_popover_new` | Popover | Create a popover |
| `gtk_popover_set/get_child` | Popover | The single child widget |
| `gtk_popover_popup/popdown` | Popover | Programmatically show/hide |
| `gtk_widget_get_ancestor` | Popover/Widget | Find the nearest ancestor of a given type |
| `gtk_menu_button_new` | MenuButton | Create a button with a menu |
| `gtk_menu_button_set_label`, `set/get_icon_name`, `set/get_child` | MenuButton | The button's visible content |
| `gtk_menu_button_set/get_popover` | MenuButton | Arbitrary popup content |
| `gtk_menu_button_set/get_menu_model` | MenuButton | A ready-made menu from GMenuModel |
| `gtk_menu_button_get/set_active`, `popup`, `popdown` | MenuButton | Programmatic control of opening |
| `gtk_menu_button_set/get_direction` | MenuButton | Which side the menu opens from |
| `gtk_menu_button_set/get_use_underline` | MenuButton | Mnemonic in the button text |
| `gtk_menu_button_set/get_has_frame` | MenuButton | The button's frame |
| `gtk_menu_button_set/get_primary` | MenuButton | The window's primary menu button |
| `gtk_menu_button_set_create_popup_func` | MenuButton | Rebuild content before each opening |
| `gtk_menu_button_set/get_always_show_arrow` | MenuButton | The menu indicator arrow |
| `gtk_expander_new`, `_with_mnemonic` | Expander | Create a collapsible section |
| `gtk_expander_set/get_expanded` | Expander | Whether the section is expanded |
| `gtk_expander_set/get_label` | Expander | The header text |
| `gtk_expander_set/get_child` | Expander | The content that's hidden/shown |
| `gtk_calendar_new` | Calendar | Create a calendar |
| `gtk_calendar_select_day` | Calendar | Select a day in the current month |
| `gtk_calendar_mark/unmark_day`, `clear_marks` | Calendar | Visual day markers |
| `gtk_overlay_new` | Overlay | Create an overlay container |
| `gtk_overlay_set/get_child` | Overlay | The main (background) widget |
| `gtk_overlay_add/remove_overlay` | Overlay | Widgets layered on top |
| `gtk_fixed_new` | Fixed | Create an absolute-positioning container |
| `gtk_fixed_put`, `move`, `remove` | Fixed | Place/move/remove by coordinates |
| `gtk_aspect_frame_new` | AspectFrame | Create a container with a fixed aspect ratio |
| `gtk_aspect_frame_set/get_xalign`, `set/get_yalign` | AspectFrame | Content alignment within the area |
| `gtk_aspect_frame_set/get_ratio` | AspectFrame | The desired aspect ratio |
| `gtk_aspect_frame_set/get_obey_child` | AspectFrame | Ratio source — the ratio or the content itself |
| `gtk_aspect_frame_set/get_child` | AspectFrame | The single child widget |

---

## Summary: which procedure to choose

- **A button that opens a list of menu items** → `gtk_menu_button_set_menu_model` with a ready-made `GMenuModel` — GTK builds the popup list itself, no need to manually assemble item widgets. **A button that opens arbitrary content** (a form, a calendar, anything other than an item list) → `gtk_menu_button_set_popover` with a self-assembled `GtkPopover`.
- **Popup content needed outside the context of a button** (anchored to an arbitrary widget, not necessarily a button) → `GtkPopover` directly via `gtk_widget_set_parent` + `gtk_popover_popup`/`popdown`, rather than `GtkMenuButton`, which is tightly bound to a button.
- **Hide rarely needed options without removing them entirely** → `GtkExpander`, collapsed by default (`gtk_expander_set_expanded(false)` is effectively the default value at creation).
- **Overlay one widget on top of another** (a badge, a watermark, a floating button) → `GtkOverlay`, rather than trying to achieve the same thing through absolute positioning in `GtkFixed` — `GtkOverlay` itself follows the main content's size when the window is resized, `GtkFixed` does not.
- **Positioning by absolute coordinates is genuinely necessary** (a canvas editor, where coordinates are part of the data model rather than just layout) → `GtkFixed`, with the understanding that this is a deliberate departure from the adaptive layout GTK provides by default for all the other containers in this reference series.
- **A video/image must not be distorted when the window is resized** → `GtkAspectFrame` with an explicit `ratio`, rather than `gtk_widget_set_size_request` on the content itself — the latter sets a minimum but doesn't preserve proportions when the container stretches.
- **Mark days with events on the calendar, separately from the currently selected day** → `gtk_calendar_mark_day`, rather than `gtk_calendar_select_day` — selection and marking are visually and semantically independent of each other.
