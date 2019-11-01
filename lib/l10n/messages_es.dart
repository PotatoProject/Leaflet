// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a es locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'es';

  static m0(method, maxLength) => "${method} de longitud no puede exceder ${maxLength}";

  static m1(method, minLength) => "${method} de longitud no puede exceder ${minLength}";

  static m2(path) => "Copia de seguridad ubicada en: ${path}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "archive" : MessageLookupByLibrary.simpleMessage("Archivar"),
    "black" : MessageLookupByLibrary.simpleMessage("Negro"),
    "cancel" : MessageLookupByLibrary.simpleMessage("Cancelar"),
    "chooseAction" : MessageLookupByLibrary.simpleMessage("Elegir acción"),
    "confirm" : MessageLookupByLibrary.simpleMessage("Confirmar"),
    "dark" : MessageLookupByLibrary.simpleMessage("Oscuro"),
    "done" : MessageLookupByLibrary.simpleMessage("Hecho"),
    "light" : MessageLookupByLibrary.simpleMessage("Claro"),
    "modifyNotesRoute_color_change" : MessageLookupByLibrary.simpleMessage("Cambiar color de nota"),
    "modifyNotesRoute_color_dialogTitle" : MessageLookupByLibrary.simpleMessage("Selector de color de nota"),
    "modifyNotesRoute_content" : MessageLookupByLibrary.simpleMessage("Contenido"),
    "modifyNotesRoute_image" : MessageLookupByLibrary.simpleMessage("Imagen"),
    "modifyNotesRoute_image_add" : MessageLookupByLibrary.simpleMessage("Añadir imagen"),
    "modifyNotesRoute_image_remove" : MessageLookupByLibrary.simpleMessage("Eliminar imagen"),
    "modifyNotesRoute_image_update" : MessageLookupByLibrary.simpleMessage("Actualizar imagen"),
    "modifyNotesRoute_list" : MessageLookupByLibrary.simpleMessage("Lista"),
    "modifyNotesRoute_list_entry" : MessageLookupByLibrary.simpleMessage("Entrada"),
    "modifyNotesRoute_list_selectedEntries" : MessageLookupByLibrary.simpleMessage(" entradas marcadas"),
    "modifyNotesRoute_reminder" : MessageLookupByLibrary.simpleMessage("Recordatorio"),
    "modifyNotesRoute_reminder_add" : MessageLookupByLibrary.simpleMessage("Agregar un recordatorio"),
    "modifyNotesRoute_reminder_date" : MessageLookupByLibrary.simpleMessage("Fecha"),
    "modifyNotesRoute_reminder_time" : MessageLookupByLibrary.simpleMessage("Tiempo"),
    "modifyNotesRoute_reminder_update" : MessageLookupByLibrary.simpleMessage("Actualizar recordatorio"),
    "modifyNotesRoute_security_dialog_lengthExceed" : m0,
    "modifyNotesRoute_security_dialog_lengthShort" : m1,
    "modifyNotesRoute_security_dialog_titlePassword" : MessageLookupByLibrary.simpleMessage("Establecer o actualizar contraseña"),
    "modifyNotesRoute_security_dialog_titlePin" : MessageLookupByLibrary.simpleMessage("Establecer o actualizar PIN"),
    "modifyNotesRoute_security_dialog_valid" : MessageLookupByLibrary.simpleMessage(" válido"),
    "modifyNotesRoute_security_hideContent" : MessageLookupByLibrary.simpleMessage("Ocultar contenido de nota en la página principal"),
    "modifyNotesRoute_security_password" : MessageLookupByLibrary.simpleMessage("Contraseña"),
    "modifyNotesRoute_security_pin" : MessageLookupByLibrary.simpleMessage("PIN"),
    "modifyNotesRoute_security_protectionText" : MessageLookupByLibrary.simpleMessage("Usar seguridad para ocultar"),
    "modifyNotesRoute_title" : MessageLookupByLibrary.simpleMessage("Titulo"),
    "note_archive_snackbar" : MessageLookupByLibrary.simpleMessage("Nota archivada"),
    "note_delete" : MessageLookupByLibrary.simpleMessage("Borrar"),
    "note_delete_snackbar" : MessageLookupByLibrary.simpleMessage("Nota borrada"),
    "note_edit" : MessageLookupByLibrary.simpleMessage("Editar"),
    "note_emptryTrash" : MessageLookupByLibrary.simpleMessage("Papelera vacía"),
    "note_export" : MessageLookupByLibrary.simpleMessage("Exportar"),
    "note_exportLocation" : MessageLookupByLibrary.simpleMessage("Nota exportada en"),
    "note_lockedOptions" : MessageLookupByLibrary.simpleMessage("Nota bloqueada, utilice las opciones en la pantalla de notas"),
    "note_pinToNotifs" : MessageLookupByLibrary.simpleMessage("Notificación fijada"),
    "note_removeFromArchive_snackbar" : MessageLookupByLibrary.simpleMessage("Nota archivada eliminada"),
    "note_restore_snackbar" : MessageLookupByLibrary.simpleMessage("Nota restaurada"),
    "note_select" : MessageLookupByLibrary.simpleMessage("Seleccionar"),
    "note_share" : MessageLookupByLibrary.simpleMessage("Compartir"),
    "note_star" : MessageLookupByLibrary.simpleMessage("Destacar"),
    "note_unstar" : MessageLookupByLibrary.simpleMessage("Quitar destacado"),
    "notes" : MessageLookupByLibrary.simpleMessage("Notas"),
    "notesMainPageRoute_emptyArchive" : MessageLookupByLibrary.simpleMessage("No tienes notas archivadas"),
    "notesMainPageRoute_emptyTrash" : MessageLookupByLibrary.simpleMessage("Tu papelera está vacía"),
    "notesMainPageRoute_noNotes" : MessageLookupByLibrary.simpleMessage("No existen notas, por ahora"),
    "notesMainPageRoute_note_deleteDialog_content" : MessageLookupByLibrary.simpleMessage("Una vez que las notas se eliminan de aquí no se pueden restaurar.\n¿Está seguro de que desea continuar?"),
    "notesMainPageRoute_note_deleteDialog_title" : MessageLookupByLibrary.simpleMessage("¿Eliminar notas seleccionadas?"),
    "notesMainPageRoute_note_emptyTrash_content" : MessageLookupByLibrary.simpleMessage("Una vez que las notas se eliminan de aquí no se pueden restaurar.\n¿Está seguro de que desea continuar?"),
    "notesMainPageRoute_note_emptyTrash_title" : MessageLookupByLibrary.simpleMessage("¿Vaciar la papelera?"),
    "notesMainPageRoute_note_hiddenContent" : MessageLookupByLibrary.simpleMessage("Contenido oculto"),
    "notesMainPageRoute_note_list_selectedEntries" : MessageLookupByLibrary.simpleMessage(" entradas seleccionadas"),
    "notesMainPageRoute_note_remindersSet" : MessageLookupByLibrary.simpleMessage("Recordatorios de la nota"),
    "notesMainPageRoute_other" : MessageLookupByLibrary.simpleMessage("Otras notas"),
    "notesMainPageRoute_pinnedNote" : MessageLookupByLibrary.simpleMessage("Nota anclada"),
    "notesMainPageRoute_starred" : MessageLookupByLibrary.simpleMessage("Notas destacadas"),
    "notesMainPageRoute_writeNote" : MessageLookupByLibrary.simpleMessage("Escribe una nota"),
    "notes_archive_snackbar" : MessageLookupByLibrary.simpleMessage("Notas archivadas"),
    "notes_delete_snackbar" : MessageLookupByLibrary.simpleMessage("Notas eliminadas"),
    "notes_removeFromArchive_snackbar" : MessageLookupByLibrary.simpleMessage("Notas archivadas eliminadas"),
    "notes_restore_snackbar" : MessageLookupByLibrary.simpleMessage("Notas restauradas"),
    "remove" : MessageLookupByLibrary.simpleMessage("Eliminar"),
    "reset" : MessageLookupByLibrary.simpleMessage("Reiniciar"),
    "save" : MessageLookupByLibrary.simpleMessage("Guardar"),
    "searchNotesRoute_filters_case" : MessageLookupByLibrary.simpleMessage("Distinguir mayúsculas y minúsculas"),
    "searchNotesRoute_filters_color" : MessageLookupByLibrary.simpleMessage("Filtro de color"),
    "searchNotesRoute_filters_date" : MessageLookupByLibrary.simpleMessage("Filtro de fecha"),
    "searchNotesRoute_filters_title" : MessageLookupByLibrary.simpleMessage("Filtros de búsqueda"),
    "searchNotesRoute_noQuery" : MessageLookupByLibrary.simpleMessage("Ingrese algo para iniciar la búsqueda"),
    "searchNotesRoute_nothingFound" : MessageLookupByLibrary.simpleMessage("No se han encontrado notas que coincidan con sus términos de búsqueda"),
    "searchNotesRoute_searchbar" : MessageLookupByLibrary.simpleMessage("Buscar..."),
    "securityNoteRoute_request_password" : MessageLookupByLibrary.simpleMessage("Se solicita una contraseña para abrir la nota"),
    "securityNoteRoute_request_pin" : MessageLookupByLibrary.simpleMessage("Se solicita un PIN para abrir la nota"),
    "securityNoteRoute_wrong_password" : MessageLookupByLibrary.simpleMessage("Contraseña incorrecta"),
    "securityNoteRoute_wrong_pin" : MessageLookupByLibrary.simpleMessage("PIN incorrecto"),
    "settingsRoute_about" : MessageLookupByLibrary.simpleMessage("Acerca de"),
    "settingsRoute_about_potatonotes" : MessageLookupByLibrary.simpleMessage("Acerca de PotatoNotes"),
    "settingsRoute_about_potatonotes_design" : MessageLookupByLibrary.simpleMessage("Diseño, marca de aplicaciones y logotipo de la aplicación por RshBfn"),
    "settingsRoute_about_potatonotes_development" : MessageLookupByLibrary.simpleMessage("Desarrollado y mantenido por HrX03"),
    "settingsRoute_about_sourceCode" : MessageLookupByLibrary.simpleMessage("Código fuente de PotatoNotes"),
    "settingsRoute_backupAndRestore" : MessageLookupByLibrary.simpleMessage("Copia de seguridad y restaurar"),
    "settingsRoute_backupAndRestore_backup" : MessageLookupByLibrary.simpleMessage("Respaldo (Experimental)"),
    "settingsRoute_backupAndRestore_backup_done" : m2,
    "settingsRoute_backupAndRestore_regenDbEntries" : MessageLookupByLibrary.simpleMessage("Regenerar entradas de base de datos"),
    "settingsRoute_backupAndRestore_restore" : MessageLookupByLibrary.simpleMessage("Restaurar (Experimental)"),
    "settingsRoute_backupAndRestore_restore_fail" : MessageLookupByLibrary.simpleMessage("¡DB corrupto o inválido!"),
    "settingsRoute_backupAndRestore_restore_success" : MessageLookupByLibrary.simpleMessage("¡Hecho!"),
    "settingsRoute_dev" : MessageLookupByLibrary.simpleMessage("Opciones para desarrolladores"),
    "settingsRoute_dev_idLabels" : MessageLookupByLibrary.simpleMessage("Mostrar etiquetas de información"),
    "settingsRoute_gestures" : MessageLookupByLibrary.simpleMessage("Gestos"),
    "settingsRoute_gestures_quickStar" : MessageLookupByLibrary.simpleMessage("Doble toque para destacar"),
    "settingsRoute_themes" : MessageLookupByLibrary.simpleMessage("Temas"),
    "settingsRoute_themes_appTheme" : MessageLookupByLibrary.simpleMessage("Tema de App"),
    "settingsRoute_themes_customAccentColor" : MessageLookupByLibrary.simpleMessage("Color personalizado"),
    "settingsRoute_themes_followSystem" : MessageLookupByLibrary.simpleMessage("Seguir tema del sistema"),
    "settingsRoute_themes_systemDarkMode" : MessageLookupByLibrary.simpleMessage("Modo de tema oscuro automático"),
    "settingsRoute_themes_useCustomAccent" : MessageLookupByLibrary.simpleMessage("Usar color de acento personalizado"),
    "settingsRoute_title" : MessageLookupByLibrary.simpleMessage("Ajustes"),
    "trash" : MessageLookupByLibrary.simpleMessage("Papelera"),
    "undo" : MessageLookupByLibrary.simpleMessage("Deshacer"),
    "userInfoRoute_avatar_change" : MessageLookupByLibrary.simpleMessage("Cambiar avatar"),
    "userInfoRoute_avatar_remove" : MessageLookupByLibrary.simpleMessage("Eliminar avatar"),
    "userInfoRoute_sortByDate" : MessageLookupByLibrary.simpleMessage("Ordenar notas por fecha")
  };
}
