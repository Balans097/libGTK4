# GTK4 (core: Init / Application / Window / Widget / Box / Grid) — module reference

> **Import:** `import libGTK4`
> **Scope:** a direct FFI wrapper over GTK4 (via `{.importc.}`) for building desktop GUI applications on Linux and Windows — windows, widgets, layout, application lifecycle.

This reference covers the foundational layer of the wrapper: how every GTK4 application begins (library initialization, `GtkApplication`/`GApplication`, `GtkWindow`), the base interface shared by all widgets (`GtkWidget`), and the two most commonly used layout containers — `GtkBox` and `GtkGrid`. Other widgets (buttons, entry fields, lists, etc.) are covered in separate references in the same series.

General conventions of the module:
— all functions are direct C bindings via `{.importc.}`, so they are called in prefix form: `gtk_widget_show(w)`, not `w.gtk_widget_show()`;
— almost every widget property is represented by a `get_X` / `set_X` procedure pair — in this reference such a pair is covered under a single subsection;
— pointers to GTK/GLib objects (`GtkWidget`, `GtkWindow`, `GApplication`, etc.) in this wrapper are opaque `pointer` aliases; type safety at the Nim level is limited to the type name — the actual type checking is done by GTK itself at runtime;
— `gboolean` is a `cint` (0/1), not a native Nim `bool`; to pass a boolean value use `1.gboolean`/`0.gboolean`, or write your own converter (see section IV, `gtk_widget_set_visible`).

---

## Table of Contents

