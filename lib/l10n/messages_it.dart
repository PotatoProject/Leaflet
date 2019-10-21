// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a it locale. All the
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
  String get localeName => 'it';

  static m0(method, maxLength) => "La lunghezza del ${method} non può oltrepassare ${maxLength}";

  static m1(method, minLength) => "La lunghezza del ${method} non può essere minore di ${minLength}";

  static m2(path) => "Backup situato su: ${path}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "black" : MessageLookupByLibrary.simpleMessage("Nero"),
    "cancel" : MessageLookupByLibrary.simpleMessage("Annulla"),
    "chooseAction" : MessageLookupByLibrary.simpleMessage("Scegli azione"),
    "confirm" : MessageLookupByLibrary.simpleMessage("Conferma"),
    "dark" : MessageLookupByLibrary.simpleMessage("Scuro"),
    "done" : MessageLookupByLibrary.simpleMessage("Fatto"),
    "light" : MessageLookupByLibrary.simpleMessage("Chiaro"),
    "modifyNotesRoute_color_change" : MessageLookupByLibrary.simpleMessage("Cambia colore"),
    "modifyNotesRoute_color_dialogTitle" : MessageLookupByLibrary.simpleMessage("Selettore del colore"),
    "modifyNotesRoute_content" : MessageLookupByLibrary.simpleMessage("Contenuto"),
    "modifyNotesRoute_image" : MessageLookupByLibrary.simpleMessage("Immagine"),
    "modifyNotesRoute_image_add" : MessageLookupByLibrary.simpleMessage("Aggiungi immagine"),
    "modifyNotesRoute_image_remove" : MessageLookupByLibrary.simpleMessage("Rimuovi immagine"),
    "modifyNotesRoute_image_update" : MessageLookupByLibrary.simpleMessage("Aggiorna immagine"),
    "modifyNotesRoute_list" : MessageLookupByLibrary.simpleMessage("Lista"),
    "modifyNotesRoute_list_entry" : MessageLookupByLibrary.simpleMessage("Voce"),
    "modifyNotesRoute_list_selectedEntries" : MessageLookupByLibrary.simpleMessage(" voci selezionate"),
    "modifyNotesRoute_reminder" : MessageLookupByLibrary.simpleMessage("Promemoria"),
    "modifyNotesRoute_reminder_add" : MessageLookupByLibrary.simpleMessage("Aggiungi un promemoria"),
    "modifyNotesRoute_reminder_date" : MessageLookupByLibrary.simpleMessage("Giorno"),
    "modifyNotesRoute_reminder_time" : MessageLookupByLibrary.simpleMessage("Ora"),
    "modifyNotesRoute_reminder_update" : MessageLookupByLibrary.simpleMessage("Aggiorna promemoria"),
    "modifyNotesRoute_security_dialog_lengthExceed" : m0,
    "modifyNotesRoute_security_dialog_lengthShort" : m1,
    "modifyNotesRoute_security_dialog_titlePassword" : MessageLookupByLibrary.simpleMessage("Imposta o aggiorna la password"),
    "modifyNotesRoute_security_dialog_titlePin" : MessageLookupByLibrary.simpleMessage("Imposta o aggiorna il PIN"),
    "modifyNotesRoute_security_dialog_valid" : MessageLookupByLibrary.simpleMessage(" valido/a"),
    "modifyNotesRoute_security_hideContent" : MessageLookupByLibrary.simpleMessage("Nascondi contenuto nella pagina principale"),
    "modifyNotesRoute_security_password" : MessageLookupByLibrary.simpleMessage("Password"),
    "modifyNotesRoute_security_pin" : MessageLookupByLibrary.simpleMessage("PIN"),
    "modifyNotesRoute_security_protectionText" : MessageLookupByLibrary.simpleMessage("Utilizza una protezione per nascondere"),
    "modifyNotesRoute_title" : MessageLookupByLibrary.simpleMessage("Titolo"),
    "note_delete" : MessageLookupByLibrary.simpleMessage("Elimina"),
    "note_delete_snackbar" : MessageLookupByLibrary.simpleMessage("Appunto eliminato"),
    "note_edit" : MessageLookupByLibrary.simpleMessage("Modifica"),
    "note_export" : MessageLookupByLibrary.simpleMessage("Esporta"),
    "note_exportLocation" : MessageLookupByLibrary.simpleMessage("Appunto esportato su"),
    "note_pinToNotifs" : MessageLookupByLibrary.simpleMessage("Fissa nelle notifiche"),
    "note_select" : MessageLookupByLibrary.simpleMessage("Seleziona"),
    "note_share" : MessageLookupByLibrary.simpleMessage("Condividi"),
    "note_star" : MessageLookupByLibrary.simpleMessage("Preferito"),
    "note_unstar" : MessageLookupByLibrary.simpleMessage("Non preferito"),
    "notes" : MessageLookupByLibrary.simpleMessage("Appunti"),
    "notesMainPageRoute_addButtonTooltip" : MessageLookupByLibrary.simpleMessage("Aggiungi appunto"),
    "notesMainPageRoute_noNotes" : MessageLookupByLibrary.simpleMessage("Nessun appunto aggiunto... per ora"),
    "notesMainPageRoute_note_hiddenContent" : MessageLookupByLibrary.simpleMessage("Contenuto nascosto"),
    "notesMainPageRoute_note_list_selectedEntries" : MessageLookupByLibrary.simpleMessage(" voci selezionate"),
    "notesMainPageRoute_note_remindersSet" : MessageLookupByLibrary.simpleMessage("Promemoria impostati"),
    "notesMainPageRoute_pinnedNote" : MessageLookupByLibrary.simpleMessage("Appunto fissato"),
    "notesMainPageRoute_starred" : MessageLookupByLibrary.simpleMessage("Appunti preferiti"),
    "notesMainPageRoute_user_avatar_change" : MessageLookupByLibrary.simpleMessage("Cambia immagine"),
    "notesMainPageRoute_user_avatar_remove" : MessageLookupByLibrary.simpleMessage("Rimuovi immagine"),
    "notesMainPageRoute_user_info" : MessageLookupByLibrary.simpleMessage("Informazioni utente"),
    "notesMainPageRoute_user_name_change" : MessageLookupByLibrary.simpleMessage("Cambia nickname"),
    "remove" : MessageLookupByLibrary.simpleMessage("Rimuovi"),
    "reset" : MessageLookupByLibrary.simpleMessage("Reimposta"),
    "save" : MessageLookupByLibrary.simpleMessage("Salva"),
    "searchNotesRoute_filters_case" : MessageLookupByLibrary.simpleMessage("Sensibile alle maiuscole"),
    "searchNotesRoute_filters_color" : MessageLookupByLibrary.simpleMessage("Colore"),
    "searchNotesRoute_filters_date" : MessageLookupByLibrary.simpleMessage("Data"),
    "searchNotesRoute_filters_title" : MessageLookupByLibrary.simpleMessage("Filtri"),
    "searchNotesRoute_noQuery" : MessageLookupByLibrary.simpleMessage("Scrivi qualcosa per iniziare a cercare"),
    "searchNotesRoute_nothingFound" : MessageLookupByLibrary.simpleMessage("Nessun appunto trovato che corrispondesse alla tua ricerca"),
    "searchNotesRoute_searchbar" : MessageLookupByLibrary.simpleMessage("Cerca..."),
    "securityNoteRoute_request_password" : MessageLookupByLibrary.simpleMessage("E\' richiesta una password per aprire l\'appunto"),
    "securityNoteRoute_request_pin" : MessageLookupByLibrary.simpleMessage("E\' richiesto un PIN per aprire l\'appunto"),
    "securityNoteRoute_wrong_password" : MessageLookupByLibrary.simpleMessage("Password errata"),
    "securityNoteRoute_wrong_pin" : MessageLookupByLibrary.simpleMessage("PIN errato"),
    "settingsRoute_about" : MessageLookupByLibrary.simpleMessage("Crediti"),
    "settingsRoute_about_potatonotes" : MessageLookupByLibrary.simpleMessage("A proposito di PotatoNotes..."),
    "settingsRoute_about_potatonotes_design" : MessageLookupByLibrary.simpleMessage("Design e icon dell\'app di RshBfn"),
    "settingsRoute_about_potatonotes_development" : MessageLookupByLibrary.simpleMessage("Sviluppato e supportato da HrX03"),
    "settingsRoute_about_sourceCode" : MessageLookupByLibrary.simpleMessage("Codice sorgente di PotatoNotes"),
    "settingsRoute_backupAndRestore" : MessageLookupByLibrary.simpleMessage("Backup & ripristino"),
    "settingsRoute_backupAndRestore_backup" : MessageLookupByLibrary.simpleMessage("Backup (Sperimentale)"),
    "settingsRoute_backupAndRestore_backup_done" : m2,
    "settingsRoute_backupAndRestore_restore" : MessageLookupByLibrary.simpleMessage("Ripristino (Sperimentale)"),
    "settingsRoute_backupAndRestore_restore_fail" : MessageLookupByLibrary.simpleMessage("Database corrotto o non valido!"),
    "settingsRoute_backupAndRestore_restore_success" : MessageLookupByLibrary.simpleMessage("Fatto!"),
    "settingsRoute_dev" : MessageLookupByLibrary.simpleMessage("Opzioni sviluppatore"),
    "settingsRoute_dev_idLabels" : MessageLookupByLibrary.simpleMessage("Mostra etichette dell\'id"),
    "settingsRoute_gestures" : MessageLookupByLibrary.simpleMessage("Gesti"),
    "settingsRoute_gestures_quickStar" : MessageLookupByLibrary.simpleMessage("Doppio tocco per mettere tra i preferiti"),
    "settingsRoute_themes" : MessageLookupByLibrary.simpleMessage("Temi"),
    "settingsRoute_themes_appTheme" : MessageLookupByLibrary.simpleMessage("Tema dell\'app"),
    "settingsRoute_themes_customAccentColor" : MessageLookupByLibrary.simpleMessage("Colore personalizzato"),
    "settingsRoute_themes_followSystem" : MessageLookupByLibrary.simpleMessage("Segui il tema di sistema"),
    "settingsRoute_themes_systemDarkMode" : MessageLookupByLibrary.simpleMessage("Tema scuro di sistema"),
    "settingsRoute_themes_useCustomAccent" : MessageLookupByLibrary.simpleMessage("Utilizza un colore di accento personalizzato"),
    "settingsRoute_title" : MessageLookupByLibrary.simpleMessage("Impostazioni"),
    "undo" : MessageLookupByLibrary.simpleMessage("Annulla")
  };
}
