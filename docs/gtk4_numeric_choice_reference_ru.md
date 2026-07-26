# GTK4 (numeric & choice controls: Adjustment / SpinButton / Scale / ComboBoxText) — справочник модуля

> **Импорт:** `import libGTK4`
> **Область применения:** ввод и отображение числовых значений (счётчик, ползунок) и выбор одного варианта из выпадающего списка. Шестая часть серии справочников по обёртке; предполагает знакомство с предыдущими частями, особенно с `gtk4_core_reference_ru.md` (компоновка, `GtkWidget`).

Ключевая особенность этого раздела: `GtkSpinButton` и `GtkScale` не хранят своё числовое значение, диапазон и шаг самостоятельно — за это отвечает общий для обоих объект `GtkAdjustment` ("настройка диапазона"), который можно либо создать отдельно и передать сразу двум виджетам (тогда они автоматически синхронизируют своё значение друг с другом — типичный паттерн "ползунок + поле с точным числом рядом"), либо позволить виджету создать свой `GtkAdjustment` неявно через укороченный конструктор. Поэтому справочник начинается с `GtkAdjustment`, как в своё время `GtkEditable` предшествовал `GtkEntry`.

---

## Оглавление

I. [GtkAdjustment](#gtkadjustment)
&nbsp;&nbsp;1. [`gtk_adjustment_new`](#gtk_adjustment_new)
&nbsp;&nbsp;2. [`gtk_adjustment_set_value` / `gtk_adjustment_get_value`](#gtk_adjustment_set_value--gtk_adjustment_get_value)
&nbsp;&nbsp;3. [`gtk_adjustment_set_lower` / `gtk_adjustment_get_lower` / `gtk_adjustment_set_upper` / `gtk_adjustment_get_upper`](#gtk_adjustment_set_lower--gtk_adjustment_get_lower--gtk_adjustment_set_upper--gtk_adjustment_get_upper)

II. [GtkSpinButton](#gtkspinbutton)
&nbsp;&nbsp;1. [`gtk_spin_button_new` / `gtk_spin_button_new_with_range`](#gtk_spin_button_new--gtk_spin_button_new_with_range)
&nbsp;&nbsp;2. [`gtk_spin_button_set_adjustment` / `gtk_spin_button_get_adjustment`](#gtk_spin_button_set_adjustment--gtk_spin_button_get_adjustment)
&nbsp;&nbsp;3. [`gtk_spin_button_set_digits` / `gtk_spin_button_get_digits`](#gtk_spin_button_set_digits--gtk_spin_button_get_digits)
&nbsp;&nbsp;4. [`gtk_spin_button_set_value` / `gtk_spin_button_get_value` / `gtk_spin_button_get_value_as_int`](#gtk_spin_button_set_value--gtk_spin_button_get_value--gtk_spin_button_get_value_as_int)
&nbsp;&nbsp;5. [`gtk_spin_button_set_range` / `gtk_spin_button_get_range`](#gtk_spin_button_set_range--gtk_spin_button_get_range)

III. [GtkScale (и GtkRange)](#gtkscale-и-gtkrange)
&nbsp;&nbsp;1. [`gtk_scale_new` / `gtk_scale_new_with_range`](#gtk_scale_new--gtk_scale_new_with_range)
&nbsp;&nbsp;2. [`gtk_scale_set_digits` / `gtk_scale_get_digits`](#gtk_scale_set_digits--gtk_scale_get_digits)
&nbsp;&nbsp;3. [`gtk_scale_set_draw_value` / `gtk_scale_get_draw_value`](#gtk_scale_set_draw_value--gtk_scale_get_draw_value)
&nbsp;&nbsp;4. [`gtk_scale_set_value_pos` / `gtk_scale_get_value_pos`](#gtk_scale_set_value_pos--gtk_scale_get_value_pos)
&nbsp;&nbsp;5. [`gtk_range_set_value`](#gtk_range_set_value)

IV. [GtkComboBoxText (и GtkComboBox)](#gtkcomboboxtext-и-gtkcombobox)
&nbsp;&nbsp;1. [`gtk_combo_box_text_new` / `gtk_combo_box_text_new_with_entry`](#gtk_combo_box_text_new--gtk_combo_box_text_new_with_entry)
&nbsp;&nbsp;2. [`gtk_combo_box_text_append` / `gtk_combo_box_text_prepend` / `gtk_combo_box_text_insert`](#gtk_combo_box_text_append--gtk_combo_box_text_prepend--gtk_combo_box_text_insert)
&nbsp;&nbsp;3. [`gtk_combo_box_text_append_text` / `gtk_combo_box_text_prepend_text` / `gtk_combo_box_text_insert_text`](#gtk_combo_box_text_append_text--gtk_combo_box_text_prepend_text--gtk_combo_box_text_insert_text)
&nbsp;&nbsp;4. [`gtk_combo_box_text_remove` / `gtk_combo_box_text_remove_all`](#gtk_combo_box_text_remove--gtk_combo_box_text_remove_all)
&nbsp;&nbsp;5. [`gtk_combo_box_text_get_active_text`](#gtk_combo_box_text_get_active_text)
&nbsp;&nbsp;6. [`gtk_combo_box_set_active` / `gtk_combo_box_get_active`](#gtk_combo_box_set_active--gtk_combo_box_get_active)
&nbsp;&nbsp;7. [`gtk_combo_box_set_active_id` / `gtk_combo_box_get_active_id`](#gtk_combo_box_set_active_id--gtk_combo_box_get_active_id)

V. [Практические рецепты](#практические-рецепты)
&nbsp;&nbsp;1. [Числовое поле с ползунком, разделяющие один Adjustment](#числовое-поле-с-ползунком-разделяющие-один-adjustment)
&nbsp;&nbsp;2. [Счётчик количества товара с ограниченным диапазоном](#счётчик-количества-товара-с-ограниченным-диапазоном)
&nbsp;&nbsp;3. [Выпадающий список стран с id и читаемым текстом](#выпадающий-список-стран-с-id-и-читаемым-текстом)
&nbsp;&nbsp;4. [Ползунок громкости без числового значения на глаз](#ползунок-громкости-без-числового-значения-на-глаз)
&nbsp;&nbsp;5. [Комбо-бокс с возможностью ввести свой вариант](#комбо-бокс-с-возможностью-ввести-свой-вариант)

VI. [Краткая таблица](#краткая-таблица)

VII. [Сводка: какую процедуру выбрать](#сводка-какую-процедуру-выбрать)

---

## GtkAdjustment

`GtkAdjustment` — не виджет, а объект данных: текущее значение, нижняя и верхняя граница, шаг прокрутки, размер "страницы". Используется как общая модель для `GtkSpinButton`, `GtkScale` и (за пределами этого справочника) полос прокрутки. Эта обёртка предоставляет доступ только к базовым свойствам (`value`, `lower`, `upper`) — параметры шага (`step_increment`, `page_increment`, `page_size`), задаваемые в конструкторе, отдельных геттеров/сеттеров в этой версии обёртки не имеют и настраиваются только при создании через `gtk_adjustment_new`.

### `gtk_adjustment_new`

```nim
proc gtk_adjustment_new*(value: gdouble, lower: gdouble, upper: gdouble, stepIncrement: gdouble, pageIncrement: gdouble, pageSize: gdouble): GtkAdjustment
```

**Что делает.** Создаёт объект настройки диапазона со всеми параметрами сразу. `value` — начальное значение, `lower`/`upper` — границы диапазона. `stepIncrement` — на сколько сдвигается значение при нажатии стрелок `GtkSpinButton` или клавиш со стрелками на `GtkScale`. `pageIncrement` — на сколько сдвигается значение при клике по области ползунка вне самого бегунка (аналог `PageUp`/`PageDown`). `pageSize` имеет смысл в первую очередь для полос прокрутки (доля видимой области от общего размера содержимого) — для `GtkSpinButton`/`GtkScale` обычно передаётся `0.0`.

- `value` — начальное значение (должно быть в пределах `[lower, upper]`).
- `lower`, `upper` — границы диапазона.
- `stepIncrement` — шаг при пошаговом изменении (стрелки, клавиатура).
- `pageIncrement` — шаг при "постраничном" изменении.
- `pageSize` — размер видимой страницы (для `SpinButton`/`Scale` обычно `0.0`).

```nim
let quantityAdjustment = gtk_adjustment_new(1.0, 1.0, 99.0, 1.0, 5.0, 0.0)
echo "Adjustment для количества товара создан: диапазон 1–99, шаг 1"
```

---

### `gtk_adjustment_set_value` / `gtk_adjustment_get_value`

```nim
proc gtk_adjustment_set_value*(adjustment: GtkAdjustment, value: gdouble)
proc gtk_adjustment_get_value*(adjustment: GtkAdjustment): gdouble
```

**Что делает.** Устанавливают и читают текущее значение напрямую через объект `GtkAdjustment`, минуя привязанные к нему виджеты. Поскольку `GtkSpinButton`/`GtkScale`, использующие один и тот же `GtkAdjustment`, подписаны на его изменения, вызов `set_value` на самом adjustment обновит **все** виджеты, которые с ним связаны, — это и есть механизм их автоматической синхронизации друг с другом.

- `adjustment` — объект настройки диапазона.
- `value` — новое значение.

```nim
gtk_adjustment_set_value(quantityAdjustment, 5.0)
echo "Текущее значение: ", gtk_adjustment_get_value(quantityAdjustment)
# все виджеты, использующие quantityAdjustment, сразу отражают новое значение
```

---

### `gtk_adjustment_set_lower` / `gtk_adjustment_get_lower` / `gtk_adjustment_set_upper` / `gtk_adjustment_get_upper`

```nim
proc gtk_adjustment_set_lower*(adjustment: GtkAdjustment, lower: gdouble)
proc gtk_adjustment_get_lower*(adjustment: GtkAdjustment): gdouble
proc gtk_adjustment_set_upper*(adjustment: GtkAdjustment, upper: gdouble)
proc gtk_adjustment_get_upper*(adjustment: GtkAdjustment): gdouble
```

**Что делает.** Изменяют границы диапазона уже после создания — например, когда допустимый максимум количества товара зависит от остатка на складе, вычисляемого динамически, а не является константой на момент создания adjustment. Если текущее значение (`value`) оказывается за пределами нового диапазона после изменения границы, GTK автоматически подтягивает его к ближайшей допустимой границе.

- `adjustment` — объект настройки диапазона.
- `lower`, `upper` — новая граница.

```nim
gtk_adjustment_set_upper(quantityAdjustment, 12.0)  # на складе осталось только 12 штук
echo "Новый максимум количества: ", gtk_adjustment_get_upper(quantityAdjustment)
```

---

## GtkSpinButton

`GtkSpinButton` — поле числового ввода со стрелками вверх/вниз для пошагового изменения значения. Внутренне это `GtkEntry`, дополненный числовой логикой, — но управление самим текстом (например, `gtk_editable_set_width_chars` из справочника по вводу текста) у него доступно наравне с числовыми функциями этого раздела.

### `gtk_spin_button_new` / `gtk_spin_button_new_with_range`

```nim
proc gtk_spin_button_new*(adjustment: GtkAdjustment, climbRate: gdouble, digits: guint): GtkSpinButton
proc gtk_spin_button_new_with_range*(min: gdouble, max: gdouble, step: gdouble): GtkSpinButton
```

**Что делает.** Два способа создать числовое поле. `gtk_spin_button_new` принимает уже готовый `GtkAdjustment` (раздел I) — используется, когда несколько виджетов должны разделять один и тот же диапазон/значение, либо когда нужен полный контроль над `pageIncrement`/`pageSize`. `climbRate` — коэффициент ускорения: при удержании стрелки нажатой шаг изменения постепенно увеличивается пропорционально этому значению (`0.0` отключает ускорение — шаг всегда равен `stepIncrement` adjustment'а). `gtk_spin_button_new_with_range` — укороченная форма для самого частого случая: создаёт свой `GtkAdjustment` неявно, сразу с границами и шагом, без ускорения и без явного управления количеством знаков (оно устанавливается по количеству знаков после запятой в `step`).

- `adjustment` — объект настройки диапазона (для полной формы).
- `climbRate` — коэффициент ускорения при удержании стрелки.
- `digits` — число знаков после запятой при отображении.
- `min`, `max`, `step` — границы и шаг (для укороченной формы).

```nim
let quantitySpin = gtk_spin_button_new_with_range(1.0, 99.0, 1.0)
echo "Числовое поле количества создано: от 1 до 99, шаг 1"

let priceSpin = gtk_spin_button_new(priceAdjustment, 1.0, 2)  # с ускорением, 2 знака после запятой
```

---

### `gtk_spin_button_set_adjustment` / `gtk_spin_button_get_adjustment`

```nim
proc gtk_spin_button_set_adjustment*(spinButton: GtkSpinButton, adjustment: GtkAdjustment)
proc gtk_spin_button_get_adjustment*(spinButton: GtkSpinButton): GtkAdjustment
```

**Что делает.** Заменяют `GtkAdjustment` уже существующего поля на другой (например, чтобы связать поле с новым диапазоном при переключении контекста — счётчик страниц документа поменялся вместе с открытием другого файла), либо получают текущий adjustment, чтобы связать с ним ещё один виджет (типично — `GtkScale`, см. раздел V, «Числовое поле с ползунком»).

- `spinButton` — числовое поле.
- `adjustment` — новый объект настройки диапазона.

```nim
let sharedAdjustment = gtk_spin_button_get_adjustment(quantitySpin)
echo "Adjustment получен, его можно передать в gtk_scale_new для связанного ползунка"
```

---

### `gtk_spin_button_set_digits` / `gtk_spin_button_get_digits`

```nim
proc gtk_spin_button_set_digits*(spinButton: GtkSpinButton, digits: guint)
proc gtk_spin_button_get_digits*(spinButton: GtkSpinButton): guint
```

**Что делает.** Задают количество знаков после запятой, показываемых в поле, — `0` для целых чисел, `2` для денежных сумм и т.п. Это чисто отображаемая настройка: внутреннее значение `GtkAdjustment` всегда хранится как `gdouble` полной точности, `digits` влияет только на то, сколько знаков видно и вводимо в самом текстовом представлении поля.

- `spinButton` — числовое поле.
- `digits` — количество знаков после запятой.

```nim
gtk_spin_button_set_digits(priceSpin, 2)
echo "Поле цены показывает ", gtk_spin_button_get_digits(priceSpin), " знака после запятой"
```

---

### `gtk_spin_button_set_value` / `gtk_spin_button_get_value` / `gtk_spin_button_get_value_as_int`

```nim
proc gtk_spin_button_set_value*(spinButton: GtkSpinButton, value: gdouble)
proc gtk_spin_button_get_value*(spinButton: GtkSpinButton): gdouble
proc gtk_spin_button_get_value_as_int*(spinButton: GtkSpinButton): gint
```

**Что делает.** Устанавливают и читают текущее значение поля. `get_value_as_int` — удобный короткий путь для полей, изначально предназначенных для целых чисел (`digits = 0`) — экономит явное приведение `gint(gtk_spin_button_get_value(...))`; отдельного сеттера для целочисленного значения нет, только `set_value` с `gdouble`.

- `spinButton` — числовое поле.
- `value` — новое значение.

```nim
gtk_spin_button_set_value(quantitySpin, 3.0)
echo "Выбрано количество: ", gtk_spin_button_get_value_as_int(quantitySpin)
```

---

### `gtk_spin_button_set_range` / `gtk_spin_button_get_range`

```nim
proc gtk_spin_button_set_range*(spinButton: GtkSpinButton, min: gdouble, max: gdouble)
proc gtk_spin_button_get_range*(spinButton: GtkSpinButton, min: ptr gdouble, max: ptr gdouble)
```

**Что делает.** Короткая форма для изменения границ диапазона поля напрямую, без обращения к его `GtkAdjustment` через `gtk_adjustment_set_lower`/`set_upper` — под капотом делает ровно то же самое (изменяет `lower`/`upper` связанного adjustment'а), но за один вызов и без необходимости сначала получать сам объект `GtkAdjustment`.

- `spinButton` — числовое поле.
- `min`, `max` — новые границы (для `get_range` — указатели, куда будут записаны текущие границы).

```nim
gtk_spin_button_set_range(quantitySpin, 1.0, 12.0)  # на складе осталось 12 штук
var currentMin, currentMax: gdouble
gtk_spin_button_get_range(quantitySpin, addr currentMin, addr currentMax)
echo "Диапазон количества теперь: от ", currentMin, " до ", currentMax
```

---

## GtkScale (и GtkRange)

`GtkScale` — ползунок для выбора значения в диапазоне перетаскиванием бегунка. `GtkRange` — общий базовый класс для `GtkScale` и полос прокрутки; в этой обёртке из него доступна только одна функция напрямую (`gtk_range_set_value`), но принимающая любой из этих виджетов.

### `gtk_scale_new` / `gtk_scale_new_with_range`

```nim
proc gtk_scale_new*(orientation: GtkOrientation, adjustment: GtkAdjustment): GtkScale
proc gtk_scale_new_with_range*(orientation: GtkOrientation, min: gdouble, max: gdouble, step: gdouble): GtkScale
```

**Что делает.** Та же логика выбора между полной и укороченной формой, что у `gtk_spin_button_new`/`_with_range`: полная форма принимает готовый `GtkAdjustment` (нужна, чтобы связать ползунок с другим виджетом через общий adjustment — см. раздел V, «Числовое поле с ползунком»), укороченная создаёт adjustment неявно из границ и шага.

- `orientation` — `GTK_ORIENTATION_HORIZONTAL` или `GTK_ORIENTATION_VERTICAL`.
- `adjustment` — объект настройки диапазона (для полной формы).
- `min`, `max`, `step` — границы и шаг (для укороченной формы).

```nim
let volumeScale = gtk_scale_new_with_range(GTK_ORIENTATION_HORIZONTAL, 0.0, 100.0, 1.0)
echo "Горизонтальный ползунок громкости создан: от 0 до 100"
```

---

### `gtk_scale_set_digits` / `gtk_scale_get_digits`

```nim
proc gtk_scale_set_digits*(scale: GtkScale, digits: gint)
proc gtk_scale_get_digits*(scale: GtkScale): gint
```

**Что делает.** Задают количество знаков после запятой в числе, показываемом рядом с ползунком, — та же логика, что у `gtk_spin_button_set_digits`, но применяется только при включённом `gtk_scale_set_draw_value` (следующий подраздел): если значение не отображается вовсе, `digits` ни на что не влияет.

- `scale` — ползунок.
- `digits` — количество знаков после запятой.

```nim
gtk_scale_set_digits(volumeScale, 0)  # громкость — целое число, без дробной части
echo "Ползунок громкости показывает целые значения"
```

---

### `gtk_scale_set_draw_value` / `gtk_scale_get_draw_value`

```nim
proc gtk_scale_set_draw_value*(scale: GtkScale, drawValue: gboolean)
proc gtk_scale_get_draw_value*(scale: GtkScale): gboolean
```

**Что делает.** Показывают/скрывают текущее числовое значение рядом с бегунком ползунка. По умолчанию значение не показано — только сам ползунок; включение полезно, когда точное число важно пользователю (например, процент громкости), а не только относительное положение.

- `scale` — ползунок.
- `drawValue` — `1.gboolean`, чтобы показывать значение.

```nim
gtk_scale_set_draw_value(volumeScale, 1.gboolean)
echo "Числовое значение громкости теперь отображается рядом с ползунком"
```

---

### `gtk_scale_set_value_pos` / `gtk_scale_get_value_pos`

```nim
proc gtk_scale_set_value_pos*(scale: GtkScale, pos: GtkPositionType)
proc gtk_scale_get_value_pos*(scale: GtkScale): GtkPositionType
```

**Что делает.** Задают, с какой стороны от ползунка показывается числовое значение (при включённом `draw_value`) — `GTK_POS_LEFT`, `_RIGHT`, `_TOP`, `_BOTTOM`.

- `scale` — ползунок.
- `pos` — значение `GtkPositionType`.

```nim
gtk_scale_set_value_pos(volumeScale, GTK_POS_RIGHT)
echo "Значение громкости показывается справа от ползунка"
```

---

### `gtk_range_set_value`

```nim
proc gtk_range_set_value*(range: GtkRange, value: cdouble)
```

**Что делает.** Устанавливает текущее значение — та же операция, что `gtk_adjustment_set_value` на связанном adjustment'е, но вызывается напрямую на самом виджете (`GtkScale` передаётся как `GtkRange` без явного приведения типов, поскольку в этой обёртке оба — `pointer`). Отдельного геттера `gtk_range_get_value` в этой версии обёртки нет — для чтения текущего значения используйте `gtk_adjustment_get_value` на объекте, полученном через `gtk_spin_button_get_adjustment`, либо храните adjustment в переменной при создании ползунка через полную форму `gtk_scale_new`.

- `range` — ползунок (`GtkScale`) или другой наследник `GtkRange`.
- `value` — новое значение.

```nim
gtk_range_set_value(volumeScale, 75.0)
echo "Громкость установлена программно на 75"
```

---

## GtkComboBoxText (и GtkComboBox)

`GtkComboBoxText` — выпадающий список для выбора одного варианта из нескольких, где каждый вариант — простая строка текста (для более сложных случаев — с иконками, произвольной моделью данных — используется более общий `GtkComboBox` с `GtkTreeModel`, не входящий в этот справочник). `GtkComboBoxText` — подтип `GtkComboBox`, поэтому часть функций управления текущим выбором объявлена на уровне `GtkComboBox` и работает одинаково для обоих.

### `gtk_combo_box_text_new` / `gtk_combo_box_text_new_with_entry`

```nim
proc gtk_combo_box_text_new*(): GtkComboBoxText
proc gtk_combo_box_text_new_with_entry*(): GtkComboBoxText
```

**Что делает.** Создают пустой выпадающий список. `gtk_combo_box_text_new_with_entry` дополнительно даёт пользователю возможность ввести собственный текст, не ограничиваясь предложенными вариантами (комбинация выпадающего списка с текстовым полем — работа с введённым вручную текстом идёт через интерфейс `GtkEditable`, справочник по вводу текста, применённый к самому комбо-боксу).

- Параметров нет.

```nim
let countryCombo = gtk_combo_box_text_new()
let tagsCombo = gtk_combo_box_text_new_with_entry()
echo "Обычный выпадающий список и список с возможностью ввода своего варианта созданы"
```

---

### `gtk_combo_box_text_append` / `gtk_combo_box_text_prepend` / `gtk_combo_box_text_insert`

```nim
proc gtk_combo_box_text_append*(comboBox: GtkComboBoxText, id: cstring, text: cstring)
proc gtk_combo_box_text_prepend*(comboBox: GtkComboBoxText, id: cstring, text: cstring)
proc gtk_combo_box_text_insert*(comboBox: GtkComboBoxText, position: gint, id: cstring, text: cstring)
```

**Что делает.** Добавляют вариант в конец, в начало, или в произвольную позицию списка — с двумя строками сразу: `text` — то, что видит пользователь, `id` — стабильный технический идентификатор варианта (например, код страны `"RU"` при видимом тексте `"Россия"`), не зависящий от порядка элементов в списке или от локализации видимого текста. Именно `id`, а не числовой индекс позиции, рекомендуется использовать для хранения выбора между запусками приложения (индекс "поплывёт", если список вариантов позже изменится, `id` — нет). Передача `nil` вместо `id` допустима, если стабильный идентификатор не нужен, — тогда обращаться к варианту можно только по индексу через `gtk_combo_box_set/get_active`.

- `comboBox` — выпадающий список.
- `id` — стабильный идентификатор варианта, либо `nil`.
- `text` — видимый пользователю текст.
- `position` (для `insert`) — индекс вставки.

```nim
gtk_combo_box_text_append(countryCombo, "RU", "Россия")
gtk_combo_box_text_append(countryCombo, "DE", "Германия")
gtk_combo_box_text_append(countryCombo, "FR", "Франция")
echo "Три страны добавлены в выпадающий список"
```

---

### `gtk_combo_box_text_append_text` / `gtk_combo_box_text_prepend_text` / `gtk_combo_box_text_insert_text`

```nim
proc gtk_combo_box_text_append_text*(comboBox: GtkComboBoxText, text: cstring)
proc gtk_combo_box_text_prepend_text*(comboBox: GtkComboBoxText, text: cstring)
proc gtk_combo_box_text_insert_text*(comboBox: GtkComboBoxText, position: gint, text: cstring)
```

**Что делает.** Упрощённые варианты предыдущих трёх функций — без `id` вообще, только видимый текст (внутренне эквивалентно вызову с `id = nil`). Уместны, когда список вариантов и так однозначно идентифицируется своим текстом или позицией и отдельный технический идентификатор не нужен.

- `comboBox` — выпадающий список.
- `text` — видимый пользователю текст.
- `position` (для `insert_text`) — индекс вставки.

```nim
let sortOrderCombo = gtk_combo_box_text_new()
gtk_combo_box_text_append_text(sortOrderCombo, "По имени")
gtk_combo_box_text_append_text(sortOrderCombo, "По дате")
gtk_combo_box_text_append_text(sortOrderCombo, "По размеру")
echo "Варианты сортировки добавлены без отдельных технических идентификаторов"
```

---

### `gtk_combo_box_text_remove` / `gtk_combo_box_text_remove_all`

```nim
proc gtk_combo_box_text_remove*(comboBox: GtkComboBoxText, position: gint)
proc gtk_combo_box_text_remove_all*(comboBox: GtkComboBoxText)
```

**Что делает.** Удаляют один вариант по индексу позиции или очищают список полностью — например, перед повторным заполнением списка новыми данными (загруженными асинхронно после первоначального создания пустого комбо-бокса).

- `comboBox` — выпадающий список.
- `position` (для `remove`) — индекс удаляемого варианта.

```nim
gtk_combo_box_text_remove_all(countryCombo)
echo "Список стран очищен перед повторным заполнением"
```

---

### `gtk_combo_box_text_get_active_text`

```nim
proc gtk_combo_box_text_get_active_text*(comboBox: GtkComboBoxText): cstring
```

**Что делает.** Возвращает видимый текст текущего выбранного варианта. Если выбор пуст (ничего не выбрано — актуально сразу после создания списка, до первого выбора пользователем или программной установки), возвращает `nil`. Для комбо-бокса с полем ввода (`gtk_combo_box_text_new_with_entry`) при отсутствии выбора из готового списка возвращает именно текст, введённый пользователем вручную, — то есть эта функция покрывает оба случая единообразно.

- `comboBox` — выпадающий список.

```nim
let selectedCountryText = gtk_combo_box_text_get_active_text(countryCombo)
if not isNil(selectedCountryText):
  echo "Выбрана страна: ", $selectedCountryText
else:
  echo "Страна ещё не выбрана"
```

---

### `gtk_combo_box_set_active` / `gtk_combo_box_get_active`

```nim
proc gtk_combo_box_set_active*(comboBox: GtkComboBox, index: gint)
proc gtk_combo_box_get_active*(comboBox: GtkComboBox): gint
```

**Что делает.** Устанавливают и читают текущий выбор по числовому индексу позиции в списке (начиная с `0`). `-1` означает "ничего не выбрано". Эти функции объявлены на уровне базового `GtkComboBox`, но применимы напрямую и к `GtkComboBoxText`.

- `comboBox` — выпадающий список (`GtkComboBoxText` передаётся напрямую).
- `index` — индекс варианта, либо `-1`, чтобы снять выбор.

```nim
gtk_combo_box_set_active(countryCombo, 0)  # выбрать первый вариант по умолчанию
echo "Выбран вариант с индексом: ", gtk_combo_box_get_active(countryCombo)
```

---

### `gtk_combo_box_set_active_id` / `gtk_combo_box_get_active_id`

```nim
proc gtk_combo_box_set_active_id*(comboBox: GtkComboBox, activeId: cstring): gboolean
proc gtk_combo_box_get_active_id*(comboBox: GtkComboBox): cstring
```

**Что делает.** То же самое, что `set_active`/`get_active`, но по стабильному `id`, заданному при добавлении варианта через `gtk_combo_box_text_append`/`prepend`/`insert` (не короткими `_text`-вариантами без `id` — для них `set_active_id` работать не будет, так как `id` не был задан). `set_active_id` возвращает `gboolean`, сообщающий, был ли найден и установлен вариант с таким `id` (`0.gboolean`, если варианта с указанным `id` в списке нет — например, потому что список ещё не заполнен). Это предпочтительный способ восстановить сохранённый ранее выбор (например, из настроек приложения) — устойчив к изменению порядка или состава остальных вариантов списка, в отличие от индекса.

- `comboBox` — выпадающий список.
- `activeId` — стабильный идентификатор варианта.

```nim
let savedCountryId = "DE"  # сохранённое ранее значение, например, из файла настроек
if gtk_combo_box_set_active_id(countryCombo, savedCountryId.cstring) == 0.gboolean:
  echo "Сохранённая страна не найдена в текущем списке — оставляем выбор пустым"
else:
  echo "Восстановлен сохранённый выбор: ", $gtk_combo_box_get_active_id(countryCombo)
```

---

## Практические рецепты

### Числовое поле с ползунком, разделяющие один Adjustment

Классическая связка "поле с точным числом + ползунок рядом" — оба виджета автоматически синхронизируются, так как используют один и тот же `GtkAdjustment`.

```nim
proc buildVolumeControl(): GtkBox =
  result = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 8)

  let volumeAdjustment = gtk_adjustment_new(50.0, 0.0, 100.0, 1.0, 10.0, 0.0)

  let volumeScale = gtk_scale_new(GTK_ORIENTATION_HORIZONTAL, volumeAdjustment)
  gtk_widget_set_hexpand(volumeScale, 1.gboolean)

  let volumeSpin = gtk_spin_button_new(volumeAdjustment, 1.0, 0)

  gtk_box_append(result, volumeScale)
  gtk_box_append(result, volumeSpin)
  echo "Ползунок и числовое поле громкости связаны одним Adjustment — изменение одного сразу отражается в другом"

let volumeControl = buildVolumeControl()
```

---

### Счётчик количества товара с ограниченным диапазоном

Простой `GtkSpinButton` для выбора количества единиц товара, с укороченной формой конструктора и без десятичных знаков.

```nim
proc buildQuantitySpin(maxAvailable: int): GtkSpinButton =
  result = gtk_spin_button_new_with_range(1.0, maxAvailable.float, 1.0)
  gtk_spin_button_set_digits(result, 0)
  gtk_spin_button_set_value(result, 1.0)
  echo "Счётчик количества создан: от 1 до ", maxAvailable

let quantitySpin = buildQuantitySpin(12)
```

---

### Выпадающий список стран с id и читаемым текстом

Полная сборка `GtkComboBoxText` со стабильными идентификаторами, обработчиком выбора и восстановлением сохранённого значения.

```nim
proc onCountryChanged(comboBox: GtkComboBoxText, userData: gpointer) {.cdecl.} =
  let id = gtk_combo_box_get_active_id(comboBox)
  if not isNil(id):
    echo "Выбрана страна с кодом: ", $id

proc buildCountryCombo(savedCountryId: string): GtkComboBoxText =
  result = gtk_combo_box_text_new()
  gtk_combo_box_text_append(result, "RU", "Россия")
  gtk_combo_box_text_append(result, "DE", "Германия")
  gtk_combo_box_text_append(result, "FR", "Франция")
  gtk_combo_box_text_append(result, "JP", "Япония")

  if savedCountryId.len == 0 or gtk_combo_box_set_active_id(result, savedCountryId.cstring) == 0.gboolean:
    gtk_combo_box_set_active(result, 0)  # запасной вариант — первая страна в списке

  discard g_signal_connect(result, "changed", onCountryChanged, nil)

let countryCombo = buildCountryCombo("DE")
```

---

### Ползунок громкости без числового значения на глаз

Компактный вертикальный ползунок для панели быстрых настроек — без отображения числа, только визуальное положение.

```nim
proc buildCompactVolumeSlider(): GtkScale =
  result = gtk_scale_new_with_range(GTK_ORIENTATION_VERTICAL, 0.0, 100.0, 5.0)
  gtk_scale_set_draw_value(result, 0.gboolean)  # только положение ползунка, без числа
  gtk_widget_set_size_request(result, -1, 120)
  gtk_range_set_value(result, 70.0)
  echo "Компактный вертикальный ползунок громкости без цифр создан"

let quickVolumeSlider = buildCompactVolumeSlider()
```

---

### Комбо-бокс с возможностью ввести свой вариант

`GtkComboBoxText` с полем ввода — пользователь может выбрать готовый тег или напечатать новый, не входящий в список.

```nim
proc buildTagPicker(existingTags: openArray[string]): GtkComboBoxText =
  result = gtk_combo_box_text_new_with_entry()
  for tag in existingTags:
    gtk_combo_box_text_append_text(result, tag.cstring)
  echo "Список готовых тегов с возможностью ввода собственного варианта создан"

proc getSelectedOrTypedTag(comboBox: GtkComboBoxText): string =
  let activeText = gtk_combo_box_text_get_active_text(comboBox)
  result = if isNil(activeText): "" else: $activeText

let tagPicker = buildTagPicker(["срочно", "в работе", "готово"])
```

---

## Краткая таблица

| Процедура(ы) | Категория | Что делает вкратце |
|---|---|---|
| `gtk_adjustment_new` | Adjustment | Создать объект настройки диапазона со всеми параметрами |
| `gtk_adjustment_set/get_value` | Adjustment | Текущее значение (обновляет все связанные виджеты) |
| `gtk_adjustment_set/get_lower`, `set/get_upper` | Adjustment | Границы диапазона |
| `gtk_spin_button_new`, `_with_range` | SpinButton | Создать числовое поле — с готовым Adjustment или укороченно |
| `gtk_spin_button_set/get_adjustment` | SpinButton | Связанный объект настройки диапазона |
| `gtk_spin_button_set/get_digits` | SpinButton | Число знаков после запятой в отображении |
| `gtk_spin_button_set/get_value`, `get_value_as_int` | SpinButton | Текущее числовое значение |
| `gtk_spin_button_set/get_range` | SpinButton | Границы диапазона (короткая форма без Adjustment) |
| `gtk_scale_new`, `_with_range` | Scale | Создать ползунок — с готовым Adjustment или укороченно |
| `gtk_scale_set/get_digits` | Scale | Число знаков после запятой в подписи значения |
| `gtk_scale_set/get_draw_value` | Scale | Показывать ли числовое значение рядом с бегунком |
| `gtk_scale_set/get_value_pos` | Scale | С какой стороны показывать значение |
| `gtk_range_set_value` | Range | Установить значение напрямую на виджете (без Adjustment) |
| `gtk_combo_box_text_new`, `_with_entry` | ComboBoxText | Создать выпадающий список — обычный или с полем ввода |
| `gtk_combo_box_text_append/prepend/insert` | ComboBoxText | Добавить вариант с id и текстом |
| `gtk_combo_box_text_append/prepend/insert_text` | ComboBoxText | Добавить вариант только с текстом, без id |
| `gtk_combo_box_text_remove`, `remove_all` | ComboBoxText | Удалить один вариант / очистить список |
| `gtk_combo_box_text_get_active_text` | ComboBoxText | Видимый текст текущего выбора (или введённый вручную) |
| `gtk_combo_box_set/get_active` | ComboBox | Текущий выбор по числовому индексу |
| `gtk_combo_box_set/get_active_id` | ComboBox | Текущий выбор по стабильному id |

---

## Сводка: какую процедуру выбрать

- **Ползунок и числовое поле должны показывать одно и то же значение синхронно** → создать один `GtkAdjustment` через `gtk_adjustment_new` и передать его сразу в `gtk_scale_new` и `gtk_spin_button_new` (полные формы конструкторов), а не пытаться вручную синхронизировать два независимых `_with_range`-виджета через сигналы.
- **Нужен только один из виджетов, без синхронизации с другим** → укороченный конструктор (`gtk_spin_button_new_with_range`/`gtk_scale_new_with_range`) — Adjustment создаётся неявно, не нужно создавать и хранить его отдельно.
- **Важно точное число** (количество, цена, возраст) → `GtkSpinButton` — вводится с клавиатуры и корректируется стрелками. **Важно быстрое визуальное ощущение позиции в диапазоне** (громкость, яркость) → `GtkScale`, особенно с выключенным `draw_value` для совсем компактного вида.
- **Сохранять выбор пользователя между запусками приложения / выбор может теряться позицию в списке** (список вариантов может меняться, пополняться) → `gtk_combo_box_set_active_id`/`get_active_id` по стабильному `id`, а не `gtk_combo_box_set_active`/`get_active` по числовому индексу — индекс "плывёт" при изменении состава списка, `id` — нет.
- **Список вариантов не имеет естественного технического идентификатора, кроме собственного текста** → короткие `_text`-варианты (`append_text` и т.п.), не заводя `id` искусственно.
- **Список готовых вариантов, но пользователь иногда должен ввести что-то своё** → `gtk_combo_box_text_new_with_entry`, а не обычный `GtkComboBoxText` + отдельное поле рядом — так один и тот же виджет обслуживает оба случая, а `gtk_combo_box_text_get_active_text` единообразно возвращает результат независимо от того, выбран готовый вариант или введён новый.
- **Нужно прочитать текущее значение `GtkScale` программно** → через `GtkAdjustment`, полученный при создании (или `gtk_spin_button_get_adjustment` у связанного `GtkSpinButton`) — у `GtkRange`/`GtkScale` в этой обёртке есть только `gtk_range_set_value` для записи, но нет отдельного геттера значения на уровне самого виджета.
