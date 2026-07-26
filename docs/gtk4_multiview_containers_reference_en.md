# GTK4 (multi-view containers: ListBox / Notebook / Paned / Stack) — module reference

> **Import:** `import libGTK4`
> **Scope:** containers that manage several "views" of content — a list of rows, tabs, an adjustable split into two panes, switchable screens. Seventh part of the wrapper reference series; assumes familiarity with the previous parts, especially `gtk4_core_reference_ru.md` (layout, `GtkWidget`).

The four widgets in this reference solve superficially similar but different problems: `GtkListBox` is a vertical list of arbitrary row widgets with selection support (unlike `GtkBox`, which simply lays out widgets with no notion of "row" or "selection"); `GtkNotebook` is classic tabs; `GtkPaned` is an area split into two parts by a draggable divider; `GtkStack` is several "screens" occupying the same spot, of which only one is visible — like slides in a presentation, switched either programmatically or via `GtkStackSwitcher`.

---

## Table of contents

I. [GtkListBox](#gtklistbox)
&nbsp;&nbsp;1. [`gtk_list_box_new`](#gtk_list_box_new)
&nbsp;&nbsp;2. [`gtk_list_box_append` / `gtk_list_box_prepend` / `gtk_list_box_insert` / `gtk_list_box_remove`](#gtk_list_box_append--gtk_list_box_prepend--gtk_list_box_insert--gtk_list_box_remove)
&nbsp;&nbsp;3. [`gtk_list_box_set_selection_mode` / `gtk_list_box_get_selection_mode`](#gtk_list_box_set_selection_mode--gtk_list_box_get_selection_mode)
&nbsp;&nbsp;4. [`gtk_list_box_select_row` / `gtk_list_box_unselect_row` / `gtk_list_box_get_selected_row`](#gtk_list_box_select_row--gtk_list_box_unselect_row--gtk_list_box_get_selected_row)
&nbsp;&nbsp;5. [`gtk_list_box_row_new` / `gtk_list_box_row_set_child` / `gtk_list_box_row_get_child` / `gtk_list_box_row_get_index`](#gtk_list_box_row_new--gtk_list_box_row_set_child--gtk_list_box_row_get_child--gtk_list_box_row_get_index)

II. [GtkNotebook](#gtknotebook)
&nbsp;&nbsp;1. [`gtk_notebook_new`](#gtk_notebook_new)
&nbsp;&nbsp;2. [`gtk_notebook_append_page` / `gtk_notebook_prepend_page` / `gtk_notebook_insert_page`](#gtk_notebook_append_page--gtk_notebook_prepend_page--gtk_notebook_insert_page)
&nbsp;&nbsp;3. [`gtk_notebook_remove_page`](#gtk_notebook_remove_page)
&nbsp;&nbsp;4. [`gtk_notebook_set_current_page` / `gtk_notebook_get_current_page`](#gtk_notebook_set_current_page--gtk_notebook_get_current_page)
&nbsp;&nbsp;5. [`gtk_notebook_get_nth_page` / `gtk_notebook_get_n_pages`](#gtk_notebook_get_nth_page--gtk_notebook_get_n_pages)
&nbsp;&nbsp;6. [`gtk_notebook_set_tab_pos` / `gtk_notebook_get_tab_pos`](#gtk_notebook_set_tab_pos--gtk_notebook_get_tab_pos)
&nbsp;&nbsp;7. [`gtk_notebook_set_show_tabs` / `gtk_notebook_get_show_tabs`](#gtk_notebook_set_show_tabs--gtk_notebook_get_show_tabs)
&nbsp;&nbsp;8. [`gtk_notebook_set_scrollable`](#gtk_notebook_set_scrollable)

III. [GtkPaned](#gtkpaned)
&nbsp;&nbsp;1. [`gtk_paned_new`](#gtk_paned_new)
&nbsp;&nbsp;2. [`gtk_paned_set_start_child` / `gtk_paned_get_start_child` / `gtk_paned_set_end_child` / `gtk_paned_get_end_child`](#gtk_paned_set_start_child--gtk_paned_get_start_child--gtk_paned_set_end_child--gtk_paned_get_end_child)
&nbsp;&nbsp;3. [`gtk_paned_set_position` / `gtk_paned_get_position`](#gtk_paned_set_position--gtk_paned_get_position)

IV. [GtkStack (and GtkStackSwitcher)](#gtkstack-and-gtkstackswitcher)
&nbsp;&nbsp;1. [`gtk_stack_new`](#gtk_stack_new)
&nbsp;&nbsp;2. [`gtk_stack_add_child` / `gtk_stack_add_named` / `gtk_stack_add_titled`](#gtk_stack_add_child--gtk_stack_add_named--gtk_stack_add_titled)
&nbsp;&nbsp;3. [`gtk_stack_remove` / `gtk_stack_get_child_by_name`](#gtk_stack_remove--gtk_stack_get_child_by_name)
&nbsp;&nbsp;4. [`gtk_stack_set_visible_child` / `gtk_stack_get_visible_child` / `set_visible_child_name` / `get_visible_child_name`](#gtk_stack_set_visible_child--gtk_stack_get_visible_child--set_visible_child_name--get_visible_child_name)
&nbsp;&nbsp;5. [`gtk_stack_set_transition_type` / `gtk_stack_get_transition_type` / `set_transition_duration` / `get_transition_duration`](#gtk_stack_set_transition_type--gtk_stack_get_transition_type--set_transition_duration--get_transition_duration)
&nbsp;&nbsp;6. [`gtk_stack_switcher_new` / `gtk_stack_switcher_set_stack` / `gtk_stack_switcher_get_stack`](#gtk_stack_switcher_new--gtk_stack_switcher_set_stack--gtk_stack_switcher_get_stack)

V. [Practical recipes](#practical-recipes)
&nbsp;&nbsp;1. [A contacts list with composite rows and multiple-selection mode](#a-contacts-list-with-composite-rows-and-multiple-selection-mode)
&nbsp;&nbsp;2. [Document-editor tabs with a close button](#document-editor-tabs-with-a-close-button)
&nbsp;&nbsp;3. [An area split into two panes: list on the left, details on the right](#an-area-split-into-two-panes-list-on-the-left-details-on-the-right)
&nbsp;&nbsp;4. [A settings screen switched via GtkStackSwitcher](#a-settings-screen-switched-via-gtkstackswitcher)
&nbsp;&nbsp;5. [Programmatic switching between "loading" and "result" in the same spot on screen](#programmatic-switching-between-loading-and-result-in-the-same-spot-on-screen)

VI. [Summary table](#summary-table)

VII. [Summary: which procedure to choose](#summary-which-procedure-to-choose)

---

## GtkListBox

`GtkListBox` is a vertical list where each item is a `GtkListBoxRow` holding an arbitrary widget (unlike simply enumerating widgets in a `GtkBox`, `GtkListBox` knows about row selection, supports several selection modes, and has a special CSS style for list rows). It differs from full-fledged data models (`GtkColumnView`/`GtkListView`, outside the scope of this reference) in that each row is an ordinary widget, created and filled by hand, rather than being built automatically from a data model — more convenient for short lists with arbitrarily complex row layout, but not designed for thousands of items.

### `gtk_list_box_new`

```nim
proc gtk_list_box_new*(): GtkListBox
```

**What it does.** Creates an empty list.

- No parameters.

```nim
let contactsList = gtk_list_box_new()
echo "Contacts list created"
```

---

### `gtk_list_box_append` / `gtk_list_box_prepend` / `gtk_list_box_insert` / `gtk_list_box_remove`

```nim
proc gtk_list_box_append*(box: GtkListBox, child: GtkWidget)
proc gtk_list_box_prepend*(box: GtkListBox, child: GtkWidget)
proc gtk_list_box_insert*(box: GtkListBox, child: GtkWidget, position: gint)
proc gtk_list_box_remove*(box: GtkListBox, child: GtkWidget)
```

**What it does.** Add and remove list rows — the same insertion-order logic as `gtk_box_append`/`prepend`/`insert_child_after` from the basic reference. The passed `child` can be either an explicitly created `GtkListBoxRow` (see the row subsection below — needed when fine control over the row itself is required, for example its own CSS name) or an arbitrary widget directly — in which case `GtkListBox` implicitly wraps it in a `GtkListBoxRow` automatically.

- `box` — the list.
- `child` — the widget to add (a row, or an arbitrary widget that will be wrapped automatically).
- `position` (for `insert`) — the insertion index.

```nim
let contactsList = gtk_list_box_new()
gtk_list_box_append(contactsList, gtk_label_new("Anna Ivanova"))
gtk_list_box_append(contactsList, gtk_label_new("Peter Smirnov"))
echo "Two contacts added to the list"
```

---

### `gtk_list_box_set_selection_mode` / `gtk_list_box_get_selection_mode`

```nim
proc gtk_list_box_set_selection_mode*(box: GtkListBox, mode: GtkSelectionMode)
proc gtk_list_box_get_selection_mode*(box: GtkListBox): GtkSelectionMode
```

**What it does.** Set how many list rows can be selected at once and whether the selection can be cleared entirely: `GTK_SELECTION_NONE` — selection disabled (the list is used only for display, with no interactivity), `GTK_SELECTION_SINGLE` — one row can be selected or none at all, `GTK_SELECTION_BROWSE` — exactly one row is always selected (the default value — clicking another row moves the selection to it, but the selection can never be fully cleared), `GTK_SELECTION_MULTIPLE` — several rows can be selected at once (`Ctrl+click`, `Shift+click`).

- `box` — the list.
- `mode` — a `GtkSelectionMode` value.

```nim
gtk_list_box_set_selection_mode(contactsList, GTK_SELECTION_MULTIPLE)
echo "Contacts list now supports selecting several rows at once"
```

---

### `gtk_list_box_select_row` / `gtk_list_box_unselect_row` / `gtk_list_box_get_selected_row`

```nim
proc gtk_list_box_select_row*(box: GtkListBox, row: GtkListBoxRow)
proc gtk_list_box_unselect_row*(box: GtkListBox, row: GtkListBoxRow)
proc gtk_list_box_get_selected_row*(box: GtkListBox): GtkListBoxRow
```

**What it does.** Programmatically select/deselect a specific row, and read the currently selected row. `get_selected_row` returns only a single row (the last one selected) even in `GTK_SELECTION_MULTIPLE` mode — to get the full list of selected rows under multiple selection, this wrapper would need a separate function for iterating over all selected rows, which isn't part of this set (`gtk_list_box_selected_foreach`); for most single-selection scenarios (`GTK_SELECTION_SINGLE`/`_BROWSE`), `get_selected_row` is exactly what's needed.

- `box` — the list.
- `row` — the row (a `GtkListBoxRow` object, not the arbitrary widget passed into `append` — if the row wasn't created manually via `gtk_list_box_row_new`, GTK still wraps it in a `GtkListBoxRow`, accessible through the `"row-selected"`/`"row-activated"` signals).

```nim
let selected = gtk_list_box_get_selected_row(contactsList)
if not isNil(selected):
  echo "Row selected at index: ", gtk_list_box_row_get_index(selected)
```

---

### `gtk_list_box_row_new` / `gtk_list_box_row_set_child` / `gtk_list_box_row_get_child` / `gtk_list_box_row_get_index`

```nim
proc gtk_list_box_row_new*(): GtkListBoxRow
proc gtk_list_box_row_set_child*(row: GtkListBoxRow, child: GtkWidget)
proc gtk_list_box_row_get_child*(row: GtkListBoxRow): GtkWidget
proc gtk_list_box_row_get_index*(row: GtkListBoxRow): gint
```

**What it does.** Explicitly create a list row separately from adding it to the list — needed when something must be done to the row before or besides adding content via `append` (for example, setting `gtk_widget_set_name` on the row for targeted CSS styling of that specific row). `row_set_child`/`row_get_child` — the row's single content slot, the same "one child" pattern as with the window/frame/scrolled container — for several elements within one row, a `GtkBox` is used. `row_get_index` returns the row's position in the list (starting at `0`) — not an identifier, but the current position, which changes as other rows are inserted/removed.

- `row` — the row.
- `child` — the row's content.

```nim
let complexRow = gtk_list_box_row_new()
let rowContent = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 8)
gtk_box_append(rowContent, gtk_image_new_from_icon_name("avatar-default-symbolic"))
gtk_box_append(rowContent, gtk_label_new("Maria Kuznetsova"))
gtk_list_box_row_set_child(complexRow, rowContent)
gtk_list_box_append(contactsList, complexRow)
echo "Row with an icon and a name added as an explicit GtkListBoxRow"
```

---

## GtkNotebook

`GtkNotebook` is the classic tab widget: several content pages that the user switches between by clicking a tab label. Each page is added as a pair of widgets — the page's content and the tab-label widget (usually a `GtkLabel`, but it can be something more elaborate too, such as a label with a close button).

### `gtk_notebook_new`

```nim
proc gtk_notebook_new*(): GtkNotebook
```

**What it does.** Creates an empty tab widget with no pages.

- No parameters.

```nim
let documentTabs = gtk_notebook_new()
echo "Editor tab widget created"
```

---

### `gtk_notebook_append_page` / `gtk_notebook_prepend_page` / `gtk_notebook_insert_page`

```nim
proc gtk_notebook_append_page*(notebook: GtkNotebook, child: GtkWidget, tabLabel: GtkWidget): gint
proc gtk_notebook_prepend_page*(notebook: GtkNotebook, child: GtkWidget, tabLabel: GtkWidget): gint
proc gtk_notebook_insert_page*(notebook: GtkNotebook, child: GtkWidget, tabLabel: GtkWidget, position: gint): gint
```

**What it does.** Add a new tab — `child` becomes the page's content, `tabLabel` is the widget for the tab label itself (usually `gtk_label_new`, but any widget will do, up to a `GtkBox` with an icon and a close button, see section V). All three variants return the numeric index of the added page (starting at `0`) — convenient to save right away for later use with `set_current_page`/`remove_page`, rather than relying on the index staying predictable after further inserts/removals of other tabs.

- `notebook` — the tab widget.
- `child` — the new page's content.
- `tabLabel` — the tab-label widget.
- `position` (for `insert_page`) — the insertion index.

```nim
let firstDocView = gtk_text_view_new()
let tabIndex = gtk_notebook_append_page(documentTabs, firstDocView, gtk_label_new("Document 1"))
echo "Tab added at index ", tabIndex
```

---

### `gtk_notebook_remove_page`

```nim
proc gtk_notebook_remove_page*(notebook: GtkNotebook, pageNum: gint)
```

**What it does.** Removes a tab by numeric index along with its content (the content widget itself is not destroyed, only detached — just like `gtk_box_remove` for `GtkBox`). After removal, the indices of all subsequent tabs shift down by one — if tab indices are stored anywhere in the application's logic (for example, to associate a tab with an open file), they need to be recalculated after every removal.

- `notebook` — the tab widget.
- `pageNum` — the index of the tab to remove.

```nim
gtk_notebook_remove_page(documentTabs, tabIndex)
echo "Document tab closed"
```

---

### `gtk_notebook_set_current_page` / `gtk_notebook_get_current_page`

```nim
proc gtk_notebook_set_current_page*(notebook: GtkNotebook, pageNum: gint)
proc gtk_notebook_get_current_page*(notebook: GtkNotebook): gint
```

**What it does.** Switch the active (visible) tab programmatically, and read the index of the currently active tab. `set_current_page(notebook, -1)` switches to the most recently added tab — a convenient way to immediately activate a just-created tab without remembering its exact index, provided it was indeed added last.

- `notebook` — the tab widget.
- `pageNum` — the index of the tab to activate, or `-1` for the last one.

```nim
gtk_notebook_set_current_page(documentTabs, -1)  # switch to the tab just added
echo "Active tab index: ", gtk_notebook_get_current_page(documentTabs)
```

---

### `gtk_notebook_get_nth_page` / `gtk_notebook_get_n_pages`

```nim
proc gtk_notebook_get_nth_page*(notebook: GtkNotebook, pageNum: gint): GtkWidget
proc gtk_notebook_get_n_pages*(notebook: GtkNotebook): gint
```

**What it does.** Return the page's content widget by index, and the total number of tabs — for example, to iterate over all open documents to check whether any of them have unsaved changes before closing the application.

- `notebook` — the tab widget.
- `pageNum` — the page's index.

```nim
for i in 0 ..< gtk_notebook_get_n_pages(documentTabs):
  let pageContent = gtk_notebook_get_nth_page(documentTabs, gint(i))
  echo "Page ", i, ": content widget obtained"
```

---

### `gtk_notebook_set_tab_pos` / `gtk_notebook_get_tab_pos`

```nim
proc gtk_notebook_set_tab_pos*(notebook: GtkNotebook, pos: GtkPositionType)
proc gtk_notebook_get_tab_pos*(notebook: GtkNotebook): GtkPositionType
```

**What it does.** Set which side of the content area the tab labels are placed on — `GTK_POS_TOP` (top, the default value), `_BOTTOM`, `_LEFT`, `_RIGHT` (a vertical column of tabs along the side).

- `notebook` — the tab widget.
- `pos` — a `GtkPositionType` value.

```nim
gtk_notebook_set_tab_pos(documentTabs, GTK_POS_LEFT)
echo "Tab labels moved to the left side"
```

---

### `gtk_notebook_set_show_tabs` / `gtk_notebook_get_show_tabs`

```nim
proc gtk_notebook_set_show_tabs*(notebook: GtkNotebook, showTabs: gboolean)
proc gtk_notebook_get_show_tabs*(notebook: GtkNotebook): gboolean
```

**What it does.** Show/hide the entire row of tab labels, leaving page switching available only programmatically (`set_current_page`) — for example, for a multi-step setup wizard implemented via `GtkNotebook` for the sake of its built-in page logic, but with no visual tabs that the user could switch between in an arbitrary order themselves.

- `notebook` — the tab widget.
- `showTabs` — `0.gboolean` to hide the labels.

```nim
gtk_notebook_set_show_tabs(wizardNotebook, 0.gboolean)
echo "Tab labels hidden — switching is only programmatic, via Next/Back buttons"
```

---

### `gtk_notebook_set_scrollable`

```nim
proc gtk_notebook_set_scrollable*(notebook: GtkNotebook, scrollable: gboolean)
```

**What it does.** Allows scrolling the row of tab labels (with arrows at the edges) when more tabs are open than fit within the width, instead of shrinking every label down to an unreadable minimum. Relevant for applications that can have a large number of simultaneously open tabs (text editors, browsers).

- `notebook` — the tab widget.
- `scrollable` — `1.gboolean` to allow scrolling the labels.

```nim
gtk_notebook_set_scrollable(documentTabs, 1.gboolean)
echo "With many open documents, the tab labels can now be scrolled"
```

---

## GtkPaned

`GtkPaned` is an area split into two parts (`start`/`end` — left/right for horizontal orientation, top/bottom for vertical) by a draggable divider, letting the user adjust the ratio of the two panes' sizes themselves. The classic example: a file manager with a folder tree on the left and a file list on the right.

### `gtk_paned_new`

```nim
proc gtk_paned_new*(orientation: GtkOrientation): GtkPaned
```

**What it does.** Creates an empty split area with the given orientation. `GTK_ORIENTATION_HORIZONTAL` — the panes sit side by side horizontally (`start` on the left, `end` on the right), `GTK_ORIENTATION_VERTICAL` — one above the other (`start` on top, `end` at the bottom).

- `orientation` — `GTK_ORIENTATION_HORIZONTAL` or `GTK_ORIENTATION_VERTICAL`.

```nim
let mainSplit = gtk_paned_new(GTK_ORIENTATION_HORIZONTAL)
echo "Horizontally split area created: a pane on the left and on the right"
```

---

### `gtk_paned_set_start_child` / `gtk_paned_get_start_child` / `gtk_paned_set_end_child` / `gtk_paned_get_end_child`

```nim
proc gtk_paned_set_start_child*(paned: GtkPaned, child: GtkWidget)
proc gtk_paned_get_start_child*(paned: GtkPaned): GtkWidget
proc gtk_paned_set_end_child*(paned: GtkPaned, child: GtkWidget)
proc gtk_paned_get_end_child*(paned: GtkPaned): GtkWidget
```

**What it does.** Set and read the content of each of the two panes independently. As with `GtkBox`, for several elements within one pane, a container is made the single child.

- `paned` — the split area.
- `child` — the content widget for the corresponding pane.

```nim
gtk_paned_set_start_child(mainSplit, folderTreeScrolled)
gtk_paned_set_end_child(mainSplit, fileListScrolled)
echo "Folder tree on the left, file list on the right"
```

---

### `gtk_paned_set_position` / `gtk_paned_get_position`

```nim
proc gtk_paned_set_position*(paned: GtkPaned, position: gint)
proc gtk_paned_get_position*(paned: GtkPaned): gint
```

**What it does.** Set and read the divider's position in pixels from the start of the area (the left edge for horizontal orientation, the top edge for vertical) — effectively the `start` pane's width (or height). It's worth setting the position right after creation — without an explicit `set_position`, GTK splits the space roughly in half, which isn't always appropriate (for example, a folder tree usually needs a narrower pane than a file list).

- `paned` — the split area.
- `position` — the divider's position in pixels.

```nim
gtk_paned_set_position(mainSplit, 220)  # folder-tree pane 220px wide
echo "Initial width of the left pane: ", gtk_paned_get_position(mainSplit), " pixels"
```

---

## GtkStack (and GtkStackSwitcher)

`GtkStack` shows exactly one of several widgets added to it, all occupying the same spot, with a smooth transition animation between them when switching. Unlike `GtkNotebook`, `GtkStack` has no visual row of switch buttons of its own — that's handled separately by `GtkStackSwitcher` (or, in other scenarios, `GtkStackSidebar` — outside the scope of this reference), or switching is done entirely programmatically, with no visible control at all (for example, switching between a loading screen and a result screen).

### `gtk_stack_new`

```nim
proc gtk_stack_new*(): GtkStack
```

**What it does.** Creates an empty stack with no pages.

- No parameters.

```nim
let settingsStack = gtk_stack_new()
echo "Settings screen stack created"
```

---

### `gtk_stack_add_child` / `gtk_stack_add_named` / `gtk_stack_add_titled`

```nim
proc gtk_stack_add_child*(stack: GtkStack, child: GtkWidget): GtkWidget
proc gtk_stack_add_named*(stack: GtkStack, child: GtkWidget, name: cstring): GtkWidget
proc gtk_stack_add_titled*(stack: GtkStack, child: GtkWidget, name: cstring, title: cstring): GtkWidget
```

**What it does.** Three levels of adding a page to the stack. `gtk_stack_add_child` is the minimal variant, with no name (the page can only be referred to later through the widget object itself, not by a string identifier). `gtk_stack_add_named` adds with a name — the `name` that `gtk_stack_set_visible_child_name` then uses for switching, and that `GtkStackSwitcher` uses to match a switch button to a page. `gtk_stack_add_titled` is the same as `_named`, but additionally with a human-readable `title`, which `GtkStackSwitcher` uses as the caption on the switch button (unlike `name`, meant to stay technical and unchanged under interface localization). All three variants return the same `child` that was passed in — convenient for chaining without an intermediate variable.

- `stack` — the stack.
- `child` — the page widget to add.
- `name` — the page's technical string identifier.
- `title` — the title visible to the user (for `add_titled`).

```nim
let generalPage = gtk_box_new(GTK_ORIENTATION_VERTICAL, 8)
let networkPage = gtk_box_new(GTK_ORIENTATION_VERTICAL, 8)
discard gtk_stack_add_titled(settingsStack, generalPage, "general", "General")
discard gtk_stack_add_titled(settingsStack, networkPage, "network", "Network")
echo "Two settings screens added to the stack with names and titles"
```

---

### `gtk_stack_remove` / `gtk_stack_get_child_by_name`

```nim
proc gtk_stack_remove*(stack: GtkStack, child: GtkWidget)
proc gtk_stack_get_child_by_name*(stack: GtkStack, name: cstring): GtkWidget
```

**What it does.** Remove a page from the stack (by widget object), and find a page by its technical name set via `add_named`/`add_titled` (returns `nil` if there's no page with that name — including when a page was added via `add_child` with no name at all).

- `stack` — the stack.
- `child` — the page widget to remove.
- `name` — the technical name of the page to find.

```nim
let networkPageFound = gtk_stack_get_child_by_name(settingsStack, "network")
echo "'network' page found in the stack: ", not isNil(networkPageFound)
```

---

### `gtk_stack_set_visible_child` / `gtk_stack_get_visible_child` / `set_visible_child_name` / `get_visible_child_name`

```nim
proc gtk_stack_set_visible_child*(stack: GtkStack, child: GtkWidget)
proc gtk_stack_get_visible_child*(stack: GtkStack): GtkWidget
proc gtk_stack_set_visible_child_name*(stack: GtkStack, name: cstring)
proc gtk_stack_get_visible_child_name*(stack: GtkStack): cstring
```

**What it does.** Switch the visible page — by widget object (`set_visible_child`, works for any page, including ones added via `add_child` with no name) or by technical name (`set_visible_child_name`, only for pages added with a name). Switching triggers the transition animation, configurable via the next subsection. `get_visible_child`/`get_visible_child_name` read the current visible page — the second function is more convenient when the application's logic already works with page names rather than storing direct references to widget objects.

- `stack` — the stack.
- `child` — the target page (as an object).
- `name` — the target page's technical name.

```nim
gtk_stack_set_visible_child_name(settingsStack, "network")
echo "Network settings screen shown: ", $gtk_stack_get_visible_child_name(settingsStack)
```

---

### `gtk_stack_set_transition_type` / `gtk_stack_get_transition_type` / `set_transition_duration` / `get_transition_duration`

```nim
proc gtk_stack_set_transition_type*(stack: GtkStack, transition: GtkStackTransitionType)
proc gtk_stack_get_transition_type*(stack: GtkStack): GtkStackTransitionType
proc gtk_stack_set_transition_duration*(stack: GtkStack, duration: cuint)
proc gtk_stack_get_transition_duration*(stack: GtkStack): cuint
```

**What it does.** Configure the transition animation between pages when switching. `transition` is the animation type: `GTK_STACK_TRANSITION_TYPE_NONE` (instant, no animation), `_CROSSFADE` (a smooth cross-fade — a universal default choice for most cases), various sliding variants (`_SLIDE_LEFT`/`_RIGHT`/`_UP`/`_DOWN`, and ones that pick a direction automatically based on the pages' relative order — `_SLIDE_LEFT_RIGHT`/`_SLIDE_UP_DOWN`), and overlay variants (`_OVER_*`/`_UNDER_*` — the new page slides over the old one, or emerges from beneath it). `duration` is the animation's length in milliseconds (200 ms by default).

- `stack` — the stack.
- `transition` — a `GtkStackTransitionType` value.
- `duration` — the length in milliseconds.

```nim
gtk_stack_set_transition_type(settingsStack, GTK_STACK_TRANSITION_TYPE_SLIDE_LEFT_RIGHT)
gtk_stack_set_transition_duration(settingsStack, 250)
echo "Switching between settings screens is now animated as a slide in the appropriate direction over 250 ms"
```

---

### `gtk_stack_switcher_new` / `gtk_stack_switcher_set_stack` / `gtk_stack_switcher_get_stack`

```nim
proc gtk_stack_switcher_new*(): GtkStackSwitcher
proc gtk_stack_switcher_set_stack*(switcher: GtkStackSwitcher, stack: GtkStack)
proc gtk_stack_switcher_get_stack*(switcher: GtkStackSwitcher): GtkStack
```

**What it does.** `GtkStackSwitcher` is a ready-made row of switch buttons, one for every stack page added with a `title` via `gtk_stack_add_titled` (pages with no title don't appear in the switcher). `gtk_stack_switcher_set_stack` links the switcher to a specific stack — after that, the switcher automatically shows buttons for all current and subsequently added pages, with no manual synchronization needed.

- `switcher` — the switcher.
- `stack` — the stack to link the switcher to.

```nim
let switcher = gtk_stack_switcher_new()
gtk_stack_switcher_set_stack(switcher, settingsStack)

let settingsRoot = gtk_box_new(GTK_ORIENTATION_VERTICAL, 8)
gtk_widget_set_halign(switcher, GTK_ALIGN_CENTER)
gtk_box_append(settingsRoot, switcher)
gtk_box_append(settingsRoot, settingsStack)
echo "Switcher with 'General'/'Network' buttons automatically synchronized with the stack"
```

---

## Practical recipes

### A contacts list with composite rows and multiple-selection mode

List rows with an icon and two lines of text (a name and a status), with the ability to select several contacts at once.

```nim
proc buildContactRow(name, status: string): GtkWidget =
  let row = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 8)
  gtk_widget_set_margin_top(row, 6)
  gtk_widget_set_margin_bottom(row, 6)
  gtk_widget_set_margin_start(row, 8)
  gtk_widget_set_margin_end(row, 8)

  gtk_box_append(row, gtk_image_new_from_icon_name("avatar-default-symbolic"))

  let textColumn = gtk_box_new(GTK_ORIENTATION_VERTICAL, 2)
  gtk_box_append(textColumn, gtk_label_new(name.cstring))
  let statusLabel = gtk_label_new(status.cstring)
  gtk_widget_add_css_class(statusLabel, "dim-label")
  gtk_box_append(textColumn, statusLabel)
  gtk_box_append(row, textColumn)

  result = row

proc buildContactsList(): GtkListBox =
  result = gtk_list_box_new()
  gtk_list_box_set_selection_mode(result, GTK_SELECTION_MULTIPLE)
  gtk_list_box_append(result, buildContactRow("Anna Ivanova", "online"))
  gtk_list_box_append(result, buildContactRow("Peter Smirnov", "offline"))
  echo "Contacts list with composite rows and multiple selection assembled"

let contactsList = buildContactsList()
```

---

### Document-editor tabs with a close button

The tab label is not just text but a `GtkBox` with a caption and a small close button.

```nim
proc buildClosableTab(notebook: GtkNotebook, title: string, content: GtkWidget) =
  let tabLabel = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 4)
  gtk_box_append(tabLabel, gtk_label_new(title.cstring))

  let closeButton = gtk_button_new_from_icon_name("window-close-symbolic")
  gtk_button_set_has_frame(closeButton, 0.gboolean)
  gtk_widget_add_css_class(closeButton, "flat")

  proc onCloseClicked(button: GtkButton, userData: gpointer) {.cdecl.} =
    let nb = cast[GtkNotebook](userData)
    let pageIndex = gtk_notebook_get_current_page(nb)
    gtk_notebook_remove_page(nb, pageIndex)
    echo "Tab closed by clicking the button in its label"

  discard g_signal_connect(closeButton, "clicked", onCloseClicked, cast[gpointer](notebook))
  gtk_box_append(tabLabel, closeButton)

  discard gtk_notebook_append_page(notebook, content, tabLabel)

let editorTabs = gtk_notebook_new()
gtk_notebook_set_scrollable(editorTabs, 1.gboolean)
buildClosableTab(editorTabs, "main.nim", gtk_text_view_new())
buildClosableTab(editorTabs, "utils.nim", gtk_text_view_new())
```

---

### An area split into two panes: list on the left, details on the right

A file manager / mail client — a typical layout: a narrow navigation pane on the left, a wide content area on the right.

```nim
proc buildMasterDetailLayout(): GtkPaned =
  result = gtk_paned_new(GTK_ORIENTATION_HORIZONTAL)

  let folderList = gtk_list_box_new()
  gtk_list_box_append(folderList, gtk_label_new("Inbox"))
  gtk_list_box_append(folderList, gtk_label_new("Sent"))
  gtk_list_box_append(folderList, gtk_label_new("Drafts"))
  let folderScrolled = gtk_scrolled_window_new()
  gtk_scrolled_window_set_child(folderScrolled, folderList)
  gtk_paned_set_start_child(result, folderScrolled)

  let messageView = gtk_text_view_new()
  gtk_text_view_set_editable(messageView, 0.gboolean)
  let messageScrolled = gtk_scrolled_window_new()
  gtk_scrolled_window_set_child(messageScrolled, messageView)
  gtk_paned_set_end_child(result, messageScrolled)

  gtk_paned_set_position(result, 180)
  echo "Folder list on the left (180px), message view on the right"

let mailLayout = buildMasterDetailLayout()
```

---

### A settings screen switched via GtkStackSwitcher

A complete build of a stack with two settings screens and a row of switch buttons above it.

```nim
proc buildSettingsScreen(): GtkBox =
  result = gtk_box_new(GTK_ORIENTATION_VERTICAL, 12)

  let stack = gtk_stack_new()
  gtk_stack_set_transition_type(stack, GTK_STACK_TRANSITION_TYPE_CROSSFADE)

  let generalPage = gtk_label_new("General settings go here")
  let networkPage = gtk_label_new("Network settings go here")
  discard gtk_stack_add_titled(stack, generalPage, "general", "General")
  discard gtk_stack_add_titled(stack, networkPage, "network", "Network")

  let switcher = gtk_stack_switcher_new()
  gtk_stack_switcher_set_stack(switcher, stack)
  gtk_widget_set_halign(switcher, GTK_ALIGN_CENTER)

  gtk_box_append(result, switcher)
  gtk_box_append(result, stack)
  echo "Settings screen with a switcher and two tab-screens is ready"

let settingsScreen = buildSettingsScreen()
```

---

### Programmatic switching between "loading" and "result" in the same spot on screen

A `GtkStack` with no visible switcher — switching happens when a background operation finishes, not on a user click.

```nim
proc buildAsyncResultArea(): GtkStack =
  result = gtk_stack_new()
  gtk_stack_set_transition_type(result, GTK_STACK_TRANSITION_TYPE_CROSSFADE)

  let spinner = gtk_spinner_new()
  gtk_spinner_start(spinner)
  discard gtk_stack_add_named(result, spinner, "loading")

  let resultLabel = gtk_label_new("")
  discard gtk_stack_add_named(result, resultLabel, "result")

  gtk_stack_set_visible_child_name(result, "loading")
  echo "Result area is showing the loading spinner"

proc onDataLoaded(stack: GtkStack, text: string) =
  let resultChild = gtk_stack_get_child_by_name(stack, "result")
  gtk_label_set_text(cast[GtkLabel](resultChild), text.cstring)
  gtk_stack_set_visible_child_name(stack, "result")
  echo "Loading finished — the area switched to the result with a cross-fade animation"
```

---

## Summary table

| Procedure(s) | Category | What it does, briefly |
|---|---|---|
| `gtk_list_box_new` | ListBox | Create a list of rows |
| `gtk_list_box_append/prepend/insert/remove` | ListBox | Add/remove a row |
| `gtk_list_box_set/get_selection_mode` | ListBox | How many rows can be selected at once |
| `gtk_list_box_select_row`, `unselect_row`, `get_selected_row` | ListBox | Programmatic control of the selection |
| `gtk_list_box_row_new`, `row_set/get_child`, `row_get_index` | ListBox | Explicitly creating a row and its content |
| `gtk_notebook_new` | Notebook | Create the tab widget |
| `gtk_notebook_append/prepend/insert_page` | Notebook | Add a tab (content + label) |
| `gtk_notebook_remove_page` | Notebook | Remove a tab by index |
| `gtk_notebook_set/get_current_page` | Notebook | The currently active tab |
| `gtk_notebook_get_nth_page`, `get_n_pages` | Notebook | Content by index / total number of tabs |
| `gtk_notebook_set/get_tab_pos` | Notebook | Which side the labels are placed on |
| `gtk_notebook_set/get_show_tabs` | Notebook | Whether to show the row of labels at all |
| `gtk_notebook_set_scrollable` | Notebook | Allow scrolling the labels when there are too many |
| `gtk_paned_new` | Paned | Create an area with two panes and a divider |
| `gtk_paned_set/get_start_child`, `set/get_end_child` | Paned | The content of each of the two panes |
| `gtk_paned_set/get_position` | Paned | The position of the draggable divider |
| `gtk_stack_new` | Stack | Create a stack of switchable pages |
| `gtk_stack_add_child`, `add_named`, `add_titled` | Stack | Add a page — with no name / with a name / with a name and title |
| `gtk_stack_remove`, `get_child_by_name` | Stack | Remove a page / find one by name |
| `gtk_stack_set/get_visible_child`, `set/get_visible_child_name` | Stack | Switching the visible page (by object or by name) |
| `gtk_stack_set/get_transition_type`, `set/get_transition_duration` | Stack | The type and length of the transition animation |
| `gtk_stack_switcher_new`, `switcher_set/get_stack` | StackSwitcher | A ready-made row of switch buttons for the stack |

---

## Summary: which procedure to choose

- **A list of arbitrary rows with selection support** (contacts, files with icons, settings shown as rows) → `GtkListBox`, rather than `GtkBox` plus hand-written click-and-highlight logic — selection, selection modes, and row styling are already built in.
- **Classic tabs switched by the user** → `GtkNotebook`. **Switching screens with no visible row of tabs, or with a fully custom switcher, or purely programmatically with no user involvement at all** → `GtkStack` (with `GtkStackSwitcher` if you still want a ready-made row of buttons, but not necessarily shaped like classic tabs).
- **The user needs to adjust the ratio of two areas' sizes themselves** (list/details, tree/content) → `GtkPaned` with `gtk_paned_set_position` for a sensible initial value — don't try to achieve the same effect with a `GtkBox` and `hexpand` on one of the two widgets, since that gives no draggable border.
- **You need to both show several options and be able to switch to them by a stable text name** (without depending on an index or a direct reference to the widget object) → `gtk_stack_add_named`/`add_titled` + `gtk_stack_set_visible_child_name`, rather than `gtk_notebook_insert_page` with a numeric index that shifts when other tabs are added/removed.
- **The stack needs a title visible to the user in the switcher, separate from the technical name** (for example, to localize the interface without changing the internal logic that refers to `name`) → `gtk_stack_add_titled`, rather than `add_named` with a subsequent attempt to fetch the title from somewhere else — the technical name and the visible title are deliberately kept separate.
- **Switching the screen should be smooth, not abrupt** → `gtk_stack_set_transition_type` with any value other than `GTK_STACK_TRANSITION_TYPE_NONE` (the default is already `_CROSSFADE`, but the specific direction is better chosen to fit the context: sliding for "forward/back" navigation, cross-fade for switches with no particular direction, such as loading → result).
