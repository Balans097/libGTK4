# GTK4 (drawing, styling & low-level utilities: DrawingArea / CssProvider / GFile / GVariant / GObject) — module reference

> **Import:** `import libGTK4`
> **Scope:** custom drawing via Cairo, programmatic styling via CSS, and the low-level GLib/GObject utilities that underlie the rest of the wrapper (files, errors, variant values, object properties, reference counting). The ninth part of the wrapper reference series; assumes familiarity with the previous parts, especially `gtk4_core_reference_ru.md` (layout, `GtkWidget`).

This reference differs from the previous ones in nature: `GtkDrawingArea` and `GtkCssProvider` are still widget/GTK-specific APIs, but `GFile`, `GVariant`, and especially `GObject` are no longer GTK itself — they are the underlying GLib/GObject layer on which GTK, and transitively this entire wrapper, is built. The `GObject` functions apply not only to widgets, but to any GObject-compatible object encountered in the previous references (`GtkApplication`, `GtkTextBuffer`, `GMenuModel`, etc.).

---

## Table of Contents

I. [GtkDrawingArea](#gtkdrawingarea)
&nbsp;&nbsp;1. [`gtk_drawing_area_new`](#gtk_drawing_area_new)
&nbsp;&nbsp;2. [`gtk_drawing_area_set_content_width` / `get_content_width` / `set_content_height` / `get_content_height`](#gtk_drawing_area_set_content_width--get_content_width--set_content_height--get_content_height)
&nbsp;&nbsp;3. [`gtk_drawing_area_set_draw_func`](#gtk_drawing_area_set_draw_func)

II. [Styling: GtkCssProvider and GtkStyleContext](#styling-gtkcssprovider-and-gtkstylecontext)
&nbsp;&nbsp;1. [`gtk_css_provider_new`](#gtk_css_provider_new)
&nbsp;&nbsp;2. [`gtk_css_provider_load_from_data` / `_from_file` / `_from_path` / `_from_string`](#gtk_css_provider_load_from_data--_from_file--_from_path--_from_string)
&nbsp;&nbsp;3. [`gtk_widget_get_style_context` / `gtk_style_context_add_provider`](#gtk_widget_get_style_context--gtk_style_context_add_provider)
&nbsp;&nbsp;4. [`gtk_style_context_add_provider_for_display` / `gtk_widget_get_display` / `gdk_display_get_default`](#gtk_style_context_add_provider_for_display--gtk_widget_get_display--gdk_display_get_default)

III. [GFile and GError](#gfile-and-gerror)
&nbsp;&nbsp;1. [`g_file_new_for_path` / `g_file_get_path` / `g_file_get_basename`](#g_file_new_for_path--g_file_get_path--g_file_get_basename)
&nbsp;&nbsp;2. [`g_error_free`](#g_error_free)

IV. [GVariant](#gvariant)
&nbsp;&nbsp;1. [`g_variant_new_string` / `g_variant_new_boolean` / `g_variant_new_int32`](#g_variant_new_string--g_variant_new_boolean--g_variant_new_int32)
&nbsp;&nbsp;2. [`g_variant_get_string` / `g_variant_get_boolean` / `g_variant_get_int32`](#g_variant_get_string--g_variant_get_boolean--g_variant_get_int32)

V. [GObject](#gobject)
&nbsp;&nbsp;1. [Reference counting: `g_object_ref` / `g_object_unref` / `g_object_ref_sink` / `g_object_is_floating`](#reference-counting-g_object_ref--g_object_unref--g_object_ref_sink--g_object_is_floating)
&nbsp;&nbsp;2. [`g_object_set` / `g_object_get`](#g_object_set--g_object_get)
&nbsp;&nbsp;3. [`g_object_set_property` / `g_object_get_property`](#g_object_set_property--g_object_get_property)
&nbsp;&nbsp;4. [Change notifications: `g_object_notify` and related](#change-notifications-g_object_notify-and-related)
&nbsp;&nbsp;5. [Arbitrary data by string key: `g_object_set_data` and related](#arbitrary-data-by-string-key-g_object_set_data-and-related)
&nbsp;&nbsp;6. [Weak references: `g_object_weak_ref` and related](#weak-references-g_object_weak_ref-and-related)
&nbsp;&nbsp;7. [Toggle references: `g_object_add_toggle_ref`](#toggle-references-g_object_add_toggle_ref)
&nbsp;&nbsp;8. [Type information: `g_object_get_type` and related](#type-information-g_object_get_type-and-related)
&nbsp;&nbsp;9. [Creating objects: `g_object_new` / `g_object_newv`](#creating-objects-g_object_new--g_object_newv)
&nbsp;&nbsp;10. [Data by GQuark: `g_object_set_qdata` and related](#data-by-gquark-g_object_set_qdata-and-related)
&nbsp;&nbsp;11. [Binding properties: `g_object_bind_property`](#binding-properties-g_object_bind_property)
&nbsp;&nbsp;12. [`g_quark_from_string` / `g_quark_to_string` / `g_quark_try_string`](#g_quark_from_string--g_quark_to_string--g_quark_try_string)

VI. [Practical recipes](#practical-recipes)
&nbsp;&nbsp;1. [A simple drawing on GtkDrawingArea via Cairo](#a-simple-drawing-on-gtkdrawingarea-via-cairo)
&nbsp;&nbsp;2. [Loading a global application CSS theme](#loading-a-global-application-css-theme)
&nbsp;&nbsp;3. [Binding a button's sensitivity to a checkbox state without a single line of handler code](#binding-a-buttons-sensitivity-to-a-checkbox-state-without-a-single-line-of-handler-code)
&nbsp;&nbsp;4. [Attaching custom data to a widget by string key](#attaching-custom-data-to-a-widget-by-string-key)
&nbsp;&nbsp;5. [Passing a composite value via GVariant to an action handler](#passing-a-composite-value-via-gvariant-to-an-action-handler)

VII. [Quick reference table](#quick-reference-table)

VIII. [Summary: which procedure to choose](#summary-which-procedure-to-choose)

---

## GtkDrawingArea

`GtkDrawingArea` is an empty canvas: a widget with no visual representation of its own, which calls a drawing function you supply every time it needs to be redrawn. The drawing function receives a Cairo context — a low-level 2D graphics API (lines, shapes, text, images) that isn't covered here as a topic in its own right, but is mentioned to the extent needed for basic use of `GtkDrawingArea`.

### `gtk_drawing_area_new`

```nim
proc gtk_drawing_area_new*(): GtkDrawingArea
```

**What it does.** Creates an empty drawing area with no drawing function assigned — the function itself must be set separately via `gtk_drawing_area_set_draw_func`; without it the area remains visually empty.

- No parameters.

```nim
let canvas = gtk_drawing_area_new()
echo "Empty drawing area created"
```

---

### `gtk_drawing_area_set_content_width` / `get_content_width` / `set_content_height` / `get_content_height`

```nim
proc gtk_drawing_area_set_content_width*(area: GtkDrawingArea, width: gint)
proc gtk_drawing_area_get_content_width*(area: GtkDrawingArea): gint
proc gtk_drawing_area_set_content_height*(area: GtkDrawingArea, height: gint)
proc gtk_drawing_area_get_content_height*(area: GtkDrawingArea): gint
```

**What it does.** Sets the preferred content size of the canvas — how much space the drawing area requests for itself from the layout system (analogous to `gtk_widget_set_size_request` from the core reference, but specifically for the drawing content rather than the widget's overall minimum). The actual size the area receives on screen still depends on the parent container and the `hexpand`/`vexpand` settings — these two values are only a preference.

- `area` — the drawing area.
- `width`, `height` — the preferred content size in pixels.

```nim
gtk_drawing_area_set_content_width(canvas, 300)
gtk_drawing_area_set_content_height(canvas, 200)
echo "Drawing area is requesting 300×200 pixels for itself"
```

---

### `gtk_drawing_area_set_draw_func`

```nim
proc gtk_drawing_area_set_draw_func*(area: GtkDrawingArea, drawFunc: pointer, userData: gpointer, destroy: GDestroyNotify)
```

**What it does.** Assigns the function GTK calls every time the drawing area needs to be redrawn (on first display, on resize, or on an explicit redraw request via `gtk_widget_queue_draw` from the core reference). `drawFunc` is a pointer to a C-compatible function with the signature `proc(area: GtkDrawingArea, cr: pointer, width, height: gint, userData: gpointer) {.cdecl.}`, where `cr` is the Cairo context into which all drawing is done via `cairo_*` functions (not covered in this reference). `destroy` is an optional cleanup function for `userData`, called when the drawing area is destroyed or the drawing function is replaced with another one (`nil` can be passed if `userData` doesn't need to be freed).

- `area` — the drawing area.
- `drawFunc` — pointer to the drawing function.
- `userData` — arbitrary user data passed to `drawFunc`.
- `destroy` — cleanup function for `userData`, or `nil`.

```nim
proc onDraw(area: GtkDrawingArea, cr: pointer, width: gint, height: gint, userData: gpointer) {.cdecl.} =
  # cairo_* functions are used here (cairo_set_source_rgb, cairo_rectangle,
  # cairo_fill, etc.) to draw into the cr context — the Cairo API is not
  # covered in this reference.
  echo "Drawing canvas of size ", width, "×", height

gtk_drawing_area_set_draw_func(canvas, onDraw, nil, nil)
echo "Drawing function assigned to the canvas"
```

---

## Styling: GtkCssProvider and GtkStyleContext

CSS is the main mechanism for visual customization in GTK4: colors, padding, fonts, and borders are specified in CSS syntax (similar to, but not identical to, web CSS) and applied to widgets via selectors by name (`gtk_widget_set_name`, see the core controls reference), by CSS class (`gtk_widget_add_css_class`), or by widget type. `GtkCssProvider` loads style rules from various sources; `GtkStyleContext` determines the scope (a specific widget or the entire application) to which those rules are applied.

### `gtk_css_provider_new`

```nim
proc gtk_css_provider_new*(): GtkCssProvider
```

**What it does.** Creates an empty style provider that doesn't yet contain any CSS rules — the rules themselves are loaded via one of the calls in the next subsection.

- No parameters.

```nim
let cssProvider = gtk_css_provider_new()
echo "Style provider created"
```

---

### `gtk_css_provider_load_from_data` / `_from_file` / `_from_path` / `_from_string`

```nim
proc gtk_css_provider_load_from_data*(cssProvider: GtkCssProvider, data: cstring, length: gssize)
proc gtk_css_provider_load_from_file*(cssProvider: GtkCssProvider, file: GFile)
proc gtk_css_provider_load_from_path*(cssProvider: GtkCssProvider, path: cstring)
proc gtk_css_provider_load_from_string*(cssProvider: GtkCssProvider, str: cstring)
```

**What it does.** Four ways to load CSS rules into an already-created provider. `load_from_data` loads from a byte buffer of a given length (`length = -1` for a `NUL`-terminated string). `load_from_file` loads from a `GFile` object (section III). `load_from_path` is shorter — directly from a file path string on disk, without creating an intermediate `GFile`. `load_from_string` loads from a ready-made Nim string of CSS embedded directly in the program code (for example, for a few lines of CSS that don't warrant a separate file).

- `cssProvider` — the style provider.
- `data` / `str` — the CSS text.
- `length` (for `load_from_data`) — length in bytes, or `-1`.
- `file` — a `GFile` object pointing to the CSS file.
- `path` — the path to the CSS file.

```nim
gtk_css_provider_load_from_string(cssProvider, """
  .danger-button { background-color: #c0392b; }
  .rounded-panel { border-radius: 12px; }
""")
echo "CSS rules loaded from a string embedded in the code"
```

---

### `gtk_widget_get_style_context` / `gtk_style_context_add_provider`

```nim
proc gtk_widget_get_style_context*(widget: GtkWidget): GtkStyleContext
proc gtk_style_context_add_provider*(context: GtkStyleContext, provider: pointer, priority: guint)
```

**What it does.** Applies a style provider to a single specific widget only (and, automatically, to all of its child widgets, since CSS styles are inherited in a cascade) — obtain the style context via `gtk_widget_get_style_context`, then add the provider to it. `priority` determines the order of application when rules from different providers for the same widget conflict — for equally specific CSS selectors, the provider with the higher numeric priority wins; for an application's own styles, the value `GTK_STYLE_PROVIDER_PRIORITY_APPLICATION` is typically used (a constant not defined as a separate name in this wrapper — in practice equivalent to the number `600`, which can be passed directly).

- `widget` — the widget the style is applied to.
- `context` — the style context obtained from `get_style_context`.
- `provider` — the style provider (`GtkCssProvider`, cast to `pointer`).
- `priority` — the numeric priority.

```nim
let context = gtk_widget_get_style_context(dangerButton)
gtk_style_context_add_provider(context, cast[pointer](cssProvider), 600)
gtk_widget_add_css_class(dangerButton, "danger-button")
echo "Custom CSS class applied only to this button (and its descendants)"
```

---

### `gtk_style_context_add_provider_for_display` / `gtk_widget_get_display` / `gdk_display_get_default`

```nim
proc gtk_style_context_add_provider_for_display*(display: pointer, provider: pointer, priority: guint)
proc gtk_widget_get_display*(widget: GtkWidget): GdkDisplay
proc gdk_display_get_default*(): pointer
```

**What it does.** `gtk_style_context_add_provider_for_display` applies a style provider globally — to all widgets in all windows shown on a given display (`GdkDisplay` is an abstraction of a screen/display session, in X11/Wayland terms), rather than to a single widget and its descendants as `gtk_style_context_add_provider` does. This is exactly how an application's shared CSS theme is loaded (see section VI, "Loading a global CSS theme"). The display to apply the styles to is obtained either from a specific already-existing widget via `gtk_widget_get_display`, or, if no widget/window has been created yet, via `gdk_display_get_default()` — the default display for the current session.

- `display` — the display object (`GdkDisplay`, cast to `pointer`).
- `provider` — the style provider.
- `priority` — the numeric priority.

```nim
let display = gdk_display_get_default()
gtk_style_context_add_provider_for_display(display, cast[pointer](cssProvider), 600)
echo "CSS provider applied globally to all application windows on this display"
```

---

## GFile and GError

`GFile` is a GIO abstraction of a file or folder, representing a path without immediately touching the filesystem (unlike a plain path string, `GFile` can also work with network and virtual filesystems — though in this wrapper only basic operations for local paths are available). `GError` is the standard way GLib/GTK C functions convey error information, already encountered in previous references as a `ptr GError` parameter in many functions (e.g. `gtk_file_chooser_set_file`).

### `g_file_new_for_path` / `g_file_get_path` / `g_file_get_basename`

```nim
proc g_file_new_for_path*(path: cstring): GFile
proc g_file_get_path*(file: GFile): cstring
proc g_file_get_basename*(file: GFile): cstring
```

**What it does.** `g_file_new_for_path` creates a `GFile` object from an ordinary local path string — the most common way to obtain a `GFile` for functions that expect one (e.g. `gtk_css_provider_load_from_file`, `gtk_file_chooser_set_current_folder` from previous references). `g_file_get_path` is the reverse operation, extracting the path string back (it may return `nil` for a `GFile` that doesn't represent a local path — e.g. network resources, which isn't relevant here since the only way to create a `GFile` in this wrapper is from a local path). `g_file_get_basename` returns only the file name without the folder path (the last path component).

- `path` — a local path string (absolute or relative).
- `file` — the `GFile` object.

```nim
let configFile = g_file_new_for_path("/home/user/.config/myapp/settings.json")
echo "File name: ", $g_file_get_basename(configFile)  # prints "File name: settings.json"
echo "Full path: ", $g_file_get_path(configFile)
```

---

### `g_error_free`

```nim
proc g_error_free*(error: GError)
```

**What it does.** Frees the memory occupied by a `GError` object obtained from a function that accepted a `ptr GError` parameter (after the value at that pointer has been filled in by the function and the error text has already been read/handled by the calling code). `GError` is not managed automatically by GObject's reference counting (it's a separate GLib structure, not a GObject) — if a function returned an error via `ptr GError`, the responsibility for freeing the memory lies with the calling code.

- `error` — the error object.

```nim
var err: ptr GError = nil
if gtk_file_chooser_set_file(chooser, someFile, addr err) == 0.gboolean:
  if not isNil(err):
    echo "Failed to set the file — an error was received"
    g_error_free(err[])  # err is ptr GError, err[] is the GError object itself
```

- **Implementation notes.** Forgetting to call `g_error_free` for every error received is a source of memory leaks in long-running applications, especially in code where errors occur frequently (e.g. during periodic network operations) — it's worth calling it on both branches (both when handling an error and immediately after finding out there was an error but ignoring it). Note: in this wrapper `GError` is typed as an opaque `pointer` (not as a structure with fields), so the error text (the `message` field of the real C `GError` structure) cannot be read directly through ordinary Nim field access — that would require a separate accessor binding not included in the current set of functions; this wrapper only allows checking for the fact that an error occurred and freeing the memory correctly.

---

## GVariant

`GVariant` is a type-safe container for a value of an arbitrary type (string, number, boolean, as well as nested structures and arrays — though only three basic scalar types are available in this wrapper), with information about its own type built into the value itself. It's used wherever GTK/GIO needs a universal way to pass a value without tying it to a specific language/ABI — primarily for action parameters (Actions, see the window chrome reference regarding `gtk_actionable_set_action_target_value`) and for serializing settings via `GSettings` (not covered in this wrapper).

### `g_variant_new_string` / `g_variant_new_boolean` / `g_variant_new_int32`

```nim
proc g_variant_new_string*(str: cstring): GVariant
proc g_variant_new_boolean*(value: gboolean): GVariant
proc g_variant_new_int32*(value: gint32): GVariant
```

**What it does.** Wraps an ordinary Nim/C value (a string, boolean, or 32-bit integer) in a typed `GVariant`. The resulting `GVariant` "knows" its own type — when reading it back later via `g_variant_get_*` (next subsection), it's important to use the function matching the type the value was created with, otherwise the behavior is undefined.

- `str` — the string (for `new_string`).
- `value` — the boolean (for `new_boolean`) or the 32-bit integer (for `new_int32`).

```nim
let targetValue = g_variant_new_string("grid")
gtk_actionable_set_action_target_value(viewModeButton, targetValue)
echo "GVariant with the string 'grid' created and passed as the action parameter"
```

---

### `g_variant_get_string` / `g_variant_get_boolean` / `g_variant_get_int32`

```nim
proc g_variant_get_string*(value: GVariant, length: ptr gsize): cstring
proc g_variant_get_boolean*(value: GVariant): gboolean
proc g_variant_get_int32*(value: GVariant): gint32
```

**What it does.** Extracts a value of the corresponding type back out of a `GVariant`. `g_variant_get_string` can additionally return the string's length via `length` (in bytes, not counting the trailing null) — passing `nil` instead of `length` is fine if the length isn't needed, since the string is already `NUL`-terminated.

- `value` — the `GVariant` object.
- `length` (only for `get_string`) — pointer for the string length, or `nil`.

```nim
proc onActionActivated(action: pointer, parameter: GVariant, userData: gpointer) {.cdecl.} =
  let requestedMode = $g_variant_get_string(parameter, nil)
  echo "Requested display mode: ", requestedMode
```

---

## GObject

`GObject` is the base class of the object system on which all of GTK is built: reference counting, the property system, signals (the window chrome reference uses signals in passing; a full treatment is in a separate reference). The functions in this section apply to any object encountered in the previous references — a window, a button, a text buffer, an application — since all of them ultimately inherit from `GObject`. In this wrapper, a parameter of type `GObject` accepts a `gpointer`/any of the more specific widget types directly, without an explicit cast.

### Reference counting: `g_object_ref` / `g_object_unref` / `g_object_ref_sink` / `g_object_is_floating`

```nim
proc g_object_ref*(obj: gpointer): gpointer
proc g_object_unref*(obj: gpointer)
proc g_object_ref_sink*(obj: gpointer): gpointer
proc g_object_is_floating*(obj: GObject): gboolean
proc g_object_force_floating*(obj: GObject)
```

**What it does.** GObject manages object lifetime through reference counting: `g_object_ref` increments the count by one (the object won't be destroyed while the count is greater than zero) and returns the same object — convenient for use in an assignment chain. `g_object_unref` decrements the count; when it reaches zero, the object is destroyed. GTK widgets are in a special "floating" state when created — they don't need to be explicitly `ref`'d immediately after creation, since the container the widget is added to (`gtk_box_append` and similar functions from previous references) itself "sinks" the floating reference internally via `g_object_ref_sink`; `g_object_is_floating` checks the current state, `g_object_force_floating` forcibly returns the object to the floating state (a specialized scenario, almost never needed in application code).

- **Implementation notes.** For widgets added to a container in the ordinary way (`gtk_box_append`, `gtk_window_set_child`, etc. from previous references), calling code normally doesn't need to manage the reference count manually at all — the floating reference is passed to the container automatically. Explicit `g_object_ref`/`unref` is needed primarily for objects that need to be kept "alive" longer than a single container owns them (for example, to temporarily remove a widget from one container and place it into another without letting it be destroyed in between).

- `obj` — the object.

```nim
let keepAliveRef = g_object_ref(someWidget)
gtk_box_remove(oldContainer, someWidget)
gtk_box_append(newContainer, someWidget)
g_object_unref(keepAliveRef)  # the temporary protective reference is no longer needed
echo "Widget safely moved between containers without risk of being destroyed in the process"
```

---

### `g_object_set` / `g_object_get`

```nim
proc g_object_set*(obj: GObject, firstPropertyName: cstring) {.varargs.}
proc g_object_get*(obj: GObject, firstPropertyName: cstring) {.varargs.}
```

**What it does.** Sets/reads several named properties of a GObject object at once — a universal mechanism that works for any property of any GObject class (including those for which this wrapper doesn't define a dedicated type-safe `get_X`/`set_X` pair), but requires passing the property name as a string with no compile-time type checking. The argument list is alternating "property name" / "value" pairs, terminated by a mandatory `nil` — the same C variadic-argument protocol as `gtk_file_chooser_dialog_new` from the dialogs reference.

- **Implementation notes.** For properties that already have a dedicated type-safe pair of functions in this wrapper (e.g. `gtk_window_set_title`/`get_title`), it's preferable to use that pair — it's checked by the Nim compiler and doesn't require remembering the exact property name string and its C type. `g_object_set`/`get` is a fallback for accessing properties not explicitly covered elsewhere in the wrapper.

- `obj` — the object.
- `firstPropertyName`, followed by (name, value) pairs, terminated by `nil`.

```nim
g_object_set(cast[GObject](someButton), "sensitive".cstring, 0.gboolean, nil)
echo "The 'sensitive' property changed directly via g_object_set, bypassing the type-safe wrapper"
```

---

### `g_object_set_property` / `g_object_get_property`

```nim
proc g_object_set_property*(obj: GObject, propertyName: cstring, value: pointer)
proc g_object_get_property*(obj: GObject, propertyName: cstring, value: pointer)
```

**What it does.** Sets/reads a **single** property by name via a `GValue` object (a typed value container from GObject, distinct from the `GVariant` in section IV, though similar in purpose) — a lower-level alternative to `g_object_set`/`get` that requires you to prepare and initialize a `GValue` of the appropriate type yourself (functions for working with `GValue` aren't covered in this reference). In practice, `g_object_set`/`get` from the previous subsection is more convenient for most cases — this pair is needed primarily when writing generic code that works with properties of an arbitrary type via introspection, without knowing in advance exactly what type of value it's dealing with.

- `obj` — the object.
- `propertyName` — the property name.
- `value` — a pointer to a prepared `GValue` (not a raw value directly).

```nim
# gvalue must be pre-initialized via g_value_init with the appropriate GType
g_object_get_property(cast[GObject](someWidget), "visible", addr gvalue)
echo "Value of the 'visible' property read into a GValue"
```

---

### Change notifications: `g_object_notify` and related

```nim
proc g_object_notify*(obj: GObject, propertyName: cstring)
proc g_object_notify_by_pspec*(obj: GObject, pspec: pointer)
proc g_object_freeze_notify*(obj: GObject)
proc g_object_thaw_notify*(obj: GObject)
```

**What it does.** `g_object_notify` manually emits the `"notify::property-name"` signal for the given property — GTK does this automatically when a property is changed through the standard setters; an explicit call is only needed when implementing your own GObject subclasses with their own properties (a topic beyond the scope of this reference, which is oriented toward using ready-made GTK widgets rather than creating new classes). `g_object_notify_by_pspec` does the same thing, but using an already-obtained property specification object (`GParamSpec`, represented here as `pointer`) instead of a string name — faster for frequent calls, since it doesn't need to look up the property by name each time. `g_object_freeze_notify`/`thaw_notify` temporarily suspend the emission of all `"notify::*"` notifications for an object (useful when bulk-changing several properties at once via `g_object_set`, so subscribers get a single resulting notification after `thaw_notify` rather than one per intermediate change) — the calls must be strictly paired.

- `obj` — the object.
- `propertyName` — the property name (for `notify`).
- `pspec` — the property specification object (for `notify_by_pspec`).

```nim
g_object_freeze_notify(cast[GObject](configObject))
g_object_set(cast[GObject](configObject), "width".cstring, 800.cint, "height".cstring, 600.cint, nil)
g_object_thaw_notify(cast[GObject](configObject))
echo "Both properties changed, subscribers will get notifications in one batch after thaw_notify"
```

---

### Arbitrary data by string key: `g_object_set_data` and related

```nim
proc g_object_set_data*(obj: GObject, key: cstring, data: gpointer)
proc g_object_get_data*(obj: GObject, key: cstring): gpointer
proc g_object_set_data_full*(obj: GObject, key: cstring, data: gpointer, destroy: pointer)
proc g_object_steal_data*(obj: GObject, key: cstring): gpointer
```

**What it does.** Attaches arbitrary application data to any GObject object by string key — a way to associate additional information with an existing widget for which the widget class itself has no dedicated property (for example, attaching a database record ID to a `GtkListBoxRow` from which that row was built). `set_data_full` is the same thing, but with a `destroy` function that is called automatically when the object is destroyed or when the same data under the same key is overwritten with new data — needed if `data` itself owns resources that need to be freed (for example, a pointer to a heap-allocated Nim structure registered via `GC_ref`, which is outside the scope of this reference). `get_data` reads the data, leaving it attached; `steal_data` reads and simultaneously detaches the data from the object, without calling the `destroy` function even if one was set via `set_data_full` — that is, it passes responsibility for the data to the calling code.

- `obj` — the object.
- `key` — the string key.
- `data` — the arbitrary data (`gpointer`).
- `destroy` (for `set_data_full`) — the data cleanup function.

```nim
g_object_set_data(cast[GObject](contactRow), "contact-id", cast[gpointer](contactId))
# ... later, e.g. in a row-click handler ...
let storedId = g_object_get_data(cast[GObject](contactRow), "contact-id")
echo "Contact identifier attached to the list row has been retrieved"
```

---

### Weak references: `g_object_weak_ref` and related

```nim
proc g_object_weak_ref*(obj: GObject, notify: pointer, data: gpointer)
proc g_object_weak_unref*(obj: GObject, notify: pointer, data: gpointer)
proc g_object_add_weak_pointer*(obj: GObject, weakPointerLocation: ptr gpointer)
proc g_object_remove_weak_pointer*(obj: GObject, weakPointerLocation: ptr gpointer)
```

**What it does.** A weak reference does not increment the object's reference count (unlike `g_object_ref`) and therefore doesn't prevent the object from being destroyed, but it lets you find out the **moment** it is destroyed. `g_object_weak_ref` registers a callback function `notify` (C-compatible, called with `data` and a pointer to the object being destroyed) that fires exactly at the moment the object is destroyed — useful for, say, cleaning up an external data structure that references this object, without waiting for an explicit notification from somewhere else. `g_object_add_weak_pointer` is a simpler variant: instead of a callback function, just the address of a Nim/C variable (`weakPointerLocation`) that GTK itself will zero out (`nil`) at the moment the object is destroyed — convenient when the only thing needed is to prevent the variable from holding a dangling pointer to an already-destroyed object.

- `obj` — the object.
- `notify` — the callback function (for `weak_ref`).
- `data` — arbitrary data passed to `notify`.
- `weakPointerLocation` — the address of the pointer variable to be zeroed out on destruction.

```nim
var widgetPointer: gpointer = cast[gpointer](temporaryPopover)
g_object_add_weak_pointer(cast[GObject](temporaryPopover), addr widgetPointer)
# ... after the popover may have been destroyed somewhere else in the code ...
if isNil(widgetPointer):
  echo "The popover has already been destroyed — not attempting to access it again"
```

---

### Toggle references: `g_object_add_toggle_ref`

```nim
proc g_object_add_toggle_ref*(obj: GObject, notify: pointer, data: gpointer)
proc g_object_remove_toggle_ref*(obj: GObject, notify: pointer, data: gpointer)
```

**What it does.** A specialized mechanism for tracking when an object's reference count crosses between the value "1" and "more than 1" in either direction — intended almost exclusively for implementing GObject bindings to other languages (including, indirectly, mechanisms similar to what this very wrapper is — a Nim binding to GTK), letting a language with its own garbage collector synchronize the lifetime of its Nim/managed wrapper object with the actual lifetime of the GObject object. For application code using ready-made GTK widgets through this wrapper, toggle references are almost never needed directly — mentioned here for completeness, since the functions are present in the set.

- `obj` — the object.
- `notify` — the callback function, receiving a flag for whether the count became `1` or more.
- `data` — arbitrary data passed to `notify`.

```nim
# Specialized scenario — typical application code doesn't need this pair of functions.
```

---

### Type information: `g_object_get_type` and related

```nim
proc g_object_get_type*(): GType
proc g_object_class_find_property*(oclass: pointer, propertyName: cstring): pointer
proc g_object_class_list_properties*(oclass: pointer, nProperties: ptr cuint): ptr pointer
```

**What it does.** `g_object_get_type` returns `GType` — the numeric type identifier of `GObject` in GLib's type system (the base type from which all other GObject classes inherit; similar `_get_type` functions exist for almost every GTK class, e.g. `gtk_button_get_type`, though not defined separately in this wrapper for each widget). `g_object_class_find_property`/`g_object_class_list_properties` are introspection functions: finding the description of a specific class property and getting the full list of all properties of a class from a class object (`GObjectClass*`, obtained via separate type-system functions not covered in this wrapper) — used when writing generic object-inspection code (for example, automatically building an editing form from the list of properties of an arbitrary object), not for everyday work with specific known widgets.

- `oclass` — a pointer to the class structure.
- `propertyName` — the property name (for `find_property`).
- `nProperties` — a pointer into which the number of properties found will be written (for `list_properties`).

```nim
echo "GType of the base GObject class: ", g_object_get_type()
```

---

### Creating objects: `g_object_new` / `g_object_newv`

```nim
proc g_object_new*(objectType: GType, firstPropertyName: cstring): gpointer {.varargs.}
proc g_object_newv*(objectType: GType, nParameters: cuint, parameters: pointer): gpointer
```

**What it does.** Creates a new instance of a GObject class from its `GType`, setting some properties immediately through the constructor — a universal low-level way to create an object, underlying how all specialized constructors like `gtk_button_new`/`gtk_window_new` from previous references work under the hood. `g_object_new` accepts properties as alternating (name, value) pairs in a variadic list terminated by `nil` — the same protocol as `g_object_set`. `g_object_newv` is a version with an explicit array of parameters instead of a variadic list (used less often, mainly when dynamically building a list of properties at runtime whose count isn't known in advance at the time the code is written).

- **Implementation notes.** For any widget that already has a specialized constructor in this wrapper (`gtk_button_new`, `gtk_label_new`, etc.), there's no practical reason to use `g_object_new` directly — the specialized constructors are simpler, more type-safe, and cover everything application code needs; `g_object_new` is relevant for GObject classes outside GTK widgets that don't have a separate constructor in this wrapper.

- `objectType` — the `GType` of the class to create.
- `firstPropertyName`, followed by (name, value) pairs, terminated by `nil`.

```nim
# Example is illustrative only — for real GTK widgets, specialized
# constructors like gtk_button_new are preferred over calling g_object_new directly.
let obj = g_object_new(someCustomType, "some-property".cstring, 42.cint, nil)
echo "Object created directly through the GObject type system"
```

---

### Data by GQuark: `g_object_set_qdata` and related

```nim
proc g_object_set_qdata*(obj: GObject, quark: GQuark, data: gpointer)
proc g_object_get_qdata*(obj: GObject, quark: GQuark): gpointer
proc g_object_set_qdata_full*(obj: GObject, quark: GQuark, data: gpointer, destroy: pointer)
proc g_object_steal_qdata*(obj: GObject, quark: GQuark): gpointer
```

**What it does.** Functionally identical to `g_object_set_data`/`get_data`/`set_data_full`/`steal_data` (above), but uses a pre-interned `GQuark` (see the quarks subsection below) instead of a string as the key — faster for frequent access with the same key, since comparing `GQuark` integers is faster than comparing strings, but requires first obtaining the `GQuark` itself via `g_quark_from_string`. Justified in hot code paths with frequent access to attached data; for one-off or infrequent use, the difference is immaterial and the string-based variant is simpler.

- `obj` — the object.
- `quark` — the interned key identifier.
- `data` — the arbitrary data.
- `destroy` (for `set_qdata_full`) — the data cleanup function.

```nim
let contactIdQuark = g_quark_from_string("contact-id")
g_object_set_qdata(cast[GObject](contactRow), contactIdQuark, cast[gpointer](contactId))
echo "Data attached using a pre-interned key"
```

---

### Binding properties: `g_object_bind_property`

```nim
proc g_object_bind_property*(source: GObject, sourceProperty: cstring, target: GObject, targetProperty: cstring, flags: GBindingFlags): pointer
proc g_object_bind_property_full*(source: GObject, sourceProperty: cstring, target: GObject, targetProperty: cstring, flags: GBindingFlags, transformTo: pointer, transformFrom: pointer, userData: gpointer, notify: pointer): pointer
```

**What it does.** Automatically synchronizes one object's property with another's, without the need to manually connect the `"notify::property"` signal and write synchronization code yourself — for example, to have a button's sensitivity automatically follow a checkbox's state (see section VI, "Binding a button's sensitivity"). `flags` determines the mode: `G_BINDING_DEFAULT` — when `source` changes, `target` is updated; synchronization isn't performed once at the moment the binding is created. `G_BINDING_SYNC_CREATE` — additionally synchronizes `target` with `source`'s value immediately when the binding is created (used almost always together with the other flags). `G_BINDING_BIDIRECTIONAL` — synchronizes in both directions, not only from `source` to `target`. `G_BINDING_INVERT_BOOLEAN` — for boolean properties, inverts the value during synchronization (`target` gets `not source`). `g_object_bind_property_full` is an extended variant with custom conversion functions between incompatible property types (`transformTo`/`transformFrom`) — the plain `bind_property` only works when both properties are the same type or GTK knows how to convert them automatically (e.g. `gint`↔`gdouble`).

- `source`, `target` — the objects being bound.
- `sourceProperty`, `targetProperty` — the property names.
- `flags` — the `GBindingFlags` bitmask.

```nim
discard g_object_bind_property(cast[GObject](enableFeatureCheck), "active",
                                cast[GObject](featureOptionsBox), "sensitive",
                                G_BINDING_SYNC_CREATE)
echo "The feature options area automatically enables/disables along with the checkbox"
```

---

### `g_quark_from_string` / `g_quark_to_string` / `g_quark_try_string`

```nim
proc g_quark_from_string*(str: cstring): GQuark
proc g_quark_to_string*(quark: GQuark): cstring
proc g_quark_try_string*(str: cstring): GQuark
```

**What it does.** `GQuark` is an integer identifier corresponding one-to-one to a string "interned" (registered) in GLib's global table once for the lifetime of the process — used instead of strings where comparison speed matters (see `g_object_set_qdata` above, as well as `GError` domains, which aren't covered separately in this reference). `g_quark_from_string` returns the existing `GQuark` for a string if it has already been interned somewhere earlier in the process, or creates a new entry — it can be called repeatedly with the same string, always returning the same numeric identifier. `g_quark_to_string` is the reverse operation. `g_quark_try_string` differs from `from_string` in that it **does not create** a new entry if the string hasn't been interned yet, returning `0` instead — useful when you only need to check whether the string has been seen before, without creating a new entry needlessly.

- `str` — the string.
- `quark` — the `GQuark` identifier.

```nim
let quark1 = g_quark_from_string("contact-id")
let quark2 = g_quark_from_string("contact-id")
echo "Both calls returned the same identifier: ", quark1 == quark2  # prints "true"
```

---

## Practical recipes

### A simple drawing on GtkDrawingArea via Cairo

A minimal drawing area that paints itself with a background and draws a circle — this only shows where Cairo code fits in, without going into the Cairo API itself in detail.

```nim
proc onDrawCircle(area: GtkDrawingArea, cr: pointer, width: gint, height: gint, userData: gpointer) {.cdecl.} =
  # cairo_* functions are used here to draw into the cr context:
  # cairo_set_source_rgb(cr, ...), cairo_arc(cr, ...), cairo_fill(cr), etc.
  echo "Drawing a circle in an area of ", width, "×", height

proc buildSimpleCanvas(): GtkDrawingArea =
  result = gtk_drawing_area_new()
  gtk_drawing_area_set_content_width(result, 200)
  gtk_drawing_area_set_content_height(result, 200)
  gtk_drawing_area_set_draw_func(result, onDrawCircle, nil, nil)
  echo "200×200 canvas with a circle-drawing function is ready"

let canvas = buildSimpleCanvas()
```

---

### Loading a global application CSS theme

A typical place to load CSS is right after GTK initialization, before the first window is shown, so that styles are applied immediately to all subsequently created widgets.

```nim
proc loadApplicationTheme() =
  let provider = gtk_css_provider_new()
  gtk_css_provider_load_from_path(provider, "/usr/share/myapp/theme.css")
  let display = gdk_display_get_default()
  gtk_style_context_add_provider_for_display(display, cast[pointer](provider), 600)
  echo "Global application theme loaded and applied to all windows"

proc onActivate(app: GtkApplication, userData: gpointer) {.cdecl.} =
  loadApplicationTheme()
  # ... creating the main window ...
```

---

### Binding a button's sensitivity to a checkbox state without a single line of handler code

`g_object_bind_property` replaces manually connecting the `"toggled"` signal and writing a synchronization handler.

```nim
proc buildAutoLinkedControls(): GtkBox =
  result = gtk_box_new(GTK_ORIENTATION_VERTICAL, 8)

  let enableCheck = gtk_check_button_new_with_label("Enable email notifications")
  let emailEntry = gtk_entry_new()
  gtk_entry_set_placeholder_text(emailEntry, "you@example.com")

  discard g_object_bind_property(cast[GObject](enableCheck), "active",
                                  cast[GObject](emailEntry), "sensitive",
                                  G_BINDING_SYNC_CREATE)

  gtk_box_append(result, enableCheck)
  gtk_box_append(result, emailEntry)
  echo "The email field is automatically enabled only when the checkbox is on — no manual handler"

let notificationSettings = buildAutoLinkedControls()
```

---

### Attaching custom data to a widget by string key

A contact-list row stores the database record ID, retrieved later in a click handler.

```nim
proc buildContactRow(contactId: int, name: string): GtkWidget =
  result = gtk_label_new(name.cstring)
  g_object_set_data(cast[GObject](result), "contact-id", cast[gpointer](contactId))

proc onRowActivated(box: GtkListBox, row: GtkListBoxRow, userData: gpointer) {.cdecl.} =
  let rowChild = gtk_list_box_row_get_child(row)
  let storedId = g_object_get_data(cast[GObject](rowChild), "contact-id")
  echo "Row activated with attached contact id: ", cast[int](storedId)

let contactsList = gtk_list_box_new()
gtk_list_box_append(contactsList, buildContactRow(42, "Anna Ivanova"))
discard g_signal_connect(contactsList, "row-activated", onRowActivated, nil)
```

---

### Passing a composite value via GVariant to an action handler

An action with a parameter (for example, toggling a display mode), where the selected variant is passed as a string `GVariant`.

```nim
proc onSetViewMode(action: pointer, parameter: GVariant, userData: gpointer) {.cdecl.} =
  let mode = $g_variant_get_string(parameter, nil)
  echo "Switching display mode to: ", mode

# The action itself is registered via g_action_map_add_action (see the ACTIONS
# reference); only reading the parameter passed via GVariant is shown here.

let gridModeTarget = g_variant_new_string("grid")
gtk_actionable_set_action_target_value(gridViewButton, gridModeTarget)
echo "Grid-view button passes the string parameter 'grid' to the action"
```

---

## Quick reference table

| Procedure(s) | Category | What it does, briefly |
|---|---|---|
| `gtk_drawing_area_new` | DrawingArea | Create an empty canvas |
| `gtk_drawing_area_set/get_content_width/height` | DrawingArea | Preferred content size |
| `gtk_drawing_area_set_draw_func` | DrawingArea | Assign a Cairo drawing function |
| `gtk_css_provider_new` | CssProvider | Create a style provider |
| `gtk_css_provider_load_from_data/file/path/string` | CssProvider | Load CSS from various sources |
| `gtk_widget_get_style_context`, `gtk_style_context_add_provider` | StyleContext | Apply styles to a single widget and its descendants |
| `gtk_style_context_add_provider_for_display`, `gtk_widget_get_display`, `gdk_display_get_default` | StyleContext/Display | Apply styles globally to all windows of a display |
| `g_file_new_for_path`, `get_path`, `get_basename` | GFile | Create a file object from a path / read the path and name |
| `g_error_free` | GError | Free an error object |
| `g_variant_new_string/boolean/int32` | GVariant | Wrap a value in a typed container |
| `g_variant_get_string/boolean/int32` | GVariant | Extract the value back out |
| `g_object_ref`, `unref`, `ref_sink`, `is_floating`, `force_floating` | GObject | Reference counting and floating state |
| `g_object_set`, `get` | GObject | Several properties by name in one call |
| `g_object_set/get_property` | GObject | A single property via GValue |
| `g_object_notify`, `notify_by_pspec`, `freeze/thaw_notify` | GObject | Property change notifications |
| `g_object_set/get_data`, `set_data_full`, `steal_data` | GObject | Arbitrary data by string key |
| `g_object_weak_ref/unref`, `add/remove_weak_pointer` | GObject | Tracking object destruction without owning it |
| `g_object_add/remove_toggle_ref` | GObject | Specialized synchronization for language bindings |
| `g_object_get_type`, `class_find_property`, `class_list_properties` | GObject | Type introspection and its properties |
| `g_object_new`, `newv` | GObject | Low-level object creation by GType |
| `g_object_set/get_qdata`, `set_qdata_full`, `steal_qdata` | GObject | Arbitrary data by GQuark (faster than strings) |
| `g_object_bind_property`, `bind_property_full` | GObject | Automatic synchronization of two objects' properties |
| `g_quark_from_string`, `to_string`, `try_string` | GObject | Interned string identifiers |

---

## Summary: which procedure to choose

- **Custom graphics that can't be expressed with ready-made widgets** (charts, custom visualizations, a game board) → `GtkDrawingArea` + `gtk_drawing_area_set_draw_func`, rather than trying to assemble the desired look from a combination of existing widgets.
- **Style a single specific widget** (and its descendants) → `gtk_widget_get_style_context` + `gtk_style_context_add_provider`. **Style the whole application** (a shared theme) → `gtk_style_context_add_provider_for_display`, called once at application startup, rather than repeating the first approach manually for every window.
- **A widget property that already has a type-safe `set_X`/`get_X` pair in this wrapper** → always prefer that pair. **A property with no specialized pair** (rare properties or ones specific to particular GTK versions) → `g_object_set`/`get` by string name as a fallback.
- **Need to keep the state of two widgets in sync** (sensitivity, visibility, a value) → `g_object_bind_property` instead of manually connecting the `"notify::..."` signal and writing synchronization code — especially if the synchronization needs to be bidirectional (`G_BINDING_BIDIRECTIONAL`) or invert a boolean value (`G_BINDING_INVERT_BOOLEAN`).
- **Attach extra application data to an existing widget** → `g_object_set_data`/`get_data` for one-off/infrequent use with a clear string key; `g_object_set_qdata`/`get_qdata` with a pre-obtained `GQuark` if the same key is used very frequently and comparison speed matters.
- **Need to know when an object will be destroyed without owning it yourself** (without preventing its destruction) → `g_object_add_weak_pointer` for the simple "zero out a variable" case; `g_object_weak_ref` if you need arbitrary logic at the moment of destruction, not just nulling a pointer.
- **A widget is created and immediately added to a container the usual way** → manually managing the reference count (`g_object_ref`/`unref`) isn't required — the container itself will sink the floating reference. Manual management is only needed when an object needs to outlive a temporary absence of its owning container.
