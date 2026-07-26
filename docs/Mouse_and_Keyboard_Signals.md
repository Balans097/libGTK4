# Mouse and Keyboard Action Signals in GTK4

## 🖱️ Mouse signals

### Basic mouse events (GtkWidget)
| Signal | When it fires | Parameters |
|--------|------------------|-----------|
| button-press-event | Mouse button pressed | widget, event |
| button-release-event | Mouse button released | widget, event |
| enter-notify | Cursor entered the widget's area | widget, event |
| leave-notify | Cursor left the widget's area | widget, event |
| motion-notify | Cursor movement | widget, event |
| scroll-event | Mouse wheel scroll | widget, event |

---

### Mouse signals in GtkButton / ToggleButton
| Signal | When it fires | Parameters |
|--------|------------------|-----------|
| clicked | Click on the button | button |
| pressed | Button pressed | button |
| released | Button released | button |

---

### Mouse signals in GtkEntry
| Signal | When it fires | Parameters |
|--------|------------------|-----------|
| icon-press | Click on the icon | entry, icon_pos, event |
| icon-release | Icon released | entry, icon_pos, event |

---

### Mouse signals in GtkListBox
| Signal | When it fires | Parameters |
|--------|------------------|-----------|
| row-activated | A row is clicked/activated | list_box, row |
| child-activated | Click on a child element | list_box, child |

---

### Mouse signals in GtkGesture
| Signal | Widget | When it fires |
|--------|--------|------------------|
| pressed | GtkGestureClick | Button pressed |
| released | GtkGestureClick | Button released |
| clicked | GtkGestureClick | Click (press + release) |
| drag-begin | GtkGestureDrag | Drag started |
| drag-update | GtkGestureDrag | Drag update |
| drag-end | GtkGestureDrag | Drag ended |
| swipe | GtkGestureSwipe | Swipe |
| long-pressed | GtkGestureLongPress | Long press |
| rotate | GtkGestureRotate | Rotation (multi-touch) |
| zoom | GtkGestureZoom | Zoom/scaling (multi-touch) |
| enter | GtkEventControllerMotion | Cursor entered |
| leave | GtkEventControllerMotion | Cursor left |
| motion | GtkEventControllerMotion | Cursor movement |
| scroll | GtkEventControllerScroll | Scrolling |

---

## ⌨️ Keyboard signals

### Basic keyboard events (GtkWidget)
| Signal | When it fires | Parameters |
|--------|------------------|-----------|
| key-press-event | Key pressed | widget, event |
| key-release-event | Key released | widget, event |

---

### Keyboard signals in GtkEntry
| Signal | When it fires | Parameters |
|--------|------------------|-----------|
| activate | Enter pressed | entry |
| preedit-changed | Preedit text changed | entry |

---

### Keyboard signals in GtkTextView
| Signal | When it fires | Parameters |
|--------|------------------|-----------|
| backspace | Backspace pressed | text_view |
| insert-at-cursor | Text inserted | text_view, string |
| move-cursor | Cursor moved | text_view, step, count, extend_selection |

---

### Keyboard signals in GtkButton / ToggleButton
| Signal | When it fires | Parameters |
|--------|------------------|-----------|
| activate | Enter/Space pressed | button |

---

### Keyboard signals in GtkGesture
| Signal | Widget | When it fires |
|--------|--------|------------------|
| key-pressed | GtkEventControllerKey | Key pressed |
| key-released | GtkEventControllerKey | Key released |

---

## 📚 Summary list

### Mouse
- button-press-event
- button-release-event
- clicked
- pressed
- released
- enter-notify
- leave-notify
- motion-notify
- scroll-event
- drag-begin / drag-update / drag-end
- swipe
- long-pressed
- rotate
- zoom

### Keyboard
- key-press-event
- key-release-event
- activate
- backspace
- insert-at-cursor
- move-cursor
- key-pressed / key-released (Gesture)
