# GTK4 Signals Overview

## General information

In GTK4, every widget can emit **signals** — events that can be subscribed to via `g_signal_connect`. Signals let you respond to user actions, state changes, and widget lifecycle events.

---

## Common GtkWidget signals

| Signal                | When it fires                  | Parameters                            |
| ---------------------- | ------------------------------- | ------------------------------------ |
| realize                | Widget is bound to the screen   | widget                               |
| unrealize              | Widget is detached from the screen | widget                            |
| map                    | Widget is displayed             | widget                               |
| unmap                  | Widget is hidden                | widget                               |
| show                   | Widget becomes visible          | widget                               |
| hide                   | Widget is hidden                | widget                               |
| destroy                | Widget is destroyed             | widget                               |
| size-allocate          | Size changed                    | widget, allocation                   |
| state-flags-changed    | State changed                   | widget, flags                        |
| direction-changed      | Text direction changed          | widget, direction                    |
| mnemonic-activate      | Mnemonic activated              | widget, group_cycling                |
| focus                  | Widget received focus           | widget, direction                    |
| enter-notify           | Cursor entered                  | widget, event                        |
| leave-notify           | Cursor left                     | widget, event                        |
| motion-notify          | Cursor movement                 | widget, event                        |
| button-press-event     | Mouse button pressed            | widget, event                        |
| button-release-event   | Mouse button released           | widget, event                        |
| scroll-event           | Scrolling                       | widget, event                        |
| key-press-event        | Key pressed                     | widget, event                        |
| key-release-event      | Key released                    | widget, event                        |
| query-tooltip          | Tooltip requested               | widget, x, y, keyboard_mode, tooltip |

---

## GtkWindow

| Signal            | When it fires                    | Parameters    |
| ----------------- | --------------------------------- | ------------- |
| activate-focus    | The focused widget is activated   | window        |
| activate-default  | The default widget is activated   | window        |
| close-request     | A window-close request            | window        |
| notify::is-active | Window became active/inactive     | window, pspec |

---

## GtkButton

| Signal   | When it fires     | Parameters |
| -------- | ------------------ | --------- |
| clicked  | Click on the button | button    |
| activate | Enter/Space          | button    |
| pressed  | Press               | button    |
| released | Release             | button    |

---

## GtkCheckButton / GtkToggleButton

| Signal   | When it fires   | Parameters    |
| -------- | ---------------- | ------------- |
| toggled  | State changed    | toggle_button |
| clicked  | Click            | button        |
| activate | Activation       | button        |

---

## GtkEntry

| Signal          | When it fires      | Parameters              |
| --------------- | -------------------- | ---------------------- |
| activate        | Enter                | entry                  |
| changed         | Text changed         | editable               |
| icon-press      | Click on the icon     | entry, icon_pos, event |
| icon-release    | Icon released         | entry, icon_pos, event |
| preedit-changed | Preedit text changed  | entry                  |

---

## GtkTextView

| Signal                      | When it fires              | Parameters                                    |
| ---------------------------- | ---------------------------- | --------------------------------------------- |
| backspace                    | Backspace                   | text_view                                    |
| copy-clipboard                | Copy                        | text_view                                    |
| cut-clipboard                 | Cut                          | text_view                                    |
| paste-clipboard               | Paste                        | text_view                                    |
| extend-selection               | Selection extended           | text_view, granularity, location, start, end |
| insert-at-cursor              | Text inserted                | text_view, string                            |
| move-cursor                    | Cursor moved                 | text_view, step, count, extend_selection     |
| set-anchor                     | Anchor set                   | text_view                                    |
| toggle-cursor-visible          | Cursor visibility toggled    | text_view                                    |
| selection-boundary-changed     | Selection boundary changed   | text_view                                    |

---

## Containers (GtkBox, GtkGrid, etc.)

| Signal       | When it fires      | Parameters         |
| ------------ | -------------------- | ------------------ |
| add          | A child was added     | container, widget |
| remove       | A child was removed   | container, widget |
| check-resize | Size check            | container         |

---

## GtkNotebook

| Signal               | When it fires        | Parameters                         |
| --------------------- | ---------------------- | ---------------------------------- |
| switch-page          | A tab was switched      | notebook, page, page_num          |
| page-added            | A page was added        | notebook, child, page_num         |
| page-removed          | A page was removed      | notebook, child, page_num         |
| change-current-page   | A switch was requested   | notebook, offset                  |
| focus-tab             | Focus on a tab          | notebook, direction                |
| move-focus-out        | Focus moved away         | notebook, direction                |
| reorder-tab           | A tab was moved         | notebook, direction, move_to_last |
| select-page           | A page was selected     | notebook, page_num                |

---

## GtkListBox

