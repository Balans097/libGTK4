################################################################
##  dialogs.nim — диалоговые окна
##
##  Всё, что открывает отдельное GTK-окно поверх главного:
##  открытие/сохранение файла, окно "О программе", простые
##  информационные диалоги и диалоги об ошибке.
##
##  Это GUI-код (как и gui.nim), просто не встроенный в
##  компоновку главного окна, а вызываемый по требованию.
##  Логика файлового ввода-вывода сюда НЕ переносится — только
##  вызывается из fileio.nim; сам этот модуль лишь решает, что
##  показать пользователю по результату.
################################################################

import libGTK4
import config
import i18n
import docmodel
import fileio


# ============================================================================
# Простые модальные диалоги
#
# libGTK4 уже предоставляет готовые showInfoDialog / showErrorDialog /
# showWarningDialog (обёртки над showMessageDialog с разным
# GtkMessageType и флагом diaog=0 — в этой версии библиотеки
# GtkDialogFlags именованными константами не выражен, а модальность
# файловых диалогов ниже выставляется отдельным вызовом
# gtk_window_set_modal). Переопределять их здесь не нужно — они
# вызываются напрямую, см. runOpenDialog/runSaveAsDialog ниже.
# ============================================================================


# ============================================================================
# Диалог «Открыть файл»
# ============================================================================

proc runOpenDialog*() =
  let dlg = gtk_file_chooser_dialog_new(
    tr("dialog.open.title").cstring,
    state.window,
    GTK_FILE_CHOOSER_ACTION_OPEN,
    tr("dialog.open.cancel").cstring, GTK_RESPONSE_CANCEL.gint,
    tr("dialog.open.accept").cstring, GTK_RESPONSE_ACCEPT.gint,
    nil)
  gtk_window_set_modal(cast[GtkWindow](dlg), TRUE)

  proc onResponse(dialog: GtkFileChooserDialog, responseId: gint, userData: gpointer) {.cdecl.} =
    if responseId == GTK_RESPONSE_ACCEPT.gint:
      let gfile = gtk_file_chooser_get_file(cast[GtkFileChooser](dialog))
      if gfile != nil:
        let cpath = g_file_get_path(gfile)
        if cpath != nil:
          let fullPath = $cpath
          g_free(cast[gpointer](cpath))
          let (content, res) = loadFromPath(fullPath)
          if res.ok:
            setBufferText(content)
            state.docPath  = fullPath
            state.docTitle = baseName(fullPath)
            markModified(false)
            setStatus(tr("status.opened") & state.docTitle)
          else:
            showErrorDialog(state.window, tr("dialog.error.read"), res.error)
        g_object_unref(cast[gpointer](gfile))
    gtk_window_destroy(cast[GtkWindow](dialog))

  discard g_signal_connect(dlg, "response", cast[GCallback](onResponse), nil)
  gtk_window_present(cast[GtkWindow](dlg))


# ============================================================================
# Диалог «Сохранить как»
# ============================================================================

proc runSaveAsDialog*() =
  let dlg = gtk_file_chooser_dialog_new(
    tr("dialog.saveAs.title").cstring,
    state.window,
    GTK_FILE_CHOOSER_ACTION_SAVE,
    tr("dialog.saveAs.cancel").cstring, GTK_RESPONSE_CANCEL.gint,
    tr("dialog.saveAs.accept").cstring, GTK_RESPONSE_ACCEPT.gint,
    nil)
  gtk_window_set_modal(cast[GtkWindow](dlg), TRUE)

  let suggested = suggestedFileName(
    state.docTitle, tr("app.title.untitled"), tr("dialog.saveAs.defaultName"))
  gtk_file_chooser_set_current_name(cast[GtkFileChooser](dlg), suggested.cstring)

  proc onResponse(dialog: GtkFileChooserDialog, responseId: gint, userData: gpointer) {.cdecl.} =
    if responseId == GTK_RESPONSE_ACCEPT.gint:
      let gfile = gtk_file_chooser_get_file(cast[GtkFileChooser](dialog))
      if gfile != nil:
        let cpath = g_file_get_path(gfile)
        if cpath != nil:
          let fullPath = $cpath
          g_free(cast[gpointer](cpath))
          let res = saveToPath(fullPath, bufferText())
          if res.ok:
            state.docPath  = fullPath
            state.docTitle = baseName(fullPath)
            markModified(false)
            setStatus(tr("status.saved") & state.docTitle)
          else:
            showErrorDialog(state.window, tr("dialog.error.write"), res.error)
        g_object_unref(cast[gpointer](gfile))
    gtk_window_destroy(cast[GtkWindow](dialog))

  discard g_signal_connect(dlg, "response", cast[GCallback](onResponse), nil)
  gtk_window_present(cast[GtkWindow](dlg))


# ============================================================================
# Диалог «О программе»
# ============================================================================

proc runAboutDialog*() =
  let dlg = gtk_about_dialog_new()
  gtk_about_dialog_set_program_name(dlg, tr("app.title").cstring)
  gtk_about_dialog_set_version(dlg, config.appVersion.cstring)
  gtk_about_dialog_set_comments(dlg, tr("about.comments").cstring)
  gtk_window_set_transient_for(cast[GtkWindow](dlg), state.window)
  gtk_window_set_modal(cast[GtkWindow](dlg), TRUE)

  proc onClose(w: GtkWindow, ud: gpointer): gboolean {.cdecl.} =
    gtk_window_destroy(w)
    result = TRUE

  discard g_signal_connect(dlg, "close-request", cast[GCallback](onClose), nil)
  gtk_window_present(cast[GtkWindow](dlg))
