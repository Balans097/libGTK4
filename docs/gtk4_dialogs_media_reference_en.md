# GTK4 (about/color/font dialogs, GLArea, clipboard & images: AboutDialog / ColorChooserDialog / FontChooserDialog / GLArea / Clipboard / GdkPixbuf / GdkTexture) — module reference

> **Import:** `import libGTK4`
> **Scope:** the "About" dialog, the system color and font chooser dialogs, the OpenGL rendering area, the system clipboard, and two ways of working with in-memory raster images. Twelfth part of this wrapper reference series; assumes familiarity with earlier parts, especially `gtk4_core_reference_ru.md` and `gtk4_window_chrome_dialogs_reference_ru.md` (dialogs, `GtkWindow`).

`GdkPixbuf` and `GdkTexture` solve an outwardly similar problem (an in-memory raster image), but for different purposes: `GdkPixbuf` is the older, CPU-oriented format, convenient for programmatic pixel manipulation (scaling, saving to a file, line-by-line loading from a stream); `GdkTexture` is the modern, GPU-oriented format, optimal for displaying an image on screen (what `gtk_image_new_from_paintable`/`gtk_picture_set_paintable` from earlier references ultimately accept, since `GdkTexture` implements the `GdkPaintable` interface). There is a direct conversion between the two (`gdk_texture_new_for_pixbuf`).

---

## Table of contents

