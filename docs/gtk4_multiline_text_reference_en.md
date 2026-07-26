# GTK4 (multiline text: GtkTextBuffer / GtkTextView) — module reference

> **Import:** `import libGTK4`
> **Scope:** multiline text — the data model (`GtkTextBuffer`) and its visual representation (`GtkTextView`). Fourth part of the wrapper reference series; assumes familiarity with the previous parts (`gtk4_core_reference_ru.md`, `gtk4_basic_controls_reference_ru.md`, `gtk4_text_input_reference_ru.md`).

An important difference from single-line fields (the text input reference): for multiline text in GTK4, the data model (`GtkTextBuffer` — the text itself, its formatting, its tags) and the display widget (`GtkTextView` — how that text is shown on screen: line wrapping, margins, the cursor) are two separate objects. The same buffer can be shown in several `GtkTextView`s at once (they will all reflect the same text in sync) — somewhat like `GtkEntryBuffer` for `GtkEntry`, but with a much richer model.

A position within the text in this API is given not by a number (a character index) but by a `GtkTextIter` ("iterator") structure — many functions on both `GtkTextBuffer` and `GtkTextView` take and fill in a `ptr GtkTextIter`. In this wrapper, `GtkTextIter` is a fixed-size structure that you need to declare as an ordinary Nim variable (`var iter: GtkTextIter`) and pass by address (`addr iter`) — GTK itself fills in its contents; calling code does not need to, and should not, construct an iterator "from scratch" by hand.

---

## Table of contents

