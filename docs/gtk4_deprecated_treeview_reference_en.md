# GTK4 (deprecated: GtkTreeView family — ListStore / TreeStore / TreeView / TreeViewColumn / CellRenderer / TreeSelection / TreePath / TreeModel) — module reference

> **Import:** `import libGTK4`
> **Scope:** the classic "list/tree + data model + columns" pattern from GTK3, carried over into GTK4 for backward compatibility. Fourteenth part of this wrapper reference series.

## Important warning

**The entire API in this reference is officially deprecated in GTK4.** For new code, the GTK documentation recommends the modern replacement: `GtkColumnView`/`GtkListView` (table and simple lists built on `GListModel`) instead of `GtkTreeView`/`GtkTreeStore`, `GtkColumnViewColumn` instead of `GtkTreeViewColumn`, widget factories (`GtkListItemFactory`) instead of `GtkCellRenderer`, and `GtkSelectionModel` instead of `GtkTreeSelection` — this modern set is covered in a separate reference in this series.

In the wrapper itself, all the code in this reference is wrapped in `when not defined(GTK_DISABLE_DEPRECATED):` — available in a normal build, but disappears completely from the binary when compiling with the `-d:GTK_DISABLE_DEPRECATED` flag. This gives a practical way to check whether existing code still depends on the deprecated API before migrating to the modern replacement: if the project compiles with this flag, then none of the functions in this reference are being used.

