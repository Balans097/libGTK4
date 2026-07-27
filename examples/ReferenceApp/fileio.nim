################################################################
##  fileio.nim — чтение и запись файлов документа
##
##  Чистый слой ввода-вывода: не знает о GTK, не показывает
##  диалогов и не трогает AppState напрямую. Возвращает результат
##  вызывающему коду (dialogs.nim/actions.nim), который сам решает,
##  как сообщить пользователю об ошибке (см. dialogs.showErrorDialog).
##
##  Именно эта развязка позволяет, например, писать модульные
##  тесты на чтение/запись без запуска GTK вообще.
################################################################

import std/os


type
  FileResult* = object
    ok*:    bool     ## успех операции
    error*: string   ## текст ошибки (пусто, если ok == true)


proc saveToPath*(path: string, content: string): FileResult =
  ## Записать содержимое в файл по указанному пути.
  try:
    writeFile(path, content)
    result = FileResult(ok: true, error: "")
  except IOError as e:
    result = FileResult(ok: false, error: e.msg)


proc loadFromPath*(path: string): tuple[content: string, res: FileResult] =
  ## Прочитать файл целиком. Если `res.ok == false` — `content` пуст
  ## и использовать его не нужно.
  try:
    let text = readFile(path)
    result = (content: text, res: FileResult(ok: true, error: ""))
  except IOError as e:
    result = (content: "", res: FileResult(ok: false, error: e.msg))


proc suggestedFileName*(currentTitle, untitledPlaceholder, defaultName: string): string =
  ## Подсказать имя файла для диалога "Сохранить как": если документ
  ## ещё не имеет имени — предложить имя по умолчанию, иначе — текущее.
  result = if currentTitle == untitledPlaceholder: defaultName else: currentTitle


proc baseName*(path: string): string =
  result = extractFilename(path)
