# GTK4 (GLib core utilities: memory / strings / timers / main loop) — module reference

> **Import:** `import libGTK4`
> **Scope:** the low-level GLib utilities that come up again and again when writing handlers and helper code throughout the rest of this reference series — C-string memory management, deferred and periodic calls, manual access to the main event loop. Thirteenth part of this wrapper reference series; assumes familiarity with `gtk4_core_reference_ru.md` (`GtkApplication`, `g_application_run`).

This reference is more compact than the others — everything here is more of an "everyday tool" that has already come up in passing in earlier references (for example, `g_timeout_add` was mentioned in the pulsing progress-indicator examples) than a distinct topical area of GTK.

---

## Table of contents

I. [Memory and strings: `g_free`, `g_malloc`, `g_strdup` and related functions](#memory-and-strings-g_free-g_malloc-g_strdup-and-related-functions)
&nbsp;&nbsp;1. [`g_free`](#g_free)
&nbsp;&nbsp;2. [`g_malloc` / `g_malloc0`](#g_malloc--g_malloc0)
&nbsp;&nbsp;3. [`g_strdup`](#g_strdup)
&nbsp;&nbsp;4. [`g_strdup_printf`](#g_strdup_printf)
&nbsp;&nbsp;5. [`g_strcmp0`](#g_strcmp0)

II. [Deferred and periodic calls](#deferred-and-periodic-calls)
&nbsp;&nbsp;1. [`g_timeout_add` / `g_timeout_add_seconds`](#g_timeout_add--g_timeout_add_seconds)
&nbsp;&nbsp;2. [`g_idle_add`](#g_idle_add)
&nbsp;&nbsp;3. [`g_source_remove`](#g_source_remove)

III. [The main loop: `g_main_loop_new` and related functions](#the-main-loop-g_main_loop_new-and-related-functions)
&nbsp;&nbsp;1. [`g_main_loop_new` / `g_main_loop_run` / `g_main_loop_quit`](#g_main_loop_new--g_main_loop_run--g_main_loop_quit)

IV. [Practical recipes](#practical-recipes)
&nbsp;&nbsp;1. [Periodically updating a clock in the UI](#periodically-updating-a-clock-in-the-ui)
&nbsp;&nbsp;2. [A one-off deferred operation](#a-one-off-deferred-operation)
&nbsp;&nbsp;3. [Offloading heavy-but-fast processing onto the main loop's "idle" moments](#offloading-heavy-but-fast-processing-onto-the-main-loops-idle-moments)
&nbsp;&nbsp;4. [Safely comparing strings where either or both may be nil](#safely-comparing-strings-where-either-or-both-may-be-nil)

V. [Quick reference table](#quick-reference-table)

VI. [Summary: which procedure to choose](#summary-which-procedure-to-choose)

---

## Memory and strings: `g_free`, `g_malloc`, `g_strdup` and related functions

The functions in this section work with memory allocated **on the C side** through the GLib allocator — that is, memory obtained from other functions in this wrapper that return a `cstring`/`pointer` allocated by GTK/GLib itself (not Nim strings/objects, which are the responsibility of Nim's garbage collector). Mixing these two worlds without understanding which one manages what is a frequent source of bugs in FFI code.

### `g_free`

```nim
proc g_free*(mem: gpointer)
```

**What it does.** Releases memory allocated by GLib/GTK functions (`g_malloc`, `g_strdup`, and many other functions in this wrapper whose documentation in the GTK header comments explicitly states that the calling code must free the returned value). Calling `g_free` on memory not allocated through the GLib allocator (for example, on an ordinary Nim string converted to a `cstring` via `$`/`.cstring`) is undefined behavior.

- **Implementation note.** Most `get_*` functions in this reference series that return a `cstring` return a pointer to memory owned by the GTK object itself (for example, `gtk_window_get_title`) — such a string does **not** need to be freed by hand; GTK does that itself when the object changes or is destroyed. Only values explicitly documented as "ownership transfers to the calling code" need to be freed by hand via `g_free` (for example, the result of `g_strdup_printf` below) — in general, for functions in this wrapper this distinction isn't reflected in the type signatures (both cases look like an ordinary `cstring`), and it needs to be checked against the documentation of the specific GTK function.

- `mem` — a pointer to memory allocated by GLib.

```nim
let duplicated = g_strdup("temporary string")
echo "The copied C string is used here"
g_free(cast[gpointer](duplicated))
echo "Memory correctly freed"
```

---

### `g_malloc` / `g_malloc0`

```nim
proc g_malloc*(nBytes: gsize): gpointer
proc g_malloc0*(nBytes: gsize): gpointer
```

**What it does.** Allocates a block of memory of the given size through the GLib allocator — needed primarily when preparing buffers to pass into C functions that expect the calling code to have already allocated memory of the required size (rather than accepting a ready-made value). `g_malloc0` additionally zeroes the allocated memory (analogous to `calloc` in plain C) — safer for structures where uninitialized fields could lead to undefined behavior on later use; `g_malloc` is faster but leaves the memory contents undefined.

- `nBytes` — the size of the block to allocate, in bytes.

```nim
let buffer = g_malloc0(256)
echo "Zeroed 256-byte buffer allocated through the GLib allocator"
# ... using buffer in a C-compatible API ...
g_free(buffer)
```

---

### `g_strdup`

```nim
proc g_strdup*(str: cstring): cstring
```

**What it does.** Creates a copy of a C string allocated through the GLib allocator — needed when a C function that a string is passed into stores the passed pointer for later use (rather than copying the contents internally itself), and the original Nim string that the `cstring` was obtained from could later be freed by Nim's garbage collector, leaving such a stored pointer dangling. The result of `g_strdup` ultimately needs to be freed via `g_free` when it's no longer needed.

- `str` — the source string to copy.

```nim
let safeCopy = g_strdup("a value that will be kept in a C structure long-term")
echo "Independent C copy of the string created"
```

---

### `g_strdup_printf`

```nim
proc g_strdup_printf*(format: cstring): cstring {.varargs.}
```

**What it does.** Builds a new string from a `printf`-style template (the same formatting logic as `gtk_message_dialog_new` from the window chrome reference — `%s` for strings, `%d` for numbers, and so on), allocating the result through the GLib allocator. Unlike Nim string interpolation (`&`, `fmt`), the result is a `cstring`, which ultimately needs to be freed via `g_free`.

- **Implementation note.** As with `gtk_message_dialog_new`, when building a string from unvalidated user data it's worth avoiding substituting the user input itself as the format template — only as an argument to a ready-made `%s` in a template defined by the application itself.

- `format` — a `printf`-style format string, followed by arguments as needed.

```nim
let message = g_strdup_printf("Processed %d of %d files", 3, 10)
echo $message
g_free(cast[gpointer](message))
```

---

### `g_strcmp0`

```nim
proc g_strcmp0*(str1: cstring, str2: cstring): gint
```

**What it does.** Compares two C strings, safely handling `nil` as either argument (plain C's ordinary `strcmp` leads to undefined behavior/a crash on a `nil` argument) — `nil` is treated as "less than" any non-`nil` string, and two `nil`s are treated as equal. Returns a negative number, `0`, or a positive number — the same semantics as standard `strcmp`. Useful when working with the results of functions in this wrapper that may return `nil` (for example, `gtk_button_get_icon_name`, if the button's content wasn't set as an icon), when such a result needs to be compared against a string without a manual `isNil` check beforehand.

- `str1`, `str2` — the strings being compared; either may be `nil`.

```nim
let iconName = gtk_button_get_icon_name(someButton)  # may return nil
if g_strcmp0(iconName, "document-save-symbolic") == 0:
  echo "This is the save button"
# the comparison is safe even if iconName turned out to be nil
```

---

## Deferred and periodic calls

GTK doesn't provide a separate timer API — periodic and deferred calls go through GLib's shared main-event-loop mechanism (`GMainLoop`, the same one that drives the whole of `g_application_run` from the core reference). The callback function for all the procedures in this section has a single common signature, `GSourceFunc`: `proc(userData: gpointer): gboolean {.cdecl.}` — the return value determines whether the call should repeat (`1.gboolean`) or whether this was the final call (`0.gboolean`).

### `g_timeout_add` / `g_timeout_add_seconds`

```nim
proc g_timeout_add*(interval: guint, function: GSourceFunc, data: gpointer): guint
proc g_timeout_add_seconds*(interval: guint, function: GSourceFunc, data: gpointer): guint
```

**What it does.** Registers a function to be called periodically (as long as the function itself keeps returning `1.gboolean`) at equal time intervals. `g_timeout_add` specifies the interval in milliseconds — more precise, but slightly more costly for the system with very frequent wake-ups. `g_timeout_add_seconds` — an interval in seconds; GLib rounds the firing moment and "aligns" it to the nearest convenient system tick on its own to save power — preferable for periodic actions that aren't time-critical (for example, updating an on-screen clock once a minute, rather than once every 60000 milliseconds down to the millisecond). Both return a `guint` identifier that can be passed to `g_source_remove` for early cancellation.

- `interval` — the period in milliseconds (for `add`) or seconds (for `add_seconds`).
- `function` — the callback function (`GSourceFunc`).
- `data` — user data passed to `function`.

```nim
proc onTick(userData: gpointer): gboolean {.cdecl.} =
  echo "Timer tick"
  result = 1.gboolean  # 1 — keep calling; 0 — stop after this call

let timerId = g_timeout_add(1000, onTick, nil)
echo "Timer with a 1-second interval started, id=", timerId
```

---

### `g_idle_add`

```nim
proc g_idle_add*(function: GSourceFunc, data: gpointer): guint
```

**What it does.** Registers a function to be called at the very next opportunity, whenever the main event loop is free of higher-priority tasks (screen redraws, handling user input) — not on a schedule, but "as soon as an idle moment appears." Useful for splitting heavy-but-fast, line-by-line processing into small steps so as not to block the UI with one long synchronous call (see section IV, "Offloading heavy-but-fast processing"), and for deferred actions that aren't critical to a specific time but only need to happen "a little later, not right now in this frame."

- `function` — the callback function (`GSourceFunc`), the same signature as `g_timeout_add`.
- `data` — user data.

```nim
proc processNextChunk(userData: gpointer): gboolean {.cdecl.} =
  echo "Next chunk of data processed"
  # result = 1.gboolean if there's more data to process; 0.gboolean if processing is done
  result = 0.gboolean

discard g_idle_add(processNextChunk, nil)
echo "Processing scheduled for the main loop's first idle moment"
```

---

### `g_source_remove`

```nim
proc g_source_remove*(tag: guint): gboolean
```

**What it does.** Cancels a previously registered timer or idle handler ahead of schedule, by its identifier (returned from `g_timeout_add`/`g_timeout_add_seconds`/`g_idle_add`) — needed when the condition for further firings stops being relevant before the handler itself would naturally have returned `0.gboolean` (for example, a window whose state was being periodically polled was closed by the user).

- `tag` — the timer/idle handler identifier.

```nim
g_source_remove(timerId)
echo "Timer cancelled ahead of schedule"
```

---

## The main loop: `g_main_loop_new` and related functions

`GMainLoop` — the low-level main-event-loop object, the same mechanism hidden inside `g_application_run` from the core reference. Manually creating and running a `GMainLoop` directly is rarely needed — `GtkApplication`/`g_application_run` is almost always sufficient; explicit use is appropriate for console utilities or background processes that use GLib's asynchronous operations (timers, reading from streams) but don't show any GTK interface at all.

### `g_main_loop_new` / `g_main_loop_run` / `g_main_loop_quit`

```nim
proc g_main_loop_new*(context: pointer, isRunning: gboolean): pointer
proc g_main_loop_run*(loop: pointer)
proc g_main_loop_quit*(loop: pointer)
```

**What it does.** `g_main_loop_new` creates the main-loop object — `context` is almost always passed as `nil` (use the default context); `isRunning` is a legacy parameter, usually `0.gboolean`. `g_main_loop_run` starts the loop and blocks execution (similar to `g_application_run`) until `g_main_loop_quit` is called — from a timer/idle/signal handler, since `run` itself blocks the thread that called it.

- `context` — the main-loop context, usually `nil`.
- `isRunning` — a legacy parameter, usually `0.gboolean`.
- `loop` — the main-loop object.

```nim
let loop = g_main_loop_new(nil, 0.gboolean)

proc onDone(userData: gpointer): gboolean {.cdecl.} =
  echo "Background task finished, stopping the loop"
  g_main_loop_quit(cast[pointer](userData))
  result = 0.gboolean

discard g_timeout_add(5000, onDone, loop)
g_main_loop_run(loop)  # blocks execution for 5 seconds, then finishes
echo "Main loop finished"
```

---

## Practical recipes

### Periodically updating a clock in the UI

A label showing the current time, updated once a second.

```nim
import times

proc onClockTick(userData: gpointer): gboolean {.cdecl.} =
  let clockLabel = cast[GtkLabel](userData)
  gtk_label_set_text(clockLabel, now().format("HH:mm:ss").cstring)
  result = 1.gboolean

proc startClock(clockLabel: GtkLabel): guint =
  result = g_timeout_add(1000, onClockTick, cast[gpointer](clockLabel))
  echo "Clock started, updating once a second"

let clockLabel = gtk_label_new("")
let clockTimerId = startClock(clockLabel)
# g_source_remove(clockTimerId) — when the window is closed, if the clock is no longer needed
```

---

### A one-off deferred operation

Showing a hint 2 seconds after the application starts, with no periodic repetition.

```nim
proc showDelayedHint(userData: gpointer): gboolean {.cdecl.} =
  echo "Showing the hint 2 seconds after startup"
  result = 0.gboolean

discard g_timeout_add(2000, showDelayedHint, nil)
```

---

### Offloading heavy-but-fast processing onto the main loop's "idle" moments

Processing a large list of items in small chunks, so as not to block the UI with one long synchronous call.

```nim
var itemsToProcess: seq[string] = @["item1", "item2", "item3", "item4", "item5"]
var processedCount = 0

proc processOneItem(userData: gpointer): gboolean {.cdecl.} =
  if processedCount < itemsToProcess.len:
    echo "Processed item: ", itemsToProcess[processedCount]
    processedCount += 1
    result = 1.gboolean
  else:
    echo "Processing of all items finished"
    result = 0.gboolean

discard g_idle_add(processOneItem, nil)
echo "List processing started, one item per idle-loop moment"
```

---

### Safely comparing strings where either or both may be nil

A typical pattern when working with the results of GTK `get_*` functions that may return `nil`.

```nim
proc isSaveIcon(button: GtkButton): bool =
  let iconName = gtk_button_get_icon_name(button)
  result = g_strcmp0(iconName, "document-save-symbolic") == 0

echo "This is the save button: ", isSaveIcon(someButton)
```

---

## Quick reference table

| Procedure(s) | Category | What it does in brief |
|---|---|---|
| `g_free` | Memory | Free memory allocated by GLib |
| `g_malloc`, `g_malloc0` | Memory | Allocate a block of memory (plain / zeroed) |
| `g_strdup` | Strings | An independent copy of a string via the GLib allocator |
| `g_strdup_printf` | Strings | printf-style string formatting |
| `g_strcmp0` | Strings | String comparison, safe with nil |
| `g_timeout_add`, `g_timeout_add_seconds` | Timers | Periodic call at equal time intervals |
| `g_idle_add` | Timers | Call at the main loop's next idle moment |
| `g_source_remove` | Timers | Early cancellation of a timer/idle handler |
| `g_main_loop_new`, `run`, `quit` | Main loop | Low-level creation and running of the event loop |

---

## Summary: which procedure to choose

- **A regular action with a clear time interval** → `g_timeout_add`/`g_timeout_add_seconds` — the seconds variant is preferable for periodic actions that aren't time-precise.
- **An action needs to happen "as soon as possible, but without blocking the UI right now"** → `g_idle_add`, not `g_timeout_add` with an interval of `0`.
- **A timer/idle handler might need to be cancelled ahead of time** → save the identifier and call `g_source_remove`.
- **A string from a GTK function that may return `nil` is being compared to another string** → `g_strcmp0`, not an ordinary Nim comparison, which would crash on `nil`.
- **A C string/buffer needs to outlive the original Nim string** → `g_strdup`/`g_malloc`, with a mandatory `g_free` afterward.
- **A console utility with no GTK interface** → `g_main_loop_new`/`run`/`quit` directly. **There's at least one GTK window** → `GtkApplication`/`g_application_run` — no need to create a `GMainLoop` separately.
