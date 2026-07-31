# GTK4 (text formatting & navigation: GtkTextTag / GtkTextMark / GtkTextIter) — module reference

> **Import:** `import libGTK4`
> **Scope:** in-depth work with multi-line text — managing formatting tag objects and the tag table, additional mark properties, and the full navigation/position-inspection API of `GtkTextIter`. Sixteenth part of the wrapper reference series; a direct continuation of `gtk4_multiline_text_reference_en.md` (`GtkTextBuffer`/`GtkTextView`), which already introduced iterators, marks, and tags at a basic level — here they're covered in depth.

This reference is an extension, not a replacement: applying tags to text (`gtk_text_buffer_apply_tag`) and basic mark usage (`gtk_text_buffer_create_mark`) were already covered in the previous reference. Here you'll find how to create tag objects themselves with specific visual properties, additional mark properties, and how to move/inspect a `GtkTextIter` at the level of characters, words, sentences, and visual lines.

---

## Table of Contents

I. [GtkTextTag and GtkTextTagTable](#gtktexttag-and-gtktexttagtable)
&nbsp;&nbsp;1. [`gtk_text_tag_new`](#gtk_text_tag_new)
&nbsp;&nbsp;2. [`gtk_text_tag_set/get_priority`](#gtk_text_tag_setget_priority)
&nbsp;&nbsp;3. [`gtk_text_tag_table_new` / `add` / `remove` / `lookup` / `get_size`](#gtk_text_tag_table_new--add--remove--lookup--get_size)

II. [GtkTextMark (additional properties)](#gtktextmark-additional-properties)
&nbsp;&nbsp;1. [`gtk_text_mark_new`](#gtk_text_mark_new)
&nbsp;&nbsp;2. [`gtk_text_mark_set/get_visible`](#gtk_text_mark_setget_visible)
&nbsp;&nbsp;3. [`gtk_text_mark_get_deleted` / `get_name` / `get_buffer` / `get_left_gravity`](#gtk_text_mark_get_deleted--get_name--get_buffer--get_left_gravity)

III. [GtkTextIter: position and text extraction](#gtktextiter-position-and-text-extraction)
&nbsp;&nbsp;1. [Querying position: `get_offset`, `get_line` and related](#querying-position-get_offset-get_line-and-related)
&nbsp;&nbsp;2. [Extracting content: `get_char`, `get_slice`, `get_text` and the visible variants](#extracting-content-get_char-get_slice-get_text-and-the-visible-variants)
&nbsp;&nbsp;3. [Absolute positioning: `set_offset`, `set_line` and related](#absolute-positioning-set_offset-set_line-and-related)

IV. [GtkTextIter: movement](#gtktextiter-movement)
&nbsp;&nbsp;1. [By characters and lines: `forward/backward_char(s)`, `_line(s)`](#by-characters-and-lines-forwardbackward_chars-_lines)
&nbsp;&nbsp;2. [By words and sentences](#by-words-and-sentences)
&nbsp;&nbsp;3. [By cursor positions: `forward/backward_cursor_position(s)`](#by-cursor-positions-forwardbackward_cursor_positions)
&nbsp;&nbsp;4. [To boundaries and tags: `forward_to_end`, `forward_to_line_end`, `forward/backward_to_tag_toggle`](#to-boundaries-and-tags-forward_to_end-forward_to_line_end-forwardbackward_to_tag_toggle)
&nbsp;&nbsp;5. [Text search: `forward_search` / `backward_search`](#text-search-forward_search--backward_search)

V. [GtkTextIter: comparison and boundary checks](#gtktextiter-comparison-and-boundary-checks)
&nbsp;&nbsp;1. [`gtk_text_iter_equal` / `compare` / `in_range`](#gtk_text_iter_equal--compare--in_range)
&nbsp;&nbsp;2. [Word/line/sentence boundary checks](#wordlinesentence-boundary-checks)
&nbsp;&nbsp;3. [`gtk_text_iter_is_cursor_position`, `get_chars_in_line`, `get_bytes_in_line`, `is_end`, `is_start`, `can_insert`, `editable`](#gtk_text_iter_is_cursor_position-get_chars_in_line-get_bytes_in_line-is_end-is_start-can_insert-editable)

VI. [GtkTextBuffer: additional functions](#gtktextbuffer-additional-functions)
&nbsp;&nbsp;1. [`gtk_text_buffer_create_tag`](#gtk_text_buffer_create_tag)
&nbsp;&nbsp;2. [`gtk_text_buffer_insert_with_tags` / `insert_with_tags_by_name`](#gtk_text_buffer_insert_with_tags--insert_with_tags_by_name)
&nbsp;&nbsp;3. [`gtk_text_buffer_add/remove_selection_clipboard`](#gtk_text_buffer_addremove_selection_clipboard)

VII. [Practical recipes](#practical-recipes)
&nbsp;&nbsp;1. [A set of formatting tags for a simple editor (bold, italic, heading)](#a-set-of-formatting-tags-for-a-simple-editor-bold-italic-heading)
&nbsp;&nbsp;2. [Finding and highlighting every occurrence of a substring](#finding-and-highlighting-every-occurrence-of-a-substring)
&nbsp;&nbsp;3. [Selecting the word under the cursor on a double click](#selecting-the-word-under-the-cursor-on-a-double-click)
&nbsp;&nbsp;4. [Counting the words in a document](#counting-the-words-in-a-document)
&nbsp;&nbsp;5. [Tag priority on overlap (a selection highlight on top of syntax highlighting)](#tag-priority-on-overlap-a-selection-highlight-on-top-of-syntax-highlighting)

VIII. [Quick reference table](#quick-reference-table)

IX. [Summary: which procedure to choose](#summary-which-procedure-to-choose)

---

## GtkTextTag and GtkTextTagTable

`GtkTextTag` is a named set of visual properties (color, font, indentation, etc.) that are set not through separate functions of this wrapper but through GObject's generic property mechanism — `g_object_set` (see the drawing/styling/GLib-utilities reference), since `GtkTextTag` has dozens of possible properties (`"foreground"`, `"weight"`, `"strikethrough"`, `"editable"`, etc.), and giving each one a dedicated type-safe function in this wrapper would be excessive.

### `gtk_text_tag_new`

```nim
proc gtk_text_tag_new*(name: cstring): GtkTextTag
```

**What it does.** Creates a tag object with the given name (passing `nil` creates an anonymous tag, which can then only be referenced by object, not by name). Creating a tag by itself applies no formatting at all — properties are set separately via `g_object_set` (see section VII, "A set of formatting tags" recipe), and the tag itself must be registered in the buffer's tag table (`gtk_text_tag_table_add`, next subsection, or via the shorthand `gtk_text_buffer_create_tag` in section VI) before it can be applied to any text.

- `name` — the tag's name, or `nil` for an anonymous tag.

```nim
let boldTag = gtk_text_tag_new("bold")
g_object_set(cast[GObject](boldTag), "weight".cstring, 700.cint, nil)  # 700 = PANGO_WEIGHT_BOLD
echo "The 'bold' tag was created with a bold weight"
```

---

### `gtk_text_tag_set/get_priority`

```nim
proc gtk_text_tag_set_priority*(tag: GtkTextTag, priority: gint)
proc gtk_text_tag_get_priority*(tag: GtkTextTag): gint
```

**What it does.** Sets/gets a tag's priority when it overlaps with other tags applied to the same text range — when values of the same visual property conflict (e.g. two tags both set the text color), the tag with the higher priority wins. The default priority follows the order in which the tag was added to the table (added later — higher priority); setting it explicitly is needed when the addition order doesn't match the desired application order (see section VII, the tag-priority recipe).

- `tag` — the tag.
- `priority` — the numeric priority (higher — takes precedence).

```nim
gtk_text_tag_set_priority(searchHighlightTag, 100)  # higher than the syntax-highlighting tags
echo "Search-result highlighting is now always shown on top of syntax highlighting"
```

---

### `gtk_text_tag_table_new` / `add` / `remove` / `lookup` / `get_size`

```nim
proc gtk_text_tag_table_new*(): GtkTextTagTable
proc gtk_text_tag_table_add*(table: GtkTextTagTable, tag: GtkTextTag): gboolean
proc gtk_text_tag_table_remove*(table: GtkTextTagTable, tag: GtkTextTag)
proc gtk_text_tag_table_lookup*(table: GtkTextTagTable, name: cstring): GtkTextTag
proc gtk_text_tag_table_get_size*(table: GtkTextTagTable): gint
```

**What it does.** `GtkTextTagTable` is the registry of tags available to a particular buffer (the same object that could have been passed to `gtk_text_buffer_new` in the previous reference, or obtained from an existing buffer via `gtk_text_buffer_get_tag_table`). `new` creates an empty table (only needed for manual assembly — a buffer normally creates its own table automatically). `add` registers a tag (returns `0.gboolean` if a tag with that name is already registered — two tags with the same name cannot coexist in one table). `remove` takes a tag out of the table. `lookup` finds an already-registered tag by name — the same mechanism used implicitly by `gtk_text_buffer_apply_tag_by_name` from the previous reference to get a tag object. `get_size` — the number of tags in the table.

- `table` — the tag table.
- `tag` — the tag.
- `name` — the tag's name (for `lookup`).

```nim
let tagTable = gtk_text_buffer_get_tag_table(buffer)
discard gtk_text_tag_table_add(tagTable, boldTag)
echo "The 'bold' tag is registered in the buffer's tag table, total tags: ", gtk_text_tag_table_get_size(tagTable)
```

---

## GtkTextMark (additional properties)

Basic mark usage (`create_mark`, `get_insert`, `get_selection_bound`) was already covered in the previous reference. Here — additional properties of the `GtkTextMark` object itself.

### `gtk_text_mark_new`

```nim
proc gtk_text_mark_new*(name: cstring, leftGravity: gboolean): GtkTextMark
```

**What it does.** Creates a mark object separately from a buffer — unlike `gtk_text_buffer_create_mark` (previous reference), which creates a mark and immediately attaches it to a position in a specific buffer, this function only creates a "free" mark object that then needs to be attached to a buffer via `gtk_text_buffer_add_mark` (previous reference). The difference is purely in how the steps are split up — `create_mark` is shorter for most scenarios.

- `name` — the mark's name, or `nil`.
- `leftGravity` — the same "sticking" logic on text insertion as in `create_mark`.

```nim
let freeMark = gtk_text_mark_new("bookmark-2", 1.gboolean)
echo "The mark was created separately from a buffer, not yet attached to a position"
```

---

### `gtk_text_mark_set/get_visible`

```nim
proc gtk_text_mark_set_visible*(mark: GtkTextMark, setting: gboolean)
proc gtk_text_mark_get_visible*(mark: GtkTextMark): gboolean
```

**What it does.** Shows/hides the mark as a visible vertical bar in a `GtkTextView`'s text (marks are invisible by default — most marks are used as purely programmatic position bookmarks with no visual representation). Visible marks are used rarely — mainly to display the position of other participants in collaborative document editing.

- `mark` — the mark.
- `setting` — `1.gboolean` to make the mark visible.

```nim
gtk_text_mark_set_visible(collaboratorCursorMark, 1.gboolean)
echo "The other collaborator's cursor position is now visible as a vertical bar in the text"
```

---

### `gtk_text_mark_get_deleted` / `get_name` / `get_buffer` / `get_left_gravity`

```nim
proc gtk_text_mark_get_deleted*(mark: GtkTextMark): gboolean
proc gtk_text_mark_get_name*(mark: GtkTextMark): cstring
proc gtk_text_mark_get_buffer*(mark: GtkTextMark): GtkTextBuffer
proc gtk_text_mark_get_left_gravity*(mark: GtkTextMark): gboolean
```

**What it does.** `get_deleted` reports whether the mark has been deleted from the buffer (via `gtk_text_buffer_delete_mark`, previous reference) — after deletion the mark object may still exist in memory (if references to it remain), but it's no longer attached to any position; the check is useful before trying to use a mark saved somewhere in the code that might have been independently deleted. `get_name`/`get_buffer` are the inverse operations: the mark's name and the buffer it's attached to (`get_buffer` returns `nil` if the mark has already been deleted). `get_left_gravity` reads the setting given at creation time via `create_mark`/`gtk_text_mark_new`.

- `mark` — the mark.

```nim
if gtk_text_mark_get_deleted(savedBookmark) != 0.gboolean:
  echo "The saved bookmark no longer exists in the buffer"
else:
  echo "The bookmark '", $gtk_text_mark_get_name(savedBookmark), "' is still valid"
```

---

## GtkTextIter: position and text extraction

### Querying position: `get_offset`, `get_line` and related

```nim
proc gtk_text_iter_get_offset*(iter: ptr GtkTextIter): gint
proc gtk_text_iter_get_line*(iter: ptr GtkTextIter): gint
proc gtk_text_iter_get_line_offset*(iter: ptr GtkTextIter): gint
proc gtk_text_iter_get_line_index*(iter: ptr GtkTextIter): gint
proc gtk_text_iter_get_visible_line_index*(iter: ptr GtkTextIter): gint
proc gtk_text_iter_get_visible_line_offset*(iter: ptr GtkTextIter): gint
```

**What it does.** Reads the iterator's current position in various units. `get_offset` — the absolute character number from the start of the text. `get_line` — the logical line number (from `0`). `get_line_offset`/`get_line_index` — position within the line in characters and in UTF-8 bytes. `get_visible_line_index`/`_offset` — the same pair, but excluding text hidden by invisibility tags.

- `iter` — the iterator.

```nim
echo "Position: line ", gtk_text_iter_get_line(myIter), ", character ", gtk_text_iter_get_line_offset(myIter), " from the start of the line"
```

---

### Extracting content: `get_char`, `get_slice`, `get_text` and the visible variants

```nim
proc gtk_text_iter_get_char*(iter: ptr GtkTextIter): gunichar
proc gtk_text_iter_get_slice*(start: ptr GtkTextIter, `end`: ptr GtkTextIter): cstring
proc gtk_text_iter_get_text*(start: ptr GtkTextIter, `end`: ptr GtkTextIter): cstring
proc gtk_text_iter_get_visible_slice*(start: ptr GtkTextIter, `end`: ptr GtkTextIter): cstring
proc gtk_text_iter_get_visible_text*(start: ptr GtkTextIter, `end`: ptr GtkTextIter): cstring
```

**What it does.** `get_char` returns the single Unicode character at the current position. `get_slice`/`get_text` are the same operations that were called as buffer methods in the previous reference, but here as standalone functions taking two iterators directly. `get_visible_slice`/`get_visible_text` do the same thing but always exclude text hidden by invisibility tags.

- `iter` — the iterator (for `get_char`).
- `start`, `end` — the range boundaries.

```nim
let firstChar = gtk_text_iter_get_char(startIter)
echo "Character code at the start of the range: ", firstChar
```

---

### Absolute positioning: `set_offset`, `set_line` and related

```nim
proc gtk_text_iter_set_offset*(iter: ptr GtkTextIter, charOffset: gint)
proc gtk_text_iter_set_line*(iter: ptr GtkTextIter, lineNumber: gint)
proc gtk_text_iter_set_line_offset*(iter: ptr GtkTextIter, charOnLine: gint)
proc gtk_text_iter_set_line_index*(iter: ptr GtkTextIter, byteOnLine: gint)
proc gtk_text_iter_set_visible_line_index*(iter: ptr GtkTextIter, byteOnLine: gint)
proc gtk_text_iter_set_visible_line_offset*(iter: ptr GtkTextIter, charOnLine: gint)
```

**What it does.** Moves an already-existing iterator to an absolute position — the same logic as `gtk_text_buffer_get_iter_at_offset`/`get_iter_at_line_offset` from the previous reference, but applied to an iterator you already have (reusing one variable instead of fetching a fresh iterator from the buffer again).

- `iter` — the iterator to move.
- `charOffset`, `lineNumber`, `charOnLine`, `byteOnLine` — the target position.

```nim
gtk_text_iter_set_line(myIter, 0)
gtk_text_iter_set_line_offset(myIter, 0)
echo "The iterator was moved to the start of the first line"
```

---

## GtkTextIter: movement

### By characters and lines: `forward/backward_char(s)`, `_line(s)`

```nim
proc gtk_text_iter_forward_char*(iter: ptr GtkTextIter): gboolean
proc gtk_text_iter_backward_char*(iter: ptr GtkTextIter): gboolean
proc gtk_text_iter_forward_chars*(iter: ptr GtkTextIter, count: gint): gboolean
proc gtk_text_iter_backward_chars*(iter: ptr GtkTextIter, count: gint): gboolean
proc gtk_text_iter_forward_line*(iter: ptr GtkTextIter): gboolean
proc gtk_text_iter_backward_line*(iter: ptr GtkTextIter): gboolean
proc gtk_text_iter_forward_lines*(iter: ptr GtkTextIter, count: gint): gboolean
proc gtk_text_iter_backward_lines*(iter: ptr GtkTextIter, count: gint): gboolean
```

**What it does.** Basic step-by-step iterator movement — one character/line forward or backward, or straight to a given number of characters/lines via the `count` variants. All return a `gboolean` indicating whether the full requested distance was covered (`0.gboolean` if the iterator hit the start/end of the text first). Moving by line goes to the start of the next/previous logical line (not a visual one — see `gtk_text_view_forward_display_line` in the previous reference for moving by visual, wrap-aware lines).

- `iter` — the iterator to move.
- `count` — the number of positions (for the plural variants).

```nim
discard gtk_text_iter_forward_chars(myIter, 5)
echo "The iterator was moved 5 characters forward"
```

---

### By words and sentences

```nim
proc gtk_text_iter_forward_word_end*(iter: ptr GtkTextIter): gboolean
proc gtk_text_iter_backward_word_start*(iter: ptr GtkTextIter): gboolean
proc gtk_text_iter_forward_word_ends*(iter: ptr GtkTextIter, count: gint): gboolean
proc gtk_text_iter_backward_word_starts*(iter: ptr GtkTextIter, count: gint): gboolean
proc gtk_text_iter_forward_visible_word_end*(iter: ptr GtkTextIter): gboolean
proc gtk_text_iter_backward_visible_word_start*(iter: ptr GtkTextIter): gboolean
proc gtk_text_iter_forward_visible_word_ends*(iter: ptr GtkTextIter, count: gint): gboolean
proc gtk_text_iter_backward_visible_word_starts*(iter: ptr GtkTextIter, count: gint): gboolean
proc gtk_text_iter_forward_sentence_end*(iter: ptr GtkTextIter): gboolean
proc gtk_text_iter_backward_sentence_start*(iter: ptr GtkTextIter): gboolean
proc gtk_text_iter_forward_sentence_ends*(iter: ptr GtkTextIter, count: gint): gboolean
proc gtk_text_iter_backward_sentence_starts*(iter: ptr GtkTextIter, count: gint): gboolean
```

**What it does.** Moves the iterator to a word or sentence boundary — the same logic that implements a double-/triple-click to select a word/sentence in a text editor (see section VII, "Selecting the word under the cursor"). Note the asymmetry in the naming: moving forward goes to the **end** of the word/sentence (`forward_word_end`), moving backward goes to its **start** (`backward_word_start`) — that is, both functions always move "outward" from the current word/sentence, not symmetrically toward the opposite edge of the same word. Word boundaries are determined by Unicode rules (taking punctuation and whitespace into account) — the same rules GTK uses to determine a "word" on double-click. The `_visible_` variants exclude text hidden by invisibility tags when locating boundaries.

- `iter` — the iterator to move.
- `count` — the number of boundaries (for the plural variants).

```nim
discard gtk_text_iter_backward_word_start(myIter)
discard gtk_text_iter_forward_word_end(endIter)
echo "The iterators now span the word they originally sat inside"
```

---

### By cursor positions: `forward/backward_cursor_position(s)`

```nim
proc gtk_text_iter_forward_cursor_position*(iter: ptr GtkTextIter): gboolean
proc gtk_text_iter_backward_cursor_position*(iter: ptr GtkTextIter): gboolean
proc gtk_text_iter_forward_cursor_positions*(iter: ptr GtkTextIter, count: gint): gboolean
proc gtk_text_iter_backward_cursor_positions*(iter: ptr GtkTextIter, count: gint): gboolean
proc gtk_text_iter_forward_visible_cursor_position*(iter: ptr GtkTextIter): gboolean
proc gtk_text_iter_backward_visible_cursor_position*(iter: ptr GtkTextIter): gboolean
proc gtk_text_iter_forward_visible_cursor_positions*(iter: ptr GtkTextIter, count: gint): gboolean
proc gtk_text_iter_backward_visible_cursor_positions*(iter: ptr GtkTextIter, count: gint): gboolean
```

**What it does.** Moves the iterator by one valid text-cursor position — not the same as moving by one character (`forward_char`): certain sequences of Unicode characters (composite emoji, combining diacritical marks) span several code points but represent a single position the cursor can't stop in the middle of. This is the group of functions that actually underlies how `Left Arrow`/`Right Arrow` move the cursor in a `GtkTextView` in practice (unlike `forward_char`, which would land in the middle of a composite character).

- `iter` — the iterator to move.
- `count` — the number of positions.

```nim
discard gtk_text_iter_forward_cursor_position(cursorIter)
echo "The iterator was moved one valid cursor position forward"
```

---

### To boundaries and tags: `forward_to_end`, `forward_to_line_end`, `forward/backward_to_tag_toggle`

```nim
proc gtk_text_iter_forward_to_end*(iter: ptr GtkTextIter)
proc gtk_text_iter_forward_to_line_end*(iter: ptr GtkTextIter): gboolean
proc gtk_text_iter_forward_to_tag_toggle*(iter: ptr GtkTextIter, tag: GtkTextTag): gboolean
proc gtk_text_iter_backward_to_tag_toggle*(iter: ptr GtkTextIter, tag: GtkTextTag): gboolean
```

**What it does.** `forward_to_end` moves the iterator straight to the very end of the buffer's text (no return value — the operation always succeeds). `forward_to_line_end` — to the end of the current logical line. `forward_to_tag_toggle`/`backward_to_tag_toggle` move the iterator to the nearest point where application of the given tag "toggles" (starts or ends) — a way to quickly find the boundaries of a tag-formatted range without a sequential character-by-character scan; passing `nil` instead of `tag` finds the toggle point of **any** tag, not a specific one.

- `iter` — the iterator to move.
- `tag` — the tag whose toggle point is being sought, or `nil` for any tag.

```nim
discard gtk_text_iter_forward_to_tag_toggle(myIter, boldTag)
echo "The iterator was moved to the end (or start) of the nearest bold-formatted range"
```

---

### Text search: `forward_search` / `backward_search`

```nim
proc gtk_text_iter_forward_search*(iter: ptr GtkTextIter, str: cstring, flags: gint, matchStart: ptr GtkTextIter, matchEnd: ptr GtkTextIter, limit: ptr GtkTextIter): gboolean
proc gtk_text_iter_backward_search*(iter: ptr GtkTextIter, str: cstring, flags: gint, matchStart: ptr GtkTextIter, matchEnd: ptr GtkTextIter, limit: ptr GtkTextIter): gboolean
```

**What it does.** Searches for the substring `str` in the text, starting at position `iter`, in the corresponding direction — fills `matchStart`/`matchEnd` with the boundaries of the match found (either can be passed as `nil` if that particular boundary isn't needed). `flags` is a bitmask of search modes: `GTK_TEXT_SEARCH_VISIBLE_ONLY = 1` (ignore text hidden by tags), `_TEXT_ONLY = 2` (ignore non-text elements such as embedded images when counting positions), `_CASE_INSENSITIVE = 4` (case-insensitive matching). `limit` — an optional boundary beyond which the search doesn't go (passing `nil` searches to the end/start of all the text).

- `iter` — the starting position of the search.
- `str` — the substring to search for.
- `flags` — a bitmask of search modes (there are no named constants in this wrapper).
- `matchStart`, `matchEnd` — pointers for the boundaries of the match found; either may be `nil`.
- `limit` — the search boundary, or `nil`.

```nim
var searchStart: GtkTextIter
gtk_text_buffer_get_start_iter(buffer, addr searchStart)
var matchStart, matchEnd: GtkTextIter
if gtk_text_iter_forward_search(addr searchStart, "TODO".cstring, 4, addr matchStart, addr matchEnd, nil) != 0.gboolean:
  # 4 = GTK_TEXT_SEARCH_CASE_INSENSITIVE
  echo "Found the first case-insensitive occurrence of 'TODO'"
```

---

## GtkTextIter: comparison and boundary checks

### `gtk_text_iter_equal` / `compare` / `in_range`

```nim
proc gtk_text_iter_equal*(lhs: ptr GtkTextIter, rhs: ptr GtkTextIter): gboolean
proc gtk_text_iter_compare*(lhs: ptr GtkTextIter, rhs: ptr GtkTextIter): gint
proc gtk_text_iter_in_range*(iter: ptr GtkTextIter, start: ptr GtkTextIter, `end`: ptr GtkTextIter): gboolean
```

**What it does.** `equal` checks whether two iterators point at the same position (not to be confused with comparing the addresses of the Nim `GtkTextIter` variables themselves — this compares logical text position). `compare` — a three-way comparison of positions (negative, `0`, positive — the same semantics as `g_strcmp0` from the GLib-utilities reference, but for text positions rather than strings). `in_range` checks whether position `iter` falls inside the range `[start, end)`.

- `lhs`, `rhs` — the iterators being compared.
- `iter` — the position being checked.
- `start`, `end` — the range boundaries.

```nim
if gtk_text_iter_compare(cursorIter, selectionEndIter) < 0:
  echo "The cursor is positioned before the end of the selection"
```

---

### Word/line/sentence boundary checks

```nim
proc gtk_text_iter_starts_word*(iter: ptr GtkTextIter): gboolean
proc gtk_text_iter_ends_word*(iter: ptr GtkTextIter): gboolean
proc gtk_text_iter_inside_word*(iter: ptr GtkTextIter): gboolean
proc gtk_text_iter_starts_line*(iter: ptr GtkTextIter): gboolean
proc gtk_text_iter_ends_line*(iter: ptr GtkTextIter): gboolean
proc gtk_text_iter_starts_sentence*(iter: ptr GtkTextIter): gboolean
proc gtk_text_iter_ends_sentence*(iter: ptr GtkTextIter): gboolean
proc gtk_text_iter_inside_sentence*(iter: ptr GtkTextIter): gboolean
```

**What it does.** Checks whether the iterator's current position sits exactly at a boundary (start/end) or inside a word/sentence/line, without altering the iterator itself — used together with the movement functions from section IV for conditional logic (e.g. "if the cursor isn't at the start of a word, move to the start first," before selecting the whole word).

- `iter` — the iterator.

```nim
if gtk_text_iter_starts_word(cursorIter) == 0.gboolean:
  discard gtk_text_iter_backward_word_start(cursorIter)
echo "The iterator is now guaranteed to be at the start of a word"
```

---

### `gtk_text_iter_is_cursor_position`, `get_chars_in_line`, `get_bytes_in_line`, `is_end`, `is_start`, `can_insert`, `editable`

```nim
proc gtk_text_iter_is_cursor_position*(iter: ptr GtkTextIter): gboolean
proc gtk_text_iter_get_chars_in_line*(iter: ptr GtkTextIter): gint
proc gtk_text_iter_get_bytes_in_line*(iter: ptr GtkTextIter): gint
proc gtk_text_iter_is_end*(iter: ptr GtkTextIter): gboolean
proc gtk_text_iter_is_start*(iter: ptr GtkTextIter): gboolean
proc gtk_text_iter_can_insert*(iter: ptr GtkTextIter, defaultEditability: gboolean): gboolean
proc gtk_text_iter_editable*(iter: ptr GtkTextIter, defaultSetting: gboolean): gboolean
```

**What it does.** `is_cursor_position` — whether this position is valid as a cursor position (see section IV, "by cursor positions" — the same composite-character logic). `get_chars_in_line`/`get_bytes_in_line` — the length of the current logical line (in characters and bytes respectively), not of the entire text. `is_end`/`is_start` — whether the iterator sits exactly at the very start/end of all the buffer's text. `can_insert`/`editable` — whether text can be inserted at this position / whether the position is editable, taking non-editability tags into account (the same tag-respecting logic as the `_interactive` buffer operations from the previous reference) — `defaultEditability`/`defaultSetting` determine the result for text with no explicit tag on the matter.

- `iter` — the iterator.
- `defaultEditability`, `defaultSetting` — `1.gboolean` if untagged text should be considered editable.

```nim
echo "Length of the current line: ", gtk_text_iter_get_chars_in_line(myIter), " characters"
if gtk_text_iter_can_insert(myIter, 1.gboolean) != 0.gboolean:
  echo "Text can be inserted at this position"
```

---

## GtkTextBuffer: additional functions

### `gtk_text_buffer_create_tag`

```nim
proc gtk_text_buffer_create_tag*(buffer: GtkTextBuffer, tagName: cstring, firstPropertyName: cstring): GtkTextTag {.varargs.}
```

**What it does.** A shorthand that combines `gtk_text_tag_new` + setting properties via `g_object_set` + `gtk_text_tag_table_add` into a single call — creates a tag, immediately sets its properties (a variadic list of alternating "property name"/"value" pairs, terminated with `nil` — the same protocol as `g_object_set`), and registers it in the buffer's tag table. The preferred way to create tags in application code instead of the three separate steps from section I.

- `buffer` — the buffer.
- `tagName` — the tag's name, or `nil`.
- `firstPropertyName`, followed by (property name, value) pairs, terminated with `nil`.

```nim
let highlightTag = gtk_text_buffer_create_tag(buffer, "highlight".cstring,
                                                "background".cstring, "yellow".cstring, nil)
echo "A yellow highlight tag was created and registered in a single call"
```

---

### `gtk_text_buffer_insert_with_tags` / `insert_with_tags_by_name`

```nim
proc gtk_text_buffer_insert_with_tags*(buffer: GtkTextBuffer, iter: ptr GtkTextIter, text: cstring, len: gint, firstTag: GtkTextTag) {.varargs.}
proc gtk_text_buffer_insert_with_tags_by_name*(buffer: GtkTextBuffer, iter: ptr GtkTextIter, text: cstring, len: gint, firstTagName: cstring) {.varargs.}
```

**What it does.** Inserts text and immediately applies one or more tags to it in a single call — shorter than a `gtk_text_buffer_insert` + `gtk_text_buffer_apply_tag` sequence for each tag separately. The list of tags is passed as a variadic list of tag objects (`insert_with_tags`) or their names (`insert_with_tags_by_name`), terminated with `nil`.

- `buffer` — the buffer.
- `iter` — the insertion position.
- `text` — the text to insert.
- `len` — the length in bytes, or `-1`.
- `firstTag`/`firstTagName`, followed by tags/tag names, terminated with `nil`.

```nim
var endIter: GtkTextIter
gtk_text_buffer_get_end_iter(buffer, addr endIter)
gtk_text_buffer_insert_with_tags_by_name(buffer, addr endIter, "Important note".cstring, -1, "bold".cstring, nil)
echo "The text was inserted with the bold tag already applied"
```

---

### `gtk_text_buffer_add/remove_selection_clipboard`

```nim
proc gtk_text_buffer_add_selection_clipboard*(buffer: GtkTextBuffer, clipboard: GdkClipboard)
proc gtk_text_buffer_remove_selection_clipboard*(buffer: GtkTextBuffer, clipboard: GdkClipboard)
```

**What it does.** Links the buffer to the system "primary selection" clipboard (an X11-specific concept, separate from the regular `Ctrl+C`/`Ctrl+V` clipboard — text selected with the mouse automatically becomes available for pasting with a middle-click, without an explicit copy) — has no effect on platforms without this concept (Windows). A `GtkTextView` typically already sets this up automatically for its buffer; an explicit call is only needed for non-standard use of a buffer with no `GtkTextView` attached.

- `buffer` — the buffer.
- `clipboard` — the clipboard object (from the dialogs-and-media reference, `gdk_display_get_clipboard`).

```nim
# primarySelectionClipboard is obtained via a separate, primary-selection-specific call
# not covered in this reference
gtk_text_buffer_add_selection_clipboard(buffer, primarySelectionClipboard)
echo "The buffer is now linked to the X11 primary selection (on platforms that have it)"
```

---

## Practical recipes

### A set of formatting tags for a simple editor (bold, italic, heading)

```nim
proc setupFormattingTags(buffer: GtkTextBuffer) =
  discard gtk_text_buffer_create_tag(buffer, "bold".cstring, "weight".cstring, 700.cint, nil)
  discard gtk_text_buffer_create_tag(buffer, "italic".cstring, "style".cstring, 2.cint, nil)
  discard gtk_text_buffer_create_tag(buffer, "heading".cstring,
                                      "weight".cstring, 700.cint,
                                      "scale".cstring, 1.5.cdouble, nil)
  echo "The 'bold', 'italic', and 'heading' tags are ready to use"

proc applyBoldToSelection(buffer: GtkTextBuffer) =
  var start, stop: GtkTextIter
  if gtk_text_buffer_get_selection_bounds(buffer, addr start, addr stop) != 0.gboolean:
    gtk_text_buffer_apply_tag_by_name(buffer, "bold".cstring, addr start, addr stop)
    echo "The selected text was made bold"

setupFormattingTags(buffer)
```

---

### Finding and highlighting every occurrence of a substring

```nim
proc highlightAllOccurrences(buffer: GtkTextBuffer, query: string) =
  discard gtk_text_buffer_create_tag(buffer, "search-highlight".cstring,
                                      "background".cstring, "yellow".cstring, nil)
  var searchPos: GtkTextIter
  gtk_text_buffer_get_start_iter(buffer, addr searchPos)

  var foundCount = 0
  while true:
    var matchStart, matchEnd: GtkTextIter
    let found = gtk_text_iter_forward_search(addr searchPos, query.cstring, 4,
                                              addr matchStart, addr matchEnd, nil)
    if found == 0.gboolean:
      break
    gtk_text_buffer_apply_tag_by_name(buffer, "search-highlight".cstring, addr matchStart, addr matchEnd)
    foundCount += 1
    searchPos = matchEnd

  echo "Found and highlighted occurrences: ", foundCount

highlightAllOccurrences(buffer, "TODO")
```

---

### Selecting the word under the cursor on a double click

```nim
proc onDoubleClick(gesture: GtkGestureClick, nPress: gint, x: gdouble, y: gdouble, userData: gpointer) {.cdecl.} =
  if nPress != 2:
    return
  let textView = cast[GtkTextView](userData)
  let buffer = gtk_text_view_get_buffer(textView)

  var wordStart, wordEnd, clickIter: GtkTextIter
  # the click position is obtained via gtk_text_view_get_iter_at_position (see multi-line text)
  wordStart = clickIter
  wordEnd = clickIter

  if gtk_text_iter_starts_word(addr wordStart) == 0.gboolean:
    discard gtk_text_iter_backward_word_start(addr wordStart)
  if gtk_text_iter_ends_word(addr wordEnd) == 0.gboolean:
    discard gtk_text_iter_forward_word_end(addr wordEnd)
  gtk_text_buffer_select_range(buffer, addr wordEnd, addr wordStart)
  echo "The whole word under the cursor was selected by the double click"
```

---

### Counting the words in a document

```nim
proc countWords(buffer: GtkTextBuffer): int =
  var iter: GtkTextIter
  gtk_text_buffer_get_start_iter(buffer, addr iter)

  while gtk_text_iter_is_end(addr iter) == 0.gboolean:
    if gtk_text_iter_forward_word_end(addr iter) == 0.gboolean:
      break
    result += 1

echo "Number of words in the document: ", countWords(buffer)
```

---

### Tag priority on overlap (a selection highlight on top of syntax highlighting)

```nim
proc setupLayeredTags(buffer: GtkTextBuffer) =
  let syntaxTag = gtk_text_buffer_create_tag(buffer, "syntax-keyword".cstring,
                                              "foreground".cstring, "blue".cstring, nil)
  let searchTag = gtk_text_buffer_create_tag(buffer, "search-match".cstring,
                                              "background".cstring, "yellow".cstring, nil)

  gtk_text_tag_set_priority(searchTag, gtk_text_tag_get_priority(syntaxTag) + 1)
  echo "The search-highlight tag is now guaranteed to show on top of syntax highlighting"

setupLayeredTags(buffer)
```

---

## Quick reference table

| Procedure(s) | Category | What it does, briefly |
|---|---|---|
| `gtk_text_tag_new` | TextTag | Create a tag object (properties — via g_object_set) |
| `gtk_text_tag_set/get_priority` | TextTag | Priority when overlapping other tags |
| `gtk_text_tag_table_new`, `add`, `remove`, `lookup`, `get_size` | TextTagTable | The buffer's tag registry |
| `gtk_text_mark_new` | TextMark | Create a mark separately from a buffer |
| `gtk_text_mark_set/get_visible` | TextMark | Visible vertical bar for the mark |
| `gtk_text_mark_get_deleted`, `get_name`, `get_buffer`, `get_left_gravity` | TextMark | The mark's state and properties |
| `gtk_text_iter_get_offset/line/line_offset/line_index/visible_*` | TextIter | Current position in various units |
| `gtk_text_iter_get_char/slice/text/visible_slice/visible_text` | TextIter | Extracting a character/text within a range |
| `gtk_text_iter_set_offset/line/line_offset/line_index/visible_*` | TextIter | Absolute positioning |
| `gtk_text_iter_forward/backward_char(s)`, `_line(s)` | TextIter | Step-by-step movement |
| `gtk_text_iter_forward/backward_word_*`, `_sentence_*` | TextIter | Movement by words/sentences |
| `gtk_text_iter_forward/backward_cursor_position(s)` | TextIter | Movement by valid cursor positions |
| `gtk_text_iter_forward_to_end/line_end`, `forward/backward_to_tag_toggle` | TextIter | Movement to boundaries and tag toggles |
| `gtk_text_iter_forward/backward_search` | TextIter | Substring search from the current position |
| `gtk_text_iter_equal`, `compare`, `in_range` | TextIter | Comparing positions |
| `gtk_text_iter_starts/ends/inside_word/line/sentence` | TextIter | Checking whether at a boundary/inside |
| `gtk_text_iter_is_cursor_position`, `get_chars/bytes_in_line`, `is_end/start`, `can_insert`, `editable` | TextIter | Other position checks |
| `gtk_text_buffer_create_tag` | TextBuffer | Create and immediately register a tag |
| `gtk_text_buffer_insert_with_tags(_by_name)` | TextBuffer | Insert text with tags already applied |
| `gtk_text_buffer_add/remove_selection_clipboard` | TextBuffer | Linking to the X11 primary selection |

---

## Summary: which procedure to choose

- **Create a formatting tag** → `gtk_text_buffer_create_tag` (a single call), not the separate `gtk_text_tag_new` + `g_object_set` + `gtk_text_tag_table_add`.
- **Insert text already formatted** → `gtk_text_buffer_insert_with_tags_by_name`, not `insert` + `apply_tag_by_name` done separately.
- **Movement that matches the feel of the keyboard arrow keys as closely as possible** → `forward/backward_cursor_position`, not `forward/backward_char` — the latter can stop in the middle of a composite Unicode character.
- **Select a whole word/sentence** → `backward_word_start`/`forward_word_end` from the current position, after first checking `starts_word`/`inside_word`.
- **Quickly find the boundaries of a tag-formatted range** → `forward_to_tag_toggle`/`backward_to_tag_toggle`, not a character-by-character scan.
- **Two tags visually conflict on overlap** → explicitly set a higher `gtk_text_tag_set_priority`, rather than relying on tag creation order.
- **A mark is only needed for programmatic position tracking** → a plain `gtk_text_buffer_create_mark` (invisible by default); `gtk_text_mark_set_visible` is only for specialized scenarios.