Reasons this reference is still documented (rather than simply skipped): existing GTK3 code being ported to GTK4 without a full interface rewrite; libraries and tutorials that still rely on this API; and GTK4 itself guarantees this API will keep working (even without further development) for the entire lifecycle of GTK4, unlike code relying on non-exported internal symbols (see the separate discussion of the private API when the wrapper's own cleanup is covered).

---

## Table of contents

I. [GtkListStore](#gtkliststore)
&nbsp;&nbsp;1. [`gtk_list_store_new` / `gtk_list_store_newv`](#gtk_list_store_new--gtk_list_store_newv)
&nbsp;&nbsp;2. [`gtk_list_store_append` / `gtk_list_store_prepend` / `gtk_list_store_insert`](#gtk_list_store_append--gtk_list_store_prepend--gtk_list_store_insert)
&nbsp;&nbsp;3. [`gtk_list_store_set`](#gtk_list_store_set)
&nbsp;&nbsp;4. [`gtk_list_store_remove` / `gtk_list_store_clear`](#gtk_list_store_remove--gtk_list_store_clear)

II. [GtkTreeStore](#gtktreestore)
&nbsp;&nbsp;1. [`gtk_tree_store_new`](#gtk_tree_store_new)
&nbsp;&nbsp;2. [`gtk_tree_store_append` / `gtk_tree_store_prepend` / `gtk_tree_store_insert`](#gtk_tree_store_append--gtk_tree_store_prepend--gtk_tree_store_insert)
&nbsp;&nbsp;3. [`gtk_tree_store_set`](#gtk_tree_store_set)
&nbsp;&nbsp;4. [`gtk_tree_store_remove` / `gtk_tree_store_clear`](#gtk_tree_store_remove--gtk_tree_store_clear)

III. [GtkTreeView](#gtktreeview)
&nbsp;&nbsp;1. [`gtk_tree_view_new` / `gtk_tree_view_new_with_model`](#gtk_tree_view_new--gtk_tree_view_new_with_model)
&nbsp;&nbsp;2. [`gtk_tree_view_set_model` / `gtk_tree_view_get_model`](#gtk_tree_view_set_model--gtk_tree_view_get_model)
&nbsp;&nbsp;3. [`gtk_tree_view_append_column` / `gtk_tree_view_insert_column` / `gtk_tree_view_remove_column`](#gtk_tree_view_append_column--gtk_tree_view_insert_column--gtk_tree_view_remove_column)
&nbsp;&nbsp;4. [`gtk_tree_view_get_selection`](#gtk_tree_view_get_selection)
&nbsp;&nbsp;5. [`gtk_tree_view_set_headers_visible` / `gtk_tree_view_get_headers_visible`](#gtk_tree_view_set_headers_visible--gtk_tree_view_get_headers_visible)
&nbsp;&nbsp;6. [`gtk_tree_view_expand_all` / `gtk_tree_view_collapse_all`](#gtk_tree_view_expand_all--gtk_tree_view_collapse_all)

IV. [GtkTreeViewColumn](#gtktreeviewcolumn)
&nbsp;&nbsp;1. [`gtk_tree_view_column_new` / `gtk_tree_view_column_new_with_attributes`](#gtk_tree_view_column_new--gtk_tree_view_column_new_with_attributes)
&nbsp;&nbsp;2. [`gtk_tree_view_column_pack_start` / `gtk_tree_view_column_pack_end` / `gtk_tree_view_column_add_attribute`](#gtk_tree_view_column_pack_start--gtk_tree_view_column_pack_end--gtk_tree_view_column_add_attribute)
&nbsp;&nbsp;3. [`gtk_tree_view_column_set_title` / `gtk_tree_view_column_get_title`](#gtk_tree_view_column_set_title--gtk_tree_view_column_get_title)
&nbsp;&nbsp;4. [`gtk_tree_view_column_set_resizable` / `get_resizable` / `set_visible` / `get_visible`](#gtk_tree_view_column_set_resizable--get_resizable--set_visible--get_visible)
&nbsp;&nbsp;5. [`gtk_tree_view_column_clear`](#gtk_tree_view_column_clear)

V. [GtkCellRenderer](#gtkcellrenderer)
&nbsp;&nbsp;1. [`gtk_cell_renderer_text_new` / `gtk_cell_renderer_toggle_new` / `gtk_cell_renderer_pixbuf_new`](#gtk_cell_renderer_text_new--gtk_cell_renderer_toggle_new--gtk_cell_renderer_pixbuf_new)
&nbsp;&nbsp;2. [`gtk_cell_renderer_toggle_set_active` / `get_active` / `set_radio` / `get_radio`](#gtk_cell_renderer_toggle_set_active--get_active--set_radio--get_radio)

VI. [GtkTreeSelection](#gtktreeselection)
&nbsp;&nbsp;1. [`gtk_tree_selection_set_mode` / `gtk_tree_selection_get_mode`](#gtk_tree_selection_set_mode--gtk_tree_selection_get_mode)
&nbsp;&nbsp;2. [`gtk_tree_selection_get_selected`](#gtk_tree_selection_get_selected)
&nbsp;&nbsp;3. [`gtk_tree_selection_select_iter` / `unselect_iter` / `select_all` / `unselect_all`](#gtk_tree_selection_select_iter--unselect_iter--select_all--unselect_all)

VII. [GtkTreePath](#gtktreepath)
&nbsp;&nbsp;1. [`gtk_tree_path_new` / `gtk_tree_path_new_from_string`](#gtk_tree_path_new--gtk_tree_path_new_from_string)
&nbsp;&nbsp;2. [`gtk_tree_path_to_string` / `gtk_tree_path_free`](#gtk_tree_path_to_string--gtk_tree_path_free)

VIII. [GtkTreeModel](#gtktreemodel)
&nbsp;&nbsp;1. [`gtk_tree_model_get_iter` / `gtk_tree_model_get_iter_first` / `gtk_tree_model_get_path`](#gtk_tree_model_get_iter--gtk_tree_model_get_iter_first--gtk_tree_model_get_path)
&nbsp;&nbsp;2. [`gtk_tree_model_get_value`](#gtk_tree_model_get_value)
&nbsp;&nbsp;3. [`gtk_tree_model_iter_next` / `gtk_tree_model_iter_previous`](#gtk_tree_model_iter_next--gtk_tree_model_iter_previous)
&nbsp;&nbsp;4. [`gtk_tree_model_iter_children` / `iter_has_child` / `iter_n_children` / `iter_nth_child` / `iter_parent`](#gtk_tree_model_iter_children--iter_has_child--iter_n_children--iter_nth_child--iter_parent)
&nbsp;&nbsp;5. [`gtk_tree_model_get_string_from_iter`](#gtk_tree_model_get_string_from_iter)

IX. [Practical recipes](#practical-recipes)
&nbsp;&nbsp;1. [Simple list with one text column](#simple-list-with-one-text-column)
&nbsp;&nbsp;2. [Tree with expandable nodes](#tree-with-expandable-nodes)
&nbsp;&nbsp;3. [Column with checkboxes on each row](#column-with-checkboxes-on-each-row)
&nbsp;&nbsp;4. [Manually walking all model rows via an iterator](#manually-walking-all-model-rows-via-an-iterator)
&nbsp;&nbsp;5. [Reacting to a user's row selection](#reacting-to-a-users-row-selection)

X. [Quick reference table](#quick-reference-table)

XI. [Summary: which procedure to choose](#summary-which-procedure-to-choose)

---

## GtkListStore

`GtkListStore` — a flat (non-hierarchical) tabular data model: a set of rows, each with a fixed number of typed columns — data for `GtkTreeView` in simple list mode (no node nesting, unlike `GtkTreeStore`, section II).

### `gtk_list_store_new` / `gtk_list_store_newv`

```nim
proc gtk_list_store_new*(nColumns: gint): GtkListStore {.varargs.}
proc gtk_list_store_newv*(nColumns: gint, types: ptr GType): GtkListStore
```

**What it does.** Creates a model with a given number of columns and their types. `gtk_list_store_new` takes the column types as a variadic list of `GType` following `nColumns` (for example, `gtk_list_store_new(2, g_object_get_type(), G_TYPE_STRING)` — though in practice the types are almost always taken from ready-made constants like `G_TYPE_STRING`/`G_TYPE_INT`, which aren't always set up as separately named constants in this wrapper apart from `g_object_get_type`). `gtk_list_store_newv` performs the same operation via an explicit `GType` array instead of a variadic list, which is more convenient when the number of columns is determined dynamically.

- `nColumns` — the number of columns.
- What follows (for `new`) — `nColumns` `GType` values, one per column.
- `types` (for `newv`) — a `GType` array of the same size as `nColumns`.

```nim
# G_TYPE_STRING needs to be obtained by whatever method is available for getting
# the GType for strings — this wrapper has no separately defined constant for it;
# it's usually taken from the actual GLib headers (G_TYPE_STRING = 64 in the
# standard GLib type system) or computed via helper type functions not covered
# in this reference.
let contactsStore = gtk_list_store_new(1, G_TYPE_STRING)
echo "List model with one text column created"
```

---

### `gtk_list_store_append` / `gtk_list_store_prepend` / `gtk_list_store_insert`

```nim
proc gtk_list_store_append*(listStore: GtkListStore, iter: ptr GtkTreeIter)
proc gtk_list_store_prepend*(listStore: GtkListStore, iter: ptr GtkTreeIter)
proc gtk_list_store_insert*(listStore: GtkListStore, iter: ptr GtkTreeIter, position: gint)
```

**What it does.** Adds a new empty row at the end, at the beginning, or at an arbitrary position in the model, and fills in the passed `iter` to point to the newly added row — the row itself then needs to be filled with values via `gtk_list_store_set` (next subsection); by themselves these functions only reserve a slot for the new row.

- `listStore` — the model.
- `iter` — the iterator (`GtkTreeIter`, the same structure type as `GtkTextIter` from the multiline-text reference, but a separate one specific to `GtkTreeModel`), which will be filled in to point to the new row.
- `position` (for `insert`) — the insertion index.

```nim
var newRow: GtkTreeIter
gtk_list_store_append(contactsStore, addr newRow)
echo "New empty row added, iterator points to it"
```

---

### `gtk_list_store_set`

```nim
proc gtk_list_store_set*(listStore: GtkListStore, iter: ptr GtkTreeIter) {.varargs.}
```

**What it does.** Fills in the column values of the given row — a variadic list of alternating "column number" (`gint`, starting at `0`) / "value" pairs, which must be terminated by a `-1` in place of the next column number (an end-of-list marker — the same terminator-value principle as `nil` in lists of C strings, but here specifically numeric, since column numbers are non-negative and `-1` can never actually be a real column number).

- **Implementation note.** Omitting the terminating `-1` is a source of undefined behavior, analogous to omitting `nil` in `gtk_file_chooser_dialog_new` from the window chrome reference.

- `listStore` — the model.
- `iter` — the row whose values are being set.
- What follows — alternating (column number, value) pairs, terminated by `-1`.

```nim
gtk_list_store_set(contactsStore, addr newRow, 0, "Anna Ivanova".cstring, -1)
echo "Value of the new row's first (and only) column set"
```

---

### `gtk_list_store_remove` / `gtk_list_store_clear`

```nim
proc gtk_list_store_remove*(listStore: GtkListStore, iter: ptr GtkTreeIter): gboolean
proc gtk_list_store_clear*(listStore: GtkListStore)
```

**What it does.** Removes a single row by iterator (`remove` additionally reports, via its return value, whether the iterator remained valid after removal — now pointing at the next row, if one exists; `0.gboolean` if the removed row was the last one) and clears the model entirely (`clear` removes all rows at once).

- `listStore` — the model.
- `iter` — the iterator of the row to remove (for `remove`).

```nim
discard gtk_list_store_remove(contactsStore, addr newRow)
echo "Row removed"
gtk_list_store_clear(contactsStore)
echo "All rows of the model removed at once"
```

---

## GtkTreeStore

`GtkTreeStore` — a hierarchical data model: the same column logic as `GtkListStore`, but each row can have child rows to an arbitrary depth — data for `GtkTreeView` in tree mode.

### `gtk_tree_store_new`

```nim
proc gtk_tree_store_new*(nColumns: gint): GtkTreeStore {.varargs.}
```

**What it does.** Creates a hierarchical model with a given number of columns and their types — the same variadic type-list logic as `gtk_list_store_new`.

- `nColumns` — the number of columns.
- What follows — `nColumns` `GType` values, one per column.

```nim
let fileTreeStore = gtk_tree_store_new(1, G_TYPE_STRING)
echo "Hierarchical model for a file tree created"
```

---

### `gtk_tree_store_append` / `gtk_tree_store_prepend` / `gtk_tree_store_insert`

```nim
proc gtk_tree_store_append*(treeStore: GtkTreeStore, iter: ptr GtkTreeIter, parent: ptr GtkTreeIter)
proc gtk_tree_store_prepend*(treeStore: GtkTreeStore, iter: ptr GtkTreeIter, parent: ptr GtkTreeIter)
proc gtk_tree_store_insert*(treeStore: GtkTreeStore, iter: ptr GtkTreeIter, parent: ptr GtkTreeIter, position: gint)
```

**What it does.** The same logic as the identically-named `GtkListStore` functions, but with an additional `parent` parameter — the iterator of the parent row. Passing `nil` for `parent` adds the row at the top level of the tree.

- `treeStore` — the model.
- `iter` — the iterator that will be filled in to point to the new row.
- `parent` — the iterator of the parent row, or `nil` for the top level.
- `position` (for `insert`) — the insertion index among rows at the same level.

```nim
var rootFolder, childFile: GtkTreeIter
gtk_tree_store_append(fileTreeStore, addr rootFolder, nil)
gtk_tree_store_append(fileTreeStore, addr childFile, addr rootFolder)
echo "Top-level folder and a file nested inside it added"
```

---

### `gtk_tree_store_set`

```nim
proc gtk_tree_store_set*(treeStore: GtkTreeStore, iter: ptr GtkTreeIter) {.varargs.}
```

**What it does.** Fills in the column values of the given row — the same logic of alternating (column number, value) pairs terminated by `-1` as `gtk_list_store_set`.

- `treeStore` — the model.
- `iter` — the row whose values are being set.
- What follows — alternating (column number, value) pairs, terminated by `-1`.

```nim
gtk_tree_store_set(fileTreeStore, addr rootFolder, 0, "Projects".cstring, -1)
gtk_tree_store_set(fileTreeStore, addr childFile, 0, "main.nim".cstring, -1)
echo "Names of the folder and the nested file set"
```

---

### `gtk_tree_store_remove` / `gtk_tree_store_clear`

```nim
proc gtk_tree_store_remove*(treeStore: GtkTreeStore, iter: ptr GtkTreeIter): gboolean
proc gtk_tree_store_clear*(treeStore: GtkTreeStore)
```

**What it does.** Removes a row along with all of its child rows, and clears the tree entirely.

- `treeStore` — the model.
- `iter` — the iterator of the row to remove (for `remove`).

```nim
discard gtk_tree_store_remove(fileTreeStore, addr childFile)
echo "File removed from the folder"
```

---

## GtkTreeView

`GtkTreeView` — a widget that displays a `GtkTreeModel` as a table with columns, headers, and node expand/collapse.

### `gtk_tree_view_new` / `gtk_tree_view_new_with_model`

```nim
proc gtk_tree_view_new*(): GtkTreeView
proc gtk_tree_view_new_with_model*(model: GtkTreeModel): GtkTreeView
```

**What it does.** Creates the display widget — empty, or already attached to the given model.

- `model` — the data model (`GtkListStore`/`GtkTreeStore`, cast to `GtkTreeModel`).

```nim
let contactsView = gtk_tree_view_new_with_model(cast[GtkTreeModel](contactsStore))
echo "Display widget immediately connected to the contacts model"
```

---

### `gtk_tree_view_set_model` / `gtk_tree_view_get_model`

```nim
proc gtk_tree_view_set_model*(treeView: GtkTreeView, model: GtkTreeModel)
proc gtk_tree_view_get_model*(treeView: GtkTreeView): GtkTreeModel
```

**What it does.** Replaces the model of an already-existing widget with another one, and reads the currently attached model.

- `treeView` — the display widget.
- `model` — the new data model.

```nim
gtk_tree_view_set_model(contactsView, cast[GtkTreeModel](otherContactsStore))
echo "Widget's model replaced with a different one"
```

---

### `gtk_tree_view_append_column` / `gtk_tree_view_insert_column` / `gtk_tree_view_remove_column`

```nim
proc gtk_tree_view_append_column*(treeView: GtkTreeView, column: GtkTreeViewColumn): gint
proc gtk_tree_view_insert_column*(treeView: GtkTreeView, column: GtkTreeViewColumn, position: gint): gint
proc gtk_tree_view_remove_column*(treeView: GtkTreeView, column: GtkTreeViewColumn): gint
```

**What it does.** Adds a previously assembled column at the end, at an arbitrary position, or removes an already-added column. All three return the new total column count after the operation.

- `treeView` — the display widget.
- `column` — the column (`GtkTreeViewColumn`).
- `position` (for `insert_column`) — the insertion index.

```nim
let nameColumn = gtk_tree_view_column_new_with_attributes("Name".cstring, nameCellRenderer, "text".cstring, 0, nil)
discard gtk_tree_view_append_column(contactsView, nameColumn)
echo "'Name' column added to the display widget"
```

---

### `gtk_tree_view_get_selection`

```nim
proc gtk_tree_view_get_selection*(treeView: GtkTreeView): GtkTreeSelection
```

**What it does.** Returns the row-selection object associated with this widget.

- `treeView` — the display widget.

```nim
let selection = gtk_tree_view_get_selection(contactsView)
echo "Row selection object obtained"
```

---

### `gtk_tree_view_set_headers_visible` / `gtk_tree_view_get_headers_visible`

```nim
proc gtk_tree_view_set_headers_visible*(treeView: GtkTreeView, headersVisible: gboolean)
proc gtk_tree_view_get_headers_visible*(treeView: GtkTreeView): gboolean
```

**What it does.** Shows/hides the column header row entirely.

- `treeView` — the display widget.
- `headersVisible` — `0.gboolean` to hide the headers.

```nim
gtk_tree_view_set_headers_visible(contactsView, 0.gboolean)
echo "Column headers hidden — the widget now looks like a plain list"
```

---

### `gtk_tree_view_expand_all` / `gtk_tree_view_collapse_all`

```nim
proc gtk_tree_view_expand_all*(treeView: GtkTreeView)
proc gtk_tree_view_collapse_all*(treeView: GtkTreeView)
```

**What it does.** Expands/collapses all tree nodes at every nesting level at once — applicable only when a `GtkTreeStore` model is attached.

- `treeView` — the display widget.

```nim
gtk_tree_view_expand_all(fileTreeView)
echo "All folders in the file tree expanded"
```

---

## GtkTreeViewColumn

`GtkTreeViewColumn` — the description of a single `GtkTreeView` column: which cell renderers to display, which model column to bind them to, the title, the width.

### `gtk_tree_view_column_new` / `gtk_tree_view_column_new_with_attributes`

```nim
proc gtk_tree_view_column_new*(): GtkTreeViewColumn
proc gtk_tree_view_column_new_with_attributes*(title: cstring, cell: GtkCellRenderer, firstAttribute: cstring): GtkTreeViewColumn {.varargs.}
```

**What it does.** `gtk_tree_view_column_new` creates an empty column with no title and no renderer. `gtk_tree_view_column_new_with_attributes` is a shorthand: it sets the title, one renderer, and the binding of that renderer's properties to model columns, all at once. Attributes are passed as alternating "renderer property name"/"model column number" pairs, terminated by a mandatory `nil`.

- `title` — the column title.
- `cell` — the cell renderer.
- `firstAttribute`, followed by pairs (property name, model column number), terminated by `nil`.

```nim
let nameRenderer = gtk_cell_renderer_text_new()
let nameColumn = gtk_tree_view_column_new_with_attributes("Name".cstring, nameRenderer, "text".cstring, 0, nil)
echo "'Name' column, showing text from the model's column zero, created"
```

---

### `gtk_tree_view_column_pack_start` / `gtk_tree_view_column_pack_end` / `gtk_tree_view_column_add_attribute`

```nim
proc gtk_tree_view_column_pack_start*(treeColumn: GtkTreeViewColumn, cell: GtkCellRenderer, expand: gboolean)
proc gtk_tree_view_column_pack_end*(treeColumn: GtkTreeViewColumn, cell: GtkCellRenderer, expand: gboolean)
proc gtk_tree_view_column_add_attribute*(treeColumn: GtkTreeViewColumn, cellRenderer: GtkCellRenderer, attribute: cstring, column: gint)
```

**What it does.** A step-by-step alternative to `new_with_attributes` — relevant when a single column needs to display several renderers at once (for example, an icon and text side by side). `pack_start`/`pack_end` add a renderer at the beginning/end of the column. `add_attribute` binds a single renderer property to a model column.

- `treeColumn` — the column.
- `cell` — the cell renderer.
- `expand` — `1.gboolean` for the renderer to claim available free space.
- `attribute` — the renderer property name.
- `column` — the model column number.

```nim
let iconColumn = gtk_tree_view_column_new()
let iconRenderer = gtk_cell_renderer_pixbuf_new()
let textRenderer = gtk_cell_renderer_text_new()
gtk_tree_view_column_pack_start(iconColumn, iconRenderer, 0.gboolean)
gtk_tree_view_column_pack_start(iconColumn, textRenderer, 1.gboolean)
gtk_tree_view_column_add_attribute(iconColumn, iconRenderer, "pixbuf".cstring, 0)
gtk_tree_view_column_add_attribute(iconColumn, textRenderer, "text".cstring, 1)
echo "Column with an icon and text side by side assembled from two renderers"
```

---

### `gtk_tree_view_column_set_title` / `gtk_tree_view_column_get_title`

```nim
proc gtk_tree_view_column_set_title*(treeColumn: GtkTreeViewColumn, title: cstring)
proc gtk_tree_view_column_get_title*(treeColumn: GtkTreeViewColumn): cstring
```

**What it does.** Sets and reads the column title text after creation.

- `treeColumn` — the column.
- `title` — the new title text.

```nim
gtk_tree_view_column_set_title(nameColumn, "Full name")
echo "Column title changed: ", $gtk_tree_view_column_get_title(nameColumn)
```

---

### `gtk_tree_view_column_set_resizable` / `get_resizable` / `set_visible` / `get_visible`

```nim
proc gtk_tree_view_column_set_resizable*(treeColumn: GtkTreeViewColumn, resizable: gboolean)
proc gtk_tree_view_column_get_resizable*(treeColumn: GtkTreeViewColumn): gboolean
proc gtk_tree_view_column_set_visible*(treeColumn: GtkTreeViewColumn, visible: gboolean)
proc gtk_tree_view_column_get_visible*(treeColumn: GtkTreeViewColumn): gboolean
```

**What it does.** `resizable` allows the column width to be changed by dragging the header border. `visible` shows/hides the column entirely, without removing it from the widget.

- `treeColumn` — the column.
- `resizable`, `visible` — `1.gboolean`/`0.gboolean`.

```nim
gtk_tree_view_column_set_resizable(nameColumn, 1.gboolean)
echo "'Name' column can now be resized with the mouse"
```

---

### `gtk_tree_view_column_clear`

```nim
proc gtk_tree_view_column_clear*(treeColumn: GtkTreeViewColumn)
```

**What it does.** Removes all cell renderers previously added to the column, leaving it empty — needed for fully rebuilding a column's contents without creating a new object.

- `treeColumn` — the column.

```nim
gtk_tree_view_column_clear(iconColumn)
echo "All renderers removed from the column, ready to be rebuilt"
```

---

## GtkCellRenderer

`GtkCellRenderer` — the object responsible for drawing the contents of a single column cell (text, checkbox, image) based on the value from the corresponding model column.

### `gtk_cell_renderer_text_new` / `gtk_cell_renderer_toggle_new` / `gtk_cell_renderer_pixbuf_new`

```nim
proc gtk_cell_renderer_text_new*(): GtkCellRenderer
proc gtk_cell_renderer_toggle_new*(): GtkCellRenderer
proc gtk_cell_renderer_pixbuf_new*(): GtkCellRenderer
```

**What it does.** Creates the three most common renderer types: text, toggle (an interactive checkbox in the cell), and image (usually from a model column holding a `GdkPixbuf`).

- No parameters.

```nim
let textRenderer = gtk_cell_renderer_text_new()
let toggleRenderer = gtk_cell_renderer_toggle_new()
echo "Text renderer and toggle renderer created"
```

---

### `gtk_cell_renderer_toggle_set_active` / `get_active` / `set_radio` / `get_radio`

```nim
proc gtk_cell_renderer_toggle_set_active*(cellRenderer: GtkCellRenderer, setting: gboolean)
proc gtk_cell_renderer_toggle_get_active*(cellRenderer: GtkCellRenderer): gboolean
proc gtk_cell_renderer_toggle_set_radio*(cellRenderer: GtkCellRenderer, radio: gboolean)
proc gtk_cell_renderer_toggle_get_radio*(cellRenderer: GtkCellRenderer): gboolean
```

**What it does.** `set_active`/`get_active` control the renderer's checkbox state as a template — once the renderer is bound to a model column via `add_attribute` with the `"active"` property, each cell's actual state is taken from the model row. `set_radio`/`get_radio` toggle the visual style between a square checkbox and a round radio button — a purely visual setting; the logic of mutually exclusive selection across rows is implemented separately in a `"toggled"` signal handler.

- `cellRenderer` — the toggle renderer.
- `setting` — `1.gboolean` for a checked state by default.
- `radio` — `1.gboolean` for the radio-button visual style.

```nim
gtk_cell_renderer_toggle_set_radio(toggleRenderer, 0.gboolean)
echo "Toggle renderer set to the plain checkbox visual style"
```

---

## GtkTreeSelection

`GtkTreeSelection` — the object that manages row selection in a `GtkTreeView`, obtained via `gtk_tree_view_get_selection`.

### `gtk_tree_selection_set_mode` / `gtk_tree_selection_get_mode`

```nim
proc gtk_tree_selection_set_mode*(selection: GtkTreeSelection, mode: GtkSelectionMode)
proc gtk_tree_selection_get_mode*(selection: GtkTreeSelection): GtkSelectionMode
```

**What it does.** Sets the selection mode — the same logic and `GtkSelectionMode` values as `gtk_list_box_set_selection_mode`.

- `selection` — the selection object.
- `mode` — a `GtkSelectionMode` value.

```nim
gtk_tree_selection_set_mode(selection, GTK_SELECTION_MULTIPLE)
echo "Multiple rows can now be selected at once in the contacts table"
```

---

### `gtk_tree_selection_get_selected`

```nim
proc gtk_tree_selection_get_selected*(selection: GtkTreeSelection, model: ptr GtkTreeModel, iter: ptr GtkTreeIter): gboolean
```

**What it does.** Returns the selected row (filling in `iter`) and, optionally, the model (filling in `model`, if not `nil`). In `GTK_SELECTION_MULTIPLE` mode it returns only one (the last-selected) row. Returns a `gboolean` indicating whether anything was selected.

- `selection` — the selection object.
- `model` — a pointer for the model, or `nil`.
- `iter` — a pointer for the iterator of the selected row.

```nim
var selectedIter: GtkTreeIter
if gtk_tree_selection_get_selected(selection, nil, addr selectedIter) != 0.gboolean:
  echo "There is a selected row, iterator obtained"
else:
  echo "Nothing selected"
```

---

### `gtk_tree_selection_select_iter` / `unselect_iter` / `select_all` / `unselect_all`

```nim
proc gtk_tree_selection_select_iter*(selection: GtkTreeSelection, iter: ptr GtkTreeIter)
proc gtk_tree_selection_unselect_iter*(selection: GtkTreeSelection, iter: ptr GtkTreeIter)
proc gtk_tree_selection_select_all*(selection: GtkTreeSelection)
proc gtk_tree_selection_unselect_all*(selection: GtkTreeSelection)
```

**What it does.** Programmatically selects/deselects a specific row and all rows at once (`select_all`/`unselect_all` are only meaningful in `GTK_SELECTION_MULTIPLE` mode).

- `selection` — the selection object.
- `iter` — the row's iterator (for `select_iter`/`unselect_iter`).

```nim
gtk_tree_selection_select_iter(selection, addr newRow)
echo "The just-added row selected programmatically"
```

---

## GtkTreePath

`GtkTreePath` — a way of addressing a row independent of an iterator, via a sequence of numeric indices (e.g. `"2:1"`), convenient for serializing a position (unlike `GtkTreeIter`, which becomes invalid once the model changes).

### `gtk_tree_path_new` / `gtk_tree_path_new_from_string`

```nim
proc gtk_tree_path_new*(): GtkTreePath
proc gtk_tree_path_new_from_string*(path: cstring): GtkTreePath
```

**What it does.** `gtk_tree_path_new` creates an empty path. `gtk_tree_path_new_from_string` parses a path from text of the form `"2:1"` (indices separated by colons) — the more common way to obtain a path.

- `path` — the string representation of the path (for `new_from_string`).

```nim
let path = gtk_tree_path_new_from_string("0")
echo "Path to the first top-level row created"
```

---

### `gtk_tree_path_to_string` / `gtk_tree_path_free`

```nim
proc gtk_tree_path_to_string*(path: GtkTreePath): cstring
proc gtk_tree_path_free*(path: GtkTreePath)
```

**What it does.** `to_string` serializes the path back into a string. `free` releases the memory of the path object — unlike `GtkTreeIter`, `GtkTreePath` is a separately allocated object requiring explicit release.

- `path` — the path.

```nim
echo "String representation of the path: ", $gtk_tree_path_to_string(path)
gtk_tree_path_free(path)
echo "Path object memory released"
```

---

## GtkTreeModel

`GtkTreeModel` — the common interface implemented by both `GtkListStore` and `GtkTreeStore` — the functions in this section work identically with both.

### `gtk_tree_model_get_iter` / `gtk_tree_model_get_iter_first` / `gtk_tree_model_get_path`

```nim
proc gtk_tree_model_get_iter*(treeModel: GtkTreeModel, iter: ptr GtkTreeIter, path: GtkTreePath): gboolean
proc gtk_tree_model_get_iter_first*(treeModel: GtkTreeModel, iter: ptr GtkTreeIter): gboolean
proc gtk_tree_model_get_path*(treeModel: GtkTreeModel, iter: ptr GtkTreeIter): GtkTreePath
```

**What it does.** Converts between `GtkTreePath` and `GtkTreeIter`: `get_iter` fills in an iterator from a path, `get_iter_first` is a shorthand for the first top-level row. `get_path` builds a `GtkTreePath` (which ultimately needs to be released via `gtk_tree_path_free`) from an iterator.

- `treeModel` — the model.
- `iter` — the iterator.
- `path` — the path (for `get_iter`).

```nim
var firstRowIter: GtkTreeIter
if gtk_tree_model_get_iter_first(cast[GtkTreeModel](contactsStore), addr firstRowIter) != 0.gboolean:
  echo "Iterator of the model's first row obtained"
```

---

### `gtk_tree_model_get_value`

```nim
proc gtk_tree_model_get_value*(treeModel: GtkTreeModel, iter: ptr GtkTreeIter, column: gint, value: pointer)
```

**What it does.** Reads the value of the given row's column into a `GValue` object — extracting the actual string/number from the populated `GValue` requires separate functions such as `g_value_get_string`/`g_value_get_int`, not covered in this reference.

- `treeModel` — the model.
- `iter` — the row's iterator.
- `column` — the column number.
- `value` — a pointer to a `GValue` structure.

```nim
gtk_tree_model_get_value(cast[GtkTreeModel](contactsStore), addr firstRowIter, 0, addr gvalue)
echo "Value of the first row's column zero read into a GValue"
```

---

### `gtk_tree_model_iter_next` / `gtk_tree_model_iter_previous`

```nim
proc gtk_tree_model_iter_next*(treeModel: GtkTreeModel, iter: ptr GtkTreeIter): gboolean
proc gtk_tree_model_iter_previous*(treeModel: GtkTreeModel, iter: ptr GtkTreeIter): gboolean
```

**What it does.** Moves the iterator to the next/previous row at the same nesting level — the main way to walk the model's rows by hand.

- `treeModel` — the model.
- `iter` — the iterator that will be moved.

```nim
var iter: GtkTreeIter
discard gtk_tree_model_get_iter_first(cast[GtkTreeModel](contactsStore), addr iter)
while gtk_tree_model_iter_next(cast[GtkTreeModel](contactsStore), addr iter) != 0.gboolean:
  echo "Moved to the next row at the same level"
```

---

### `gtk_tree_model_iter_children` / `iter_has_child` / `iter_n_children` / `iter_nth_child` / `iter_parent`

```nim
proc gtk_tree_model_iter_children*(treeModel: GtkTreeModel, iter: ptr GtkTreeIter, parent: ptr GtkTreeIter): gboolean
proc gtk_tree_model_iter_has_child*(treeModel: GtkTreeModel, iter: ptr GtkTreeIter): gboolean
proc gtk_tree_model_iter_n_children*(treeModel: GtkTreeModel, iter: ptr GtkTreeIter): gint
proc gtk_tree_model_iter_nth_child*(treeModel: GtkTreeModel, iter: ptr GtkTreeIter, parent: ptr GtkTreeIter, n: gint): gboolean
proc gtk_tree_model_iter_parent*(treeModel: GtkTreeModel, iter: ptr GtkTreeIter, child: ptr GtkTreeIter): gboolean
```

**What it does.** Navigation down into and back out of the tree hierarchy (for a flat `GtkListStore`, `iter_has_child` is always `0.gboolean`). `iter_children` fills `iter` with the first child of the row `parent` (`nil` — top level). `iter_has_child`/`iter_n_children` check/count child rows. `iter_nth_child` gives direct access by index. `iter_parent` finds the parent of the row `child`.

- `treeModel` — the model.
- `iter` — the iterator to be filled with the result.
- `parent` — the parent row (or `nil`).
- `n` — the numeric index of the child row.
- `child` — the row whose parent is being looked up.

```nim
if gtk_tree_model_iter_has_child(cast[GtkTreeModel](fileTreeStore), addr rootFolder) != 0.gboolean:
  echo "The folder has ", gtk_tree_model_iter_n_children(cast[GtkTreeModel](fileTreeStore), addr rootFolder), " nested items"
  var firstChild: GtkTreeIter
  discard gtk_tree_model_iter_children(cast[GtkTreeModel](fileTreeStore), addr firstChild, addr rootFolder)
```

---

### `gtk_tree_model_get_string_from_iter`

```nim
proc gtk_tree_model_get_string_from_iter*(treeModel: GtkTreeModel, iter: ptr GtkTreeIter): cstring
```

**What it does.** A shorter alternative to the `get_path` + `to_string` combination — directly returns the string representation of a row's position without an intermediate `GtkTreePath` object.

- `treeModel` — the model.
- `iter` — the row's iterator.

```nim
let positionString = gtk_tree_model_get_string_from_iter(cast[GtkTreeModel](contactsStore), addr firstRowIter)
echo "Row position as a string: ", $positionString
```

---

## Practical recipes

### Simple list with one text column

A minimal assembly of `GtkListStore` + `GtkTreeView` with a single column — the most common starting scenario.

```nim
proc buildSimpleContactsList(): GtkTreeView =
  let store = gtk_list_store_new(1, G_TYPE_STRING)

  for name in ["Anna Ivanova", "Petr Smirnov", "Maria Kuznetsova"]:
    var iter: GtkTreeIter
    gtk_list_store_append(store, addr iter)
    gtk_list_store_set(store, addr iter, 0, name.cstring, -1)

  result = gtk_tree_view_new_with_model(cast[GtkTreeModel](store))
  let renderer = gtk_cell_renderer_text_new()
  let column = gtk_tree_view_column_new_with_attributes("Name".cstring, renderer, "text".cstring, 0, nil)
  discard gtk_tree_view_append_column(result, column)
  echo "List of three contacts with one column assembled"

let contactsView = buildSimpleContactsList()
```

---

### Tree with expandable nodes

A two-level folder → files hierarchy, displayed as a tree.

```nim
proc buildFileTree(): GtkTreeView =
  let store = gtk_tree_store_new(1, G_TYPE_STRING)

  var projectsFolder: GtkTreeIter
  gtk_tree_store_append(store, addr projectsFolder, nil)
  gtk_tree_store_set(store, addr projectsFolder, 0, "Projects".cstring, -1)

  for fileName in ["main.nim", "utils.nim"]:
    var fileIter: GtkTreeIter
    gtk_tree_store_append(store, addr fileIter, addr projectsFolder)
    gtk_tree_store_set(store, addr fileIter, 0, fileName.cstring, -1)

  result = gtk_tree_view_new_with_model(cast[GtkTreeModel](store))
  let renderer = gtk_cell_renderer_text_new()
  let column = gtk_tree_view_column_new_with_attributes("File".cstring, renderer, "text".cstring, 0, nil)
  discard gtk_tree_view_append_column(result, column)
  gtk_tree_view_expand_all(result)
  echo "'Projects' tree with two nested files assembled and expanded"

let fileTreeView = buildFileTree()
```

---

### Column with checkboxes on each row

A task list with an interactive "done" checkbox in a separate column.

```nim
proc onTaskToggled(cellRenderer: GtkCellRenderer, path: cstring, userData: gpointer) {.cdecl.} =
  let store = cast[GtkListStore](userData)
  let treePath = gtk_tree_path_new_from_string(path)
  var iter: GtkTreeIter
  if gtk_tree_model_get_iter(cast[GtkTreeModel](store), addr iter, treePath) != 0.gboolean:
    # The value is read via GValue (not shown here for brevity) and inverted,
    # then written back through gtk_list_store_set with the new boolean value.
    echo "Task checkbox toggled"
  gtk_tree_path_free(treePath)

proc buildTaskListWithCheckboxes(): GtkTreeView =
  let store = gtk_list_store_new(2, G_TYPE_BOOLEAN, G_TYPE_STRING)  # done, title

  var iter: GtkTreeIter
  gtk_list_store_append(store, addr iter)
  gtk_list_store_set(store, addr iter, 0, 0.gboolean, 1, "Write the report".cstring, -1)

  result = gtk_tree_view_new_with_model(cast[GtkTreeModel](store))

  let toggleRenderer = gtk_cell_renderer_toggle_new()
  discard g_signal_connect(toggleRenderer, "toggled", onTaskToggled, cast[gpointer](store))
  let doneColumn = gtk_tree_view_column_new_with_attributes("Done".cstring, toggleRenderer, "active".cstring, 0, nil)
  discard gtk_tree_view_append_column(result, doneColumn)

  let titleRenderer = gtk_cell_renderer_text_new()
  let titleColumn = gtk_tree_view_column_new_with_attributes("Task".cstring, titleRenderer, "text".cstring, 1, nil)
  discard gtk_tree_view_append_column(result, titleColumn)

  echo "Task list with an interactive checkbox column assembled"

let taskListView = buildTaskListWithCheckboxes()
```

---

### Manually walking all model rows via an iterator

Iterating over all top-level rows of a flat model, e.g. for counting or searching.

```nim
proc countRows(store: GtkListStore): int =
  var iter: GtkTreeIter
  var hasRow = gtk_tree_model_get_iter_first(cast[GtkTreeModel](store), addr iter) != 0.gboolean
  while hasRow:
    result += 1
    hasRow = gtk_tree_model_iter_next(cast[GtkTreeModel](store), addr iter) != 0.gboolean

echo "Number of rows in the model: ", countRows(contactsStore)
```

---

### Reacting to a user's row selection

A selection-changed handler that reads a value from the selected row.

```nim
proc onSelectionChanged(selection: GtkTreeSelection, userData: gpointer) {.cdecl.} =
  var iter: GtkTreeIter
  if gtk_tree_selection_get_selected(selection, nil, addr iter) != 0.gboolean:
    let path = gtk_tree_model_get_string_from_iter(cast[GtkTreeModel](contactsStore), addr iter)
    echo "User selected the row at position: ", $path

let selection = gtk_tree_view_get_selection(contactsView)
discard g_signal_connect(selection, "changed", onSelectionChanged, nil)
```

---

## Quick reference table

| Procedure(s) | Category | What it does in brief |
|---|---|---|
| `gtk_list_store_new`, `newv` | ListStore | Create a flat model with given columns |
| `gtk_list_store_append/prepend/insert` | ListStore | Add an empty row |
| `gtk_list_store_set` | ListStore | Fill in a row's column values |
| `gtk_list_store_remove`, `clear` | ListStore | Remove a row / clear the model |
| `gtk_tree_store_new` | TreeStore | Create a hierarchical model |
| `gtk_tree_store_append/prepend/insert` | TreeStore | Add a row (with or without a parent) |
| `gtk_tree_store_set` | TreeStore | Fill in a row's column values |
| `gtk_tree_store_remove`, `clear` | TreeStore | Remove a row along with its children / clear the tree |
| `gtk_tree_view_new`, `_with_model` | TreeView | Create the display widget |
| `gtk_tree_view_set/get_model` | TreeView | The attached data model |
| `gtk_tree_view_append/insert/remove_column` | TreeView | Column management |
| `gtk_tree_view_get_selection` | TreeView | The row-selection object |
| `gtk_tree_view_set/get_headers_visible` | TreeView | The column header row |
| `gtk_tree_view_expand_all`, `collapse_all` | TreeView | Expand/collapse all tree nodes |
| `gtk_tree_view_column_new`, `_with_attributes` | TreeViewColumn | Create a column |
| `gtk_tree_view_column_pack_start/end`, `add_attribute` | TreeViewColumn | Step-by-step assembly of multiple renderers in a column |
| `gtk_tree_view_column_set/get_title` | TreeViewColumn | The column title |
| `gtk_tree_view_column_set/get_resizable`, `set/get_visible` | TreeViewColumn | Column resizing and visibility |
| `gtk_tree_view_column_clear` | TreeViewColumn | Remove all of a column's renderers |
| `gtk_cell_renderer_text/toggle/pixbuf_new` | CellRenderer | Create a text/toggle/image renderer |
| `gtk_cell_renderer_toggle_set/get_active`, `set/get_radio` | CellRenderer | Checkbox state and visual style |
| `gtk_tree_selection_set/get_mode` | TreeSelection | Row selection mode |
| `gtk_tree_selection_get_selected` | TreeSelection | The currently selected row |
| `gtk_tree_selection_select/unselect_iter`, `select/unselect_all` | TreeSelection | Programmatic selection control |
| `gtk_tree_path_new`, `_from_string` | TreePath | Create a path to a row |
| `gtk_tree_path_to_string`, `free` | TreePath | Path serialization and release |
| `gtk_tree_model_get_iter`, `get_iter_first`, `get_path` | TreeModel | Path ↔ iterator conversion |
| `gtk_tree_model_get_value` | TreeModel | A row's column value via GValue |
| `gtk_tree_model_iter_next`, `iter_previous` | TreeModel | Walking rows at the same level |
| `gtk_tree_model_iter_children`, `has_child`, `n_children`, `nth_child`, `parent` | TreeModel | Navigating the tree hierarchy |
| `gtk_tree_model_get_string_from_iter` | TreeModel | A short string representation of a position |

---

## Summary: which procedure to choose

- **New code not tied to porting an existing GTK3 codebase** → prefer the modern `GtkColumnView`/`GtkListView` (separate reference) rather than starting with `GtkTreeView` — the entire API in this reference is officially deprecated.
- **Non-hierarchical data** (a simple list of records) → `GtkListStore`. **Nested data** (files and folders, a category structure) → `GtkTreeStore`.
- **A column shows a single value in a simple way** → `gtk_tree_view_column_new_with_attributes` with one renderer. **A single cell needs to show several elements at once** (icon + text) → step-by-step assembly via `pack_start`/`pack_end`/`add_attribute` on an empty column from `gtk_tree_view_column_new`.
- **A column needs to be temporarily hidden while keeping the ability to bring it back later** → `gtk_tree_view_column_set_visible(column, false)`, not `gtk_tree_view_remove_column` — `remove_column` requires rebuilding the column from scratch when it's brought back.
- **A row's position needs to survive subsequent model changes** (stored in an external structure, passed between functions not immediately) → `GtkTreePath` (via `gtk_tree_model_get_path`/`get_string_from_iter`), not a saved copy of a `GtkTreeIter`, which, like `GtkTextIter`, becomes invalid once the model changes.
- **Manually walking all rows of a model** → a chain of `get_iter_first` + `iter_next` in a loop for a single level; `iter_children`/`iter_has_child`/`iter_n_children` for recursively walking nested tree levels.
- **A column with an interactive checkbox on each row** → `GtkCellRendererToggle`, bound to a boolean model column via the `"active"` property, with a `"toggled"` signal handler on the renderer itself (not to be confused with `gtk_cell_renderer_toggle_set_active` — that's only a template value, not tied to a specific row once bound to the model).
