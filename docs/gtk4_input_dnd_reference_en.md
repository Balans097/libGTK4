# GTK4 (input: GtkEventController / gestures / Drag-and-Drop) — module reference

> **Import:** `import libGTK4`
> **Scope:** GTK4's modern input-handling system — event controllers and gestures (replacing legacy GTK3 signals such as `"button-press-event"`), plus drag-and-drop between widgets. Fifteenth part of the wrapper reference series; assumes familiarity with `gtk4_core_reference_en.md` (`GtkWidget`, `g_signal_connect`).

In GTK4, input handling is built around **controllers** (`GtkEventController` and its subtypes) — objects attached to a widget via `gtk_widget_add_controller`, each subscribing to a particular class of events (clicks, mouse dragging, key presses, cursor motion, scrolling). Gestures (`GtkGesture` and its subtypes — `GtkGestureClick`, `GtkGestureDrag`, etc.) are specialized controllers that recognize composite, multi-step interactions (not just "button pressed," but "button pressed, then released within a short time and small offset — that's a click").

**Important limitation for this section's parameters:** in this wrapper, `GtkPropagationPhase`, `GtkPropagationLimit`, drag-and-drop actions (`GdkDragAction`), and scroll flags are not defined as named enum types — the corresponding parameters (`phase`, `limit`, `actions`, `flags`) are passed as plain `gint`/`cint`, and the exact numeric values need to be checked against the actual GTK4 headers (e.g. `GTK_PHASE_BUBBLE = 1` — the default event propagation phase, `GDK_ACTION_COPY = 1` — the copy action during a drag). In the examples below such values are given wherever they matter for the example to work, with an explanatory comment.

---

## Table of Contents