I. [GtkTextBuffer](#gtktextbuffer)
&nbsp;&nbsp;1. [`gtk_text_buffer_new`](#gtk_text_buffer_new)
&nbsp;&nbsp;2. [`gtk_text_buffer_set_text` / `gtk_text_buffer_get_text` / `gtk_text_buffer_get_slice`](#gtk_text_buffer_set_text--gtk_text_buffer_get_text--gtk_text_buffer_get_slice)
&nbsp;&nbsp;3. [`gtk_text_buffer_insert` / `gtk_text_buffer_insert_at_cursor` / `_range`](#gtk_text_buffer_insert--gtk_text_buffer_insert_at_cursor--_range)
&nbsp;&nbsp;4. [Interactive insert and delete: the `_interactive` variants](#interactive-insert-and-delete-the-_interactive-variants)
&nbsp;&nbsp;5. [`gtk_text_buffer_delete` / `gtk_text_buffer_backspace`](#gtk_text_buffer_delete--gtk_text_buffer_backspace)
&nbsp;&nbsp;6. [`gtk_text_buffer_get_char_count` / `gtk_text_buffer_get_line_count`](#gtk_text_buffer_get_char_count--gtk_text_buffer_get_line_count)
&nbsp;&nbsp;7. [Obtaining iterators: `get_start_iter` and related functions](#obtaining-iterators-get_start_iter-and-related-functions)
&nbsp;&nbsp;8. [Marks: `create_mark` and related functions](#marks-create_mark-and-related-functions)
&nbsp;&nbsp;9. [`gtk_text_buffer_place_cursor` / `gtk_text_buffer_select_range`](#gtk_text_buffer_place_cursor--gtk_text_buffer_select_range)
&nbsp;&nbsp;10. [Selection: `get_selection_bounds` / `get_has_selection` / `delete_selection`](#selection-get_selection_bounds--get_has_selection--delete_selection)
&nbsp;&nbsp;11. [Formatting tags: `apply_tag` and related functions](#formatting-tags-apply_tag-and-related-functions)
&nbsp;&nbsp;12. [Anchors for child widgets and images](#anchors-for-child-widgets-and-images)
&nbsp;&nbsp;13. [Clipboard: `cut/copy/paste_clipboard`](#clipboard-cutcopypaste_clipboard)
&nbsp;&nbsp;14. [The modified flag: `gtk_text_buffer_set/get_modified`](#the-modified-flag-gtk_text_buffer_setget_modified)
&nbsp;&nbsp;15. [Buffer undo/redo](#buffer-undoredo)

II. [GtkTextView](#gtktextview)
&nbsp;&nbsp;1. [`gtk_text_view_new` / `gtk_text_view_new_with_buffer`](#gtk_text_view_new--gtk_text_view_new_with_buffer)
&nbsp;&nbsp;2. [`gtk_text_view_set_buffer` / `gtk_text_view_get_buffer`](#gtk_text_view_set_buffer--gtk_text_view_get_buffer)
&nbsp;&nbsp;3. [`gtk_text_view_set_editable` / `gtk_text_view_get_editable`](#gtk_text_view_set_editable--gtk_text_view_get_editable)
&nbsp;&nbsp;4. [`gtk_text_view_set_wrap_mode` / `gtk_text_view_get_wrap_mode`](#gtk_text_view_set_wrap_mode--gtk_text_view_get_wrap_mode)
&nbsp;&nbsp;5. [`gtk_text_view_set_cursor_visible` / `gtk_text_view_get_cursor_visible`](#gtk_text_view_set_cursor_visible--gtk_text_view_get_cursor_visible)
&nbsp;&nbsp;6. [`gtk_text_view_set_monospace` / `gtk_text_view_get_monospace`](#gtk_text_view_set_monospace--gtk_text_view_get_monospace)
&nbsp;&nbsp;7. [Margins and alignment: margins, indent, justification](#margins-and-alignment-margins-indent-justification)
&nbsp;&nbsp;8. [`gtk_text_view_set_tabs` / `gtk_text_view_get_tabs`](#gtk_text_view_set_tabs--gtk_text_view_get_tabs)
&nbsp;&nbsp;9. [`gtk_text_view_set_accepts_tab` / `gtk_text_view_get_accepts_tab`](#gtk_text_view_set_accepts_tab--gtk_text_view_get_accepts_tab)
&nbsp;&nbsp;10. [`gtk_text_view_set_overwrite` / `gtk_text_view_get_overwrite`](#gtk_text_view_set_overwrite--gtk_text_view_get_overwrite)
&nbsp;&nbsp;11. [`gtk_text_view_set_input_purpose` / `get_input_purpose` / `set_input_hints` / `get_input_hints`](#gtk_text_view_set_input_purpose--get_input_purpose--set_input_hints--get_input_hints)
&nbsp;&nbsp;12. [Scrolling to a position: `scroll_to_mark` / `scroll_to_iter` / `scroll_mark_onscreen`](#scrolling-to-a-position-scroll_to_mark--scroll_to_iter--scroll_mark_onscreen)
&nbsp;&nbsp;13. [Coordinate conversion: `get_iter_at_location` and related functions](#coordinate-conversion-get_iter_at_location-and-related-functions)
&nbsp;&nbsp;14. [`gtk_text_view_set_gutter` / `gtk_text_view_get_gutter`](#gtk_text_view_set_gutter--gtk_text_view_get_gutter)
&nbsp;&nbsp;15. [`gtk_text_view_set_extra_menu` / `gtk_text_view_get_extra_menu`](#gtk_text_view_set_extra_menu--gtk_text_view_get_extra_menu)
&nbsp;&nbsp;16. [Embedding widgets: `add_child_at_anchor` / `add_overlay` / `move_overlay` / `remove`](#embedding-widgets-add_child_at_anchor--add_overlay--move_overlay--remove)
&nbsp;&nbsp;17. [Navigating by display lines: `forward/backward_display_line` and related functions](#navigating-by-display-lines-forwardbackward_display_line-and-related-functions)
&nbsp;&nbsp;18. [`gtk_text_view_get_cursor_locations`](#gtk_text_view_get_cursor_locations)
&nbsp;&nbsp;19. [`gtk_text_view_reset_im_context` / `gtk_text_view_im_context_filter_keypress`](#gtk_text_view_reset_im_context--gtk_text_view_im_context_filter_keypress)

III. [Practical recipes](#practical-recipes)
&nbsp;&nbsp;1. [A simple multiline editor with wrapping and margins](#a-simple-multiline-editor-with-wrapping-and-margins)
&nbsp;&nbsp;2. [Highlighting part of the text via tags](#highlighting-part-of-the-text-via-tags)
&nbsp;&nbsp;3. [An unsaved-changes indicator via the modified flag](#an-unsaved-changes-indicator-via-the-modified-flag)
&nbsp;&nbsp;4. [A read-only field with a monospace font (log viewer)](#a-read-only-field-with-a-monospace-font-log-viewer)
&nbsp;&nbsp;5. [Grouping edits into a single undo operation](#grouping-edits-into-a-single-undo-operation)

IV. [Summary table](#summary-table)

V. [Summary: which procedure to choose](#summary-which-procedure-to-choose)

---

## GtkTextBuffer

`GtkTextBuffer` stores the text itself, its formatting (via tags — `GtkTextTag`), and named positions within the text (marks — `GtkTextMark`), but knows nothing about how it should be drawn on screen — rendering is the responsibility of `GtkTextView` (section II).

### `gtk_text_buffer_new`

```nim
proc gtk_text_buffer_new*(table: GtkTextTagTable): GtkTextBuffer
```

**What it does.** Creates an empty text buffer. `table` is the formatting tag table (`GtkTextTagTable`) that the buffer will use; passing `nil` creates a buffer with a new, empty tag table automatically — for most scenarios (including all the examples in this reference) this is sufficient, and creating a tag table by hand is not required.

- `table` — the tag table, or `nil` for an automatically-created empty table.

```nim
let buffer = gtk_text_buffer_new(nil)
echo "Empty text buffer created"
```

---

### `gtk_text_buffer_set_text` / `gtk_text_buffer_get_text` / `gtk_text_buffer_get_slice`

```nim
proc gtk_text_buffer_set_text*(buffer: GtkTextBuffer, text: cstring, len: gint)
proc gtk_text_buffer_get_text*(buffer: GtkTextBuffer, start: ptr GtkTextIter, `end`: ptr GtkTextIter, include_hidden_chars: gboolean): cstring
proc gtk_text_buffer_get_slice*(buffer: GtkTextBuffer, start: ptr GtkTextIter, `end`: ptr GtkTextIter, include_hidden_chars: gboolean): cstring
```

**What it does.** `set_text` replaces the buffer's entire text at once. `get_text` returns the text within a given range (`get_start_iter`/`get_end_iter` — for the whole text, see below); `get_slice`, unlike `get_text`, additionally substitutes a textual representation for non-text elements within the range — for example, embedded images — as a placeholder character. `include_hidden_chars` determines whether text marked with an invisibility tag (hidden text) is included in the result — for ordinary use, pass `1.gboolean`.

- `buffer` — the buffer.
- `text` — the new text (for `set_text`).
- `len` — the length of the text in bytes, or `-1` for an ordinary `NUL`-terminated string.
- `start`, `end` — iterators bounding the range to read.
- `include_hidden_chars` — `1.gboolean` to include text hidden by tags.

```nim
let buffer = gtk_text_buffer_new(nil)
gtk_text_buffer_set_text(buffer, "First line\nSecond line", -1)

var startIter, endIter: GtkTextIter
gtk_text_buffer_get_start_iter(buffer, addr startIter)
gtk_text_buffer_get_end_iter(buffer, addr endIter)
echo "Buffer text: ", $gtk_text_buffer_get_text(buffer, addr startIter, addr endIter, 1.gboolean)
```

---

### `gtk_text_buffer_insert` / `gtk_text_buffer_insert_at_cursor` / `_range`

```nim
proc gtk_text_buffer_insert*(buffer: GtkTextBuffer, iter: ptr GtkTextIter, text: cstring, len: gint)
proc gtk_text_buffer_insert_at_cursor*(buffer: GtkTextBuffer, text: cstring, len: gint)
proc gtk_text_buffer_insert_range*(buffer: GtkTextBuffer, iter: ptr GtkTextIter, start: ptr GtkTextIter, `end`: ptr GtkTextIter)
```

**What it does.** These insert text into the buffer without affecting the rest of the content. `gtk_text_buffer_insert` inserts at the given position (after insertion, `iter` is moved to the end of the inserted text). `insert_at_cursor` is a shorthand for the most common case — inserting at the current cursor position (the `"insert"` mark, see the section on marks). `insert_range` copies and inserts a range of text **from the same or a different buffer** — including that range's formatting tags, not just the bare text.

- `buffer` — the buffer.
- `iter` — the insertion position (for `insert`).
- `text` — the text to insert.
- `len` — length in bytes, or `-1`.
- `start`, `end` (for `insert_range`) — the source range to copy.

```nim
gtk_text_buffer_insert_at_cursor(buffer, "inserted text", -1)
echo "Text inserted at the current cursor position"
```

---

### Interactive insert and delete: the `_interactive` variants

```nim
proc gtk_text_buffer_insert_interactive*(buffer: GtkTextBuffer, iter: ptr GtkTextIter, text: cstring, len: gint, default_editable: gboolean): gboolean
proc gtk_text_buffer_insert_interactive_at_cursor*(buffer: GtkTextBuffer, text: cstring, len: gint, default_editable: gboolean): gboolean
proc gtk_text_buffer_insert_range_interactive*(buffer: GtkTextBuffer, iter: ptr GtkTextIter, start: ptr GtkTextIter, `end`: ptr GtkTextIter, default_editable: gboolean): gboolean
proc gtk_text_buffer_delete_interactive*(buffer: GtkTextBuffer, start_iter: ptr GtkTextIter, end_iter: ptr GtkTextIter, default_editable: gboolean): gboolean
```

**What it does.** The "interactive" versions of the insert/delete operations take into account whether the text in the affected range is tagged as non-editable (a `GtkTextTag` can individually forbid editing of the fragment it marks, even if the `GtkTextView` as a whole is editable — for example, for "locked" inserted quotes). `default_editable` is what counts as editable by default for text with no explicit tag on the matter (usually `1.gboolean`, if the buffer as a whole is meant to be editable). They return a `gboolean` — whether the operation succeeded in full; partial application (only to the editable fragments of the range) is also a normal outcome, and is not reported separately.

- **Implementation note.** The plain (non-interactive) `gtk_text_buffer_insert`/`delete` **always** performs the operation, ignoring non-editable tags — the interactive variants are needed specifically when an insert/delete is triggered by a user action (for example, inside a keyboard-input handler) and must respect tag-protected regions; for programmatic text modifications that bypass user input, the non-interactive versions are usually sufficient.

- `buffer` — the buffer.
- `default_editable` — `1.gboolean` if text with no explicit tag should be considered editable.

```nim
var cursorIter: GtkTextIter
gtk_text_buffer_get_iter_at_mark(buffer, addr cursorIter, gtk_text_buffer_get_insert(buffer))
let inserted = gtk_text_buffer_insert_interactive(buffer, addr cursorIter, "text from the user", -1, 1.gboolean)
echo "Insert performed: ", inserted != 0.gboolean
```

---

### `gtk_text_buffer_delete` / `gtk_text_buffer_backspace`

```nim
proc gtk_text_buffer_delete*(buffer: GtkTextBuffer, start: ptr GtkTextIter, `end`: ptr GtkTextIter)
proc gtk_text_buffer_backspace*(buffer: GtkTextBuffer, iter: ptr GtkTextIter, interactive: gboolean, default_editable: gboolean): gboolean
```

**What it does.** `delete` unconditionally removes the range of text between two iterators. `backspace` emulates exactly one press of the `Backspace` key at position `iter` — this is not simply "delete one character backward": for composite characters (multi-codepoint emoji, combining diacritical marks), `backspace` removes exactly what a single keypress would remove for the user, which can differ from deleting a single `gunichar`.

- `buffer` — the buffer.
- `start`, `end` (for `delete`) — the bounds of the range to delete.
- `iter` (for `backspace`) — the position before which the deletion happens (after the call, the iterator points to the new cursor position).
- `interactive`, `default_editable` (for `backspace`) — the same logic of respecting non-editable tags as in the `_interactive` variants above.

```nim
var start, stop: GtkTextIter
gtk_text_buffer_get_iter_at_offset(buffer, addr start, 0)
gtk_text_buffer_get_iter_at_offset(buffer, addr stop, 5)
gtk_text_buffer_delete(buffer, addr start, addr stop)
echo "First 5 characters of the buffer deleted"
```

---

### `gtk_text_buffer_get_char_count` / `gtk_text_buffer_get_line_count`

```nim
proc gtk_text_buffer_get_char_count*(buffer: GtkTextBuffer): gint
proc gtk_text_buffer_get_line_count*(buffer: GtkTextBuffer): gint
```

**What it does.** Return the total number of characters and the number of lines (separated by `\n`) in the buffer as a whole — faster than computing the same thing via `get_text` and manually counting, since it doesn't require copying the entire text.

- `buffer` — the buffer.

```nim
echo "The document has ", gtk_text_buffer_get_line_count(buffer), " lines, ",
     gtk_text_buffer_get_char_count(buffer), " characters"
```

---

### Obtaining iterators: `get_start_iter` and related functions

```nim
proc gtk_text_buffer_get_start_iter*(buffer: GtkTextBuffer, iter: ptr GtkTextIter)
proc gtk_text_buffer_get_end_iter*(buffer: GtkTextBuffer, iter: ptr GtkTextIter)
proc gtk_text_buffer_get_bounds*(buffer: GtkTextBuffer, start: ptr GtkTextIter, `end`: ptr GtkTextIter)
proc gtk_text_buffer_get_iter_at_line*(buffer: GtkTextBuffer, iter: ptr GtkTextIter, line_number: gint)
proc gtk_text_buffer_get_iter_at_offset*(buffer: GtkTextBuffer, iter: ptr GtkTextIter, char_offset: gint)
proc gtk_text_buffer_get_iter_at_line_offset*(buffer: GtkTextBuffer, iter: ptr GtkTextIter, line_number: gint, char_offset: gint)
proc gtk_text_buffer_get_iter_at_line_index*(buffer: GtkTextBuffer, iter: ptr GtkTextIter, line_number: gint, byte_index: gint)
proc gtk_text_buffer_get_iter_at_mark*(buffer: GtkTextBuffer, iter: ptr GtkTextIter, mark: GtkTextMark)
proc gtk_text_buffer_get_iter_at_child_anchor*(buffer: GtkTextBuffer, iter: ptr GtkTextIter, anchor: GtkTextChildAnchor)
```

**What it does.** All of these functions fill in a `GtkTextIter` passed by pointer, pointing it at a specific position in the text — this is the only way to obtain an iterator (you cannot construct one "from scratch" without a buffer). `get_start_iter`/`get_end_iter`/`get_bounds` — the start, the end, and both bounds of the entire text at once. `get_iter_at_offset` — the position at an absolute character number from the start of the text (analogous to `gtk_editable_set_position` for single-line fields, but for a buffer). `get_iter_at_line`/`get_iter_at_line_offset` — by line number (and, in the second case, a character offset within that line). `get_iter_at_line_index` is the same as `_line_offset`, but the offset is given in UTF-8 **bytes** rather than characters — rarely needed, mostly when integrating with code that operates on byte indices. `get_iter_at_mark`/`get_iter_at_child_anchor` — the position of a previously created mark/anchor (see the following subsections).

- `buffer` — the buffer.
- `iter` — pointer to the structure that will be filled in.
- `line_number` — the line number, starting at `0`.
- `char_offset` — the offset in characters.
- `byte_index` — the offset in UTF-8 bytes.
- `mark`, `anchor` — a previously created mark or anchor.

```nim
var lineStart: GtkTextIter
gtk_text_buffer_get_iter_at_line(buffer, addr lineStart, 1)  # start of the second line (0-based index)
echo "Iterator set to the start of the second line"
```

---

### Marks: `create_mark` and related functions

```nim
proc gtk_text_buffer_create_mark*(buffer: GtkTextBuffer, mark_name: cstring, where: ptr GtkTextIter, left_gravity: gboolean): GtkTextMark
proc gtk_text_buffer_add_mark*(buffer: GtkTextBuffer, mark: GtkTextMark, where: ptr GtkTextIter)
proc gtk_text_buffer_move_mark*(buffer: GtkTextBuffer, mark: GtkTextMark, where: ptr GtkTextIter)
proc gtk_text_buffer_move_mark_by_name*(buffer: GtkTextBuffer, name: cstring, where: ptr GtkTextIter)
proc gtk_text_buffer_delete_mark*(buffer: GtkTextBuffer, mark: GtkTextMark)
proc gtk_text_buffer_delete_mark_by_name*(buffer: GtkTextBuffer, name: cstring)
proc gtk_text_buffer_get_mark*(buffer: GtkTextBuffer, name: cstring): GtkTextMark
proc gtk_text_buffer_get_insert*(buffer: GtkTextBuffer): GtkTextMark
proc gtk_text_buffer_get_selection_bound*(buffer: GtkTextBuffer): GtkTextMark
```

**What it does.** A mark (`GtkTextMark`) is a named position within the text that, unlike `GtkTextIter`, **survives** subsequent editing of the text: if the text before the mark changes, the mark automatically "floats" along with the text surrounding it, staying at the same logical spot. `GtkTextIter`, by contrast, is a snapshot of a position at a specific moment, which becomes invalid immediately after any change to the buffer's text. Every buffer already contains two predefined marks, available via `get_insert` (the current cursor position) and `get_selection_bound` (the other end of the current selection, if any) — these are exactly the two marks that `place_cursor`/`select_range` use (next subsection). `left_gravity` determines which character the mark "sticks to" when text is inserted exactly at its position — `1.gboolean` means the inserted text ends up **after** the mark.

- `buffer` — the buffer.
- `mark_name` / `name` — the mark's name (you can pass `nil` for an anonymous mark, which can then only be referenced through the returned `GtkTextMark` object, not by name).
- `where` — the position to place/move the mark to.
- `left_gravity` — `1.gboolean`/`0.gboolean` (see above).
- `mark` — a mark object obtained from `create_mark`/`get_mark`/`get_insert`/`get_selection_bound`.

```nim
var savedPosition: GtkTextIter
gtk_text_buffer_get_iter_at_offset(buffer, addr savedPosition, 42)
let bookmark = gtk_text_buffer_create_mark(buffer, "bookmark-1", addr savedPosition, 1.gboolean)
# ... after arbitrary edits to the text elsewhere in the buffer ...
var restoredIter: GtkTextIter
gtk_text_buffer_get_iter_at_mark(buffer, addr restoredIter, bookmark)
echo "Bookmark restored to its former logical place, even though the text above it shifted"
```

---

### `gtk_text_buffer_place_cursor` / `gtk_text_buffer_select_range`

```nim
proc gtk_text_buffer_place_cursor*(buffer: GtkTextBuffer, where: ptr GtkTextIter)
proc gtk_text_buffer_select_range*(buffer: GtkTextBuffer, ins: ptr GtkTextIter, bound: ptr GtkTextIter)
```

**What it does.** `place_cursor` moves the cursor to the given position and clears any current selection (equivalent to a mouse click without Shift held). `select_range` moves the cursor to position `ins` and simultaneously selects the text from there to `bound` — if `ins` and `bound` coincide, this is equivalent to `place_cursor`. The parameter names correspond to the names of the predefined `"insert"` and `"selection_bound"` marks (see the previous subsection) — these are exactly the two marks this function repositions.

- `buffer` — the buffer.
- `where` (for `place_cursor`) — the new cursor position.
- `ins`, `bound` (for `select_range`) — the new cursor position and the other end of the selection.

```nim
var start, stop: GtkTextIter
gtk_text_buffer_get_iter_at_offset(buffer, addr start, 0)
gtk_text_buffer_get_iter_at_offset(buffer, addr stop, 13)
gtk_text_buffer_select_range(buffer, addr stop, addr start)  # select the first 13 characters
echo "First line selected programmatically"
```

---

### Selection: `get_selection_bounds` / `get_has_selection` / `delete_selection`

```nim
proc gtk_text_buffer_get_selection_bounds*(buffer: GtkTextBuffer, start: ptr GtkTextIter, `end`: ptr GtkTextIter): gboolean
proc gtk_text_buffer_get_has_selection*(buffer: GtkTextBuffer): gboolean
proc gtk_text_buffer_delete_selection*(buffer: GtkTextBuffer, interactive: gboolean, default_editable: gboolean): gboolean
```

**What it does.** These read the bounds of the current selection (`get_selection_bounds` fills in both iterators and returns a `gboolean` for whether there's a selection at all — the counterpart of `gtk_editable_get_selection_bounds` for single-line fields, but for a buffer), check merely whether a selection exists without retrieving its bounds (`get_has_selection` — faster when the bounds aren't needed), and delete the selected text (`delete_selection`, with the same `interactive`/`default_editable` logic as the other `_interactive` operations).

- `buffer` — the buffer.
- `start`, `end` — iterators that will receive the selection bounds.
- `interactive`, `default_editable` (for `delete_selection`) — see the subsection on interactive operations.

```nim
if gtk_text_buffer_get_has_selection(buffer) != 0.gboolean:
  discard gtk_text_buffer_delete_selection(buffer, 1.gboolean, 1.gboolean)
  echo "Selected text deleted"
```

---

### Formatting tags: `apply_tag` and related functions

```nim
proc gtk_text_buffer_apply_tag*(buffer: GtkTextBuffer, tag: GtkTextTag, start: ptr GtkTextIter, `end`: ptr GtkTextIter)
proc gtk_text_buffer_remove_tag*(buffer: GtkTextBuffer, tag: GtkTextTag, start: ptr GtkTextIter, `end`: ptr GtkTextIter)
proc gtk_text_buffer_apply_tag_by_name*(buffer: GtkTextBuffer, name: cstring, start: ptr GtkTextIter, `end`: ptr GtkTextIter)
proc gtk_text_buffer_remove_tag_by_name*(buffer: GtkTextBuffer, name: cstring, start: ptr GtkTextIter, `end`: ptr GtkTextIter)
proc gtk_text_buffer_remove_all_tags*(buffer: GtkTextBuffer, start: ptr GtkTextIter, `end`: ptr GtkTextIter)
proc gtk_text_buffer_get_tag_table*(buffer: GtkTextBuffer): GtkTextTagTable
```

**What it does.** `GtkTextTag` is a named set of formatting attributes (color, boldness, strikethrough, non-editability, and so on) that can be applied to an arbitrary range of text; the same tag can be applied to several non-adjacent ranges at once. `apply_tag`/`remove_tag` work with an already-created `GtkTextTag` object; the `_by_name` variants do the same by the name of a tag registered in the buffer's tag table (creating the tags themselves is done via `gtk_text_tag_new`/`gtk_text_tag_table_add`, which are outside the scope of this reference). `remove_all_tags` strips all tags from a range at once, regardless of which ones were applied. `get_tag_table` returns the buffer's tag table — the same one that could have been passed to `gtk_text_buffer_new`.

- `buffer` — the buffer.
- `tag` / `name` — the formatting tag (as an object or by name).
- `start`, `end` — the range to apply to.

```nim
# boldTag is created beforehand via gtk_text_tag_new("bold") + the "weight" property,
# then registered in the buffer's tag table
var start, stop: GtkTextIter
gtk_text_buffer_get_iter_at_offset(buffer, addr start, 0)
gtk_text_buffer_get_iter_at_offset(buffer, addr stop, 5)
gtk_text_buffer_apply_tag_by_name(buffer, "bold", addr start, addr stop)
echo "First 5 characters marked with the bold tag"
```

---

### Anchors for child widgets and images

```nim
proc gtk_text_buffer_create_child_anchor*(buffer: GtkTextBuffer, iter: ptr GtkTextIter): GtkTextChildAnchor
proc gtk_text_buffer_insert_markup*(buffer: GtkTextBuffer, iter: ptr GtkTextIter, markup: cstring, len: gint)
proc gtk_text_buffer_insert_paintable*(buffer: GtkTextBuffer, iter: ptr GtkTextIter, paintable: GdkPaintable)
```

**What it does.** `create_child_anchor` creates an "anchor" in the text — a special placeholder point into which an arbitrary widget can then be embedded via `gtk_text_view_add_child_at_anchor` (section II) — this is how, for example, buttons or mini-forms get inserted right in the middle of a paragraph. `insert_markup` inserts text with Pango markup (analogous to `gtk_label_set_markup`, but with the ability to insert at a specific spot in already-existing text rather than replacing all of the content). `insert_paintable` inserts a ready-made image (`GdkPaintable`) directly into the text stream.

- `buffer` — the buffer.
- `iter` — the insertion position.
- `markup` — text with Pango markup (for `insert_markup`).
- `paintable` — the image (for `insert_paintable`).

```nim
var endIter: GtkTextIter
gtk_text_buffer_get_end_iter(buffer, addr endIter)
let anchor = gtk_text_buffer_create_child_anchor(buffer, addr endIter)
echo "Anchor for embedding a widget created at the end of the text"
```

---

### Clipboard: `cut/copy/paste_clipboard`

```nim
proc gtk_text_buffer_cut_clipboard*(buffer: GtkTextBuffer, clipboard: GdkClipboard, default_editable: gboolean)
proc gtk_text_buffer_copy_clipboard*(buffer: GtkTextBuffer, clipboard: GdkClipboard)
proc gtk_text_buffer_paste_clipboard*(buffer: GtkTextBuffer, clipboard: GdkClipboard, override_location: ptr GtkTextIter, default_editable: gboolean)
```

**What it does.** Programmatically perform "Cut"/"Copy"/"Paste" on the buffer's current selection via the system clipboard — the same effect as the standard keyboard shortcuts, but invoked from code (for example, for your own "Copy" menu item instead of the standard one). `override_location` for `paste_clipboard` is an optional insertion position other than the current cursor position (`nil` — paste at the current cursor position, as usual).

- `buffer` — the buffer.
- `clipboard` — the clipboard object (usually obtained via `gtk_widget_get_clipboard` — outside the scope of this reference).
- `default_editable` — `1.gboolean` if text with no explicit tag should be considered editable.
- `override_location` — the insertion position, or `nil`.

```nim
# clipboard is obtained beforehand via gtk_widget_get_clipboard(textView)
gtk_text_buffer_copy_clipboard(buffer, clipboard)
echo "Selected text copied to the system clipboard"
```

---

### The modified flag: `gtk_text_buffer_set/get_modified`

```nim
proc gtk_text_buffer_set_modified*(buffer: GtkTextBuffer, setting: gboolean)
proc gtk_text_buffer_get_modified*(buffer: GtkTextBuffer): gboolean
```

**What it does.** GTK automatically sets this flag to `true` on any change to the buffer's text, whether made by the user or programmatically — a typical use is to show `"Document.txt •"` (with a dot/asterisk) instead of `"Document.txt"` in the window title while there are unsaved changes. After the document is saved, the application must reset the flag **itself** by calling `set_modified(buffer, 0.gboolean)` — GTK doesn't know that the content was saved to an external file, and does not reset the flag automatically.

- `buffer` — the buffer.
- `setting` — `0.gboolean`/`1.gboolean`.

```nim
proc onSave() =
  # ... write the buffer's text to a file ...
  gtk_text_buffer_set_modified(buffer, 0.gboolean)
  echo "Document saved, modified flag reset"

echo "Has unsaved changes: ", gtk_text_buffer_get_modified(buffer) != 0.gboolean
```

---

### Buffer undo/redo

```nim
proc gtk_text_buffer_set_enable_undo*(buffer: GtkTextBuffer, enable_undo: gboolean)
proc gtk_text_buffer_get_enable_undo*(buffer: GtkTextBuffer): gboolean
proc gtk_text_buffer_get_can_undo*(buffer: GtkTextBuffer): gboolean
proc gtk_text_buffer_get_can_redo*(buffer: GtkTextBuffer): gboolean
proc gtk_text_buffer_undo*(buffer: GtkTextBuffer)
proc gtk_text_buffer_redo*(buffer: GtkTextBuffer)
proc gtk_text_buffer_begin_irreversible_action*(buffer: GtkTextBuffer)
proc gtk_text_buffer_end_irreversible_action*(buffer: GtkTextBuffer)
proc gtk_text_buffer_begin_user_action*(buffer: GtkTextBuffer)
proc gtk_text_buffer_end_user_action*(buffer: GtkTextBuffer)
proc gtk_text_buffer_set_max_undo_levels*(buffer: GtkTextBuffer, max_undo_levels: guint)
proc gtk_text_buffer_get_max_undo_levels*(buffer: GtkTextBuffer): guint
```

**What it does.** Like `GtkEditable` (text input reference), `GtkTextBuffer` has built-in undo/redo support — enabled by default (`enable_undo`), so `Ctrl+Z`/`Ctrl+Shift+Z` work in `GtkTextView` with no extra code. `get_can_undo`/`get_can_redo` report whether undo/redo is available right now (for example, to enable/disable the corresponding menu items); `undo`/`redo` perform the operation programmatically. `begin_user_action`/`end_user_action` group several consecutive edit operations into a single history entry — for example, an autocorrect that deletes a word and inserts the corrected one would, without grouping, create two separate undo steps instead of one logical one. `begin_irreversible_action`/`end_irreversible_action` do the opposite: they mark the operations inside the block as not undoable at all (for example, programmatically loading a new document into an existing buffer, which should not be "undoable" back to the previous content). `max_undo_levels` limits the depth of the history (`0` — unlimited).

- `buffer` — the buffer.
- `enable_undo` — `1.gboolean`/`0.gboolean`.
- `max_undo_levels` — the maximum number of history steps.

```nim
gtk_text_buffer_begin_user_action(buffer)
gtk_text_buffer_delete(buffer, addr wrongWordStart, addr wrongWordEnd)
gtk_text_buffer_insert(buffer, addr wrongWordStart, "correctedWord", -1)
gtk_text_buffer_end_user_action(buffer)
echo "Word autocorrect — a single operation for Ctrl+Z"
```

---

## GtkTextView

`GtkTextView` is the widget that displays the contents of a `GtkTextBuffer` and handles user interaction (keyboard input, mouse, scrolling). The text itself and its formatting are edited through the buffer (section I) — the procedures in this section are responsible for how that text looks and behaves on screen.

### `gtk_text_view_new` / `gtk_text_view_new_with_buffer`

```nim
proc gtk_text_view_new*(): GtkTextView
proc gtk_text_view_new_with_buffer*(buffer: GtkTextBuffer): GtkTextView
```

**What it does.** Create a text display widget — with an automatically created empty buffer (`gtk_text_view_new`), or with a pre-prepared buffer (`gtk_text_view_new_with_buffer`, for example if the text needs to be visible in several `GtkTextView`s at once).

- `buffer` — an existing buffer (for the `_with_buffer` variant).

```nim
let editor = gtk_text_view_new()
echo "Text display widget created with its own empty buffer"
```

---

### `gtk_text_view_set_buffer` / `gtk_text_view_get_buffer`

```nim
proc gtk_text_view_set_buffer*(textView: GtkTextView, buffer: GtkTextBuffer)
proc gtk_text_view_get_buffer*(textView: GtkTextView): GtkTextBuffer
```

**What it does.** Replace the buffer the widget displays with another one (for example, to switch the editor between several open documents, each stored in its own buffer), or retrieve the buffer to work with the text through the functions in section I.

- `textView` — the widget.
- `buffer` — the new buffer.

```nim
let buffer = gtk_text_view_get_buffer(editor)
gtk_text_buffer_set_text(buffer, "Initial document text", -1)
echo "Text set through the buffer obtained from the widget"
```

---

### `gtk_text_view_set_editable` / `gtk_text_view_get_editable`

```nim
proc gtk_text_view_set_editable*(textView: GtkTextView, setting: gboolean)
proc gtk_text_view_get_editable*(textView: GtkTextView): gboolean
```

**What it does.** Allow/forbid the user from editing the text — the same logic as `gtk_editable_set_editable` for single-line fields: the text remains visible and selectable for copying, but cannot be edited from the keyboard. A typical use is viewing a log or documentation inside a `GtkTextView` (which gives you line wrapping, scrolling, and text selection "for free", unlike `GtkLabel`).

- `textView` — the widget.
- `setting` — `0.gboolean` to forbid editing.

```nim
gtk_text_view_set_editable(logViewer, 0.gboolean)
echo "Log viewer is read-only: ", gtk_text_view_get_editable(logViewer) == 0.gboolean
```

---

### `gtk_text_view_set_wrap_mode` / `gtk_text_view_get_wrap_mode`

```nim
proc gtk_text_view_set_wrap_mode*(textView: GtkTextView, wrap_mode: PangoWrapMode)
proc gtk_text_view_get_wrap_mode*(textView: GtkTextView): PangoWrapMode
```

**What it does.** Set the wrapping mode for long lines — the same logic and the same values (`PANGO_WRAP_WORD`, `PANGO_WRAP_CHAR`, `PANGO_WRAP_WORD_CHAR`) as `gtk_label_set_wrap_mode` from the basic controls reference. Unlike `GtkLabel`, `GtkTextView` has no separate boolean "enable wrapping" — wrapping is either always on in one of the modes, or fully off via the special value `GTK_WRAP_NONE` (this value belongs to a separate type, `GtkWrapMode`, not `PangoWrapMode` — in this wrapper it's covered by the broader `GtkWrapMode` enum declared in the basic types section).

- `textView` — the widget.
- `wrap_mode` — a `PangoWrapMode` value.

```nim
gtk_text_view_set_wrap_mode(editor, PANGO_WRAP_WORD)
echo "Word-boundary wrapping of long lines enabled"
```

---

### `gtk_text_view_set_cursor_visible` / `gtk_text_view_get_cursor_visible`

```nim
proc gtk_text_view_set_cursor_visible*(textView: GtkTextView, setting: gboolean)
proc gtk_text_view_get_cursor_visible*(textView: GtkTextView): gboolean
```

**What it does.** Show/hide the blinking text cursor — independent of `editable`: you can, for example, keep the cursor visible in a non-editable viewer (so the user can navigate the text with the keyboard and see the current position for subsequent selection and copying), or conversely hide the cursor in an editable field that has a fully custom way of displaying the input position.

- `textView` — the widget.
- `setting` — `0.gboolean` to hide the cursor.

```nim
gtk_text_view_set_cursor_visible(logViewer, 1.gboolean)
echo "Cursor is visible in the log viewer even without the ability to edit"
```

---

### `gtk_text_view_set_monospace` / `gtk_text_view_get_monospace`

```nim
proc gtk_text_view_set_monospace*(textView: GtkTextView, monospace: gboolean)
proc gtk_text_view_get_monospace*(textView: GtkTextView): gboolean
```

**What it does.** Switch the widget to a monospace font (from the theme/system settings) — useful for displaying code, logs, or data aligned into columns with spaces/tabs, where a proportional font visually breaks the alignment.

- `textView` — the widget.
- `monospace` — `1.gboolean` for a monospace font.

```nim
gtk_text_view_set_monospace(logViewer, 1.gboolean)
echo "Log viewer switched to a monospace font"
```

---

### Margins and alignment: margins, indent, justification

```nim
proc gtk_text_view_set_left_margin*(text_view: GtkTextView, left_margin: gint)
proc gtk_text_view_get_left_margin*(text_view: GtkTextView): gint
proc gtk_text_view_set_right_margin*(text_view: GtkTextView, right_margin: gint)
proc gtk_text_view_get_right_margin*(text_view: GtkTextView): gint
proc gtk_text_view_set_top_margin*(text_view: GtkTextView, top_margin: gint)
proc gtk_text_view_get_top_margin*(text_view: GtkTextView): gint
proc gtk_text_view_set_bottom_margin*(text_view: GtkTextView, bottom_margin: gint)
proc gtk_text_view_get_bottom_margin*(text_view: GtkTextView): gint
proc gtk_text_view_set_indent*(text_view: GtkTextView, indent: gint)
proc gtk_text_view_get_indent*(text_view: GtkTextView): gint
proc gtk_text_view_set_pixels_above_lines*(text_view: GtkTextView, pixels_above_lines: gint)
proc gtk_text_view_get_pixels_above_lines*(text_view: GtkTextView): gint
proc gtk_text_view_set_pixels_below_lines*(text_view: GtkTextView, pixels_below_lines: gint)
proc gtk_text_view_get_pixels_below_lines*(text_view: GtkTextView): gint
proc gtk_text_view_set_pixels_inside_wrap*(text_view: GtkTextView, pixels_inside_wrap: gint)
proc gtk_text_view_get_pixels_inside_wrap*(text_view: GtkTextView): gint
proc gtk_text_view_set_justification*(text_view: GtkTextView, justification: GtkJustification)
proc gtk_text_view_get_justification*(text_view: GtkTextView): GtkJustification
```

**What it does.** A large group of typography settings for text within the widget. `left_margin`/`right_margin`/`top_margin`/`bottom_margin` are the internal margins between the text and the widget's edges (not to be confused with `gtk_widget_set_margin_*` from the basic reference — that sets the outer margin of **the widget itself** within its container, while these set the margin of **the text inside** the widget). `indent` is an additional indent for the first line of each paragraph (can be negative — in which case the first line juts out to the left relative to the rest, a "hanging indent"). `pixels_above_lines`/`pixels_below_lines` add extra vertical space before and after each line of text (line spacing). `pixels_inside_wrap` adds extra space between the display lines that a single logical line has wrapped into (i.e. between wrap points within one paragraph, not between paragraphs). `justification` is the same logic as `gtk_label_set_justify`.

- `text_view` — the widget.
- Each parameter is a value in pixels (for margins/spacing) or a `GtkJustification` (for alignment).

```nim
gtk_text_view_set_left_margin(editor, 16)
gtk_text_view_set_right_margin(editor, 16)
gtk_text_view_set_pixels_above_lines(editor, 2)
gtk_text_view_set_pixels_below_lines(editor, 2)
echo "Text editor now has comfortable margins and line spacing"
```

---

### `gtk_text_view_set_tabs` / `gtk_text_view_get_tabs`

```nim
proc gtk_text_view_set_tabs*(text_view: GtkTextView, tabs: PangoTabArray)
proc gtk_text_view_get_tabs*(text_view: GtkTextView): PangoTabArray
```

**What it does.** Set the tab-stop positions for `\t` characters — the same logic as `gtk_label_set_tabs`/`gtk_entry_set_tabs`, but for a multiline widget this setting is far more commonly needed (for example, for a code editor with a tab width of 4 spaces).

- `text_view` — the widget.
- `tabs` — a Pango array of tab-stop positions.

```nim
# tabArray is built beforehand via pango_tab_array_new/pango_tab_array_set_tab
gtk_text_view_set_tabs(codeEditor, tabArray)
echo "Tab width configured for the code editor"
```

---

### `gtk_text_view_set_accepts_tab` / `gtk_text_view_get_accepts_tab`

```nim
proc gtk_text_view_set_accepts_tab*(text_view: GtkTextView, accepts_tab: gboolean)
proc gtk_text_view_get_accepts_tab*(text_view: GtkTextView): gboolean
```

**What it does.** Determine whether pressing the `Tab` key inserts a tab character into the text (`1.gboolean`, the default behavior — typical for code editors) or, instead, moves focus to the next form widget, as in ordinary fields (`0.gboolean` — appropriate when `GtkTextView` is used as a multiline field inside a form, rather than as a standalone editor).

- `text_view` — the widget.
- `accepts_tab` — `1.gboolean`/`0.gboolean`.

```nim
gtk_text_view_set_accepts_tab(commentField, 0.gboolean)
echo "Tab in the comment field now moves focus onward through the form instead of inserting a tab character"
```

---

### `gtk_text_view_set_overwrite` / `gtk_text_view_get_overwrite`

```nim
proc gtk_text_view_set_overwrite*(text_view: GtkTextView, overwrite: gboolean)
proc gtk_text_view_get_overwrite*(text_view: GtkTextView): gboolean
```

**What it does.** Switch the input mode between "insert" (default — new text shifts existing text along) and "replace"/overwrite (new text overwrites the characters under the cursor) — the same behavior toggled by the `Insert` key on the keyboard in most text editors.

- `text_view` — the widget.
- `overwrite` — `1.gboolean` for replace mode.

```nim
proc onInsertKeyPressed() =
  gtk_text_view_set_overwrite(editor, if gtk_text_view_get_overwrite(editor) != 0.gboolean: 0.gboolean else: 1.gboolean)
  echo "Input mode toggled"
```

---

### `gtk_text_view_set_input_purpose` / `get_input_purpose` / `set_input_hints` / `get_input_hints`

```nim
proc gtk_text_view_set_input_purpose*(text_view: GtkTextView, purpose: GtkInputPurpose)
proc gtk_text_view_get_input_purpose*(text_view: GtkTextView): GtkInputPurpose
proc gtk_text_view_set_input_hints*(text_view: GtkTextView, hints: GtkInputHints)
proc gtk_text_view_get_input_hints*(text_view: GtkTextView): GtkInputHints
```

**What it does.** The same as `gtk_entry_set_input_purpose`/`set_input_hints` from the text input reference, applied to the multiline widget — the content's purpose for the on-screen keyboard and input system.

- `text_view` — the widget.
- `purpose` — a `GtkInputPurpose` value.
- `hints` — a bitmask of `GtkInputHints` values.

```nim
gtk_text_view_set_input_hints(commentField, GTK_INPUT_HINT_UPPERCASE_SENTENCES)
echo "The first letter of each sentence will be suggested capitalized on the on-screen keyboard"
```

---

### Scrolling to a position: `scroll_to_mark` / `scroll_to_iter` / `scroll_mark_onscreen`

```nim
proc gtk_text_view_scroll_to_mark*(text_view: GtkTextView, mark: GtkTextMark, within_margin: gdouble, use_align: gboolean, xalign: gdouble, yalign: gdouble)
proc gtk_text_view_scroll_to_iter*(text_view: GtkTextView, iter: ptr GtkTextIter, within_margin: gdouble, use_align: gboolean, xalign: gdouble, yalign: gdouble): gboolean
proc gtk_text_view_scroll_mark_onscreen*(text_view: GtkTextView, mark: GtkTextMark)
```

**What it does.** Scroll the visible area of a `GtkTextView` to show a given position — by mark (survives text changes) or by iterator (a snapshot at the current moment, good only for immediate use). `within_margin` is the minimum margin from the edge of the visible area (a fraction from `0.0` to `0.5`) within which a position is not considered "visible enough" and will still trigger scrolling. `use_align`/`xalign`/`yalign` — if `use_align = true`, the position will be placed at an exact relative spot within the visible area (`0.0`–`1.0` on each axis, as with `gtk_label_set_xalign`); if `false`, GTK scrolls the minimum distance necessary just to make the position visible, no more. `scroll_mark_onscreen` is a shorthand for the most common case: the minimal scroll needed just to show the mark, without precise positioning.

- `text_view` — the widget.
- `mark` / `iter` — the target position.
- `within_margin` — a threshold margin from `0.0` to `0.5`.
- `use_align`, `xalign`, `yalign` — precise positioning within the visible area.

```nim
let insertMark = gtk_text_buffer_get_insert(buffer)
gtk_text_view_scroll_mark_onscreen(editor, insertMark)
echo "View scrolled so the cursor is visible"
```

---

### Coordinate conversion: `get_iter_at_location` and related functions

```nim
proc gtk_text_view_get_iter_location*(text_view: GtkTextView, iter: ptr GtkTextIter, location: ptr GdkRectangle)
proc gtk_text_view_get_iter_at_location*(text_view: GtkTextView, iter: ptr GtkTextIter, x: gint, y: gint): gboolean
proc gtk_text_view_get_iter_at_position*(text_view: GtkTextView, iter: ptr GtkTextIter, trailing: ptr gint, x: gint, y: gint): gboolean
proc gtk_text_view_get_line_at_y*(text_view: GtkTextView, target_iter: ptr GtkTextIter, y: gint, line_top: ptr gint)
proc gtk_text_view_get_line_yrange*(text_view: GtkTextView, iter: ptr GtkTextIter, y: ptr gint, height: ptr gint)
proc gtk_text_view_get_visible_rect*(text_view: GtkTextView, visible_rect: ptr GdkRectangle)
proc gtk_text_view_buffer_to_window_coords*(text_view: GtkTextView, win: GtkTextWindowType, buffer_x: gint, buffer_y: gint, window_x: ptr gint, window_y: ptr gint)
proc gtk_text_view_window_to_buffer_coords*(text_view: GtkTextView, win: GtkTextWindowType, window_x: gint, window_y: gint, buffer_x: ptr gint, buffer_y: ptr gint)
```

**What it does.** A group of functions for converting between a text position (`GtkTextIter`) and pixel coordinates — needed for advanced scenarios such as custom handling of mouse clicks on a specific word, drawing over a particular line of text, or implementing custom scrolling behavior. `get_iter_location` — the pixel rectangle occupied by the character at a given position. `get_iter_at_location`/`get_iter_at_position` do the reverse: from pixel coordinates, find the text position underneath them (`_at_position` additionally returns `trailing` — whether the point is closer to the start or the end of the character under it, important for precise cursor placement between characters). `get_line_at_y`/`get_line_yrange` are analogous operations at the level of whole lines rather than individual characters. `get_visible_rect` is the rectangle of the currently visible (not scrolled off-screen) area in buffer coordinates. `buffer_to_window_coords`/`window_to_buffer_coords` convert between the buffer's coordinate system and the coordinate system of a specific widget area (`win` is a `GtkTextWindowType` value specifying which area is meant — the main text area or one of the side "gutter" areas, see the next subsection).

- `text_view` — the widget.
- `iter` — the text position (used as a source or as a result, depending on the function).
- `x`, `y` — pixel coordinates.
- `win` — a `GtkTextWindowType` value.

```nim
var clickedIter: GtkTextIter
if gtk_text_view_get_iter_at_location(editor, addr clickedIter, mouseX, mouseY) != 0.gboolean:
  echo "Mouse click landed on a text position, iterator obtained"
```

---

### `gtk_text_view_set_gutter` / `gtk_text_view_get_gutter`

```nim
proc gtk_text_view_set_gutter*(text_view: GtkTextView, win: GtkTextWindowType, widget: GtkWidget)
proc gtk_text_view_get_gutter*(text_view: GtkTextView, win: GtkTextWindowType): GtkWidget
```

**What it does.** Install an arbitrary widget into the side area ("gutter") along one of the four edges of the text area — the classic use is a line-number column to the left of code in an editor. `win` determines which side (`GTK_TEXT_WINDOW_LEFT`, `_RIGHT`, `_TOP`, `_BOTTOM`).

- `text_view` — the widget.
- `win` — the side to place it on (a `GtkTextWindowType` value).
- `widget` — the widget for that side area.

```nim
# lineNumbersWidget is a self-drawn widget with line numbers
gtk_text_view_set_gutter(codeEditor, GTK_TEXT_WINDOW_LEFT, lineNumbersWidget)
echo "Line-number column added to the left of the code editor"
```

---

### `gtk_text_view_set_extra_menu` / `gtk_text_view_get_extra_menu`

```nim
proc gtk_text_view_set_extra_menu*(text_view: GtkTextView, model: GMenuModel)
proc gtk_text_view_get_extra_menu*(text_view: GtkTextView): GMenuModel
```

**What it does.** Add extra items to the widget's standard context menu — the same logic as `gtk_entry_set_extra_menu`/`gtk_label_set_extra_menu`.

- `text_view` — the widget.
- `model` — the additional menu model.

```nim
# extraMenuModel is built beforehand via g_menu_new/g_menu_append
gtk_text_view_set_extra_menu(editor, extraMenuModel)
echo "Extra items added to the editor's context menu"
```

---

### Embedding widgets: `add_child_at_anchor` / `add_overlay` / `move_overlay` / `remove`

```nim
proc gtk_text_view_add_child_at_anchor*(text_view: GtkTextView, child: GtkWidget, anchor: GtkTextChildAnchor)
proc gtk_text_view_add_overlay*(text_view: GtkTextView, child: GtkWidget, xpos: gint, ypos: gint)
proc gtk_text_view_move_overlay*(text_view: GtkTextView, child: GtkWidget, xpos: gint, ypos: gint)
proc gtk_text_view_remove*(text_view: GtkTextView, child: GtkWidget)
```

**What it does.** Two different ways to place an arbitrary widget over/inside the text. `add_child_at_anchor` embeds the widget **into the text flow**, at the location of an anchor previously created via `gtk_text_buffer_create_child_anchor` (section I) — the widget behaves as part of the text: it shifts when the surrounding text is edited, and participates in line wrapping. `add_overlay`, by contrast, places the widget over the text at fixed pixel coordinates (`xpos`, `ypos`) relative to the buffer — it is not tied to a specific spot in the text and does not shift when the text is edited (`move_overlay` changes the coordinates of an already-added overlay). `remove` removes a widget added by either method.

- `text_view` — the widget.
- `child` — the widget to embed.
- `anchor` (for `add_child_at_anchor`) — the anchor obtained from `gtk_text_buffer_create_child_anchor`.
- `xpos`, `ypos` (for `add_overlay`/`move_overlay`) — coordinates in the buffer's coordinate system.

```nim
var endIter: GtkTextIter
gtk_text_buffer_get_end_iter(buffer, addr endIter)
let anchor = gtk_text_buffer_create_child_anchor(buffer, addr endIter)
let inlineButton = gtk_button_new_with_label("Expand")
gtk_text_view_add_child_at_anchor(editor, inlineButton, anchor)
echo "Button embedded directly into the text flow and will move along with it"
```

---

### Navigating by display lines: `forward/backward_display_line` and related functions

```nim
proc gtk_text_view_forward_display_line*(text_view: GtkTextView, iter: ptr GtkTextIter): gboolean
proc gtk_text_view_backward_display_line*(text_view: GtkTextView, iter: ptr GtkTextIter): gboolean
proc gtk_text_view_forward_display_line_end*(text_view: GtkTextView, iter: ptr GtkTextIter): gboolean
proc gtk_text_view_backward_display_line_start*(text_view: GtkTextView, iter: ptr GtkTextIter): gboolean
proc gtk_text_view_starts_display_line*(text_view: GtkTextView, iter: ptr GtkTextIter): gboolean
proc gtk_text_view_move_visually*(text_view: GtkTextView, iter: ptr GtkTextIter, count: gint): gboolean
```

**What it does.** A "display line" is a line **after** wrapping to the widget's width, as opposed to a "logical line" (a line between `\n` characters in the text itself, which the `GtkTextBuffer` functions like `get_iter_at_line` work with). A single long logical line with wrapping enabled can occupy several display lines on screen. This group of functions moves an iterator one display line forward/backward (rather than one logical line), to the end/start of the current display line, checks whether a position is exactly at the start of a display line, and moves the cursor "visually" by a given number of positions (`move_visually` — accounting for bidirectional text, RTL/LTR, where the visual order of characters can differ from the logical order in memory). These are needed when implementing the `Up Arrow`/`Down Arrow`/`Home`/`End` keys by hand — the standard `GtkTextView` already handles these keys itself, so these functions are only directly needed for custom navigation.

- `text_view` — the widget.
- `iter` — the iterator that will be moved.
- `count` (for `move_visually`) — the number of visual positions to move by (can be negative).

```nim
var iter: GtkTextIter
gtk_text_buffer_get_iter_at_mark(buffer, addr iter, gtk_text_buffer_get_insert(buffer))
discard gtk_text_view_forward_display_line(editor, addr iter)
echo "Iterator moved one display line down from the cursor"
```

---

### `gtk_text_view_get_cursor_locations`

```nim
proc gtk_text_view_get_cursor_locations*(text_view: GtkTextView, iter: ptr GtkTextIter, strong: ptr GdkRectangle, weak: ptr GdkRectangle)
```

**What it does.** Returns the pixel rectangles of the cursor for a given position — two of them at once, "strong" and "weak", because in text with mixed writing direction (for example, English text with Hebrew insertions) the cursor at a direction-change point must visually point to two possible "next" insertion spots at once. For unidirectional text (including Russian and English with no RTL insertions) both rectangles coincide, and the distinction has no practical significance — using `strong` is sufficient. Passing `nil` for `iter` means "the current cursor position".

- `text_view` — the widget.
- `iter` — the position (or `nil` for the current cursor position).
- `strong`, `weak` — pointers for the result (either can be passed as `nil` if that particular value isn't needed).

```nim
var cursorRect: GdkRectangle
gtk_text_view_get_cursor_locations(editor, nil, addr cursorRect, nil)
echo "Cursor on screen in buffer coordinates: (", cursorRect.x, ", ", cursorRect.y, ")"
```

---

### `gtk_text_view_reset_im_context` / `gtk_text_view_im_context_filter_keypress`

```nim
proc gtk_text_view_reset_im_context*(text_view: GtkTextView)
proc gtk_text_view_im_context_filter_keypress*(text_view: GtkTextView, event: GdkEvent): gboolean
```

**What it does.** `reset_im_context` is the same logic as `gtk_entry_reset_im_context` from the text input reference: resets the state of the current input method (relevant for languages with complex input — Chinese, Japanese, Korean). `im_context_filter_keypress` is a low-level function that passes a keypress event directly to the input method, bypassing the widget's usual handling; used only when implementing fully custom keyboard-input handling on top of `GtkTextView`, which is beyond the typical use covered by this reference.

- `text_view` — the widget.
- `event` (for `im_context_filter_keypress`) — the `GdkEvent` keyboard event.

```nim
gtk_text_view_reset_im_context(editor)
echo "Input method state reset"
```

---

## Practical recipes

### A simple multiline editor with wrapping and margins

Basic setup: `GtkTextView` + buffer + word wrapping + internal margins + a scrollable container (see the basic controls reference — `GtkScrolledWindow` is covered separately; it's used here just for completeness of the example).

```nim
proc buildTextEditor(): GtkTextView =
  result = gtk_text_view_new()
  gtk_text_view_set_wrap_mode(result, PANGO_WRAP_WORD)
  gtk_text_view_set_left_margin(result, 12)
  gtk_text_view_set_right_margin(result, 12)
  gtk_text_view_set_top_margin(result, 8)
  gtk_text_view_set_pixels_below_lines(result, 2)

  let buffer = gtk_text_view_get_buffer(result)
  gtk_text_buffer_set_text(buffer, "Start typing here...", -1)
  echo "Text editor with word wrapping and margins assembled"

let editor = buildTextEditor()
```

---

### Highlighting part of the text via tags

Creating a formatting tag and registering it in the buffer's tag table, then applying it to a range — a minimal syntax-highlighting example.

```nim
proc highlightWord(buffer: GtkTextBuffer, word: string) =
  # tagTable already contains a "highlight" tag, created beforehand via
  # gtk_text_tag_new("highlight") + setting the "background" property + adding it
  # to the buffer's tag table (gtk_text_tag_table_add) — these steps belong
  # to the GtkTextTag/GtkTextTagTable API and are outside the scope of this reference.
  var searchStart: GtkTextIter
  gtk_text_buffer_get_start_iter(buffer, addr searchStart)
  # Substring search via gtk_text_iter_forward_search — the GtkTextIter functions
  # as a standalone API are covered in the text-search reference.
  echo "Highlight applied to the word '", word, "' wherever it was found"

highlightWord(gtk_text_view_get_buffer(editor), "TODO")
```

---

### An unsaved-changes indicator via the modified flag

The window title automatically gets an unsaved-changes marker based on the buffer's `"modified-changed"` signal.

```nim
proc onModifiedChanged(buffer: GtkTextBuffer, userData: gpointer) {.cdecl.} =
  let window = cast[GtkWindow](userData)
  let baseTitle = "Document.txt"
  if gtk_text_buffer_get_modified(buffer) != 0.gboolean:
    gtk_window_set_title(window, baseTitle & " •")
  else:
    gtk_window_set_title(window, baseTitle)

let buffer = gtk_text_view_get_buffer(editor)
discard g_signal_connect(buffer, "modified-changed", onModifiedChanged, cast[gpointer](mainWindow))

proc onSaveDocument() =
  # ... write buffer to a file ...
  gtk_text_buffer_set_modified(buffer, 0.gboolean)
  echo "Document saved — the unsaved-changes marker in the title will disappear"
```

---

### A read-only field with a monospace font (log viewer)

A compact `GtkTextView` configured as a log viewer: not editable, with a cursor for navigation and copying, monospace font.

```nim
proc buildLogViewer(): GtkTextView =
  result = gtk_text_view_new()
  gtk_text_view_set_editable(result, 0.gboolean)
  gtk_text_view_set_cursor_visible(result, 1.gboolean)
  gtk_text_view_set_monospace(result, 1.gboolean)
  gtk_text_view_set_wrap_mode(result, PANGO_WRAP_WORD_CHAR)
  echo "Log viewer assembled: read-only, monospace font, cursor for selection"

proc appendLogLine(viewer: GtkTextView, line: string) =
  let buffer = gtk_text_view_get_buffer(viewer)
  var endIter: GtkTextIter
  gtk_text_buffer_get_end_iter(buffer, addr endIter)
  gtk_text_buffer_insert(buffer, addr endIter, (line & "\n").cstring, -1)
  gtk_text_view_scroll_mark_onscreen(viewer, gtk_text_buffer_get_insert(buffer))

let logViewer = buildLogViewer()
appendLogLine(logViewer, "[12:00:01] Application started")
appendLogLine(logViewer, "[12:00:02] Connection to server established")
```

---

### Grouping edits into a single undo operation

Automatically replacing straight quote characters throughout the document as a single logical operation for `Ctrl+Z`, rather than a separate history entry for each replacement.

```nim
proc replaceStraightQuotesWithCurly(buffer: GtkTextBuffer) =
  gtk_text_buffer_begin_user_action(buffer)
  # Multiple gtk_text_buffer_delete/insert calls throughout the buffer's content —
  # searching and replacing by content is beyond the scope of this reference
  # (see the GtkTextIter functions responsible for substring search).
  gtk_text_buffer_end_user_action(buffer)
  echo "All quote replacements grouped into a single undo operation"

replaceStraightQuotesWithCurly(gtk_text_view_get_buffer(editor))
echo "A single Ctrl+Z will undo all the replacements made at once"
```

---

## Summary table

| Procedure(s) | Category | What it does, briefly |
|---|---|---|
| `gtk_text_buffer_new` | TextBuffer | Create a buffer (with or without a tag table) |
| `gtk_text_buffer_set/get_text`, `get_slice` | TextBuffer | The buffer's entire text / a range of text |
| `gtk_text_buffer_insert`, `insert_at_cursor`, `insert_range` | TextBuffer | Insert text without affecting the rest of the content |
| `gtk_text_buffer_insert/delete_interactive*` | TextBuffer | Insert/delete respecting non-editable tags |
| `gtk_text_buffer_delete`, `backspace` | TextBuffer | Unconditional range delete / Backspace emulation |
| `gtk_text_buffer_get_char_count`, `get_line_count` | TextBuffer | Fast character/line counts |
| `gtk_text_buffer_get_start/end_iter`, `get_bounds`, `get_iter_at_*` | TextBuffer | Obtaining iterators by various criteria |
| `gtk_text_buffer_create_mark`, `add/move/delete_mark`, `get_mark`, `get_insert`, `get_selection_bound` | TextBuffer | Named positions that "float" along with the text |
| `gtk_text_buffer_place_cursor`, `select_range` | TextBuffer | Programmatic cursor and selection positioning |
| `gtk_text_buffer_get_selection_bounds`, `get_has_selection`, `delete_selection` | TextBuffer | Working with the current selection |
| `gtk_text_buffer_apply/remove_tag*`, `get_tag_table` | TextBuffer | Formatting text ranges with tags |
| `gtk_text_buffer_create_child_anchor`, `insert_markup`, `insert_paintable` | TextBuffer | Embedding widgets/markup/images into the text |
| `gtk_text_buffer_cut/copy/paste_clipboard` | TextBuffer | Programmatic cut/copy/paste |
| `gtk_text_buffer_set/get_modified` | TextBuffer | Unsaved-changes flag |
| `gtk_text_buffer_undo/redo`, `get_can_undo/redo`, `set/get_enable_undo`, `begin/end_user_action`, `begin/end_irreversible_action`, `set/get_max_undo_levels` | TextBuffer | Undo/redo and operation grouping |
| `gtk_text_view_new`, `_with_buffer` | TextView | Create the text display widget |
| `gtk_text_view_set/get_buffer` | TextView | Which buffer is displayed |
| `gtk_text_view_set/get_editable` | TextView | Allow/forbid editing |
| `gtk_text_view_set/get_wrap_mode` | TextView | Long-line wrapping mode |
| `gtk_text_view_set/get_cursor_visible` | TextView | Visibility of the blinking cursor |
| `gtk_text_view_set/get_monospace` | TextView | Monospace font |
| `gtk_text_view_set/get_left/right/top/bottom_margin`, `set/get_indent` | TextView | Internal text and paragraph margins |
| `gtk_text_view_set/get_pixels_above/below_lines`, `pixels_inside_wrap` | TextView | Line spacing |
| `gtk_text_view_set/get_justification` | TextView | Line text alignment |
| `gtk_text_view_set/get_tabs` | TextView | Tab-stop positions |
| `gtk_text_view_set/get_accepts_tab` | TextView | Whether Tab inserts a character or moves focus onward |
| `gtk_text_view_set/get_overwrite` | TextView | Insert/replace character mode |
| `gtk_text_view_set/get_input_purpose`, `set/get_input_hints` | TextView | Purpose for the on-screen keyboard |
| `gtk_text_view_scroll_to_mark`, `scroll_to_iter`, `scroll_mark_onscreen` | TextView | Scrolling to a position in the text |
| `gtk_text_view_get_iter_location`, `get_iter_at_location/position`, `get_line_at_y`, `get_line_yrange`, `get_visible_rect`, `*_to_*_coords` | TextView | Converting between text positions and pixels |
| `gtk_text_view_set/get_gutter` | TextView | Side area (e.g. line numbers) |
| `gtk_text_view_set/get_extra_menu` | TextView | Extra context-menu items |
| `gtk_text_view_add_child_at_anchor`, `add/move_overlay`, `remove` | TextView | Embedding arbitrary widgets into/over the text |
| `gtk_text_view_forward/backward_display_line*`, `starts_display_line`, `move_visually` | TextView | Navigating by display (not logical) lines |
| `gtk_text_view_get_cursor_locations` | TextView | Pixel coordinates of the cursor (accounting for RTL/LTR) |
| `gtk_text_view_reset_im_context`, `im_context_filter_keypress` | TextView | Low-level input-method handling |

---

## Summary: which procedure to choose

- **Single-line input** → the text input reference (`GtkEntry`/`GtkPasswordEntry`/`GtkSearchEntry`). **Multiline text, code, a document** → this reference (`GtkTextView`/`GtkTextBuffer`).
- **Change the text itself, its formatting, find a position** → `GtkTextBuffer` functions (section I). **Change how the text looks and behaves on screen** (wrapping, margins, font, editability) → `GtkTextView` functions (section II).
- **Remember a spot in the text that must "survive" subsequent editing** (for example, the cursor position before and after a long programmatic insertion) → a mark (`GtkTextMark` via `gtk_text_buffer_create_mark`), not a saved copy of a `GtkTextIter` — the iterator becomes invalid immediately after any change to the text.
- **Show read-only multiline text in the UI, but with selection and copying available** → `GtkTextView` with `gtk_text_view_set_editable(view, 0.gboolean)`, rather than `GtkLabel` — this gives you line wrapping, scrolling, and full-fledged selection "for free"; `GtkLabel` is better suited to short, fixed-size captions.
- **A "document modified" indicator** → the buffer's `"modified-changed"` signal plus `gtk_text_buffer_get_modified`, remembering to manually reset the flag via `set_modified(buffer, 0.gboolean)` after saving — GTK doesn't know the data has been written to an external file.
- **Several consecutive programmatic edits should be undone by a single Ctrl+Z** → wrap them in `gtk_text_buffer_begin_user_action`/`end_user_action`, rather than relying on GTK to guess on its own which edits are logically related.
- **Programmatic text modification should not enter the undo history at all** (for example, loading a new document into the buffer) → `gtk_text_buffer_begin_irreversible_action`/`end_irreversible_action`.
- **Embed a widget (a button, an image) directly into the text so it moves along with the surrounding text** → an anchor via `gtk_text_buffer_create_child_anchor` + `gtk_text_view_add_child_at_anchor`. **Place a widget over the text at fixed coordinates, independent of editing** → `gtk_text_view_add_overlay`.
- **Handle a mouse click at a specific spot in the text** → `gtk_text_view_get_iter_at_location`/`get_iter_at_position`, rather than trying to compute the text position from pixel coordinates by hand.
