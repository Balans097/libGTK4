# GTK4 (containers & indicators: ScrolledWindow / Frame / Separator / Image / Spinner / ProgressBar) — module reference

> **Import:** `import libGTK4`
> **Scope:** a scrollable container, a decorative frame, a separator, an image, and two progress indicators. The fifth part of the wrapper reference series; assumes familiarity with the previous parts, especially `gtk4_core_reference_ru.md` (layout, `GtkWidget`).

This reference is more compact than the previous ones — all six widgets are small in terms of function count, but each is, in its own way, essential in nearly any application: `GtkScrolledWindow` wraps content that might not fit on screen (a list, text, a table); `GtkFrame` and `GtkSeparator` are the simplest tools for visual grouping; `GtkImage` shows a static picture or icon; `GtkSpinner` and `GtkProgressBar` are two different ways to show the user that something is happening in the background.

---

## Table of Contents

I. [GtkScrolledWindow](#gtkscrolledwindow)
&nbsp;&nbsp;1. [`gtk_scrolled_window_new`](#gtk_scrolled_window_new)
&nbsp;&nbsp;2. [`gtk_scrolled_window_set_child` / `gtk_scrolled_window_get_child`](#gtk_scrolled_window_set_child--gtk_scrolled_window_get_child)
&nbsp;&nbsp;3. [`gtk_scrolled_window_set_policy` / `gtk_scrolled_window_get_policy`](#gtk_scrolled_window_set_policy--gtk_scrolled_window_get_policy)
&nbsp;&nbsp;4. [`gtk_scrolled_window_set_has_frame` / `gtk_scrolled_window_get_has_frame`](#gtk_scrolled_window_set_has_frame--gtk_scrolled_window_get_has_frame)

II. [GtkFrame](#gtkframe)
&nbsp;&nbsp;1. [`gtk_frame_new`](#gtk_frame_new)
&nbsp;&nbsp;2. [`gtk_frame_set_label` / `gtk_frame_get_label`](#gtk_frame_set_label--gtk_frame_get_label)
&nbsp;&nbsp;3. [`gtk_frame_set_child` / `gtk_frame_get_child`](#gtk_frame_set_child--gtk_frame_get_child)
&nbsp;&nbsp;4. [`gtk_frame_set_label_widget` / `gtk_frame_get_label_widget`](#gtk_frame_set_label_widget--gtk_frame_get_label_widget)
&nbsp;&nbsp;5. [`gtk_frame_set_label_align` / `gtk_frame_get_label_align`](#gtk_frame_set_label_align--gtk_frame_get_label_align)

III. [GtkSeparator](#gtkseparator)
&nbsp;&nbsp;1. [`gtk_separator_new`](#gtk_separator_new)

IV. [GtkImage](#gtkimage)
&nbsp;&nbsp;1. [`gtk_image_new` / `gtk_image_new_from_file` / `gtk_image_new_from_icon_name` / `gtk_image_new_from_paintable`](#gtk_image_new--gtk_image_new_from_file--gtk_image_new_from_icon_name--gtk_image_new_from_paintable)
&nbsp;&nbsp;2. [`gtk_image_set_from_file` / `gtk_image_set_from_icon_name` / `gtk_image_set_from_paintable`](#gtk_image_set_from_file--gtk_image_set_from_icon_name--gtk_image_set_from_paintable)
&nbsp;&nbsp;3. [`gtk_image_get_paintable`](#gtk_image_get_paintable)
&nbsp;&nbsp;4. [`gtk_image_set_pixel_size` / `gtk_image_get_pixel_size`](#gtk_image_set_pixel_size--gtk_image_get_pixel_size)

V. [GtkSpinner](#gtkspinner)
&nbsp;&nbsp;1. [`gtk_spinner_new`](#gtk_spinner_new)
&nbsp;&nbsp;2. [`gtk_spinner_start` / `gtk_spinner_stop`](#gtk_spinner_start--gtk_spinner_stop)

VI. [GtkProgressBar](#gtkprogressbar)
&nbsp;&nbsp;1. [`gtk_progress_bar_new`](#gtk_progress_bar_new)
&nbsp;&nbsp;2. [`gtk_progress_bar_set_fraction` / `gtk_progress_bar_get_fraction`](#gtk_progress_bar_set_fraction--gtk_progress_bar_get_fraction)
&nbsp;&nbsp;3. [`gtk_progress_bar_set_text` / `gtk_progress_bar_get_text` / `gtk_progress_bar_set_show_text` / `gtk_progress_bar_get_show_text`](#gtk_progress_bar_set_text--gtk_progress_bar_get_text--gtk_progress_bar_set_show_text--gtk_progress_bar_get_show_text)
&nbsp;&nbsp;4. [`gtk_progress_bar_pulse`](#gtk_progress_bar_pulse)

VII. [Practical Recipes](#practical-recipes)
&nbsp;&nbsp;1. [A scrollable list inside a fixed-size window](#a-scrollable-list-inside-a-fixed-size-window)
&nbsp;&nbsp;2. [A settings group inside a labeled frame](#a-settings-group-inside-a-labeled-frame)
&nbsp;&nbsp;3. [A toolbar with separators between button groups](#a-toolbar-with-separators-between-button-groups)
&nbsp;&nbsp;4. [A loading indicator: a spinner while a request is in flight, a progress bar once the completed fraction is known](#a-loading-indicator-a-spinner-while-a-request-is-in-flight-a-progress-bar-once-the-completed-fraction-is-known)
&nbsp;&nbsp;5. [A user avatar with a fallback icon](#a-user-avatar-with-a-fallback-icon)

VIII. [Quick Reference Table](#quick-reference-table)

IX. [Summary: Which Procedure to Choose](#summary-which-procedure-to-choose)

---

## GtkScrolledWindow

`GtkScrolledWindow` is a container with exactly one child widget that adds scrollbars when the content doesn't fit in the space allotted to it. Many widgets with their own built-in list (for example, `GtkTextView` from a previous reference, or `GtkListBox`/`GtkColumnView` from the lists reference) are specifically designed so that their natural minimum size is small, precisely on the assumption that they'll be placed inside a `GtkScrolledWindow` — without it, a long list or document would simply stretch the window to fill the whole screen instead of producing a scrollbar.

### `gtk_scrolled_window_new`

```nim
proc gtk_scrolled_window_new*(): GtkScrolledWindow
```

**What it does.** Creates an empty scrollable container. The child widget is set separately via `gtk_scrolled_window_set_child`.

- No parameters.

```nim
let scrolled = gtk_scrolled_window_new()
echo "Scrollable container created"
```

---

### `gtk_scrolled_window_set_child` / `gtk_scrolled_window_get_child`

```nim
proc gtk_scrolled_window_set_child*(scrolledWindow: GtkScrolledWindow, child: GtkWidget)
proc gtk_scrolled_window_get_child*(scrolledWindow: GtkScrolledWindow): GtkWidget
```

**What it does.** Set and read the single child widget — the same "one content slot" pattern as `gtk_window_set_child` (core reference). To scroll several elements at once, make a container (`GtkBox`/`GtkGrid`) the single child, just as with a window.

- `scrolledWindow` — the container.
- `child` — the content widget.

```nim
gtk_scrolled_window_set_child(scrolled, longArticleTextView)
echo "Long text placed inside the scrollable area"
```

---

### `gtk_scrolled_window_set_policy` / `gtk_scrolled_window_get_policy`

```nim
proc gtk_scrolled_window_set_policy*(scrolledWindow: GtkScrolledWindow, hscrollbarPolicy: GtkPolicyType, vscrollbarPolicy: GtkPolicyType)
proc gtk_scrolled_window_get_policy*(scrolledWindow: GtkScrolledWindow, hscrollbarPolicy: ptr GtkPolicyType, vscrollbarPolicy: ptr GtkPolicyType)
```

**What it does.** Sets, independently for each of the two axes, exactly when to show a scrollbar: `GTK_POLICY_ALWAYS` — always show it, `GTK_POLICY_AUTOMATIC` — only show it when the content genuinely doesn't fit (the default for both axes), `GTK_POLICY_NEVER` — never show a scrollbar on this axis (the content is either clipped or cannot exceed the allotted size on this axis — typically used to disable horizontal scrolling in a list with text wrapping), `GTK_POLICY_EXTERNAL` — the widget doesn't draw a scrollbar at all itself; scrolling is assumed to be provided by some external widget (a specialized case).

- `scrolledWindow` — the container.
- `hscrollbarPolicy`, `vscrollbarPolicy` — the policy for the horizontal and vertical bars.

```nim
gtk_scrolled_window_set_policy(scrolled, GTK_POLICY_NEVER, GTK_POLICY_AUTOMATIC)
echo "Horizontal scrolling disabled, vertical scrolling as needed"
```

---

### `gtk_scrolled_window_set_has_frame` / `gtk_scrolled_window_get_has_frame`

```nim
proc gtk_scrolled_window_set_has_frame*(scrolledWindow: GtkScrolledWindow, hasFrame: gboolean)
proc gtk_scrolled_window_get_has_frame*(scrolledWindow: GtkScrolledWindow): gboolean
```

**What it does.** Shows/removes a frame around the scrollable area — the same logic as `gtk_entry_set_has_frame`/`gtk_button_set_has_frame`. The frame helps visually separate the scrollable area from the surrounding interface, especially when the content (e.g. a list) has no clear boundary of its own.

- `scrolledWindow` — the container.
- `hasFrame` — `1.gboolean` for a frame.

```nim
gtk_scrolled_window_set_has_frame(scrolled, 1.gboolean)
echo "Scrollable area is now visually outlined with a frame"
```

---

## GtkFrame

`GtkFrame` is a simple decorative frame around a single child widget, optionally with a caption along the top edge of the frame. Used for visually grouping related form elements or a settings panel — the same purpose as the HTML `<fieldset>` tag.

### `gtk_frame_new`

```nim
proc gtk_frame_new*(label: cstring): GtkFrame
```

**What it does.** Creates a frame with a text caption. Passing `nil` instead of `label` creates a frame without a caption — just a border line.

- `label` — the caption text, or `nil` for no caption.

```nim
let printSettingsFrame = gtk_frame_new("Print Options")
echo "Frame with the caption 'Print Options' created"
```

---

### `gtk_frame_set_label` / `gtk_frame_get_label`

```nim
proc gtk_frame_set_label*(frame: GtkFrame, label: cstring)
proc gtk_frame_get_label*(frame: GtkFrame): cstring
```

**What it does.** Set and read the caption text after the frame has been created. Passing `nil` removes the caption entirely (not the same as an empty string `""`, which shows an empty but noticeable spot for the caption).

- `frame` — the frame.
- `label` — the new caption text, or `nil`.

```nim
gtk_frame_set_label(printSettingsFrame, "Advanced Print Options")
echo "Frame caption: ", $gtk_frame_get_label(printSettingsFrame)
```

---

### `gtk_frame_set_child` / `gtk_frame_get_child`

```nim
proc gtk_frame_set_child*(frame: GtkFrame, child: GtkWidget)
proc gtk_frame_get_child*(frame: GtkFrame): GtkWidget
```

**What it does.** Set and read the frame's single child widget — the same pattern as `gtk_window_set_child`/`gtk_scrolled_window_set_child`. To group several elements inside the frame, make a `GtkBox`/`GtkGrid` the single child.

- `frame` — the frame.
- `child` — the content widget.

```nim
let settingsBox = gtk_box_new(GTK_ORIENTATION_VERTICAL, 8)
gtk_frame_set_child(printSettingsFrame, settingsBox)
echo "Frame now contains a vertical list of settings"
```

---

### `gtk_frame_set_label_widget` / `gtk_frame_get_label_widget`

```nim
proc gtk_frame_set_label_widget*(frame: GtkFrame, label_widget: GtkWidget)
proc gtk_frame_get_label_widget*(frame: GtkFrame): GtkWidget
```

**What it does.** Replaces the plain text caption with an arbitrary widget as the frame's header — for example, a `GtkCheckButton` that lets you toggle the whole settings group inside the frame on/off right from the header itself (a common settings-panel pattern: "☐ Enable autosave" as the frame's header, with the autosave settings inside). Setting `label_widget` overrides `set_label`, and vice versa — both methods target the same slot, just with plain text or a widget.

- `frame` — the frame.
- `label_widget` — the header widget.

```nim
let enableAutosaveCheck = gtk_check_button_new_with_label("Autosave")
gtk_frame_set_label_widget(printSettingsFrame, enableAutosaveCheck)
echo "Frame header replaced with a checkbox that enables the settings group"
```

---

### `gtk_frame_set_label_align` / `gtk_frame_get_label_align`

```nim
proc gtk_frame_set_label_align*(frame: GtkFrame, xalign: cfloat)
proc gtk_frame_get_label_align*(frame: GtkFrame): cfloat
```

**What it does.** Sets the horizontal position of the caption along the top edge of the frame as a fractional value: `0.0` — at the left edge (the default), `0.5` — centered, `1.0` — at the right edge.

- `frame` — the frame.
- `xalign` — a value from `0.0` to `1.0`.

```nim
gtk_frame_set_label_align(printSettingsFrame, 0.5)
echo "Frame caption centered along the top edge"
```

---

## GtkSeparator

`GtkSeparator` is a thin dividing line, horizontal or vertical, with no behavior of its own — a visual analog of the HTML `<hr>` tag, used inside a `GtkBox` to separate groups of elements from each other.

### `gtk_separator_new`

```nim
proc gtk_separator_new*(orientation: GtkOrientation): GtkSeparator
```

**What it does.** Creates a dividing line. The line's orientation is usually the opposite of the `GtkBox` it's placed in: a horizontal `GtkBox` (elements laid out in a row) needs a **vertical** separator to visually split the row into groups; a vertical `GtkBox` needs a horizontal one accordingly.

- `orientation` — `GTK_ORIENTATION_HORIZONTAL` or `GTK_ORIENTATION_VERTICAL`.

```nim
let toolbar = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 6)
gtk_box_append(toolbar, cutButton)
gtk_box_append(toolbar, copyButton)
gtk_box_append(toolbar, pasteButton)
let divider = gtk_separator_new(GTK_ORIENTATION_VERTICAL)  # vertical line in a horizontal row
gtk_box_append(toolbar, divider)
gtk_box_append(toolbar, undoButton)
echo "Toolbar: [Cut][Copy][Paste] | [Undo]"
```

---

## GtkImage

`GtkImage` is a widget for showing a static image: an icon from the system theme, a file on disk, or an arbitrary, already-prepared `GdkPaintable` (GTK4's general interface for anything that can be drawn — including, for example, a video frame or a programmatically generated image).

### `gtk_image_new` / `gtk_image_new_from_file` / `gtk_image_new_from_icon_name` / `gtk_image_new_from_paintable`

```nim
proc gtk_image_new*(): GtkImage
proc gtk_image_new_from_file*(filename: cstring): GtkImage
proc gtk_image_new_from_icon_name*(iconName: cstring): GtkImage
proc gtk_image_new_from_paintable*(paintable: GdkPaintable): GtkImage
```

**What it does.** Four ways to create an image: empty (the content is set later by one of the setters below), from a file on disk (loaded immediately, synchronously — for large files or network paths this can stall the UI; it's better to use asynchronous loading via `GdkPixbufLoader`/`GFile`, which is outside the scope of this reference), from a system theme icon by name (the preferred way for standard action icons — it scales for the theme and light/dark mode automatically), and from an already-ready `GdkPaintable` (e.g. a `GdkTexture` obtained by any other means — a decoded video frame, a generated image, and so on).

- `filename` — the path to the image file on disk.
- `iconName` — the theme icon name (e.g. `"folder-symbolic"`).
- `paintable` — a ready-made object implementing the `GdkPaintable` interface.

```nim
let logo = gtk_image_new_from_file("/usr/share/myapp/logo.png")
let openIcon = gtk_image_new_from_icon_name("document-open-symbolic")
echo "Image from a file and an icon from the theme created"
```

---

### `gtk_image_set_from_file` / `gtk_image_set_from_icon_name` / `gtk_image_set_from_paintable`

```nim
proc gtk_image_set_from_file*(image: GtkImage, filename: cstring)
proc gtk_image_set_from_icon_name*(image: GtkImage, iconName: cstring)
proc gtk_image_set_from_paintable*(image: GtkImage, paintable: GdkPaintable)
```

**What it does.** Changes the content of an already-existing `GtkImage` widget to a new image from any of the three sources — the same choice as the constructors of the same name, but applied to a widget already placed in the interface (for example, to change a preview after a different file is selected in a list).

- `image` — the image widget.
- `filename` / `iconName` / `paintable` — the new image source.

```nim
gtk_image_set_from_icon_name(statusIcon, "emblem-ok-symbolic")
echo "Status icon updated to 'done'"
```

---

### `gtk_image_get_paintable`

```nim
proc gtk_image_get_paintable*(image: GtkImage): GdkPaintable
```

**What it does.** Returns the widget's current image as a `GdkPaintable` object, regardless of which of the three ways it was set (even if a file or icon name was originally given rather than a ready-made `GdkPaintable` directly). Useful when you need to reuse the same image elsewhere in the interface (e.g. in another `GtkImage`) without reloading it from disk.

- `image` — the image widget.

```nim
let currentPaintable = gtk_image_get_paintable(logo)
let secondLogo = gtk_image_new_from_paintable(currentPaintable)
echo "Second instance of the logo created without re-reading the file"
```

---

### `gtk_image_set_pixel_size` / `gtk_image_get_pixel_size`

```nim
proc gtk_image_set_pixel_size*(image: GtkImage, pixelSize: gint)
proc gtk_image_get_pixel_size*(image: GtkImage): gint
```

**What it does.** Sets a square display size (in pixels) for the image — especially important for theme icons set by name: the theme itself typically stores an icon at several discrete sizes (16, 24, 32, 48...), and without an explicit `pixel_size`, GTK picks a size based on the usage context, which isn't always appropriate; an explicit size guarantees a predictable result regardless of theme. A value of `-1` means "use the default size for the context."

- `image` — the image widget.
- `pixelSize` — the side length of the square in pixels, or `-1`.

```nim
let largeIcon = gtk_image_new_from_icon_name("dialog-warning-symbolic")
gtk_image_set_pixel_size(largeIcon, 48)
echo "Warning icon enlarged to 48×48 pixels"
```

---

## GtkSpinner

`GtkSpinner` is a simple spinning activity indicator with no numeric value ("something is happening, but it's unknown exactly how much or when it will finish") — a visual analog of `gtk_entry_progress_pulse` from the text-input reference, but as a standalone widget rather than one built into an entry field.

### `gtk_spinner_new`

```nim
proc gtk_spinner_new*(): GtkSpinner
```

**What it does.** Creates a spinner in the stopped (animation-wise invisible) state.

- No parameters.

```nim
let loadingSpinner = gtk_spinner_new()
echo "Spinner created, but not yet spinning"
```

---

### `gtk_spinner_start` / `gtk_spinner_stop`

```nim
proc gtk_spinner_start*(spinner: GtkSpinner)
proc gtk_spinner_stop*(spinner: GtkSpinner)
```

**What it does.** Starts and stops the spinning animation. Unlike `gtk_widget_hide`, `stop` does not hide the widget itself — it simply stops spinning and freezes on the current frame; if you need the spinner to disappear entirely once the operation is done, `stop` is usually combined with `gtk_widget_set_visible(spinner, 0.gboolean)`.

- `spinner` — the spinner.

```nim
gtk_spinner_start(loadingSpinner)
gtk_widget_set_visible(loadingSpinner, 1.gboolean)
echo "Loading started, spinner running and visible"
# ... once the operation is done ...
gtk_spinner_stop(loadingSpinner)
gtk_widget_set_visible(loadingSpinner, 0.gboolean)
echo "Loading finished, spinner stopped and hidden"
```

---

## GtkProgressBar

`GtkProgressBar` is a horizontal (or vertical — depending on the orientation of the parent container; this wrapper has no explicit orientation setting for the widget itself) bar showing the fraction of an operation that's complete. Unlike `GtkSpinner`, it's useful precisely when the completed fraction **is known** — either as an exact number, or (via `pulse`) in an "unknown how much, but definitely something is happening" mode, similar to `GtkEntry`'s pulsing mode.

### `gtk_progress_bar_new`

```nim
proc gtk_progress_bar_new*(): GtkProgressBar
```

**What it does.** Creates a progress bar at zero completion.

- No parameters.

```nim
let exportProgress = gtk_progress_bar_new()
echo "Export progress bar created"
```

---

### `gtk_progress_bar_set_fraction` / `gtk_progress_bar_get_fraction`

```nim
proc gtk_progress_bar_set_fraction*(pbar: GtkProgressBar, fraction: gdouble)
proc gtk_progress_bar_get_fraction*(pbar: GtkProgressBar): gdouble
```

**What it does.** Set and read the completed fraction, from `0.0` (nothing done) to `1.0` (fully complete).

- `pbar` — the progress bar.
- `fraction` — a value from `0.0` to `1.0`.

```nim
gtk_progress_bar_set_fraction(exportProgress, 0.42)
echo "Export progress: ", int(gtk_progress_bar_get_fraction(exportProgress) * 100), "%"
```

---

### `gtk_progress_bar_set_text` / `gtk_progress_bar_get_text` / `gtk_progress_bar_set_show_text` / `gtk_progress_bar_get_show_text`

```nim
proc gtk_progress_bar_set_text*(pbar: GtkProgressBar, text: cstring)
proc gtk_progress_bar_get_text*(pbar: GtkProgressBar): cstring
proc gtk_progress_bar_set_show_text*(pbar: GtkProgressBar, showText: gboolean)
proc gtk_progress_bar_get_show_text*(pbar: GtkProgressBar): gboolean
```

**What it does.** Sets the text displayed on top of the progress bar (e.g. `"42%"` or `"Processing file 3 of 7"`), and controls whether this text is shown at all (`show_text`, off by default). If `set_text` hasn't been called, or was passed `nil`, and `show_text` is enabled, GTK shows a computed percentage like `"42 %"` based on `fraction` on its own.

- `pbar` — the progress bar.
- `text` — the text over the bar, or `nil` for an automatic percentage.
- `showText` — `1.gboolean` to show the text.

```nim
gtk_progress_bar_set_show_text(exportProgress, 1.gboolean)
gtk_progress_bar_set_text(exportProgress, "Encoding video: frame 420 of 1000")
echo "Text over the progress bar: ", $gtk_progress_bar_get_text(exportProgress)
```

---

### `gtk_progress_bar_pulse`

```nim
proc gtk_progress_bar_pulse*(pbar: GtkProgressBar)
```

**What it does.** Shifts a small block within the progress bar one step forward and back — a mode for operations of unknown duration, similar to `gtk_entry_progress_pulse` from the text-input reference. As there, there's no automatic animation — `pulse` must be called manually and periodically (e.g. via a timer every 100–200 ms) until the operation completes, after which it's typical to switch to `set_fraction(pbar, 1.0)` or hide the bar entirely.

- `pbar` — the progress bar.

```nim
proc onPulseTick(userData: gpointer): gboolean {.cdecl.} =
  gtk_progress_bar_pulse(cast[GtkProgressBar](userData))
  result = 1.gboolean  # keep the timer going

# g_timeout_add(150, onPulseTick, cast[gpointer](searchProgress))  # see the GLib timers reference
echo "Pulsing indicator started for an operation of unknown duration"
```

---

## Practical Recipes

### A scrollable list inside a fixed-size window

A classic pairing: a fixed-size window containing a long list that scrolls within the space allotted to it, without stretching the window itself.

```nim
proc buildScrollableContentWindow(app: GtkApplication): GtkWindow =
  result = gtk_application_window_new(app)
  gtk_window_set_default_size(result, 400, 500)

  let listBox = gtk_box_new(GTK_ORIENTATION_VERTICAL, 4)
  for i in 1..50:
    gtk_box_append(listBox, gtk_label_new(("Item " & $i).cstring))

  let scrolled = gtk_scrolled_window_new()
  gtk_scrolled_window_set_policy(scrolled, GTK_POLICY_NEVER, GTK_POLICY_AUTOMATIC)
  gtk_scrolled_window_set_child(scrolled, listBox)

  gtk_window_set_child(result, scrolled)
  echo "50 items placed in a fixed 400×500 window with vertical scrolling"

# let window = buildScrollableContentWindow(app)
```

---

### A settings group inside a labeled frame

A `GtkFrame` with a text caption, containing a `GtkGrid` with several settings — a typical visual block for a settings panel.

```nim
proc buildSettingsGroup(title: string): GtkFrame =
  result = gtk_frame_new(title.cstring)
  let content = gtk_grid_new()
  gtk_grid_set_row_spacing(content, 8)
  gtk_grid_set_column_spacing(content, 12)
  gtk_widget_set_margin_start(content, 12)
  gtk_widget_set_margin_end(content, 12)
  gtk_widget_set_margin_top(content, 12)
  gtk_widget_set_margin_bottom(content, 12)
  gtk_frame_set_child(result, content)

let networkGroup = buildSettingsGroup("Network")
echo "'Network' settings group in a labeled frame ready to be filled with fields"
```

---

### A toolbar with separators between button groups

Three logical button groups separated by vertical lines.

```nim
proc buildToolbarWithSeparators(): GtkBox =
  result = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 4)

  for iconName in ["document-new-symbolic", "document-open-symbolic", "document-save-symbolic"]:
    gtk_box_append(result, gtk_button_new_from_icon_name(iconName.cstring))

  gtk_box_append(result, gtk_separator_new(GTK_ORIENTATION_VERTICAL))

  for iconName in ["edit-cut-symbolic", "edit-copy-symbolic", "edit-paste-symbolic"]:
    gtk_box_append(result, gtk_button_new_from_icon_name(iconName.cstring))

  gtk_box_append(result, gtk_separator_new(GTK_ORIENTATION_VERTICAL))
  gtk_box_append(result, gtk_button_new_from_icon_name("edit-undo-symbolic"))

  echo "Toolbar of three groups separated by vertical lines assembled"

let toolbar = buildToolbarWithSeparators()
```

---

### A loading indicator: a spinner while a request is in flight, a progress bar once the completed fraction is known

Switching between two kinds of indicators depending on whether the operation's progress is known at the time it starts.

```nim
proc showIndeterminateLoading(container: GtkBox): GtkSpinner =
  result = gtk_spinner_new()
  gtk_spinner_start(result)
  gtk_box_append(container, result)
  echo "Spinner shown — the request's completed fraction is not yet known"

proc switchToKnownProgress(container: GtkBox, spinner: GtkSpinner): GtkProgressBar =
  gtk_spinner_stop(spinner)
  gtk_box_remove(container, spinner)
  result = gtk_progress_bar_new()
  gtk_progress_bar_set_show_text(result, 1.gboolean)
  gtk_box_append(container, result)
  echo "Server reported the total file size — switched to an exact progress bar"

proc updateProgress(pbar: GtkProgressBar, downloaded, total: int) =
  gtk_progress_bar_set_fraction(pbar, downloaded.float / total.float)
  gtk_progress_bar_set_text(pbar, (
    $downloaded & " of " & $total & " MB"
  ).cstring)
```

---

### A user avatar with a fallback icon

An attempt to load an avatar image from a file, falling back to a default profile icon if the file doesn't exist.

```nim
proc buildAvatarImage(avatarPath: string): GtkImage =
  if fileExists(avatarPath):
    result = gtk_image_new_from_file(avatarPath.cstring)
    echo "Avatar loaded from file: ", avatarPath
  else:
    result = gtk_image_new_from_icon_name("avatar-default-symbolic")
    echo "Avatar file not found, showing the default profile icon"
  gtk_image_set_pixel_size(result, 64)

let userAvatar = buildAvatarImage("/home/user/.cache/myapp/avatar.png")
```

---

## Quick Reference Table

| Procedure(s) | Category | What it does, briefly |
|---|---|---|
| `gtk_scrolled_window_new` | ScrolledWindow | Create a scrollable container |
| `gtk_scrolled_window_set/get_child` | ScrolledWindow | The single child widget |
| `gtk_scrolled_window_set/get_policy` | ScrolledWindow | When to show scrollbars on each axis |
| `gtk_scrolled_window_set/get_has_frame` | ScrolledWindow | A frame around the scrollable area |
| `gtk_frame_new` | Frame | Create a frame, with or without a caption |
| `gtk_frame_set/get_label` | Frame | The caption text |
| `gtk_frame_set/get_child` | Frame | The single child widget inside the frame |
| `gtk_frame_set/get_label_widget` | Frame | An arbitrary widget instead of a text caption |
| `gtk_frame_set/get_label_align` | Frame | The caption's position along the top edge |
| `gtk_separator_new` | Separator | Create a dividing line |
| `gtk_image_new`, `_from_file`, `_from_icon_name`, `_from_paintable` | Image | Create an image from various sources |
| `gtk_image_set_from_file/icon_name/paintable` | Image | Change the content of an existing widget |
| `gtk_image_get_paintable` | Image | Get the current image as a `GdkPaintable` |
| `gtk_image_set/get_pixel_size` | Image | The display size (especially important for theme icons) |
| `gtk_spinner_new` | Spinner | Create a spinning activity indicator |
| `gtk_spinner_start/stop` | Spinner | Start/stop the spinning animation |
| `gtk_progress_bar_new` | ProgressBar | Create a progress bar |
| `gtk_progress_bar_set/get_fraction` | ProgressBar | The exact completed fraction, from 0.0 to 1.0 |
| `gtk_progress_bar_set/get_text`, `set/get_show_text` | ProgressBar | Text over the bar (custom or an automatic percentage) |
| `gtk_progress_bar_pulse` | ProgressBar | Pulsing for operations of unknown duration |

---

## Summary: Which Procedure to Choose

- **A list/text/table might not fit on screen** → always wrap it in a `GtkScrolledWindow` rather than relying on the window to adjust to the content on its own — without the wrapper, long content simply stretches the window instead of becoming scrollable.
- **Visually group several form fields or settings** → a `GtkFrame` with a caption, rather than just an indent of empty space — the frame gives the group a clear visible boundary. If the whole group needs to be enabled/disabled with a single toggle right in the header → `gtk_frame_set_label_widget` with a checkbox instead of plain text.
- **Split a row of toolbar buttons into logical groups** → a `GtkSeparator` with the **opposite** orientation to the `GtkBox` it's nested in (a vertical line in a horizontal row).
- **Show an icon or a picture** → `GtkImage`; for standard action icons, the `_from_icon_name` constructor (scales for the theme automatically) rather than `_from_file` with an icon manually exported at a specific size.
- **Indicating "something is happening, but it's unknown how much"** → `GtkSpinner` (compact, no numeric value) for short operations, or `GtkProgressBar` in pulsing mode (`gtk_progress_bar_pulse`) if a bar is more contextually appropriate than a spinning icon.
- **Indicating a known, exact completed fraction** → `GtkProgressBar` with `gtk_progress_bar_set_fraction`, not pulsing — pulsing mode specifically signals to the user that the duration is unknown.
- **Text over the progress bar** → `gtk_progress_bar_set_show_text` + `gtk_progress_bar_set_text` for meaningful text; if a percentage is enough, just `set_show_text(true)` without calling `set_text` — GTK will show the percentage computed from `fraction` on its own.
