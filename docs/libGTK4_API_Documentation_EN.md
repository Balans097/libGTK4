# libGTK4.nim API Documentation

## Overview

**Version:** 1.2  
**Date:** 2026-02-15  
**Author:** Balans097 — vasil.minsk@yahoo.com  
**Purpose:** Complete GTK4 wrapper for the Nim programming language

### Description

This library provides direct bindings to the GTK4 C API through FFI (Foreign Function Interface). It enables development of graphical applications in Nim using the full functionality of GTK4, including over 1780 additional functions covering Inspector API, Accessible API, Action API, Builder API, Constraint API, GSK, GDK, and more.

---

## Table of Contents

1. [Basic Types](#basic-types)
2. [Applications](#applications)
3. [Windows](#windows)
4. [Containers](#containers)
5. [Buttons and Toggles](#buttons-and-toggles)
6. [Text Widgets](#text-widgets)
7. [Lists and Selection](#lists-and-selection)
8. [Display Widgets](#display-widgets)
9. [Dialogs](#dialogs)
10. [Menus and Bars](#menus-and-bars)
11. [Drawing](#drawing)
12. [Events and Signals](#events-and-signals)
13. [CSS and Styling](#css-and-styling)
14. [Resources and Data](#resources-and-data)
15. [Layout Managers](#layout-managers)
16. [Models and Lists](#models-and-lists)
17. [Inspector API](#inspector-api)
18. [Accessibility API](#accessibility-api)
19. [Actions API](#actions-api)
20. [Builder API](#builder-api)
21. [Constraint API](#constraint-api)
22. [GSK (Graphics)](#gsk-graphics)
23. [GDK (Display)](#gdk-display)
24. [Bitset API](#bitset-api)
25. [Roaring Bitmap API](#roaring-bitmap-api)
26. [Utilities](#utilities)
27. [Complete Examples](#complete-examples)

---

## Basic Types

### GLib Types

```nim
type
  gboolean* = int32      # Boolean type (0 = FALSE, 1 = TRUE)
  gint* = int32          # 32-bit signed integer
  guint* = uint32        # 32-bit unsigned integer
  gchar* = char          # Character
  guchar* = uint8        # Unsigned character
  gshort* = int16        # Short integer
  gushort* = uint16      # Unsigned short integer
  glong* = int           # Long integer
  gulong* = uint         # Unsigned long integer
  gint8* = int8          # 8-bit signed integer
  guint8* = uint8        # 8-bit unsigned integer
  gint16* = int16        # 16-bit signed integer
  guint16* = uint16      # 16-bit unsigned integer
  gint32* = int32        # 32-bit signed integer
  guint32* = uint32      # 32-bit unsigned integer
  gint64* = int64        # 64-bit signed integer
  guint64* = uint64      # 64-bit unsigned integer
  gfloat* = float32      # Single precision float
  gdouble* = float64     # Double precision float
  gsize* = uint          # Size type
  gssize* = int          # Signed size type
  goffset* = int64       # Offset type
  gpointer* = pointer    # Generic pointer
  gconstpointer* = pointer  # Const pointer
  gunichar* = uint32     # Unicode character
```

### GTK Widget Types

```nim
type
  GtkWidget* = pointer              # Base widget type
  GtkWindow* = pointer              # Window
  GtkApplicationWindow* = pointer   # Application window
  GtkDialog* = pointer              # Dialog window
  GtkAboutDialog* = pointer         # About dialog
  GtkMessageDialog* = pointer       # Message dialog
  GtkFileChooserDialog* = pointer   # File chooser dialog
  GtkColorChooserDialog* = pointer  # Color picker dialog
  GtkFontChooserDialog* = pointer   # Font chooser dialog
```

### Container Types

```nim
type
  GtkBox* = pointer           # Linear container
  GtkGrid* = pointer          # Grid container
  GtkFixed* = pointer         # Fixed position container
  GtkPaned* = pointer         # Split pane container
  GtkStack* = pointer         # Stack container
  GtkStackSwitcher* = pointer # Stack switcher
  GtkNotebook* = pointer      # Tabbed notebook
  GtkExpander* = pointer      # Expandable container
  GtkFrame* = pointer         # Frame container
  GtkAspectFrame* = pointer   # Aspect ratio frame
  GtkOverlay* = pointer       # Overlay container
  GtkScrolledWindow* = pointer # Scrollable container
  GtkViewport* = pointer      # Viewport
```

---

## Applications

### GtkApplication

The main application type for GTK4 applications.

#### Creating an Application

```nim
proc gtk_application_new*(
  application_id: cstring,
  flags: GApplicationFlags
): GtkApplication
```

Creates a new GTK application.

**Parameters:**
- `application_id` — Unique application identifier (e.g., "com.example.MyApp")
- `flags` — Application flags

**Returns:** New GtkApplication instance

**Example:**
```nim
let app = gtk_application_new("com.example.myapp", G_APPLICATION_DEFAULT_FLAGS)
```

#### Running the Application

```nim
proc g_application_run*(
  application: GApplication,
  argc: gint,
  argv: cstringArray
): gint
```

Runs the application main loop.

**Parameters:**
- `application` — Application to run
- `argc` — Number of command line arguments
- `argv` — Array of command line arguments

**Returns:** Application exit code

**Example:**
```nim
let status = g_application_run(app, 0, nil)
```

#### Application Properties

```nim
proc g_application_set_application_id*(
  application: GApplication,
  application_id: cstring
)
```

Sets the application ID.

```nim
proc g_application_get_application_id*(
  application: GApplication
): cstring
```

Gets the application ID.

```nim
proc g_application_set_flags*(
  application: GApplication,
  flags: GApplicationFlags
)
```

Sets application flags.

```nim
proc g_application_get_flags*(
  application: GApplication
): GApplicationFlags
```

Gets application flags.

#### Application Lifecycle

```nim
proc g_application_quit*(
  application: GApplication
)
```

Quits the application.

```nim
proc g_application_hold*(
  application: GApplication
)
```

Increases the application hold count.

```nim
proc g_application_release*(
  application: GApplication
)
```

Decreases the application hold count.

**Example:**
```nim
proc onQuitActivate(action: GSimpleAction, parameter: pointer, app: GApplication) {.cdecl.} =
  g_application_quit(app)

# Later in code
g_application_hold(app)  # Keep app alive
# ... do work ...
g_application_release(app)  # Allow app to quit
```

---

## Windows

### GtkWindow

The main window widget.

#### Creating Windows

```nim
proc gtk_application_window_new*(
  application: GtkApplication
): GtkWidget
```

Creates a new application window.

**Example:**
```nim
let window = gtk_application_window_new(app)
```

```nim
proc gtk_window_new*(): GtkWidget
```

Creates a new standalone window (not tied to an application).

#### Window Properties

```nim
proc gtk_window_set_title*(
  window: GtkWindow,
  title: cstring
)
```

Sets the window title.

```nim
proc gtk_window_get_title*(
  window: GtkWindow
): cstring
```

Gets the window title.

```nim
proc gtk_window_set_default_size*(
  window: GtkWindow,
  width: gint,
  height: gint
)
```

Sets the default window size.

**Example:**
```nim
gtk_window_set_title(window, "My Application")
gtk_window_set_default_size(window, 800, 600)
```

```nim
proc gtk_window_get_default_size*(
  window: GtkWindow,
  width: ptr gint,
  height: ptr gint
)
```

Gets the default window size.

#### Window State

```nim
proc gtk_window_present*(
  window: GtkWindow
)
```

Shows the window and brings it to the front.

```nim
proc gtk_window_close*(
  window: GtkWindow
)
```

Closes the window.

```nim
proc gtk_window_destroy*(
  window: GtkWindow
)
```

Destroys the window.

```nim
proc gtk_window_is_active*(
  window: GtkWindow
): gboolean
```

Checks if the window is active.

```nim
proc gtk_window_maximize*(
  window: GtkWindow
)
```

Maximizes the window.

```nim
proc gtk_window_unmaximize*(
  window: GtkWindow
)
```

Unmaximizes the window.

```nim
proc gtk_window_minimize*(
  window: GtkWindow
)
```

Minimizes the window.

```nim
proc gtk_window_fullscreen*(
  window: GtkWindow
)
```

Sets the window to fullscreen.

```nim
proc gtk_window_unfullscreen*(
  window: GtkWindow
)
```

Exits fullscreen mode.

#### Window Content

```nim
proc gtk_window_set_child*(
  window: GtkWindow,
  child: GtkWidget
)
```

Sets the child widget of the window.

```nim
proc gtk_window_get_child*(
  window: GtkWindow
): GtkWidget
```

Gets the child widget of the window.

**Example:**
```nim
let box = gtk_box_new(GTK_ORIENTATION_VERTICAL, 0)
gtk_window_set_child(window, box)
```

#### Window Decorations

```nim
proc gtk_window_set_decorated*(
  window: GtkWindow,
  setting: gboolean
)
```

Sets whether the window should be decorated.

```nim
proc gtk_window_set_deletable*(
  window: GtkWindow,
  setting: gboolean
)
```

Sets whether the window can be deleted/closed.

```nim
proc gtk_window_set_resizable*(
  window: GtkWindow,
  resizable: gboolean
)
```

Sets whether the window can be resized.

```nim
proc gtk_window_set_modal*(
  window: GtkWindow,
  modal: gboolean
)
```

Sets whether the window is modal.

#### Window Hierarchy

```nim
proc gtk_window_set_transient_for*(
  window: GtkWindow,
  parent: GtkWindow
)
```

Sets a window as transient for another window.

```nim
proc gtk_window_get_transient_for*(
  window: GtkWindow
): GtkWindow
```

Gets the transient parent.

**Example:**
```nim
# Create a dialog that's transient for main window
let dialog = gtk_window_new()
gtk_window_set_transient_for(dialog, mainWindow)
gtk_window_set_modal(dialog, 1)
```

---

## Containers

### GtkBox

Linear container that arranges widgets in a single row or column.

#### Creating a Box

```nim
proc gtk_box_new*(
  orientation: GtkOrientation,
  spacing: gint
): GtkWidget
```

Creates a new box container.

**Parameters:**
- `orientation` — GTK_ORIENTATION_HORIZONTAL or GTK_ORIENTATION_VERTICAL
- `spacing` — Spacing between widgets in pixels

**Example:**
```nim
let vbox = gtk_box_new(GTK_ORIENTATION_VERTICAL, 10)
let hbox = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 5)
```

#### Adding Widgets

```nim
proc gtk_box_append*(
  box: GtkBox,
  child: GtkWidget
)
```

Appends a widget to the end of the box.

```nim
proc gtk_box_prepend*(
  box: GtkBox,
  child: GtkWidget
)
```

Prepends a widget to the start of the box.

```nim
proc gtk_box_insert_child_after*(
  box: GtkBox,
  child: GtkWidget,
  sibling: GtkWidget
)
```

Inserts a widget after another widget.

**Example:**
```nim
let box = gtk_box_new(GTK_ORIENTATION_VERTICAL, 5)
gtk_box_append(box, gtk_label_new("First"))
gtk_box_append(box, gtk_label_new("Second"))
gtk_box_append(box, gtk_label_new("Third"))
```

#### Removing Widgets

```nim
proc gtk_box_remove*(
  box: GtkBox,
  child: GtkWidget
)
```

Removes a widget from the box.

#### Box Properties

```nim
proc gtk_box_set_spacing*(
  box: GtkBox,
  spacing: gint
)
```

Sets the spacing between widgets.

```nim
proc gtk_box_get_spacing*(
  box: GtkBox
): gint
```

Gets the spacing.

```nim
proc gtk_box_set_homogeneous*(
  box: GtkBox,
  homogeneous: gboolean
)
```

Sets whether all children should have the same size.

**Example:**
```nim
let box = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 0)
gtk_box_set_spacing(box, 10)
gtk_box_set_homogeneous(box, 1)  # All children same size
```

### GtkGrid

Container for arranging widgets in a table.

#### Creating a Grid

```nim
proc gtk_grid_new*(): GtkWidget
```

Creates a new grid container.

**Example:**
```nim
let grid = gtk_grid_new()
```

#### Adding Widgets

```nim
proc gtk_grid_attach*(
  grid: GtkGrid,
  child: GtkWidget,
  column: gint,
  row: gint,
  width: gint,
  height: gint
)
```

Attaches a widget to the grid.

**Parameters:**
- `grid` — Grid container
- `child` — Widget to place
- `column` — Column number (starting at 0)
- `row` — Row number (starting at 0)
- `width` — Number of columns to span
- `height` — Number of rows to span

**Example:**
```nim
let grid = gtk_grid_new()
gtk_grid_attach(grid, gtk_label_new("Name:"), 0, 0, 1, 1)
gtk_grid_attach(grid, gtk_entry_new(), 1, 0, 1, 1)
gtk_grid_attach(grid, gtk_label_new("Email:"), 0, 1, 1, 1)
gtk_grid_attach(grid, gtk_entry_new(), 1, 1, 1, 1)
```

```nim
proc gtk_grid_attach_next_to*(
  grid: GtkGrid,
  child: GtkWidget,
  sibling: GtkWidget,
  side: GtkPositionType,
  width: gint,
  height: gint
)
```

Attaches a widget next to another widget.

#### Removing Widgets

```nim
proc gtk_grid_remove*(
  grid: GtkGrid,
  child: GtkWidget
)
```

Removes a widget from the grid.

#### Grid Properties

```nim
proc gtk_grid_set_row_spacing*(
  grid: GtkGrid,
  spacing: guint
)
```

Sets spacing between rows.

```nim
proc gtk_grid_set_column_spacing*(
  grid: GtkGrid,
  spacing: guint
)
```

Sets spacing between columns.

```nim
proc gtk_grid_set_row_homogeneous*(
  grid: GtkGrid,
  homogeneous: gboolean
)
```

Sets whether all rows should have the same height.

```nim
proc gtk_grid_set_column_homogeneous*(
  grid: GtkGrid,
  homogeneous: gboolean
)
```

Sets whether all columns should have the same width.

**Example:**
```nim
let grid = gtk_grid_new()
gtk_grid_set_row_spacing(grid, 10)
gtk_grid_set_column_spacing(grid, 10)
gtk_grid_set_row_homogeneous(grid, 0)
gtk_grid_set_column_homogeneous(grid, 1)
```

### GtkPaned

Container with a resizable divider between two widgets.

```nim
proc gtk_paned_new*(
  orientation: GtkOrientation
): GtkWidget
```

Creates a new paned container.

**Example:**
```nim
let paned = gtk_paned_new(GTK_ORIENTATION_HORIZONTAL)
```

```nim
proc gtk_paned_set_start_child*(
  paned: GtkPaned,
  child: GtkWidget
)
```

Sets the first child widget.

```nim
proc gtk_paned_set_end_child*(
  paned: GtkPaned,
  child: GtkWidget
)
```

Sets the second child widget.

```nim
proc gtk_paned_set_position*(
  paned: GtkPaned,
  position: gint
)
```

Sets the position of the divider.

```nim
proc gtk_paned_get_position*(
  paned: GtkPaned
): gint
```

Gets the position of the divider.

**Example:**
```nim
let paned = gtk_paned_new(GTK_ORIENTATION_HORIZONTAL)
let leftPanel = gtk_label_new("Left Panel")
let rightPanel = gtk_label_new("Right Panel")
gtk_paned_set_start_child(paned, leftPanel)
gtk_paned_set_end_child(paned, rightPanel)
gtk_paned_set_position(paned, 200)  # 200 pixels for left panel
```

### GtkNotebook

Tabbed container widget.

```nim
proc gtk_notebook_new*(): GtkWidget
```

Creates a new notebook.

```nim
proc gtk_notebook_append_page*(
  notebook: GtkNotebook,
  child: GtkWidget,
  tab_label: GtkWidget
): gint
```

Appends a page to the notebook.

**Returns:** Index of the new page

```nim
proc gtk_notebook_prepend_page*(
  notebook: GtkNotebook,
  child: GtkWidget,
  tab_label: GtkWidget
): gint
```

Prepends a page to the notebook.

```nim
proc gtk_notebook_insert_page*(
  notebook: GtkNotebook,
  child: GtkWidget,
  tab_label: GtkWidget,
  position: gint
): gint
```

Inserts a page at a specific position.

```nim
proc gtk_notebook_remove_page*(
  notebook: GtkNotebook,
  page_num: gint
)
```

Removes a page by index.

```nim
proc gtk_notebook_set_current_page*(
  notebook: GtkNotebook,
  page_num: gint
)
```

Sets the current page.

```nim
proc gtk_notebook_get_current_page*(
  notebook: GtkNotebook
): gint
```

Gets the current page index.

**Example:**
```nim
let notebook = gtk_notebook_new()

# Add first tab
let page1 = gtk_label_new("Content of page 1")
let tab1 = gtk_label_new("Tab 1")
discard gtk_notebook_append_page(notebook, page1, tab1)

# Add second tab
let page2 = gtk_label_new("Content of page 2")
let tab2 = gtk_label_new("Tab 2")
discard gtk_notebook_append_page(notebook, page2, tab2)

# Switch to second tab
gtk_notebook_set_current_page(notebook, 1)
```

### GtkStack and GtkStackSwitcher

Stack container for switching between different views.

```nim
proc gtk_stack_new*(): GtkWidget
```

Creates a new stack.

```nim
proc gtk_stack_add_child*(
  stack: GtkStack,
  child: GtkWidget
): GtkStackPage
```

Adds a child to the stack.

```nim
proc gtk_stack_add_titled*(
  stack: GtkStack,
  child: GtkWidget,
  name: cstring,
  title: cstring
): GtkStackPage
```

Adds a child with a name and title.

```nim
proc gtk_stack_set_visible_child*(
  stack: GtkStack,
  child: GtkWidget
)
```

Sets the visible child.

```nim
proc gtk_stack_set_visible_child_name*(
  stack: GtkStack,
  name: cstring
)
```

Sets the visible child by name.

```nim
proc gtk_stack_switcher_new*(): GtkWidget
```

Creates a switcher for a stack.

```nim
proc gtk_stack_switcher_set_stack*(
  switcher: GtkStackSwitcher,
  stack: GtkStack
)
```

Connects a switcher to a stack.

**Example:**
```nim
let stack = gtk_stack_new()
let switcher = gtk_stack_switcher_new()
gtk_stack_switcher_set_stack(switcher, stack)

# Add pages
discard gtk_stack_add_titled(stack, gtk_label_new("Home"), "home", "Home")
discard gtk_stack_add_titled(stack, gtk_label_new("Settings"), "settings", "Settings")
discard gtk_stack_add_titled(stack, gtk_label_new("About"), "about", "About")

# Create layout
let box = gtk_box_new(GTK_ORIENTATION_VERTICAL, 0)
gtk_box_append(box, switcher)
gtk_box_append(box, stack)
```

### GtkScrolledWindow

Container that adds scrollbars to its child.

```nim
proc gtk_scrolled_window_new*(): GtkWidget
```

Creates a new scrolled window.

```nim
proc gtk_scrolled_window_set_child*(
  scrolled_window: GtkScrolledWindow,
  child: GtkWidget
)
```

Sets the child widget.

```nim
proc gtk_scrolled_window_set_policy*(
  scrolled_window: GtkScrolledWindow,
  hscrollbar_policy: GtkPolicyType,
  vscrollbar_policy: GtkPolicyType
)
```

Sets the scrollbar policies.

**Example:**
```nim
let scrolled = gtk_scrolled_window_new()
let textview = gtk_text_view_new()
gtk_scrolled_window_set_child(scrolled, textview)
gtk_scrolled_window_set_policy(scrolled, GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC)
```

---

## Buttons and Toggles

### GtkButton

Standard push button.

#### Creating Buttons

```nim
proc gtk_button_new*(): GtkWidget
```

Creates an empty button.

```nim
proc gtk_button_new_with_label*(
  label: cstring
): GtkWidget
```

Creates a button with a text label.

```nim
proc gtk_button_new_with_mnemonic*(
  label: cstring
): GtkWidget
```

Creates a button with a mnemonic (keyboard shortcut).

**Example:**
```nim
let btn1 = gtk_button_new_with_label("Click Me")
let btn2 = gtk_button_new_with_mnemonic("_Save")  # Alt+S
```

```nim
proc gtk_button_new_from_icon_name*(
  icon_name: cstring
): GtkWidget
```

Creates a button with an icon.

**Example:**
```nim
let btnSave = gtk_button_new_from_icon_name("document-save")
let btnOpen = gtk_button_new_from_icon_name("document-open")
```

#### Button Properties

```nim
proc gtk_button_set_label*(
  button: GtkButton,
  label: cstring
)
```

Sets the button text.

```nim
proc gtk_button_get_label*(
  button: GtkButton
): cstring
```

Gets the button text.

```nim
proc gtk_button_set_child*(
  button: GtkButton,
  child: GtkWidget
)
```

Sets custom content for the button.

```nim
proc gtk_button_get_child*(
  button: GtkButton
): GtkWidget
```

Gets the button's child widget.

```nim
proc gtk_button_set_has_frame*(
  button: GtkButton,
  has_frame: gboolean
)
```

Sets whether the button has a visible frame.

```nim
proc gtk_button_set_icon_name*(
  button: GtkButton,
  icon_name: cstring
)
```

Sets the icon for the button.

**Example - Custom Button Content:**
```nim
let button = gtk_button_new()
let box = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 5)
gtk_box_append(box, gtk_image_new_from_icon_name("folder-open"))
gtk_box_append(box, gtk_label_new("Open File"))
gtk_button_set_child(button, box)
```

#### Button Signals

```nim
# Connect to "clicked" signal
proc onButtonClicked(button: GtkButton, data: gpointer) {.cdecl.} =
  echo "Button clicked!"

discard g_signal_connect_data(button, "clicked", 
                              cast[GCallback](onButtonClicked), 
                              nil, nil, 0)
```

### GtkToggleButton

Button that maintains a pressed/unpressed state.

```nim
proc gtk_toggle_button_new*(): GtkWidget
```

Creates a new toggle button.

```nim
proc gtk_toggle_button_new_with_label*(
  label: cstring
): GtkWidget
```

Creates a toggle button with a label.

```nim
proc gtk_toggle_button_set_active*(
  toggle_button: GtkToggleButton,
  is_active: gboolean
)
```

Sets the toggle state.

```nim
proc gtk_toggle_button_get_active*(
  toggle_button: GtkToggleButton
): gboolean
```

Gets the toggle state.

**Example:**
```nim
let toggle = gtk_toggle_button_new_with_label("Bold")

proc onToggled(btn: GtkToggleButton, data: gpointer) {.cdecl.} =
  if gtk_toggle_button_get_active(btn) == 1:
    echo "Toggle is ON"
  else:
    echo "Toggle is OFF"

discard g_signal_connect_data(toggle, "toggled", 
                              cast[GCallback](onToggled), 
                              nil, nil, 0)
```

### GtkCheckButton

Checkbox widget.

```nim
proc gtk_check_button_new*(): GtkWidget
```

Creates a new checkbox.

```nim
proc gtk_check_button_new_with_label*(
  label: cstring
): GtkWidget
```

Creates a checkbox with a label.

```nim
proc gtk_check_button_new_with_mnemonic*(
  label: cstring
): GtkWidget
```

Creates a checkbox with a mnemonic.

```nim
proc gtk_check_button_set_active*(
  check_button: GtkCheckButton,
  setting: gboolean
)
```

Sets the checkbox state.

```nim
proc gtk_check_button_get_active*(
  check_button: GtkCheckButton
): gboolean
```

Gets the checkbox state.

**Example:**
```nim
let check1 = gtk_check_button_new_with_label("Remember me")
let check2 = gtk_check_button_new_with_label("Send notifications")

gtk_check_button_set_active(check1, 1)  # Checked by default
```

### GtkSwitch

On/off switch widget.

```nim
proc gtk_switch_new*(): GtkWidget
```

Creates a new switch.

```nim
proc gtk_switch_set_active*(
  sw: GtkSwitch,
  is_active: gboolean
)
```

Sets the switch state.

```nim
proc gtk_switch_get_active*(
  sw: GtkSwitch
): gboolean
```

Gets the switch state.

```nim
proc gtk_switch_set_state*(
  sw: GtkSwitch,
  state: gboolean
)
```

Sets the underlying state.

```nim
proc gtk_switch_get_state*(
  sw: GtkSwitch
): gboolean
```

Gets the underlying state.

**Example:**
```nim
let switchWidget = gtk_switch_new()

proc onSwitchActivate(sw: GtkSwitch, state: gboolean, data: gpointer): gboolean {.cdecl.} =
  if state == 1:
    echo "Switch turned ON"
  else:
    echo "Switch turned OFF"
  return 0  # Allow state change

discard g_signal_connect_data(switchWidget, "state-set", 
                              cast[GCallback](onSwitchActivate), 
                              nil, nil, 0)
```

### GtkLinkButton

Button that opens a URL.

```nim
proc gtk_link_button_new*(
  uri: cstring
): GtkWidget
```

Creates a link button.

```nim
proc gtk_link_button_new_with_label*(
  uri: cstring,
  label: cstring
): GtkWidget
```

Creates a link button with custom label.

```nim
proc gtk_link_button_set_uri*(
  link_button: GtkLinkButton,
  uri: cstring
)
```

Sets the URI.

```nim
proc gtk_link_button_get_uri*(
  link_button: GtkLinkButton
): cstring
```

Gets the URI.

**Example:**
```nim
let link = gtk_link_button_new_with_label("https://gtk.org", "GTK Website")
```

### GtkMenuButton

Button that pops up a menu.

```nim
proc gtk_menu_button_new*(): GtkWidget
```

Creates a menu button.

```nim
proc gtk_menu_button_set_popover*(
  menu_button: GtkMenuButton,
  popover: GtkWidget
)
```

Sets the popover menu.

```nim
proc gtk_menu_button_set_menu_model*(
  menu_button: GtkMenuButton,
  menu_model: GMenuModel
)
```

Sets the menu model.

```nim
proc gtk_menu_button_set_icon_name*(
  menu_button: GtkMenuButton,
  icon_name: cstring
)
```

Sets the icon.

```nim
proc gtk_menu_button_set_direction*(
  menu_button: GtkMenuButton,
  direction: GtkArrowType
)
```

Sets the popup direction.

**Example:**
```nim
let menuBtn = gtk_menu_button_new()
gtk_menu_button_set_icon_name(menuBtn, "open-menu-symbolic")

let popover = gtk_popover_new()
let box = gtk_box_new(GTK_ORIENTATION_VERTICAL, 0)
gtk_box_append(box, gtk_button_new_with_label("Option 1"))
gtk_box_append(box, gtk_button_new_with_label("Option 2"))
gtk_popover_set_child(popover, box)
gtk_menu_button_set_popover(menuBtn, popover)
```

---

## Text Widgets

### GtkLabel

Widget for displaying text.

#### Creating Labels

```nim
proc gtk_label_new*(
  str: cstring
): GtkWidget
```

Creates a label with text.

```nim
proc gtk_label_new_with_mnemonic*(
  str: cstring
): GtkWidget
```

Creates a label with a mnemonic.

**Example:**
```nim
let label1 = gtk_label_new("Hello, World!")
let label2 = gtk_label_new_with_mnemonic("_Name:")
```

#### Setting Text

```nim
proc gtk_label_set_text*(
  label: GtkLabel,
  str: cstring
)
```

Sets plain text.

```nim
proc gtk_label_get_text*(
  label: GtkLabel
): cstring
```

Gets the text.

```nim
proc gtk_label_set_markup*(
  label: GtkLabel,
  str: cstring
)
```

Sets text with Pango markup.

**Example:**
```nim
let label = gtk_label_new("")
gtk_label_set_markup(label, "<b>Bold</b> and <i>italic</i> text")
```

#### Label Properties

```nim
proc gtk_label_set_selectable*(
  label: GtkLabel,
  setting: gboolean
)
```

Makes the label selectable.

```nim
proc gtk_label_set_wrap*(
  label: GtkLabel,
  wrap: gboolean
)
```

Enables text wrapping.

```nim
proc gtk_label_set_wrap_mode*(
  label: GtkLabel,
  wrap_mode: PangoWrapMode
)
```

Sets the wrap mode.

```nim
proc gtk_label_set_justify*(
  label: GtkLabel,
  jtype: GtkJustification
)
```

Sets text justification.

```nim
proc gtk_label_set_ellipsize*(
  label: GtkLabel,
  mode: PangoEllipsizeMode
)
```

Sets ellipsize mode.

```nim
proc gtk_label_set_xalign*(
  label: GtkLabel,
  xalign: gfloat
)
```

Sets horizontal alignment (0.0 = left, 1.0 = right).

```nim
proc gtk_label_set_yalign*(
  label: GtkLabel,
  yalign: gfloat
)
```

Sets vertical alignment (0.0 = top, 1.0 = bottom).

**Example:**
```nim
let label = gtk_label_new("Long text that will wrap to multiple lines when the window is narrow")
gtk_label_set_wrap(label, 1)
gtk_label_set_justify(label, GTK_JUSTIFY_CENTER)
gtk_label_set_xalign(label, 0.5)
```

### GtkEntry

Single-line text input field.

#### Creating Entries

```nim
proc gtk_entry_new*(): GtkWidget
```

Creates a new entry.

```nim
proc gtk_entry_new_with_buffer*(
  buffer: GtkEntryBuffer
): GtkWidget
```

Creates an entry with a specific buffer.

#### Entry Text

```nim
proc gtk_entry_set_text*(
  entry: GtkEntry,
  text: cstring
)
```

Sets the text.

```nim
proc gtk_entry_get_text*(
  entry: GtkEntry
): cstring
```

Gets the text.

```nim
proc gtk_entry_buffer_set_text*(
  buffer: GtkEntryBuffer,
  chars: cstring,
  n_chars: gint
)
```

Sets text in the buffer.

```nim
proc gtk_entry_buffer_get_text*(
  buffer: GtkEntryBuffer
): cstring
```

Gets text from the buffer.

#### Entry Properties

```nim
proc gtk_entry_set_placeholder_text*(
  entry: GtkEntry,
  text: cstring
)
```

Sets placeholder text (shown when empty).

```nim
proc gtk_entry_set_max_length*(
  entry: GtkEntry,
  max: gint
)
```

Sets maximum text length.

```nim
proc gtk_entry_set_visibility*(
  entry: GtkEntry,
  visible: gboolean
)
```

Sets whether text is visible (for passwords).

```nim
proc gtk_entry_set_invisible_char*(
  entry: GtkEntry,
  ch: gunichar
)
```

Sets the invisible character for passwords.

```nim
proc gtk_entry_set_has_frame*(
  entry: GtkEntry,
  setting: gboolean
)
```

Sets whether entry has a frame.

```nim
proc gtk_entry_set_alignment*(
  entry: GtkEntry,
  xalign: gfloat
)
```

Sets text alignment in the entry.

**Example:**
```nim
let entry = gtk_entry_new()
gtk_entry_set_placeholder_text(entry, "Enter your name...")
gtk_entry_set_max_length(entry, 50)

proc onActivate(entry: GtkEntry, data: gpointer) {.cdecl.} =
  let text = gtk_entry_get_text(entry)
  echo "You entered: ", text

discard g_signal_connect_data(entry, "activate", 
                              cast[GCallback](onActivate), 
                              nil, nil, 0)
```

### GtkPasswordEntry

Password entry widget.

```nim
proc gtk_password_entry_new*(): GtkWidget
```

Creates a password entry.

```nim
proc gtk_password_entry_set_show_peek_icon*(
  entry: GtkPasswordEntry,
  show_peek_icon: gboolean
)
```

Shows/hides the peek icon.

**Example:**
```nim
let passwordEntry = gtk_password_entry_new()
gtk_password_entry_set_show_peek_icon(passwordEntry, 1)
```

### GtkSearchEntry

Search entry widget with clear button.

```nim
proc gtk_search_entry_new*(): GtkWidget
```

Creates a search entry.

```nim
proc gtk_search_entry_set_placeholder_text*(
  entry: GtkSearchEntry,
  text: cstring
)
```

Sets placeholder text.

**Example:**
```nim
let searchEntry = gtk_search_entry_new()
gtk_search_entry_set_placeholder_text(searchEntry, "Search...")

proc onSearchChanged(entry: GtkSearchEntry, data: gpointer) {.cdecl.} =
  let text = gtk_editable_get_text(entry)
  echo "Search: ", text

discard g_signal_connect_data(searchEntry, "search-changed", 
                              cast[GCallback](onSearchChanged), 
                              nil, nil, 0)
```

### GtkTextView

Multi-line text editor.

#### Creating TextView

```nim
proc gtk_text_view_new*(): GtkWidget
```

Creates a new text view.

```nim
proc gtk_text_view_new_with_buffer*(
  buffer: GtkTextBuffer
): GtkWidget
```

Creates a text view with a specific buffer.

#### Getting/Setting Buffer

```nim
proc gtk_text_view_get_buffer*(
  text_view: GtkTextView
): GtkTextBuffer
```

Gets the text buffer.

```nim
proc gtk_text_view_set_buffer*(
  text_view: GtkTextView,
  buffer: GtkTextBuffer
)
```

Sets the text buffer.

#### TextView Properties

```nim
proc gtk_text_view_set_editable*(
  text_view: GtkTextView,
  setting: gboolean
)
```

Sets whether text is editable.

```nim
proc gtk_text_view_set_wrap_mode*(
  text_view: GtkTextView,
  wrap_mode: GtkWrapMode
)
```

Sets line wrapping mode.

```nim
proc gtk_text_view_set_cursor_visible*(
  text_view: GtkTextView,
  setting: gboolean
)
```

Shows/hides the cursor.

```nim
proc gtk_text_view_set_monospace*(
  text_view: GtkTextView,
  monospace: gboolean
)
```

Uses monospace font.

```nim
proc gtk_text_view_set_left_margin*(
  text_view: GtkTextView,
  left_margin: gint
)
```

Sets left margin.

```nim
proc gtk_text_view_set_right_margin*(
  text_view: GtkTextView,
  right_margin: gint
)
```

Sets right margin.

**Example:**
```nim
let textview = gtk_text_view_new()
gtk_text_view_set_wrap_mode(textview, GTK_WRAP_WORD)
gtk_text_view_set_left_margin(textview, 10)
gtk_text_view_set_right_margin(textview, 10)
gtk_text_view_set_monospace(textview, 1)
```

### GtkTextBuffer

Buffer for storing text content.

#### Creating Buffer

```nim
proc gtk_text_buffer_new*(
  table: GtkTextTagTable
): GtkTextBuffer
```

Creates a new text buffer.

#### Setting/Getting Text

```nim
proc gtk_text_buffer_set_text*(
  buffer: GtkTextBuffer,
  text: cstring,
  len: gint
)
```

Sets the entire buffer text.

**Parameters:**
- `len` — Length of text in bytes (-1 for null-terminated)

```nim
proc gtk_text_buffer_get_text*(
  buffer: GtkTextBuffer,
  start: ptr GtkTextIter,
  end_iter: ptr GtkTextIter,
  include_hidden_chars: gboolean
): cstring
```

Gets text from a range.

**Example:**
```nim
let buffer = gtk_text_view_get_buffer(textview)
gtk_text_buffer_set_text(buffer, "Hello, World!", -1)

# Get all text
var start, end_iter: GtkTextIter
gtk_text_buffer_get_start_iter(buffer, addr start)
gtk_text_buffer_get_end_iter(buffer, addr end_iter)
let text = gtk_text_buffer_get_text(buffer, addr start, addr end_iter, 0)
echo text
```

#### Inserting Text

```nim
proc gtk_text_buffer_insert*(
  buffer: GtkTextBuffer,
  iter: ptr GtkTextIter,
  text: cstring,
  len: gint
)
```

Inserts text at iterator position.

```nim
proc gtk_text_buffer_insert_at_cursor*(
  buffer: GtkTextBuffer,
  text: cstring,
  len: gint
)
```

Inserts text at cursor position.

#### Deleting Text

```nim
proc gtk_text_buffer_delete*(
  buffer: GtkTextBuffer,
  start: ptr GtkTextIter,
  end_iter: ptr GtkTextIter
)
```

Deletes text in a range.

#### Iterators

```nim
proc gtk_text_buffer_get_start_iter*(
  buffer: GtkTextBuffer,
  iter: ptr GtkTextIter
)
```

Gets iterator at start of buffer.

```nim
proc gtk_text_buffer_get_end_iter*(
  buffer: GtkTextBuffer,
  iter: ptr GtkTextIter
)
```

Gets iterator at end of buffer.

```nim
proc gtk_text_buffer_get_iter_at_offset*(
  buffer: GtkTextBuffer,
  iter: ptr GtkTextIter,
  char_offset: gint
)
```

Gets iterator at character offset.

```nim
proc gtk_text_buffer_get_iter_at_line*(
  buffer: GtkTextBuffer,
  iter: ptr GtkTextIter,
  line_number: gint
)
```

Gets iterator at line number.

**Example - Insert and Delete:**
```nim
let buffer = gtk_text_view_get_buffer(textview)

# Insert text at cursor
gtk_text_buffer_insert_at_cursor(buffer, "New text", -1)

# Delete all text
var start, end_iter: GtkTextIter
gtk_text_buffer_get_start_iter(buffer, addr start)
gtk_text_buffer_get_end_iter(buffer, addr end_iter)
gtk_text_buffer_delete(buffer, addr start, addr end_iter)
```

---

## Lists and Selection

### GtkComboBox and GtkComboBoxText

Dropdown selection widgets.

#### GtkComboBoxText

```nim
proc gtk_combo_box_text_new*(): GtkWidget
```

Creates a simple text combo box.

```nim
proc gtk_combo_box_text_new_with_entry*(): GtkWidget
```

Creates a combo box with entry field.

```nim
proc gtk_combo_box_text_append*(
  combo_box: GtkComboBoxText,
  id: cstring,
  text: cstring
)
```

Appends an item.

```nim
proc gtk_combo_box_text_append_text*(
  combo_box: GtkComboBoxText,
  text: cstring
)
```

Appends text without ID.

```nim
proc gtk_combo_box_text_prepend*(
  combo_box: GtkComboBoxText,
  id: cstring,
  text: cstring
)
```

Prepends an item.

```nim
proc gtk_combo_box_text_insert*(
  combo_box: GtkComboBoxText,
  position: gint,
  id: cstring,
  text: cstring
)
```

Inserts an item at position.

```nim
proc gtk_combo_box_text_remove*(
  combo_box: GtkComboBoxText,
  position: gint
)
```

Removes an item.

```nim
proc gtk_combo_box_text_remove_all*(
  combo_box: GtkComboBoxText
)
```

Removes all items.

```nim
proc gtk_combo_box_text_get_active_text*(
  combo_box: GtkComboBoxText
): cstring
```

Gets the active item text.

**Example:**
```nim
let combo = gtk_combo_box_text_new()
gtk_combo_box_text_append_text(combo, "Option 1")
gtk_combo_box_text_append_text(combo, "Option 2")
gtk_combo_box_text_append_text(combo, "Option 3")

proc onChanged(combo: GtkComboBoxText, data: gpointer) {.cdecl.} =
  let text = gtk_combo_box_text_get_active_text(combo)
  if text != nil:
    echo "Selected: ", text

discard g_signal_connect_data(combo, "changed", 
                              cast[GCallback](onChanged), 
                              nil, nil, 0)
```

#### GtkComboBox (Generic)

```nim
proc gtk_combo_box_new*(): GtkWidget
```

Creates a combo box.

```nim
proc gtk_combo_box_set_model*(
  combo_box: GtkComboBox,
  model: GtkTreeModel
)
```

Sets the data model.

```nim
proc gtk_combo_box_set_active*(
  combo_box: GtkComboBox,
  index_: gint
)
```

Sets active item by index.

```nim
proc gtk_combo_box_get_active*(
  combo_box: GtkComboBox
): gint
```

Gets active item index.

### GtkListBox

Vertical list of widgets.

```nim
proc gtk_list_box_new*(): GtkWidget
```

Creates a new list box.

```nim
proc gtk_list_box_append*(
  box: GtkListBox,
  child: GtkWidget
)
```

Appends a widget.

```nim
proc gtk_list_box_prepend*(
  box: GtkListBox,
  child: GtkWidget
)
```

Prepends a widget.

```nim
proc gtk_list_box_insert*(
  box: GtkListBox,
  child: GtkWidget,
  position: gint
)
```

Inserts a widget at position.

```nim
proc gtk_list_box_remove*(
  box: GtkListBox,
  child: GtkWidget
)
```

Removes a widget.

```nim
proc gtk_list_box_select_row*(
  box: GtkListBox,
  row: GtkListBoxRow
)
```

Selects a row.

```nim
proc gtk_list_box_get_selected_row*(
  box: GtkListBox
): GtkListBoxRow
```

Gets the selected row.

```nim
proc gtk_list_box_set_selection_mode*(
  box: GtkListBox,
  mode: GtkSelectionMode
)
```

Sets selection mode.

**Example:**
```nim
let listbox = gtk_list_box_new()

# Add items
for i in 1..5:
  let label = gtk_label_new("Item " & $i)
  gtk_list_box_append(listbox, label)

proc onRowActivated(box: GtkListBox, row: GtkListBoxRow, data: gpointer) {.cdecl.} =
  let index = gtk_list_box_row_get_index(row)
  echo "Activated row: ", index

discard g_signal_connect_data(listbox, "row-activated", 
                              cast[GCallback](onRowActivated), 
                              nil, nil, 0)
```

### GtkDropDown

Modern dropdown selection widget (GTK4).

```nim
proc gtk_drop_down_new*(
  model: GListModel,
  expression: GtkExpression
): GtkWidget
```

Creates a dropdown from a model.

```nim
proc gtk_drop_down_new_from_strings*(
  strings: cstringArray
): GtkWidget
```

Creates a dropdown from string array.

```nim
proc gtk_drop_down_set_selected*(
  self: GtkDropDown,
  position: guint
)
```

Sets selected item.

```nim
proc gtk_drop_down_get_selected*(
  self: GtkDropDown
): guint
```

Gets selected item index.

```nim
proc gtk_drop_down_set_enable_search*(
  self: GtkDropDown,
  enable_search: gboolean
)
```

Enables search functionality.

**Example:**
```nim
let items = allocCStringArray(["Apple", "Banana", "Cherry", "Date"])
let dropdown = gtk_drop_down_new_from_strings(items)
gtk_drop_down_set_enable_search(dropdown, 1)
gtk_drop_down_set_selected(dropdown, 0)

proc onSelectionChanged(dropdown: GtkDropDown, pspec: pointer, data: gpointer) {.cdecl.} =
  let index = gtk_drop_down_get_selected(dropdown)
  echo "Selected index: ", index

discard g_signal_connect_data(dropdown, "notify::selected", 
                              cast[GCallback](onSelectionChanged), 
                              nil, nil, 0)
```

### GtkFlowBox

Grid-like container that reflows.

```nim
proc gtk_flow_box_new*(): GtkWidget
```

Creates a flow box.

```nim
proc gtk_flow_box_append*(
  box: GtkFlowBox,
  child: GtkWidget
)
```

Appends a child.

```nim
proc gtk_flow_box_insert*(
  box: GtkFlowBox,
  widget: GtkWidget,
  position: gint
)
```

Inserts a child at position.

```nim
proc gtk_flow_box_remove*(
  box: GtkFlowBox,
  widget: GtkWidget
)
```

Removes a child.

```nim
proc gtk_flow_box_set_max_children_per_line*(
  box: GtkFlowBox,
  n_children: guint
)
```

Sets maximum children per line.

```nim
proc gtk_flow_box_set_min_children_per_line*(
  box: GtkFlowBox,
  n_children: guint
)
```

Sets minimum children per line.

```nim
proc gtk_flow_box_set_row_spacing*(
  box: GtkFlowBox,
  spacing: guint
)
```

Sets row spacing.

```nim
proc gtk_flow_box_set_column_spacing*(
  box: GtkFlowBox,
  spacing: guint
)
```

Sets column spacing.

**Example:**
```nim
let flowbox = gtk_flow_box_new()
gtk_flow_box_set_max_children_per_line(flowbox, 4)
gtk_flow_box_set_row_spacing(flowbox, 10)
gtk_flow_box_set_column_spacing(flowbox, 10)

for i in 1..12:
  let button = gtk_button_new_with_label("Item " & $i)
  gtk_flow_box_append(flowbox, button)
```

---

## Display Widgets

### GtkImage

Widget for displaying images.

```nim
proc gtk_image_new*(): GtkWidget
```

Creates an empty image.

```nim
proc gtk_image_new_from_file*(
  filename: cstring
): GtkWidget
```

Creates image from file.

```nim
proc gtk_image_new_from_resource*(
  resource_path: cstring
): GtkWidget
```

Creates image from resource.

```nim
proc gtk_image_new_from_icon_name*(
  icon_name: cstring
): GtkWidget
```

Creates image from icon name.

```nim
proc gtk_image_new_from_pixbuf*(
  pixbuf: GdkPixbuf
): GtkWidget
```

Creates image from pixbuf.

```nim
proc gtk_image_set_from_file*(
  image: GtkImage,
  filename: cstring
)
```

Loads image from file.

```nim
proc gtk_image_set_from_icon_name*(
  image: GtkImage,
  icon_name: cstring
)
```

Sets icon from name.

```nim
proc gtk_image_set_pixel_size*(
  image: GtkImage,
  pixel_size: gint
)
```

Sets icon size in pixels.

```nim
proc gtk_image_clear*(
  image: GtkImage
)
```

Clears the image.

**Example:**
```nim
let image = gtk_image_new_from_icon_name("folder-open")
gtk_image_set_pixel_size(image, 64)

# Later, change the image
gtk_image_set_from_file(image, "/path/to/image.png")
```

### GtkPicture

Modern image display widget.

```nim
proc gtk_picture_new*(): GtkWidget
```

Creates a new picture widget.

```nim
proc gtk_picture_new_for_file*(
  file: GFile
): GtkWidget
```

Creates picture from GFile.

```nim
proc gtk_picture_new_for_filename*(
  filename: cstring
): GtkWidget
```

Creates picture from filename.

```nim
proc gtk_picture_set_filename*(
  self: GtkPicture,
  filename: cstring
)
```

Sets image from filename.

```nim
proc gtk_picture_set_can_shrink*(
  self: GtkPicture,
  can_shrink: gboolean
)
```

Sets whether image can shrink.

```nim
proc gtk_picture_set_keep_aspect_ratio*(
  self: GtkPicture,
  keep_aspect_ratio: gboolean
)
```

Sets whether to keep aspect ratio.

**Example:**
```nim
let picture = gtk_picture_new_for_filename("/path/to/image.jpg")
gtk_picture_set_keep_aspect_ratio(picture, 1)
gtk_picture_set_can_shrink(picture, 1)
```

### GtkSpinner

Animated loading indicator.

```nim
proc gtk_spinner_new*(): GtkWidget
```

Creates a spinner.

```nim
proc gtk_spinner_start*(
  spinner: GtkSpinner
)
```

Starts animation.

```nim
proc gtk_spinner_stop*(
  spinner: GtkSpinner
)
```

Stops animation.

```nim
proc gtk_spinner_set_spinning*(
  spinner: GtkSpinner,
  spinning: gboolean
)
```

Sets spinning state.

```nim
proc gtk_spinner_get_spinning*(
  spinner: GtkSpinner
): gboolean
```

Gets spinning state.

**Example:**
```nim
let spinner = gtk_spinner_new()
gtk_spinner_start(spinner)

# Later, stop it
# gtk_spinner_stop(spinner)
```

### GtkProgressBar

Progress indicator.

```nim
proc gtk_progress_bar_new*(): GtkWidget
```

Creates a progress bar.

```nim
proc gtk_progress_bar_set_fraction*(
  pbar: GtkProgressBar,
  fraction: gdouble
)
```

Sets progress (0.0 to 1.0).

```nim
proc gtk_progress_bar_get_fraction*(
  pbar: GtkProgressBar
): gdouble
```

Gets current progress.

```nim
proc gtk_progress_bar_set_text*(
  pbar: GtkProgressBar,
  text: cstring
)
```

Sets text overlay.

```nim
proc gtk_progress_bar_set_show_text*(
  pbar: GtkProgressBar,
  show_text: gboolean
)
```

Shows/hides text.

```nim
proc gtk_progress_bar_pulse*(
  pbar: GtkProgressBar
)
```

Pulses (for indeterminate progress).

```nim
proc gtk_progress_bar_set_inverted*(
  pbar: GtkProgressBar,
  inverted: gboolean
)
```

Inverts progress direction.

**Example:**
```nim
let progressBar = gtk_progress_bar_new()
gtk_progress_bar_set_show_text(progressBar, 1)

# Update progress
for i in 0..100:
  let fraction = i.float / 100.0
  gtk_progress_bar_set_fraction(progressBar, fraction)
  gtk_progress_bar_set_text(progressBar, $i & "%")
```

### GtkLevelBar

Level indicator widget.

```nim
proc gtk_level_bar_new*(): GtkWidget
```

Creates a level bar.

```nim
proc gtk_level_bar_new_for_interval*(
  min_value: gdouble,
  max_value: gdouble
): GtkWidget
```

Creates level bar with range.

```nim
proc gtk_level_bar_set_value*(
  self: GtkLevelBar,
  value: gdouble
)
```

Sets current value.

```nim
proc gtk_level_bar_get_value*(
  self: GtkLevelBar
): gdouble
```

Gets current value.

```nim
proc gtk_level_bar_set_min_value*(
  self: GtkLevelBar,
  value: gdouble
)
```

Sets minimum value.

```nim
proc gtk_level_bar_set_max_value*(
  self: GtkLevelBar,
  value: gdouble
)
```

Sets maximum value.

**Example:**
```nim
let levelBar = gtk_level_bar_new_for_interval(0.0, 100.0)
gtk_level_bar_set_value(levelBar, 75.0)
```

### GtkSeparator

Visual separator line.

```nim
proc gtk_separator_new*(
  orientation: GtkOrientation
): GtkWidget
```

Creates a separator.

**Example:**
```nim
let vbox = gtk_box_new(GTK_ORIENTATION_VERTICAL, 0)
gtk_box_append(vbox, gtk_label_new("Section 1"))
gtk_box_append(vbox, gtk_separator_new(GTK_ORIENTATION_HORIZONTAL))
gtk_box_append(vbox, gtk_label_new("Section 2"))
```

---

## Dialogs

### GtkDialog

Base dialog widget.

```nim
proc gtk_dialog_new*(): GtkWidget
```

Creates a new dialog.

```nim
proc gtk_dialog_new_with_buttons*(
  title: cstring,
  parent: GtkWindow,
  flags: GtkDialogFlags,
  first_button_text: cstring
): GtkWidget
```

Creates dialog with buttons.

```nim
proc gtk_dialog_add_button*(
  dialog: GtkDialog,
  button_text: cstring,
  response_id: gint
): GtkWidget
```

Adds a button to the dialog.

```nim
proc gtk_dialog_get_content_area*(
  dialog: GtkDialog
): GtkWidget
```

Gets the content area.

```nim
proc gtk_dialog_set_default_response*(
  dialog: GtkDialog,
  response_id: gint
)
```

Sets default response.

**Example:**
```nim
let dialog = gtk_dialog_new_with_buttons(
  "Confirm Action",
  mainWindow,
  GTK_DIALOG_MODAL,
  nil
)

discard gtk_dialog_add_button(dialog, "Cancel", GTK_RESPONSE_CANCEL)
discard gtk_dialog_add_button(dialog, "OK", GTK_RESPONSE_OK)

let contentArea = gtk_dialog_get_content_area(dialog)
gtk_box_append(contentArea, gtk_label_new("Are you sure?"))

gtk_window_present(dialog)
```

### GtkMessageDialog

Simple message dialog.

```nim
proc gtk_message_dialog_new*(
  parent: GtkWindow,
  flags: GtkDialogFlags,
  type_: GtkMessageType,
  buttons: GtkButtonsType,
  message_format: cstring
): GtkWidget
```

Creates a message dialog.

**Message Types:**
- GTK_MESSAGE_INFO
- GTK_MESSAGE_WARNING
- GTK_MESSAGE_QUESTION
- GTK_MESSAGE_ERROR

**Button Types:**
- GTK_BUTTONS_NONE
- GTK_BUTTONS_OK
- GTK_BUTTONS_CLOSE
- GTK_BUTTONS_CANCEL
- GTK_BUTTONS_YES_NO
- GTK_BUTTONS_OK_CANCEL

```nim
proc gtk_message_dialog_set_markup*(
  message_dialog: GtkMessageDialog,
  str: cstring
)
```

Sets message with markup.

**Example:**
```nim
let dialog = gtk_message_dialog_new(
  mainWindow,
  GTK_DIALOG_MODAL,
  GTK_MESSAGE_INFO,
  GTK_BUTTONS_OK,
  "Operation completed successfully"
)

proc onResponse(dialog: GtkDialog, response: gint, data: gpointer) {.cdecl.} =
  gtk_window_destroy(dialog)

discard g_signal_connect_data(dialog, "response", 
                              cast[GCallback](onResponse), 
                              nil, nil, 0)

gtk_window_present(dialog)
```

### GtkFileChooserDialog

File selection dialog.

```nim
proc gtk_file_chooser_dialog_new*(
  title: cstring,
  parent: GtkWindow,
  action: GtkFileChooserAction,
  first_button_text: cstring
): GtkWidget
```

Creates a file chooser dialog.

**Actions:**
- GTK_FILE_CHOOSER_ACTION_OPEN — Open file
- GTK_FILE_CHOOSER_ACTION_SAVE — Save file
- GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER — Select folder

```nim
proc gtk_file_chooser_get_file*(
  chooser: GtkFileChooser
): GFile
```

Gets selected file.

```nim
proc gtk_file_chooser_set_current_name*(
  chooser: GtkFileChooser,
  name: cstring
)
```

Sets current filename (for save dialogs).

```nim
proc gtk_file_chooser_set_current_folder*(
  chooser: GtkFileChooser,
  file: GFile,
  error: ptr GError
): gboolean
```

Sets current folder.

**Example:**
```nim
let dialog = gtk_file_chooser_dialog_new(
  "Open File",
  mainWindow,
  GTK_FILE_CHOOSER_ACTION_OPEN,
  nil
)

discard gtk_dialog_add_button(dialog, "Cancel", GTK_RESPONSE_CANCEL)
discard gtk_dialog_add_button(dialog, "Open", GTK_RESPONSE_ACCEPT)

proc onResponse(dialog: GtkDialog, response: gint, data: gpointer) {.cdecl.} =
  if response == GTK_RESPONSE_ACCEPT:
    let file = gtk_file_chooser_get_file(dialog)
    if file != nil:
      let path = g_file_get_path(file)
      echo "Selected file: ", path
      g_free(path)
      g_object_unref(file)
  gtk_window_destroy(dialog)

discard g_signal_connect_data(dialog, "response", 
                              cast[GCallback](onResponse), 
                              nil, nil, 0)

gtk_window_present(dialog)
```

### GtkAboutDialog

About dialog.

```nim
proc gtk_about_dialog_new*(): GtkWidget
```

Creates an about dialog.

```nim
proc gtk_about_dialog_set_program_name*(
  about: GtkAboutDialog,
  name: cstring
)
```

Sets program name.

```nim
proc gtk_about_dialog_set_version*(
  about: GtkAboutDialog,
  version: cstring
)
```

Sets version.

```nim
proc gtk_about_dialog_set_copyright*(
  about: GtkAboutDialog,
  copyright: cstring
)
```

Sets copyright.

```nim
proc gtk_about_dialog_set_comments*(
  about: GtkAboutDialog,
  comments: cstring
)
```

Sets comments.

```nim
proc gtk_about_dialog_set_license*(
  about: GtkAboutDialog,
  license: cstring
)
```

Sets license text.

```nim
proc gtk_about_dialog_set_website*(
  about: GtkAboutDialog,
  website: cstring
)
```

Sets website URL.

```nim
proc gtk_about_dialog_set_authors*(
  about: GtkAboutDialog,
  authors: cstringArray
)
```

Sets authors list.

**Example:**
```nim
let about = gtk_about_dialog_new()
gtk_about_dialog_set_program_name(about, "My Application")
gtk_about_dialog_set_version(about, "1.0.0")
gtk_about_dialog_set_copyright(about, "Copyright © 2026 My Company")
gtk_about_dialog_set_comments(about, "A great application")
gtk_about_dialog_set_website(about, "https://example.com")

let authors = allocCStringArray(["John Doe", "Jane Smith"])
gtk_about_dialog_set_authors(about, authors)

gtk_window_set_transient_for(about, mainWindow)
gtk_window_present(about)
```

---

## Menus and Bars

### GMenu and GMenuItem

Menu models for application menus.

```nim
proc g_menu_new*(): GMenu
```

Creates a new menu.

```nim
proc g_menu_item_new*(
  label: cstring,
  detailed_action: cstring
): GMenuItem
```

Creates a menu item.

```nim
proc g_menu_append_item*(
  menu: GMenu,
  item: GMenuItem
)
```

Appends an item to menu.

```nim
proc g_menu_append*(
  menu: GMenu,
  label: cstring,
  detailed_action: cstring
)
```

Appends an item with label and action.

```nim
proc g_menu_append_submenu*(
  menu: GMenu,
  label: cstring,
  submenu: GMenuModel
)
```

Appends a submenu.

**Example:**
```nim
let menu = g_menu_new()
g_menu_append(menu, "New", "app.new")
g_menu_append(menu, "Open", "app.open")
g_menu_append(menu, "Quit", "app.quit")

# Create submenu
let fileMenu = g_menu_new()
g_menu_append_submenu(menu, "File", fileMenu)
```

### GtkPopover

Popover widget.

```nim
proc gtk_popover_new*(): GtkWidget
```

Creates a popover.

```nim
proc gtk_popover_set_child*(
  popover: GtkPopover,
  child: GtkWidget
)
```

Sets popover content.

```nim
proc gtk_popover_set_pointing_to*(
  popover: GtkPopover,
  rect: ptr GdkRectangle
)
```

Sets pointing position.

```nim
proc gtk_popover_popup*(
  popover: GtkPopover
)
```

Shows the popover.

```nim
proc gtk_popover_popdown*(
  popover: GtkPopover
)
```

Hides the popover.

**Example:**
```nim
let button = gtk_button_new_with_label("Show Menu")
let popover = gtk_popover_new()

let box = gtk_box_new(GTK_ORIENTATION_VERTICAL, 5)
gtk_box_append(box, gtk_button_new_with_label("Option 1"))
gtk_box_append(box, gtk_button_new_with_label("Option 2"))
gtk_box_append(box, gtk_button_new_with_label("Option 3"))

gtk_popover_set_child(popover, box)
gtk_widget_set_parent(popover, button)

proc onClicked(btn: GtkButton, pop: gpointer) {.cdecl.} =
  gtk_popover_popup(cast[GtkPopover](pop))

discard g_signal_connect_data(button, "clicked", 
                              cast[GCallback](onClicked), 
                              popover, nil, 0)
```

### GtkHeaderBar

Header bar for windows.

```nim
proc gtk_header_bar_new*(): GtkWidget
```

Creates a header bar.

```nim
proc gtk_header_bar_pack_start*(
  bar: GtkHeaderBar,
  child: GtkWidget
)
```

Packs widget at start (left).

```nim
proc gtk_header_bar_pack_end*(
  bar: GtkHeaderBar,
  child: GtkWidget
)
```

Packs widget at end (right).

```nim
proc gtk_header_bar_set_title_widget*(
  bar: GtkHeaderBar,
  title_widget: GtkWidget
)
```

Sets title widget.

```nim
proc gtk_header_bar_set_decoration_layout*(
  bar: GtkHeaderBar,
  layout: cstring
)
```

Sets decoration button layout.

```nim
proc gtk_header_bar_set_show_title_buttons*(
  bar: GtkHeaderBar,
  setting: gboolean
)
```

Shows/hides window buttons.

**Example:**
```nim
let headerBar = gtk_header_bar_new()

# Add buttons
let btnMenu = gtk_menu_button_new()
gtk_menu_button_set_icon_name(btnMenu, "open-menu-symbolic")
gtk_header_bar_pack_end(headerBar, btnMenu)

let btnAdd = gtk_button_new_from_icon_name("list-add-symbolic")
gtk_header_bar_pack_start(headerBar, btnAdd)

# Set as window titlebar
gtk_window_set_titlebar(window, headerBar)
```

### GtkActionBar

Bottom action bar.

```nim
proc gtk_action_bar_new*(): GtkWidget
```

Creates an action bar.

```nim
proc gtk_action_bar_pack_start*(
  action_bar: GtkActionBar,
  child: GtkWidget
)
```

Packs widget at start.

```nim
proc gtk_action_bar_pack_end*(
  action_bar: GtkActionBar,
  child: GtkWidget
)
```

Packs widget at end.

```nim
proc gtk_action_bar_set_center_widget*(
  action_bar: GtkActionBar,
  center_widget: GtkWidget
)
```

Sets center widget.

**Example:**
```nim
let actionBar = gtk_action_bar_new()
gtk_action_bar_pack_start(actionBar, gtk_button_new_with_label("Cancel"))
gtk_action_bar_pack_end(actionBar, gtk_button_new_with_label("Apply"))
```

---

## Drawing

### GtkDrawingArea

Custom drawing widget.

```nim
proc gtk_drawing_area_new*(): GtkWidget
```

Creates a drawing area.

```nim
proc gtk_drawing_area_set_draw_func*(
  area: GtkDrawingArea,
  draw_func: GtkDrawingAreaDrawFunc,
  user_data: gpointer,
  destroy: GDestroyNotify
)
```

Sets the draw function.

**Draw Function Signature:**
```nim
type GtkDrawingAreaDrawFunc* = proc(
  drawing_area: GtkDrawingArea,
  cr: ptr cairo_t,
  width: gint,
  height: gint,
  user_data: gpointer
) {.cdecl.}
```

```nim
proc gtk_drawing_area_set_content_width*(
  self: GtkDrawingArea,
  width: gint
)
```

Sets content width.

```nim
proc gtk_drawing_area_set_content_height*(
  self: GtkDrawingArea,
  height: gint
)
```

Sets content height.

**Example:**
```nim
proc drawCallback(area: GtkDrawingArea, cr: ptr cairo_t, 
                  width: gint, height: gint, data: gpointer) {.cdecl.} =
  # Draw a red circle
  cairo_set_source_rgb(cr, 1.0, 0.0, 0.0)
  cairo_arc(cr, width.float/2, height.float/2, 50.0, 0.0, 2 * PI)
  cairo_fill(cr)
  
  # Draw a blue rectangle
  cairo_set_source_rgb(cr, 0.0, 0.0, 1.0)
  cairo_rectangle(cr, 10.0, 10.0, 100.0, 50.0)
  cairo_fill(cr)

let drawingArea = gtk_drawing_area_new()
gtk_drawing_area_set_content_width(drawingArea, 400)
gtk_drawing_area_set_content_height(drawingArea, 300)
gtk_drawing_area_set_draw_func(drawingArea, drawCallback, nil, nil)
```

### Cairo Drawing Functions

```nim
proc cairo_set_source_rgb*(
  cr: ptr cairo_t,
  red: cdouble,
  green: cdouble,
  blue: cdouble
)
```

Sets RGB color (0.0 to 1.0).

```nim
proc cairo_set_source_rgba*(
  cr: ptr cairo_t,
  red: cdouble,
  green: cdouble,
  blue: cdouble,
  alpha: cdouble
)
```

Sets RGBA color with alpha.

```nim
proc cairo_set_line_width*(
  cr: ptr cairo_t,
  width: cdouble
)
```

Sets line width.

```nim
proc cairo_move_to*(
  cr: ptr cairo_t,
  x: cdouble,
  y: cdouble
)
```

Moves to position.

```nim
proc cairo_line_to*(
  cr: ptr cairo_t,
  x: cdouble,
  y: cdouble
)
```

Draws line to position.

```nim
proc cairo_rectangle*(
  cr: ptr cairo_t,
  x: cdouble,
  y: cdouble,
  width: cdouble,
  height: cdouble
)
```

Adds rectangle to path.

```nim
proc cairo_arc*(
  cr: ptr cairo_t,
  xc: cdouble,
  yc: cdouble,
  radius: cdouble,
  angle1: cdouble,
  angle2: cdouble
)
```

Adds arc to path.

```nim
proc cairo_stroke*(
  cr: ptr cairo_t
)
```

Strokes the current path.

```nim
proc cairo_fill*(
  cr: ptr cairo_t
)
```

Fills the current path.

**Example - Complex Drawing:**
```nim
proc drawGraph(area: GtkDrawingArea, cr: ptr cairo_t, 
               width: gint, height: gint, data: gpointer) {.cdecl.} =
  # White background
  cairo_set_source_rgb(cr, 1.0, 1.0, 1.0)
  cairo_rectangle(cr, 0.0, 0.0, width.float, height.float)
  cairo_fill(cr)
  
  # Draw grid
  cairo_set_source_rgb(cr, 0.9, 0.9, 0.9)
  cairo_set_line_width(cr, 1.0)
  for i in 0..<10:
    let x = width.float * i.float / 10.0
    cairo_move_to(cr, x, 0.0)
    cairo_line_to(cr, x, height.float)
  for i in 0..<10:
    let y = height.float * i.float / 10.0
    cairo_move_to(cr, 0.0, y)
    cairo_line_to(cr, width.float, y)
  cairo_stroke(cr)
  
  # Draw sine wave
  cairo_set_source_rgb(cr, 0.0, 0.0, 1.0)
  cairo_set_line_width(cr, 2.0)
  cairo_move_to(cr, 0.0, height.float / 2.0)
  for i in 0..<width:
    let x = i.float
    let y = height.float / 2.0 + sin(x / 20.0) * height.float / 4.0
    cairo_line_to(cr, x, y)
  cairo_stroke(cr)
```

---

## Events and Signals

### Signal Connection

```nim
proc g_signal_connect_data*(
  instance: gpointer,
  detailed_signal: cstring,
  c_handler: GCallback,
  data: gpointer,
  destroy_data: GClosureNotify,
  connect_flags: GConnectFlags
): gulong
```

Connects a signal handler.

**Returns:** Handler ID (for disconnection)

```nim
proc g_signal_handler_disconnect*(
  instance: gpointer,
  handler_id: gulong
)
```

Disconnects a signal handler.

```nim
proc g_signal_handler_block*(
  instance: gpointer,
  handler_id: gulong
)
```

Blocks a signal handler.

```nim
proc g_signal_handler_unblock*(
  instance: gpointer,
  handler_id: gulong
)
```

Unblocks a signal handler.

**Example:**
```nim
var handlerId: gulong

proc onClicked(btn: GtkButton, data: gpointer) {.cdecl.} =
  echo "Clicked!"
  # Disconnect after first click
  g_signal_handler_disconnect(btn, handlerId)

handlerId = g_signal_connect_data(button, "clicked", 
                                  cast[GCallback](onClicked), 
                                  nil, nil, 0)
```

### Common Widget Signals

#### Button Signals
- `"clicked"` — Button clicked
- `"activate"` — Button activated (keyboard)

#### Toggle Signals
- `"toggled"` — Toggle state changed

#### Entry Signals
- `"changed"` — Text changed
- `"activate"` — Enter pressed

#### Window Signals
- `"destroy"` — Window destroyed
- `"close-request"` — Close requested

### Event Controllers

Modern GTK4 event handling.

```nim
proc gtk_event_controller_key_new*(): GtkEventController
```

Creates keyboard event controller.

```nim
proc gtk_event_controller_motion_new*(): GtkEventController
```

Creates motion event controller.

```nim
proc gtk_gesture_click_new*(): GtkGesture
```

Creates click gesture.

```nim
proc gtk_gesture_drag_new*(): GtkGesture
```

Creates drag gesture.

```nim
proc gtk_widget_add_controller*(
  widget: GtkWidget,
  controller: GtkEventController
)
```

Adds controller to widget.

**Example - Keyboard Events:**
```nim
proc onKeyPressed(controller: GtkEventController, keyval: guint, 
                  keycode: guint, state: GdkModifierType, 
                  data: gpointer): gboolean {.cdecl.} =
  echo "Key pressed: ", keyval
  if keyval == GDK_KEY_Escape:
    echo "Escape pressed!"
    return 1
  return 0

let keyController = gtk_event_controller_key_new()
discard g_signal_connect_data(keyController, "key-pressed", 
                              cast[GCallback](onKeyPressed), 
                              nil, nil, 0)
gtk_widget_add_controller(window, keyController)
```

**Example - Mouse Events:**
```nim
proc onMotion(controller: GtkEventController, x: gdouble, y: gdouble, 
              data: gpointer) {.cdecl.} =
  echo "Mouse at: ", x, ", ", y

let motionController = gtk_event_controller_motion_new()
discard g_signal_connect_data(motionController, "motion", 
                              cast[GCallback](onMotion), 
                              nil, nil, 0)
gtk_widget_add_controller(drawingArea, motionController)
```

**Example - Click Gesture:**
```nim
proc onClick(gesture: GtkGesture, n_press: gint, x: gdouble, y: gdouble, 
             data: gpointer) {.cdecl.} =
  echo "Clicked at: ", x, ", ", y
  echo "Press count: ", n_press

let clickGesture = gtk_gesture_click_new()
discard g_signal_connect_data(clickGesture, "pressed", 
                              cast[GCallback](onClick), 
                              nil, nil, 0)
gtk_widget_add_controller(widget, clickGesture)
```

---

## CSS and Styling

### CSS Provider

```nim
proc gtk_css_provider_new*(): GtkCssProvider
```

Creates a CSS provider.

```nim
proc gtk_css_provider_load_from_data*(
  css_provider: GtkCssProvider,
  data: cstring,
  length: gssize
)
```

Loads CSS from string.

```nim
proc gtk_css_provider_load_from_file*(
  css_provider: GtkCssProvider,
  file: GFile
)
```

Loads CSS from file.

```nim
proc gtk_style_context_add_provider_for_display*(
  display: GdkDisplay,
  provider: GtkStyleProvider,
  priority: guint
)
```

Applies CSS provider to display.

**Priority Constants:**
- GTK_STYLE_PROVIDER_PRIORITY_FALLBACK = 1
- GTK_STYLE_PROVIDER_PRIORITY_THEME = 200
- GTK_STYLE_PROVIDER_PRIORITY_SETTINGS = 400
- GTK_STYLE_PROVIDER_PRIORITY_APPLICATION = 600
- GTK_STYLE_PROVIDER_PRIORITY_USER = 800

**Example:**
```nim
let css = """
  window {
    background-color: #f0f0f0;
  }
  
  button {
    border-radius: 8px;
    padding: 10px 20px;
    font-weight: bold;
  }
  
  button:hover {
    background-color: #e0e0e0;
  }
  
  .primary-button {
    background-color: #007bff;
    color: white;
  }
  
  .danger-button {
    background-color: #dc3545;
    color: white;
  }
  
  label.title {
    font-size: 24px;
    font-weight: bold;
  }
"""

let provider = gtk_css_provider_new()
gtk_css_provider_load_from_data(provider, css, -1)

let display = gdk_display_get_default()
gtk_style_context_add_provider_for_display(
  display, 
  provider, 
  GTK_STYLE_PROVIDER_PRIORITY_APPLICATION
)
```

### CSS Classes

```nim
proc gtk_widget_add_css_class*(
  widget: GtkWidget,
  css_class: cstring
)
```

Adds a CSS class.

```nim
proc gtk_widget_remove_css_class*(
  widget: GtkWidget,
  css_class: cstring
)
```

Removes a CSS class.

```nim
proc gtk_widget_has_css_class*(
  widget: GtkWidget,
  css_class: cstring
): gboolean
```

Checks for CSS class.

**Example:**
```nim
let btnSave = gtk_button_new_with_label("Save")
gtk_widget_add_css_class(btnSave, "primary-button")

let btnDelete = gtk_button_new_with_label("Delete")
gtk_widget_add_css_class(btnDelete, "danger-button")

# Toggle class
if gtk_widget_has_css_class(widget, "active") == 1:
  gtk_widget_remove_css_class(widget, "active")
else:
  gtk_widget_add_css_class(widget, "active")
```

---

## Resources and Data

### GResource

Embedded resource system.

```nim
proc g_resource_load*(
  filename: cstring,
  error: ptr GError
): GResource
```

Loads resources from file.

```nim
proc g_resources_register*(
  resource: GResource
)
```

Registers resources globally.

```nim
proc g_resources_unregister*(
  resource: GResource
)
```

Unregisters resources.

```nim
proc g_resource_lookup_data*(
  resource: GResource,
  path: cstring,
  lookup_flags: GResourceLookupFlags,
  error: ptr GError
): GBytes
```

Looks up resource data.

**Example:**
```nim
# Compile resources: glib-compile-resources resources.gresource.xml
let resource = g_resource_load("resources.gresource", nil)
if resource != nil:
  g_resources_register(resource)
  
  # Load image from resources
  let image = gtk_image_new_from_resource("/com/example/app/icon.png")
  
  # Load CSS from resources
  let cssFile = g_file_new_for_uri("resource:///com/example/app/style.css")
  let provider = gtk_css_provider_new()
  gtk_css_provider_load_from_file(provider, cssFile)
```

### GBytes

Immutable byte array.

```nim
proc g_bytes_new*(
  data: gconstpointer,
  size: gsize
): GBytes
```

Creates a new GBytes.

```nim
proc g_bytes_get_data*(
  bytes: GBytes,
  size: ptr gsize
): gconstpointer
```

Gets the data pointer.

```nim
proc g_bytes_get_size*(
  bytes: GBytes
): gsize
```

Gets the size.

```nim
proc g_bytes_unref*(
  bytes: GBytes
)
```

Decreases reference count.

---

## Layout Managers

### GtkBoxLayout

Box layout manager.

```nim
proc gtk_box_layout_new*(
  orientation: GtkOrientation
): GtkLayoutManager
```

Creates a box layout.

```nim
proc gtk_box_layout_set_spacing*(
  box_layout: GtkBoxLayout,
  spacing: guint
)
```

Sets spacing.

```nim
proc gtk_box_layout_set_homogeneous*(
  box_layout: GtkBoxLayout,
  homogeneous: gboolean
)
```

Sets homogeneous mode.

### GtkGridLayout

Grid layout manager.

```nim
proc gtk_grid_layout_new*(): GtkLayoutManager
```

Creates a grid layout.

```nim
proc gtk_grid_layout_set_row_spacing*(
  grid_layout: GtkGridLayout,
  spacing: guint
)
```

Sets row spacing.

```nim
proc gtk_grid_layout_set_column_spacing*(
  grid_layout: GtkGridLayout,
  spacing: guint
)
```

Sets column spacing.

### GtkCenterLayout

Center layout manager.

```nim
proc gtk_center_layout_new*(): GtkLayoutManager
```

Creates a center layout.

```nim
proc gtk_center_layout_set_center_widget*(
  self: GtkCenterLayout,
  widget: GtkWidget
)
```

Sets center widget.

```nim
proc gtk_center_layout_set_start_widget*(
  self: GtkCenterLayout,
  widget: GtkWidget
)
```

Sets start widget.

```nim
proc gtk_center_layout_set_end_widget*(
  self: GtkCenterLayout,
  widget: GtkWidget
)
```

Sets end widget.

---

## Models and Lists

### GListModel

Generic list model interface.

```nim
proc g_list_store_new*(
  item_type: GType
): GListStore
```

Creates a list store.

```nim
proc g_list_store_append*(
  store: GListStore,
  item: gpointer
)
```

Appends an item.

```nim
proc g_list_store_insert*(
  store: GListStore,
  position: guint,
  item: gpointer
)
```

Inserts an item.

```nim
proc g_list_store_remove*(
  store: GListStore,
  position: guint
)
```

Removes an item.

```nim
proc g_list_model_get_n_items*(
  list: GListModel
): guint
```

Gets item count.

```nim
proc g_list_model_get_item*(
  list: GListModel,
  position: guint
): gpointer
```

Gets item at position.

### GtkStringList

String list model.

```nim
proc gtk_string_list_new*(
  strings: cstringArray
): GtkStringList
```

Creates a string list.

```nim
proc gtk_string_list_append*(
  self: GtkStringList,
  string: cstring
)
```

Appends a string.

```nim
proc gtk_string_list_get_string*(
  self: GtkStringList,
  position: guint
): cstring
```

Gets string at position.

---

## Inspector API

GTK Inspector debugging tools.

### Inspector Window

```nim
proc gtk_inspector_window_get_type*(): pointer
```

Gets inspector window type.

```nim
proc gtk_inspector_window_select_widget_under_pointer*(
  iw: pointer
)
```

Selects widget under pointer.

```nim
proc gtk_inspector_window_get_inspected_display*(
  iw: pointer
): pointer
```

Gets inspected display.

```nim
proc gtk_inspector_is_recording*(
  widget: GtkWidget
): gboolean
```

Checks if recording.

```nim
proc gtk_inspector_handle_event*(
  event: pointer
): gboolean
```

Handles inspector event.

### Recording

```nim
proc gtk_inspector_recorder_is_recording*(
  recorder: pointer
): gboolean
```

Checks recording status.

```nim
proc gtk_inspector_recording_get_timestamp*(
  recording: pointer
): gint64
```

Gets recording timestamp.

```nim
proc gtk_inspector_render_recording_get_node*(
  recording: pointer
): pointer
```

Gets render node from recording.

---

## Accessibility API

Accessibility support.

### GtkAccessible

```nim
proc gtk_accessible_get_accessible_role*(
  self: GtkAccessible
): GtkAccessibleRole
```

Gets accessible role.

```nim
proc gtk_accessible_update_state*(
  self: GtkAccessible,
  first_state: GtkAccessibleState
)
```

Updates state.

```nim
proc gtk_accessible_update_property*(
  self: GtkAccessible,
  first_property: GtkAccessibleProperty
)
```

Updates property.

```nim
proc gtk_accessible_update_relation*(
  self: GtkAccessible,
  first_relation: GtkAccessibleRelation
)
```

Updates relation.

---

## Actions API

Application actions.

### GSimpleAction

```nim
proc g_simple_action_new*(
  name: cstring,
  parameter_type: pointer
): GSimpleAction
```

Creates a simple action.

```nim
proc g_simple_action_set_enabled*(
  simple: GSimpleAction,
  enabled: gboolean
)
```

Enables/disables action.

```nim
proc g_action_map_add_action*(
  action_map: GActionMap,
  action: GAction
)
```

Adds action to map.

**Example:**
```nim
proc onQuit(action: GSimpleAction, parameter: pointer, app: GApplication) {.cdecl.} =
  g_application_quit(app)

proc onAbout(action: GSimpleAction, parameter: pointer, app: GApplication) {.cdecl.} =
  echo "Show about dialog"

let quitAction = g_simple_action_new("quit", nil)
discard g_signal_connect_data(quitAction, "activate", 
                              cast[GCallback](onQuit), 
                              app, nil, 0)
g_action_map_add_action(app, quitAction)

let aboutAction = g_simple_action_new("about", nil)
discard g_signal_connect_data(aboutAction, "activate", 
                              cast[GCallback](onAbout), 
                              app, nil, 0)
g_action_map_add_action(app, aboutAction)
```

---

## Builder API

UI construction from XML.

### GtkBuilder

```nim
proc gtk_builder_new*(): GtkBuilder
```

Creates a builder.

```nim
proc gtk_builder_new_from_file*(
  filename: cstring
): GtkBuilder
```

Creates builder from file.

```nim
proc gtk_builder_new_from_string*(
  string: cstring,
  length: gssize
): GtkBuilder
```

Creates builder from string.

```nim
proc gtk_builder_add_from_file*(
  builder: GtkBuilder,
  filename: cstring,
  error: ptr GError
): gboolean
```

Adds UI from file.

```nim
proc gtk_builder_get_object*(
  builder: GtkBuilder,
  name: cstring
): GObject
```

Gets object by ID.

**Example:**
```nim
let ui = """
<?xml version="1.0" encoding="UTF-8"?>
<interface>
  <object class="GtkWindow" id="window">
    <property name="title">Builder Example</property>
    <property name="default-width">400</property>
    <property name="default-height">300</property>
    <child>
      <object class="GtkBox" id="main_box">
        <property name="orientation">vertical</property>
        <property name="spacing">10</property>
        <child>
          <object class="GtkLabel" id="label">
            <property name="label">Hello from Builder!</property>
          </object>
        </child>
        <child>
          <object class="GtkButton" id="button">
            <property name="label">Click Me</property>
          </object>
        </child>
      </object>
    </child>
  </object>
</interface>
"""

let builder = gtk_builder_new_from_string(ui, -1)
let window = gtk_builder_get_object(builder, "window")
let button = gtk_builder_get_object(builder, "button")

proc onClicked(btn: GtkButton, data: gpointer) {.cdecl.} =
  echo "Button clicked from builder!"

discard g_signal_connect_data(button, "clicked", 
                              cast[GCallback](onClicked), 
                              nil, nil, 0)
```

---

## Constraint API

Constraint-based layouts.

### GtkConstraintLayout

```nim
proc gtk_constraint_layout_new*(): GtkLayoutManager
```

Creates constraint layout.

```nim
proc gtk_constraint_new*(
  target: GtkConstraintTarget,
  target_attribute: GtkConstraintAttribute,
  relation: GtkConstraintRelation,
  source: GtkConstraintTarget,
  source_attribute: GtkConstraintAttribute,
  multiplier: gdouble,
  constant: gdouble,
  strength: gint
): GtkConstraint
```

Creates a constraint.

```nim
proc gtk_constraint_layout_add_constraint*(
  layout: GtkConstraintLayout,
  constraint: GtkConstraint
)
```

Adds a constraint.

---

## GSK (Graphics)

Graphics rendering API.

### GskRenderNode

```nim
proc gsk_render_node_draw*(
  node: pointer,
  cr: ptr cairo_t
)
```

Draws render node.

```nim
proc gsk_render_node_get_bounds*(
  node: pointer,
  bounds: pointer
)
```

Gets node bounds.

```nim
proc gsk_render_node_unref*(
  node: pointer
)
```

Unreferences node.

### GskTransform

```nim
proc gsk_transform_new*(): pointer
```

Creates new transform.

```nim
proc gsk_transform_translate*(
  next: pointer,
  point: pointer
): pointer
```

Translates transform.

```nim
proc gsk_transform_rotate*(
  next: pointer,
  angle: gfloat
): pointer
```

Rotates transform.

```nim
proc gsk_transform_scale*(
  next: pointer,
  factor_x: gfloat,
  factor_y: gfloat
): pointer
```

Scales transform.

---

## GDK (Display)

Display and device API.

### GdkDisplay

```nim
proc gdk_display_get_default*(): GdkDisplay
```

Gets default display.

```nim
proc gdk_display_get_name*(
  display: GdkDisplay
): cstring
```

Gets display name.

```nim
proc gdk_display_flush*(
  display: GdkDisplay
)
```

Flushes display.

```nim
proc gdk_display_sync*(
  display: GdkDisplay
)
```

Synchronizes display.

### GdkMonitor

```nim
proc gdk_display_get_monitors*(
  display: GdkDisplay
): GListModel
```

Gets monitor list.

```nim
proc gdk_monitor_get_geometry*(
  monitor: GdkMonitor,
  geometry: ptr GdkRectangle
)
```

Gets monitor geometry.

```nim
proc gdk_monitor_get_width_mm*(
  monitor: GdkMonitor
): gint
```

Gets physical width in mm.

```nim
proc gdk_monitor_get_height_mm*(
  monitor: GdkMonitor
): gint
```

Gets physical height in mm.

### GdkClipboard

```nim
proc gdk_display_get_clipboard*(
  display: GdkDisplay
): GdkClipboard
```

Gets clipboard.

```nim
proc gdk_clipboard_set_text*(
  clipboard: GdkClipboard,
  text: cstring
)
```

Sets clipboard text.

```nim
proc gdk_clipboard_read_text_async*(
  clipboard: GdkClipboard,
  cancellable: pointer,
  callback: GAsyncReadyCallback,
  user_data: gpointer
)
```

Reads clipboard text asynchronously.

**Example:**
```nim
let display = gdk_display_get_default()
let clipboard = gdk_display_get_clipboard(display)
gdk_clipboard_set_text(clipboard, "Hello, Clipboard!")
```

---

## Bitset API

Efficient bitset operations.

```nim
proc bitset_free*(bitset: pointer): pointer
```

Frees bitset.

```nim
proc bitset_clear*(bitset: pointer): pointer
```

Clears all bits.

```nim
proc bitset_fill*(bitset: pointer): pointer
```

Sets all bits.

```nim
proc bitset_count*(bitset: pointer): pointer
```

Counts set bits.

```nim
proc bitset_empty*(bitset: pointer): pointer
```

Checks if empty.

```nim
proc bitset_minimum*(bitset: pointer): pointer
```

Finds minimum set bit.

```nim
proc bitset_maximum*(bitset: pointer): pointer
```

Finds maximum set bit.

---

## Roaring Bitmap API

Compressed bitmap for large integer sets.

### 32-bit Roaring Bitmaps

```nim
proc roaring_bitmap_create_with_capacity*(): pointer
```

Creates bitmap with capacity.

```nim
proc roaring_bitmap_free*(r: pointer): pointer
```

Frees bitmap.

```nim
proc roaring_bitmap_add*(
  r: pointer,
  x: pointer
): pointer
```

Adds element.

```nim
proc roaring_bitmap_remove*(
  r: pointer,
  x: pointer
): pointer
```

Removes element.

```nim
proc roaring_bitmap_contains*(
  r: pointer,
  val: pointer
): pointer
```

Checks if contains element.

```nim
proc roaring_bitmap_get_cardinality*(
  r: pointer
): pointer
```

Gets element count.

```nim
proc roaring_bitmap_is_empty*(
  r: pointer
): pointer
```

Checks if empty.

```nim
proc roaring_bitmap_minimum*(
  r: pointer
): pointer
```

Gets minimum element.

```nim
proc roaring_bitmap_maximum*(
  r: pointer
): pointer
```

Gets maximum element.

```nim
proc roaring_bitmap_run_optimize*(
  r: pointer
): pointer
```

Optimizes for runs.

```nim
proc roaring_bitmap_shrink_to_fit*(
  r: pointer
): pointer
```

Shrinks memory usage.

```nim
proc roaring_bitmap_serialize*(
  r: pointer,
  buf: cstring
): pointer
```

Serializes bitmap.

```nim
proc roaring_bitmap_size_in_bytes*(
  r: pointer
): pointer
```

Gets serialized size.

### 64-bit Roaring Bitmaps

```nim
proc roaring64_bitmap_free*(r: pointer): pointer
```

Frees 64-bit bitmap.

```nim
proc roaring64_bitmap_add*(
  r: pointer,
  val: pointer
): pointer
```

Adds 64-bit element.

```nim
proc roaring64_bitmap_contains*(
  r: pointer,
  val: pointer
): pointer
```

Checks 64-bit element.

```nim
proc roaring64_bitmap_get_cardinality*(
  r: pointer
): pointer
```

Gets count.

---

## Utilities

### Memory Management

```nim
proc safeUnref*[T](obj: var T)
```

Safely unreferences GObject.

**Example:**
```nim
var window = gtk_application_window_new(app)
# ... use window ...
window.safeUnref()  # Now window is nil
```

```nim
proc safeRef*[T](obj: T): T
```

Safely references GObject.

### Settings

```nim
proc getDefaultSettings*(): GtkSettings
```

Gets default GTK settings.

```nim
proc isDarkTheme*(): bool
```

Checks if dark theme is active.

### GLib Utilities

```nim
proc g_timeout_add*(
  interval: guint,
  function: GSourceFunc,
  data: gpointer
): guint
```

Adds timeout callback.

**Example:**
```nim
proc onTimeout(data: gpointer): gboolean {.cdecl.} =
  echo "Timeout fired!"
  return 1  # Continue repeating

discard g_timeout_add(1000, onTimeout, nil)  # Every 1 second
```

```nim
proc g_idle_add*(
  function: GSourceFunc,
  data: gpointer
): guint
```

Adds idle callback.

```nim
proc g_source_remove*(
  tag: guint
): gboolean
```

Removes timeout/idle source.

---

## Complete Examples

### Example 1: Hello World Application

```nim
import libGTK4

proc activate(app: GtkApplication, userData: gpointer) {.cdecl.} =
  let window = gtk_application_window_new(app)
  gtk_window_set_title(window, "Hello GTK4")
  gtk_window_set_default_size(window, 400, 300)
  
  let button = gtk_button_new_with_label("Hello, World!")
  gtk_window_set_child(window, button)
  
  proc onClicked(btn: GtkButton, data: gpointer) {.cdecl.} =
    echo "Hello, World!"
  
  discard g_signal_connect_data(button, "clicked", 
                                cast[GCallback](onClicked), 
                                nil, nil, 0)
  
  gtk_window_present(window)

proc main() =
  let app = gtk_application_new("com.example.hello", G_APPLICATION_DEFAULT_FLAGS)
  discard g_signal_connect_data(app, "activate", 
                                cast[GCallback](activate), 
                                nil, nil, 0)
  let status = g_application_run(app, 0, nil)
  g_object_unref(app)
  quit(status)

main()
```

### Example 2: Text Editor

```nim
import libGTK4

proc activate(app: GtkApplication, userData: gpointer) {.cdecl.} =
  # Create window
  let window = gtk_application_window_new(app)
  gtk_window_set_title(window, "Simple Text Editor")
  gtk_window_set_default_size(window, 600, 400)
  
  # Create header bar
  let headerBar = gtk_header_bar_new()
  let btnOpen = gtk_button_new_with_label("Open")
  let btnSave = gtk_button_new_with_label("Save")
  gtk_header_bar_pack_start(headerBar, btnOpen)
  gtk_header_bar_pack_end(headerBar, btnSave)
  gtk_window_set_titlebar(window, headerBar)
  
  # Create text view with scrolling
  let scrolled = gtk_scrolled_window_new()
  let textView = gtk_text_view_new()
  gtk_text_view_set_wrap_mode(textView, GTK_WRAP_WORD)
  gtk_scrolled_window_set_child(scrolled, textView)
  gtk_window_set_child(window, scrolled)
  
  # Open button handler
  proc onOpen(btn: GtkButton, data: gpointer) {.cdecl.} =
    let dialog = gtk_file_chooser_dialog_new(
      "Open File",
      window,
      GTK_FILE_CHOOSER_ACTION_OPEN,
      nil
    )
    discard gtk_dialog_add_button(dialog, "Cancel", GTK_RESPONSE_CANCEL)
    discard gtk_dialog_add_button(dialog, "Open", GTK_RESPONSE_ACCEPT)
    
    proc onResponse(dlg: GtkDialog, response: gint, tv: gpointer) {.cdecl.} =
      if response == GTK_RESPONSE_ACCEPT:
        let file = gtk_file_chooser_get_file(dlg)
        if file != nil:
          # Read file content (simplified)
          let path = g_file_get_path(file)
          echo "Opening: ", path
          g_free(path)
          g_object_unref(file)
      gtk_window_destroy(dlg)
    
    discard g_signal_connect_data(dialog, "response", 
                                  cast[GCallback](onResponse), 
                                  textView, nil, 0)
    gtk_window_present(dialog)
  
  # Save button handler
  proc onSave(btn: GtkButton, tv: gpointer) {.cdecl.} =
    let textView = cast[GtkTextView](tv)
    let buffer = gtk_text_view_get_buffer(textView)
    var start, endIter: GtkTextIter
    gtk_text_buffer_get_start_iter(buffer, addr start)
    gtk_text_buffer_get_end_iter(buffer, addr endIter)
    let text = gtk_text_buffer_get_text(buffer, addr start, addr endIter, 0)
    echo "Saving text: ", text
  
  discard g_signal_connect_data(btnOpen, "clicked", 
                                cast[GCallback](onOpen), 
                                nil, nil, 0)
  discard g_signal_connect_data(btnSave, "clicked", 
                                cast[GCallback](onSave), 
                                textView, nil, 0)
  
  gtk_window_present(window)

proc main() =
  let app = gtk_application_new("com.example.editor", G_APPLICATION_DEFAULT_FLAGS)
  discard g_signal_connect_data(app, "activate", 
                                cast[GCallback](activate), 
                                nil, nil, 0)
  discard g_application_run(app, 0, nil)
  g_object_unref(app)

main()
```

### Example 3: Calculator

```nim
import libGTK4
import strutils

var display: GtkEntry
var currentValue: float = 0.0
var pendingOp: string = ""
var pendingValue: float = 0.0

proc updateDisplay(value: float) =
  gtk_entry_set_text(display, $value)

proc onNumberClick(btn: GtkButton, data: gpointer) {.cdecl.} =
  let label = gtk_button_get_label(btn)
  let current = $gtk_entry_get_text(display)
  if current == "0" or pendingOp != "":
    gtk_entry_set_text(display, label)
    pendingOp = ""
  else:
    gtk_entry_set_text(display, current & $label)

proc onOpClick(btn: GtkButton, data: gpointer) {.cdecl.} =
  let op = $gtk_button_get_label(btn)
  currentValue = parseFloat($gtk_entry_get_text(display))
  pendingOp = op
  pendingValue = currentValue

proc onEquals(btn: GtkButton, data: gpointer) {.cdecl.} =
  let value = parseFloat($gtk_entry_get_text(display))
  var result: float
  case pendingOp:
  of "+": result = pendingValue + value
  of "-": result = pendingValue - value
  of "*": result = pendingValue * value
  of "/": result = if value != 0: pendingValue / value else: 0.0
  else: result = value
  
  updateDisplay(result)
  pendingOp = ""

proc onClear(btn: GtkButton, data: gpointer) {.cdecl.} =
  currentValue = 0.0
  pendingValue = 0.0
  pendingOp = ""
  updateDisplay(0.0)

proc activate(app: GtkApplication, userData: gpointer) {.cdecl.} =
  let window = gtk_application_window_new(app)
  gtk_window_set_title(window, "Calculator")
  gtk_window_set_default_size(window, 300, 400)
  
  let mainBox = gtk_box_new(GTK_ORIENTATION_VERTICAL, 5)
  gtk_window_set_child(window, mainBox)
  
  # Display
  display = gtk_entry_new()
  gtk_entry_set_text(display, "0")
  gtk_entry_set_alignment(display, 1.0)  # Right align
  gtk_widget_set_hexpand(display, 1)
  gtk_box_append(mainBox, display)
  
  # Button grid
  let grid = gtk_grid_new()
  gtk_grid_set_row_spacing(grid, 5)
  gtk_grid_set_column_spacing(grid, 5)
  gtk_box_append(mainBox, grid)
  
  # Number buttons
  let numbers = ["7", "8", "9", "4", "5", "6", "1", "2", "3", "0"]
  var row = 0
  var col = 0
  for num in numbers:
    let btn = gtk_button_new_with_label(num)
    gtk_grid_attach(grid, btn, col, row, 1, 1)
    discard g_signal_connect_data(btn, "clicked", 
                                  cast[GCallback](onNumberClick), 
                                  nil, nil, 0)
    col += 1
    if col > 2:
      col = 0
      row += 1
  
  # Operation buttons
  let ops = ["+", "-", "*", "/"]
  for i, op in ops:
    let btn = gtk_button_new_with_label(op)
    gtk_grid_attach(grid, btn, 3, i, 1, 1)
    discard g_signal_connect_data(btn, "clicked", 
                                  cast[GCallback](onOpClick), 
                                  nil, nil, 0)
  
  # Equals and Clear
  let btnEquals = gtk_button_new_with_label("=")
  gtk_grid_attach(grid, btnEquals, 1, 3, 1, 1)
  discard g_signal_connect_data(btnEquals, "clicked", 
                                cast[GCallback](onEquals), 
                                nil, nil, 0)
  
  let btnClear = gtk_button_new_with_label("C")
  gtk_grid_attach(grid, btnClear, 2, 3, 1, 1)
  discard g_signal_connect_data(btnClear, "clicked", 
                                cast[GCallback](onClear), 
                                nil, nil, 0)
  
  gtk_window_present(window)

proc main() =
  let app = gtk_application_new("com.example.calculator", G_APPLICATION_DEFAULT_FLAGS)
  discard g_signal_connect_data(app, "activate", 
                                cast[GCallback](activate), 
                                nil, nil, 0)
  discard g_application_run(app, 0, nil)
  g_object_unref(app)

main()
```

### Example 4: Drawing Application

```nim
import libGTK4
import math

var points: seq[tuple[x, y: float]] = @[]

proc drawCallback(area: GtkDrawingArea, cr: ptr cairo_t, 
                  width: gint, height: gint, data: gpointer) {.cdecl.} =
  # White background
  cairo_set_source_rgb(cr, 1.0, 1.0, 1.0)
  cairo_paint(cr)
  
  # Draw lines
  if points.len > 0:
    cairo_set_source_rgb(cr, 0.0, 0.0, 0.0)
    cairo_set_line_width(cr, 2.0)
    cairo_move_to(cr, points[0].x, points[0].y)
    for i in 1..<points.len:
      cairo_line_to(cr, points[i].x, points[i].y)
    cairo_stroke(cr)

proc onDrag(gesture: GtkGesture, x: gdouble, y: gdouble, area: gpointer) {.cdecl.} =
  points.add((x, y))
  gtk_widget_queue_draw(cast[GtkWidget](area))

proc onDragEnd(gesture: GtkGesture, x: gdouble, y: gdouble, data: gpointer) {.cdecl.} =
  points = @[]

proc activate(app: GtkApplication, userData: gpointer) {.cdecl.} =
  let window = gtk_application_window_new(app)
  gtk_window_set_title(window, "Drawing App")
  gtk_window_set_default_size(window, 800, 600)
  
  let drawingArea = gtk_drawing_area_new()
  gtk_drawing_area_set_draw_func(drawingArea, drawCallback, nil, nil)
  gtk_window_set_child(window, drawingArea)
  
  # Add drag gesture
  let dragGesture = gtk_gesture_drag_new()
  discard g_signal_connect_data(dragGesture, "drag-update", 
                                cast[GCallback](onDrag), 
                                drawingArea, nil, 0)
  discard g_signal_connect_data(dragGesture, "drag-end", 
                                cast[GCallback](onDragEnd), 
                                nil, nil, 0)
  gtk_widget_add_controller(drawingArea, dragGesture)
  
  gtk_window_present(window)

proc main() =
  let app = gtk_application_new("com.example.drawing", G_APPLICATION_DEFAULT_FLAGS)
  discard g_signal_connect_data(app, "activate", 
                                cast[GCallback](activate), 
                                nil, nil, 0)
  discard g_application_run(app, 0, nil)
  g_object_unref(app)

main()
```

---

## Constants Reference

### Orientation
```nim
const
  GTK_ORIENTATION_HORIZONTAL* = 0
  GTK_ORIENTATION_VERTICAL* = 1
```

### Alignment
```nim
const
  GTK_ALIGN_FILL* = 0
  GTK_ALIGN_START* = 1
  GTK_ALIGN_END* = 2
  GTK_ALIGN_CENTER* = 3
  GTK_ALIGN_BASELINE* = 4
```

### Response Types
```nim
const
  GTK_RESPONSE_NONE* = -1
  GTK_RESPONSE_REJECT* = -2
  GTK_RESPONSE_ACCEPT* = -3
  GTK_RESPONSE_DELETE_EVENT* = -4
  GTK_RESPONSE_OK* = -5
  GTK_RESPONSE_CANCEL* = -6
  GTK_RESPONSE_CLOSE* = -7
  GTK_RESPONSE_YES* = -8
  GTK_RESPONSE_NO* = -9
  GTK_RESPONSE_APPLY* = -10
```

### Application Flags
```nim
const
  G_APPLICATION_DEFAULT_FLAGS* = 0
  G_APPLICATION_IS_SERVICE* = (1 shl 0)
  G_APPLICATION_HANDLES_OPEN* = (1 shl 1)
  G_APPLICATION_HANDLES_COMMAND_LINE* = (1 shl 2)
```

---

## Additional Resources

- [Official GTK Documentation](https://docs.gtk.org/gtk4/)
- [GTK4 Tutorial](https://www.gtk.org/docs/getting-started/)
- [Nim Programming Language](https://nim-lang.org/)
- [Cairo Graphics](https://www.cairographics.org/)
- [Pango Text Layout](https://pango.gnome.org/)

---

## License

This library follows the GTK4 license terms.

## Contact

**Author:** Balans097  
**Email:** vasil.minsk@yahoo.com

---

*Documentation generated for version 1.2 (2026-02-15)*
