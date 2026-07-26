# GTK4 (basic controls: Button / ToggleButton / CheckButton / Switch / Label) — module reference

> **Import:** `import libGTK4`
> **Scope:** basic interactive and text-display widgets of GTK4 — buttons of all kinds, toggles, and labels. This is the second part of the wrapper reference series; the first part (`gtk4_core_reference_ru.md`) covers initialization, `GtkApplication`/`GApplication`, `GtkWindow`, the base `GtkWidget` interface, and the `GtkBox`/`GtkGrid` containers — the examples in this reference assume familiarity with it (window creation, layout, `g_signal_connect`).

This reference covers: `GtkButton` (a regular button), `GtkToggleButton` (a two-state toggle button), `GtkCheckButton` (checkbox/radio button — in GTK4 these are the same class), `GtkSwitch` (a mobile-UI-style toggle switch), and `GtkLabel` (static or interactive text). The text entry field (`GtkEntry` and related widgets) is covered in a separate text-input reference — the ENTRY section is large enough to warrant its own document.

---

## Table of Contents

I. [GtkButton](#gtkbutton)
&nbsp;&nbsp;1. [`gtk_button_new` / `gtk_button_new_with_label` / `gtk_button_new_with_mnemonic` / `gtk_button_new_from_icon_name`](#gtk_button_new--gtk_button_new_with_label--gtk_button_new_with_mnemonic--gtk_button_new_from_icon_name)
&nbsp;&nbsp;2. [`gtk_button_set_label` / `gtk_button_get_label`](#gtk_button_set_label--gtk_button_get_label)
&nbsp;&nbsp;3. [`gtk_button_set_use_underline` / `gtk_button_get_use_underline`](#gtk_button_set_use_underline--gtk_button_get_use_underline)
&nbsp;&nbsp;4. [`gtk_button_set_child` / `gtk_button_get_child`](#gtk_button_set_child--gtk_button_get_child)
&nbsp;&nbsp;5. [`gtk_button_set_has_frame` / `gtk_button_get_has_frame`](#gtk_button_set_has_frame--gtk_button_get_has_frame)
&nbsp;&nbsp;6. [`gtk_button_set_icon_name` / `gtk_button_get_icon_name`](#gtk_button_set_icon_name--gtk_button_get_icon_name)
&nbsp;&nbsp;7. [`gtk_button_set_can_shrink` / `gtk_button_get_can_shrink`](#gtk_button_set_can_shrink--gtk_button_get_can_shrink)
&nbsp;&nbsp;8. [`gtk_actionable_set_detailed_action_name`](#gtk_actionable_set_detailed_action_name)

II. [GtkToggleButton](#gtktogglebutton)
&nbsp;&nbsp;1. [`gtk_toggle_button_new` / `gtk_toggle_button_new_with_label` / `gtk_toggle_button_new_with_mnemonic`](#gtk_toggle_button_new--gtk_toggle_button_new_with_label--gtk_toggle_button_new_with_mnemonic)
&nbsp;&nbsp;2. [`gtk_toggle_button_set_active` / `gtk_toggle_button_get_active`](#gtk_toggle_button_set_active--gtk_toggle_button_get_active)
&nbsp;&nbsp;3. [`gtk_toggle_button_toggled`](#gtk_toggle_button_toggled)
&nbsp;&nbsp;4. [`gtk_toggle_button_set_group`](#gtk_toggle_button_set_group)

III. [GtkCheckButton](#gtkcheckbutton)
&nbsp;&nbsp;1. [`gtk_check_button_new` / `gtk_check_button_new_with_label` / `gtk_check_button_new_with_mnemonic`](#gtk_check_button_new--gtk_check_button_new_with_label--gtk_check_button_new_with_mnemonic)
&nbsp;&nbsp;2. [`gtk_check_button_set_active` / `gtk_check_button_get_active`](#gtk_check_button_set_active--gtk_check_button_get_active)
&nbsp;&nbsp;3. [`gtk_check_button_set_inconsistent` / `gtk_check_button_get_inconsistent`](#gtk_check_button_set_inconsistent--gtk_check_button_get_inconsistent)
&nbsp;&nbsp;4. [`gtk_check_button_set_group`](#gtk_check_button_set_group)
&nbsp;&nbsp;5. [`gtk_check_button_set_label` / `gtk_check_button_get_label`](#gtk_check_button_set_label--gtk_check_button_get_label)
&nbsp;&nbsp;6. [`gtk_check_button_set_use_underline` / `gtk_check_button_get_use_underline`](#gtk_check_button_set_use_underline--gtk_check_button_get_use_underline)
&nbsp;&nbsp;7. [`gtk_check_button_set_child` / `gtk_check_button_get_child`](#gtk_check_button_set_child--gtk_check_button_get_child)

IV. [GtkSwitch](#gtkswitch)
&nbsp;&nbsp;1. [`gtk_switch_new`](#gtk_switch_new)
&nbsp;&nbsp;2. [`gtk_switch_set_active` / `gtk_switch_get_active`](#gtk_switch_set_active--gtk_switch_get_active)
&nbsp;&nbsp;3. [`gtk_switch_set_state` / `gtk_switch_get_state`](#gtk_switch_set_state--gtk_switch_get_state)

V. [GtkLabel](#gtklabel)
&nbsp;&nbsp;1. [`gtk_label_new` / `gtk_label_new_with_mnemonic`](#gtk_label_new--gtk_label_new_with_mnemonic)
&nbsp;&nbsp;2. [`gtk_label_set_text` / `gtk_label_get_text`](#gtk_label_set_text--gtk_label_get_text)
&nbsp;&nbsp;3. [`gtk_label_set_markup` / `gtk_label_set_markup_with_mnemonic`](#gtk_label_set_markup--gtk_label_set_markup_with_mnemonic)
&nbsp;&nbsp;4. [`gtk_label_set_use_markup` / `gtk_label_get_use_markup`](#gtk_label_set_use_markup--gtk_label_get_use_markup)
&nbsp;&nbsp;5. [`gtk_label_set_use_underline` / `gtk_label_get_use_underline`](#gtk_label_set_use_underline--gtk_label_get_use_underline)
&nbsp;&nbsp;6. [`gtk_label_set_justify` / `gtk_label_get_justify`](#gtk_label_set_justify--gtk_label_get_justify)
&nbsp;&nbsp;7. [`gtk_label_set_wrap` / `gtk_label_get_wrap` / `gtk_label_set_wrap_mode` / `gtk_label_get_wrap_mode`](#gtk_label_set_wrap--gtk_label_get_wrap--gtk_label_set_wrap_mode--gtk_label_get_wrap_mode)
&nbsp;&nbsp;8. [`gtk_label_set_selectable` / `gtk_label_get_selectable`](#gtk_label_set_selectable--gtk_label_get_selectable)
&nbsp;&nbsp;9. [`gtk_label_set_width_chars` / `gtk_label_get_width_chars` / `gtk_label_set_max_width_chars` / `gtk_label_get_max_width_chars`](#gtk_label_set_width_chars--gtk_label_get_width_chars--gtk_label_set_max_width_chars--gtk_label_get_max_width_chars)
&nbsp;&nbsp;10. [`gtk_label_set_ellipsize` / `gtk_label_get_ellipsize`](#gtk_label_set_ellipsize--gtk_label_get_ellipsize)
&nbsp;&nbsp;11. [`gtk_label_select_region` / `gtk_label_get_selection_bounds`](#gtk_label_select_region--gtk_label_get_selection_bounds)
&nbsp;&nbsp;12. [`gtk_label_set_attributes` / `gtk_label_get_attributes`](#gtk_label_set_attributes--gtk_label_get_attributes)
&nbsp;&nbsp;13. [`gtk_label_set_mnemonic_widget` / `gtk_label_get_mnemonic_widget`](#gtk_label_set_mnemonic_widget--gtk_label_get_mnemonic_widget)
&nbsp;&nbsp;14. [`gtk_label_set_single_line_mode` / `gtk_label_get_single_line_mode`](#gtk_label_set_single_line_mode--gtk_label_get_single_line_mode)
&nbsp;&nbsp;15. [`gtk_label_set_lines` / `gtk_label_get_lines`](#gtk_label_set_lines--gtk_label_get_lines)
&nbsp;&nbsp;16. [`gtk_label_set_xalign` / `gtk_label_get_xalign` / `gtk_label_set_yalign` / `gtk_label_get_yalign`](#gtk_label_set_xalign--gtk_label_get_xalign--gtk_label_set_yalign--gtk_label_get_yalign)
&nbsp;&nbsp;17. [`gtk_label_set_extra_menu` / `gtk_label_get_extra_menu`](#gtk_label_set_extra_menu--gtk_label_get_extra_menu)
&nbsp;&nbsp;18. [`gtk_label_set_natural_wrap_mode` / `gtk_label_get_natural_wrap_mode`](#gtk_label_set_natural_wrap_mode--gtk_label_get_natural_wrap_mode)
&nbsp;&nbsp;19. [`gtk_label_set_tabs` / `gtk_label_get_tabs`](#gtk_label_set_tabs--gtk_label_get_tabs)
&nbsp;&nbsp;20. [`gtk_label_get_current_uri`](#gtk_label_get_current_uri)
&nbsp;&nbsp;21. [`gtk_label_get_layout` / `gtk_label_get_layout_offsets`](#gtk_label_get_layout--gtk_label_get_layout_offsets)

VI. [Practical Recipes](#practical-recipes)
&nbsp;&nbsp;1. [A group of radio buttons built on GtkCheckButton](#a-group-of-radio-buttons-built-on-gtkcheckbutton)
&nbsp;&nbsp;2. [Settings panel: labeled GtkSwitch toggles](#settings-panel-labeled-gtkswitch-toggles)
&nbsp;&nbsp;3. [A button with an icon and text at once](#a-button-with-an-icon-and-text-at-once)
&nbsp;&nbsp;4. [A label with wrapping, ellipsization, and selectable text](#a-label-with-wrapping-ellipsization-and-selectable-text)
&nbsp;&nbsp;5. [Mnemonic: a caption that hands focus to a field via Alt+letter](#mnemonic-a-caption-that-hands-focus-to-a-field-via-altletter)

VII. [Quick Reference Table](#quick-reference-table)

VIII. [Summary: Which Procedure to Choose](#summary-which-procedure-to-choose)

---

## GtkButton

`GtkButton` is a regular pressable button. In GTK4 a button's content is an arbitrary child widget (`gtk_button_set_child`) rather than hard-coded text: the `_with_label`/`_from_icon_name` constructors are just convenience wrappers that create a suitable child widget for you (a `GtkLabel` or a `GtkImage`).

### `gtk_button_new` / `gtk_button_new_with_label` / `gtk_button_new_with_mnemonic` / `gtk_button_new_from_icon_name`

```nim
proc gtk_button_new*(): GtkButton
proc gtk_button_new_with_label*(label: cstring): GtkButton
proc gtk_button_new_with_mnemonic*(label: cstring): GtkButton
proc gtk_button_new_from_icon_name*(icon_name: cstring): GtkButton
```

**What it does.** Four ways to create a button. `gtk_button_new` creates an empty button with no content — the child widget must be set separately via `gtk_button_set_child`. `gtk_button_new_with_label` immediately creates a button with a text caption. `gtk_button_new_with_mnemonic` does the same, but the letter following an underscore `_` in the text (e.g. `"_Open"`) becomes a mnemonic — the combination `Alt+O` activates the button even if focus is on another widget in the window. `gtk_button_new_from_icon_name` creates a button with an icon from the system theme instead of text (typical for toolbars).

- `label` — the caption text (for the mnemonic variant, with an `_` before the accelerator letter).
- `icon_name` — the theme icon name (e.g. `"document-open-symbolic"`).

```nim
let openButton = gtk_button_new_with_mnemonic("_Open")
# Alt+O activates the button from anywhere in the window
let closeIconButton = gtk_button_new_from_icon_name("window-close-symbolic")
echo "Created a mnemonic button and an icon button"
```

---

### `gtk_button_set_label` / `gtk_button_get_label`

```nim
proc gtk_button_set_label*(button: GtkButton, label: cstring)
proc gtk_button_get_label*(button: GtkButton): cstring
```

**What it does.** Set and read the button's text. If the button currently has a child widget that isn't a plain label (for example, `gtk_button_set_child` was called with a custom `GtkBox` containing an icon and text), `gtk_button_set_label` replaces the button's content with a plain `GtkLabel` holding the given text — the call does not try to find and update text inside a complex composition.

- **Implementation note.** For buttons with complex content (icon + text, see section VI, "A button with an icon and text at once"), the text must be changed directly via `gtk_label_set_text` on the specific child `GtkLabel`, not via `gtk_button_set_label`.

- `button` — the button.
- `label` — the new text.

```nim
let button = gtk_button_new_with_label("Save")
gtk_button_set_label(button, "Saving...")
echo "Button text: ", $gtk_button_get_label(button)
# prints "Button text: Saving..."
```

---

### `gtk_button_set_use_underline` / `gtk_button_get_use_underline`

```nim
proc gtk_button_set_use_underline*(button: GtkButton, useUnderline: gboolean)
proc gtk_button_get_use_underline*(button: GtkButton): gboolean
```

**What it does.** Turns interpretation of the `_` character in the button's text as a mnemonic marker on/off (the same behavior that `gtk_button_new_with_mnemonic` enables automatically at creation time). Useful if the button's text is set after creation via `gtk_button_new`/`gtk_button_set_label` rather than directly in the constructor.

- `button` — the button.
- `useUnderline` — `1.gboolean` to enable interpreting `_` as a mnemonic.

```nim
let button = gtk_button_new()
gtk_button_set_use_underline(button, 1.gboolean)
gtk_button_set_label(button, "_Print")  # Alt+P now activates the button
echo "Mnemonic enabled: ", gtk_button_get_use_underline(button) != 0.gboolean
```

---

### `gtk_button_set_child` / `gtk_button_get_child`

```nim
proc gtk_button_set_child*(button: GtkButton, child: GtkWidget)
proc gtk_button_get_child*(button: GtkButton): GtkWidget
```

**What it does.** Set the button's arbitrary child widget — what is actually displayed inside it. This is how content more complex than plain text is built: an icon next to a caption, a loading indicator, and so on — the single child widget is wrapped in a `GtkBox` (see section VI, "A button with an icon and text at once").

- `button` — the button.
- `child` — the content widget (passing `nil` clears the button).

```nim
let content = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 6)
gtk_box_append(content, gtk_image_new_from_icon_name("document-save-symbolic"))
gtk_box_append(content, gtk_label_new("Save"))
gtk_button_set_child(saveButton, content)
echo "Button content replaced with an icon plus caption"
```

---

### `gtk_button_set_has_frame` / `gtk_button_get_has_frame`

```nim
proc gtk_button_set_has_frame*(button: GtkButton, hasFrame: gboolean)
proc gtk_button_get_has_frame*(button: GtkButton): gboolean
```

**What it does.** Removes/restores the button's standard frame and background, leaving only its content — visually the same as the CSS class `"flat"` (see `gtk_widget_add_css_class` in the core reference). Used for buttons in toolbars and headers, where an explicit button frame is visually redundant and should only highlight on hover/press.

- `button` — the button.
- `hasFrame` — `0.gboolean` to remove the frame.

```nim
gtk_button_set_has_frame(toolbarButton, 0.gboolean)
echo "Button without a frame: ", gtk_button_get_has_frame(toolbarButton) == 0.gboolean
```

---

### `gtk_button_set_icon_name` / `gtk_button_get_icon_name`

```nim
proc gtk_button_set_icon_name*(button: GtkButton, iconName: cstring)
proc gtk_button_get_icon_name*(button: GtkButton): cstring
```

**What it does.** Replaces the button's content with a theme icon by name — equivalent to calling `gtk_button_set_child` with a manually created `GtkImage`, but shorter. `gtk_button_get_icon_name` only returns a name if the button's current content was set exactly this way (or via `gtk_button_new_from_icon_name`) — for a button with text or complex content it returns `nil`.

- `button` — the button.
- `iconName` — the theme icon name.

```nim
gtk_button_set_icon_name(deleteButton, "user-trash-symbolic")
echo "Button icon: ", $gtk_button_get_icon_name(deleteButton)
```

---

### `gtk_button_set_can_shrink` / `gtk_button_get_can_shrink`

```nim
proc gtk_button_set_can_shrink*(button: GtkButton, can_shrink: gboolean)
proc gtk_button_get_can_shrink*(button: GtkButton): gboolean
```

**What it does.** Allows the button to shrink below the natural size of its content (clipping the text/icon) instead of forcibly demanding a minimum size equal to the full size of its content. Relevant for buttons in cramped toolbars, where by default GTK would rather not show the button at all if there isn't enough room.

- `button` — the button.
- `can_shrink` — `1.gboolean` to allow shrinking.

```nim
gtk_button_set_can_shrink(compactToolbarButton, 1.gboolean)
echo "Button can shrink below its natural size: ", gtk_button_get_can_shrink(compactToolbarButton) != 0.gboolean
```

---

### `gtk_actionable_set_detailed_action_name`

```nim
proc gtk_actionable_set_detailed_action_name*(actionable: GtkWidget, detailedActionName: cstring)
```

**What it does.** Binds a button (or any other `Actionable` widget) to an application or window action in a single string of the form `"group.name"` or `"group.name(parameter)"` — a shorthand alternative to the separate `gtk_actionable_set_action_name` + `gtk_actionable_set_action_target_value` from the core reference, for when the action's parameter doesn't need to be supplied programmatically and can just be baked into the string.

- `actionable` — a widget implementing the `GtkActionable` interface (in particular, `GtkButton`).
- `detailedActionName` — a string like `"win.close"`, `"app.quit"`, `"win.set-view('grid')"`.

```nim
gtk_actionable_set_detailed_action_name(closeButton, "win.close")
echo "Button bound to the win.close action"
```

---

## GtkToggleButton

`GtkToggleButton` is a button with two stable states (pressed/released) that persists its state between clicks, unlike a regular `GtkButton`, which only emits a `"clicked"` signal and doesn't store state itself. It looks like a regular button visually but stays "pushed in" after being clicked, until clicked again.

### `gtk_toggle_button_new` / `gtk_toggle_button_new_with_label` / `gtk_toggle_button_new_with_mnemonic`

```nim
proc gtk_toggle_button_new*(): GtkToggleButton
proc gtk_toggle_button_new_with_label*(label: cstring): GtkToggleButton
proc gtk_toggle_button_new_with_mnemonic*(label: cstring): GtkToggleButton
```

**What it does.** Creates a toggle button — empty, with a text caption, or with a caption and a mnemonic (an `_` before the accelerator letter — the same logic as `gtk_button_new_with_mnemonic`).

- `label` — the caption text.

```nim
let boldToggle = gtk_toggle_button_new_with_label("B")
echo "Bold-formatting toggle button created"
```

---

### `gtk_toggle_button_set_active` / `gtk_toggle_button_get_active`

```nim
proc gtk_toggle_button_set_active*(toggleButton: GtkToggleButton, isActive: gboolean)
proc gtk_toggle_button_get_active*(toggleButton: GtkToggleButton): gboolean
```

**What it does.** Set and read the button's current state (pressed/released) programmatically — for example, to reflect external state (the current text formatting under the cursor) without waiting for a user click. Setting `active` programmatically also emits the `"toggled"` signal, just like a user click — the signal handler cannot tell a programmatic change apart from a user-driven one without extra logic.

- `toggleButton` — the toggle button.
- `isActive` — `1.gboolean` for the pressed state.

```nim
gtk_toggle_button_set_active(boldToggle, 1.gboolean)
echo "'B' button pressed: ", gtk_toggle_button_get_active(boldToggle) != 0.gboolean
```

---

### `gtk_toggle_button_toggled`

```nim
proc gtk_toggle_button_toggled*(toggleButton: GtkToggleButton)
```

**What it does.** Forcibly emits the `"toggled"` signal without changing the `active` state itself — rarely needed directly (in the vast majority of cases the state is changed via `set_active`, which already emits the signal on its own). Can be useful if some external state that the toggle's appearance depends on has changed without the underlying `active` boolean changing (an atypical scenario).

- `toggleButton` — the toggle button.

```nim
gtk_toggle_button_toggled(boldToggle)  # forcibly notify "toggled" subscribers
echo "toggled signal sent manually"
```

---

### `gtk_toggle_button_set_group`

```nim
proc gtk_toggle_button_set_group*(toggle_button: GtkToggleButton, group: GtkToggleButton)
```

**What it does.** Groups a toggle button together with another toggle button — within the group only one button can be pressed at a time (an analog of radio buttons, but based on `GtkToggleButton`, which is convenient for mode-selection panels styled as a row of identical buttons, e.g. a "List / Grid" switch in a toolbar). Passing `nil` for `group` removes the button from whatever group it belonged to.

- `toggle_button` — the button to add to the group.
- `group` — any other button already in the target group (or `nil` to leave the group).

```nim
let listViewToggle = gtk_toggle_button_new_with_label("List")
let gridViewToggle = gtk_toggle_button_new_with_label("Grid")
gtk_toggle_button_set_group(gridViewToggle, listViewToggle)
gtk_toggle_button_set_active(listViewToggle, 1.gboolean)  # "List" view active by default
echo "'List' and 'Grid' buttons grouped into a mutually exclusive selection"
```

---

## GtkCheckButton

In GTK4, `GtkCheckButton` is a single class used for both regular checkboxes and radio buttons: the only difference is whether the button is grouped with others via `gtk_check_button_set_group` (in which case it visually and behaviorally becomes a radio button) or exists independently (in which case it's a regular checkbox). There is no separate `GtkRadioButton` class in GTK4.

### `gtk_check_button_new` / `gtk_check_button_new_with_label` / `gtk_check_button_new_with_mnemonic`

```nim
proc gtk_check_button_new*(): GtkCheckButton
proc gtk_check_button_new_with_label*(label: cstring): GtkCheckButton
proc gtk_check_button_new_with_mnemonic*(label: cstring): GtkCheckButton
```

**What it does.** Creates a checkbox/radio button — empty (the caption is set separately via `gtk_check_button_set_label` or an arbitrary child widget via `set_child`), with a text caption, or with a caption and a mnemonic.

- `label` — the caption text.

```nim
let agreeCheck = gtk_check_button_new_with_label("I accept the terms of use")
echo "Terms-of-use agreement checkbox created"
```

---

### `gtk_check_button_set_active` / `gtk_check_button_get_active`

```nim
proc gtk_check_button_set_active*(checkButton: GtkCheckButton, setting: gboolean)
proc gtk_check_button_get_active*(checkButton: GtkCheckButton): gboolean
```

**What it does.** Set and read whether the checkbox is checked (or, for a radio button within a group, whether this particular one is selected). For a radio button, programmatically setting `set_active(true)` on one button in the group automatically unchecks the other buttons in the same group.

- `checkButton` — the checkbox/radio button.
- `setting` — `1.gboolean` for the checked state.

```nim
gtk_check_button_set_active(agreeCheck, 1.gboolean)
echo "Terms accepted: ", gtk_check_button_get_active(agreeCheck) != 0.gboolean
```

---

### `gtk_check_button_set_inconsistent` / `gtk_check_button_get_inconsistent`

```nim
proc gtk_check_button_set_inconsistent*(checkButton: GtkCheckButton, inconsistent: gboolean)
proc gtk_check_button_get_inconsistent*(checkButton: GtkCheckButton): gboolean
```

**What it does.** Enables the checkbox's "indeterminate" visual state (usually shown as a dash instead of a checkmark or empty box) — used when the checkbox represents a group of nested items with a partially mixed state (e.g. a "Select All" checkbox in a list where only some items are checked). This is a purely visual mode — it does not change the value returned by `gtk_check_button_get_active`, and is cleared automatically on the user's next click on the checkbox.

- `checkButton` — the checkbox.
- `inconsistent` — `1.gboolean` to enable the indeterminate state.

```nim
gtk_check_button_set_inconsistent(selectAllCheck, 1.gboolean)
echo "Showing a dash instead of a checkmark: ", gtk_check_button_get_inconsistent(selectAllCheck) != 0.gboolean
```

---

### `gtk_check_button_set_group`

```nim
proc gtk_check_button_set_group*(check_button: GtkCheckButton, group: GtkCheckButton)
```

**What it does.** Groups a checkbox together with another one into a mutually exclusive selection — this is exactly how radio buttons are created in GTK4: it turns a set of independent checkboxes into a set where only one can be checked at a time. Passing `nil` returns the button to independent-checkbox mode.

- `check_button` — the button to add to the group.
- `group` — any other button already in the target group (or `nil` to leave the group).

```nim
let optionA = gtk_check_button_new_with_label("Option A")
let optionB = gtk_check_button_new_with_label("Option B")
let optionC = gtk_check_button_new_with_label("Option C")
gtk_check_button_set_group(optionB, optionA)
gtk_check_button_set_group(optionC, optionA)
gtk_check_button_set_active(optionA, 1.gboolean)
echo "Three radio buttons grouped together, Option A selected by default"
```

---

### `gtk_check_button_set_label` / `gtk_check_button_get_label`

```nim
proc gtk_check_button_set_label*(check_button: GtkCheckButton, label: cstring)
proc gtk_check_button_get_label*(check_button: GtkCheckButton): cstring
```

**What it does.** Set and read the checkbox/radio button's caption text after creation.

- `check_button` — the checkbox/radio button.
- `label` — the new text.

```nim
gtk_check_button_set_label(agreeCheck, "I agree to the updated privacy policy")
echo "Checkbox text: ", $gtk_check_button_get_label(agreeCheck)
```

---

### `gtk_check_button_set_use_underline` / `gtk_check_button_get_use_underline`

```nim
proc gtk_check_button_set_use_underline*(check_button: GtkCheckButton, use_underline: gboolean)
proc gtk_check_button_get_use_underline*(check_button: GtkCheckButton): gboolean
```

**What it does.** Turns interpretation of the `_` character in the caption as a mnemonic marker on/off — the same logic as `gtk_button_set_use_underline`.

- `check_button` — the checkbox/radio button.
- `use_underline` — `1.gboolean` to enable mnemonic interpretation.

```nim
gtk_check_button_set_use_underline(agreeCheck, 1.gboolean)
gtk_check_button_set_label(agreeCheck, "I _agree to the terms")  # Alt+A toggles the checkbox
echo "Checkbox mnemonic enabled"
```

---

### `gtk_check_button_set_child` / `gtk_check_button_get_child`

```nim
proc gtk_check_button_set_child*(check_button: GtkCheckButton, child: GtkWidget)
proc gtk_check_button_get_child*(check_button: GtkCheckButton): GtkWidget
```

**What it does.** Sets an arbitrary child widget in place of a plain text caption — just like `gtk_button_set_child` for `GtkButton`, this lets you place, for example, an icon or a composite multi-line description of varying text sizes next to the checkbox.

- `check_button` — the checkbox/radio button.
- `child` — the content widget.

```nim
let descriptionBox = gtk_box_new(GTK_ORIENTATION_VERTICAL, 2)
gtk_box_append(descriptionBox, gtk_label_new("Autosave"))
gtk_box_append(descriptionBox, gtk_label_new("Save the project every 5 minutes"))
gtk_check_button_set_child(autosaveCheck, descriptionBox)
echo "Checkbox now contains a two-line title and description"
```

---

## GtkSwitch

`GtkSwitch` is a mobile-UI-style toggle switch (an "on/off" control with a sliding indicator), a visual alternative to the `GtkCheckButton` checkbox for boolean settings — typically used in settings panels. Unlike `GtkCheckButton`, `GtkSwitch` has two related but distinct properties: `active` and `state` — this is deliberate, to allow asynchronous confirmation of the toggle.

### `gtk_switch_new`

```nim
proc gtk_switch_new*(): GtkSwitch
```

**What it does.** Creates a switch in the off state.

- No parameters.

```nim
let darkModeSwitch = gtk_switch_new()
echo "Dark mode switch created"
```

---

### `gtk_switch_set_active` / `gtk_switch_get_active`

```nim
proc gtk_switch_set_active*(sw: GtkSwitch, isActive: gboolean)
proc gtk_switch_get_active*(sw: GtkSwitch): gboolean
```

**What it does.** Immediately changes the switch's visual position (the slider jumps to its new position right away) and reads the current visual position. For simple settings, where the toggle doesn't block anything and requires no confirmation, `active` is the only property you need to work with.

- `sw` — the switch.
- `isActive` — `1.gboolean` for the on position.

```nim
gtk_switch_set_active(darkModeSwitch, 1.gboolean)
echo "Dark mode enabled: ", gtk_switch_get_active(darkModeSwitch) != 0.gboolean
```

---

### `gtk_switch_set_state` / `gtk_switch_get_state`

```nim
proc gtk_switch_set_state*(sw: GtkSwitch, state: gboolean)
proc gtk_switch_get_state*(sw: GtkSwitch): gboolean
```

**What it does.** `state` is the actual, "confirmed" state, separate from the visual slider position (`active`). When the user drags the switch, `active` changes right away, but `state` stays as it was until the application explicitly calls `set_state` — this makes it possible, for example, to show a confirmation dialog or perform an asynchronous server request before the toggle is considered final; if the operation fails, you can call `set_active` with the previous value to visually "roll back" the switch.

- **Implementation note.** For settings without asynchronous confirmation, the distinction between `active` and `state` doesn't matter — both properties change in sync; the separation exists specifically for scenarios where a toggle might be rejected after the switch has already moved visually.

- `sw` — the switch.
- `state` — `1.gboolean` for the confirmed on state.

```nim
proc onNotifyActive(sw: GtkSwitch, pspec: pointer, userData: gpointer) {.cdecl.} =
  # The user moved the switch — active has already changed, but we don't confirm right away
  echo "User requested a toggle, sending request to server..."
  # ... after a successful server response ...
  gtk_switch_set_state(sw, gtk_switch_get_active(sw))
  echo "Toggle confirmed, state synced with active"

discard g_signal_connect(darkModeSwitch, "notify::active", onNotifyActive, nil)
```

---

## GtkLabel

`GtkLabel` is static or interactive text: titles, descriptions, field captions, and also clickable links (via Pango markup). Unlike `GtkEntry`, the content of a `GtkLabel` is not editable by default — it can only optionally be made selectable (`gtk_label_set_selectable`) for copying.

### `gtk_label_new` / `gtk_label_new_with_mnemonic`

```nim
proc gtk_label_new*(str: cstring): GtkLabel
proc gtk_label_new_with_mnemonic*(str: cstring): GtkLabel
```

**What it does.** Creates a label with plain text, or with text where an `_` before a letter marks a mnemonic. A `GtkLabel`'s mnemonic does not activate the label itself (it has no action), but hands input focus to an associated widget — see `gtk_label_set_mnemonic_widget` below; a typical example is a form field's caption, whose mnemonic moves focus into the field itself.

- `str` — the label text.

```nim
let title = gtk_label_new("Application Settings")
echo "Title created"
```

---

### `gtk_label_set_text` / `gtk_label_get_text`

```nim
proc gtk_label_set_text*(label: GtkLabel, str: cstring)
proc gtk_label_get_text*(label: GtkLabel): cstring
```

**What it does.** Set and read the label's plain (unformatted) text. If Pango markup had previously been enabled on the label via `gtk_label_set_markup`, calling `set_text` disables markup interpretation — the passed string is displayed literally, including any `<`, `>`, `&` characters.

- `label` — the label.
- `str` — the new text.

```nim
gtk_label_set_text(statusLabel, "Ready")
echo "Status text: ", $gtk_label_get_text(statusLabel)
```

---

### `gtk_label_set_markup` / `gtk_label_set_markup_with_mnemonic`

```nim
proc gtk_label_set_markup*(label: GtkLabel, str: cstring)
proc gtk_label_set_markup_with_mnemonic*(label: GtkLabel, str: cstring)
```

**What it does.** Sets the label's text as Pango markup (`<b>`, `<i>`, `<span foreground="...">`, `<a href="...">` for links, and so on) — automatically enables `use_markup` (see below). The `_with_mnemonic` variant additionally interprets `_` in the text as a mnemonic marker, just like the text constructors.

- **Implementation note.** There is no separate getter for "retrieve the markup as set" — for a label with markup, `gtk_label_get_text` returns the plain text with tags already stripped out, not the original marked-up string.

- `label` — the label.
- `str` — text with Pango markup.

```nim
gtk_label_set_markup(hintLabel, "See the <a href=\"https://example.com/docs\">documentation</a> for details")
echo "Label with a clickable link set"
```

---

### `gtk_label_set_use_markup` / `gtk_label_get_use_markup`

```nim
proc gtk_label_set_use_markup*(label: GtkLabel, setting: gboolean)
proc gtk_label_get_use_markup*(label: GtkLabel): gboolean
```

**What it does.** Turns interpretation of the label's text as Pango markup on/off directly, independent of `set_markup` — for example, so that the same `set_text` call is sometimes interpreted as markup and sometimes shown literally, depending on the source of the text (user input is reasonably shown literally to avoid accidental or intentional markup injection).

- `label` — the label.
- `setting` — `1.gboolean` to interpret the text as Pango markup.

```nim
echo "Markup in use: ", gtk_label_get_use_markup(hintLabel) != 0.gboolean
```

---

### `gtk_label_set_use_underline` / `gtk_label_get_use_underline`

```nim
proc gtk_label_set_use_underline*(label: GtkLabel, setting: gboolean)
proc gtk_label_get_use_underline*(label: GtkLabel): gboolean
```

**What it does.** Turns interpretation of the `_` character in the text as a mnemonic marker on/off — the same logic as `gtk_button_set_use_underline`, but for handing focus to an associated widget rather than activating the label itself (see `gtk_label_set_mnemonic_widget`).

- `label` — the label.
- `setting` — `1.gboolean` to interpret `_` as a mnemonic.

```nim
gtk_label_set_use_underline(fieldCaption, 1.gboolean)
gtk_label_set_text(fieldCaption, "_Username")
echo "Field caption mnemonic enabled"
```

---

### `gtk_label_set_justify` / `gtk_label_get_justify`

```nim
proc gtk_label_set_justify*(label: GtkLabel, jtype: GtkJustification)
proc gtk_label_get_justify*(label: GtkLabel): GtkJustification
```

**What it does.** Sets horizontal text alignment **within the label itself**, when the text spans multiple lines (`GTK_JUSTIFY_LEFT`, `GTK_JUSTIFY_RIGHT`, `GTK_JUSTIFY_CENTER`, `GTK_JUSTIFY_FILL` — stretching lines to fill the width, as in a text editor). Not to be confused with `gtk_widget_set_halign` from the core reference — that aligns the label as a whole widget within the space allotted to it by its container, while `justify` only aligns lines of text relative to each other within a multi-line label.

- `label` — the label.
- `jtype` — a `GtkJustification` value.

```nim
gtk_label_set_justify(longDescription, GTK_JUSTIFY_LEFT)
echo "Multi-line text left-aligned"
```

---

### `gtk_label_set_wrap` / `gtk_label_get_wrap` / `gtk_label_set_wrap_mode` / `gtk_label_get_wrap_mode`

```nim
proc gtk_label_set_wrap*(label: GtkLabel, wrap: gboolean)
proc gtk_label_get_wrap*(label: GtkLabel): gboolean
proc gtk_label_set_wrap_mode*(label: GtkLabel, wrapMode: PangoWrapMode)
proc gtk_label_get_wrap_mode*(label: GtkLabel): PangoWrapMode
```

**What it does.** `set_wrap` enables wrapping of long text onto a new line when it doesn't fit within the width allotted to the label (without this, long text simply gets clipped or stretches the parent container). `wrap_mode` refines **how exactly** to wrap — at word boundaries (`PANGO_WRAP_WORD`, the default), mid-word character by character (`PANGO_WRAP_CHAR`), or first try word wrapping and only fall back to character wrapping for words longer than an entire line (`PANGO_WRAP_WORD_CHAR`).

- `label` — the label.
- `wrap` — `1.gboolean` to enable wrapping.
- `wrapMode` — a `PangoWrapMode` value.

```nim
gtk_label_set_wrap(longDescription, 1.gboolean)
gtk_label_set_wrap_mode(longDescription, PANGO_WRAP_WORD_CHAR)
echo "Text wrapping enabled, prioritizing word breaks"
```

---

### `gtk_label_set_selectable` / `gtk_label_get_selectable`

```nim
proc gtk_label_set_selectable*(label: GtkLabel, setting: gboolean)
proc gtk_label_get_selectable*(label: GtkLabel): gboolean
```

**What it does.** Allows the user to select the label's text with the mouse and copy it (`Ctrl+C`) — by default a regular label's text is not selectable, like any other non-interactive UI element. Worth enabling for labels containing values the user might need to copy — error codes, identifiers, version numbers.

- `label` — the label.
- `setting` — `1.gboolean` to allow selection.

```nim
gtk_label_set_selectable(versionLabel, 1.gboolean)
echo "Version text can now be selected and copied"
```

---

### `gtk_label_set_width_chars` / `gtk_label_get_width_chars` / `gtk_label_set_max_width_chars` / `gtk_label_get_max_width_chars`

```nim
proc gtk_label_set_width_chars*(label: GtkLabel, nChars: gint)
proc gtk_label_get_width_chars*(label: GtkLabel): gint
proc gtk_label_set_max_width_chars*(label: GtkLabel, nChars: gint)
proc gtk_label_get_max_width_chars*(label: GtkLabel): gint
```

**What it does.** Sets the minimum (`width_chars`) and maximum (`max_width_chars`) width of the label in characters (an approximate count of "average"-sized characters in the current font, not pixels) — a way to set reasonable width bounds for a text widget without tying it to pixels, which look different across fonts and screen scaling.

- `label` — the label.
- `nChars` — number of characters, or `-1` for no limit.

```nim
gtk_label_set_max_width_chars(descriptionLabel, 40)
gtk_label_set_wrap(descriptionLabel, 1.gboolean)
echo "Label won't be wider than 40 characters, long text will wrap"
```

---

### `gtk_label_set_ellipsize` / `gtk_label_get_ellipsize`

```nim
proc gtk_label_set_ellipsize*(label: GtkLabel, mode: PangoEllipsizeMode)
proc gtk_label_get_ellipsize*(label: GtkLabel): PangoEllipsizeMode
```

**What it does.** Enables ellipsizing text when it doesn't fit within the label's width, instead of wrapping to a new line or overflowing. `mode` determines which side to truncate: `PANGO_ELLIPSIZE_NONE` (no ellipsizing, the default), `PANGO_ELLIPSIZE_START` (ellipsis at the start — handy for file paths, where it's more important to see the filename at the end), `PANGO_ELLIPSIZE_MIDDLE`, `PANGO_ELLIPSIZE_END` (ellipsis at the end — the most common case for titles).

- `label` — the label.
- `mode` — a `PangoEllipsizeMode` value.

```nim
gtk_label_set_ellipsize(fileNameLabel, PANGO_ELLIPSIZE_END)
echo "A long filename will be ellipsized at the end"
```

---

### `gtk_label_select_region` / `gtk_label_get_selection_bounds`

```nim
proc gtk_label_select_region*(label: GtkLabel, start_offset: gint, end_offset: gint)
proc gtk_label_get_selection_bounds*(label: GtkLabel, start: ptr gint, `end`: ptr gint): gboolean
```

**What it does.** Programmatically selects a range of the label's text (only works if `gtk_label_set_selectable` is enabled), and reads the bounds of the current selection made by the user. `get_selection_bounds` returns a `gboolean` indicating whether there is any active selection at all — if not, the values behind the `start`/`end` pointers are undefined and should not be used.

- `label` — the label.
- `start_offset`, `end_offset` — the selection bounds, in characters.
- `start`, `end` (for reading) — pointers where the current selection's bounds will be written.

```nim
gtk_label_set_selectable(codeLabel, 1.gboolean)
gtk_label_select_region(codeLabel, 0, 8)  # select the first 8 characters programmatically
var start, stop: gint
if gtk_label_get_selection_bounds(codeLabel, addr start, addr stop) != 0.gboolean:
  echo "Selected from ", start, " to ", stop
```

---

### `gtk_label_set_attributes` / `gtk_label_get_attributes`

```nim
proc gtk_label_set_attributes*(label: GtkLabel, attrs: PangoAttrList)
proc gtk_label_get_attributes*(label: GtkLabel): PangoAttrList
```

**What it does.** Sets and reads a list of Pango formatting attributes (`PangoAttrList`) directly — a programmatic alternative to textual Pango markup (`gtk_label_set_markup`) for cases where formatting attributes are computed in code rather than given as a static string (e.g. syntax highlighting). Building a `PangoAttrList` is a separate topic outside the scope of this reference (the `pango_attr_list_*` functions).

- `label` — the label.
- `attrs` — the Pango attribute list.

```nim
# attrs is built beforehand via pango_attr_list_new/pango_attr_list_insert
gtk_label_set_attributes(codeLabel, attrs)
echo "Programmatic formatting attributes applied"
```

---

### `gtk_label_set_mnemonic_widget` / `gtk_label_get_mnemonic_widget`

```nim
proc gtk_label_set_mnemonic_widget*(label: GtkLabel, widget: GtkWidget)
proc gtk_label_get_mnemonic_widget*(label: GtkLabel): GtkWidget
```

**What it does.** Links a caption label to another widget (usually an input field): when the label's mnemonic is activated (`Alt+letter`, see `gtk_label_set_use_underline`), input focus is handed not to the label itself (it has no focus as such) but to the specified widget. This is the standard way to make form captions accessible from the keyboard.

- `label` — the caption label with the mnemonic enabled.
- `widget` — the widget (usually a `GtkEntry`) that should receive focus.

```nim
let nameCaption = gtk_label_new_with_mnemonic("_Username")
let nameEntry = gtk_entry_new()
gtk_label_set_mnemonic_widget(nameCaption, nameEntry)
echo "Alt+U now moves focus into the username field"
```

---

### `gtk_label_set_single_line_mode` / `gtk_label_get_single_line_mode`

```nim
proc gtk_label_set_single_line_mode*(label: GtkLabel, single_line_mode: gboolean)
proc gtk_label_get_single_line_mode*(label: GtkLabel): gboolean
```

**What it does.** Forcibly collapses the label's text into a single line, even if the source text contains line-break characters (`\n`) — line breaks are displayed as an ordinary space instead of moving to a new visual line. This differs from simply not including `\n` in the text in that it controls the handling of line breaks already present in the string, rather than their presence.

- `label` — the label.
- `single_line_mode` — `1.gboolean` to collapse into a single line.

```nim
gtk_label_set_single_line_mode(compactStatusLabel, 1.gboolean)
echo "Line breaks in the status text will be shown as spaces"
```

---

### `gtk_label_set_lines` / `gtk_label_get_lines`

```nim
proc gtk_label_set_lines*(label: GtkLabel, lines: gint)
proc gtk_label_get_lines*(label: GtkLabel): gint
```

**What it does.** Limits the maximum number of visible text lines when wrapping is enabled (`gtk_label_set_wrap`) — text that doesn't fit in the given number of lines gets cut off (combined with `gtk_label_set_ellipsize`, with an ellipsis at the end of the last visible line). Useful for previews of long descriptions with a fixed height (e.g. a news card with a description capped at 3 lines).

- `label` — the label.
- `lines` — the maximum number of lines, or `-1` for no limit.

```nim
gtk_label_set_wrap(newsPreview, 1.gboolean)
gtk_label_set_lines(newsPreview, 3)
gtk_label_set_ellipsize(newsPreview, PANGO_ELLIPSIZE_END)
echo "News description capped at three lines with an ellipsis"
```

---

### `gtk_label_set_xalign` / `gtk_label_get_xalign` / `gtk_label_set_yalign` / `gtk_label_get_yalign`

```nim
proc gtk_label_set_xalign*(label: GtkLabel, xalign: cfloat)
proc gtk_label_get_xalign*(label: GtkLabel): cfloat
proc gtk_label_set_yalign*(label: GtkLabel, yalign: cfloat)
proc gtk_label_get_yalign*(label: GtkLabel): cfloat
```

**What it does.** Sets precise alignment of the text within the label widget's bounds as a fractional value from `0.0` to `1.0` (`0.0` — flush to the left/top edge, `1.0` — to the right/bottom, `0.5` — centered) — a more flexible alternative to the discrete `gtk_widget_set_halign`/`set_valign` from the core reference, for cases where you need alignment that isn't strictly "at the edge" or "centered," but with an arbitrary offset.

- `label` — the label.
- `xalign`, `yalign` — values from `0.0` to `1.0`.

```nim
gtk_label_set_xalign(priceLabel, 1.0)  # pin the price text to the right edge
echo "Price text right-aligned: xalign=", gtk_label_get_xalign(priceLabel)
```

---

### `gtk_label_set_extra_menu` / `gtk_label_get_extra_menu`

```nim
proc gtk_label_set_extra_menu*(label: GtkLabel, model: GMenuModel)
proc gtk_label_get_extra_menu*(label: GtkLabel): GMenuModel
```

**What it does.** Adds extra items to the label's standard context menu (which normally contains "Copy" for selectable text) — the menu model is built the same way as an application menu (see the core reference, `gtk_application_set_menubar`).

- `label` — the label.
- `model` — the extra menu model.

```nim
# extraMenuModel is built beforehand via g_menu_new/g_menu_append
gtk_label_set_extra_menu(codeLabel, extraMenuModel)
echo "Extra items added to the label's context menu"
```

---

### `gtk_label_set_natural_wrap_mode` / `gtk_label_get_natural_wrap_mode`

```nim
proc gtk_label_set_natural_wrap_mode*(label: GtkLabel, wrap_mode: GtkNaturalWrapMode)
proc gtk_label_get_natural_wrap_mode*(label: GtkLabel): GtkNaturalWrapMode
```

**What it does.** Fine-tunes how GTK computes the "natural" (preferred) size of a wrapping label when determining the minimum size within the layout system — affects how readily a multi-line label with `wrap` agrees to shrink in width instead of insisting on showing as many words as possible on one line. A specialized setting for fine-tuning automatic layout; in most cases the default value doesn't need to be changed.

- `label` — the label.
- `wrap_mode` — a `GtkNaturalWrapMode` value.

```nim
echo "Current natural wrap mode: ", gtk_label_get_natural_wrap_mode(longDescription)
```

---

### `gtk_label_set_tabs` / `gtk_label_get_tabs`

```nim
proc gtk_label_set_tabs*(label: GtkLabel, tabs: PangoTabArray)
proc gtk_label_get_tabs*(label: GtkLabel): PangoTabArray
```

**What it does.** Sets tab stop positions for `\t` characters within the label's text (an analog of tab stops in a text editor) — relevant only for multi-line text with monospaced data alignment via tabs. A `PangoTabArray` is built with separate `pango_tab_array_*` functions, which are not covered in this reference.

- `label` — the label.
- `tabs` — the Pango tab-stop array.

```nim
# tabArray is built beforehand via pango_tab_array_new/pango_tab_array_set_tab
gtk_label_set_tabs(monospaceReport, tabArray)
echo "Tab stop positions set for the report"
```

---

### `gtk_label_get_current_uri`

```nim
proc gtk_label_get_current_uri*(label: GtkLabel): cstring
```

**What it does.** Returns the URI of the link the mouse cursor is currently over (for a label with Pango markup containing `<a href="...">` tags) — called from inside an `"activate-link"` or similar signal handler to find out which of several possible links triggered the action. Returns `nil` when not hovering over a link.

- `label` — the label with links in its markup.

```nim
let uri = gtk_label_get_current_uri(hintLabel)
if not isNil(uri):
  echo "Cursor is currently over a link: ", $uri
```

---

### `gtk_label_get_layout` / `gtk_label_get_layout_offsets`

```nim
proc gtk_label_get_layout*(label: GtkLabel): PangoLayout
proc gtk_label_get_layout_offsets*(label: GtkLabel, x: ptr gint, y: ptr gint)
```

**What it does.** Gives access to the low-level Pango text layout object (`PangoLayout`) that the label uses to draw its text, and to its offset relative to the top-left corner of the widget itself. Needed for advanced scenarios — precise text measurement, custom drawing on top of the label's text, determining which character sits under a given pixel coordinate. Not required for regular work with a label's text (reading, formatting, alignment) — using these functions assumes familiarity with the Pango API.

- `label` — the label.
- `x`, `y` (for `get_layout_offsets`) — pointers where the offset will be written.

```nim
let layout = gtk_label_get_layout(measuredLabel)
var offsetX, offsetY: gint
gtk_label_get_layout_offsets(measuredLabel, addr offsetX, addr offsetY)
echo "Text layout offset: (", offsetX, ", ", offsetY, ")"
```

---

## Practical Recipes

### A group of radio buttons built on GtkCheckButton

Choosing one option out of several is a classic scenario, implemented in GTK4 via `gtk_check_button_set_group`.

```nim
proc buildViewModeChoice(): GtkBox =
  result = gtk_box_new(GTK_ORIENTATION_VERTICAL, 6)

  let smallOption = gtk_check_button_new_with_label("Small icons")
  let largeOption = gtk_check_button_new_with_label("Large icons")
  let listOption = gtk_check_button_new_with_label("List")

  gtk_check_button_set_group(largeOption, smallOption)
  gtk_check_button_set_group(listOption, smallOption)
  gtk_check_button_set_active(smallOption, 1.gboolean)  # default option

  gtk_box_append(result, smallOption)
  gtk_box_append(result, largeOption)
  gtk_box_append(result, listOption)
  echo "Group of three mutually exclusive view-mode options assembled"

let viewModeChoice = buildViewModeChoice()
```

---

### Settings panel: labeled GtkSwitch toggles

A typical settings row: caption on the left, switch on the right, stretched across the full width via `hexpand` on the intervening spacer.

```nim
proc buildSettingRow(caption: string, initiallyOn: bool): GtkBox =
  result = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 12)
  let label = gtk_label_new(caption.cstring)
  gtk_widget_set_hexpand(label, 1.gboolean)
  gtk_widget_set_halign(label, GTK_ALIGN_START)

  let sw = gtk_switch_new()
  gtk_switch_set_active(sw, if initiallyOn: 1.gboolean else: 0.gboolean)
  gtk_widget_set_valign(sw, GTK_ALIGN_CENTER)

  gtk_box_append(result, label)
  gtk_box_append(result, sw)

let notificationsRow = buildSettingRow("Notifications", true)
let autoUpdateRow = buildSettingRow("Automatic updates", false)
echo "Two settings rows with switches assembled"
```

---

### A button with an icon and text at once

`gtk_button_set_icon_name` replaces the entire content of the button with a single icon — to get an icon next to text, the content is assembled by hand via `gtk_button_set_child`.

```nim
proc buildIconTextButton(iconName, labelText: string): GtkButton =
  result = gtk_button_new()
  let content = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 6)
  let icon = gtk_image_new_from_icon_name(iconName.cstring)
  let label = gtk_label_new(labelText.cstring)
  gtk_box_append(content, icon)
  gtk_box_append(content, label)
  gtk_button_set_child(result, content)

let saveButton = buildIconTextButton("document-save-symbolic", "Save")
echo "Button with a save icon and text assembled"
```

---

### A label with wrapping, ellipsization, and selectable text

A combination of `GtkLabel` properties for showing long text in a width-constrained block, with an ellipsis if there's too much text even for several lines, and with the ability to select and copy what's visible.

```nim
proc buildDescriptionLabel(text: string): GtkLabel =
  result = gtk_label_new(text.cstring)
  gtk_label_set_wrap(result, 1.gboolean)
  gtk_label_set_wrap_mode(result, PANGO_WRAP_WORD_CHAR)
  gtk_label_set_lines(result, 4)
  gtk_label_set_ellipsize(result, PANGO_ELLIPSIZE_END)
  gtk_label_set_max_width_chars(result, 50)
  gtk_label_set_selectable(result, 1.gboolean)
  gtk_label_set_xalign(result, 0.0)  # pin to the left edge instead of centering
  echo "Description label assembled: wrapping, up to 4 lines, selectable"

let description = buildDescriptionLabel("A very long description that won't fit into four lines without ellipsization...")
```

---

### Mnemonic: a caption that hands focus to a field via Alt+letter

A full caption/entry-field pairing — pressing the mnemonic moves focus into the field without activating the caption itself.

```nim
proc buildLabeledEntryRow(mnemonicCaption: string): GtkBox =
  result = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 8)

  let caption = gtk_label_new_with_mnemonic(mnemonicCaption.cstring)
  gtk_widget_set_halign(caption, GTK_ALIGN_END)

  let entry = gtk_entry_new()
  gtk_widget_set_hexpand(entry, 1.gboolean)
  gtk_label_set_mnemonic_widget(caption, entry)

  gtk_box_append(result, caption)
  gtk_box_append(result, entry)

let emailRow = buildLabeledEntryRow("_Email")
echo "Alt+E now moves focus into the email field"
```

---

## Quick Reference Table

| Procedure(s) | Category | What it does, briefly |
|---|---|---|
| `gtk_button_new`, `_with_label`, `_with_mnemonic`, `_from_icon_name` | Button | Create a button — empty, with text, with a mnemonic, with an icon |
| `gtk_button_set/get_label` | Button | Button text (replaces complex content with a plain caption) |
| `gtk_button_set/get_use_underline` | Button | Interpretation of `_` in the text as a mnemonic |
| `gtk_button_set/get_child` | Button | Arbitrary button content |
| `gtk_button_set/get_has_frame` | Button | Button frame/background (flat look) |
| `gtk_button_set/get_icon_name` | Button | Icon content by theme name |
| `gtk_button_set/get_can_shrink` | Button | Allow the button to shrink below its natural size |
| `gtk_actionable_set_detailed_action_name` | Button | Binding to an action via the `"group.name"` string |
| `gtk_toggle_button_new`, `_with_label`, `_with_mnemonic` | ToggleButton | Create a toggle button |
| `gtk_toggle_button_set/get_active` | ToggleButton | Current state (pressed/released) |
| `gtk_toggle_button_toggled` | ToggleButton | Forcibly emit the `"toggled"` signal |
| `gtk_toggle_button_set_group` | ToggleButton | Group into a mutually exclusive selection |
| `gtk_check_button_new`, `_with_label`, `_with_mnemonic` | CheckButton | Create a checkbox/radio button |
| `gtk_check_button_set/get_active` | CheckButton | Whether checked / whether the radio option is selected |
| `gtk_check_button_set/get_inconsistent` | CheckButton | "Indeterminate" visual state (a dash) |
| `gtk_check_button_set_group` | CheckButton | Turn into a radio button within a group |
| `gtk_check_button_set/get_label` | CheckButton | Caption text |
| `gtk_check_button_set/get_use_underline` | CheckButton | Interpretation of `_` in the caption as a mnemonic |
| `gtk_check_button_set/get_child` | CheckButton | Arbitrary content instead of text |
| `gtk_switch_new` | Switch | Create a switch |
| `gtk_switch_set/get_active` | Switch | Immediate visual position |
| `gtk_switch_set/get_state` | Switch | Confirmed state (for asynchronous operations) |
| `gtk_label_new`, `_with_mnemonic` | Label | Create a label |
| `gtk_label_set/get_text` | Label | Plain (unformatted) text |
| `gtk_label_set_markup`, `_with_mnemonic` | Label | Text with Pango markup (links, formatting) |
| `gtk_label_set/get_use_markup` | Label | Interpretation of the text as Pango markup |
| `gtk_label_set/get_use_underline` | Label | Interpretation of `_` as a mnemonic |
| `gtk_label_set/get_justify` | Label | Line alignment within multi-line text |
| `gtk_label_set/get_wrap`, `set/get_wrap_mode` | Label | Text wrapping and its mode (word/character) |
| `gtk_label_set/get_selectable` | Label | Allow text selection and copying |
| `gtk_label_set/get_width_chars`, `set/get_max_width_chars` | Label | Min./max. width in characters |
| `gtk_label_set/get_ellipsize` | Label | Ellipsizing text |
| `gtk_label_select_region`, `get_selection_bounds` | Label | Programmatic selection / current selection bounds |
| `gtk_label_set/get_attributes` | Label | Programmatic Pango formatting attributes |
| `gtk_label_set/get_mnemonic_widget` | Label | Widget that receives focus via the label's mnemonic |
| `gtk_label_set/get_single_line_mode` | Label | Collapse line breaks into spaces |
| `gtk_label_set/get_lines` | Label | Limit on the number of visible lines |
| `gtk_label_set/get_xalign`, `set/get_yalign` | Label | Precise fractional text alignment |
| `gtk_label_set/get_extra_menu` | Label | Extra items in the label's context menu |
| `gtk_label_set/get_natural_wrap_mode` | Label | Fine-tuning natural size computation |
| `gtk_label_set/get_tabs` | Label | Tab stop positions for `\t` in the text |
| `gtk_label_get_current_uri` | Label | URI of the link under the cursor (for markup with links) |
| `gtk_label_get_layout`, `get_layout_offsets` | Label | Low-level access to the Pango layout |

---

## Summary: Which Procedure to Choose

- **Choosing one out of several mutually exclusive options** → `GtkCheckButton` with `gtk_check_button_set_group` — there's no separate radio-button class in GTK4.
- **A mode toggle styled as a row of identical buttons** (e.g. "List"/"Grid" in a toolbar, rather than a list of checkboxes) → `GtkToggleButton` with `gtk_toggle_button_set_group`, not `GtkCheckButton` — visually these are buttons, not checkboxes.
- **A simple boolean setting in a settings panel** → `GtkSwitch` — the stylistically expected choice for settings; `GtkCheckButton` is more appropriate inside lists and forms where there are already form-style text captions nearby.
- **The toggle must be confirmed asynchronously** (a server request, a dialog) → `GtkSwitch` with its separate `active`/`state`, rather than an instantaneous `GtkCheckButton`/`GtkToggleButton`, which has no such separation.
- **The button's text is just text** → `gtk_button_new_with_label`/`gtk_button_set_label`. **Text + icon together** → `gtk_button_set_child` with a manually assembled `GtkBox` (there's no ready-made "text plus icon" function).
- **The button must be activatable from the keyboard without explicitly tabbing to it** → add a mnemonic (`_` in the text + `gtk_button_new_with_mnemonic`/`set_use_underline`).
- **A caption must hand focus to an associated field via a mnemonic** (rather than performing an action itself) → `gtk_label_new_with_mnemonic` + `gtk_label_set_mnemonic_widget`, rather than trying to make the label clickable by hand.
- **Long text shouldn't bloat the interface** → `gtk_label_set_wrap` (wrapping onto several lines) combined with `gtk_label_set_lines`/`set_max_width_chars`, and `gtk_label_set_ellipsize` if the text might still not fit after that.
- **The user might need to copy a value from a label** (an error code, a version, an identifier) → don't forget `gtk_label_set_selectable` — a regular label's text isn't selectable by default.
- **You need a link inside the text** → `gtk_label_set_markup` with an `<a href="...">` tag, rather than a separate link button (`GtkLinkButton` — covered in the advanced buttons reference).