I. [GtkEventController (common base interface)](#gtkeventcontroller-common-base-interface)
&nbsp;&nbsp;1. [`gtk_widget_add_controller` / `gtk_widget_remove_controller`](#gtk_widget_add_controller--gtk_widget_remove_controller)
&nbsp;&nbsp;2. [`gtk_event_controller_get_widget`](#gtk_event_controller_get_widget)
&nbsp;&nbsp;3. [`gtk_event_controller_set/get_propagation_phase`](#gtk_event_controller_setget_propagation_phase)
&nbsp;&nbsp;4. [`gtk_event_controller_set/get_propagation_limit`](#gtk_event_controller_setget_propagation_limit)
&nbsp;&nbsp;5. [`gtk_event_controller_set/get_name`](#gtk_event_controller_setget_name)
&nbsp;&nbsp;6. [`gtk_event_controller_reset`](#gtk_event_controller_reset)

II. [GtkGesture (common base interface for gestures)](#gtkgesture-common-base-interface-for-gestures)
&nbsp;&nbsp;1. [`gtk_gesture_is_active` / `gtk_gesture_is_recognized`](#gtk_gesture_is_active--gtk_gesture_is_recognized)
&nbsp;&nbsp;2. [`gtk_gesture_get_point` / `gtk_gesture_get_bounding_box`, `_center`](#gtk_gesture_get_point--gtk_gesture_get_bounding_box-_center)
&nbsp;&nbsp;3. [`gtk_gesture_set_state` / `gtk_gesture_get_sequence_state`, `set_sequence_state`](#gtk_gesture_set_state--gtk_gesture_get_sequence_state-set_sequence_state)
&nbsp;&nbsp;4. [`gtk_gesture_group` / `gtk_gesture_ungroup` / `gtk_gesture_is_grouped_with`](#gtk_gesture_group--gtk_gesture_ungroup--gtk_gesture_is_grouped_with)

III. [GtkGestureSingle (common interface for single-pointer gestures)](#gtkgesturesingle-common-interface-for-single-pointer-gestures)
&nbsp;&nbsp;1. [`gtk_gesture_single_set/get_button`](#gtk_gesture_single_setget_button)
&nbsp;&nbsp;2. [`gtk_gesture_single_set/get_touch_only`](#gtk_gesture_single_setget_touch_only)
&nbsp;&nbsp;3. [`gtk_gesture_single_set/get_exclusive`](#gtk_gesture_single_setget_exclusive)

IV. [Specific gestures](#specific-gestures)
&nbsp;&nbsp;1. [`gtk_gesture_click_new`](#gtk_gesture_click_new)
&nbsp;&nbsp;2. [`gtk_gesture_drag_new`, `get_start_point`, `get_offset`](#gtk_gesture_drag_new-get_start_point-get_offset)
&nbsp;&nbsp;3. [`gtk_gesture_long_press_new`, `set/get_delay_factor`](#gtk_gesture_long_press_new-setget_delay_factor)
&nbsp;&nbsp;4. [`gtk_gesture_swipe_new`, `get_velocity`](#gtk_gesture_swipe_new-get_velocity)
&nbsp;&nbsp;5. [`gtk_gesture_rotate_new`, `get_angle_delta`](#gtk_gesture_rotate_new-get_angle_delta)
&nbsp;&nbsp;6. [`gtk_gesture_zoom_new`, `get_scale_delta`](#gtk_gesture_zoom_new-get_scale_delta)

V. [Specific controllers (non-gesture)](#specific-controllers-non-gesture)
&nbsp;&nbsp;1. [`gtk_event_controller_key_new` and related](#gtk_event_controller_key_new-and-related)
&nbsp;&nbsp;2. [`gtk_event_controller_focus_new`, `contains_focus`, `is_focus`](#gtk_event_controller_focus_new-contains_focus-is_focus)
&nbsp;&nbsp;3. [`gtk_event_controller_motion_new`, `contains_pointer`, `is_pointer`](#gtk_event_controller_motion_new-contains_pointer-is_pointer)
&nbsp;&nbsp;4. [`gtk_event_controller_scroll_new` and related](#gtk_event_controller_scroll_new-and-related)

VI. [Drag-and-Drop: GtkDragSource](#drag-and-drop-gtkdragsource)
&nbsp;&nbsp;1. [`gtk_drag_source_new`](#gtk_drag_source_new)
&nbsp;&nbsp;2. [`gtk_drag_source_set/get_content`](#gtk_drag_source_setget_content)
&nbsp;&nbsp;3. [`gtk_drag_source_set/get_actions`](#gtk_drag_source_setget_actions)
&nbsp;&nbsp;4. [`gtk_drag_source_set_icon`](#gtk_drag_source_set_icon)
&nbsp;&nbsp;5. [`gtk_drag_source_drag_cancel` / `gtk_drag_source_get_drag`](#gtk_drag_source_drag_cancel--gtk_drag_source_get_drag)

VII. [Drag-and-Drop: GtkDropTarget](#drag-and-drop-gtkdroptarget)
&nbsp;&nbsp;1. [`gtk_drop_target_new`](#gtk_drop_target_new)
&nbsp;&nbsp;2. [`gtk_drop_target_set/get_gtypes`](#gtk_drop_target_setget_gtypes)
&nbsp;&nbsp;3. [`gtk_drop_target_set/get_actions`](#gtk_drop_target_setget_actions)
&nbsp;&nbsp;4. [`gtk_drop_target_set/get_preload`](#gtk_drop_target_setget_preload)
&nbsp;&nbsp;5. [`gtk_drop_target_get_value` / `get_drop` / `get_current_drop` / `get_formats` / `reject`](#gtk_drop_target_get_value--get_drop--get_current_drop--get_formats--reject)

VIII. [Practical recipes](#practical-recipes)
&nbsp;&nbsp;1. [Right-click for a context menu](#right-click-for-a-context-menu)
&nbsp;&nbsp;2. [Dragging a widget with the mouse inside an area](#dragging-a-widget-with-the-mouse-inside-an-area)
&nbsp;&nbsp;3. [Long press as a mobile context-menu gesture](#long-press-as-a-mobile-context-menu-gesture)
&nbsp;&nbsp;4. [Dragging text from one field to another](#dragging-text-from-one-field-to-another)
&nbsp;&nbsp;5. [Reacting to hover on a card](#reacting-to-hover-on-a-card)

IX. [Quick reference table](#quick-reference-table)

X. [Summary: which procedure to choose](#summary-which-procedure-to-choose)

---

## GtkEventController (common base interface)

All the specific controllers and gestures in this reference are subtypes of `GtkEventController`. The functions in this section apply directly to any of them (in this wrapper, a parameter of type `GtkEventController` accepts `pointer`, so a specific gesture/controller can be passed without an explicit cast).

### `gtk_widget_add_controller` / `gtk_widget_remove_controller`

```nim
proc gtk_widget_add_controller*(widget: GtkWidget, controller: GtkEventController)
proc gtk_widget_remove_controller*(widget: GtkWidget, controller: GtkEventController)
```

**What it does.** Attaches/detaches a controller to/from a widget — without this, a created gesture/controller has no effect at all; it must be explicitly added to the widget whose events it should handle. A single widget can have several different controllers at once (e.g. a separate `GtkGestureClick` for clicks and a `GtkEventControllerMotion` for hover, side by side).

- `widget` — the widget the controller is added to or removed from.
- `controller` — a gesture or controller (any subtype of `GtkEventController`).

```nim
let clickGesture = gtk_gesture_click_new()
gtk_widget_add_controller(someWidget, clickGesture)
echo "Click gesture attached to the widget"
```

---

### `gtk_event_controller_get_widget`

```nim
proc gtk_event_controller_get_widget*(controller: GtkEventController): GtkWidget
```

**What it does.** Returns the widget the controller is attached to — the inverse of `add_controller`, useful inside a controller's signal handler when the widget itself wasn't explicitly passed through `userData`.

- `controller` — the controller/gesture.

```nim
let owningWidget = gtk_event_controller_get_widget(clickGesture)
echo "Retrieved the widget the gesture is attached to"
```

---

### `gtk_event_controller_set/get_propagation_phase`

```nim
proc gtk_event_controller_set_propagation_phase*(controller: GtkEventController, phase: gint)
proc gtk_event_controller_get_propagation_phase*(controller: GtkEventController): gint
```

**What it does.** Sets/gets the phase of the widget-tree event propagation at which the controller fires — GTK4 propagates events in three phases: first "top-down" from the window to the target widget (`GTK_PHASE_CAPTURE = 0`), then directly on the target widget itself, then "bottom-up" back to the window (`GTK_PHASE_BUBBLE = 1` — the default for most controllers). `GTK_PHASE_NONE = 2` disables automatic firing entirely — the controller only reacts to events explicitly forwarded to it manually (e.g. via `gtk_event_controller_key_forward`, section V). The capture phase is needed when a parent container must intercept an event before it reaches a child widget — for example, to implement custom keyboard shortcuts that must fire even when focus is in a text field.

- `controller` — the controller/gesture.
- `phase` — the numeric phase value (`0` = capture, `1` = bubble, `2` = none — there are no named constants in this wrapper).

```nim
gtk_event_controller_set_propagation_phase(clickGesture, 1)  # 1 = GTK_PHASE_BUBBLE, the default
echo "The gesture will react during the normal event bubble phase"
```

---

### `gtk_event_controller_set/get_propagation_limit`

```nim
proc gtk_event_controller_set_propagation_limit*(controller: GtkEventController, limit: gint)
proc gtk_event_controller_get_propagation_limit*(controller: GtkEventController): gint
```

**What it does.** Limits how far a firing event may propagate beyond the widget the controller is attached to — `GTK_LIMIT_NONE = 0` (no limit, the default) or `GTK_LIMIT_SAME_NATIVE = 1` (the event does not cross the boundary of the "native" window — relevant mainly for embedded popovers/popups with their own system-level surface). A specialized setting; for most application code the default value doesn't need changing.

- `controller` — the controller/gesture.
- `limit` — the numeric limit value (`0`/`1` — there are no named constants in this wrapper).

```nim
echo "Current propagation limit: ", gtk_event_controller_get_propagation_limit(clickGesture)
```

---

### `gtk_event_controller_set/get_name`

```nim
proc gtk_event_controller_set_name*(controller: GtkEventController, name: cstring)
proc gtk_event_controller_get_name*(controller: GtkEventController): cstring
```

**What it does.** Sets/reads an arbitrary string name for the controller — purely for debugging/diagnostic convenience (e.g. telling several similar controllers attached to the same widget apart in logs); it has no effect on behavior.

- `controller` — the controller/gesture.
- `name` — an arbitrary name.

```nim
gtk_event_controller_set_name(clickGesture, "primary-click-gesture")
echo "The controller was given a debug name: ", $gtk_event_controller_get_name(clickGesture)
```

---

### `gtk_event_controller_reset`

```nim
proc gtk_event_controller_reset*(controller: GtkEventController)
```

**What it does.** Forcibly resets the controller's internal state back to its initial state — for example, for a drag gesture this will cancel the current unfinished drag, as if the user had released the mouse button. Needed in rare cases of programmatic intervention in an ongoing interaction (e.g. if a widget is programmatically hidden in the middle of a drag and the gesture needs to be explicitly "stopped" rather than left hanging).

- `controller` — the controller/gesture.

```nim
gtk_event_controller_reset(dragGesture)
echo "The drag gesture's state has been reset"
```

---

## GtkGesture (common base interface for gestures)

The functions in this section apply to any specific gesture through its common `GtkGesture` interface.

### `gtk_gesture_is_active` / `gtk_gesture_is_recognized`

```nim
proc gtk_gesture_is_active*(gesture: GtkGesture): gboolean
proc gtk_gesture_is_recognized*(gesture: GtkGesture): gboolean
```

**What it does.** `is_active` reports whether the gesture is currently tracking at least one active touch/press sequence, regardless of whether the gesture itself has been recognized yet. `is_recognized` reports whether the gesture as such has been recognized; a gesture can be active but not yet recognized.

- `gesture` — the gesture.

```nim
if gtk_gesture_is_recognized(longPressGesture) != 0.gboolean:
  echo "Long press recognized"
```

---

### `gtk_gesture_get_point` / `gtk_gesture_get_bounding_box`, `_center`

```nim
proc gtk_gesture_get_point*(gesture: GtkGesture, sequence: pointer, x: ptr gdouble, y: ptr gdouble): gboolean
proc gtk_gesture_get_bounding_box*(gesture: GtkGesture, rect: pointer): gboolean
proc gtk_gesture_get_bounding_box_center*(gesture: GtkGesture, x: ptr gdouble, y: ptr gdouble): gboolean
```

**What it does.** `get_point` returns the current coordinate of a specific touch sequence (`sequence` — an identifier for multi-touch gestures; `nil` for the single active sequence). `get_bounding_box`/`_center` return a rectangle (`GdkRectangle`, cast to `pointer`) covering all of the gesture's simultaneously active points.

- `gesture` — the gesture.
- `sequence` — the touch sequence identifier, or `nil`.
- `x`, `y` — pointers for the coordinates.
- `rect` — a pointer to a `GdkRectangle` struct.

```nim
var x, y: gdouble
if gtk_gesture_get_point(clickGesture, nil, addr x, addr y) != 0.gboolean:
  echo "Click point: (", x, ", ", y, ")"
```

---

### `gtk_gesture_set_state` / `gtk_gesture_get_sequence_state`, `set_sequence_state`

```nim
proc gtk_gesture_set_state*(gesture: GtkGesture, state: gint): gboolean
proc gtk_gesture_get_sequence_state*(gesture: GtkGesture, sequence: pointer): gint
proc gtk_gesture_set_sequence_state*(gesture: GtkGesture, sequence: pointer, state: gint): gboolean
```

**What it does.** Controls whether the gesture claims exclusive ownership of a touch sequence (`GTK_EVENT_SEQUENCE_CLAIMED = 1`) — relevant when several gestures on different widgets could potentially claim the same interaction: the gesture with `CLAIMED` "wins" over the others, which transition to `GTK_EVENT_SEQUENCE_DENIED = 2`. `GTK_EVENT_SEQUENCE_NONE = 0` is the default state. `set_state` applies the state to all of the gesture's sequences; `set_sequence_state` applies it to one specific sequence.

- `gesture` — the gesture.
- `state` — the numeric state value (there are no named constants in this wrapper).
- `sequence` — the identifier of a specific sequence.

```nim
discard gtk_gesture_set_state(dragGesture, 1)  # 1 = GTK_EVENT_SEQUENCE_CLAIMED
echo "The drag gesture claimed exclusive ownership of the current interaction"
```

---

### `gtk_gesture_group` / `gtk_gesture_ungroup` / `gtk_gesture_is_grouped_with`

```nim
proc gtk_gesture_group*(groupGesture: GtkGesture, gesture: GtkGesture)
proc gtk_gesture_ungroup*(gesture: GtkGesture)
proc gtk_gesture_is_grouped_with*(gesture: GtkGesture, other: GtkGesture): gboolean
```

**What it does.** Combines several gestures into a group — grouped gestures process the same touch sequences together, and none of them blocks the others automatically.

- `groupGesture`, `gesture` — the gestures to combine.
- `other` — the gesture to check the grouping against.

```nim
gtk_gesture_group(rotateGesture, zoomGesture)
echo "The rotate and zoom gestures are now grouped and fire together"
```

---

## GtkGestureSingle (common interface for single-pointer gestures)

`GtkGestureSingle` is the base for gestures that handle exactly one interaction point at a time (`GtkGestureClick`, `GtkGestureDrag`, `GtkGestureLongPress`).

### `gtk_gesture_single_set/get_button`

```nim
proc gtk_gesture_single_set_button*(gesture: GtkGestureSingle, button: guint)
proc gtk_gesture_single_get_button*(gesture: GtkGestureSingle): guint
```

**What it does.** Sets which mouse button the gesture reacts to — `0` means "any button" (the default), `1` — left, `2` — middle, `3` — right.

- `gesture` — the gesture.
- `button` — the button number, `0` for any.

```nim
gtk_gesture_single_set_button(contextMenuGesture, 3)
echo "The gesture is now set to the right mouse button for the context menu"
```

---

### `gtk_gesture_single_set/get_touch_only`

```nim
proc gtk_gesture_single_set_touch_only*(gesture: GtkGestureSingle, touchOnly: gboolean)
proc gtk_gesture_single_get_touch_only*(gesture: GtkGestureSingle): gboolean
```

**What it does.** Restricts the gesture to reacting only to touchscreen input, ignoring the mouse/trackpad.

- `gesture` — the gesture.
- `touchOnly` — `1.gboolean` to react only to touch.

```nim
gtk_gesture_single_set_touch_only(swipeGesture, 1.gboolean)
echo "The swipe gesture now reacts only to the touchscreen, not the mouse"
```

---

### `gtk_gesture_single_set/get_exclusive`

```nim
proc gtk_gesture_single_set_exclusive*(gesture: GtkGestureSingle, exclusive: gboolean)
proc gtk_gesture_single_get_exclusive*(gesture: GtkGestureSingle): gboolean
```

**What it does.** Enables a mode in which the gesture is ignored entirely if another touch point was already active at the moment it began.

- `gesture` — the gesture.
- `exclusive` — `1.gboolean` for exclusive single-point mode.

```nim
gtk_gesture_single_set_exclusive(clickGesture, 1.gboolean)
echo "The click gesture is now ignored entirely if a second touch point was already active"
```

---

## Specific gestures

### `gtk_gesture_click_new`

```nim
proc gtk_gesture_click_new*(): GtkGestureClick
```

**What it does.** Creates a click-recognition gesture — it emits `"pressed"` on press and `"released"` on release, both with coordinates and the number of consecutive clicks. Which button it reacts to is controlled via `gtk_gesture_single_set_button` from section III.

- No parameters.

```nim
let clickGesture = gtk_gesture_click_new()

proc onPressed(gesture: GtkGestureClick, nPress: gint, x: gdouble, y: gdouble, userData: gpointer) {.cdecl.} =
  echo "Click #", nPress, " at coordinates (", x, ", ", y, ")"

discard g_signal_connect(clickGesture, "pressed", onPressed, nil)
gtk_widget_add_controller(someWidget, clickGesture)
```

---

### `gtk_gesture_drag_new`, `get_start_point`, `get_offset`

```nim
proc gtk_gesture_drag_new*(): GtkGestureDrag
proc gtk_gesture_drag_get_start_point*(gesture: GtkGestureDrag, x: ptr gdouble, y: ptr gdouble): gboolean
proc gtk_gesture_drag_get_offset*(gesture: GtkGestureDrag, x: ptr gdouble, y: ptr gdouble): gboolean
```

**What it does.** Recognizes mouse dragging — emits `"drag-begin"`, `"drag-update"`, `"drag-end"`. `get_start_point` returns the coordinate where the drag started. `get_offset` returns the offset from the starting point at the current moment.

- `gesture` — the drag gesture.
- `x`, `y` — pointers for the coordinates/offset.

```nim
proc onDragUpdate(gesture: GtkGestureDrag, offsetX: gdouble, offsetY: gdouble, userData: gpointer) {.cdecl.} =
  echo "Offset from the start of the drag: (", offsetX, ", ", offsetY, ")"

let dragGesture = gtk_gesture_drag_new()
discard g_signal_connect(dragGesture, "drag-update", onDragUpdate, nil)
```

---

### `gtk_gesture_long_press_new`, `set/get_delay_factor`

```nim
proc gtk_gesture_long_press_new*(): GtkGestureLongPress
proc gtk_gesture_long_press_set_delay_factor*(gesture: GtkGestureLongPress, delayFactor: gdouble)
proc gtk_gesture_long_press_get_delay_factor*(gesture: GtkGestureLongPress): gdouble
```

**What it does.** Recognizes a long press without movement — emits `"pressed"` once the delay threshold has elapsed. `delay_factor` is a multiplier on the system's default timing (`1.0` — standard, `2.0` — twice as long).

- `gesture` — the long-press gesture.
- `delayFactor` — the multiplier applied to the default wait time.

```nim
let longPressGesture = gtk_gesture_long_press_new()
gtk_gesture_long_press_set_delay_factor(longPressGesture, 1.5)
echo "The long press now fires one and a half times slower than the default"
```

---

### `gtk_gesture_swipe_new`, `get_velocity`

```nim
proc gtk_gesture_swipe_new*(): GtkGestureSwipe
proc gtk_gesture_swipe_get_velocity*(gesture: GtkGestureSwipe, velocityX: ptr gdouble, velocityY: ptr gdouble): gboolean
```

**What it does.** Recognizes a quick swipe gesture — emits `"swipe"` on completion with the final velocity. `get_velocity` returns the same result outside the signal handler.

- `gesture` — the swipe gesture.
- `velocityX`, `velocityY` — pointers for the velocity components.

```nim
proc onSwipe(gesture: GtkGestureSwipe, velocityX: gdouble, velocityY: gdouble, userData: gpointer) {.cdecl.} =
  if velocityX > 0:
    echo "Swipe right at speed ", velocityX
  else:
    echo "Swipe left at speed ", -velocityX

let swipeGesture = gtk_gesture_swipe_new()
discard g_signal_connect(swipeGesture, "swipe", onSwipe, nil)
```

---

### `gtk_gesture_rotate_new`, `get_angle_delta`

```nim
proc gtk_gesture_rotate_new*(): GtkGestureRotate
proc gtk_gesture_rotate_get_angle_delta*(gesture: GtkGestureRotate): gdouble
```

**What it does.** Recognizes a two-finger rotation gesture — `get_angle_delta` returns the accumulated rotation angle in radians.

- `gesture` — the rotate gesture.

```nim
let rotateGesture = gtk_gesture_rotate_new()
proc onRotateChanged(gesture: GtkGestureRotate, angle: gdouble, angleDelta: gdouble, userData: gpointer) {.cdecl.} =
  echo "Image rotated by ", angleDelta, " radians since the start of the gesture"
discard g_signal_connect(rotateGesture, "angle-changed", onRotateChanged, nil)
```

---

### `gtk_gesture_zoom_new`, `get_scale_delta`

```nim
proc gtk_gesture_zoom_new*(): GtkGestureZoom
proc gtk_gesture_zoom_get_scale_delta*(gesture: GtkGestureZoom): gdouble
```

**What it does.** Recognizes a two-finger pinch-to-zoom gesture — `get_scale_delta` returns the scale factor relative to the start of the gesture.

- `gesture` — the zoom gesture.

```nim
let zoomGesture = gtk_gesture_zoom_new()
proc onZoomChanged(gesture: GtkGestureZoom, scale: gdouble, userData: gpointer) {.cdecl.} =
  echo "Current scale factor: ", scale
discard g_signal_connect(zoomGesture, "scale-changed", onZoomChanged, nil)
```

---

## Specific controllers (non-gesture)

### `gtk_event_controller_key_new` and related

```nim
proc gtk_event_controller_key_new*(): GtkEventControllerKey
proc gtk_event_controller_key_set_im_context*(controller: GtkEventControllerKey, imContext: pointer)
proc gtk_event_controller_key_get_im_context*(controller: GtkEventControllerKey): pointer
proc gtk_event_controller_key_forward*(controller: GtkEventControllerKey, widget: GtkWidget): gboolean
proc gtk_event_controller_key_get_group*(controller: GtkEventControllerKey): guint
```

**What it does.** `gtk_event_controller_key_new` creates a key-press controller — it emits `"key-pressed"`/`"key-released"` signals with the key code and modifiers. `set/get_im_context` link the controller to an input method (Input Method, for languages with complex input — the same mechanism mentioned for `gtk_entry_reset_im_context` in the text-input reference) — a specialized setting for custom text widgets. `key_forward` forwards a key event to another widget — useful when the controller intercepted the event during the capture phase (section I) but must pass the unhandled event on to a specific widget. `get_group` returns the keyboard layout group number (relevant for layouts with alternate character groups, e.g. switched via `AltGr`).

- `controller` — the key controller.
- `imContext` — the input-method object.
- `widget` — the widget the event is forwarded to (for `key_forward`).

```nim
let keyController = gtk_event_controller_key_new()

proc onKeyPressed(controller: GtkEventControllerKey, keyval: guint, keycode: guint, state: gint, userData: gpointer): gboolean {.cdecl.} =
  echo "Key pressed with code ", keyval
  result = 0.gboolean  # 0 — don't consider the event fully handled, let it keep propagating

discard g_signal_connect(keyController, "key-pressed", onKeyPressed, nil)
gtk_widget_add_controller(mainWindow, keyController)
```

---

### `gtk_event_controller_focus_new`, `contains_focus`, `is_focus`

```nim
proc gtk_event_controller_focus_new*(): GtkEventControllerFocus
proc gtk_event_controller_focus_contains_focus*(controller: GtkEventControllerFocus): gboolean
proc gtk_event_controller_focus_is_focus*(controller: GtkEventControllerFocus): gboolean
```

**What it does.** Tracks changes in keyboard focus relative to the widget it's attached to. `is_focus` — focus is on this exact widget. `contains_focus` — focus is on this widget **or on any of its children** (relevant for composite containers where what matters is knowing focus is "somewhere inside," not necessarily on the container itself). Emits `"enter"`/`"leave"` signals when focus is gained/lost.

- `controller` — the focus controller.

```nim
let focusController = gtk_event_controller_focus_new()
gtk_widget_add_controller(formContainer, focusController)
echo "Focus is somewhere inside the form: ", gtk_event_controller_focus_contains_focus(focusController) != 0.gboolean
```

---

### `gtk_event_controller_motion_new`, `contains_pointer`, `is_pointer`

```nim
proc gtk_event_controller_motion_new*(): GtkEventControllerMotion
proc gtk_event_controller_motion_contains_pointer*(controller: GtkEventControllerMotion): gboolean
proc gtk_event_controller_motion_is_pointer*(controller: GtkEventControllerMotion): gboolean
```

**What it does.** Tracks mouse cursor movement over a widget — emits `"enter"`/`"leave"`/`"motion"` (the last one with current coordinates on every movement inside the widget). `is_pointer`/`contains_pointer` follow the same "widget itself / widget or descendants" logic as `GtkEventControllerFocus`, but for cursor hovering rather than keyboard focus. The primary way to implement a hover effect — highlighting a card, showing extra elements on hover, and so on.

- `controller` — the motion controller.

```nim
let motionController = gtk_event_controller_motion_new()

proc onEnter(controller: GtkEventControllerMotion, x: gdouble, y: gdouble, userData: gpointer) {.cdecl.} =
  gtk_widget_add_css_class(cast[GtkWidget](userData), "hovered")

proc onLeave(controller: GtkEventControllerMotion, userData: gpointer) {.cdecl.} =
  gtk_widget_remove_css_class(cast[GtkWidget](userData), "hovered")

discard g_signal_connect(motionController, "enter", onEnter, cast[gpointer](cardWidget))
discard g_signal_connect(motionController, "leave", onLeave, cast[gpointer](cardWidget))
gtk_widget_add_controller(cardWidget, motionController)
```

---

### `gtk_event_controller_scroll_new` and related

```nim
proc gtk_event_controller_scroll_new*(flags: gint): GtkEventControllerScroll
proc gtk_event_controller_scroll_set_flags*(controller: GtkEventControllerScroll, flags: gint)
proc gtk_event_controller_scroll_get_flags*(controller: GtkEventControllerScroll): gint
proc gtk_event_controller_scroll_get_unit*(controller: GtkEventControllerScroll): gint
```

**What it does.** Creates a controller for mouse-wheel/trackpad scrolling — emits a `"scroll"` signal with the scroll amount on each axis. `flags` determines which axes and modes to track: `GTK_EVENT_CONTROLLER_SCROLL_VERTICAL = 1`, `_HORIZONTAL = 2`, `_BOTH_AXES = 3` (sum of both), `_DISCRETE = 4` (only discrete wheel "clicks," no smooth trackpad scrolling), `_KINETIC = 8` (with kinetic/inertial scrolling support). `get_unit` reports the unit the last scroll event arrived in — pixels (smooth trackpad scrolling) or wheel "clicks."

- `flags` — a bitmask of modes (there are no named constants in this wrapper).
- `controller` — the scroll controller.

```nim
let scrollController = gtk_event_controller_scroll_new(3)  # 3 = VERTICAL | HORIZONTAL

proc onScroll(controller: GtkEventControllerScroll, dx: gdouble, dy: gdouble, userData: gpointer): gboolean {.cdecl.} =
  echo "Scrolled by (", dx, ", ", dy, ")"
  result = 0.gboolean

discard g_signal_connect(scrollController, "scroll", onScroll, nil)
gtk_widget_add_controller(canvasWidget, scrollController)
```

---

## Drag-and-Drop: GtkDragSource

`GtkDragSource` is a controller that turns a widget into a source of draggable data: the user can start dragging that widget's content with the mouse and drop it onto another widget that has a `GtkDropTarget` (section VII).

### `gtk_drag_source_new`

```nim
proc gtk_drag_source_new*(): GtkDragSource
```

**What it does.** Creates a drag source with no content — the actual draggable content is set via `set_content` (next subsection), and the source, like any controller, must be attached to a widget via `gtk_widget_add_controller`.

- No parameters.

```nim
let dragSource = gtk_drag_source_new()
echo "Drag source created"
```

---

### `gtk_drag_source_set/get_content`

```nim
proc gtk_drag_source_set_content*(source: GtkDragSource, content: pointer)
proc gtk_drag_source_get_content*(source: GtkDragSource): pointer
```

**What it does.** Sets exactly what gets transferred when dragging — a `GdkContentProvider` object (an opaque `pointer` in this wrapper; building the `GdkContentProvider` itself from text, a file, or arbitrary data is done via the `gdk_content_provider_*` functions, which aren't part of this reference but are conceptually similar to preparing a `GVariant`/`GBytes` from earlier references).

- `source` — the drag source.
- `content` — the `GdkContentProvider` object.

```nim
# textContent is built beforehand via gdk_content_provider_new_for_value with a string GValue
gtk_drag_source_set_content(dragSource, textContent)
echo "The source now carries text content when dragged"
```

---

### `gtk_drag_source_set/get_actions`

```nim
proc gtk_drag_source_set_actions*(source: GtkDragSource, actions: gint)
proc gtk_drag_source_get_actions*(source: GtkDragSource): gint
```

**What it does.** Sets the allowed drag actions — a bitmask of `GDK_ACTION_COPY = 1`, `_MOVE = 2`, `_LINK = 4` (combinable with `or` if the source supports several options, letting the user pick a specific action with a keyboard modifier during the drag — e.g. `Ctrl` for copy instead of move, behavior familiar from file managers).

- `source` — the drag source.
- `actions` — a bitmask of allowed actions.

```nim
gtk_drag_source_set_actions(dragSource, 1 or 2)  # GDK_ACTION_COPY | GDK_ACTION_MOVE
echo "The source now allows both copying and moving during a drag"
```

---

### `gtk_drag_source_set_icon`

```nim
proc gtk_drag_source_set_icon*(source: GtkDragSource, paintable: pointer, hotX: gint, hotY: gint)
```

**What it does.** Sets the image that follows the cursor during a drag (by default GTK shows an automatically generated snapshot of the dragged widget itself) — `paintable` (the same `GdkPaintable` interface as `GdkTexture` from the dialogs-and-media reference), `hotX`/`hotY` — the point inside the image that should sit exactly under the cursor (e.g. `0, 0` — the image's top-left corner tracks the cursor directly).

- `source` — the drag source.
- `paintable` — the drag-cursor image.
- `hotX`, `hotY` — the image's "hot point" relative to the cursor.

```nim
gtk_drag_source_set_icon(dragSource, cast[pointer](thumbnailTexture), 0, 0)
echo "A thumbnail will now follow the cursor during the drag"
```

---

### `gtk_drag_source_drag_cancel` / `gtk_drag_source_get_drag`

```nim
proc gtk_drag_source_drag_cancel*(source: GtkDragSource)
proc gtk_drag_source_get_drag*(source: GtkDragSource): pointer
```

**What it does.** `drag_cancel` programmatically cancels the currently running drag (if any) — for example, if it turns out mid-drag that the data is no longer valid. `get_drag` returns the object for the current drag (`GdkDrag`, as a `pointer`) — `nil` if no drag is in progress.

- `source` — the drag source.

```nim
if not isNil(gtk_drag_source_get_drag(dragSource)):
  gtk_drag_source_drag_cancel(dragSource)
  echo "The current drag was cancelled programmatically"
```

---

## Drag-and-Drop: GtkDropTarget

`GtkDropTarget` is a controller that turns a widget into a place where content dragged from a `GtkDragSource` can be dropped.

### `gtk_drop_target_new`

```nim
proc gtk_drop_target_new*(contentType: GType, actions: gint): GtkDropTarget
```

**What it does.** Creates a drop target that accepts content of a single specific `GType` and allows the specified actions (the same `GDK_ACTION_*` bitmask as `gtk_drag_source_set_actions`).

- `contentType` — the accepted content type (`GType`).
- `actions` — a bitmask of allowed actions.

```nim
let dropTarget = gtk_drop_target_new(G_TYPE_STRING, 1)  # 1 = GDK_ACTION_COPY
echo "The drop target accepts text content, copy only"
```

---

### `gtk_drop_target_set/get_gtypes`

```nim
proc gtk_drop_target_set_gtypes*(target: GtkDropTarget, types: ptr GType, nTypes: gsize)
proc gtk_drop_target_get_gtypes*(target: GtkDropTarget, nTypes: ptr gsize): ptr GType
```

**What it does.** Sets several allowed content types at once instead of the single type from the constructor — for example, accepting both text and files.

- `target` — the drop target.
- `types` — an array of allowed `GType`s.
- `nTypes` — the number of elements in the array.

```nim
var acceptedTypes = [G_TYPE_STRING, gFileGType]
gtk_drop_target_set_gtypes(dropTarget, addr acceptedTypes[0], csize_t(acceptedTypes.len))
echo "The target now accepts both text and files"
```

---

### `gtk_drop_target_set/get_actions`

```nim
proc gtk_drop_target_set_actions*(target: GtkDropTarget, actions: gint)
proc gtk_drop_target_get_actions*(target: GtkDropTarget): gint
```

**What it does.** Changes the allowed actions after the target has already been created.

- `target` — the drop target.
- `actions` — a bitmask of allowed actions.

```nim
gtk_drop_target_set_actions(dropTarget, 1 or 2)
echo "The target now allows both copying and moving"
```

---

### `gtk_drop_target_set/get_preload`

```nim
proc gtk_drop_target_set_preload*(target: GtkDropTarget, preload: gboolean)
proc gtk_drop_target_get_preload*(target: GtkDropTarget): gboolean
```

**What it does.** Enables preloading the content during a drag, before it's actually dropped — allows showing a preview. Off by default.

- `target` — the drop target.
- `preload` — `1.gboolean` to enable preloading.

```nim
gtk_drop_target_set_preload(dropTarget, 1.gboolean)
echo "Content preloading on hover is enabled"
```

---

### `gtk_drop_target_get_value` / `get_drop` / `get_current_drop` / `get_formats` / `reject`

```nim
proc gtk_drop_target_get_value*(target: GtkDropTarget): GValue
proc gtk_drop_target_get_drop*(target: GtkDropTarget): pointer
proc gtk_drop_target_get_current_drop*(target: GtkDropTarget): pointer
proc gtk_drop_target_get_formats*(target: GtkDropTarget): pointer
proc gtk_drop_target_reject*(target: GtkDropTarget)
```

**What it does.** `get_value` returns the actually dropped value as a `GValue` (available inside `"drop"`). `get_drop`/`get_current_drop` — the low-level operation object (`GdkDrop`). `get_formats` — which formats are available in the current drag. `reject` explicitly rejects the drag even if the type formally matches.

- `target` — the drop target.

```nim
proc onDrop(target: GtkDropTarget, value: GValue, x: gdouble, y: gdouble, userData: gpointer): gboolean {.cdecl.} =
  echo "Something was dropped on the target at coordinates (", x, ", ", y, ")"
  result = 1.gboolean

discard g_signal_connect(dropTarget, "drop", onDrop, nil)
gtk_widget_add_controller(dropZoneWidget, dropTarget)
```

---

## Practical recipes

### Right-click for a context menu

```nim
proc onRightClick(gesture: GtkGestureClick, nPress: gint, x: gdouble, y: gdouble, userData: gpointer) {.cdecl.} =
  let contextPopover = cast[GtkPopover](userData)
  gtk_popover_popup(contextPopover)
  echo "Context menu opened by right-click at point (", x, ", ", y, ")"

proc attachContextMenu(widget: GtkWidget, popover: GtkPopover) =
  let rightClickGesture = gtk_gesture_click_new()
  gtk_gesture_single_set_button(rightClickGesture, 3)
  discard g_signal_connect(rightClickGesture, "pressed", onRightClick, cast[gpointer](popover))
  gtk_widget_add_controller(widget, rightClickGesture)
  echo "Context menu wired up to right-click on the widget"
```

---

### Dragging a widget with the mouse inside an area

```nim
proc buildDraggableCard(canvas: GtkFixed, startX, startY: float): GtkWidget =
  result = gtk_button_new_with_label("Drag me")
  gtk_fixed_put(canvas, result, startX, startY)

  let dragGesture = gtk_gesture_drag_new()

  proc onDragUpdate(gesture: GtkGestureDrag, offsetX: gdouble, offsetY: gdouble, userData: gpointer) {.cdecl.} =
    let card = cast[GtkWidget](userData)
    var beginX, beginY: gdouble
    discard gtk_gesture_drag_get_start_point(gesture, addr beginX, addr beginY)
    gtk_fixed_move(canvas, card, beginX + offsetX, beginY + offsetY)

  discard g_signal_connect(dragGesture, "drag-update", onDragUpdate, cast[gpointer](result))
  gtk_widget_add_controller(result, dragGesture)
  echo "The card can now be freely dragged with the mouse inside the area"

let canvas = gtk_fixed_new()
let card = buildDraggableCard(canvas, 20.0, 20.0)
```

---

### Long press as a mobile context-menu gesture

```nim
proc onLongPress(gesture: GtkGestureLongPress, x: gdouble, y: gdouble, userData: gpointer) {.cdecl.} =
  let contextPopover = cast[GtkPopover](userData)
  gtk_popover_popup(contextPopover)
  echo "Context menu opened by a long press"

proc attachLongPressMenu(widget: GtkWidget, popover: GtkPopover) =
  let longPressGesture = gtk_gesture_long_press_new()
  gtk_gesture_single_set_touch_only(longPressGesture, 1.gboolean)
  discard g_signal_connect(longPressGesture, "pressed", onLongPress, cast[gpointer](popover))
  gtk_widget_add_controller(widget, longPressGesture)
  echo "A long press on a touchscreen opens the same context menu"
```

---

### Dragging text from one field to another

```nim
proc attachTextDragSource(sourceLabel: GtkLabel) =
  let dragSource = gtk_drag_source_new()
  gtk_drag_source_set_actions(dragSource, 1)

  proc onPrepare(source: GtkDragSource, x: gdouble, y: gdouble, userData: gpointer): pointer {.cdecl.} =
    let text = $gtk_label_get_text(cast[GtkLabel](userData))
    echo "Preparing content for the drag: ", text

  discard g_signal_connect(dragSource, "prepare", onPrepare, cast[gpointer](sourceLabel))
  gtk_widget_add_controller(sourceLabel, dragSource)

proc attachTextDropTarget(targetEntry: GtkEntry) =
  let dropTarget = gtk_drop_target_new(G_TYPE_STRING, 1)

  proc onDrop(target: GtkDropTarget, value: GValue, x: gdouble, y: gdouble, userData: gpointer): gboolean {.cdecl.} =
    echo "Text dropped into the entry field"
    result = 1.gboolean

  discard g_signal_connect(dropTarget, "drop", onDrop, nil)
  gtk_widget_add_controller(targetEntry, dropTarget)

echo "Dragging text between the label and the entry field is set up"
```

---

### Reacting to hover on a card

```nim
proc makeCardHoverable(card: GtkWidget) =
  let motionController = gtk_event_controller_motion_new()

  proc onEnter(controller: GtkEventControllerMotion, x: gdouble, y: gdouble, userData: gpointer) {.cdecl.} =
    gtk_widget_add_css_class(cast[GtkWidget](userData), "card-hovered")

  proc onLeave(controller: GtkEventControllerMotion, userData: gpointer) {.cdecl.} =
    gtk_widget_remove_css_class(cast[GtkWidget](userData), "card-hovered")

  discard g_signal_connect(motionController, "enter", onEnter, cast[gpointer](card))
  discard g_signal_connect(motionController, "leave", onLeave, cast[gpointer](card))
  gtk_widget_add_controller(card, motionController)
  echo "The card is highlighted with a CSS class on hover"
```

---

## Quick reference table

| Procedure(s) | Category | What it does, briefly |
|---|---|---|
| `gtk_widget_add/remove_controller` | EventController | Attach/detach a controller to/from a widget |
| `gtk_event_controller_get_widget` | EventController | The widget the controller is attached to |
| `gtk_event_controller_set/get_propagation_phase` | EventController | Event propagation phase |
| `gtk_event_controller_set/get_propagation_limit` | EventController | Limit on propagation outside the window |
| `gtk_event_controller_set/get_name` | EventController | Debug name of the controller |
| `gtk_event_controller_reset` | EventController | Reset internal state |
| `gtk_gesture_is_active`, `is_recognized` | Gesture | Whether the gesture is active / recognized |
| `gtk_gesture_get_point`, `get_bounding_box*` | Gesture | Coordinates of interaction points |
| `gtk_gesture_set_state`, `get/set_sequence_state` | Gesture | Claiming exclusive ownership |
| `gtk_gesture_group/ungroup`, `is_grouped_with` | Gesture | Handling by multiple gestures together |
| `gtk_gesture_single_set/get_button` | GestureSingle | Mouse button |
| `gtk_gesture_single_set/get_touch_only` | GestureSingle | React to touch input only |
| `gtk_gesture_single_set/get_exclusive` | GestureSingle | Ignore on a second touch point |
| `gtk_gesture_click_new` | Click | Click recognition |
| `gtk_gesture_drag_new`, `get_start_point`, `get_offset` | Drag | Mouse-drag recognition |
| `gtk_gesture_long_press_new`, `set/get_delay_factor` | LongPress | Long-press recognition |
| `gtk_gesture_swipe_new`, `get_velocity` | Swipe | Swipe gesture recognition |
| `gtk_gesture_rotate_new`, `get_angle_delta` | Rotate | Rotation recognition |
| `gtk_gesture_zoom_new`, `get_scale_delta` | Zoom | Zoom/pinch recognition |
| `gtk_event_controller_key_new` and related | Key | Key presses, input method |
| `gtk_event_controller_focus_new`, `contains/is_focus` | Focus | Focus tracking |
| `gtk_event_controller_motion_new`, `contains/is_pointer` | Motion | Cursor tracking, hover |
| `gtk_event_controller_scroll_new` and related | Scroll | Wheel/trackpad scrolling |
| `gtk_drag_source_new` | DragSource | Create a drag source |
| `gtk_drag_source_set/get_content` | DragSource | Draggable content |
| `gtk_drag_source_set/get_actions` | DragSource | Allowed actions |
| `gtk_drag_source_set_icon` | DragSource | Image that follows the cursor |
| `gtk_drag_source_drag_cancel`, `get_drag` | DragSource | Programmatic cancel / current drag |
| `gtk_drop_target_new` | DropTarget | Create a drop target |
| `gtk_drop_target_set/get_gtypes` | DropTarget | Multiple allowed types |
| `gtk_drop_target_set/get_actions` | DropTarget | Allowed actions |
| `gtk_drop_target_set/get_preload` | DropTarget | Preload on hover |
| `gtk_drop_target_get_value`, `get_drop`, `get_current_drop`, `get_formats`, `reject` | DropTarget | Reading and rejecting content |

---

## Summary: which procedure to choose

- **Reacting to a plain click** → `GtkGestureClick` with the default button (`0` — any). **Right button only, for a context menu** → the same gesture with `gtk_gesture_single_set_button(gesture, 3)`.
- **Dragging a widget within the application's UI** → `GtkGestureDrag` plus your own movement logic, not full drag-and-drop — that's needed for transferring data between widgets/applications.
- **Transferring data by dragging between different widgets** → `GtkDragSource` + `GtkDropTarget`, not `GtkGestureDrag`.
- **Long press as a touch-device stand-in for right-click** → `GtkGestureLongPress` with `touch_only = true`, so it doesn't conflict with a regular mouse click.
- **A hover highlight effect with no click** → `GtkEventControllerMotion` with `"enter"`/`"leave"` driving a CSS class.
- **A parent needs to intercept events before its children** → `propagation_phase = 0` (capture), rather than relying on the default bubble phase.
- **Several gestures on the same widget shouldn't interfere with each other** → `gtk_gesture_group`, rather than relying on automatic coexistence.
