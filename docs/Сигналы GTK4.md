# Обзор сигналов GTK4

## Общая информация

В GTK4 каждый виджет может испускать **сигналы** — события, на которые можно подписываться через `g_signal_connect`. Сигналы позволяют реагировать на действия пользователя, изменения состояния и события жизненного цикла виджетов.

---

## Общие сигналы GtkWidget

| Сигнал               | Когда вызывается            | Параметры                            |
| -------------------- | --------------------------- | ------------------------------------ |
| realize              | Виджет связан с экраном     | widget                               |
| unrealize            | Виджет отключён от экрана   | widget                               |
| map                  | Виджет отображается         | widget                               |
| unmap                | Виджет скрывается           | widget                               |
| show                 | Виджет становится видимым   | widget                               |
| hide                 | Виджет скрывается           | widget                               |
| destroy              | Виджет уничтожается         | widget                               |
| size-allocate        | Изменён размер              | widget, allocation                   |
| state-flags-changed  | Изменилось состояние        | widget, flags                        |
| direction-changed    | Изменено направление текста | widget, direction                    |
| mnemonic-activate    | Активирована мнемоника      | widget, group_cycling                |
| focus                | Виджет получил фокус        | widget, direction                    |
| enter-notify         | Курсор вошёл                | widget, event                        |
| leave-notify         | Курсор вышел                | widget, event                        |
| motion-notify        | Движение курсора            | widget, event                        |
| button-press-event   | Нажата кнопка мыши          | widget, event                        |
| button-release-event | Отпущена кнопка мыши        | widget, event                        |
| scroll-event         | Прокрутка                   | widget, event                        |
| key-press-event      | Нажата клавиша              | widget, event                        |
| key-release-event    | Отпущена клавиша            | widget, event                        |
| query-tooltip        | Запрос подсказки            | widget, x, y, keyboard_mode, tooltip |

---

## GtkWindow

| Сигнал            | Когда вызывается               | Параметры     |
| ----------------- | ------------------------------ | ------------- |
| activate-focus    | Активация виджета в фокусе     | window        |
| activate-default  | Активация виджета по умолчанию | window        |
| close-request     | Запрос закрытия окна           | window        |
| notify::is-active | Окно стало активным/неактивным | window, pspec |

---

## GtkButton

| Сигнал   | Когда вызывается | Параметры |
| -------- | ---------------- | --------- |
| clicked  | Клик по кнопке   | button    |
| activate | Enter/пробел     | button    |
| pressed  | Нажатие          | button    |
| released | Отпускание       | button    |

---

## GtkCheckButton / GtkToggleButton

| Сигнал   | Когда вызывается   | Параметры     |
| -------- | ------------------ | ------------- |
| toggled  | Изменено состояние | toggle_button |
| clicked  | Клик               | button        |
| activate | Активация          | button        |

---

## GtkEntry

| Сигнал          | Когда вызывается | Параметры              |
| --------------- | ---------------- | ---------------------- |
| activate        | Enter            | entry                  |
| changed         | Изменён текст    | editable               |
| icon-press      | Клик по иконке   | entry, icon_pos, event |
| icon-release    | Отпущена иконка  | entry, icon_pos, event |
| preedit-changed | Изменён preedit  | entry                  |

---

## GtkTextView

| Сигнал                     | Когда вызывается           | Параметры                                    |
| -------------------------- | -------------------------- | -------------------------------------------- |
| backspace                  | Backspace                  | text_view                                    |
| copy-clipboard             | Копирование                | text_view                                    |
| cut-clipboard              | Вырезание                  | text_view                                    |
| paste-clipboard            | Вставка                    | text_view                                    |
| extend-selection           | Расширение выделения       | text_view, granularity, location, start, end |
| insert-at-cursor           | Вставка текста             | text_view, string                            |
| move-cursor                | Перемещение курсора        | text_view, step, count, extend_selection     |
| set-anchor                 | Установка якоря            | text_view                                    |
| toggle-cursor-visible      | Видимость курсора          | text_view                                    |
| selection-boundary-changed | Изменена граница выделения | text_view                                    |

---

## Контейнеры (GtkBox, GtkGrid и др.)

| Сигнал       | Когда вызывается  | Параметры         |
| ------------ | ----------------- | ----------------- |
| add          | Добавлен дочерний | container, widget |
| remove       | Удалён дочерний   | container, widget |
| check-resize | Проверка размера  | container         |

---

## GtkNotebook

| Сигнал              | Когда вызывается    | Параметры                         |
| ------------------- | ------------------- | --------------------------------- |
| switch-page         | Переключена вкладка | notebook, page, page_num          |
| page-added          | Добавлена страница  | notebook, child, page_num         |
| page-removed        | Удалена страница    | notebook, child, page_num         |
| change-current-page | Запрос смены        | notebook, offset                  |
| focus-tab           | Фокус на вкладке    | notebook, direction               |
| move-focus-out      | Фокус ушёл          | notebook, direction               |
| reorder-tab         | Перемещение вкладки | notebook, direction, move_to_last |
| select-page         | Выбрана страница    | notebook, page_num                |

