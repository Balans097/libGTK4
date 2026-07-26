# GTK4 (numeric & choice controls: Adjustment / SpinButton / Scale / ComboBoxText) — module reference

> **Import:** `import libGTK4`
> **Scope:** entering and displaying numeric values (a counter, a slider) and choosing a single option from a dropdown list. Sixth part of the wrapper reference series; assumes familiarity with the previous parts, especially `gtk4_core_reference_ru.md` (layout, `GtkWidget`).

The key feature of this section: `GtkSpinButton` and `GtkScale` do not store their numeric value, range, and step themselves — that's the job of `GtkAdjustment` ("range settings"), an object shared by both, which can either be created separately and passed to two widgets at once (in which case they automatically keep their value in sync with each other — the typical "slider + exact-number field next to it" pattern), or left for the widget to create its own `GtkAdjustment` implicitly via a shorthand constructor. That's why this reference starts with `GtkAdjustment`, the same way `GtkEditable` once preceded `GtkEntry`.

---

## Table of contents

I. [GtkAdjustment](#gtkadjustment)
&nbsp;&nbsp;1. [`gtk_adjustment_new`](#gtk_adjustment_new)
&nbsp;&nbsp;2. [`gtk_adjustment_set_value` / `gtk_adjustment_get_value`](#gtk_adjustment_set_value--gtk_adjustment_get_value)
&nbsp;&nbsp;3. [`gtk_adjustment_set_lower` / `gtk_adjustment_get_lower` / `gtk_adjustment_set_upper` / `gtk_adjustment_get_upper`](#gtk_adjustment_set_lower--gtk_adjustment_get_lower--gtk_adjustment_set_upper--gtk_adjustment_get_upper)

II. [GtkSpinButton](#gtkspinbutton)
&nbsp;&nbsp;1. [`gtk_spin_button_new` / `gtk_spin_button_new_with_range`](#gtk_spin_button_new--gtk_spin_button_new_with_range)
&nbsp;&nbsp;2. [`gtk_spin_button_set_adjustment` / `gtk_spin_button_get_adjustment`](#gtk_spin_button_set_adjustment--gtk_spin_button_get_adjustment)
&nbsp;&nbsp;3. [`gtk_spin_button_set_digits` / `gtk_spin_button_get_digits`](#gtk_spin_button_set_digits--gtk_spin_button_get_digits)
&nbsp;&nbsp;4. [`gtk_spin_button_set_value` / `gtk_spin_button_get_value` / `gtk_spin_button_get_value_as_int`](#gtk_spin_button_set_value--gtk_spin_button_get_value--gtk_spin_button_get_value_as_int)
&nbsp;&nbsp;5. [`gtk_spin_button_set_range` / `gtk_spin_button_get_range`](#gtk_spin_button_set_range--gtk_spin_button_get_range)

III. [GtkScale (and GtkRange)](#gtkscale-and-gtkrange)
&nbsp;&nbsp;1. [`gtk_scale_new` / `gtk_scale_new_with_range`](#gtk_scale_new--gtk_scale_new_with_range)
&nbsp;&nbsp;2. [`gtk_scale_set_digits` / `gtk_scale_get_digits`](#gtk_scale_set_digits--gtk_scale_get_digits)
&nbsp;&nbsp;3. [`gtk_scale_set_draw_value` / `gtk_scale_get_draw_value`](#gtk_scale_set_draw_value--gtk_scale_get_draw_value)
&nbsp;&nbsp;4. [`gtk_scale_set_value_pos` / `gtk_scale_get_value_pos`](#gtk_scale_set_value_pos--gtk_scale_get_value_pos)
&nbsp;&nbsp;5. [`gtk_range_set_value`](#gtk_range_set_value)

IV. [GtkComboBoxText (and GtkComboBox)](#gtkcomboboxtext-and-gtkcombobox)
&nbsp;&nbsp;1. [`gtk_combo_box_text_new` / `gtk_combo_box_text_new_with_entry`](#gtk_combo_box_text_new--gtk_combo_box_text_new_with_entry)
&nbsp;&nbsp;2. [`gtk_combo_box_text_append` / `gtk_combo_box_text_prepend` / `gtk_combo_box_text_insert`](#gtk_combo_box_text_append--gtk_combo_box_text_prepend--gtk_combo_box_text_insert)
&nbsp;&nbsp;3. [`gtk_combo_box_text_append_text` / `gtk_combo_box_text_prepend_text` / `gtk_combo_box_text_insert_text`](#gtk_combo_box_text_append_text--gtk_combo_box_text_prepend_text--gtk_combo_box_text_insert_text)
&nbsp;&nbsp;4. [`gtk_combo_box_text_remove` / `gtk_combo_box_text_remove_all`](#gtk_combo_box_text_remove--gtk_combo_box_text_remove_all)
&nbsp;&nbsp;5. [`gtk_combo_box_text_get_active_text`](#gtk_combo_box_text_get_active_text)
&nbsp;&nbsp;6. [`gtk_combo_box_set_active` / `gtk_combo_box_get_active`](#gtk_combo_box_set_active--gtk_combo_box_get_active)
&nbsp;&nbsp;7. [`gtk_combo_box_set_active_id` / `gtk_combo_box_get_active_id`](#gtk_combo_box_set_active_id--gtk_combo_box_get_active_id)

V. [Practical recipes](#practical-recipes)
&nbsp;&nbsp;1. [A numeric field with a slider, sharing one Adjustment](#a-numeric-field-with-a-slider-sharing-one-adjustment)
&nbsp;&nbsp;2. [A product-quantity counter with a limited range](#a-product-quantity-counter-with-a-limited-range)
&nbsp;&nbsp;3. [A country dropdown with an id and readable text](#a-country-dropdown-with-an-id-and-readable-text)
&nbsp;&nbsp;4. [A volume slider with no numeric value shown](#a-volume-slider-with-no-numeric-value-shown)
&nbsp;&nbsp;5. [A combo box that also allows typing your own option](#a-combo-box-that-also-allows-typing-your-own-option)

VI. [Summary table](#summary-table)

VII. [Summary: which procedure to choose](#summary-which-procedure-to-choose)

---

## GtkAdjustment

`GtkAdjustment` is not a widget but a data object: the current value, the lower and upper bounds, the scroll step, the "page" size. Used as a shared model for `GtkSpinButton`, `GtkScale`, and (outside the scope of this reference) scrollbars. This wrapper exposes only the basic properties (`value`, `lower`, `upper`) — the step parameters (`step_increment`, `page_increment`, `page_size`), set in the constructor, have no separate getters/setters in this version of the wrapper and can only be configured at creation time via `gtk_adjustment_new`.

### `gtk_adjustment_new`

```nim
proc gtk_adjustment_new*(value: gdouble, lower: gdouble, upper: gdouble, stepIncrement: gdouble, pageIncrement: gdouble, pageSize: gdouble): GtkAdjustment
```

**What it does.** Creates a range-settings object with all parameters at once. `value` is the initial value, `lower`/`upper` are the bounds of the range. `stepIncrement` is how much the value shifts when the `GtkSpinButton`'s arrows or `GtkScale`'s arrow keys are pressed. `pageIncrement` is how much the value shifts when clicking on the slider's track outside the handle itself (analogous to `PageUp`/`PageDown`). `pageSize` mainly makes sense for scrollbars (the fraction of the visible area relative to the total content size) — for `GtkSpinButton`/`GtkScale` it's usually passed as `0.0`.

- `value` — the initial value (must be within `[lower, upper]`).
- `lower`, `upper` — the bounds of the range.
- `stepIncrement` — the step for incremental changes (arrows, keyboard).
- `pageIncrement` — the step for "page-wise" changes.
- `pageSize` — the size of the visible page (usually `0.0` for `SpinButton`/`Scale`).

```nim
let quantityAdjustment = gtk_adjustment_new(1.0, 1.0, 99.0, 1.0, 5.0, 0.0)
echo "Adjustment for product quantity created: range 1-99, step 1"
```

---

### `gtk_adjustment_set_value` / `gtk_adjustment_get_value`

```nim
proc gtk_adjustment_set_value*(adjustment: GtkAdjustment, value: gdouble)
proc gtk_adjustment_get_value*(adjustment: GtkAdjustment): gdouble
```

**What it does.** Set and read the current value directly through the `GtkAdjustment` object, bypassing the widgets attached to it. Since any `GtkSpinButton`/`GtkScale` using the same `GtkAdjustment` is subscribed to its changes, calling `set_value` on the adjustment itself updates **all** the widgets tied to it — this is exactly the mechanism behind their automatic synchronization with each other.

- `adjustment` — the range-settings object.
- `value` — the new value.

```nim
gtk_adjustment_set_value(quantityAdjustment, 5.0)
echo "Current value: ", gtk_adjustment_get_value(quantityAdjustment)
# all widgets using quantityAdjustment immediately reflect the new value
```

---

### `gtk_adjustment_set_lower` / `gtk_adjustment_get_lower` / `gtk_adjustment_set_upper` / `gtk_adjustment_get_upper`

```nim
proc gtk_adjustment_set_lower*(adjustment: GtkAdjustment, lower: gdouble)
proc gtk_adjustment_get_lower*(adjustment: GtkAdjustment): gdouble
proc gtk_adjustment_set_upper*(adjustment: GtkAdjustment, upper: gdouble)
proc gtk_adjustment_get_upper*(adjustment: GtkAdjustment): gdouble
```

**What it does.** Change the bounds of the range after creation — for example, when the allowed maximum quantity of a product depends on stock on hand, computed dynamically rather than being a constant at the time the adjustment was created. If the current value (`value`) ends up outside the new range after a bound changes, GTK automatically pulls it to the nearest allowed bound.

- `adjustment` — the range-settings object.
- `lower`, `upper` — the new bound.

```nim
gtk_adjustment_set_upper(quantityAdjustment, 12.0)  # only 12 units left in stock
echo "New maximum quantity: ", gtk_adjustment_get_upper(quantityAdjustment)
```

---

## GtkSpinButton

`GtkSpinButton` is a numeric input field with up/down arrows for incremental value changes. Internally it's a `GtkEntry` augmented with numeric logic — but managing the text itself (for example, `gtk_editable_set_width_chars` from the text input reference) is available on it right alongside the numeric functions in this section.

### `gtk_spin_button_new` / `gtk_spin_button_new_with_range`

```nim
proc gtk_spin_button_new*(adjustment: GtkAdjustment, climbRate: gdouble, digits: guint): GtkSpinButton
proc gtk_spin_button_new_with_range*(min: gdouble, max: gdouble, step: gdouble): GtkSpinButton
```

**What it does.** Two ways to create a numeric field. `gtk_spin_button_new` takes an already-built `GtkAdjustment` (section I) — used when several widgets need to share the same range/value, or when full control over `pageIncrement`/`pageSize` is needed. `climbRate` is an acceleration coefficient: while an arrow is held down, the step of change gradually increases proportionally to this value (`0.0` disables acceleration — the step always equals the adjustment's `stepIncrement`). `gtk_spin_button_new_with_range` is a shorthand for the most common case: it creates its own `GtkAdjustment` implicitly, right away with bounds and a step, with no acceleration and no explicit control over the number of digits (that's set from the number of decimal places in `step`).

- `adjustment` — the range-settings object (for the full form).
- `climbRate` — the acceleration coefficient while an arrow is held.
- `digits` — the number of decimal places shown.
- `min`, `max`, `step` — the bounds and the step (for the shorthand form).

```nim
let quantitySpin = gtk_spin_button_new_with_range(1.0, 99.0, 1.0)
echo "Quantity field created: from 1 to 99, step 1"

let priceSpin = gtk_spin_button_new(priceAdjustment, 1.0, 2)  # with acceleration, 2 decimal places
```

---

### `gtk_spin_button_set_adjustment` / `gtk_spin_button_get_adjustment`

```nim
proc gtk_spin_button_set_adjustment*(spinButton: GtkSpinButton, adjustment: GtkAdjustment)
proc gtk_spin_button_get_adjustment*(spinButton: GtkSpinButton): GtkAdjustment
```

**What it does.** Replace an already-existing field's `GtkAdjustment` with another one (for example, to attach the field to a new range when the context switches — a document's page counter changes along with opening a different file), or retrieve the current adjustment to link another widget to it (typically a `GtkScale`, see section V, "A numeric field with a slider").

- `spinButton` — the numeric field.
- `adjustment` — the new range-settings object.

```nim
let sharedAdjustment = gtk_spin_button_get_adjustment(quantitySpin)
echo "Adjustment obtained; it can be passed to gtk_scale_new for a linked slider"
```

---

### `gtk_spin_button_set_digits` / `gtk_spin_button_get_digits`

```nim
proc gtk_spin_button_set_digits*(spinButton: GtkSpinButton, digits: guint)
proc gtk_spin_button_get_digits*(spinButton: GtkSpinButton): guint
```

**What it does.** Set the number of decimal places shown in the field — `0` for whole numbers, `2` for money amounts, and so on. This is purely a display setting: the internal `GtkAdjustment` value is always stored as a full-precision `gdouble`; `digits` only affects how many digits are visible and enterable in the field's own text representation.

- `spinButton` — the numeric field.
- `digits` — the number of decimal places.

```nim
gtk_spin_button_set_digits(priceSpin, 2)
echo "Price field shows ", gtk_spin_button_get_digits(priceSpin), " decimal places"
```

---

### `gtk_spin_button_set_value` / `gtk_spin_button_get_value` / `gtk_spin_button_get_value_as_int`

```nim
proc gtk_spin_button_set_value*(spinButton: GtkSpinButton, value: gdouble)
proc gtk_spin_button_get_value*(spinButton: GtkSpinButton): gdouble
proc gtk_spin_button_get_value_as_int*(spinButton: GtkSpinButton): gint
```

**What it does.** Set and read the field's current value. `get_value_as_int` is a convenient shortcut for fields originally intended for whole numbers (`digits = 0`) — it saves you the explicit cast `gint(gtk_spin_button_get_value(...))`; there is no separate setter for an integer value, only `set_value` with a `gdouble`.

- `spinButton` — the numeric field.
- `value` — the new value.

```nim
gtk_spin_button_set_value(quantitySpin, 3.0)
echo "Quantity selected: ", gtk_spin_button_get_value_as_int(quantitySpin)
```

---

### `gtk_spin_button_set_range` / `gtk_spin_button_get_range`

```nim
proc gtk_spin_button_set_range*(spinButton: GtkSpinButton, min: gdouble, max: gdouble)
proc gtk_spin_button_get_range*(spinButton: GtkSpinButton, min: ptr gdouble, max: ptr gdouble)
```

**What it does.** A shorthand for changing the field's range bounds directly, without going through its `GtkAdjustment` via `gtk_adjustment_set_lower`/`set_upper` — under the hood it does exactly the same thing (changes the `lower`/`upper` of the linked adjustment), but in one call and without first needing to obtain the `GtkAdjustment` object itself.

- `spinButton` — the numeric field.
- `min`, `max` — the new bounds (for `get_range` — pointers into which the current bounds will be written).

```nim
gtk_spin_button_set_range(quantitySpin, 1.0, 12.0)  # 12 units left in stock
var currentMin, currentMax: gdouble
gtk_spin_button_get_range(quantitySpin, addr currentMin, addr currentMax)
echo "Quantity range is now: from ", currentMin, " to ", currentMax
```

---

## GtkScale (and GtkRange)

`GtkScale` is a slider for choosing a value within a range by dragging a handle. `GtkRange` is the shared base class for `GtkScale` and scrollbars; in this wrapper only one function from it is exposed directly (`gtk_range_set_value`), but it accepts any of these widgets.

### `gtk_scale_new` / `gtk_scale_new_with_range`

```nim
proc gtk_scale_new*(orientation: GtkOrientation, adjustment: GtkAdjustment): GtkScale
proc gtk_scale_new_with_range*(orientation: GtkOrientation, min: gdouble, max: gdouble, step: gdouble): GtkScale
```

**What it does.** The same choice of full vs. shorthand form as with `gtk_spin_button_new`/`_with_range`: the full form takes a ready-made `GtkAdjustment` (needed to link the slider to another widget through a shared adjustment — see section V, "A numeric field with a slider"), the shorthand form creates the adjustment implicitly from the bounds and step.

- `orientation` — `GTK_ORIENTATION_HORIZONTAL` or `GTK_ORIENTATION_VERTICAL`.
- `adjustment` — the range-settings object (for the full form).
- `min`, `max`, `step` — the bounds and the step (for the shorthand form).

```nim
let volumeScale = gtk_scale_new_with_range(GTK_ORIENTATION_HORIZONTAL, 0.0, 100.0, 1.0)
echo "Horizontal volume slider created: from 0 to 100"
```

---

### `gtk_scale_set_digits` / `gtk_scale_get_digits`

```nim
proc gtk_scale_set_digits*(scale: GtkScale, digits: gint)
proc gtk_scale_get_digits*(scale: GtkScale): gint
```

**What it does.** Set the number of decimal places in the number shown next to the slider — the same logic as `gtk_spin_button_set_digits`, but it only applies when `gtk_scale_set_draw_value` is enabled (next subsection): if the value isn't displayed at all, `digits` has no effect on anything.

- `scale` — the slider.
- `digits` — the number of decimal places.

```nim
gtk_scale_set_digits(volumeScale, 0)  # volume is a whole number, no fractional part
echo "Volume slider shows whole-number values"
```

---

### `gtk_scale_set_draw_value` / `gtk_scale_get_draw_value`

```nim
proc gtk_scale_set_draw_value*(scale: GtkScale, drawValue: gboolean)
proc gtk_scale_get_draw_value*(scale: GtkScale): gboolean
```

**What it does.** Show/hide the current numeric value next to the slider's handle. By default the value is not shown — only the slider itself; enabling it is useful when the exact number matters to the user (for example, a volume percentage), not just the relative position.

- `scale` — the slider.
- `drawValue` — `1.gboolean` to show the value.

```nim
gtk_scale_set_draw_value(volumeScale, 1.gboolean)
echo "Volume's numeric value is now shown next to the slider"
```

---

### `gtk_scale_set_value_pos` / `gtk_scale_get_value_pos`

```nim
proc gtk_scale_set_value_pos*(scale: GtkScale, pos: GtkPositionType)
proc gtk_scale_get_value_pos*(scale: GtkScale): GtkPositionType
```

**What it does.** Set which side of the slider the numeric value is shown on (when `draw_value` is enabled) — `GTK_POS_LEFT`, `_RIGHT`, `_TOP`, `_BOTTOM`.

- `scale` — the slider.
- `pos` — a `GtkPositionType` value.

```nim
gtk_scale_set_value_pos(volumeScale, GTK_POS_RIGHT)
echo "Volume value shown to the right of the slider"
```

---

### `gtk_range_set_value`

```nim
proc gtk_range_set_value*(range: GtkRange, value: cdouble)
```

**What it does.** Sets the current value — the same operation as `gtk_adjustment_set_value` on the linked adjustment, but called directly on the widget itself (`GtkScale` is passed as a `GtkRange` with no explicit cast needed, since in this wrapper both are `pointer`). There is no separate `gtk_range_get_value` getter in this version of the wrapper — to read the current value, use `gtk_adjustment_get_value` on the object obtained via `gtk_spin_button_get_adjustment`, or keep the adjustment in a variable when creating the slider through the full form of `gtk_scale_new`.

- `range` — the slider (`GtkScale`) or another descendant of `GtkRange`.
- `value` — the new value.

```nim
gtk_range_set_value(volumeScale, 75.0)
echo "Volume set programmatically to 75"
```

---

## GtkComboBoxText (and GtkComboBox)

`GtkComboBoxText` is a dropdown list for choosing one option out of several, where each option is a plain text string (for more complex cases — with icons, an arbitrary data model — the more general `GtkComboBox` with `GtkTreeModel` is used, which is outside the scope of this reference). `GtkComboBoxText` is a subtype of `GtkComboBox`, so some of the functions for managing the current selection are declared at the `GtkComboBox` level and work identically for both.

### `gtk_combo_box_text_new` / `gtk_combo_box_text_new_with_entry`

```nim
proc gtk_combo_box_text_new*(): GtkComboBoxText
proc gtk_combo_box_text_new_with_entry*(): GtkComboBoxText
```

**What it does.** Create an empty dropdown list. `gtk_combo_box_text_new_with_entry` additionally lets the user type their own text, not limited to the proposed options (a combination of a dropdown list with a text field — working with manually typed text goes through the `GtkEditable` interface, the text input reference, applied to the combo box itself).

- No parameters.

```nim
let countryCombo = gtk_combo_box_text_new()
let tagsCombo = gtk_combo_box_text_new_with_entry()
echo "An ordinary dropdown list and one that also allows typing your own option were created"
```

---

### `gtk_combo_box_text_append` / `gtk_combo_box_text_prepend` / `gtk_combo_box_text_insert`

```nim
proc gtk_combo_box_text_append*(comboBox: GtkComboBoxText, id: cstring, text: cstring)
proc gtk_combo_box_text_prepend*(comboBox: GtkComboBoxText, id: cstring, text: cstring)
proc gtk_combo_box_text_insert*(comboBox: GtkComboBoxText, position: gint, id: cstring, text: cstring)
```

**What it does.** Add an option to the end, to the start, or at an arbitrary position of the list — with two strings at once: `text` is what the user sees, `id` is a stable technical identifier for the option (for example, a country code `"RU"` with the visible text `"Russia"`), independent of the order of items in the list or of the localization of the visible text. It's the `id`, rather than a numeric position index, that's recommended for storing the user's choice between application runs (the index will "drift" if the list of options later changes; the `id` won't). Passing `nil` instead of an `id` is allowed if a stable identifier isn't needed — in that case the option can only be referred to by index via `gtk_combo_box_set/get_active`.

- `comboBox` — the dropdown list.
- `id` — the option's stable identifier, or `nil`.
- `text` — the text visible to the user.
- `position` (for `insert`) — the insertion index.

```nim
gtk_combo_box_text_append(countryCombo, "RU", "Russia")
gtk_combo_box_text_append(countryCombo, "DE", "Germany")
gtk_combo_box_text_append(countryCombo, "FR", "France")
echo "Three countries added to the dropdown list"
```

---

### `gtk_combo_box_text_append_text` / `gtk_combo_box_text_prepend_text` / `gtk_combo_box_text_insert_text`

```nim
proc gtk_combo_box_text_append_text*(comboBox: GtkComboBoxText, text: cstring)
proc gtk_combo_box_text_prepend_text*(comboBox: GtkComboBoxText, text: cstring)
proc gtk_combo_box_text_insert_text*(comboBox: GtkComboBoxText, position: gint, text: cstring)
```

**What it does.** Simplified versions of the previous three functions — with no `id` at all, just the visible text (internally equivalent to calling with `id = nil`). Appropriate when the list of options is already uniquely identified by its text or position and a separate technical identifier isn't needed.

- `comboBox` — the dropdown list.
- `text` — the text visible to the user.
- `position` (for `insert_text`) — the insertion index.

```nim
let sortOrderCombo = gtk_combo_box_text_new()
gtk_combo_box_text_append_text(sortOrderCombo, "By name")
gtk_combo_box_text_append_text(sortOrderCombo, "By date")
gtk_combo_box_text_append_text(sortOrderCombo, "By size")
echo "Sort-order options added with no separate technical identifiers"
```

---

### `gtk_combo_box_text_remove` / `gtk_combo_box_text_remove_all`

```nim
proc gtk_combo_box_text_remove*(comboBox: GtkComboBoxText, position: gint)
proc gtk_combo_box_text_remove_all*(comboBox: GtkComboBoxText)
```

**What it does.** Remove a single option by position index, or clear the list entirely — for example, before refilling the list with new data (loaded asynchronously after the empty combo box was first created).

- `comboBox` — the dropdown list.
- `position` (for `remove`) — the index of the option to remove.

```nim
gtk_combo_box_text_remove_all(countryCombo)
echo "Country list cleared before refilling"
```

---

### `gtk_combo_box_text_get_active_text`

```nim
proc gtk_combo_box_text_get_active_text*(comboBox: GtkComboBoxText): cstring
```

**What it does.** Returns the visible text of the currently selected option. If nothing is selected (relevant right after the list is created, before the user makes a first choice or a programmatic selection is made), returns `nil`. For a combo box with a text entry (`gtk_combo_box_text_new_with_entry`), when nothing from the ready-made list is selected, it returns exactly the text the user typed by hand — so this function covers both cases uniformly.

- `comboBox` — the dropdown list.

```nim
let selectedCountryText = gtk_combo_box_text_get_active_text(countryCombo)
if not isNil(selectedCountryText):
  echo "Country selected: ", $selectedCountryText
else:
  echo "No country selected yet"
```

---

### `gtk_combo_box_set_active` / `gtk_combo_box_get_active`

```nim
proc gtk_combo_box_set_active*(comboBox: GtkComboBox, index: gint)
proc gtk_combo_box_get_active*(comboBox: GtkComboBox): gint
```

**What it does.** Set and read the current selection by the numeric position index in the list (starting at `0`). `-1` means "nothing selected". These functions are declared at the level of the base `GtkComboBox`, but apply directly to `GtkComboBoxText` as well.

- `comboBox` — the dropdown list (`GtkComboBoxText` is passed directly).
- `index` — the option's index, or `-1` to clear the selection.

```nim
gtk_combo_box_set_active(countryCombo, 0)  # select the first option by default
echo "Selected option index: ", gtk_combo_box_get_active(countryCombo)
```

---

### `gtk_combo_box_set_active_id` / `gtk_combo_box_get_active_id`

```nim
proc gtk_combo_box_set_active_id*(comboBox: GtkComboBox, activeId: cstring): gboolean
proc gtk_combo_box_get_active_id*(comboBox: GtkComboBox): cstring
```

**What it does.** The same as `set_active`/`get_active`, but by the stable `id` set when the option was added via `gtk_combo_box_text_append`/`prepend`/`insert` (not the shorthand `_text` variants without an `id` — for those, `set_active_id` won't work, since no `id` was ever set). `set_active_id` returns a `gboolean` reporting whether an option with that `id` was found and selected (`0.gboolean` if there's no option with the given `id` in the list — for example, because the list hasn't been filled yet). This is the preferred way to restore a previously saved selection (for example, from the application's settings) — resistant to changes in the order or composition of the rest of the list's options, unlike an index.

- `comboBox` — the dropdown list.
- `activeId` — the option's stable identifier.

```nim
let savedCountryId = "DE"  # a previously saved value, e.g. from a settings file
if gtk_combo_box_set_active_id(countryCombo, savedCountryId.cstring) == 0.gboolean:
  echo "Saved country not found in the current list — leaving the selection empty"
else:
  echo "Restored saved selection: ", $gtk_combo_box_get_active_id(countryCombo)
```

---

## Practical recipes

### A numeric field with a slider, sharing one Adjustment

The classic "exact-number field + slider next to it" combination — both widgets automatically stay in sync, since they use the same `GtkAdjustment`.

```nim
proc buildVolumeControl(): GtkBox =
  result = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 8)

  let volumeAdjustment = gtk_adjustment_new(50.0, 0.0, 100.0, 1.0, 10.0, 0.0)

  let volumeScale = gtk_scale_new(GTK_ORIENTATION_HORIZONTAL, volumeAdjustment)
  gtk_widget_set_hexpand(volumeScale, 1.gboolean)

  let volumeSpin = gtk_spin_button_new(volumeAdjustment, 1.0, 0)

  gtk_box_append(result, volumeScale)
  gtk_box_append(result, volumeSpin)
  echo "Volume slider and numeric field linked by one Adjustment — changing one immediately reflects in the other"

let volumeControl = buildVolumeControl()
```

---

### A product-quantity counter with a limited range

A simple `GtkSpinButton` for choosing a quantity of product units, using the shorthand constructor and with no decimal places.

```nim
proc buildQuantitySpin(maxAvailable: int): GtkSpinButton =
  result = gtk_spin_button_new_with_range(1.0, maxAvailable.float, 1.0)
  gtk_spin_button_set_digits(result, 0)
  gtk_spin_button_set_value(result, 1.0)
  echo "Quantity counter created: from 1 to ", maxAvailable

let quantitySpin = buildQuantitySpin(12)
```

---

### A country dropdown with an id and readable text

A complete build of `GtkComboBoxText` with stable identifiers, a selection-change handler, and restoring a saved value.

```nim
proc onCountryChanged(comboBox: GtkComboBoxText, userData: gpointer) {.cdecl.} =
  let id = gtk_combo_box_get_active_id(comboBox)
  if not isNil(id):
    echo "Country selected with code: ", $id

proc buildCountryCombo(savedCountryId: string): GtkComboBoxText =
  result = gtk_combo_box_text_new()
  gtk_combo_box_text_append(result, "RU", "Russia")
  gtk_combo_box_text_append(result, "DE", "Germany")
  gtk_combo_box_text_append(result, "FR", "France")
  gtk_combo_box_text_append(result, "JP", "Japan")

  if savedCountryId.len == 0 or gtk_combo_box_set_active_id(result, savedCountryId.cstring) == 0.gboolean:
    gtk_combo_box_set_active(result, 0)  # fallback — the first country in the list

  discard g_signal_connect(result, "changed", onCountryChanged, nil)

let countryCombo = buildCountryCombo("DE")
```

---

### A volume slider with no numeric value shown

A compact vertical slider for a quick-settings panel — no number displayed, just the visual position.

```nim
proc buildCompactVolumeSlider(): GtkScale =
  result = gtk_scale_new_with_range(GTK_ORIENTATION_VERTICAL, 0.0, 100.0, 5.0)
  gtk_scale_set_draw_value(result, 0.gboolean)  # slider position only, no number
  gtk_widget_set_size_request(result, -1, 120)
  gtk_range_set_value(result, 70.0)
  echo "Compact vertical volume slider with no numbers created"

let quickVolumeSlider = buildCompactVolumeSlider()
```

---

### A combo box that also allows typing your own option

A `GtkComboBoxText` with a text entry — the user can pick an existing tag or type a new one not in the list.

```nim
proc buildTagPicker(existingTags: openArray[string]): GtkComboBoxText =
  result = gtk_combo_box_text_new_with_entry()
  for tag in existingTags:
    gtk_combo_box_text_append_text(result, tag.cstring)
  echo "List of existing tags with the option to type your own created"

proc getSelectedOrTypedTag(comboBox: GtkComboBoxText): string =
  let activeText = gtk_combo_box_text_get_active_text(comboBox)
  result = if isNil(activeText): "" else: $activeText

let tagPicker = buildTagPicker(["urgent", "in progress", "done"])
```

---

## Summary table

| Procedure(s) | Category | What it does, briefly |
|---|---|---|
| `gtk_adjustment_new` | Adjustment | Create a range-settings object with all parameters |
| `gtk_adjustment_set/get_value` | Adjustment | The current value (updates all linked widgets) |
| `gtk_adjustment_set/get_lower`, `set/get_upper` | Adjustment | The bounds of the range |
| `gtk_spin_button_new`, `_with_range` | SpinButton | Create a numeric field — with a ready-made Adjustment, or shorthand |
| `gtk_spin_button_set/get_adjustment` | SpinButton | The linked range-settings object |
| `gtk_spin_button_set/get_digits` | SpinButton | Number of decimal places shown |
| `gtk_spin_button_set/get_value`, `get_value_as_int` | SpinButton | The current numeric value |
| `gtk_spin_button_set/get_range` | SpinButton | The bounds of the range (shorthand, no Adjustment) |
| `gtk_scale_new`, `_with_range` | Scale | Create a slider — with a ready-made Adjustment, or shorthand |
| `gtk_scale_set/get_digits` | Scale | Number of decimal places in the value label |
| `gtk_scale_set/get_draw_value` | Scale | Whether to show the numeric value next to the handle |
| `gtk_scale_set/get_value_pos` | Scale | Which side to show the value on |
| `gtk_range_set_value` | Range | Set the value directly on the widget (no Adjustment) |
| `gtk_combo_box_text_new`, `_with_entry` | ComboBoxText | Create a dropdown list — ordinary, or with a text entry |
| `gtk_combo_box_text_append/prepend/insert` | ComboBoxText | Add an option with an id and text |
| `gtk_combo_box_text_append/prepend/insert_text` | ComboBoxText | Add an option with text only, no id |
| `gtk_combo_box_text_remove`, `remove_all` | ComboBoxText | Remove one option / clear the list |
| `gtk_combo_box_text_get_active_text` | ComboBoxText | The visible text of the current selection (or manually typed text) |
| `gtk_combo_box_set/get_active` | ComboBox | The current selection by numeric index |
| `gtk_combo_box_set/get_active_id` | ComboBox | The current selection by stable id |

---

## Summary: which procedure to choose

- **A slider and a numeric field must show the same value in sync** → create a single `GtkAdjustment` via `gtk_adjustment_new` and pass it into both `gtk_scale_new` and `gtk_spin_button_new` (the full constructor forms), rather than trying to manually synchronize two independent `_with_range` widgets through signals.
- **You only need one of the widgets, with no syncing to another** → the shorthand constructor (`gtk_spin_button_new_with_range`/`gtk_scale_new_with_range`) — the Adjustment is created implicitly, no need to create and store it separately.
- **The exact number matters** (a quantity, a price, an age) → `GtkSpinButton` — typed from the keyboard and adjusted with the arrows. **A quick visual sense of position within the range matters** (volume, brightness) → `GtkScale`, especially with `draw_value` turned off for a very compact look.
- **Persisting the user's choice across application runs / the selection could lose its position in the list** (the list of options may change or grow) → `gtk_combo_box_set_active_id`/`get_active_id` by a stable `id`, rather than `gtk_combo_box_set_active`/`get_active` by numeric index — the index "drifts" when the list's composition changes, the `id` doesn't.
- **The list of options has no natural technical identifier besides its own text** → the short `_text` variants (`append_text`, etc.), without artificially inventing an `id`.
- **A list of ready-made options, but the user sometimes needs to type something of their own** → `gtk_combo_box_text_new_with_entry`, rather than an ordinary `GtkComboBoxText` plus a separate field next to it — this way the same widget serves both cases, and `gtk_combo_box_text_get_active_text` returns the result uniformly regardless of whether a ready-made option was chosen or a new one was typed.
- **You need to read a `GtkScale`'s current value programmatically** → through the `GtkAdjustment` obtained at creation time (or `gtk_spin_button_get_adjustment` on a linked `GtkSpinButton`) — in this wrapper, `GtkRange`/`GtkScale` only has `gtk_range_set_value` for writing, with no separate value getter at the level of the widget itself.
