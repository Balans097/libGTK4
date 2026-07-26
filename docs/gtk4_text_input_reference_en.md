# GTK4 (text input: GtkEditable / Entry / PasswordEntry / SearchEntry) — module reference

> **Import:** `import libGTK4`
> **Scope:** single-line text input — ordinary fields, password fields, the search field. Third part of the wrapper reference series; assumes familiarity with the first part (`gtk4_core_reference_ru.md` — initialization, the window, `GtkWidget`, layout) and the second (`gtk4_basic_controls_reference_ru.md` — buttons, `GtkLabel`).

The key feature of this section: the text itself, the cursor position, the selection, and editability of `GtkEntry`, `GtkPasswordEntry`, and `GtkSearchEntry` are not managed by each class's own functions, but by the shared `GtkEditable` interface — the same set of `gtk_editable_*` procedures, working identically for all three widgets (and a few others not covered in this reference, such as `GtkSpinButton`). That's why this reference starts with `GtkEditable` rather than with `GtkEntry`.

---

## Table of contents

I. [The GtkEditable interface (shared by all input fields)](#the-gtkeditable-interface-shared-by-all-input-fields)
&nbsp;&nbsp;1. [`gtk_editable_get_text` / `gtk_editable_set_text`](#gtk_editable_get_text--gtk_editable_set_text)
&nbsp;&nbsp;2. [`gtk_editable_get_chars`](#gtk_editable_get_chars)
&nbsp;&nbsp;3. [`gtk_editable_insert_text` / `gtk_editable_delete_text`](#gtk_editable_insert_text--gtk_editable_delete_text)
&nbsp;&nbsp;4. [`gtk_editable_get_selection_bounds` / `gtk_editable_select_region` / `gtk_editable_delete_selection`](#gtk_editable_get_selection_bounds--gtk_editable_select_region--gtk_editable_delete_selection)
&nbsp;&nbsp;5. [`gtk_editable_set_position` / `gtk_editable_get_position`](#gtk_editable_set_position--gtk_editable_get_position)
&nbsp;&nbsp;6. [`gtk_editable_set_editable` / `gtk_editable_get_editable`](#gtk_editable_set_editable--gtk_editable_get_editable)
&nbsp;&nbsp;7. [`gtk_editable_set_alignment` / `gtk_editable_get_alignment`](#gtk_editable_set_alignment--gtk_editable_get_alignment)
&nbsp;&nbsp;8. [`gtk_editable_set_width_chars` / `gtk_editable_get_width_chars` / `gtk_editable_set_max_width_chars` / `gtk_editable_get_max_width_chars`](#gtk_editable_set_width_chars--gtk_editable_get_width_chars--gtk_editable_set_max_width_chars--gtk_editable_get_max_width_chars)
&nbsp;&nbsp;9. [`gtk_editable_set_enable_undo` / `gtk_editable_get_enable_undo`](#gtk_editable_set_enable_undo--gtk_editable_get_enable_undo)

II. [GtkEntry](#gtkentry)
&nbsp;&nbsp;1. [`gtk_entry_new` / `gtk_entry_new_with_buffer`](#gtk_entry_new--gtk_entry_new_with_buffer)
&nbsp;&nbsp;2. [`gtk_entry_set_placeholder_text` / `gtk_entry_get_placeholder_text`](#gtk_entry_set_placeholder_text--gtk_entry_get_placeholder_text)
&nbsp;&nbsp;3. [`gtk_entry_set_visibility` / `gtk_entry_get_visibility`](#gtk_entry_set_visibility--gtk_entry_get_visibility)
&nbsp;&nbsp;4. [`gtk_entry_set_max_length` / `gtk_entry_get_max_length`](#gtk_entry_set_max_length--gtk_entry_get_max_length)
&nbsp;&nbsp;5. [`gtk_entry_set_has_frame` / `gtk_entry_get_has_frame`](#gtk_entry_set_has_frame--gtk_entry_get_has_frame)
&nbsp;&nbsp;6. [`gtk_entry_set_alignment` / `gtk_entry_get_alignment`](#gtk_entry_set_alignment--gtk_entry_get_alignment)
&nbsp;&nbsp;7. [`gtk_entry_set_buffer` / `gtk_entry_get_buffer`](#gtk_entry_set_buffer--gtk_entry_get_buffer)
&nbsp;&nbsp;8. [`gtk_entry_set_invisible_char` / `gtk_entry_get_invisible_char` / `gtk_entry_unset_invisible_char`](#gtk_entry_set_invisible_char--gtk_entry_get_invisible_char--gtk_entry_unset_invisible_char)
&nbsp;&nbsp;9. [`gtk_entry_set_activates_default` / `gtk_entry_get_activates_default`](#gtk_entry_set_activates_default--gtk_entry_get_activates_default)
&nbsp;&nbsp;10. [`gtk_entry_set_attributes` / `gtk_entry_get_attributes`](#gtk_entry_set_attributes--gtk_entry_get_attributes)
&nbsp;&nbsp;11. [`gtk_entry_set_tabs` / `gtk_entry_get_tabs`](#gtk_entry_set_tabs--gtk_entry_get_tabs)
&nbsp;&nbsp;12. [`gtk_entry_set_progress_fraction` / `gtk_entry_get_progress_fraction` / `set_progress_pulse_step` / `get_progress_pulse_step` / `gtk_entry_progress_pulse`](#gtk_entry_set_progress_fraction--gtk_entry_get_progress_fraction--set_progress_pulse_step--get_progress_pulse_step--gtk_entry_progress_pulse)
&nbsp;&nbsp;13. [`gtk_entry_set_completion` / `gtk_entry_get_completion`](#gtk_entry_set_completion--gtk_entry_get_completion)
&nbsp;&nbsp;14. [`gtk_entry_get_text_length`](#gtk_entry_get_text_length)
&nbsp;&nbsp;15. [Icons inside the field: `gtk_entry_set_icon_from_icon_name` and related functions](#icons-inside-the-field-gtk_entry_set_icon_from_icon_name-and-related-functions)
&nbsp;&nbsp;16. [`gtk_entry_set_input_purpose` / `gtk_entry_get_input_purpose` / `gtk_entry_set_input_hints` / `gtk_entry_get_input_hints`](#gtk_entry_set_input_purpose--gtk_entry_get_input_purpose--gtk_entry_set_input_hints--gtk_entry_get_input_hints)
&nbsp;&nbsp;17. [`gtk_entry_set_extra_menu` / `gtk_entry_get_extra_menu`](#gtk_entry_set_extra_menu--gtk_entry_get_extra_menu)
&nbsp;&nbsp;18. [`gtk_entry_reset_im_context`](#gtk_entry_reset_im_context)
&nbsp;&nbsp;19. [`gtk_entry_grab_focus_without_selecting`](#gtk_entry_grab_focus_without_selecting)

III. [GtkPasswordEntry](#gtkpasswordentry)
&nbsp;&nbsp;1. [`gtk_password_entry_new`](#gtk_password_entry_new)
&nbsp;&nbsp;2. [`gtk_password_entry_set_show_peek_icon` / `gtk_password_entry_get_show_peek_icon`](#gtk_password_entry_set_show_peek_icon--gtk_password_entry_get_show_peek_icon)
&nbsp;&nbsp;3. [`gtk_password_entry_set_extra_menu` / `gtk_password_entry_get_extra_menu`](#gtk_password_entry_set_extra_menu--gtk_password_entry_get_extra_menu)

IV. [GtkSearchEntry](#gtksearchentry)
&nbsp;&nbsp;1. [`gtk_search_entry_new`](#gtk_search_entry_new)
&nbsp;&nbsp;2. [`gtk_search_entry_set_placeholder_text` / `gtk_search_entry_get_placeholder_text`](#gtk_search_entry_set_placeholder_text--gtk_search_entry_get_placeholder_text)
&nbsp;&nbsp;3. [`gtk_search_entry_set_search_delay` / `gtk_search_entry_get_search_delay`](#gtk_search_entry_set_search_delay--gtk_search_entry_get_search_delay)
&nbsp;&nbsp;4. [`gtk_search_entry_set_key_capture_widget` / `gtk_search_entry_get_key_capture_widget`](#gtk_search_entry_set_key_capture_widget--gtk_search_entry_get_key_capture_widget)
&nbsp;&nbsp;5. [`gtk_search_entry_set_input_purpose` / `gtk_search_entry_get_input_purpose` / `set_input_hints` / `get_input_hints`](#gtk_search_entry_set_input_purpose--gtk_search_entry_get_input_purpose--set_input_hints--get_input_hints)

V. [Practical recipes](#practical-recipes)
&nbsp;&nbsp;1. [A login form: username + password with a peek button](#a-login-form-username--password-with-a-peek-button)
&nbsp;&nbsp;2. [A search field with delay and live filtering](#a-search-field-with-delay-and-live-filtering)
&nbsp;&nbsp;3. [An email field with a validation icon](#an-email-field-with-a-validation-icon)
&nbsp;&nbsp;4. [An input field with a progress indicator (e.g. while checking a password)](#an-input-field-with-a-progress-indicator-eg-while-checking-a-password)
&nbsp;&nbsp;5. [Submitting a form on Enter via `activates_default`](#submitting-a-form-on-enter-via-activates_default)

VI. [Summary table](#summary-table)

VII. [Summary: which procedure to choose](#summary-which-procedure-to-choose)

---

## The GtkEditable interface (shared by all input fields)

`GtkEditable` is not a separate widget but a shared interface implemented by `GtkEntry`, `GtkPasswordEntry`, `GtkSearchEntry`, and a number of other widgets with editable text. All the procedures in this section take any of these widgets as their first parameter — in this wrapper, the parameter is typed as `pointer`, so the concrete type (`GtkEntry`, `GtkPasswordEntry`, etc.) is passed directly with no type casting needed.

### `gtk_editable_get_text` / `gtk_editable_set_text`

```nim
proc gtk_editable_get_text*(editable: pointer): cstring
proc gtk_editable_set_text*(editable: pointer, text: cstring)
```

**What it does.** Set and read the field's entire text at once. This is the primary way to work with an input field's contents in GTK4 — the old `gtk_entry_set_text`/`gtk_entry_get_text` functions from GTK3 are declared non-functional in GTK4 (in this wrapper they are commented out rather than removed entirely, to explicitly show what they need to be replaced with) precisely in favor of this pair, common to all Editable widgets.

- `editable` — any Editable widget (`GtkEntry`, `GtkPasswordEntry`, `GtkSearchEntry`).
- `text` — the field's new text.

```nim
let entry = gtk_entry_new()
gtk_editable_set_text(entry, "initial value")
echo "Field text: ", $gtk_editable_get_text(entry)
# prints "Field text: initial value"
```

---

### `gtk_editable_get_chars`

```nim
proc gtk_editable_get_chars*(editable: pointer, startPos: gint, endPos: gint): cstring
```

**What it does.** Returns a substring of the field's text between the given character positions — unlike `get_text`, which always returns the entire content, this function reads only the selected range. A negative value of `endPos` (`-1`) means "to the end of the text".

- `editable` — an Editable widget.
- `startPos`, `endPos` — the bounds of the range in characters (not bytes — important for non-ASCII text).

```nim
gtk_editable_set_text(entry, "Hello, world!")
let firstWord = gtk_editable_get_chars(entry, 0, 5)
echo "First word: ", $firstWord  # prints "First word: Hello"
```

---

### `gtk_editable_insert_text` / `gtk_editable_delete_text`

```nim
proc gtk_editable_insert_text*(editable: pointer, text: cstring, length: gint, position: ptr gint)
proc gtk_editable_delete_text*(editable: pointer, startPos: gint, endPos: gint)
```

**What it does.** Insert text at an arbitrary position (not necessarily the cursor position) and delete a range of text. `gtk_editable_insert_text` is unusual in that its last parameter is a `ptr gint`: before the call it must hold the insertion position, and after the call GTK overwrites it with the position immediately **after** the inserted text — convenient for a sequence of consecutive inserts without manually recalculating offsets.

- `editable` — an Editable widget.
- `text` — the text to insert.
- `length` — the length of the inserted text in bytes (`-1` if `text` is an ordinary `NUL`-terminated string).
- `position` — a pointer to the insertion position (both on input and on output, see above).
- `startPos`, `endPos` (for `delete_text`) — the bounds of the range to delete, in characters.

```nim
var pos: gint = 0
gtk_editable_insert_text(entry, "Hello, ", -1, addr pos)
echo "Text after position ", pos, " will be continued by the next insert"
gtk_editable_delete_text(entry, 0, 5)  # delete the first 5 characters
```

---

### `gtk_editable_get_selection_bounds` / `gtk_editable_select_region` / `gtk_editable_delete_selection`

```nim
proc gtk_editable_get_selection_bounds*(editable: pointer, startPos: ptr gint, endPos: ptr gint): gboolean
proc gtk_editable_select_region*(editable: pointer, startPos: gint, endPos: gint)
proc gtk_editable_delete_selection*(editable: pointer)
```

**What it does.** Read the bounds of the current text selection, set the selection programmatically, and delete the selected text. `gtk_editable_get_selection_bounds` returns a `gboolean` reporting whether there's an active selection at all — if there is no selection, the values behind the `startPos`/`endPos` pointers are undefined.

- `editable` — an Editable widget.
- `startPos`, `endPos` — the bounds of the selection range, in characters.

```nim
gtk_editable_select_region(entry, 0, 5)  # select the first 5 characters
var start, stop: gint
if gtk_editable_get_selection_bounds(entry, addr start, addr stop) != 0.gboolean:
  echo "Selected from ", start, " to ", stop
gtk_editable_delete_selection(entry)  # erase the selected text, as if Delete were pressed
```

---

### `gtk_editable_set_position` / `gtk_editable_get_position`

```nim
proc gtk_editable_set_position*(editable: pointer, position: gint)
proc gtk_editable_get_position*(editable: pointer): gint
```

**What it does.** Set and read the position of the text cursor within the field (in characters from the start of the text, disregarding any selection). A value of `-1` for `set_position` moves the cursor to the end of the text.

- `editable` — an Editable widget.
- `position` — the cursor position in characters, or `-1` for the end of the text.

```nim
gtk_editable_set_position(entry, -1)  # move the cursor to the end
echo "Current cursor position: ", gtk_editable_get_position(entry)
```

---

### `gtk_editable_set_editable` / `gtk_editable_get_editable`

```nim
proc gtk_editable_set_editable*(editable: pointer, isEditable: gboolean)
proc gtk_editable_get_editable*(editable: pointer): gboolean
```

**What it does.** Allow/forbid the user from editing the text without disabling the widget itself entirely (unlike `gtk_widget_set_sensitive` from the basic reference, after which the field looks "greyed out" and doesn't accept focus at all). A field with `editable = false` looks like an ordinary active field, lets the user select and copy the text, but does not let them change it — suitable for showing read-only values within a form that has a uniform appearance.

- `editable` — an Editable widget.
- `isEditable` — `1.gboolean` to allow editing.

```nim
gtk_editable_set_text(readonlyIdField, "USR-00123")
gtk_editable_set_editable(readonlyIdField, 0.gboolean)
echo "The ID field can be viewed and copied, but not edited"
```

---

### `gtk_editable_set_alignment` / `gtk_editable_get_alignment`

```nim
proc gtk_editable_set_alignment*(editable: pointer, xalign: gfloat)
proc gtk_editable_get_alignment*(editable: pointer): gfloat
```

**What it does.** Set the horizontal alignment of the text within the field as a fractional value from `0.0` (left-aligned) to `1.0` (right-aligned) — the counterpart of `gtk_label_set_xalign` from the basic controls reference, but for an editable field. Useful for numeric-value fields, which are traditionally right-aligned.

- `editable` — an Editable widget.
- `xalign` — a value from `0.0` to `1.0`.

```nim
gtk_editable_set_alignment(quantityEntry, 1.0)  # numbers are pushed to the right edge of the field
echo "Quantity field alignment: ", gtk_editable_get_alignment(quantityEntry)
```

---

### `gtk_editable_set_width_chars` / `gtk_editable_get_width_chars` / `gtk_editable_set_max_width_chars` / `gtk_editable_get_max_width_chars`

```nim
proc gtk_editable_set_width_chars*(editable: pointer, nChars: gint)
proc gtk_editable_get_width_chars*(editable: pointer): gint
proc gtk_editable_set_max_width_chars*(editable: pointer, nChars: gint)
proc gtk_editable_get_max_width_chars*(editable: pointer): gint
```

**What it does.** Set the minimum (`width_chars`) and maximum (`max_width_chars`) width of the field in characters — the same logic as `gtk_label_set_width_chars`/`set_max_width_chars` from the basic controls reference, applied to an editable field. Do not confuse this with `gtk_entry_set_max_length` (section II) — that limits the **number of characters that can be typed in**, not the visual width of the field.

- `editable` — an Editable widget.
- `nChars` — the number of characters, or `-1` for no limit.

```nim
gtk_editable_set_width_chars(zipCodeEntry, 6)
gtk_editable_set_max_width_chars(zipCodeEntry, 6)
echo "ZIP code field is exactly 6 characters wide"
```

---

### `gtk_editable_set_enable_undo` / `gtk_editable_get_enable_undo`

```nim
proc gtk_editable_set_enable_undo*(editable: pointer, enableUndo: gboolean)
proc gtk_editable_get_enable_undo*(editable: pointer): gboolean
```

**What it does.** Enable/disable GTK's built-in support for undo/redo of input (`Ctrl+Z`/`Ctrl+Shift+Z`) for a specific field — enabled by default. Disabling it makes sense for fields where an edit history isn't needed or could confuse the user (for example, a field whose value is overwritten programmatically from outside, rather than only through user input).

- `editable` — an Editable widget.
- `enableUndo` — `0.gboolean` to disable the undo history for this field.

```nim
gtk_editable_set_enable_undo(autoGeneratedField, 0.gboolean)
echo "Undo history disabled for the auto-filled field"
```

---

## GtkEntry

`GtkEntry` is the standard single-line input field. The text itself, the cursor, and the selection are managed by the `GtkEditable` interface (section I) — the procedures in this section handle everything else: appearance, input restrictions, icons inside the field, the progress indicator, and hints for on-screen keyboards/input methods.

### `gtk_entry_new` / `gtk_entry_new_with_buffer`

```nim
proc gtk_entry_new*(): GtkEntry
proc gtk_entry_new_with_buffer*(buffer: GtkEntryBuffer): GtkEntry
```

**What it does.** Create an input field — with its own internal text buffer (`gtk_entry_new`), or with a pre-prepared shared buffer (`gtk_entry_new_with_buffer`). A shared buffer (`GtkEntryBuffer`) lets several input fields display and edit the same text in sync — a specialized scenario; aside from it, `gtk_entry_new` is sufficient in the vast majority of cases.

- `buffer` — a previously created `GtkEntryBuffer` (see `gtk_entry_set_buffer` below).

```nim
let nameEntry = gtk_entry_new()
echo "Name input field created"
```

---

### `gtk_entry_set_placeholder_text` / `gtk_entry_get_placeholder_text`

```nim
proc gtk_entry_set_placeholder_text*(entry: GtkEntry, text: cstring)
proc gtk_entry_get_placeholder_text*(entry: GtkEntry): cstring
```

**What it does.** Set a hint text shown inside the field in grey while the field is empty, disappearing once typing begins (the typical "placeholder" pattern from web forms). This is not the field's value — `gtk_editable_get_text` for an empty field with a placeholder set will still return an empty string, not the hint text.

- `entry` — the input field.
- `text` — the hint text.

```nim
gtk_entry_set_placeholder_text(searchBox, "Search by name...")
echo "Placeholder text set: ", $gtk_entry_get_placeholder_text(searchBox)
```

---

### `gtk_entry_set_visibility` / `gtk_entry_get_visibility`

```nim
proc gtk_entry_set_visibility*(entry: GtkEntry, visible: gboolean)
proc gtk_entry_get_visibility*(entry: GtkEntry): gboolean
```

**What it does.** Turn the display of the typed text as-is on/off — when `visible = false`, a mask character is shown instead of the characters (see `gtk_entry_set_invisible_char`), as in a password field. For a full-fledged password field in GTK4, `GtkPasswordEntry` (section III) is normally used instead of a `GtkEntry` with visibility turned off — this setting is kept for cases where you specifically need a field with `GtkEntry` behavior (for example, with its own autocomplete icon) but with masked text.

- `entry` — the input field.
- `visible` — `0.gboolean` to mask the typed text.

```nim
gtk_entry_set_visibility(pinEntry, 0.gboolean)
echo "Field text is masked: ", gtk_entry_get_visibility(pinEntry) == 0.gboolean
```

---

### `gtk_entry_set_max_length` / `gtk_entry_get_max_length`

```nim
proc gtk_entry_set_max_length*(entry: GtkEntry, max: gint)
proc gtk_entry_get_max_length*(entry: GtkEntry): gint
```

**What it does.** Limit the maximum number of characters the user can type into the field — an attempt to type more is simply ignored at the widget level (unlike `gtk_editable_set_max_width_chars` from section I, which only limits the visual width, not the amount of text that can be entered). `0` means no limit.

- `entry` — the input field.
- `max` — the maximum number of characters, `0` for no limit.

```nim
gtk_entry_set_max_length(pinEntry, 4)
echo "Maximum PIN length: ", gtk_entry_get_max_length(pinEntry)
```

---

### `gtk_entry_set_has_frame` / `gtk_entry_get_has_frame`

```nim
proc gtk_entry_set_has_frame*(entry: GtkEntry, setting: gboolean)
proc gtk_entry_get_has_frame*(entry: GtkEntry): gboolean
```

**What it does.** Remove/restore the field's standard frame — the counterpart of `gtk_button_set_has_frame` from the basic controls reference. Used for fields embedded in a toolbar or a composite widget, where a separate field frame is visually redundant against the container's overall frame.

- `entry` — the input field.
- `setting` — `0.gboolean` to remove the frame.

```nim
gtk_entry_set_has_frame(inlineEditEntry, 0.gboolean)
echo "Frameless field, for embedding in a composite widget"
```

---

### `gtk_entry_set_alignment` / `gtk_entry_get_alignment`

```nim
proc gtk_entry_set_alignment*(entry: GtkEntry, xalign: gfloat)
proc gtk_entry_get_alignment*(entry: GtkEntry): gfloat
```

**What it does.** The same as `gtk_editable_set_alignment`/`get_alignment` from section I, but declared separately as `GtkEntry`'s own function — a historical duplication in GTK's own public API (both functions do the same thing for `GtkEntry`, since `GtkEntry` implements `GtkEditable`). There is no behavioral difference — it doesn't matter which of the two you use.

- `entry` — the input field.
- `xalign` — a value from `0.0` to `1.0`.

```nim
gtk_entry_set_alignment(priceEntry, 1.0)
echo "Price field right-aligned"
```

---

### `gtk_entry_set_buffer` / `gtk_entry_get_buffer`

```nim
proc gtk_entry_set_buffer*(entry: GtkEntry, buffer: GtkEntryBuffer)
proc gtk_entry_get_buffer*(entry: GtkEntry): GtkEntryBuffer
```

**What it does.** Set and read the field's internal text buffer — the same object that can be passed directly into the `gtk_entry_new_with_buffer` constructor. Changing the buffer of an already-existing field entirely replaces its text with the new buffer's text; several fields using the same `GtkEntryBuffer` object automatically keep their text in sync.

- `entry` — the input field.
- `buffer` — a `GtkEntryBuffer` object.

```nim
let sharedBuffer = gtk_entry_get_buffer(primaryEntry)
gtk_entry_set_buffer(mirrorEntry, sharedBuffer)
echo "Two fields now show and edit the same text"
```

---

### `gtk_entry_set_invisible_char` / `gtk_entry_get_invisible_char` / `gtk_entry_unset_invisible_char`

```nim
proc gtk_entry_set_invisible_char*(entry: GtkEntry, ch: gunichar)
proc gtk_entry_get_invisible_char*(entry: GtkEntry): gunichar
proc gtk_entry_unset_invisible_char*(entry: GtkEntry)
```

**What it does.** Set the character used to mask the text when visibility is turned off (`gtk_entry_set_visibility(entry, 0.gboolean)`) — the "black dot" character (`•`) is used by default. `gtk_entry_unset_invisible_char` restores the mask character to its default value.

- `entry` — the input field.
- `ch` — the mask character (`gunichar` — a Unicode code point, not a single-byte `char`).

```nim
gtk_entry_set_visibility(pinEntry, 0.gboolean)
gtk_entry_set_invisible_char(pinEntry, gunichar(ord('*')))
echo "Mask character changed to an asterisk"
```

---

### `gtk_entry_set_activates_default` / `gtk_entry_get_activates_default`

```nim
proc gtk_entry_set_activates_default*(entry: GtkEntry, setting: gboolean)
proc gtk_entry_get_activates_default*(entry: GtkEntry): gboolean
```

**What it does.** Enable the behavior "pressing Enter in the field activates the window's/dialog's default button" — without this, pressing Enter in an input field does nothing at the window level (it only emits the field's own `"activate"` signal). A required setting for form fields where submission on Enter is expected (see the "Submitting a form on Enter" recipe in section V).

- `entry` — the input field.
- `setting` — `1.gboolean` to enable activation of the default button.

```nim
gtk_entry_set_activates_default(passwordEntry, 1.gboolean)
echo "Enter in the password field now activates the default login button"
```

---

### `gtk_entry_set_attributes` / `gtk_entry_get_attributes`

```nim
proc gtk_entry_set_attributes*(entry: GtkEntry, attrs: PangoAttrList)
proc gtk_entry_get_attributes*(entry: GtkEntry): PangoAttrList
```

**What it does.** Set and read the list of Pango formatting attributes for the field's text — the same logic as `gtk_label_set_attributes`/`get_attributes` from the basic controls reference. Applicable, for example, for syntax highlighting in a command-input field.

- `entry` — the input field.
- `attrs` — the list of Pango attributes.

```nim
# attrs is built beforehand via pango_attr_list_new/pango_attr_list_insert
gtk_entry_set_attributes(commandEntry, attrs)
echo "Formatting attributes applied to the command input field"
```

---

### `gtk_entry_set_tabs` / `gtk_entry_get_tabs`

```nim
proc gtk_entry_set_tabs*(entry: GtkEntry, tabs: PangoTabArray)
proc gtk_entry_get_tabs*(entry: GtkEntry): PangoTabArray
```

**What it does.** Set tab-stop positions for `\t` characters within the field's text — the same logic as `gtk_label_set_tabs`. This setting is less relevant for a single-line input field than for multiline text, but the option is kept, since `GtkEntry` does in principle support a tab character within its content.

- `entry` — the input field.
- `tabs` — a Pango array of tab-stop positions.

```nim
# tabArray is built beforehand via pango_tab_array_new/pango_tab_array_set_tab
gtk_entry_set_tabs(commandEntry, tabArray)
echo "Tab-stop positions set for the command input field"
```

---

### `gtk_entry_set_progress_fraction` / `gtk_entry_get_progress_fraction` / `set_progress_pulse_step` / `get_progress_pulse_step` / `gtk_entry_progress_pulse`

```nim
proc gtk_entry_set_progress_fraction*(entry: GtkEntry, fraction: gdouble)
proc gtk_entry_get_progress_fraction*(entry: GtkEntry): gdouble
proc gtk_entry_set_progress_pulse_step*(entry: GtkEntry, fraction: gdouble)
proc gtk_entry_get_progress_pulse_step*(entry: GtkEntry): gdouble
proc gtk_entry_progress_pulse*(entry: GtkEntry)
```

**What it does.** Show a progress indicator right inside the input field, over the text — an unusual but built-in `GtkEntry` capability, useful, for example, for an address field indicating that a page is loading, or a field with a background asynchronous check of the entered value. `set_progress_fraction` sets the exact completion fraction from `0.0` to `1.0` (for operations with known progress). For operations of unknown duration, a "pulsing" mode is used: `set_progress_pulse_step` sets the pulse step, and each call to `gtk_entry_progress_pulse` shifts the indicator by that step — you need to call `progress_pulse` periodically yourself (for example, on a timer); there is no automatic animation.

- `entry` — the input field.
- `fraction` — the completion fraction from `0.0` to `1.0`.

```nim
gtk_entry_set_progress_pulse_step(urlEntry, 0.1)
proc onPulseTimeout(userData: gpointer): gboolean {.cdecl.} =
  gtk_entry_progress_pulse(urlEntry)
  result = 1.gboolean  # 1 — keep calling the timer
# g_timeout_add(200, onPulseTimeout, nil)  # starting the timer — see the GLib timers reference
echo "Pulsing loading indicator configured with a step of 0.1"
```

---

### `gtk_entry_set_completion` / `gtk_entry_get_completion`

```nim
proc gtk_entry_set_completion*(entry: GtkEntry, completion: GtkEntryCompletion)
proc gtk_entry_get_completion*(entry: GtkEntry): GtkEntryCompletion
```

**What it does.** Attach a popup autocomplete list (`GtkEntryCompletion`) to the field — a dropdown list of options that filters as you type. Building the `GtkEntryCompletion` object itself (the data model, the text column) is a separate topic, outside the scope of this reference.

- `entry` — the input field.
- `completion` — a previously configured `GtkEntryCompletion` object.

```nim
# completion is built beforehand via gtk_entry_completion_new + configuring the model
gtk_entry_set_completion(cityEntry, completion)
echo "Autocomplete attached to the city field"
```

---

### `gtk_entry_get_text_length`

```nim
proc gtk_entry_get_text_length*(entry: GtkEntry): guint16
```

**What it does.** Returns the current length of the field's text in characters. Functionally equivalent to `len($gtk_editable_get_text(entry))` (adjusting for the fact that Nim's `len` for a string counts UTF-8 bytes, not Unicode characters) — this call is faster, since it doesn't require copying the whole string just to count its length.

- `entry` — the input field.

```nim
echo "Characters entered: ", gtk_entry_get_text_length(bioEntry)
```

---

### Icons inside the field: `gtk_entry_set_icon_from_icon_name` and related functions

```nim
proc gtk_entry_set_icon_from_icon_name*(entry: GtkEntry, icon_pos: GtkEntryIconPosition, icon_name: cstring)
proc gtk_entry_set_icon_from_gicon*(entry: GtkEntry, icon_pos: GtkEntryIconPosition, icon: GIcon)
proc gtk_entry_set_icon_from_paintable*(entry: GtkEntry, icon_pos: GtkEntryIconPosition, paintable: GdkPaintable)
proc gtk_entry_get_icon_storage_type*(entry: GtkEntry, icon_pos: GtkEntryIconPosition): GtkImageType
proc gtk_entry_get_icon_name*(entry: GtkEntry, icon_pos: GtkEntryIconPosition): cstring
proc gtk_entry_get_icon_gicon*(entry: GtkEntry, icon_pos: GtkEntryIconPosition): GIcon
proc gtk_entry_get_icon_paintable*(entry: GtkEntry, icon_pos: GtkEntryIconPosition): GdkPaintable
proc gtk_entry_set_icon_activatable*(entry: GtkEntry, icon_pos: GtkEntryIconPosition, activatable: gboolean)
proc gtk_entry_get_icon_activatable*(entry: GtkEntry, icon_pos: GtkEntryIconPosition): gboolean
proc gtk_entry_set_icon_sensitive*(entry: GtkEntry, icon_pos: GtkEntryIconPosition, sensitive: gboolean)
proc gtk_entry_get_icon_sensitive*(entry: GtkEntry, icon_pos: GtkEntryIconPosition): gboolean
proc gtk_entry_set_icon_tooltip_text*(entry: GtkEntry, icon_pos: GtkEntryIconPosition, tooltip: cstring)
proc gtk_entry_get_icon_tooltip_text*(entry: GtkEntry, icon_pos: GtkEntryIconPosition): cstring
proc gtk_entry_set_icon_tooltip_markup*(entry: GtkEntry, icon_pos: GtkEntryIconPosition, tooltip: cstring)
proc gtk_entry_get_icon_tooltip_markup*(entry: GtkEntry, icon_pos: GtkEntryIconPosition): cstring
proc gtk_entry_get_icon_at_pos*(entry: GtkEntry, x: gint, y: gint): gint
```

**What it does.** A large group of functions manages two icon "slots" inside the field — at the start (`GTK_ENTRY_ICON_PRIMARY`) and at the end (`GTK_ENTRY_ICON_SECONDARY`) of the text. This is exactly how GTK4 implements typical patterns like "search icon on the left, clear button on the right" in `GtkSearchEntry`, or "validity icon on the right" in a form. An icon can be set by name from the theme (`from_icon_name`), as an arbitrary `GIcon`, or directly as a ready-made image (`from_paintable`); `get_icon_storage_type` reports which of the three ways the current icon in the slot was set (`GTK_IMAGE_EMPTY` if there is no icon). An icon can be made clickable (`set_icon_activatable`) — in which case a click on it emits the `"icon-press"` signal — and given a tooltip (`set_icon_tooltip_text`/`_markup`). `get_icon_at_pos` determines whether a pixel coordinate lies over one of the icons (returns the icon slot's index, or `-1` if the coordinate isn't over an icon).

- `entry` — the input field.
- `icon_pos` — `GTK_ENTRY_ICON_PRIMARY` or `GTK_ENTRY_ICON_SECONDARY`.
- `icon_name` / `icon` / `paintable` — the source of the icon image (one of three mutually exclusive ways).
- `activatable`, `sensitive` — `1.gboolean`/`0.gboolean`.
- `tooltip` — the tooltip text for the icon.

```nim
gtk_entry_set_icon_from_icon_name(searchLikeEntry, GTK_ENTRY_ICON_SECONDARY, "edit-clear-symbolic")
gtk_entry_set_icon_activatable(searchLikeEntry, GTK_ENTRY_ICON_SECONDARY, 1.gboolean)
gtk_entry_set_icon_tooltip_text(searchLikeEntry, GTK_ENTRY_ICON_SECONDARY, "Clear")

proc onIconPress(entry: GtkEntry, iconPos: GtkEntryIconPosition, userData: gpointer) {.cdecl.} =
  if iconPos == GTK_ENTRY_ICON_SECONDARY:
    gtk_editable_set_text(entry, "")
    echo "Field cleared by clicking the icon"

discard g_signal_connect(searchLikeEntry, "icon-press", onIconPress, nil)
```

---

### `gtk_entry_set_input_purpose` / `gtk_entry_get_input_purpose` / `gtk_entry_set_input_hints` / `gtk_entry_get_input_hints`

```nim
proc gtk_entry_set_input_purpose*(entry: GtkEntry, purpose: GtkInputPurpose)
proc gtk_entry_get_input_purpose*(entry: GtkEntry): GtkInputPurpose
proc gtk_entry_set_input_hints*(entry: GtkEntry, hints: GtkInputHints)
proc gtk_entry_get_input_hints*(entry: GtkEntry): GtkInputHints
```

**What it does.** Tell the input system (primarily the on-screen keyboard on touch devices, but this also affects input methods and autocorrect) the semantic purpose of the field. `input_purpose` is the content category as a single value (`GTK_INPUT_PURPOSE_EMAIL`, `_PHONE`, `_DIGITS`, `_PASSWORD`, `_URL`, and so on) — the on-screen keyboard might, for example, show a special layout with an `@` key for email. `input_hints` is an independent bitmask of additional instructions (`GTK_INPUT_HINT_NO_SPELLCHECK`, `_UPPERCASE_WORDS`, `_WORD_COMPLETION`, etc.), combined with `or`.

- `entry` — the input field.
- `purpose` — a `GtkInputPurpose` value.
- `hints` — a bitmask of `GtkInputHints` values.

```nim
gtk_entry_set_input_purpose(emailEntry, GTK_INPUT_PURPOSE_EMAIL)
gtk_entry_set_input_hints(emailEntry, GTK_INPUT_HINT_NO_SPELLCHECK)
echo "Email field configured: no spellcheck, with an email-oriented keyboard"
```

---

### `gtk_entry_set_extra_menu` / `gtk_entry_get_extra_menu`

```nim
proc gtk_entry_set_extra_menu*(entry: GtkEntry, model: GMenuModel)
proc gtk_entry_get_extra_menu*(entry: GtkEntry): GMenuModel
```

**What it does.** Add extra items to the field's standard context menu (which usually contains "Cut"/"Copy"/"Paste") — the same logic as `gtk_label_set_extra_menu`.

- `entry` — the input field.
- `model` — the additional menu model.

```nim
# extraMenuModel is built beforehand via g_menu_new/g_menu_append
gtk_entry_set_extra_menu(commandEntry, extraMenuModel)
echo "Extra items added to the field's context menu"
```

---

### `gtk_entry_reset_im_context`

```nim
proc gtk_entry_reset_im_context*(entry: GtkEntry)
```

**What it does.** Resets the state of the current input method (Input Method — the mechanism used, for example, for typing in languages with complex layouts: Chinese, Japanese, Korean, or for entering composite characters). Needed in rare cases — for example, if a field was cleared programmatically during an unfinished composite-character input, and you need to explicitly abort that input process rather than leave the input method in a desynchronized state.

- `entry` — the input field.

```nim
gtk_editable_set_text(entry, "")
gtk_entry_reset_im_context(entry)
echo "Input method state reset along with clearing the field"
```

---

### `gtk_entry_grab_focus_without_selecting`

```nim
proc gtk_entry_grab_focus_without_selecting*(entry: GtkEntry): gboolean
```

**What it does.** Gives the field keyboard focus without selecting all of its text — the ordinary `gtk_widget_grab_focus` (basic reference) selects all the text in a `GtkEntry` by default when it receives focus (standard input-field behavior, convenient for quickly replacing a value). This function is needed when that behavior is undesirable — for example, when programmatically returning focus to a field the user was already typing into, where selecting the text would be unexpected for them.

- `entry` — the input field.

```nim
discard gtk_entry_grab_focus_without_selecting(entry)
echo "Focus given to the field without selecting its current content"
```

---

## GtkPasswordEntry

`GtkPasswordEntry` is a specialized field for entering a password: the text is always masked, and the widget adds only one feature on top of standard masking — a "show password" (peek) button. Working with the password text itself goes through the same `GtkEditable` interface (section I) — `gtk_editable_get_text`/`set_text`.

### `gtk_password_entry_new`

```nim
proc gtk_password_entry_new*(): GtkPasswordEntry
```

**What it does.** Creates a password input field with text masking already enabled and a peek button by default.

- No parameters.

```nim
let passwordEntry = gtk_password_entry_new()
echo "Password field created"
```

---

### `gtk_password_entry_set_show_peek_icon` / `gtk_password_entry_get_show_peek_icon`

```nim
proc gtk_password_entry_set_show_peek_icon*(entry: GtkPasswordEntry, showPeekIcon: gboolean)
proc gtk_password_entry_get_show_peek_icon*(entry: GtkPasswordEntry): gboolean
```

**What it does.** Show/hide the peek button, which lets the user temporarily see the entered password in plain text. The button is shown by default; disabling it is appropriate for fields with heightened privacy requirements (for example, re-entering a PIN in a public place), or when the password is shown/hidden through a separate custom button implemented by the application itself.

- `entry` — the password field.
- `showPeekIcon` — `0.gboolean` to hide the peek button.

```nim
gtk_password_entry_set_show_peek_icon(pinEntry, 0.gboolean)
echo "Peek button hidden: ", gtk_password_entry_get_show_peek_icon(pinEntry) == 0.gboolean
```

---

### `gtk_password_entry_set_extra_menu` / `gtk_password_entry_get_extra_menu`

```nim
proc gtk_password_entry_set_extra_menu*(entry: GtkPasswordEntry, model: GMenuModel)
proc gtk_password_entry_get_extra_menu*(entry: GtkPasswordEntry): GMenuModel
```

**What it does.** Add extra items to the password field's context menu — the same logic as `gtk_entry_set_extra_menu`. Note: a password field's default context menu does not contain a "Copy" item (for security reasons) — adding your own items via `extra_menu` does not restore this capability automatically.

- `entry` — the password field.
- `model` — the additional menu model.

```nim
# extraMenuModel is built beforehand via g_menu_new/g_menu_append
gtk_password_entry_set_extra_menu(passwordEntry, extraMenuModel)
echo "Extra items added to the password field's context menu"
```

---

## GtkSearchEntry

`GtkSearchEntry` is a field specialized for search: with a built-in magnifying-glass icon, a clear button that appears when the text isn't empty, and signals optimized for live search as text is typed (with a delay, so as not to trigger a search on every keystroke). The field's text is again handled through `GtkEditable` (section I).

### `gtk_search_entry_new`

```nim
proc gtk_search_entry_new*(): GtkSearchEntry
```

**What it does.** Creates a search field with a magnifying-glass icon on the left and a clear button that automatically appears on the right when the field isn't empty.

- No parameters.

```nim
let searchEntry = gtk_search_entry_new()
echo "Search field created"
```

---

### `gtk_search_entry_set_placeholder_text` / `gtk_search_entry_get_placeholder_text`

```nim
proc gtk_search_entry_set_placeholder_text*(entry: GtkSearchEntry, text: cstring)
proc gtk_search_entry_get_placeholder_text*(entry: GtkSearchEntry): cstring
```

**What it does.** The same as `gtk_entry_set_placeholder_text` from section II, but as a separate `GtkSearchEntry` function — hint text shown while the field is empty.

- `entry` — the search field.
- `text` — the hint text.

```nim
gtk_search_entry_set_placeholder_text(searchEntry, "Search contacts")
echo "Search field placeholder: ", $gtk_search_entry_get_placeholder_text(searchEntry)
```

---

### `gtk_search_entry_set_search_delay` / `gtk_search_entry_get_search_delay`

```nim
proc gtk_search_entry_set_search_delay*(entry: GtkSearchEntry, delay: guint)
proc gtk_search_entry_get_search_delay*(entry: GtkSearchEntry): guint
```

**What it does.** Set the delay in milliseconds between the last keystroke and the emission of the `"search-changed"` signal — unlike the `"changed"` signal (emitted immediately on every text change, inherited from `GtkEditable`), `"search-changed"` is specifically meant for triggering the actual search, and "collapses" a quick run of keystrokes into a single firing after a pause in typing. This removes the need to implement debouncing yourself with a timer.

- `entry` — the search field.
- `delay` — the delay in milliseconds (the default value is 150 ms).

```nim
gtk_search_entry_set_search_delay(searchEntry, 300)

proc onSearchChanged(entry: GtkSearchEntry, userData: gpointer) {.cdecl.} =
  echo "Running search for: ", $gtk_editable_get_text(entry)

discard g_signal_connect(searchEntry, "search-changed", onSearchChanged, nil)
echo "Search fires after a 300 ms pause in typing"
```

---

### `gtk_search_entry_set_key_capture_widget` / `gtk_search_entry_get_key_capture_widget`

```nim
proc gtk_search_entry_set_key_capture_widget*(entry: GtkSearchEntry, widget: GtkWidget)
proc gtk_search_entry_get_key_capture_widget*(entry: GtkSearchEntry): GtkWidget
```

**What it does.** Link the search field to another widget (usually a results list/tree, or an entire window) so that starting to type within the given widget automatically transfers focus and the typed characters to the search field, even if the user hasn't explicitly clicked into the field — the "start typing to search" pattern familiar from file managers.

- `entry` — the search field.
- `widget` — the widget (or window) within which keystrokes should be captured by the search field.

```nim
gtk_search_entry_set_key_capture_widget(searchEntry, resultsListView)
echo "Typing in the results list is now automatically redirected to the search field"
```

---

### `gtk_search_entry_set_input_purpose` / `gtk_search_entry_get_input_purpose` / `set_input_hints` / `get_input_hints`

```nim
proc gtk_search_entry_set_input_purpose*(entry: GtkSearchEntry, purpose: GtkInputPurpose)
proc gtk_search_entry_get_input_purpose*(entry: GtkSearchEntry): GtkInputPurpose
proc gtk_search_entry_set_input_hints*(entry: GtkSearchEntry, hints: GtkInputHints)
proc gtk_search_entry_get_input_hints*(entry: GtkSearchEntry): GtkInputHints
```

**What it does.** The same as `gtk_entry_set_input_purpose`/`set_input_hints` from section II, applied to the search field — the content's purpose for the on-screen keyboard, and additional hints (for example, disabling auto-capitalization, appropriate for search, where case usually doesn't matter).

- `entry` — the search field.
- `purpose` — a `GtkInputPurpose` value (for search this is usually left at `GTK_INPUT_PURPOSE_FREE_FORM`, the default).
- `hints` — a bitmask of `GtkInputHints` values.

```nim
gtk_search_entry_set_input_hints(searchEntry, GTK_INPUT_HINT_NO_SPELLCHECK)
echo "Spellcheck disabled for the search field"
```

---

## Practical recipes

### A login form: username + password with a peek button

The standard combination of a username field and a `GtkPasswordEntry` — the peek button is already built in, no extra configuration needed.

```nim
proc buildLoginForm(): GtkGrid =
  result = gtk_grid_new()
  gtk_grid_set_row_spacing(result, 8)
  gtk_grid_set_column_spacing(result, 12)

  let loginLabel = gtk_label_new("Username:")
  gtk_widget_set_halign(loginLabel, GTK_ALIGN_END)
  let loginEntry = gtk_entry_new()
  gtk_entry_set_placeholder_text(loginEntry, "username")
  gtk_widget_set_hexpand(loginEntry, 1.gboolean)
  gtk_grid_attach(result, loginLabel, 0, 0, 1, 1)
  gtk_grid_attach(result, loginEntry, 1, 0, 1, 1)

  let passwordLabel = gtk_label_new("Password:")
  gtk_widget_set_halign(passwordLabel, GTK_ALIGN_END)
  let passwordEntry = gtk_password_entry_new()
  gtk_entry_set_activates_default(passwordEntry, 1.gboolean)
  gtk_grid_attach_next_to(result, passwordLabel, loginLabel, GTK_POS_BOTTOM, 1, 1)
  gtk_grid_attach_next_to(result, passwordEntry, passwordLabel, GTK_POS_RIGHT, 1, 1)

  echo "Login form assembled: username + password with a peek button"

let loginForm = buildLoginForm()
```

---

### A search field with delay and live filtering

A full setup of `GtkSearchEntry` with a `"search-changed"` handler that only fires after a pause in typing.

```nim
proc onSearchChanged(entry: GtkSearchEntry, userData: gpointer) {.cdecl.} =
  let query = $gtk_editable_get_text(entry)
  if query.len == 0:
    echo "Query is empty — show all items"
  else:
    echo "Filtering the list by query: '", query, "'"

proc buildSearchBar(): GtkSearchEntry =
  result = gtk_search_entry_new()
  gtk_search_entry_set_placeholder_text(result, "Search...")
  gtk_search_entry_set_search_delay(result, 250)
  discard g_signal_connect(result, "search-changed", onSearchChanged, nil)

let searchBar = buildSearchBar()
```

---

### An email field with a validation icon

The icon at the end of the field changes depending on whether the entered text looks like an email — a simple "contains an `@` character" check, for the sake of the example.

```nim
proc onEmailChanged(entry: GtkEntry, userData: gpointer) {.cdecl.} =
  let text = $gtk_editable_get_text(entry)
  if text.len == 0:
    gtk_entry_set_icon_from_icon_name(entry, GTK_ENTRY_ICON_SECONDARY, nil)
  elif '@' in text:
    gtk_entry_set_icon_from_icon_name(entry, GTK_ENTRY_ICON_SECONDARY, "emblem-ok-symbolic")
    gtk_entry_set_icon_tooltip_text(entry, GTK_ENTRY_ICON_SECONDARY, "Looks like an email")
  else:
    gtk_entry_set_icon_from_icon_name(entry, GTK_ENTRY_ICON_SECONDARY, "dialog-warning-symbolic")
    gtk_entry_set_icon_tooltip_text(entry, GTK_ENTRY_ICON_SECONDARY, "Doesn't look like an email")

proc buildEmailField(): GtkEntry =
  result = gtk_entry_new()
  gtk_entry_set_placeholder_text(result, "you@example.com")
  gtk_entry_set_input_purpose(result, GTK_INPUT_PURPOSE_EMAIL)
  discard g_signal_connect(result, "changed", onEmailChanged, nil)

let emailField = buildEmailField()
echo "Email field with live icon-based validation assembled"
```

---

### An input field with a progress indicator (e.g. while checking a password)

A pulsing indicator inside the field while an asynchronous operation is in progress (for example, checking whether a username is already taken on the server).

```nim
var pulseActive = false

proc onPulseTick(userData: gpointer): gboolean {.cdecl.} =
  let entry = cast[GtkEntry](userData)
  if pulseActive:
    gtk_entry_progress_pulse(entry)
    result = 1.gboolean  # keep the timer going
  else:
    gtk_entry_set_progress_fraction(entry, 0.0)  # turn off the indicator
    result = 0.gboolean  # stop the timer

proc startAvailabilityCheck(entry: GtkEntry) =
  pulseActive = true
  gtk_entry_set_progress_pulse_step(entry, 0.15)
  # g_timeout_add(150, onPulseTick, cast[gpointer](entry))  # see the GLib timers reference
  echo "Username availability check started, indicator running"

proc finishAvailabilityCheck() =
  pulseActive = false
  echo "Check finished, indicator turned off"
```

---

### Submitting a form on Enter via `activates_default`

For pressing Enter in any field of the form to act like clicking the "Log in" button, the button must be set as the window's "default button", and the fields must have `activates_default` enabled.

```nim
proc buildLoginFormWithSubmit(window: GtkWindow): GtkBox =
  result = gtk_box_new(GTK_ORIENTATION_VERTICAL, 12)

  let loginEntry = gtk_entry_new()
  gtk_entry_set_activates_default(loginEntry, 1.gboolean)
  gtk_box_append(result, loginEntry)

  let passwordEntry = gtk_password_entry_new()
  gtk_entry_set_activates_default(passwordEntry, 1.gboolean)
  gtk_box_append(result, passwordEntry)

  let submitButton = gtk_button_new_with_label("Log in")
  gtk_widget_add_css_class(submitButton, "suggested-action")
  gtk_box_append(result, submitButton)

  # gtk_window_set_default_widget(window, submitButton) — see the WINDOW/WIDGET reference
  echo "Enter in any of the fields now activates the 'Log in' button"

# let loginBox = buildLoginFormWithSubmit(mainWindow)
```

---

## Summary table

| Procedure(s) | Category | What it does, briefly |
|---|---|---|
| `gtk_editable_get/set_text` | GtkEditable | The field's entire text — the primary way to work with its content |
| `gtk_editable_get_chars` | GtkEditable | A substring of the text by character range |
| `gtk_editable_insert_text`, `delete_text` | GtkEditable | Insert/delete text at an arbitrary position |
| `gtk_editable_get_selection_bounds`, `select_region`, `delete_selection` | GtkEditable | Working with the current selection |
| `gtk_editable_set/get_position` | GtkEditable | The text cursor's position |
| `gtk_editable_set/get_editable` | GtkEditable | Allow/forbid editing without disabling the field entirely |
| `gtk_editable_set/get_alignment` | GtkEditable | Horizontal alignment of the text in the field |
| `gtk_editable_set/get_width_chars`, `set/get_max_width_chars` | GtkEditable | Min./max. visual width of the field in characters |
| `gtk_editable_set/get_enable_undo` | GtkEditable | Built-in input undo history (Ctrl+Z) |
| `gtk_entry_new`, `_with_buffer` | Entry | Create a field — with its own or a shared text buffer |
| `gtk_entry_set/get_placeholder_text` | Entry | Hint text on an empty field |
| `gtk_entry_set/get_visibility` | Entry | Masking of the typed text |
| `gtk_entry_set/get_max_length` | Entry | Maximum number of characters that can be typed |
| `gtk_entry_set/get_has_frame` | Entry | The field's frame |
| `gtk_entry_set/get_alignment` | Entry | Text alignment (duplicates `gtk_editable_*`) |
| `gtk_entry_set/get_buffer` | Entry | Shared text buffer between several fields |
| `gtk_entry_set/get_invisible_char`, `unset_invisible_char` | Entry | Mask character when visibility is off |
| `gtk_entry_set/get_activates_default` | Entry | Enter in the field activates the window's default button |
| `gtk_entry_set/get_attributes` | Entry | Programmatic Pango formatting attributes |
| `gtk_entry_set/get_tabs` | Entry | Tab-stop positions for `\t` |
| `gtk_entry_set/get_progress_fraction`, `pulse_step`, `progress_pulse` | Entry | Progress indicator inside the field |
| `gtk_entry_set/get_completion` | Entry | Popup autocomplete list |
| `gtk_entry_get_text_length` | Entry | Fast retrieval of the text length without copying the string |
| `gtk_entry_set_icon_from_icon_name/gicon/paintable` | Entry | Icon at the start/end of the field |
| `gtk_entry_get_icon_storage_type` | Entry | Which method was used to set the icon in the slot |
| `gtk_entry_set/get_icon_activatable`, `set/get_icon_sensitive` | Entry | Clickability and availability of the icon |
| `gtk_entry_set/get_icon_tooltip_text/markup` | Entry | Tooltip for the icon |
| `gtk_entry_get_icon_at_pos` | Entry | Whether a coordinate lies over an icon |
| `gtk_entry_set/get_input_purpose`, `set/get_input_hints` | Entry | The field's purpose for the on-screen keyboard/input methods |
| `gtk_entry_set/get_extra_menu` | Entry | Extra items in the field's context menu |
| `gtk_entry_reset_im_context` | Entry | Resetting the input method's state |
| `gtk_entry_grab_focus_without_selecting` | Entry | Give focus without selecting all the text |
| `gtk_password_entry_new` | PasswordEntry | Create a password field |
| `gtk_password_entry_set/get_show_peek_icon` | PasswordEntry | The "show password" button |
| `gtk_password_entry_set/get_extra_menu` | PasswordEntry | Extra items in the password field's context menu |
| `gtk_search_entry_new` | SearchEntry | Create a search field |
| `gtk_search_entry_set/get_placeholder_text` | SearchEntry | Hint text |
| `gtk_search_entry_set/get_search_delay` | SearchEntry | Delay before the `"search-changed"` signal |
| `gtk_search_entry_set/get_key_capture_widget` | SearchEntry | Auto-redirecting typing from another widget |
| `gtk_search_entry_set/get_input_purpose`, `set/get_input_hints` | SearchEntry | The field's purpose for the on-screen keyboard |

---

## Summary: which procedure to choose

- **Working with the text of any input field** (get/set, selection, cursor position) → always `gtk_editable_*`, rather than separate functions of a specific class — the `GtkEditable` interface is the same for `GtkEntry`, `GtkPasswordEntry`, and `GtkSearchEntry`.
- **You need a password field** → `GtkPasswordEntry`, not a `GtkEntry` with `gtk_entry_set_visibility(entry, 0.gboolean)` — the specialized widget already gives you a peek button and correct context-menu behavior (no "Copy") out of the box.
- **You need a search field with live filtering** → `GtkSearchEntry` + the `"search-changed"` signal (already delayed via `gtk_search_entry_set_search_delay`), rather than `GtkEntry` + the `"changed"` signal with a hand-written debounce timer.
- **Limit how much the user can type** → `gtk_entry_set_max_length` (number of characters). **Limit how much space the field takes up on screen** → `gtk_editable_set_width_chars`/`set_max_width_chars` — these are two independent constraints that should not be confused with each other.
- **Pressing Enter should submit the form** → `gtk_entry_set_activates_default(entry, 1.gboolean)` on every field of the form, plus the submit button must be set as the window's default button.
- **An icon inside the field** (a magnifying glass, a clear cross, a validity indicator) → `gtk_entry_set_icon_from_icon_name`/`_from_gicon`/`_from_paintable` specifying `GTK_ENTRY_ICON_PRIMARY`/`_SECONDARY`, rather than a separate `GtkImage` next to the field — this way the icon is visually and functionally integrated into the field itself (clicking, tooltip).
- **A field only for displaying a value, with no editing but with selection and copying available** → `gtk_editable_set_editable(entry, 0.gboolean)`, rather than `gtk_widget_set_sensitive(entry, 0.gboolean)` — the latter also blocks text selection and copying.
- **A long-running background operation tied to the field** (a server-side check, a load) → a pulsing indicator via `gtk_entry_set_progress_pulse_step`/`gtk_entry_progress_pulse` if the duration is unknown, or `gtk_entry_set_progress_fraction` if the progress is known exactly.