---

## GtkListBox

| Сигнал                | Когда вызывается     | Параметры       |
| --------------------- | -------------------- | --------------- |
| row-activated         | Активирована строка  | list_box, row   |
| row-selected          | Выбрана строка       | list_box, row   |
| selected-rows-changed | Изменился выбор      | list_box        |
| child-activated       | Активирован дочерний | list_box, child |

---

## GtkComboBox / GtkDropDown

| Сигнал      | Когда вызывается | Параметры              |
| ----------- | ---------------- | ---------------------- |
| changed     | Изменён выбор    | combo_box              |
| move-active | Перемещение      | combo_box, scroll_type |
| popdown     | Закрыт список    | combo_box              |
| popup       | Открыт список    | combo_box              |

---

## GtkScale / GtkRange

| Сигнал        | Когда вызывается     | Параметры                 |
| ------------- | -------------------- | ------------------------- |
| adjust-bounds | Изменены границы     | range, scroll_type, value |
| change-value  | Запрос изменения     | range, scroll_type, value |
| move-slider   | Перемещение ползунка | range, scroll_type        |
| value-changed | Изменено значение    | range                     |

---

## GtkFileChooser

| Сигнал                 | Когда вызывается         | Параметры    |
| ---------------------- | ------------------------ | ------------ |
| file-set               | Выбран файл              | file_chooser |
| selection-changed      | Изменён выбор            | file_chooser |
| current-folder-changed | Изменена папка           | file_chooser |
| confirm-overwrite      | Подтверждение перезаписи | file_chooser |
| update-preview         | Обновление предпросмотра | file_chooser |

---

## GtkDrawingArea

| Сигнал | Когда вызывается | Параметры                   |
| ------ | ---------------- | --------------------------- |
| resize | Изменён размер   | drawing_area, width, height |
| render | Отрисовка        | drawing_area, snapshot      |

---

## GtkDialog / GtkMessageDialog

| Сигнал   | Когда вызывается | Параметры           |
| -------- | ---------------- | ------------------- |
| response | Ответ диалога    | dialog, response_id |
| close    | Закрытие         | dialog              |

---

## GtkProgressBar

| Сигнал | Когда вызывается | Параметры    |
| ------ | ---------------- | ------------ |
| pulse  | Обновление       | progress_bar |

---

## GtkCalendar

| Сигнал                    | Когда вызывается | Параметры |
| ------------------------- | ---------------- | --------- |
| day-selected              | Выбран день      | calendar  |
| day-selected-double-click | Двойной клик     | calendar  |
| month-changed             | Изменён месяц    | calendar  |
| next-month                | Следующий месяц  | calendar  |
| next-year                 | Следующий год    | calendar  |
| prev-month                | Предыдущий месяц | calendar  |
| prev-year                 | Предыдущий год   | calendar  |

---

## GtkStack / GtkStackSwitcher

| Сигнал                     | Когда вызывается       | Параметры    |
| -------------------------- | ---------------------- | ------------ |
| notify::visible-child      | Изменён видимый виджет | stack, pspec |
| notify::visible-child-name | Изменено имя виджета   | stack, pspec |

---

## Сигналы жестов (GtkGesture)

| Сигнал       | Виджет                   | Когда вызывается      |
| ------------ | ------------------------ | --------------------- |
| pressed      | GtkGestureClick          | Нажатие               |
| released     | GtkGestureClick          | Отпускание            |
| clicked      | GtkGestureClick          | Клик                  |
| drag-begin   | GtkGestureDrag           | Начало перетаскивания |
| drag-update  | GtkGestureDrag           | Обновление            |
| drag-end     | GtkGestureDrag           | Конец                 |
| swipe        | GtkGestureSwipe          | Свайп                 |
| long-pressed | GtkGestureLongPress      | Долгое нажатие        |
| rotate       | GtkGestureRotate         | Вращение              |
| zoom         | GtkGestureZoom           | Масштабирование       |
| key-pressed  | GtkEventControllerKey    | Нажата клавиша        |
| key-released | GtkEventControllerKey    | Отпущена клавиша      |
| enter        | GtkEventControllerMotion | Курсор вошёл          |
| leave        | GtkEventControllerMotion | Курсор вышел          |
| motion       | GtkEventControllerMotion | Движение              |
| scroll       | GtkEventControllerScroll | Прокрутка             |

---

## Сигналы действий (GAction)

| Сигнал                     | Когда вызывается      | Параметры                          |
| -------------------------- | --------------------- | ---------------------------------- |
| **activate**               | Активировано действие | action, parameter                  |
| **change-state**           | Изменено состояние    | action, value                      |
| **action-added**           | Добавлено действие    | action_group, action_name          |
| **action-removed**         | Удалено действие      | action_group, action_name          |
| **action-enabled-changed** | Изменена доступность  | action_group, action_name, enabled |
| **action-state-changed**   | Изменено состояние    | action_group, action_name, state   |

---

## Пример подключения сигналов в Nim

```nim
# Пример подключения сигнала
g_signal_connect(button, "clicked", G_CALLBACK(onClick), nil)
```