| Signal                 | When it fires        | Parameters      |
| ------------------------ | ----------------------- | --------------- |
| row-activated           | A row was activated      | list_box, row   |
| row-selected            | A row was selected       | list_box, row   |
| selected-rows-changed   | The selection changed    | list_box        |
| child-activated         | A child was activated    | list_box, child |

---

## GtkComboBox / GtkDropDown

| Signal      | When it fires    | Parameters              |
| ------------ | ------------------ | ---------------------- |
| changed     | The selection changed | combo_box              |
| move-active | Movement            | combo_box, scroll_type |
| popdown     | The list closed     | combo_box              |
| popup       | The list opened     | combo_box              |

---

## GtkScale / GtkRange

| Signal        | When it fires         | Parameters                 |
| -------------- | ------------------------ | -------------------------- |
| adjust-bounds | The bounds changed        | range, scroll_type, value |
| change-value  | A value-change requested  | range, scroll_type, value |
| move-slider   | The slider moved          | range, scroll_type        |
| value-changed | The value changed         | range                     |

---

## GtkFileChooser

| Signal                  | When it fires             | Parameters    |
| ------------------------- | ---------------------------- | ------------ |
| file-set                | A file was chosen             | file_chooser |
| selection-changed        | The selection changed         | file_chooser |
| current-folder-changed   | The folder changed            | file_chooser |
| confirm-overwrite        | Overwrite confirmation        | file_chooser |
| update-preview           | Preview update                | file_chooser |

---

## GtkDrawingArea

| Signal | When it fires    | Parameters                   |
| ------ | ------------------ | ---------------------------- |
| resize | Size changed        | drawing_area, width, height |
| render | Drawing/rendering   | drawing_area, snapshot      |

---

## GtkDialog / GtkMessageDialog

| Signal   | When it fires   | Parameters           |
| -------- | ----------------- | ------------------- |
| response | The dialog responded | dialog, response_id |
| close    | Closing            | dialog              |

---

## GtkProgressBar

| Signal | When it fires | Parameters    |
| ------ | ---------------- | ------------ |
| pulse  | Update            | progress_bar |

---

## GtkCalendar

| Signal                      | When it fires      | Parameters |
| ----------------------------- | ---------------------- | --------- |
| day-selected                 | A day was selected      | calendar  |
| day-selected-double-click    | Double-click            | calendar  |
| month-changed                | The month changed       | calendar  |
| next-month                   | Next month              | calendar  |
| next-year                    | Next year               | calendar  |
| prev-month                   | Previous month          | calendar  |
| prev-year                    | Previous year           | calendar  |

---

## GtkStack / GtkStackSwitcher

| Signal                       | When it fires             | Parameters   |
| ------------------------------ | ---------------------------- | ------------ |
| notify::visible-child         | The visible widget changed    | stack, pspec |
| notify::visible-child-name    | The widget's name changed     | stack, pspec |

---

## Gesture signals (GtkGesture)

| Signal       | Widget                   | When it fires          |
| ------------ | ------------------------ | ---------------------- |
| pressed      | GtkGestureClick          | Press                  |
| released     | GtkGestureClick          | Release                |
| clicked      | GtkGestureClick          | Click                  |
| drag-begin   | GtkGestureDrag           | Drag started           |
| drag-update  | GtkGestureDrag           | Drag update            |
| drag-end     | GtkGestureDrag           | Drag ended             |
| swipe        | GtkGestureSwipe          | Swipe                  |
| long-pressed | GtkGestureLongPress      | Long press              |
| rotate       | GtkGestureRotate         | Rotation                |
| zoom         | GtkGestureZoom           | Zoom/scaling            |
| key-pressed  | GtkEventControllerKey    | Key pressed             |
| key-released | GtkEventControllerKey    | Key released            |
| enter        | GtkEventControllerMotion | Cursor entered           |
| leave        | GtkEventControllerMotion | Cursor left              |
| motion       | GtkEventControllerMotion | Movement                |
| scroll       | GtkEventControllerScroll | Scrolling               |

---

## Action signals (GAction)

| Signal                     | When it fires        | Parameters                          |
| --------------------------- | ------------------------ | ----------------------------------- |
| **activate**               | The action was activated  | action, parameter                  |
| **change-state**           | The state changed         | action, value                      |
| **action-added**           | An action was added       | action_group, action_name          |
| **action-removed**         | An action was removed     | action_group, action_name          |
| **action-enabled-changed** | Availability changed      | action_group, action_name, enabled |
| **action-state-changed**   | The state changed         | action_group, action_name, state   |

---

## Example of connecting signals in Nim

```nim
# Example of connecting a signal
g_signal_connect(button, "clicked", G_CALLBACK(onClick), nil)
```