I. [GtkAboutDialog](#gtkaboutdialog)
&nbsp;&nbsp;1. [`gtk_about_dialog_new`](#gtk_about_dialog_new)
&nbsp;&nbsp;2. [`gtk_about_dialog_set/get_program_name`, `set/get_version`, `set/get_copyright`, `set/get_comments`](#gtk_about_dialog_setget_program_name-setget_version-setget_copyright-setget_comments)
&nbsp;&nbsp;3. [`gtk_about_dialog_set/get_license`](#gtk_about_dialog_setget_license)
&nbsp;&nbsp;4. [`gtk_about_dialog_set/get_website`, `set/get_website_label`](#gtk_about_dialog_setget_website-setget_website_label)
&nbsp;&nbsp;5. [`gtk_about_dialog_set/get_authors`](#gtk_about_dialog_setget_authors)
&nbsp;&nbsp;6. [`gtk_about_dialog_set/get_logo`, `set/get_logo_icon_name`](#gtk_about_dialog_setget_logo-setget_logo_icon_name)

II. [GtkColorChooserDialog](#gtkcolorchooserdialog)
&nbsp;&nbsp;1. [`gtk_color_chooser_dialog_new`](#gtk_color_chooser_dialog_new)
&nbsp;&nbsp;2. [`gtk_color_chooser_get_rgba` / `gtk_color_chooser_set_rgba`](#gtk_color_chooser_get_rgba--gtk_color_chooser_set_rgba)
&nbsp;&nbsp;3. [`gtk_color_chooser_set_use_alpha` / `gtk_color_chooser_get_use_alpha`](#gtk_color_chooser_set_use_alpha--gtk_color_chooser_get_use_alpha)

III. [GtkFontChooserDialog](#gtkfontchooserdialog)
&nbsp;&nbsp;1. [`gtk_font_chooser_dialog_new`](#gtk_font_chooser_dialog_new)
&nbsp;&nbsp;2. [`gtk_font_chooser_get_font` / `gtk_font_chooser_set_font`](#gtk_font_chooser_get_font--gtk_font_chooser_set_font)
&nbsp;&nbsp;3. [`gtk_font_chooser_get_font_desc` / `gtk_font_chooser_set_font_desc`](#gtk_font_chooser_get_font_desc--gtk_font_chooser_set_font_desc)
&nbsp;&nbsp;4. [`gtk_font_chooser_get_preview_text` / `gtk_font_chooser_set_preview_text`](#gtk_font_chooser_get_preview_text--gtk_font_chooser_set_preview_text)

IV. [GtkGLArea](#gtkglarea)
&nbsp;&nbsp;1. [`gtk_gl_area_new`](#gtk_gl_area_new)
&nbsp;&nbsp;2. [`gtk_gl_area_make_current` / `gtk_gl_area_queue_render` / `gtk_gl_area_attach_buffers`](#gtk_gl_area_make_current--gtk_gl_area_queue_render--gtk_gl_area_attach_buffers)
&nbsp;&nbsp;3. [`gtk_gl_area_set/get_required_version`](#gtk_gl_area_setget_required_version)
&nbsp;&nbsp;4. [`gtk_gl_area_set/get_has_depth_buffer`, `set/get_has_stencil_buffer`](#gtk_gl_area_setget_has_depth_buffer-setget_has_stencil_buffer)

V. [Clipboard: GdkClipboard](#clipboard-gdkclipboard)
&nbsp;&nbsp;1. [`gdk_display_get_clipboard`](#gdk_display_get_clipboard)
&nbsp;&nbsp;2. [`gdk_clipboard_set_text`](#gdk_clipboard_set_text)
&nbsp;&nbsp;3. [`gdk_clipboard_read_text_async` / `gdk_clipboard_read_text_finish`](#gdk_clipboard_read_text_async--gdk_clipboard_read_text_finish)

VI. [GdkPixbuf](#gdkpixbuf)
&nbsp;&nbsp;1. [`gdk_pixbuf_new` / `gdk_pixbuf_new_from_file`](#gdk_pixbuf_new--gdk_pixbuf_new_from_file)
&nbsp;&nbsp;2. [`gdk_pixbuf_get_width` / `gdk_pixbuf_get_height`](#gdk_pixbuf_get_width--gdk_pixbuf_get_height)
&nbsp;&nbsp;3. [`gdk_pixbuf_scale_simple`](#gdk_pixbuf_scale_simple)
&nbsp;&nbsp;4. [`gdk_pixbuf_savev`](#gdk_pixbuf_savev)
&nbsp;&nbsp;5. [`gdk_pixbuf_new_from_stream` / `g_memory_input_stream_new_from_bytes`](#gdk_pixbuf_new_from_stream--g_memory_input_stream_new_from_bytes)
&nbsp;&nbsp;6. [Incremental loading: `gdk_pixbuf_loader_new` and related functions](#incremental-loading-gdk_pixbuf_loader_new-and-related-functions)

VII. [GdkTexture](#gdktexture)
&nbsp;&nbsp;1. [`gdk_texture_new_for_pixbuf`](#gdk_texture_new_for_pixbuf)
&nbsp;&nbsp;2. [`gdk_texture_new_from_file` / `gdk_texture_new_from_filename`](#gdk_texture_new_from_file--gdk_texture_new_from_filename)
&nbsp;&nbsp;3. [`gdk_texture_get_width` / `gdk_texture_get_height`](#gdk_texture_get_width--gdk_texture_get_height)
&nbsp;&nbsp;4. [`gdk_texture_new_from_bytes` / `g_bytes_new_static` / `g_bytes_unref`](#gdk_texture_new_from_bytes--g_bytes_new_static--g_bytes_unref)

VIII. [Practical recipes](#practical-recipes)
&nbsp;&nbsp;1. [About dialog with a full set of information](#about-dialog-with-a-full-set-of-information)
&nbsp;&nbsp;2. [Accent color picker button with a dialog](#accent-color-picker-button-with-a-dialog)
&nbsp;&nbsp;3. [Copying text to the clipboard and reading it back](#copying-text-to-the-clipboard-and-reading-it-back)
&nbsp;&nbsp;4. [Shrinking an image before saving it as a thumbnail](#shrinking-an-image-before-saving-it-as-a-thumbnail)
&nbsp;&nbsp;5. [Incrementally loading an image from a data stream arriving in chunks](#incrementally-loading-an-image-from-a-data-stream-arriving-in-chunks)

IX. [Quick reference table](#quick-reference-table)

X. [Summary: which procedure to choose](#summary-which-procedure-to-choose)

---

## GtkAboutDialog

`GtkAboutDialog` — a ready-made "About" dialog with a standard set of fields (name, version, authors, license, website) that doesn't require assembling the layout by hand — only the text data needs to be filled in; the layout and styling are handled by GTK itself.

### `gtk_about_dialog_new`

```nim
proc gtk_about_dialog_new*(): GtkAboutDialog
```

**What it does.** Creates an empty "About" dialog — all fields are initially unset; showing the dialog without a single filled-in field gives a fairly uninformative result, so typically the name and version (next subsection) are filled in right after creation.

- No parameters.

```nim
let aboutDialog = gtk_about_dialog_new()
echo "'About' dialog created"
```

---

### `gtk_about_dialog_set/get_program_name`, `set/get_version`, `set/get_copyright`, `set/get_comments`

```nim
proc gtk_about_dialog_set_program_name*(about: GtkAboutDialog, name: cstring)
proc gtk_about_dialog_get_program_name*(about: GtkAboutDialog): cstring
proc gtk_about_dialog_set_version*(about: GtkAboutDialog, version: cstring)
proc gtk_about_dialog_get_version*(about: GtkAboutDialog): cstring
proc gtk_about_dialog_set_copyright*(about: GtkAboutDialog, copyright: cstring)
proc gtk_about_dialog_get_copyright*(about: GtkAboutDialog): cstring
proc gtk_about_dialog_set_comments*(about: GtkAboutDialog, comments: cstring)
proc gtk_about_dialog_get_comments*(about: GtkAboutDialog): cstring
```

**What it does.** Fills in the dialog's main text fields: `program_name` — the application's name (shown in large type near the top of the dialog), `version` — the version string, `copyright` — a short copyright line (e.g. `"© 2026 Your Company"`), `comments` — a short description of the application's purpose (one or two sentences, shown below the name).

- `about` — the "About" dialog.
- `name`, `version`, `copyright`, `comments` — the corresponding strings.

```nim
gtk_about_dialog_set_program_name(aboutDialog, "Project Editor")
gtk_about_dialog_set_version(aboutDialog, "1.3.0")
gtk_about_dialog_set_copyright(aboutDialog, "© 2026 Your Company")
gtk_about_dialog_set_comments(aboutDialog, "A simple editor for quick project work")
echo "Dialog's main information filled in"
```

---

### `gtk_about_dialog_set/get_license`

```nim
proc gtk_about_dialog_set_license*(about: GtkAboutDialog, license: cstring)
proc gtk_about_dialog_get_license*(about: GtkAboutDialog): cstring
```

**What it does.** Sets the full license text, shown on a separate tab/screen of the dialog (for long text, e.g. the full MIT/GPL text) — unlike `gtk_about_dialog_set_website_label` (next subsection), this is not a link but the actual embedded text in full.

- `about` — the "About" dialog.
- `license` — the full license text.

```nim
gtk_about_dialog_set_license(aboutDialog, "Distributed under the MIT license.\n\nFull license text...")
echo "License text added to the dialog"
```

---

### `gtk_about_dialog_set/get_website`, `set/get_website_label`

```nim
proc gtk_about_dialog_set_website*(about: GtkAboutDialog, website: cstring)
proc gtk_about_dialog_get_website*(about: GtkAboutDialog): cstring
proc gtk_about_dialog_set_website_label*(about: GtkAboutDialog, websiteLabel: cstring)
proc gtk_about_dialog_get_website_label*(about: GtkAboutDialog): cstring
```

**What it does.** Sets the link to the project's website (`website` — the URI itself) and the text this link is displayed to the user as (`website_label` — e.g. `"Project website"` instead of a long technical URL). The dialog displays the link as clickable (similar to `GtkLinkButton` from the panels reference).

- `about` — the "About" dialog.
- `website` — the website URI.
- `websiteLabel` — the visible link text.

```nim
gtk_about_dialog_set_website(aboutDialog, "https://example.com")
gtk_about_dialog_set_website_label(aboutDialog, "Project website")
echo "Link to the project website added"
```

---

### `gtk_about_dialog_set/get_authors`

```nim
proc gtk_about_dialog_set_authors*(about: GtkAboutDialog, authors: ptr cstring)
proc gtk_about_dialog_get_authors*(about: GtkAboutDialog): ptr cstring
```

**What it does.** Sets the list of authors — a `NULL`-terminated array of strings (the same C convention as `argv` and `gtk_application_set_accels_for_action` from the core reference), not a single string containing all the names. In Nim, such an array needs to be assembled by hand from a `seq[string]` before the call.

- `about` — the "About" dialog.
- `authors` — an array of author-name strings, terminated by `nil`.

```nim
var authorsArray = [cstring("Ivan Petrov"), cstring("Anna Sidorova"), nil]
gtk_about_dialog_set_authors(aboutDialog, addr authorsArray[0])
echo "List of two authors added to the dialog"
```

---

### `gtk_about_dialog_set/get_logo`, `set/get_logo_icon_name`

```nim
proc gtk_about_dialog_set_logo*(about: GtkAboutDialog, logo: pointer)
proc gtk_about_dialog_get_logo*(about: GtkAboutDialog): pointer
proc gtk_about_dialog_set_logo_icon_name*(about: GtkAboutDialog, iconName: cstring)
proc gtk_about_dialog_get_logo_icon_name*(about: GtkAboutDialog): cstring
```

**What it does.** Sets the logo shown near the top of the dialog — either as a ready-made image (`set_logo`, taking a `GdkPaintable` — e.g. a `GdkTexture` from section VII, cast to `pointer`), or by icon name from the system theme (`set_logo_icon_name`, for applications using an icon from the icon theme instead of their own raster logo). If neither method is called, GTK shows the default application icon (set via `gtk_window_set_default_icon_name`, core reference).

- `about` — the "About" dialog.
- `logo` — the logo image (`GdkPaintable`, cast to `pointer`).
- `iconName` — the theme icon name.

```nim
gtk_about_dialog_set_logo_icon_name(aboutDialog, "accessories-text-editor")
echo "Logo set by theme icon name"
```

---

## GtkColorChooserDialog

`GtkColorChooserDialog` — the system color-picker dialog, implementing the `GtkColorChooser` interface on top of `GtkDialog` (the same `gtk_dialog_add_button`/`"response"` signal from the window chrome reference apply directly).

### `gtk_color_chooser_dialog_new`

```nim
proc gtk_color_chooser_dialog_new*(title: cstring, parent: GtkWindow): GtkColorChooserDialog
```

**What it does.** Creates a color-picker dialog with the standard ready-made set of buttons ("Cancel"/"Select").

- `title` — the dialog's title.
- `parent` — the parent window.

```nim
let colorDialog = gtk_color_chooser_dialog_new("Choose an accent color", mainWindow)
gtk_window_present(colorDialog)
echo "Color picker dialog shown"
```

---

### `gtk_color_chooser_get_rgba` / `gtk_color_chooser_set_rgba`

```nim
proc gtk_color_chooser_get_rgba*(chooser: GtkColorChooser, color: pointer)
proc gtk_color_chooser_set_rgba*(chooser: GtkColorChooser, color: pointer)
```

**What it does.** Reads and sets the currently selected color via a `GdkRGBA` structure (red/green/blue/alpha components, each a `gdouble` from `0.0` to `1.0`; passed as an opaque `pointer` — there's no separately named type for it in this function set, so the structure needs to be declared by hand).

- `chooser` — the color-picker dialog.
- `color` — a pointer to a `GdkRGBA` structure.

```nim
proc onResponse(dialog: GtkColorChooserDialog, responseId: gint, userData: gpointer) {.cdecl.} =
  if responseId == ord(GTK_RESPONSE_ACCEPT).gint:
    var chosenColor: array[4, gdouble]  # red, green, blue, alpha
    gtk_color_chooser_get_rgba(dialog, addr chosenColor[0])
    echo "Color chosen: R=", chosenColor[0], " G=", chosenColor[1], " B=", chosenColor[2]
  gtk_window_destroy(cast[GtkWindow](dialog))

discard g_signal_connect(colorDialog, "response", onResponse, nil)
```

---

### `gtk_color_chooser_set_use_alpha` / `gtk_color_chooser_get_use_alpha`

```nim
proc gtk_color_chooser_set_use_alpha*(chooser: GtkColorChooser, useAlpha: gboolean)
proc gtk_color_chooser_get_use_alpha*(chooser: GtkColorChooser): gboolean
```

**What it does.** Enables/disables the ability to configure transparency (the alpha channel) of the chosen color — disabled by default.

- `chooser` — the color-picker dialog.
- `useAlpha` — `1.gboolean` to allow configuring transparency.

```nim
gtk_color_chooser_set_use_alpha(colorDialog, 1.gboolean)
echo "The dialog now also allows configuring color transparency"
```

---

## GtkFontChooserDialog

`GtkFontChooserDialog` — the system font-picker dialog with a live preview, implementing the `GtkFontChooser` interface on top of `GtkDialog`.

### `gtk_font_chooser_dialog_new`

```nim
proc gtk_font_chooser_dialog_new*(title: cstring, parent: GtkWindow): GtkFontChooserDialog
```

**What it does.** Creates a font-picker dialog with the standard ready-made set of buttons.

- `title` — the dialog's title.
- `parent` — the parent window.

```nim
let fontDialog = gtk_font_chooser_dialog_new("Choose the editor font", mainWindow)
gtk_window_present(fontDialog)
echo "Font picker dialog shown"
```

---

### `gtk_font_chooser_get_font` / `gtk_font_chooser_set_font`

```nim
proc gtk_font_chooser_get_font*(fontchooser: GtkFontChooser): cstring
proc gtk_font_chooser_set_font*(fontchooser: GtkFontChooser, fontname: cstring)
```

**What it does.** Reads and sets the chosen font as a single Pango description string (e.g. `"Sans Bold 12"`) — the standard Pango format, the simplest way to work with a font for most scenarios.

- `fontchooser` — the font-picker dialog.
- `fontname` — the font description string in Pango format.

```nim
gtk_font_chooser_set_font(fontDialog, "Monospace 11")
proc onFontResponse(dialog: GtkFontChooserDialog, responseId: gint, userData: gpointer) {.cdecl.} =
  if responseId == ord(GTK_RESPONSE_ACCEPT).gint:
    echo "Font chosen: ", $gtk_font_chooser_get_font(dialog)
  gtk_window_destroy(cast[GtkWindow](dialog))
discard g_signal_connect(fontDialog, "response", onFontResponse, nil)
```

---

### `gtk_font_chooser_get_font_desc` / `gtk_font_chooser_set_font_desc`

```nim
proc gtk_font_chooser_get_font_desc*(fontchooser: GtkFontChooser): pointer
proc gtk_font_chooser_set_font_desc*(fontchooser: GtkFontChooser, fontDesc: pointer)
```

**What it does.** The same as `get_font`/`set_font`, but via a structured `PangoFontDescription` object (an opaque `pointer` in this wrapper) instead of a string — needed for programmatic font handling where individual components need to be read/changed separately. Building and parsing a `PangoFontDescription` requires the `pango_font_description_*` functions, not covered in this reference.

- `fontchooser` — the font-picker dialog.
- `fontDesc` — the `PangoFontDescription` object.

```nim
let currentDesc = gtk_font_chooser_get_font_desc(fontDialog)
echo "Structured description of the current font obtained: ", not isNil(currentDesc)
```

---

### `gtk_font_chooser_get_preview_text` / `gtk_font_chooser_set_preview_text`

```nim
proc gtk_font_chooser_get_preview_text*(fontchooser: GtkFontChooser): cstring
proc gtk_font_chooser_set_preview_text*(fontchooser: GtkFontChooser, text: cstring)
```

**What it does.** Sets and reads the font preview text — by default GTK shows a standard pangram phrase; replacing it with text meaningful to the application helps the user judge the choice more accurately.

- `fontchooser` — the font-picker dialog.
- `text` — the preview text.

```nim
gtk_font_chooser_set_preview_text(fontDialog, "def hello(): print(\"Hello, world!\")")
echo "Font preview now shows a code sample instead of the standard phrase"
```

---

## GtkGLArea

`GtkGLArea` — an area for rendering via OpenGL, analogous to `GtkDrawingArea`, but instead of a Cairo context it provides an active OpenGL context for direct `gl*` function calls (the OpenGL API bindings themselves are not part of this wrapper).

### `gtk_gl_area_new`

```nim
proc gtk_gl_area_new*(): GtkGLArea
```

**What it does.** Creates an empty OpenGL rendering area. Actual drawing requires connecting a handler to the `"render"` signal (emitted whenever a redraw is needed).

- No parameters.

```nim
let glCanvas = gtk_gl_area_new()
echo "OpenGL rendering area created"
```

---

### `gtk_gl_area_make_current` / `gtk_gl_area_queue_render` / `gtk_gl_area_attach_buffers`

```nim
proc gtk_gl_area_make_current*(area: GtkGLArea)
proc gtk_gl_area_queue_render*(area: GtkGLArea)
proc gtk_gl_area_attach_buffers*(area: GtkGLArea)
```

**What it does.** `make_current` makes this area's OpenGL context active for subsequent OpenGL function calls on the current thread. `queue_render` requests a redraw on the next main-loop iteration — analogous to `gtk_widget_queue_draw`. `attach_buffers` binds OpenGL framebuffer objects to the area — normally called automatically before `"render"`.

- `area` — the OpenGL rendering area.

```nim
gtk_gl_area_make_current(glCanvas)
gtk_gl_area_queue_render(glCanvas)
echo "OpenGL context activated, redraw requested"
```

---

### `gtk_gl_area_set/get_required_version`

```nim
proc gtk_gl_area_set_required_version*(area: GtkGLArea, major: gint, minor: gint)
proc gtk_gl_area_get_required_version*(area: GtkGLArea, major: ptr gint, minor: ptr gint)
```

**What it does.** Sets the minimum required OpenGL version — if the system can't provide a context of the requested version, `GtkGLArea` will report an error instead of silently providing an incompatible version.

- `area` — the rendering area.
- `major`, `minor` — components of the required version.

```nim
gtk_gl_area_set_required_version(glCanvas, 3, 3)
echo "OpenGL version 3.3 or higher required"
```

---

### `gtk_gl_area_set/get_has_depth_buffer`, `set/get_has_stencil_buffer`

```nim
proc gtk_gl_area_set_has_depth_buffer*(area: GtkGLArea, hasDepthBuffer: gboolean)
proc gtk_gl_area_get_has_depth_buffer*(area: GtkGLArea): gboolean
proc gtk_gl_area_set_has_stencil_buffer*(area: GtkGLArea, hasStencilBuffer: gboolean)
proc gtk_gl_area_get_has_stencil_buffer*(area: GtkGLArea): gboolean
```

**What it does.** Enables/disables the depth buffer (for correct 3D object occlusion) and the stencil buffer (for masking techniques) — both disabled by default.

- `area` — the rendering area.
- `hasDepthBuffer`, `hasStencilBuffer` — `1.gboolean` to enable.

```nim
gtk_gl_area_set_has_depth_buffer(glCanvas, 1.gboolean)
echo "Depth buffer enabled for correct 3D object display"
```

---

## Clipboard: GdkClipboard

`GdkClipboard` — the system clipboard (the same one used by the built-in "Copy"/"Paste" in text fields from earlier references), also available for programmatic use — for example, a "Copy link" button next to a field that isn't a text input. This wrapper supports working with text; the full GTK4 clipboard also supports arbitrary data types (images, etc.) through a broader API not included in this minimal set.

### `gdk_display_get_clipboard`

```nim
proc gdk_display_get_clipboard*(display: pointer): GdkClipboard
```

**What it does.** Returns the system clipboard object for the given display (the same `GdkDisplay` as in `gtk_style_context_add_provider_for_display` from the drawing and GLib-utilities reference) — shared one per display, not one per window. The display is usually obtained via `gtk_widget_get_display` for a specific widget, or `gdk_display_get_default()`.

- `display` — the display object (`GdkDisplay`, cast to `pointer`).

```nim
let clipboard = gdk_display_get_clipboard(gdk_display_get_default())
echo "System clipboard object obtained"
```

---

### `gdk_clipboard_set_text`

```nim
proc gdk_clipboard_set_text*(clipboard: GdkClipboard, text: cstring)
```

**What it does.** Copies a text string to the clipboard — a programmatic equivalent of `Ctrl+C` for arbitrary text, not necessarily selected in a text field (for example, copying a link on a "Share" button click).

- `clipboard` — the clipboard object.
- `text` — the text to copy.

```nim
gdk_clipboard_set_text(clipboard, "https://example.com/shared-link")
echo "Link copied to the clipboard"
```

---

### `gdk_clipboard_read_text_async` / `gdk_clipboard_read_text_finish`

```nim
proc gdk_clipboard_read_text_async*(clipboard: GdkClipboard, cancellable: pointer, callback: GAsyncReadyCallback, userData: gpointer)
proc gdk_clipboard_read_text_finish*(clipboard: GdkClipboard, res: pointer, error: ptr GError): cstring
```

**What it does.** Asynchronously reads text from the clipboard — reading is necessarily asynchronous (unlike `set_text`, which works synchronously), since in the general case the clipboard's contents may belong to a different process, and obtaining them requires inter-process communication that must not block the UI. `read_text_async` starts the operation and returns control immediately; when the result is ready, `callback` is invoked (the standard `GAsyncReadyCallback` pattern from GIO), inside of which `read_text_finish` must be called to obtain the resulting string (or an error via `error`, if the read failed — for example, there was no text on the clipboard).

- `clipboard` — the clipboard object.
- `cancellable` — a cancellation object (`nil` can be passed).
- `callback` — the callback function invoked when the read completes.
- `userData` — user data passed to `callback`.
- `res` (for `finish`) — the async-operation result object received in `callback`.
- `error` (for `finish`) — a pointer to receive an error.

```nim
proc onClipboardReadReady(sourceObject: pointer, res: pointer, userData: gpointer) {.cdecl.} =
  var err: ptr GError = nil
  let text = gdk_clipboard_read_text_finish(cast[GdkClipboard](sourceObject), res, addr err)
  if isNil(err):
    echo "Text read from the clipboard: ", $text
  else:
    echo "Failed to read text from the clipboard"
    g_error_free(err[])

gdk_clipboard_read_text_async(clipboard, nil, onClipboardReadReady, nil)
echo "Asynchronous clipboard read started"
```

---

## GdkPixbuf

`GdkPixbuf` — an in-memory raster image geared toward programmatic pixel manipulation (CPU-side): loading from a file, scaling, saving back to a file. For displaying an image on screen without further processing, `GdkTexture` (section VII) is more commonly used — either directly, or converted from a `GdkPixbuf` via `gdk_texture_new_for_pixbuf`.

### `gdk_pixbuf_new` / `gdk_pixbuf_new_from_file`

```nim
proc gdk_pixbuf_new*(colorspace: gint, hasAlpha: gboolean, bitsPerSample: gint, width: gint, height: gint): GdkPixbuf
proc gdk_pixbuf_new_from_file*(filename: cstring, error: ptr GError): GdkPixbuf
```

**What it does.** `gdk_pixbuf_new` creates an empty in-memory image of the given size, filled with undefined data (for subsequent programmatic pixel filling — accessing the pixel buffer itself requires additional functions not covered in this reference). `colorspace` — the color space (in practice almost always the only supported value, `GDK_COLORSPACE_RGB`, equal to `0`). `bitsPerSample` — almost always `8` (the standard 8 bits per channel). `gdk_pixbuf_new_from_file` is by far the more common way to obtain a `GdkPixbuf`: synchronously loading and decoding an image from a file on disk.

- `colorspace` — the color space (usually `0` for RGB).
- `hasAlpha` — `1.gboolean` if the image should have an alpha channel.
- `bitsPerSample` — bits per channel (usually `8`).
- `width`, `height` — the image size in pixels.
- `filename` — the path to the image file (for `new_from_file`).
- `error` — a pointer to receive an error (`nil` can be passed).

```nim
var err: ptr GError = nil
let photo = gdk_pixbuf_new_from_file("/home/user/Pictures/photo.jpg", addr err)
if isNil(err):
  echo "Image loaded and decoded into memory"
else:
  echo "Failed to load the image"
  g_error_free(err[])
```

---

### `gdk_pixbuf_get_width` / `gdk_pixbuf_get_height`

```nim
proc gdk_pixbuf_get_width*(pixbuf: GdkPixbuf): gint
proc gdk_pixbuf_get_height*(pixbuf: GdkPixbuf): gint
```

**What it does.** Returns the image's actual size in pixels — for example, to compute a proportional size for subsequent scaling via `gdk_pixbuf_scale_simple`.

- `pixbuf` — the image.

```nim
echo "Size of the loaded photo: ", gdk_pixbuf_get_width(photo), "×", gdk_pixbuf_get_height(photo)
```

---

### `gdk_pixbuf_scale_simple`

```nim
proc gdk_pixbuf_scale_simple*(src: GdkPixbuf, destWidth: gint, destHeight: gint, interpType: gint): GdkPixbuf
```

**What it does.** Creates a **new** image — a scaled copy of the original at the given size (the original image is left unchanged). `interpType` — the interpolation method used when scaling (`GDK_INTERP_*` values, not set up as a separate enum type in this wrapper — in practice `GDK_INTERP_BILINEAR`, equal to `2`, gives a good balance of quality and speed for most cases; `GDK_INTERP_NEAREST` = `0` is faster but gives a jagged result).

- `src` — the source image.
- `destWidth`, `destHeight` — the result's size in pixels.
- `interpType` — the interpolation method.

```nim
let thumbnail = gdk_pixbuf_scale_simple(photo, 128, 128, 2)  # 2 = GDK_INTERP_BILINEAR
echo "128×128 thumbnail created from the full-size photo"
```

---

### `gdk_pixbuf_savev`

```nim
proc gdk_pixbuf_savev*(pixbuf: GdkPixbuf, filename: cstring, `type`: cstring, optionKeys: ptr cstring, optionValues: ptr cstring, error: ptr GError): gboolean
```

**What it does.** Saves the image to a file in the given format. `type` — the string format identifier (`"png"`, `"jpeg"`, `"bmp"`, etc.). `optionKeys`/`optionValues` — two parallel `NULL`-terminated string arrays for format-specific save parameters (for example, for JPEG — `"quality"` with a value of `"90"`); if no extra parameters are needed, both arrays can each consist of a single `nil`.

- `pixbuf` — the image.
- `filename` — the path to save to.
- `type` — the format string.
- `optionKeys`, `optionValues` — parallel arrays of format parameters, both terminated by `nil`.
- `error` — a pointer to receive an error.

```nim
var noOptions: array[1, cstring] = [cstring(nil)]
var err: ptr GError = nil
let saved = gdk_pixbuf_savev(thumbnail, "/home/user/.cache/myapp/thumb.png", "png",
                              addr noOptions[0], addr noOptions[0], addr err)
echo "Thumbnail saved: ", saved != 0.gboolean
```

---

### `gdk_pixbuf_new_from_stream` / `g_memory_input_stream_new_from_bytes`

```nim
proc gdk_pixbuf_new_from_stream*(stream: pointer, cancellable: pointer, error: ptr GError): GdkPixbuf
proc g_memory_input_stream_new_from_bytes*(bytes: GBytes): pointer
```

**What it does.** `gdk_pixbuf_new_from_stream` decodes an image not from a file on disk but from an arbitrary GIO input stream (`GInputStream`) — for example, data downloaded over the network or embedded in the application binary via GResource. `g_memory_input_stream_new_from_bytes` is a way to get such a stream from bytes already in memory (`GBytes`), when the source image data isn't directly tied to a file or a network connection.

- `stream` — the input stream (`GInputStream`).
- `cancellable` — a cancellation object (`nil` can be passed).
- `error` — a pointer to receive an error.
- `bytes` — a `GBytes` object holding the image data in memory.

```nim
# imageBytes — GBytes with image data already in memory
# (e.g. embedded in the binary via GResource)
let stream = g_memory_input_stream_new_from_bytes(imageBytes)
var err: ptr GError = nil
let decodedImage = gdk_pixbuf_new_from_stream(stream, nil, addr err)
echo "Image decoded from in-memory data, without a file on disk"
```

---

### Incremental loading: `gdk_pixbuf_loader_new` and related functions

```nim
proc gdk_pixbuf_loader_new*(): pointer
proc gdk_pixbuf_loader_write*(loader: pointer, buf: ptr uint8, count: csize_t, error: ptr GError): gboolean
proc gdk_pixbuf_loader_close*(loader: pointer, error: ptr GError): gboolean
proc gdk_pixbuf_loader_get_pixbuf*(loader: pointer): GdkPixbuf
```

**What it does.** `GdkPixbufLoader` decodes an image incrementally, as bytes become available — for example, when streaming a file download over the network, where all the data isn't available in memory at once. `gdk_pixbuf_loader_new` creates the loader; `gdk_pixbuf_loader_write` feeds it the next chunk of bytes (can be called repeatedly as data arrives); `gdk_pixbuf_loader_close` tells the loader the data has ended and finishes decoding; `gdk_pixbuf_loader_get_pixbuf` returns the resulting image — it can be called even before `close` if the format supports progressive loading (in which case it returns the image in its current, still-incomplete state), but a guaranteed complete image is only available after `close`.

- `loader` — the loader object.
- `buf` — a pointer to the byte buffer for the next chunk of data.
- `count` — the number of bytes in `buf`.
- `error` — a pointer to receive an error.

```nim
let loader = gdk_pixbuf_loader_new()
var err: ptr GError = nil
# chunk — the next chunk of bytes, e.g. received from a network socket
discard gdk_pixbuf_loader_write(loader, addr chunk[0], csize_t(chunk.len), addr err)
# ... repeated calls to write as further chunks of data arrive ...
discard gdk_pixbuf_loader_close(loader, addr err)
let streamedImage = gdk_pixbuf_loader_get_pixbuf(loader)
echo "Image fully decoded from streamed data"
```

---

## GdkTexture

`GdkTexture` — a GPU-oriented image representation, optimal for on-screen display (implements the `GdkPaintable` interface, the same one accepted by `gtk_image_new_from_paintable`/`gtk_picture_set_paintable` from earlier references). Unlike `GdkPixbuf`, it isn't meant for programmatic pixel modification after creation — only for display.

### `gdk_texture_new_for_pixbuf`

```nim
proc gdk_texture_new_for_pixbuf*(pixbuf: GdkPixbuf): GdkTexture
```

**What it does.** Converts an already loaded/processed `GdkPixbuf` into a `GdkTexture` for on-screen display — the typical final step after programmatic image processing (scaling, cropping) via the `GdkPixbuf` functions from section VI, before passing the result to `GtkPicture`/`GtkImage`.

- `pixbuf` — the source image.

```nim
let texture = gdk_texture_new_for_pixbuf(thumbnail)
gtk_picture_set_paintable(thumbnailView, cast[pointer](texture))
echo "Processed thumbnail converted to a texture and shown in a GtkPicture"
```

---

### `gdk_texture_new_from_file` / `gdk_texture_new_from_filename`

```nim
proc gdk_texture_new_from_file*(file: GFile, error: ptr GError): GdkTexture
proc gdk_texture_new_from_filename*(filename: cstring, error: pointer): GdkTexture
```

**What it does.** Loads an image directly into a `GdkTexture`, bypassing an intermediate `GdkPixbuf` — shorter and more efficient when the image doesn't need programmatic processing before display (simply showing the file as-is). `new_from_file` takes a `GFile` object; `new_from_filename` takes a path string directly.

- `file` — the `GFile` object (for `new_from_file`).
- `filename` — the file path (for `new_from_filename`).
- `error` — a pointer to receive an error.

```nim
var err: ptr GError = nil
let iconTexture = gdk_texture_new_from_filename("/usr/share/myapp/splash.png", addr err)
echo "Splash image loaded directly into a texture"
```

---

### `gdk_texture_get_width` / `gdk_texture_get_height`

```nim
proc gdk_texture_get_width*(texture: GdkTexture): gint
proc gdk_texture_get_height*(texture: GdkTexture): gint
```

**What it does.** Returns the texture's size in pixels — the same logic as `gdk_pixbuf_get_width`/`get_height`, but for `GdkTexture`.

- `texture` — the texture.

```nim
echo "Size of the loaded texture: ", gdk_texture_get_width(iconTexture), "×", gdk_texture_get_height(iconTexture)
```

---

### `gdk_texture_new_from_bytes` / `g_bytes_new_static` / `g_bytes_unref`

```nim
proc gdk_texture_new_from_bytes*(bytes: GBytes, error: ptr GError): GdkTexture
proc g_bytes_new_static*(data: pointer, size: csize_t): GBytes
proc g_bytes_unref*(bytes: GBytes)
```

**What it does.** `gdk_texture_new_from_bytes` creates a texture directly from image bytes in memory (still encoded — PNG/JPEG etc., as if it were the contents of a file rather than already-decoded pixels), without requiring an intermediate file on disk. `g_bytes_new_static` wraps a region of bytes already present in memory (for example, a resource embedded in the binary) into a `GBytes` object without copying the data — suitable only for data guaranteed to remain valid for the entire lifetime of the `GBytes` (for example, statically linked resources), unlike temporary buffers. `g_bytes_unref` releases the `GBytes` when it's no longer needed — like most GObject-compatible types, `GBytes` is reference-counted (see `g_object_unref` in the drawing and GLib-utilities reference, though formally `GBytes` is not a `GObject` but GLib's own refcounted type with a similar ownership model).

- `bytes` — the `GBytes` object holding the image data.
- `data` — a pointer to the data in memory (for `new_static`).
- `size` — the size of the data in bytes.

```nim
# embeddedIconData — a static byte array embedded in the application binary
let iconBytes = g_bytes_new_static(addr embeddedIconData[0], csize_t(embeddedIconData.len))
var err: ptr GError = nil
let embeddedTexture = gdk_texture_new_from_bytes(iconBytes, addr err)
g_bytes_unref(iconBytes)
echo "Texture created from data embedded in the binary, without touching the filesystem"
```

---

## Practical recipes

### About dialog with a full set of information

All the main fields filled in one pass, shown when the user clicks the app's menu item.

```nim
proc showAboutDialog(parent: GtkWindow) =
  let about = gtk_about_dialog_new()
  gtk_window_set_transient_for(about, parent)
  gtk_window_set_modal(about, 1.gboolean)

  gtk_about_dialog_set_program_name(about, "Project Editor")
  gtk_about_dialog_set_version(about, "1.3.0")
  gtk_about_dialog_set_copyright(about, "© 2026 Your Company")
  gtk_about_dialog_set_comments(about, "A simple editor for quick project work")
  gtk_about_dialog_set_website(about, "https://example.com")
  gtk_about_dialog_set_website_label(about, "Project website")
  gtk_about_dialog_set_logo_icon_name(about, "accessories-text-editor")

  var authorsArray = [cstring("Ivan Petrov"), cstring("Anna Sidorova"), nil]
  gtk_about_dialog_set_authors(about, addr authorsArray[0])
  gtk_about_dialog_set_license(about, "Distributed under the MIT license.")

  gtk_window_present(about)
  echo "'About' dialog with all information shown"

# showAboutDialog(mainWindow)
```

---

### Accent color picker button with a dialog

A button that opens the color-picker dialog and stores the chosen value.

```nim
var selectedAccentColor: array[4, gdouble] = [0.2, 0.5, 0.9, 1.0]  # initial blue color

proc onColorButtonClicked(button: GtkButton, userData: gpointer) {.cdecl.} =
  let dialog = gtk_color_chooser_dialog_new("Choose an accent color", cast[GtkWindow](userData))
  gtk_color_chooser_set_rgba(dialog, addr selectedAccentColor[0])

  proc onResponse(d: GtkColorChooserDialog, responseId: gint, ud: gpointer) {.cdecl.} =
    if responseId == ord(GTK_RESPONSE_ACCEPT).gint:
      gtk_color_chooser_get_rgba(d, addr selectedAccentColor[0])
      echo "New accent color saved"
    gtk_window_destroy(cast[GtkWindow](d))

  discard g_signal_connect(dialog, "response", onResponse, nil)
  gtk_window_present(dialog)

let colorButton = gtk_button_new_with_label("Accent color...")
discard g_signal_connect(colorButton, "clicked", onColorButtonClicked, cast[gpointer](mainWindow))
```

---

### Copying text to the clipboard and reading it back

A "Copy" button, and a separate "Paste" button that asynchronously reads the clipboard's contents.

```nim
proc onCopyClicked(button: GtkButton, userData: gpointer) {.cdecl.} =
  let clipboard = gdk_display_get_clipboard(gdk_display_get_default())
  gdk_clipboard_set_text(clipboard, "Text copied programmatically")
  echo "Text copied to the system clipboard"

proc onClipboardReadReady(sourceObject: pointer, res: pointer, userData: gpointer) {.cdecl.} =
  var err: ptr GError = nil
  let text = gdk_clipboard_read_text_finish(cast[GdkClipboard](sourceObject), res, addr err)
  if isNil(err):
    echo "Pasted from the clipboard: ", $text
  else:
    g_error_free(err[])

proc onPasteClicked(button: GtkButton, userData: gpointer) {.cdecl.} =
  let clipboard = gdk_display_get_clipboard(gdk_display_get_default())
  gdk_clipboard_read_text_async(clipboard, nil, onClipboardReadReady, nil)
```

---

### Shrinking an image before saving it as a thumbnail

The full chain: load the full-size image → scale it → save it to a file.

```nim
proc createThumbnail(sourcePath, thumbPath: string, size: int): bool =
  var err: ptr GError = nil
  let original = gdk_pixbuf_new_from_file(sourcePath.cstring, addr err)
  if not isNil(err):
    echo "Failed to load the source image"
    g_error_free(err[])
    return false

  let thumbnail = gdk_pixbuf_scale_simple(original, size.gint, size.gint, 2)  # 2 = GDK_INTERP_BILINEAR

  var noOptions: array[1, cstring] = [cstring(nil)]
  var saveErr: ptr GError = nil
  result = gdk_pixbuf_savev(thumbnail, thumbPath.cstring, "png",
                            addr noOptions[0], addr noOptions[0], addr saveErr) != 0.gboolean
  if result:
    echo "Thumbnail ", size, "×", size, " saved to ", thumbPath
  else:
    g_error_free(saveErr[])

discard createThumbnail("/home/user/Pictures/photo.jpg", "/home/user/.cache/myapp/thumb.png", 128)
```

---

### Incrementally loading an image from a data stream arriving in chunks

Decoding an image as network data arrives, without waiting for the full load into memory ahead of time.

```nim
proc buildStreamingImageLoader(): pointer =
  result = gdk_pixbuf_loader_new()
  echo "Image loader created, ready to accept chunks of data"

proc feedChunk(loader: pointer, chunk: seq[uint8]) =
  var err: ptr GError = nil
  discard gdk_pixbuf_loader_write(loader, unsafeAddr chunk[0], csize_t(chunk.len), addr err)
  if not isNil(err):
    echo "Error while decoding the next chunk of data"
    g_error_free(err[])

proc finishStreamingLoad(loader: pointer): GdkPixbuf =
  var err: ptr GError = nil
  discard gdk_pixbuf_loader_close(loader, addr err)
  result = gdk_pixbuf_loader_get_pixbuf(loader)
  echo "Loading finished, final image obtained"

let loader = buildStreamingImageLoader()
# feedChunk(loader, receivedNetworkChunk) — called as data arrives from the network
# let finalImage = finishStreamingLoad(loader) — after all data has been received
```

---

## Quick reference table

| Procedure(s) | Category | What it does in brief |
|---|---|---|
| `gtk_about_dialog_new` | AboutDialog | Create the "About" dialog |
| `gtk_about_dialog_set/get_program_name`, `version`, `copyright`, `comments` | AboutDialog | Main text fields |
| `gtk_about_dialog_set/get_license` | AboutDialog | Full license text |
| `gtk_about_dialog_set/get_website`, `website_label` | AboutDialog | Link to the project website |
| `gtk_about_dialog_set/get_authors` | AboutDialog | List of authors (NULL-terminated array) |
| `gtk_about_dialog_set/get_logo`, `logo_icon_name` | AboutDialog | Logo — as an image or theme icon |
| `gtk_color_chooser_dialog_new` | ColorChooserDialog | Create the color-picker dialog |
| `gtk_color_chooser_get/set_rgba` | ColorChooserDialog | Current color via GdkRGBA |
| `gtk_color_chooser_set/get_use_alpha` | ColorChooserDialog | Allow configuring transparency |
| `gtk_font_chooser_dialog_new` | FontChooserDialog | Create the font-picker dialog |
| `gtk_font_chooser_get/set_font` | FontChooserDialog | Font as a Pango description string |
| `gtk_font_chooser_get/set_font_desc` | FontChooserDialog | Font as a structured PangoFontDescription |
| `gtk_font_chooser_get/set_preview_text` | FontChooserDialog | Font preview text |
| `gtk_gl_area_new` | GLArea | Create the OpenGL rendering area |
| `gtk_gl_area_make_current`, `queue_render`, `attach_buffers` | GLArea | Context and redraw management |
| `gtk_gl_area_set/get_required_version` | GLArea | Minimum required OpenGL version |
| `gtk_gl_area_set/get_has_depth/stencil_buffer` | GLArea | Depth and stencil buffers |
| `gdk_display_get_clipboard` | Clipboard | Get the display's clipboard object |
| `gdk_clipboard_set_text` | Clipboard | Copy text programmatically |
| `gdk_clipboard_read_text_async/finish` | Clipboard | Asynchronously read text from the clipboard |
| `gdk_pixbuf_new`, `new_from_file` | Pixbuf | Create empty / load from file |
| `gdk_pixbuf_get_width/height` | Pixbuf | Image size |
| `gdk_pixbuf_scale_simple` | Pixbuf | A scaled copy of the image |
| `gdk_pixbuf_savev` | Pixbuf | Save the image to a file |
| `gdk_pixbuf_new_from_stream`, `g_memory_input_stream_new_from_bytes` | Pixbuf | Decoding from a stream/memory |
| `gdk_pixbuf_loader_new`, `write`, `close`, `get_pixbuf` | Pixbuf | Incremental (streaming) loading |
| `gdk_texture_new_for_pixbuf` | Texture | Convert a GdkPixbuf into a texture |
| `gdk_texture_new_from_file/filename` | Texture | Load an image directly into a texture |
| `gdk_texture_get_width/height` | Texture | Texture size |
| `gdk_texture_new_from_bytes`, `g_bytes_new_static/unref` | Texture | Texture from bytes in memory |

---

## Summary: which procedure to choose

- **Display an image on screen without programmatic processing** → `GdkTexture` directly (`gdk_texture_new_from_file`/`_from_filename`), not `GdkPixbuf` — shorter and more efficient, since `GdkTexture` is already optimized for display.
- **The image needs to be processed first** (scaled, cropped, saved in a different format) → `GdkPixbuf`, and only once processing is complete — convert to `GdkTexture` via `gdk_texture_new_for_pixbuf` to display the result.
- **Image data arrives in pieces** (network, stream) → `GdkPixbufLoader` (`gdk_pixbuf_loader_new`/`write`/`close`), rather than waiting for all the bytes to fully load into memory before decoding.
- **Copy/paste text programmatically, not via selection in a text field** → `GdkClipboard` (`gdk_clipboard_set_text`/`read_text_async`), rather than trying to emulate `Ctrl+C`/`Ctrl+V` with synthetic keyboard events.
- **Color/font picker dialog** → the ready-made `GtkColorChooserDialog`/`GtkFontChooserDialog`, rather than a custom `GtkDialog` with a hand-built picker widget — the system dialogs already give a familiar interface and a live preview.
- **Font handling only at the "pick and apply" level** → the string-based `gtk_font_chooser_get/set_font` (Pango format). **Programmatic parsing of individual font components** (family separate from size) → the structured `get/set_font_desc`.
- **3D graphics or complex custom rendering for which Cairo (GtkDrawingArea) isn't performant enough** → `GtkGLArea` with direct OpenGL calls, with a mandatory check of `set_required_version` against the needs of the shader code being used.