I. [GTK Initialization and Version](#initialization-and-gtk-version)
&nbsp;&nbsp;1. [`gtk_init` / `gtk_init_check`](#gtk_init--gtk_init_check)
&nbsp;&nbsp;2. [`gtk_is_initialized`](#gtk_is_initialized)
&nbsp;&nbsp;3. [`gtk_get_major_version` / `gtk_get_minor_version` / `gtk_get_micro_version`](#gtk_get_major_version--gtk_get_minor_version--gtk_get_micro_version)
&nbsp;&nbsp;4. [`gtk_check_version`](#gtk_check_version)
&nbsp;&nbsp;5. [`gtk_get_binary_age` / `gtk_get_interface_age`](#gtk_get_binary_age--gtk_get_interface_age)
&nbsp;&nbsp;6. [`gtk_get_locale_direction`](#gtk_get_locale_direction)
&nbsp;&nbsp;7. [`gtk_get_default_language`](#gtk_get_default_language)
&nbsp;&nbsp;8. [`gtk_disable_setlocale`](#gtk_disable_setlocale)
&nbsp;&nbsp;9. [`gtk_set_debug_flags` / `gtk_get_debug_flags`](#gtk_set_debug_flags--gtk_get_debug_flags)

II. [GtkApplication and GApplication](#gtkapplication-and-gapplication)
&nbsp;&nbsp;1. [`gtk_application_new`](#gtk_application_new)
&nbsp;&nbsp;2. [`g_signal_connect` (reference for this section's examples)](#g_signal_connect-reference-for-this-sections-examples)
&nbsp;&nbsp;3. [`g_application_run`](#g_application_run)
&nbsp;&nbsp;4. [`gtk_application_window_new`](#gtk_application_window_new)
&nbsp;&nbsp;5. [`gtk_application_add_window` / `gtk_application_remove_window`](#gtk_application_add_window--gtk_application_remove_window)
&nbsp;&nbsp;6. [`gtk_application_get_windows` / `gtk_application_get_active_window`](#gtk_application_get_windows--gtk_application_get_active_window)
&nbsp;&nbsp;7. [`gtk_application_get_window_by_id`](#gtk_application_get_window_by_id)
&nbsp;&nbsp;8. [`gtk_application_set_menubar` / `gtk_application_get_menubar`](#gtk_application_set_menubar--gtk_application_get_menubar)
&nbsp;&nbsp;9. [`gtk_application_get_menu_by_id`](#gtk_application_get_menu_by_id)
&nbsp;&nbsp;10. [`gtk_application_set_accels_for_action` / `gtk_application_get_accels_for_action`](#gtk_application_set_accels_for_action--gtk_application_get_accels_for_action)
&nbsp;&nbsp;11. [`gtk_application_list_action_descriptions`](#gtk_application_list_action_descriptions)
&nbsp;&nbsp;12. [`gtk_application_inhibit` / `gtk_application_uninhibit`](#gtk_application_inhibit--gtk_application_uninhibit)
&nbsp;&nbsp;13. [`g_application_activate` / `g_application_quit`](#g_application_activate--g_application_quit)
&nbsp;&nbsp;14. [`g_application_hold` / `g_application_release`](#g_application_hold--g_application_release)
&nbsp;&nbsp;15. [`g_application_register` / `g_application_get_is_registered` / `g_application_get_is_remote`](#g_application_register--g_application_get_is_registered--g_application_get_is_remote)
&nbsp;&nbsp;16. [`g_application_get_application_id` / `g_application_set_application_id`](#g_application_get_application_id--g_application_set_application_id)
&nbsp;&nbsp;17. [`g_application_get_flags` / `g_application_set_flags`](#g_application_get_flags--g_application_set_flags)
&nbsp;&nbsp;18. [`g_application_get_inactivity_timeout` / `g_application_set_inactivity_timeout`](#g_application_get_inactivity_timeout--g_application_set_inactivity_timeout)
&nbsp;&nbsp;19. [`g_application_open`](#g_application_open)
&nbsp;&nbsp;20. [`g_application_mark_busy` / `g_application_unmark_busy` / `g_application_get_is_busy`](#g_application_mark_busy--g_application_unmark_busy--g_application_get_is_busy)
&nbsp;&nbsp;21. [`g_application_send_notification` / `g_application_withdraw_notification`](#g_application_send_notification--g_application_withdraw_notification)
&nbsp;&nbsp;22. [`g_application_set_resource_base_path` / `g_application_get_resource_base_path`](#g_application_set_resource_base_path--g_application_get_resource_base_path)

III. [GtkWindow](#gtkwindow)
&nbsp;&nbsp;1. [`gtk_window_new`](#gtk_window_new)
&nbsp;&nbsp;2. [`gtk_window_set_title` / `gtk_window_get_title`](#gtk_window_set_title--gtk_window_get_title)
&nbsp;&nbsp;3. [`gtk_window_set_default_size` / `gtk_window_get_default_size`](#gtk_window_set_default_size--gtk_window_get_default_size)
&nbsp;&nbsp;4. [`gtk_window_set_resizable` / `gtk_window_get_resizable`](#gtk_window_set_resizable--gtk_window_get_resizable)
&nbsp;&nbsp;5. [`gtk_window_set_modal` / `gtk_window_get_modal`](#gtk_window_set_modal--gtk_window_get_modal)
&nbsp;&nbsp;6. [`gtk_window_set_decorated` / `gtk_window_get_decorated`](#gtk_window_set_decorated--gtk_window_get_decorated)
&nbsp;&nbsp;7. [`gtk_window_set_deletable` / `gtk_window_get_deletable`](#gtk_window_set_deletable--gtk_window_get_deletable)
&nbsp;&nbsp;8. [`gtk_window_set_transient_for` / `gtk_window_get_transient_for`](#gtk_window_set_transient_for--gtk_window_get_transient_for)
&nbsp;&nbsp;9. [`gtk_window_set_child` / `gtk_window_get_child`](#gtk_window_set_child--gtk_window_get_child)
&nbsp;&nbsp;10. [`gtk_window_set_titlebar` / `gtk_window_get_titlebar`](#gtk_window_set_titlebar--gtk_window_get_titlebar)
&nbsp;&nbsp;11. [`gtk_window_close` / `gtk_window_destroy`](#gtk_window_close--gtk_window_destroy)
&nbsp;&nbsp;12. [`gtk_window_present`](#gtk_window_present)
&nbsp;&nbsp;13. [`gtk_window_fullscreen` / `gtk_window_unfullscreen` / `gtk_window_is_fullscreen`](#gtk_window_fullscreen--gtk_window_unfullscreen--gtk_window_is_fullscreen)
&nbsp;&nbsp;14. [`gtk_window_maximize` / `gtk_window_unmaximize`](#gtk_window_maximize--gtk_window_unmaximize)
&nbsp;&nbsp;15. [`gtk_window_minimize` / `gtk_window_unminimize`](#gtk_window_minimize--gtk_window_unminimize)
&nbsp;&nbsp;16. [`gtk_window_set_icon_name` / `gtk_window_set_default_icon_name`](#gtk_window_set_icon_name--gtk_window_set_default_icon_name)

IV. [GtkWidget (base interface for all widgets)](#gtkwidget-base-interface-for-all-widgets)
&nbsp;&nbsp;1. [`gtk_widget_show` / `gtk_widget_hide` / `gtk_widget_set_visible` / `gtk_widget_get_visible`](#gtk_widget_show--gtk_widget_hide--gtk_widget_set_visible--gtk_widget_get_visible)
&nbsp;&nbsp;2. [`gtk_widget_set_sensitive` / `gtk_widget_get_sensitive`](#gtk_widget_set_sensitive--gtk_widget_get_sensitive)
&nbsp;&nbsp;3. [`gtk_widget_set_can_focus` / `gtk_widget_get_can_focus` / `gtk_widget_grab_focus`](#gtk_widget_set_can_focus--gtk_widget_get_can_focus--gtk_widget_grab_focus)
&nbsp;&nbsp;4. [`gtk_widget_set_size_request` / `gtk_widget_get_size_request`](#gtk_widget_set_size_request--gtk_widget_get_size_request)
&nbsp;&nbsp;5. [`gtk_widget_set_hexpand` / `gtk_widget_get_hexpand` / `gtk_widget_set_vexpand` / `gtk_widget_get_vexpand`](#gtk_widget_set_hexpand--gtk_widget_get_hexpand--gtk_widget_set_vexpand--gtk_widget_get_vexpand)
&nbsp;&nbsp;6. [`gtk_widget_set_halign` / `gtk_widget_get_halign` / `gtk_widget_set_valign` / `gtk_widget_get_valign`](#gtk_widget_set_halign--gtk_widget_get_halign--gtk_widget_set_valign--gtk_widget_get_valign)
&nbsp;&nbsp;7. [`gtk_widget_set_margin_start` / `_end` / `_top` / `_bottom` (and getters)](#gtk_widget_set_margin_start--_end--_top--_bottom-and-getters)
&nbsp;&nbsp;8. [`gtk_widget_set_tooltip_text` / `gtk_widget_get_tooltip_text` / `gtk_widget_set_tooltip_markup` / `gtk_widget_get_tooltip_markup`](#gtk_widget_set_tooltip_text--gtk_widget_get_tooltip_text--gtk_widget_set_tooltip_markup--gtk_widget_get_tooltip_markup)
&nbsp;&nbsp;9. [`gtk_widget_set_name` / `gtk_widget_get_name`](#gtk_widget_set_name--gtk_widget_get_name)
&nbsp;&nbsp;10. [`gtk_widget_add_css_class` / `gtk_widget_remove_css_class` / `gtk_widget_has_css_class`](#gtk_widget_add_css_class--gtk_widget_remove_css_class--gtk_widget_has_css_class)
&nbsp;&nbsp;11. [`gtk_widget_get_parent` / `gtk_widget_get_first_child` / `gtk_widget_get_last_child` / `gtk_widget_get_next_sibling` / `gtk_widget_get_prev_sibling`](#gtk_widget_get_parent--gtk_widget_get_first_child--gtk_widget_get_last_child--gtk_widget_get_next_sibling--gtk_widget_get_prev_sibling)

V. [GtkBox](#gtkbox)
&nbsp;&nbsp;1. [`gtk_box_new`](#gtk_box_new)
&nbsp;&nbsp;2. [`gtk_box_append` / `gtk_box_prepend` / `gtk_box_remove`](#gtk_box_append--gtk_box_prepend--gtk_box_remove)
&nbsp;&nbsp;3. [`gtk_box_insert_child_after` / `gtk_box_reorder_child_after`](#gtk_box_insert_child_after--gtk_box_reorder_child_after)
&nbsp;&nbsp;4. [`gtk_box_set_spacing` / `gtk_box_get_spacing`](#gtk_box_set_spacing--gtk_box_get_spacing)
&nbsp;&nbsp;5. [`gtk_box_set_homogeneous` / `gtk_box_get_homogeneous`](#gtk_box_set_homogeneous--gtk_box_get_homogeneous)
&nbsp;&nbsp;6. [`gtk_box_set_baseline_position` / `gtk_box_get_baseline_position` / `gtk_box_set_baseline_child` / `gtk_box_get_baseline_child`](#gtk_box_set_baseline_position--gtk_box_get_baseline_position--gtk_box_set_baseline_child--gtk_box_get_baseline_child)

VI. [GtkGrid](#gtkgrid)
&nbsp;&nbsp;1. [`gtk_grid_new`](#gtk_grid_new)
&nbsp;&nbsp;2. [`gtk_grid_attach` / `gtk_grid_attach_next_to`](#gtk_grid_attach--gtk_grid_attach_next_to)
&nbsp;&nbsp;3. [`gtk_grid_remove` / `gtk_grid_get_child_at`](#gtk_grid_remove--gtk_grid_get_child_at)
&nbsp;&nbsp;4. [`gtk_grid_set_row_spacing` / `gtk_grid_get_row_spacing` / `gtk_grid_set_column_spacing` / `gtk_grid_get_column_spacing`](#gtk_grid_set_row_spacing--gtk_grid_get_row_spacing--gtk_grid_set_column_spacing--gtk_grid_get_column_spacing)
&nbsp;&nbsp;5. [`gtk_grid_set_row_homogeneous` / `gtk_grid_get_row_homogeneous` / `gtk_grid_set_column_homogeneous` / `gtk_grid_get_column_homogeneous`](#gtk_grid_set_row_homogeneous--gtk_grid_get_row_homogeneous--gtk_grid_set_column_homogeneous--gtk_grid_get_column_homogeneous)
&nbsp;&nbsp;6. [`gtk_grid_insert_row` / `gtk_grid_insert_column` / `gtk_grid_remove_row` / `gtk_grid_remove_column`](#gtk_grid_insert_row--gtk_grid_insert_column--gtk_grid_remove_row--gtk_grid_remove_column)
&nbsp;&nbsp;7. [`gtk_grid_insert_next_to`](#gtk_grid_insert_next_to)
&nbsp;&nbsp;8. [`gtk_grid_query_child`](#gtk_grid_query_child)
&nbsp;&nbsp;9. [`gtk_grid_set_baseline_row` / `gtk_grid_get_baseline_row` / `gtk_grid_set_row_baseline_position` / `gtk_grid_get_row_baseline_position`](#gtk_grid_set_baseline_row--gtk_grid_get_baseline_row--gtk_grid_set_row_baseline_position--gtk_grid_get_row_baseline_position)

VII. [Practical recipes](#practical-recipes)
&nbsp;&nbsp;1. [Minimal window with a button ("Hello, GTK4")](#minimal-window-with-a-button-hello-gtk4)
&nbsp;&nbsp;2. [A labeled-field form on GtkGrid](#a-labeled-field-form-on-gtkgrid)
&nbsp;&nbsp;3. [A GtkBox toolbar with a stretching spacer](#a-gtkbox-toolbar-with-a-stretching-spacer)
&nbsp;&nbsp;4. [Window-close confirmation dialog](#window-close-confirmation-dialog)
&nbsp;&nbsp;5. [Traversing the widget tree via `get_first_child`/`get_next_sibling`](#traversing-the-widget-tree-via-get_first_childget_next_sibling)

VIII. [Quick reference table](#quick-reference-table)

IX. [Summary: which procedure to choose](#summary-which-procedure-to-choose)

---

## Initialization and GTK version

Before creating any widgets, the GTK library must be initialized. In practice, you almost never need to call `gtk_init` manually: `gtk_application_new` (section II) initializes GTK automatically when the application is activated. Calling `gtk_init`/`gtk_init_check` directly is only needed for non-standard scenarios — for example, embedding GTK in an application without `GtkApplication`, tests, or diagnostic utilities.

### `gtk_init` / `gtk_init_check`

```nim
proc gtk_init*()
proc gtk_init_check*(): gboolean
```

**What it does.** Initializes GTK's internal state: connects to the display (X11/Wayland/Windows), parses GTK-specific command-line arguments, and sets up the locale. `gtk_init` does not report an error — if it fails to connect to a display (for example, the program is run without a graphical session), the process will be aborted by the library itself. `gtk_init_check` does the same thing but returns `0` instead of aborting if initialization fails — that is the only reason to prefer it over `gtk_init` directly.

- **Implementation note.** Both procedures are idempotent: calling either again after a successful initialization breaks nothing and simply returns immediately — this makes it safe to call `gtk_init_check` "just in case" before operations that require an initialized GTK, even if `GtkApplication` has already done so implicitly.

- No parameters — GTK4 (unlike GTK3) no longer accepts `argc`/`argv` in `gtk_init`; command-line argument parsing has moved to `GApplication`/`GOptionContext`.

```nim
# Direct initialization without GtkApplication — e.g. in a console utility
# that occasionally shows a GUI dialog.
if gtk_init_check() == 0.gboolean:
  echo "Failed to initialize GTK — no display access"
  quit(1)
echo "GTK is ready"  # prints "GTK is ready"
```

---

### `gtk_is_initialized`

```nim
proc gtk_is_initialized*(): gboolean
```

**What it does.** Reports whether GTK has already been initialized (via `gtk_init`, `gtk_init_check`, or indirectly through `GtkApplication`). Useful in library code that may be linked into either a full GTK application or invoked from an environment where GTK hasn't been brought up yet — so it doesn't re-initialize it and doesn't rely on call ordering.

- No parameters; returns a `gboolean` (`1` if initialization has already happened).

```nim
if gtk_is_initialized() == 0.gboolean:
  discard gtk_init_check()
echo "Initialization checked"  # prints "Initialization checked"
```

---

### `gtk_get_major_version` / `gtk_get_minor_version` / `gtk_get_micro_version`

```nim
proc gtk_get_major_version*(): cuint
proc gtk_get_minor_version*(): cuint
proc gtk_get_micro_version*(): cuint
```

**What it does.** Returns the version components of the GTK build the application is **actually linked against at runtime** (not the version it was compiled against). This matters on Linux, where a user may build a program against one GTK version and run it on a system with another — the minor version affects the availability of individual functions (in this reference, such functions are marked "GTK 4.8+", "GTK 4.10+", etc. where applicable).

- No parameters; each returns a `cuint`.

```nim
echo "GTK version ", gtk_get_major_version(), ".", gtk_get_minor_version(), ".", gtk_get_micro_version()
# prints something like "GTK version 4.14.5"
```

---

### `gtk_check_version`

```nim
proc gtk_check_version*(requiredMajor: cuint, requiredMinor: cuint, requiredMicro: cuint): cstring
```

**What it does.** Checks that the GTK version the application is linked against is not older than the one specified. If the version is adequate, it returns `nil` (in Nim this will be a `cstring` with a `nil` value, checkable via `isNil`). If the linked version is older than required, it returns a pointer to a human-readable string explaining the mismatch, which can be printed to the user or to a log.

- **Implementation note.** Unlike a plain three-number comparison, GTK versions are compared with the backward-compatibility policy within a single major branch (4.x) taken into account — so it's better to use this procedure rather than hand-writing a comparison like `gtk_get_minor_version() >= N`.

- `requiredMajor`, `requiredMinor`, `requiredMicro` — the minimum required version.

```nim
let versionProblem = gtk_check_version(4, 10, 0)
if isNil(versionProblem):
  echo "GTK version is adequate"
else:
  echo "Version problem: ", $versionProblem
  # prints, e.g.: "Version problem: GTK+ version too old (micro mismatch)"
```

---

### `gtk_get_binary_age` / `gtk_get_interface_age`

```nim
proc gtk_get_binary_age*(): cuint
proc gtk_get_interface_age*(): cuint
```

**What it does.** Low-level library versioning counters in libtool terms (`binary age` — how many ABI versions have passed since the last incompatible change; `interface age` — how many of those were pure additions of new functions without changing existing ones). In practice these two numbers are only needed when building packages/distributions where binary compatibility of `.so` files matters; for application code they are almost never used — prefer `gtk_get_major/minor/micro_version` and `gtk_check_version`.

- No parameters; both return `cuint`.

```nim
echo "binary age: ", gtk_get_binary_age(), ", interface age: ", gtk_get_interface_age()
# prints two numbers specific to the particular GTK build
```

---

### `gtk_get_locale_direction`

```nim
proc gtk_get_locale_direction*(): GtkTextDirection
```

**What it does.** Returns the writing direction (left-to-right or right-to-left) that GTK determined from the system's current locale (LC_MESSAGES). The value is one of the `GtkTextDirection` variants (`GTK_TEXT_DIR_LTR`, `GTK_TEXT_DIR_RTL`, `GTK_TEXT_DIR_NONE`). Used when the UI needs to explicitly adapt to RTL locales (Arabic, Hebrew) — for example, to manually mirror a non-standard widget that doesn't inherit direction automatically.

- No parameters.

```nim
case gtk_get_locale_direction()
of GTK_TEXT_DIR_RTL:
  echo "The locale requires right-to-left writing"
of GTK_TEXT_DIR_LTR:
  echo "The locale requires left-to-right writing"  # prints this in most locales
else:
  echo "Direction is undetermined"
```

---

### `gtk_get_default_language`

```nim
proc gtk_get_default_language*(): pointer  # PangoLanguage
```

**What it does.** Returns the default language (a Pango `PangoLanguage*`, represented in this wrapper as an opaque `pointer`), computed from the current locale. Used primarily for passing to Pango functions responsible for font selection and language-specific line-breaking rules (e.g. when working with `PangoAttrList`) — it has no standalone value for typical GTK code that works with widgets directly.

- No parameters; the result is an opaque `pointer` to a `PangoLanguage`, intended for passing into Pango's API rather than being read directly.

```nim
let lang = gtk_get_default_language()
echo "Pointer to the default language obtained: ", not isNil(lang)
# prints "Pointer to the default language obtained: true"
```

---

### `gtk_disable_setlocale`

```nim
proc gtk_disable_setlocale*()
```

**What it does.** Prevents GTK from calling `setlocale(LC_ALL, "")` itself during initialization. By default GTK does this on its own, picking up the locale from environment variables; calling this procedure **before** `gtk_init`/`gtk_init_check` is only needed if the application wants to fully control the locale itself (for example, to force operation in the `C` locale regardless of the user's environment).

- No parameters. Must be called strictly before GTK initialization — it has no effect afterward.

```nim
gtk_disable_setlocale()  # GTK will not touch the process locale
discard gtk_init_check()
echo "GTK initialized with an application-controlled locale"
```

---

### `gtk_set_debug_flags` / `gtk_get_debug_flags`

```nim
proc gtk_set_debug_flags*(flags: cuint)
proc gtk_get_debug_flags*(): cuint
```

**What it does.** Set and read GTK's debug-flag bitmask (the same ones set via the `GTK_DEBUG` environment variable) — verbose logging of layout, rendering, theme-interaction operations, and so on. The flags are meant for debugging GTK itself and its interaction with the system, not application logic; the specific bit values are not given a separate enum type in this wrapper — when needed, check them against the `GTK_DEBUG_*` values from the GTK headers and pass them as "magic numbers" through `cuint`.

- `flags` — the bitmask (`cuint`) to set.

```nim
let currentFlags = gtk_get_debug_flags()
echo "Current GTK debug flags: ", currentFlags
# prints "Current GTK debug flags: 0" when GTK_DEBUG is not set in the environment
```

---

## GtkApplication and GApplication

`GtkApplication` is the entry point for any GTK4 application: it encapsulates the main event loop, D-Bus registration (for "single instance" application launching), menus, and global keyboard shortcuts. `GtkApplication` inherits `GApplication` from GIO, so part of its functionality (startup, flags, registration, busy state) goes through `g_application_*` procedures, while the GUI-specific part (windows, menus, accelerators) goes through `gtk_application_*`. The examples in this section use `g_signal_connect` (signals are covered in detail in a separate reference) — a minimal reference for it is given below so the examples are self-contained.

### `gtk_application_new`

```nim
proc gtk_application_new*(applicationId: cstring, flags: gint): GtkApplication
```

**What it does.** Creates an application object. `applicationId` is a unique identifier in reverse-DNS format (e.g. `"org.example.MyApp"`), used for D-Bus registration and for detecting an "already running" instance. Creating a `GtkApplication` by itself shows no windows and does not initialize GTK — the real work only begins inside the `"activate"` signal handler, which is invoked later, when the main loop starts via `g_application_run`.

- **Implementation note.** `applicationId` can be an empty string (`""`) — the application will then be anonymous (no D-Bus registration and no protection against being launched twice); this is convenient for tests and utilities but not recommended for real applications.

- `applicationId: cstring` — the application identifier in reverse-DNS style, or an empty string.
- `flags: gint` — a bitmask of `GApplicationFlags` values (e.g. `G_APPLICATION_DEFAULT_FLAGS`, `G_APPLICATION_HANDLES_OPEN` for accepting files via the command line).

```nim
let app = gtk_application_new("org.example.HelloApp", 0)
echo "Application created: ", not isNil(app)  # prints "Application created: true"
```

---

### `g_signal_connect` (reference for this section's examples)

```nim
template g_signal_connect*(instance, signal, callback, data: untyped): untyped
```

**What it does.** Connects a handler function to a named signal of a GObject-compatible object (`GtkApplication`, `GtkWindow`, `GtkButton`, etc.). Every time the object emits this signal, GTK calls the handler. A full treatment of the signal system is in a separate reference; here only the minimum needed for the `GtkApplication`/`GtkWindow` examples is given.

- `instance` — the object that is the signal source (cast to `gpointer`).
- `signal` — the signal name as a string, e.g. `"activate"`, `"clicked"`, `"close-request"`.
- `callback` — a pointer to a C-compatible handler function; its signature depends on the specific signal.
- `data` — arbitrary user data (`gpointer`) passed to the handler as its last argument.

```nim
proc onActivate(app: GtkApplication, userData: gpointer) {.cdecl.} =
  let window = gtk_application_window_new(app)
  gtk_window_set_title(window, "Example")
  gtk_window_present(window)

let app = gtk_application_new("org.example.HelloApp", 0)
discard g_signal_connect(app, "activate", onActivate, nil)
echo "activate handler connected"  # prints "activate handler connected"
```

---

### `g_application_run`

```nim
proc g_application_run*(application: GApplication, argc: gint, argv: pointer): gint
```

**What it does.** Starts the application's main event loop and blocks execution until the application terminates (all windows are closed and no `hold()` is being held, or `g_application_quit` was called). This call is precisely what initializes GTK, registers the application with D-Bus, and ultimately emits the `"activate"` signal (or `"open"`, if files were passed and the `G_APPLICATION_HANDLES_OPEN` flag is set). The return value is the process exit code, conventionally passed to `quit()`/returned from `main`.

- **Implementation note.** `GtkApplication` is a `GApplication`, so `g_application_run` is called with it directly, without a separate "gtk" version of the function.

- `application` — the application object (`GtkApplication` works directly, no cast is needed since both are `pointer` in this wrapper).
- `argc`, `argv` — command-line arguments; if they don't need to be passed to GTK (option parsing via `GOptionContext` is not used), you can pass `0` and `nil`.

```nim
let app = gtk_application_new("org.example.HelloApp", 0)
discard g_signal_connect(app, "activate", onActivate, nil)
let exitCode = g_application_run(app, 0, nil)
echo "Application exited with code ", exitCode
# this line is only printed after all application windows have been closed
```

---

### `gtk_application_window_new`

```nim
proc gtk_application_window_new*(application: GtkApplication): GtkWindow
```

**What it does.** Creates a window bound to the application (`GtkApplicationWindow` — a `GtkWindow` subtype) and automatically registers it with the application (equivalent to a subsequent call to `gtk_application_add_window`). Such a window supports integration with the application menu and gains access to Actions registered at the application level via `g_action_map_add_action`. For most applications this is the preferred way to create the main window instead of a bare `gtk_window_new`.

- `application` — the application the window will be bound to.

```nim
proc onActivate(app: GtkApplication, userData: gpointer) {.cdecl.} =
  let window = gtk_application_window_new(app)
  gtk_window_set_title(window, "Main Window")
  gtk_window_set_default_size(window, 640, 480)
  gtk_window_present(window)
  echo "Application window created and shown"  # prints this line on activation
```

---

### `gtk_application_add_window` / `gtk_application_remove_window`

```nim
proc gtk_application_add_window*(application: GtkApplication, window: GtkWindow)
proc gtk_application_remove_window*(application: GtkApplication, window: GtkWindow)
```

**What it does.** Registers an existing window (created via a plain `gtk_window_new` rather than `gtk_application_window_new`) with the application, or unregisters it. As long as the application has at least one registered open window, the main loop (`g_application_run`) does not terminate. `gtk_application_remove_window` is rarely called manually — a window is usually automatically unregistered when it is closed.

- `application` — the application.
- `window` — the window to bind to or unbind from the application.

```nim
let extraWindow = gtk_window_new()
gtk_application_add_window(app, extraWindow)
echo "Extra window registered with the application"
gtk_application_remove_window(app, extraWindow)
echo "Extra window unregistered"
```

---

### `gtk_application_get_windows` / `gtk_application_get_active_window`

```nim
proc gtk_application_get_windows*(application: GtkApplication): pointer  # GList[GtkWindow]
proc gtk_application_get_active_window*(application: GtkApplication): GtkWindow
```

**What it does.** `gtk_application_get_windows` returns a list of all of the application's windows (as a `GList*`, an opaque `pointer` in this wrapper; iterating its elements requires the `GList`-handling functions from the GLib utilities section). `gtk_application_get_active_window` returns the window that currently has input focus (or was last active) — handy when an Action handler needs to know which window it relates to without an explicit window parameter.

- `application` — the application whose windows are being queried.

```nim
let active = gtk_application_get_active_window(app)
if not isNil(active):
  echo "Active window title: ", $gtk_window_get_title(active)
```

---

### `gtk_application_get_window_by_id`

```nim
proc gtk_application_get_window_by_id*(application: GtkApplication, id: cuint): GtkWindow
```

**What it does.** Finds a window by its numeric `GtkApplicationWindow.id` — a stable number GTK assigns to a window upon registration (unlike a pointer, it is suitable, for example, for serialization into a session file or passing via D-Bus activation). If no window with that `id` exists, returns `nil`.

- `application` — the application.
- `id` — the window's numeric identifier.

```nim
let win = gtk_application_get_window_by_id(app, 1)
echo "Window with id=1 found: ", not isNil(win)
```

---

### `gtk_application_set_menubar` / `gtk_application_get_menubar`

```nim
proc gtk_application_set_menubar*(application: GtkApplication, menubar: GMenuModel)
proc gtk_application_get_menubar*(application: GtkApplication): GMenuModel
```

**What it does.** Sets and reads the top-level application menu model (`GMenuModel`, usually built via `GtkBuilder` from an XML description, or manually via `g_menu_new`/`g_menu_append` — the MENU section in a separate reference). On Linux with certain desktop environments (GNOME) this menu is shown in the global panel rather than inside the window.

- `application` — the application.
- `menubar` — the menu model (`GMenuModel`).

```nim
# Requires a menu model already built (see the MENU/GMenu reference)
gtk_application_set_menubar(app, menuModel)
echo "Application menu set"
```

---

### `gtk_application_get_menu_by_id`

```nim
proc gtk_application_get_menu_by_id*(application: GtkApplication, id: cstring): GMenu
```

**What it does.** Finds a submenu by the `id` given via the `id=` attribute in a menu XML description loaded through `GtkBuilder`. Lets you then modify that submenu programmatically (add/remove items) after the static description has been loaded.

- `application` — the application.
- `id` — the submenu's string identifier from the `GtkBuilder` markup.

```nim
let submenu = gtk_application_get_menu_by_id(app, "file-menu")
echo "Submenu 'file-menu' found: ", not isNil(submenu)
```

---

### `gtk_application_set_accels_for_action` / `gtk_application_get_accels_for_action`

```nim
proc gtk_application_set_accels_for_action*(application: GtkApplication, detailedActionName: cstring, accels: ptr cstring)
proc gtk_application_get_accels_for_action*(application: GtkApplication, detailedActionName: cstring): ptr cstring
```

**What it does.** Assigns keyboard shortcuts (accelerators) to an application Action. `detailedActionName` is a string like `"win.close"` or `"app.quit"`. `accels` is a `NULL`-terminated array of accelerator strings in GTK format (e.g. `"<Control>q"`); to remove all accelerators from an action, pass an array containing a single `nil` element.

- **Implementation note.** The `accels` array must be built by hand in Nim as a `ptr cstring` pointing to a `cstring` array terminated with `nil` — a raw C protocol similar to `argv`; for one-off assignment it's convenient to write a small helper that builds such an array from a `seq[string]`.

- `application` — the application.
- `detailedActionName` — the action name in `"group.name"` form.
- `accels` — an array of accelerator strings, terminated by `nil`.

```nim
var accelArray = [cstring("<Control>q"), nil]
gtk_application_set_accels_for_action(app, "app.quit", addr accelArray[0])
echo "Ctrl+Q shortcut assigned to the app.quit action"
```

---

### `gtk_application_list_action_descriptions`

```nim
proc gtk_application_list_action_descriptions*(application: GtkApplication): ptr cstring
```

**What it does.** Returns a `NULL`-terminated array of all "detailed" action names (in `"group.name"` form) that have at least one accelerator assigned via `gtk_application_set_accels_for_action`. Used, for example, to build a "keyboard shortcuts" screen in an application.

- `application` — the application.

```nim
let descriptions = gtk_application_list_action_descriptions(app)
echo "List of action descriptions with accelerators obtained: ", not isNil(descriptions)
```

---

### `gtk_application_inhibit` / `gtk_application_uninhibit`

```nim
proc gtk_application_inhibit*(application: GtkApplication, window: GtkWindow, flags: GtkApplicationInhibitFlags, reason: cstring): cuint
proc gtk_application_uninhibit*(application: GtkApplication, cookie: cuint)
```

**What it does.** Asks the desktop environment to temporarily refrain from certain actions (`flags` — don't go to sleep, don't show a screensaver, don't allow session logout, etc.) — for example, while a long file export is running. `gtk_application_inhibit` returns a "cookie" (a numeric request identifier) that must be passed to `gtk_application_uninhibit` once the restriction is no longer needed; if the inhibition could not be set, it returns `0`.

- `application` — the application.
- `window` — the window on whose behalf the request is made (can be `nil`).
- `flags` — what exactly to inhibit (values of `GtkApplicationInhibitFlags`).
- `reason` — a human-readable reason the desktop environment may show to the user.
- `cookie` (for `uninhibit`) — the identifier obtained from `inhibit`.

```nim
let cookie = gtk_application_inhibit(app, mainWindow, GTK_APPLICATION_INHIBIT_IDLE, "Video export")
if cookie != 0:
  echo "Sleep mode blocked for the duration of the export"
  # ... long operation ...
  gtk_application_uninhibit(app, cookie)
  echo "Inhibition released"
```

---

### `g_application_activate` / `g_application_quit`

```nim
proc g_application_activate*(application: GApplication)
proc g_application_quit*(application: GApplication)
```

**What it does.** `g_application_activate` manually emits the `"activate"` signal — the same thing that happens automatically on first launch via `g_application_run` if the application was started without file arguments. Useful for re-activating an already-running application (for example, to bring an already-open window to the front when the program is launched again). `g_application_quit` forcibly terminates the main loop, closing all of the application's windows, regardless of how many `hold()` calls are active.

- `application` — the application.

```nim
# In an "show window" action handler — bring an already-open window to the front
g_application_activate(app)
echo "Application reactivated"
```

---

### `g_application_hold` / `g_application_release`

```nim
proc g_application_hold*(application: GApplication)
proc g_application_release*(application: GApplication)
```

**What it does.** Increments/decrements the application's internal "hold" counter. As long as the counter is above zero, the main loop does not terminate even if all windows are closed — needed for background operations without a window (e.g. a daemon application, or background sync triggered from another process via D-Bus activation).

- **Implementation note.** Every `hold()` must be paired with a subsequent `release()` — otherwise the main loop will never terminate on its own, and the process will "hang" even after all windows are closed.

- `application` — the application.

```nim
g_application_hold(app)  # the application won't quit even if all windows are closed
# ... background operation with no UI ...
g_application_release(app)  # the application can now quit normally
echo "Hold released"
```

---

### `g_application_register` / `g_application_get_is_registered` / `g_application_get_is_remote`

```nim
proc g_application_register*(application: GApplication, cancellable: pointer, error: pointer): gboolean
proc g_application_get_is_registered*(application: GApplication): gboolean
proc g_application_get_is_remote*(application: GApplication): gboolean
```

**What it does.** `g_application_register` registers the application with D-Bus manually (normally `g_application_run` does this itself; an explicit call is needed if you must check whether another instance is already running **before** starting the main loop). After registration, `g_application_get_is_remote` reports whether the application turned out to be "primary" (`false`) or another instance was found already running, in which case the current process merely forwarded a command to it and should exit (`true`). `g_application_get_is_registered` is simply a flag for whether registration happened at all.

- `application` — the application.
- `cancellable` — an operation-cancellation object (`GCancellable*`; can pass `nil`).
- `error` — a pointer to receive an error (`ptr GError`; can pass `nil` if error details aren't needed).

```nim
if g_application_register(app, nil, nil) != 0.gboolean:
  if g_application_get_is_remote(app) != 0.gboolean:
    echo "Another instance is already running — exiting the current process"
    quit(0)
  echo "This is the first (primary) instance of the application"
```

---

### `g_application_get_application_id` / `g_application_set_application_id`

```nim
proc g_application_get_application_id*(application: GApplication): cstring
proc g_application_set_application_id*(application: GApplication, applicationId: cstring)
```

**What it does.** Reads and (before the first registration) changes the application identifier initially set in `gtk_application_new`. Changing `applicationId` after the application has already been registered with D-Bus (see `g_application_register`) is meaningless and is usually an API misuse.

- `application` — the application.
- `applicationId` — the new identifier in reverse-DNS format.

```nim
echo "Current application id: ", $g_application_get_application_id(app)
# prints "Current application id: org.example.HelloApp"
```

---

### `g_application_get_flags` / `g_application_set_flags`

```nim
proc g_application_get_flags*(application: GApplication): GApplicationFlags
proc g_application_set_flags*(application: GApplication, flags: GApplicationFlags)
```

**What it does.** Reads and (also only before registration) changes the application's flags (`G_APPLICATION_HANDLES_OPEN`, `G_APPLICATION_HANDLES_COMMAND_LINE`, `G_APPLICATION_IS_SERVICE`, etc.), which determine how the application reacts to being launched again with command-line arguments.

- `application` — the application.
- `flags` — a `GApplicationFlags` bitmask.

```nim
echo "Application flags: ", g_application_get_flags(app)
```

---

### `g_application_get_inactivity_timeout` / `g_application_set_inactivity_timeout`

```nim
proc g_application_get_inactivity_timeout*(application: GApplication): cuint
proc g_application_set_inactivity_timeout*(application: GApplication, inactivityTimeout: cuint)
```

**What it does.** Set/get the idle time (in milliseconds), with no active windows and no `hold`s, after which a service application (`G_APPLICATION_IS_SERVICE`) will automatically terminate. For ordinary windowed GUI applications this setting has no practical effect — they already terminate once the last window is closed.

- `application` — the application.
- `inactivityTimeout` — the timeout in milliseconds.

```nim
g_application_set_inactivity_timeout(app, 30_000)  # quit after 30 seconds of idleness
echo "Inactivity timeout set to: ", g_application_get_inactivity_timeout(app), " ms"
```

---

### `g_application_open`

```nim
proc g_application_open*(application: GApplication, files: pointer, nFiles: gint, hint: cstring)
```

**What it does.** Asks the application to open a list of files — emits the `"open"` signal instead of `"activate"`. Only works if the application was created with the `G_APPLICATION_HANDLES_OPEN` flag. Used both when the program is first launched with files as command-line arguments, and to pass files to an already-running instance (in combination with `g_application_get_is_remote`).

- `application` — the application.
- `files` — an array of pointers to `GFile*` (conceptually `ptr UncheckedArray[GFile]`; a raw `pointer` in this wrapper).
- `nFiles` — the number of elements in `files`.
- `hint` — an arbitrary hint string passed to the `"open"` signal handler (may be an empty string).

```nim
# files must be prepared as an array of GFile* — see the GFILE reference
g_application_open(app, addr filesArray[0], gint(len(filesArray)), "")
echo "File-open request sent"
```

---

### `g_application_mark_busy` / `g_application_unmark_busy` / `g_application_get_is_busy`

```nim
proc g_application_mark_busy*(application: GApplication)
proc g_application_unmark_busy*(application: GApplication)
proc g_application_get_is_busy*(application: GApplication): gboolean
```

**What it does.** Marks the application as "busy" — GTK automatically shows a waiting cursor (hourglass/spinner) over all of the application's windows while the busy counter is greater than zero. Unlike `hold`/`release`, this only affects the visual indication, not the main loop's lifecycle. `mark_busy`/`unmark_busy` calls must be paired — the internal counter sums nested calls.

- `application` — the application.

```nim
g_application_mark_busy(app)
echo "Busy: ", g_application_get_is_busy(app) != 0.gboolean  # prints "Busy: true"
# ... long synchronous operation ...
g_application_unmark_busy(app)
echo "Busy: ", g_application_get_is_busy(app) != 0.gboolean  # prints "Busy: false"
```

---

### `g_application_send_notification` / `g_application_withdraw_notification`

```nim
proc g_application_send_notification*(application: GApplication, id: cstring, notification: pointer)  # GNotification
proc g_application_withdraw_notification*(application: GApplication, id: cstring)
```

**What it does.** Shows a system notification (in the OS tray/notification center) and withdraws a previously shown notification by its identifier. `notification` is a pre-built `GNotification` object (created and configured via `g_notification_*` functions, not covered in this reference). `id` is an arbitrary string the application makes up itself, so it can later withdraw specifically that notification or replace it with a new one sharing the same `id`.

- `application` — the application.
- `id` — the notification identifier made up by the application.
- `notification` — the `GNotification` object.

```nim
# notification is built in advance via g_notification_new/g_notification_set_body etc.
g_application_send_notification(app, "export-done", notification)
echo "Notification sent"
# ... later, if the notification needs to be removed manually ...
g_application_withdraw_notification(app, "export-done")
```

---

### `g_application_set_resource_base_path` / `g_application_get_resource_base_path`

```nim
proc g_application_set_resource_base_path*(application: GApplication, resourcePath: cstring)
proc g_application_get_resource_base_path*(application: GApplication): cstring
```

**What it does.** Set/get the base path inside compiled GResource resources (`.gresource` files, either embedded in the binary or loaded separately) from which the application looks up its icons, `GtkBuilder` markup files, and CSS by default. If not set explicitly, GTK tries to derive the path from `applicationId` by replacing dots with slashes (e.g. `org.example.HelloApp` → `/org/example/HelloApp`).

- `application` — the application.
- `resourcePath` — the path within resources, e.g. `"/org/example/HelloApp"`.

```nim
g_application_set_resource_base_path(app, "/org/example/HelloApp")
echo "Resource base path: ", $g_application_get_resource_base_path(app)
```

---
## GtkWindow

`GtkWindow` is a top-level window. In GTK4 a window almost always contains **exactly one** child widget (`gtk_window_set_child`) — to place several elements inside it, that single child widget is made a container (`GtkBox`, `GtkGrid` — sections V, VI). Unlike GTK3, GTK4 windows have no "default" size of their own on first display unless one is explicitly set — see `gtk_window_set_default_size`.

### `gtk_window_new`

```nim
proc gtk_window_new*(): GtkWindow
```

**What it does.** Creates a bare top-level window not bound to any `GtkApplication`. Valid uses are auxiliary/utility windows, or applications that don't use `GtkApplication` at all. For a typical application's main window, `gtk_application_window_new` (section II) is preferable — it comes already integrated with the application's menu and actions.

- No parameters.

```nim
let window = gtk_window_new()
gtk_window_set_title(window, "Utility Window")
gtk_window_present(window)
echo "Window created without being bound to an application"
```

---

### `gtk_window_set_title` / `gtk_window_get_title`

```nim
proc gtk_window_set_title*(window: GtkWindow, title: cstring)
proc gtk_window_get_title*(window: GtkWindow): cstring
```

**What it does.** Set/get the window title, shown in the header bar (or in the OS taskbar if the header bar is hidden — see `gtk_window_set_decorated`). If no title is set, the executable's name is used.

- `window` — the window.
- `title` — the title string.

```nim
gtk_window_set_title(window, "Project Editor")
echo "Current title: ", $gtk_window_get_title(window)
# prints "Current title: Project Editor"
```

---

### `gtk_window_set_default_size` / `gtk_window_get_default_size`

```nim
proc gtk_window_set_default_size*(window: GtkWindow, width: gint, height: gint)
proc gtk_window_get_default_size*(window: GtkWindow, width: ptr gint, height: ptr gint)
```

**What it does.** Sets the size the window will be shown with **the first time it's displayed**, provided the user hasn't already manually resized it (after the first manual resize, GTK remembers the user's size and `default_size` no longer applies). Without an explicit call to `set_default_size`, the window shrinks to the minimum size that fits its content on first display — for a window with a complex interface this usually looks wrong, so this call is nearly mandatory for main windows.

- **Implementation note.** `gtk_window_get_default_size` is not a getter for the window's "current" size (for that you need the `GtkWidget` functions that work with the actual allocation), but specifically the value that was set via `set_default_size`; a negative value (`-1`) in either parameter means "use the natural size along that axis."

- `window` — the window.
- `width`, `height` — the size in pixels (logical, not physical — accounting for HiDPI scaling), or `-1` for the natural size along the corresponding axis.

```nim
gtk_window_set_default_size(window, 800, 600)
var w, h: gint
gtk_window_get_default_size(window, addr w, addr h)
echo "Default size: ", w, "×", h  # prints "Default size: 800×600"
```

---

### `gtk_window_set_resizable` / `gtk_window_get_resizable`

```nim
proc gtk_window_set_resizable*(window: GtkWindow, resizable: gboolean)
proc gtk_window_get_resizable*(window: GtkWindow): gboolean
```

**What it does.** Allow or disallow the user from resizing the window by dragging its edges. Useful for fixed-size dialogs (e.g. an "About" window), where arbitrary resizing breaks the layout.

- `window` — the window.
- `resizable` — `1.gboolean` to allow resizing (the default), `0.gboolean` to disallow it.

```nim
gtk_window_set_resizable(aboutWindow, 0.gboolean)
echo "Resizable: ", gtk_window_get_resizable(aboutWindow) != 0.gboolean
# prints "Resizable: false"
```

---

### `gtk_window_set_modal` / `gtk_window_get_modal`

```nim
proc gtk_window_set_modal*(window: GtkWindow, modal: gboolean)
proc gtk_window_get_modal*(window: GtkWindow): gboolean
```

**What it does.** Makes a window modal relative to its parent (see `gtk_window_set_transient_for`) — while the modal window is open, interaction with the parent window is blocked. A typical use is confirmation dialogs that require an explicit response before continuing to work with the main window.

- `window` — the window.
- `modal` — `1.gboolean` for modal behavior.

```nim
gtk_window_set_transient_for(confirmDialog, mainWindow)
gtk_window_set_modal(confirmDialog, 1.gboolean)
gtk_window_present(confirmDialog)
echo "Dialog shown modally over the main window"
```

---

### `gtk_window_set_decorated` / `gtk_window_get_decorated`

```nim
proc gtk_window_set_decorated*(window: GtkWindow, setting: gboolean)
proc gtk_window_get_decorated*(window: GtkWindow): gboolean
```

**What it does.** Shows/hides the standard window frame drawn by the window manager (title, minimize/maximize/close buttons). Turning off decorations is used for fully custom windows (for example, a splash screen or a picker window styled without the standard frame) — but then the application itself is responsible for moving and closing the window.

- `window` — the window.
- `setting` — `0.gboolean` to remove the standard frame.

```nim
gtk_window_set_decorated(splashWindow, 0.gboolean)
echo "Window without decorations: ", gtk_window_get_decorated(splashWindow) == 0.gboolean
```

---

### `gtk_window_set_deletable` / `gtk_window_get_deletable`

```nim
proc gtk_window_set_deletable*(window: GtkWindow, setting: gboolean)
proc gtk_window_get_deletable*(window: GtkWindow): gboolean
```

**What it does.** Shows/hides the window's close button in the header bar (and, where applicable, a "Close" item in the window's system menu). It does not prevent the window from being closed programmatically or via `Alt+F4`/system means — it only removes the regular UI button, for cases where the application needs to force the user through its own shutdown flow.

- `window` — the window.
- `setting` — `0.gboolean` to hide the close button.

```nim
gtk_window_set_deletable(wizardWindow, 0.gboolean)
echo "Close button hidden: ", gtk_window_get_deletable(wizardWindow) == 0.gboolean
```

---

### `gtk_window_set_transient_for` / `gtk_window_get_transient_for`

```nim
proc gtk_window_set_transient_for*(window: GtkWindow, parent: GtkWindow)
proc gtk_window_get_transient_for*(window: GtkWindow): GtkWindow
```

**What it does.** Marks a window as logically subordinate to a parent window — the window manager keeps such a window above its parent, centers it relative to the parent when shown, and minimizes/restores it together with the parent. This is a required setting before `gtk_window_set_modal`: without specifying a parent, modality is meaningless (it's unclear which window to block).

- `window` — the child (e.g. dialog) window.
- `parent` — the parent window.

```nim
gtk_window_set_transient_for(settingsDialog, mainWindow)
echo "Settings dialog parent set: ", not isNil(gtk_window_get_transient_for(settingsDialog))
```

---

### `gtk_window_set_child` / `gtk_window_get_child`

```nim
proc gtk_window_set_child*(window: GtkWindow, child: GtkWidget)
proc gtk_window_get_child*(window: GtkWindow): GtkWidget
```

**What it does.** Set the window's single child widget — this is how all of a window's content is attached in GTK4 (unlike GTK3, where the window itself was a "container" that could have several children). To show several elements in a window, a layout container (`GtkBox`/`GtkGrid` from this reference, or `GtkStack`/`GtkPaned` and others from related references) is made the sole child.

- `window` — the window.
- `child` — the widget that will become the window's content (passing `nil` removes the current content).

```nim
let root = gtk_box_new(GTK_ORIENTATION_VERTICAL, 8)
gtk_window_set_child(window, root)
echo "Root container set as the window's content: ", gtk_window_get_child(window) == root
```

---

### `gtk_window_set_titlebar` / `gtk_window_get_titlebar`

```nim
proc gtk_window_set_titlebar*(window: GtkWindow, titlebar: GtkWidget)
proc gtk_window_get_titlebar*(window: GtkWindow): GtkWidget
```

**What it does.** Replaces the window's standard header bar with an arbitrary widget — typically a `GtkHeaderBar` (separate reference), into which buttons, mode switches, a search field, etc. can be placed directly in the window's header, instead of a plain title string.

- `window` — the window.
- `titlebar` — the widget that will become the header bar (most often `GtkHeaderBar`).

```nim
# headerBar is built beforehand via gtk_header_bar_new and configured separately
gtk_window_set_titlebar(window, headerBar)
echo "Custom header bar set"
```

---

### `gtk_window_close` / `gtk_window_destroy`

```nim
proc gtk_window_close*(window: GtkWindow)
proc gtk_window_destroy*(window: GtkWindow)
```

**What it does.** `gtk_window_close` initiates the normal closing of a window — the same as if the user had clicked the system close button: first the `"close-request"` signal is emitted, and if no handler returns "stop the close," the window is destroyed. `gtk_window_destroy` destroys the window immediately, without emitting `"close-request"` — handlers that could prevent the close (e.g. a "save changes?" dialog) are not invoked in this case.

- **Implementation note.** To react to the user's *attempt* to close a window (not just a programmatic close), you need to connect specifically to the `"close-request"` signal, rather than trying to intercept the `gtk_window_close` call itself.

- `window` — the window to close.

```nim
proc onCloseRequest(win: GtkWindow, userData: gpointer): gboolean {.cdecl.} =
  echo "User is attempting to close the window"
  result = 0.gboolean  # 0 — allow the close; 1 — cancel the close

discard g_signal_connect(window, "close-request", onCloseRequest, nil)
gtk_window_close(window)  # triggers the close-request check described above
```

---

### `gtk_window_present`

```nim
proc gtk_window_present*(window: GtkWindow)
```

**What it does.** Shows the window and brings it to the front with input focus — this is the preferred way to show a window in GTK4 (as opposed to the `GtkWidget`-inherited `gtk_widget_show`, which also works but does not guarantee bringing the window above others or transferring focus). If the window is already visible, calling this again simply raises it to the front — convenient for the "re-activate an already-open window" scenario.

- `window` — the window to show/raise to the front.

```nim
gtk_window_present(window)
echo "Window shown and given focus"
```

---

### `gtk_window_fullscreen` / `gtk_window_unfullscreen` / `gtk_window_is_fullscreen`

```nim
proc gtk_window_fullscreen*(window: GtkWindow)
proc gtk_window_unfullscreen*(window: GtkWindow)
proc gtk_window_is_fullscreen*(window: GtkWindow): gboolean
```

**What it does.** Switch a window into fullscreen mode and back; `gtk_window_is_fullscreen` reports the current state. Toggling fullscreen mode is asynchronous (the request goes through the window manager/compositor) — the state returned by `is_fullscreen` may not update instantly after calling `fullscreen`, only on the next main-loop iteration; to reliably react to the actual state change, subscribe to the corresponding property-change notification (`"notify::fullscreened"`) instead of checking `is_fullscreen` right after the call.

- `window` — the window.

```nim
gtk_window_fullscreen(playerWindow)
echo "Fullscreen request sent"
# ... later, e.g. on pressing Escape ...
gtk_window_unfullscreen(playerWindow)
```

---

### `gtk_window_maximize` / `gtk_window_unmaximize`

```nim
proc gtk_window_maximize*(window: GtkWindow)
proc gtk_window_unmaximize*(window: GtkWindow)
```

**What it does.** Maximize a window to fill the screen while keeping the header bar and taskbar visible (unlike fullscreen mode), and restore the window to its previous size. As with `fullscreen`/`unfullscreen`, the change is asynchronous.

- `window` — the window.

```nim
gtk_window_maximize(window)
echo "Maximize request sent"
```

---

### `gtk_window_minimize` / `gtk_window_unminimize`

```nim
proc gtk_window_minimize*(window: GtkWindow)
proc gtk_window_unminimize*(window: GtkWindow)
```

**What it does.** Minimize a window to the taskbar and restore it back programmatically — the equivalent of the user clicking the minimize button.

- `window` — the window.

```nim
gtk_window_minimize(window)
echo "Window minimized"
# ... later, e.g. on clicking a tray icon ...
gtk_window_unminimize(window)
gtk_window_present(window)
```

---

### `gtk_window_set_icon_name` / `gtk_window_set_default_icon_name`

```nim
proc gtk_window_set_icon_name*(window: GtkWindow, name: cstring)
proc gtk_window_set_default_icon_name*(name: cstring)
```

**What it does.** `gtk_window_set_icon_name` sets a specific window's icon by name from the icon theme (`GtkIconTheme`) — used for windows that need an icon different from the application's main icon. `gtk_window_set_default_icon_name` is a static procedure (it doesn't take a window object); it sets the default icon at once for all of the application's windows that don't have an icon set explicitly. In practice, on Wayland/X11 environments with modern GNOME/KDE, a window's icon is more often determined by the application's `.desktop` file than by this call — nevertheless it's worth calling for explicitness and compatibility with environments that don't have a `.desktop` file (e.g. when running directly from a terminal during development).

- `window` (only for `set_icon_name`) — the specific window.
- `name` — the icon's name in the theme (e.g. `"applications-graphics"`, or a custom application icon name installed into the theme).

```nim
gtk_window_set_default_icon_name("org.example.HelloApp")
echo "Default icon set for all application windows"
```

---

## GtkWidget (base interface for all widgets)

`GtkWidget` is the base class for all UI elements in GTK4: windows, buttons, entry fields, containers. All procedures in this section apply to any widget object in the wrapper (in Nim this simply means the first parameter can be passed as `GtkWidget`, or cast from a more specific type — all widget types in this wrapper are `pointer` aliases, so no explicit cast is required, only passing the correct object matters).

### `gtk_widget_show` / `gtk_widget_hide` / `gtk_widget_set_visible` / `gtk_widget_get_visible`

```nim
proc gtk_widget_show*(widget: GtkWidget)
proc gtk_widget_hide*(widget: GtkWidget)
proc gtk_widget_set_visible*(widget: GtkWidget, visible: gboolean)
proc gtk_widget_get_visible*(widget: GtkWidget): gboolean
```

**What it does.** Control a widget's visibility. `gtk_widget_show`/`gtk_widget_hide` are simply convenience wrappers over `gtk_widget_set_visible(widget, 1.gboolean)`/`gtk_widget_set_visible(widget, 0.gboolean)`. It's important to distinguish visibility from presence in the widget tree: a hidden widget remains a child of its container and continues to occupy a place in the object model (it can be shown again) — it simply isn't drawn and doesn't participate in layout.

- **Implementation note.** In GTK4, widgets are visible by default immediately after creation (unlike GTK3, where you had to call `show()` on each widget manually) — an explicit `gtk_widget_show`/`set_visible(true)` is normally only needed to show a previously hidden widget again.

- `widget` — the widget.
- `visible` — `1.gboolean`/`0.gboolean`.

```nim
gtk_widget_hide(progressBar)
echo "Progress bar hidden: ", gtk_widget_get_visible(progressBar) == 0.gboolean
# ... when the operation begins ...
gtk_widget_show(progressBar)
echo "Progress bar shown: ", gtk_widget_get_visible(progressBar) != 0.gboolean
```

---

### `gtk_widget_set_sensitive` / `gtk_widget_get_sensitive`

```nim
proc gtk_widget_set_sensitive*(widget: GtkWidget, sensitive: gboolean)
proc gtk_widget_get_sensitive*(widget: GtkWidget): gboolean
```

**What it does.** Enable/disable a widget for interaction (an insensitive widget is usually rendered "grayed out" and doesn't react to clicks/input), without hiding it from view — unlike `hide`, where the widget disappears entirely. A typical scenario: a "Save" button stays disabled while the form has unresolved validation errors.

- `widget` — the widget.
- `sensitive` — `1.gboolean` to enable, `0.gboolean` to disable.

```nim
gtk_widget_set_sensitive(saveButton, 0.gboolean)
echo "'Save' button disabled: ", gtk_widget_get_sensitive(saveButton) == 0.gboolean
# ... after successful form validation ...
gtk_widget_set_sensitive(saveButton, 1.gboolean)
```

---

### `gtk_widget_set_can_focus` / `gtk_widget_get_can_focus` / `gtk_widget_grab_focus`

```nim
proc gtk_widget_set_can_focus*(widget: GtkWidget, canFocus: gboolean)
proc gtk_widget_get_can_focus*(widget: GtkWidget): gboolean
proc gtk_widget_grab_focus*(widget: GtkWidget): gboolean
```

**What it does.** `set_can_focus`/`get_can_focus` determine whether a widget is capable of accepting keyboard focus at all (for example, a plain `GtkLabel` cannot by default, while an entry field `GtkEntry` can). `gtk_widget_grab_focus` immediately requests input focus for a specific widget — e.g. so the cursor lands directly in the first form field when a dialog opens. Returns a `gboolean` reporting whether the focus grab succeeded (it can fail if the widget's `can_focus == false`, or it isn't visible/sensitive).

- `widget` — the widget.
- `canFocus` — `1.gboolean`/`0.gboolean`.

```nim
discard gtk_widget_grab_focus(usernameEntry)
echo "Input focus transferred to the username field"
```

---

### `gtk_widget_set_size_request` / `gtk_widget_get_size_request`

```nim
proc gtk_widget_set_size_request*(widget: GtkWidget, width: gint, height: gint)
proc gtk_widget_get_size_request*(widget: GtkWidget, width: ptr gint, height: ptr gint)
```

**What it does.** Set the **minimum** size that a widget requests from the layout system (not to be confused with `gtk_window_set_default_size` — that's about a window's initial size, whereas `size_request` is about an individual widget's minimum size inside any layout). The widget's actual size can still end up larger than this minimum if the parent container allocates it more room (especially with `hexpand`/`vexpand` enabled, see below), but never smaller.

- `widget` — the widget.
- `width`, `height` — the minimum size in pixels, or `-1` to not set a minimum on the corresponding axis (use the "natural" size computed by the widget itself).

```nim
gtk_widget_set_size_request(previewArea, 320, 240)
var w, h: gint
gtk_widget_get_size_request(previewArea, addr w, addr h)
echo "Preview area minimum size: ", w, "×", h
```

---

### `gtk_widget_set_hexpand` / `gtk_widget_get_hexpand` / `gtk_widget_set_vexpand` / `gtk_widget_get_vexpand`

```nim
proc gtk_widget_set_hexpand*(widget: GtkWidget, expand: gboolean)
proc gtk_widget_get_hexpand*(widget: GtkWidget): gboolean
proc gtk_widget_set_vexpand*(widget: GtkWidget, expand: gboolean)
proc gtk_widget_get_vexpand*(widget: GtkWidget): gboolean
```

**What it does.** Tell the parent container whether the widget should claim all the extra free space horizontally (`hexpand`) and/or vertically (`vexpand`) whenever the container is larger than the sum of its children's minimum sizes. Without `expand`, a widget gets exactly its minimum/natural size and "sticks" according to its alignment (`halign`/`valign`, see below), while any leftover space stays empty.

- **Implementation note.** This is the only truly reliable way to make, say, a text field inside a `GtkBox` stretch to the full available width — without `set_hexpand(true)`, the entry field will stay small even if it has `halign = GTK_ALIGN_FILL`.

- `widget` — the widget.
- `expand` — `1.gboolean`/`0.gboolean`.

```nim
gtk_widget_set_hexpand(searchEntry, 1.gboolean)  # the search field will take all available width
echo "hexpand enabled: ", gtk_widget_get_hexpand(searchEntry) != 0.gboolean
```

---

### `gtk_widget_set_halign` / `gtk_widget_get_halign` / `gtk_widget_set_valign` / `gtk_widget_get_valign`

```nim
proc gtk_widget_set_halign*(widget: GtkWidget, align: GtkAlign)
proc gtk_widget_get_halign*(widget: GtkWidget): GtkAlign
proc gtk_widget_set_valign*(widget: GtkWidget, align: GtkAlign)
proc gtk_widget_get_valign*(widget: GtkWidget): GtkAlign
```

**What it does.** Set how a widget aligns itself **within the space allocated to it**, if that space is larger than its natural size (`GTK_ALIGN_START`, `GTK_ALIGN_END`, `GTK_ALIGN_CENTER`, `GTK_ALIGN_FILL`). Works together with `hexpand`/`vexpand`: `expand` determines how much space the container will allocate to the widget, while `align` determines how the widget positions itself within that space if it's larger than the widget itself.

- `widget` — the widget.
- `align` — a `GtkAlign` value.

```nim
gtk_widget_set_halign(okButton, GTK_ALIGN_END)  # the button hugs the right edge
gtk_widget_set_valign(okButton, GTK_ALIGN_CENTER)
echo "Button alignment: halign=", gtk_widget_get_halign(okButton)
```

---

### `gtk_widget_set_margin_start` / `_end` / `_top` / `_bottom` (and getters)

```nim
proc gtk_widget_set_margin_start*(widget: GtkWidget, margin: gint)
proc gtk_widget_get_margin_start*(widget: GtkWidget): gint
proc gtk_widget_set_margin_end*(widget: GtkWidget, margin: gint)
proc gtk_widget_get_margin_end*(widget: GtkWidget): gint
proc gtk_widget_set_margin_top*(widget: GtkWidget, margin: gint)
proc gtk_widget_get_margin_top*(widget: GtkWidget): gint
proc gtk_widget_set_margin_bottom*(widget: GtkWidget, margin: gint)
proc gtk_widget_get_margin_bottom*(widget: GtkWidget): gint
```

**What it does.** Set a widget's outer margins on each of the four sides — what would be called `margin` in CSS. `start`/`end` are the logical "beginning"/"end" of the writing direction (in an LTR locale, `start` corresponds to the left edge and `end` to the right; in RTL, the other way around) rather than a fixed "left"/"right" — this lets layouts mirror correctly for RTL languages automatically (see `gtk_get_locale_direction` in section I). This wrapper has no separate "set all four margins at once" procedure — all four setters must be called individually.

- `widget` — the widget.
- `margin` — the margin in pixels.

```nim
gtk_widget_set_margin_start(formGrid, 12)
gtk_widget_set_margin_end(formGrid, 12)
gtk_widget_set_margin_top(formGrid, 12)
gtk_widget_set_margin_bottom(formGrid, 12)
echo "Form margins: ", gtk_widget_get_margin_top(formGrid), " on all sides"
```

---

### `gtk_widget_set_tooltip_text` / `gtk_widget_get_tooltip_text` / `gtk_widget_set_tooltip_markup` / `gtk_widget_get_tooltip_markup`

```nim
proc gtk_widget_set_tooltip_text*(widget: GtkWidget, text: cstring)
proc gtk_widget_get_tooltip_text*(widget: GtkWidget): cstring
proc gtk_widget_set_tooltip_markup*(widget: GtkWidget, markup: cstring)
proc gtk_widget_get_tooltip_markup*(widget: GtkWidget): cstring
```

**What it does.** Set the tooltip shown when the cursor hovers over the widget. The `_text` variant accepts plain text (`<`, `>`, `&` are escaped automatically); the `_markup` variant accepts Pango markup (`<b>`, `<i>`, `<span>`, etc.) for a formatted tooltip — there's no need to use both variants for the same widget at once; whichever setter was called last determines the resulting tooltip.

- `widget` — the widget.
- `text` — the plain-text tooltip.
- `markup` — the tooltip text with Pango markup.

```nim
gtk_widget_set_tooltip_text(deleteButton, "Permanently delete the selected item")
echo "Tooltip set: ", $gtk_widget_get_tooltip_text(deleteButton)
```

---

### `gtk_widget_set_name` / `gtk_widget_get_name`

```nim
proc gtk_widget_set_name*(widget: GtkWidget, name: cstring)
proc gtk_widget_get_name*(widget: GtkWidget): cstring
```

**What it does.** Set an application-unique widget name — used as the `#name` selector in CSS for styling a specific widget instance (as opposed to `add_css_class`, which applies a style to all widgets sharing a given class). Not to be confused with the widget's `label`/text — `name` is not shown to the user; it's a purely technical tag.

- `widget` — the widget.
- `name` — a unique name (usually `kebab-case`, as is conventional in CSS selectors).

```nim
gtk_widget_set_name(dangerButton, "danger-action-button")
echo "CSS selector #danger-action-button name set: ", $gtk_widget_get_name(dangerButton)
```

---

### `gtk_widget_add_css_class` / `gtk_widget_remove_css_class` / `gtk_widget_has_css_class`

```nim
proc gtk_widget_add_css_class*(widget: GtkWidget, cssClass: cstring)
proc gtk_widget_remove_css_class*(widget: GtkWidget, cssClass: cstring)
proc gtk_widget_has_css_class*(widget: GtkWidget, cssClass: cstring): gboolean
```

**What it does.** Manage a widget's set of CSS classes — the primary styling mechanism in GTK4 (replacing directly setting colors/fonts in code). GTK ships a number of built-in named classes with a ready-made look in the theme (e.g. `"destructive-action"` — for buttons for dangerous actions, with a red accent; `"suggested-action"` — for the primary/recommended button; `"flat"`, `"circular"`, etc.) — using these built-in classes instead of manually painting widgets gives a look consistent with the system theme.

- `widget` — the widget.
- `cssClass` — the class name without a leading dot (the dot is added automatically in terms of the `.name` CSS selector).

```nim
gtk_widget_add_css_class(deleteButton, "destructive-action")
echo "Button has destructive-action class: ", gtk_widget_has_css_class(deleteButton, "destructive-action") != 0.gboolean
gtk_widget_remove_css_class(deleteButton, "destructive-action")
```

---

### `gtk_widget_get_parent` / `gtk_widget_get_first_child` / `gtk_widget_get_last_child` / `gtk_widget_get_next_sibling` / `gtk_widget_get_prev_sibling`

```nim
proc gtk_widget_get_parent*(widget: GtkWidget): GtkWidget
proc gtk_widget_get_first_child*(widget: GtkWidget): GtkWidget
proc gtk_widget_get_last_child*(widget: GtkWidget): GtkWidget
proc gtk_widget_get_next_sibling*(widget: GtkWidget): GtkWidget
proc gtk_widget_get_prev_sibling*(widget: GtkWidget): GtkWidget
```

**What it does.** Let you traverse the widget tree manually — from a parent to its first/last child, from one widget to the next sibling in the same parent's list of children. This is a universal traversal method independent of the specific container type (in GTK4 all containers organize their children into a linked list accessible precisely through these `GtkWidget` procedures, rather than through each container type's own separate API, as was the case in GTK3). If there is no such child/sibling, the corresponding procedure returns `nil`.

- `widget` — the widget relative to which navigation is performed.

```nim
# Full traversal example — see section VII, "Traversing the widget tree"
var child = gtk_widget_get_first_child(container)
var count = 0
while not isNil(child):
  count += 1
  child = gtk_widget_get_next_sibling(child)
echo "Direct child widgets: ", count
```

---
## GtkBox

`GtkBox` is the simplest linear container: it lays out child widgets in a single row (horizontal) or a single column (vertical). It's the most common choice for toolbars, form rows, button groups — anywhere elements follow one another in a single direction. For a true multi-row, multi-column layout, `GtkGrid` is used (next section).

### `gtk_box_new`

```nim
proc gtk_box_new*(orientation: GtkOrientation, spacing: gint): GtkBox
```

**What it does.** Creates a `GtkBox` container with the given orientation and spacing between adjacent child widgets.

- `orientation` — `GTK_ORIENTATION_HORIZONTAL` or `GTK_ORIENTATION_VERTICAL`.
- `spacing` — the distance in pixels between adjacent child widgets (not to be confused with the `GtkBox`'s own outer margins — those are handled by `gtk_widget_set_margin_*` from section IV).

```nim
let toolbar = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 6)
echo "Horizontal bar with 6px spacing created"
```

---

### `gtk_box_append` / `gtk_box_prepend` / `gtk_box_remove`

```nim
proc gtk_box_append*(box: GtkBox, child: GtkWidget)
proc gtk_box_prepend*(box: GtkBox, child: GtkWidget)
proc gtk_box_remove*(box: GtkBox, child: GtkWidget)
```

**What it does.** Add a widget to the end (`append`) or beginning (`prepend`) of the container's list of children, or remove a widget from the container (`remove` — the widget itself is not destroyed, just detached; if no other references to it exist, it will be freed by GObject's reference counting). The order of `append` calls determines the left-to-right (or top-to-bottom for a vertical `GtkBox`) display order.

- `box` — the container.
- `child` — the widget to add/remove.

```nim
let box = gtk_box_new(GTK_ORIENTATION_VERTICAL, 8)
gtk_box_append(box, titleLabel)
gtk_box_append(box, descriptionLabel)
gtk_box_prepend(box, iconImage)  # ends up before titleLabel, i.e. first
echo "The container has three widgets: icon, title, description"
# ... later, if the description is no longer needed ...
gtk_box_remove(box, descriptionLabel)
```

---

### `gtk_box_insert_child_after` / `gtk_box_reorder_child_after`

```nim
proc gtk_box_insert_child_after*(box: GtkBox, child: GtkWidget, sibling: GtkWidget)
proc gtk_box_reorder_child_after*(box: GtkBox, child: GtkWidget, sibling: GtkWidget)
```

**What it does.** `insert_child_after` inserts a **new** widget `child` right after an already-present widget `sibling` in the container (if `sibling` is `nil`, the widget is inserted at the very beginning, similar to `prepend`). `reorder_child_after` changes the order of a widget `child` that is already present in the container, moving it to right after `sibling`, without removing and re-adding it.

- `box` — the container.
- `child` — the widget being inserted/moved.
- `sibling` — the widget after which `child` should end up (or `nil` for the start of the list).

```nim
gtk_box_insert_child_after(box, subtitleLabel, titleLabel)
echo "Subtitle inserted right after the title"
# Later, decided to swap the icon and the title:
gtk_box_reorder_child_after(box, iconImage, titleLabel)
echo "Icon moved to after the title"
```

---

### `gtk_box_set_spacing` / `gtk_box_get_spacing`

```nim
proc gtk_box_set_spacing*(box: GtkBox, spacing: gint)
proc gtk_box_get_spacing*(box: GtkBox): gint
```

**What it does.** Change and read the spacing between child widgets after the container has already been created (the same parameter passed to `gtk_box_new`, but changeable "on the fly" — for example, when switching between a compact and a spacious interface theme).

- `box` — the container.
- `spacing` — the spacing in pixels.

```nim
gtk_box_set_spacing(toolbar, 12)
echo "New spacing between toolbar buttons: ", gtk_box_get_spacing(toolbar)
```

---

### `gtk_box_set_homogeneous` / `gtk_box_get_homogeneous`

```nim
proc gtk_box_set_homogeneous*(box: GtkBox, homogeneous: gboolean)
proc gtk_box_get_homogeneous*(box: GtkBox): gboolean
```

**What it does.** Enables a mode where all child widgets get the **same** size along the layout axis (width for a horizontal `GtkBox`, height for a vertical one), equal to the size of the most demanding one, instead of each taking only its natural size. Handy for rows of identical buttons (e.g. "Cancel"/"OK"), where visually you want the buttons to be the same width regardless of how long the text on them is.

- `box` — the container.
- `homogeneous` — `1.gboolean` for equal-sized children.

```nim
let buttonRow = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 8)
gtk_box_set_homogeneous(buttonRow, 1.gboolean)
gtk_box_append(buttonRow, cancelButton)
gtk_box_append(buttonRow, okButton)
echo "Cancel and OK buttons are now the same width"
```

---

### `gtk_box_set_baseline_position` / `gtk_box_get_baseline_position` / `gtk_box_set_baseline_child` / `gtk_box_get_baseline_child`

```nim
proc gtk_box_set_baseline_position*(box: GtkBox, position: GtkBaselinePosition)
proc gtk_box_get_baseline_position*(box: GtkBox): GtkBaselinePosition
proc gtk_box_set_baseline_child*(box: GtkBox, child: gint)
proc gtk_box_get_baseline_child*(box: GtkBox): gint
```

**What it does.** Control text-baseline alignment — a fine-grained setting relevant when a horizontal `GtkBox` places side by side widgets with text of different font sizes (for example, a large number next to a small unit-of-measure label), and you want them to visually align "along the bottom of the letters" rather than the widget's top/bottom edge. `baseline_position` sets which edge the baseline gravitates toward when the widgets' heights aren't enough to align them naturally; `baseline_child` is the index of the specific child widget (starting at `0`) whose baseline is treated as the reference for the whole row — `-1` means "no designated reference widget."

- `box` — the container (must be horizontal — baseline alignment only makes sense for horizontal text layout).
- `position` — a `GtkBaselinePosition` value (`GTK_BASELINE_POSITION_TOP`, `_CENTER`, `_BOTTOM`).
- `child` — the index of the reference child widget, or `-1`.

```nim
let priceRow = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 4)
gtk_box_append(priceRow, bigPriceLabel)     # index 0, large font
gtk_box_append(priceRow, currencyLabel)     # index 1, small font
gtk_box_set_baseline_child(priceRow, 0)     # align to the large price's baseline
echo "Baseline reference child widget: ", gtk_box_get_baseline_child(priceRow)
```

---

## GtkGrid

`GtkGrid` is a table-style container: widgets are placed at explicit coordinates (column, row) and can span multiple cells in width/height. Unlike `GtkBox`, which only arranges elements in a single row/column, `GtkGrid` is suited for cases requiring a genuine two-dimensional layout — the classic example being a "label on the left — input field on the right" form spanning several rows.

### `gtk_grid_new`

```nim
proc gtk_grid_new*(): GtkGrid
```

**What it does.** Creates an empty table container. The number of rows and columns is not fixed in advance — the grid expands automatically as widgets are added at new coordinates via `gtk_grid_attach`.

- No parameters.

```nim
let formGrid = gtk_grid_new()
echo "Empty grid for the form created"
```

---

### `gtk_grid_attach` / `gtk_grid_attach_next_to`

```nim
proc gtk_grid_attach*(grid: GtkGrid, child: GtkWidget, column: gint, row: gint, width: gint, height: gint)
proc gtk_grid_attach_next_to*(grid: GtkGrid, child: GtkWidget, sibling: GtkWidget, side: GtkPositionType, width: gint, height: gint)
```

**What it does.** `gtk_grid_attach` places a widget at explicit coordinates (column, row — both starting at `0`), with the option of spanning it across several cells via `width`/`height` (in cells, not pixels). `gtk_grid_attach_next_to` is an alternative way of placing a widget next to an already-existing widget `sibling` in the grid, on the given `side` — convenient when exact numeric coordinates don't matter and what matters is the order relative to already-added elements (e.g. "add one more form row after the last one").

- `grid` — the grid container.
- `child` — the widget being added.
- `column`, `row` — the coordinates of the top-left cell occupied by the widget (for `attach`).
- `width`, `height` — how many columns/rows the widget spans (usually `1`, `1`).
- `sibling`, `side` (for `attach_next_to`) — the already-placed reference widget and the side (`GTK_POS_LEFT`, `GTK_POS_RIGHT`, `GTK_POS_TOP`, `GTK_POS_BOTTOM`).

```nim
let grid = gtk_grid_new()
gtk_grid_attach(grid, nameLabel, 0, 0, 1, 1)   # column 0, row 0
gtk_grid_attach(grid, nameEntry, 1, 0, 1, 1)   # column 1, row 0 — next to the label
gtk_grid_attach_next_to(grid, emailLabel, nameLabel, GTK_POS_BOTTOM, 1, 1)  # new row below nameLabel
gtk_grid_attach_next_to(grid, emailEntry, emailLabel, GTK_POS_RIGHT, 1, 1)
echo "A two-row form (Name, Email) assembled on the grid"
```

---

### `gtk_grid_remove` / `gtk_grid_get_child_at`

```nim
proc gtk_grid_remove*(grid: GtkGrid, child: GtkWidget)
proc gtk_grid_get_child_at*(grid: GtkGrid, column: gint, row: gint): GtkWidget
```

**What it does.** `gtk_grid_remove` removes a widget from the grid (similar to `gtk_box_remove` — the widget itself is not destroyed, only detached). `gtk_grid_get_child_at` finds which widget (if any) occupies the specified grid cell — returns `nil` if the cell is empty.

- `grid` — the grid container.
- `child` (for `remove`) — the widget to remove.
- `column`, `row` (for `get_child_at`) — the coordinates of the cell to query.

```nim
let widgetInCell = gtk_grid_get_child_at(grid, 1, 0)
if not isNil(widgetInCell):
  echo "Cell (1, 0) already has a widget — removing it before replacing"
  gtk_grid_remove(grid, widgetInCell)
```

---

### `gtk_grid_set_row_spacing` / `gtk_grid_get_row_spacing` / `gtk_grid_set_column_spacing` / `gtk_grid_get_column_spacing`

```nim
proc gtk_grid_set_row_spacing*(grid: GtkGrid, spacing: guint)
proc gtk_grid_get_row_spacing*(grid: GtkGrid): guint
proc gtk_grid_set_column_spacing*(grid: GtkGrid, spacing: guint)
proc gtk_grid_get_column_spacing*(grid: GtkGrid): guint
```

**What it does.** Set the spacing between rows and between columns independently of each other (unlike `GtkBox`, where there's a single spacing value since the layout is one-dimensional).

- `grid` — the grid container.
- `spacing` — the spacing in pixels.

```nim
gtk_grid_set_row_spacing(formGrid, 8)
gtk_grid_set_column_spacing(formGrid, 12)
echo "Form spacing: rows=", gtk_grid_get_row_spacing(formGrid), ", columns=", gtk_grid_get_column_spacing(formGrid)
```

---

### `gtk_grid_set_row_homogeneous` / `gtk_grid_get_row_homogeneous` / `gtk_grid_set_column_homogeneous` / `gtk_grid_get_column_homogeneous`

```nim
proc gtk_grid_set_row_homogeneous*(grid: GtkGrid, homogeneous: gboolean)
proc gtk_grid_get_row_homogeneous*(grid: GtkGrid): gboolean
proc gtk_grid_set_column_homogeneous*(grid: GtkGrid, homogeneous: gboolean)
proc gtk_grid_get_column_homogeneous*(grid: GtkGrid): gboolean
```

**What it does.** The `GtkBox`-style `set_homogeneous` counterpart, but separately for rows and columns: if enabled for columns, all columns get the same width (matching the widest content); independently for rows, the same logic applies to height.

- `grid` — the grid container.
- `homogeneous` — `1.gboolean`/`0.gboolean`.

```nim
gtk_grid_set_column_homogeneous(formGrid, 1.gboolean)  # both form columns get the same width
echo "Columns aligned by width: ", gtk_grid_get_column_homogeneous(formGrid) != 0.gboolean
```

---

### `gtk_grid_insert_row` / `gtk_grid_insert_column` / `gtk_grid_remove_row` / `gtk_grid_remove_column`

```nim
proc gtk_grid_insert_row*(grid: GtkGrid, position: gint)
proc gtk_grid_insert_column*(grid: GtkGrid, position: gint)
proc gtk_grid_remove_row*(grid: GtkGrid, position: gint)
proc gtk_grid_remove_column*(grid: GtkGrid, position: gint)
```

**What it does.** Insert a new empty row/column at the given position, shifting all subsequent rows/columns (and the widgets in them) over by one position, or remove a row/column entirely along with all the widgets that were in it (shifting subsequent ones back). Useful for dynamic forms where rows are added/removed while the program is running (for example, a list of "shipping address" fields where the user can add another address).

- `grid` — the grid container.
- `position` — the index of the row/column before which the insertion happens, or which is removed.

```nim
gtk_grid_insert_row(formGrid, 1)  # free up row 1 for a new field; everything below it shifts down
gtk_grid_attach(formGrid, phoneLabel, 0, 1, 1, 1)
gtk_grid_attach(formGrid, phoneEntry, 1, 1, 1, 1)
echo "A new 'Phone' row inserted into the form"
```

---

### `gtk_grid_insert_next_to`

```nim
proc gtk_grid_insert_next_to*(grid: GtkGrid, sibling: GtkWidget, side: GtkPositionType)
```

**What it does.** Inserts a new empty row or column (depending on `side`) next to the row/column where the widget `sibling` is located — combining the convenience of `attach_next_to` (no need to compute coordinates by hand) with the effect of `insert_row`/`insert_column` (existing widgets are shifted, not overwritten).

- `grid` — the grid container.
- `sibling` — the reference widget, already in the grid.
- `side` — which side of `sibling` to insert the new row/column on (`GTK_POS_TOP`/`_BOTTOM` insert a row, `GTK_POS_LEFT`/`_RIGHT` insert a column).

```nim
gtk_grid_insert_next_to(formGrid, emailLabel, GTK_POS_BOTTOM)
echo "New empty row inserted right below the Email row"
```

---

### `gtk_grid_query_child`

```nim
proc gtk_grid_query_child*(grid: GtkGrid, child: GtkWidget, column: ptr gint, row: ptr gint, width: ptr gint, height: ptr gint)
```

**What it does.** The reverse operation of `gtk_grid_attach`: given a widget already placed in the grid, returns its current coordinates and size in cells. Useful when a widget's position in the grid isn't stored separately in the application's logic and you need to find it out "on the fly" — for example, in an event handler where only the widget itself is known.

- `grid` — the grid container.
- `child` — the widget whose coordinates are needed.
- `column`, `row`, `width`, `height` — pointers into which the results will be written.

```nim
var col, row, w, h: gint
gtk_grid_query_child(formGrid, emailEntry, addr col, addr row, addr w, addr h)
echo "The email field is in column ", col, ", row ", row
```

---

### `gtk_grid_set_baseline_row` / `gtk_grid_get_baseline_row` / `gtk_grid_set_row_baseline_position` / `gtk_grid_get_row_baseline_position`

```nim
proc gtk_grid_set_baseline_row*(grid: GtkGrid, row: gint)
proc gtk_grid_get_baseline_row*(grid: GtkGrid): gint
proc gtk_grid_set_row_baseline_position*(grid: GtkGrid, row: gint, pos: GtkBaselinePosition)
proc gtk_grid_get_row_baseline_position*(grid: GtkGrid, row: gint): GtkBaselinePosition
```

**What it does.** The `GtkGrid` counterpart of `GtkBox`'s baseline alignment (see `gtk_box_set_baseline_position`), but applied to a grid: `baseline_row` sets which grid row overall is treated as the vertical reference, while `row_baseline_position` sets the baseline position **within a specific row** (by default each row is aligned independently). As with `GtkBox`, this is a fine typographic setting, needed only when adjacent cells in the same row contain text of different font sizes and visual "bottom of the letters" alignment matters.

- `grid` — the grid container.
- `row` — the row index.
- `pos` — a `GtkBaselinePosition` value.

```nim
gtk_grid_set_row_baseline_position(formGrid, 0, GTK_BASELINE_POSITION_CENTER)
echo "Row 0's baseline aligned to center"
```

---
## Practical recipes

### Minimal window with a button ("Hello, GTK4")

The full application lifecycle — from creating a `GtkApplication` to showing a window with a single button that changes its own label on click.

```nim
import libGTK4

proc onButtonClicked(button: GtkButton, userData: gpointer) {.cdecl.} =
  gtk_button_set_label(button, "Clicked!")
  echo "Button clicked"

proc onActivate(app: GtkApplication, userData: gpointer) {.cdecl.} =
  let window = gtk_application_window_new(app)
  gtk_window_set_title(window, "Hello, GTK4")
  gtk_window_set_default_size(window, 320, 200)

  let button = gtk_button_new_with_label("Click me")
  gtk_widget_set_halign(button, GTK_ALIGN_CENTER)
  gtk_widget_set_valign(button, GTK_ALIGN_CENTER)
  discard g_signal_connect(button, "clicked", onButtonClicked, nil)

  gtk_window_set_child(window, button)
  gtk_window_present(window)

let app = gtk_application_new("org.example.HelloApp", 0)
discard g_signal_connect(app, "activate", onActivate, nil)
let exitCode = g_application_run(app, 0, nil)
echo "Application exited with code ", exitCode
```

---

### A labeled-field form on GtkGrid

A typical "label on the left — field on the right" form spanning several rows, with stretching entry fields.

```nim
proc buildForm(): GtkGrid =
  result = gtk_grid_new()
  gtk_grid_set_row_spacing(result, 8)
  gtk_grid_set_column_spacing(result, 12)
  gtk_widget_set_margin_start(result, 16)
  gtk_widget_set_margin_end(result, 16)
  gtk_widget_set_margin_top(result, 16)
  gtk_widget_set_margin_bottom(result, 16)

  let nameLabel = gtk_label_new("Name:")
  gtk_widget_set_halign(nameLabel, GTK_ALIGN_END)
  let nameEntry = gtk_entry_new()
  gtk_widget_set_hexpand(nameEntry, 1.gboolean)
  gtk_grid_attach(result, nameLabel, 0, 0, 1, 1)
  gtk_grid_attach(result, nameEntry, 1, 0, 1, 1)

  let emailLabel = gtk_label_new("Email:")
  gtk_widget_set_halign(emailLabel, GTK_ALIGN_END)
  let emailEntry = gtk_entry_new()
  gtk_widget_set_hexpand(emailEntry, 1.gboolean)
  gtk_grid_attach_next_to(result, emailLabel, nameLabel, GTK_POS_BOTTOM, 1, 1)
  gtk_grid_attach_next_to(result, emailEntry, emailLabel, GTK_POS_RIGHT, 1, 1)

  echo "Form with two stretching fields assembled"

let form = buildForm()
```

---

### A GtkBox toolbar with a stretching spacer

The classic "buttons on the left — a button on the right" pattern on a single horizontal `GtkBox`: an empty widget with `hexpand` is inserted between the groups, claiming all the free space.

```nim
proc buildToolbar(): GtkBox =
  result = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 6)
  gtk_widget_set_margin_start(result, 8)
  gtk_widget_set_margin_end(result, 8)
  gtk_widget_set_margin_top(result, 8)
  gtk_widget_set_margin_bottom(result, 8)

  let openButton = gtk_button_new_with_label("Open")
  let saveButton = gtk_button_new_with_label("Save")
  gtk_box_append(result, openButton)
  gtk_box_append(result, saveButton)

  # "Spring" — an empty content-less container widget that claims all the free space
  let spacer = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 0)
  gtk_widget_set_hexpand(spacer, 1.gboolean)
  gtk_box_append(result, spacer)

  let settingsButton = gtk_button_new_with_label("Settings")
  gtk_widget_add_css_class(settingsButton, "flat")
  gtk_box_append(result, settingsButton)

  echo "Toolbar assembled: [Open] [Save] ... [Settings]"

let toolbar = buildToolbar()
```

---

### Window-close confirmation dialog

Intercepting a window-close attempt via `"close-request"` to show a dialog when there are unsaved changes (in this recipe the "modified" state is modeled with a plain variable).

```nim
var hasUnsavedChanges = true

proc onCloseRequest(win: GtkWindow, userData: gpointer): gboolean {.cdecl.} =
  if hasUnsavedChanges:
    echo "There are unsaved changes — showing a confirmation dialog"
    let confirmDialog = gtk_window_new()
    gtk_window_set_transient_for(confirmDialog, win)
    gtk_window_set_modal(confirmDialog, 1.gboolean)
    gtk_window_set_resizable(confirmDialog, 0.gboolean)
    gtk_window_set_title(confirmDialog, "Close without saving?")
    gtk_window_present(confirmDialog)
    result = 1.gboolean  # 1 — cancel closing the original window; the decision is left to the dialog
  else:
    result = 0.gboolean  # 0 — no unsaved data, close right away

discard g_signal_connect(mainWindow, "close-request", onCloseRequest, nil)
```

---

### Traversing the widget tree via `get_first_child`/`get_next_sibling`

A recursive traversal of an entire widget subtree starting from an arbitrary container — for example, for debug-printing the UI structure or finding all widgets of a certain CSS class.

```nim
import strutils  # for repeat() — the wrapper doesn't re-export strutils automatically

proc printWidgetTree(widget: GtkWidget, depth: int = 0) =
  echo repeat("  ", depth), "widget at depth ", depth
  var child = gtk_widget_get_first_child(widget)
  while not isNil(child):
    printWidgetTree(child, depth + 1)
    child = gtk_widget_get_next_sibling(child)

printWidgetTree(rootContainer)
# prints a tree like:
# widget at depth 0
#   widget at depth 1
#   widget at depth 1
#     widget at depth 2
```

---

## Quick reference table

| Procedure(s) | Category | What it does, in brief |
|---|---|---|
| `gtk_init`, `gtk_init_check` | Initialization | Manual GTK initialization without `GtkApplication` |
| `gtk_is_initialized` | Initialization | Whether GTK has already been initialized |
| `gtk_get_major/minor/micro_version` | Initialization | The GTK version the application is linked against |
| `gtk_check_version` | Initialization | Check the minimum required version |
| `gtk_get_binary_age`, `gtk_get_interface_age` | Initialization | ABI-compatibility counters (for packaging) |
| `gtk_get_locale_direction` | Initialization | LTR/RTL writing direction from the locale |
| `gtk_get_default_language` | Initialization | Default language for Pango |
| `gtk_disable_setlocale` | Initialization | Prevent GTK from touching the process locale |
| `gtk_set/get_debug_flags` | Initialization | GTK debug flags (`GTK_DEBUG` equivalent) |
| `gtk_application_new` | Application | Create a `GtkApplication` |
| `g_application_run` | Application | Start the main loop (blocks until termination) |
| `gtk_application_window_new` | Application | Create a window bound to the application |
| `gtk_application_add/remove_window` | Application | Manually (un)register a window with the application |
| `gtk_application_get_windows`, `get_active_window` | Application | List of windows / the active window |
| `gtk_application_get_window_by_id` | Application | Find a window by its numeric id |
| `gtk_application_set/get_menubar` | Application | Top-level application menu |
| `gtk_application_get_menu_by_id` | Application | Find a submenu by id from Builder markup |
| `gtk_application_set/get_accels_for_action` | Application | Keyboard shortcuts for an action |
| `gtk_application_list_action_descriptions` | Application | List of actions with assigned accelerators |
| `gtk_application_inhibit/uninhibit` | Application | Block sleep/session logout during an operation |
| `g_application_activate` | Application | Manually emit `"activate"` |
| `g_application_quit` | Application | Force-terminate the main loop |
| `g_application_hold/release` | Application | Prevent the loop from terminating with no open windows |
| `g_application_register` | Application | Manually register with D-Bus |
| `g_application_get_is_registered/is_remote` | Application | Is it registered / is this a repeated launch? |
| `g_application_get/set_application_id` | Application | Application identifier (before registration) |
| `g_application_get/set_flags` | Application | `GApplicationFlags` flags (before registration) |
| `g_application_get/set_inactivity_timeout` | Application | Service auto-termination timeout |
| `g_application_open` | Application | Emit `"open"` with a list of files |
| `g_application_mark/unmark_busy`, `get_is_busy` | Application | Waiting cursor over the application's windows |
| `g_application_send/withdraw_notification` | Application | System notifications |
| `g_application_set/get_resource_base_path` | Application | GResource base path |
| `gtk_window_new` | Window | Create a bare window without an application |
| `gtk_window_set/get_title` | Window | Window title |
| `gtk_window_set/get_default_size` | Window | Size on first display |
| `gtk_window_set/get_resizable` | Window | Whether the size can be changed manually |
| `gtk_window_set/get_modal` | Window | Modality relative to the parent |
| `gtk_window_set/get_decorated` | Window | Standard window frame |
| `gtk_window_set/get_deletable` | Window | Close button in the header bar |
| `gtk_window_set/get_transient_for` | Window | Parent window |
| `gtk_window_set/get_child` | Window | The single child content widget |
| `gtk_window_set/get_titlebar` | Window | Custom header bar |
| `gtk_window_close` | Window | Normal close via `"close-request"` |
| `gtk_window_destroy` | Window | Immediate destruction without confirmation request |
| `gtk_window_present` | Window | Show and bring to the front |
| `gtk_window_fullscreen/unfullscreen/is_fullscreen` | Window | Fullscreen mode |
| `gtk_window_maximize/unmaximize` | Window | Maximize to full screen (with frame) |
| `gtk_window_minimize/unminimize` | Window | Minimize to the taskbar |
| `gtk_window_set_icon_name`, `set_default_icon_name` | Window | Window icon / all application windows' icon |
| `gtk_widget_show/hide`, `set/get_visible` | Widget | Widget visibility |
| `gtk_widget_set/get_sensitive` | Widget | Availability for interaction |
| `gtk_widget_set/get_can_focus`, `grab_focus` | Widget | Ability to hold and grabbing keyboard focus |
| `gtk_widget_set/get_size_request` | Widget | Minimum widget size |
| `gtk_widget_set/get_hexpand`, `set/get_vexpand` | Widget | Stretching within the container |
| `gtk_widget_set/get_halign`, `set/get_valign` | Widget | Alignment within allocated space |
| `gtk_widget_set/get_margin_start/end/top/bottom` | Widget | Outer margins on each side |
| `gtk_widget_set/get_tooltip_text/markup` | Widget | Tooltip |
| `gtk_widget_set/get_name` | Widget | Name for the `#name` CSS selector |
| `gtk_widget_add/remove/has_css_class` | Widget | Widget CSS classes |
| `gtk_widget_get_parent/first_child/last_child/next_sibling/prev_sibling` | Widget | Widget-tree navigation |
| `gtk_box_new` | Box | Create a linear container |
| `gtk_box_append/prepend/remove` | Box | Add/remove a child widget |
| `gtk_box_insert_child_after/reorder_child_after` | Box | Insert/move relative to a neighbor |
| `gtk_box_set/get_spacing` | Box | Spacing between children |
| `gtk_box_set/get_homogeneous` | Box | Equal size for all children |
| `gtk_box_set/get_baseline_position`, `set/get_baseline_child` | Box | Text-baseline alignment |
| `gtk_grid_new` | Grid | Create a table container |
| `gtk_grid_attach`, `attach_next_to` | Grid | Place a widget by coordinates/next to a neighbor |
| `gtk_grid_remove`, `get_child_at` | Grid | Remove a widget / find a widget in a cell |
| `gtk_grid_set/get_row_spacing`, `set/get_column_spacing` | Grid | Spacing between rows/columns |
| `gtk_grid_set/get_row_homogeneous`, `set/get_column_homogeneous` | Grid | Equal size for rows/columns |
| `gtk_grid_insert/remove_row`, `insert/remove_column` | Grid | Dynamically insert/remove rows and columns |
| `gtk_grid_insert_next_to` | Grid | Insert a row/column next to a widget |
| `gtk_grid_query_child` | Grid | A widget's coordinates and size in the grid |
| `gtk_grid_set/get_baseline_row`, `set/get_row_baseline_position` | Grid | Baseline alignment within a grid |

---

## Summary: which procedure to choose

- **Need to create the application first** → `gtk_application_new`, then `g_signal_connect(app, "activate", ...)`, then `g_application_run` — not `gtk_init` directly (the latter is only for scenarios without `GtkApplication`).
- **Need to create the main window** → `gtk_application_window_new`, not a bare `gtk_window_new` — this way the window is immediately integrated with the application's menu and actions. `gtk_window_new` is for auxiliary windows and scenarios without `GtkApplication`.
- **Need the window to not shrink to a point on first display** → be sure to call `gtk_window_set_default_size`.
- **Need to show/raise a window** → `gtk_window_present`, not the `GtkWidget`-inherited `gtk_widget_show` — `present` reliably gives the window focus and raises it to the front.
- **Need to place several elements in a window** → first wrap them in a `GtkBox`/`GtkGrid`, and pass that container itself into `gtk_window_set_child` — a window accepts only one child widget.
- **Choosing between `GtkBox` and `GtkGrid`** → if the elements go strictly in a single row/column, use `GtkBox`; if you need a genuine layout across rows and columns (in particular, a "label — field" form), use `GtkGrid`.
- **A widget isn't stretching even though there's room** → almost always missing `gtk_widget_set_hexpand`/`set_vexpand` — `halign = GTK_ALIGN_FILL` alone isn't enough; `expand` determines how much space the container allocates to the widget in the first place.
- **Need to react to the user's attempt to close a window** (for example, to ask about unsaved changes) → connect to the `"close-request"` signal, rather than trying to intercept the `gtk_window_close`/`gtk_window_destroy` call itself.
- **Need to temporarily block a UI element without hiding it** → `gtk_widget_set_sensitive(widget, 0.gboolean)`, not `gtk_widget_hide` — the widget stays in place but doesn't respond to input.
- **Need to style a widget** → prefer built-in CSS classes (`gtk_widget_add_css_class`, e.g. `"destructive-action"`/`"suggested-action"`) over manual coloring — this keeps the look consistent with the system theme. `gtk_widget_set_name` is only for when you need a unique CSS selector for a specific instance.
- **Need to traverse all of a container's child widgets without being tied to a specific container type** → the universal `gtk_widget_get_first_child`/`gtk_widget_get_next_sibling` pair, which works the same way for `GtkBox`, `GtkGrid`, and any other container.
- **Need to temporarily prevent the computer from going to sleep** (for example, during a long operation) → `gtk_application_inhibit`/`gtk_application_uninhibit`, not `g_application_hold`/`release` — `hold`/`release` only control the application's main-loop lifecycle, not OS behavior.
