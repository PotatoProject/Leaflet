// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a nl locale. All the
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
  String get localeName => 'nl';

  static m0(method, maxLength) => "${method} lengte kan niet groter zijn dan ${maxLength}";

  static m1(method, minLength) => "${method} lengte kan niet kleiner zijn dan ${minLength}";

  static m2(path) => "Back-up in: ${path}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "archive" : MessageLookupByLibrary.simpleMessage("Archiveren"),
    "black" : MessageLookupByLibrary.simpleMessage("Zwart"),
    "cancel" : MessageLookupByLibrary.simpleMessage("Annuleren"),
    "chooseAction" : MessageLookupByLibrary.simpleMessage("Kies actie"),
    "confirm" : MessageLookupByLibrary.simpleMessage("Bevestigen"),
    "dark" : MessageLookupByLibrary.simpleMessage("Donker"),
    "done" : MessageLookupByLibrary.simpleMessage("Gereed"),
    "light" : MessageLookupByLibrary.simpleMessage("Licht"),
    "modifyNotesRoute_color_change" : MessageLookupByLibrary.simpleMessage("Wijzig notitiekleur"),
    "modifyNotesRoute_color_dialogTitle" : MessageLookupByLibrary.simpleMessage("Selecteer notitiekleur"),
    "modifyNotesRoute_content" : MessageLookupByLibrary.simpleMessage("Inhoud"),
    "modifyNotesRoute_image" : MessageLookupByLibrary.simpleMessage("Afbeelding"),
    "modifyNotesRoute_image_add" : MessageLookupByLibrary.simpleMessage("Voeg afbeelding toe"),
    "modifyNotesRoute_image_remove" : MessageLookupByLibrary.simpleMessage("Verwijder afbeelding"),
    "modifyNotesRoute_image_update" : MessageLookupByLibrary.simpleMessage("Werk afbeelding bij"),
    "modifyNotesRoute_list" : MessageLookupByLibrary.simpleMessage("Lijst"),
    "modifyNotesRoute_list_entry" : MessageLookupByLibrary.simpleMessage("Invoer"),
    "modifyNotesRoute_list_selectedEntries" : MessageLookupByLibrary.simpleMessage(" afgevinkte items"),
    "modifyNotesRoute_reminder" : MessageLookupByLibrary.simpleMessage("Herinnering"),
    "modifyNotesRoute_reminder_add" : MessageLookupByLibrary.simpleMessage("Voeg een nieuwe herinnering toe"),
    "modifyNotesRoute_reminder_date" : MessageLookupByLibrary.simpleMessage("Datum"),
    "modifyNotesRoute_reminder_time" : MessageLookupByLibrary.simpleMessage("Tijd"),
    "modifyNotesRoute_reminder_update" : MessageLookupByLibrary.simpleMessage("Herinnering bijwerken"),
    "modifyNotesRoute_security_dialog_lengthExceed" : m0,
    "modifyNotesRoute_security_dialog_lengthShort" : m1,
    "modifyNotesRoute_security_dialog_titlePassword" : MessageLookupByLibrary.simpleMessage("Wachtwoord instellen of bijwerken"),
    "modifyNotesRoute_security_dialog_titlePin" : MessageLookupByLibrary.simpleMessage("Pincode instellen of bijwerken"),
    "modifyNotesRoute_security_dialog_valid" : MessageLookupByLibrary.simpleMessage(" geldig"),
    "modifyNotesRoute_security_hideContent" : MessageLookupByLibrary.simpleMessage("Verberg notitieinhoud op hoofdpagina"),
    "modifyNotesRoute_security_password" : MessageLookupByLibrary.simpleMessage("Wachtwoord"),
    "modifyNotesRoute_security_pin" : MessageLookupByLibrary.simpleMessage("Pincode"),
    "modifyNotesRoute_security_protectionText" : MessageLookupByLibrary.simpleMessage("Beveilig het verbergen"),
    "modifyNotesRoute_title" : MessageLookupByLibrary.simpleMessage("Titel"),
    "note_archive_snackbar" : MessageLookupByLibrary.simpleMessage("Notitie gearchiveerd"),
    "note_delete" : MessageLookupByLibrary.simpleMessage("Verwijder"),
    "note_delete_snackbar" : MessageLookupByLibrary.simpleMessage("Notitie verwijderd"),
    "note_edit" : MessageLookupByLibrary.simpleMessage("Bewerk"),
    "note_emptryTrash" : MessageLookupByLibrary.simpleMessage("Prullenbak legen"),
    "note_export" : MessageLookupByLibrary.simpleMessage("Exporteren"),
    "note_exportLocation" : MessageLookupByLibrary.simpleMessage("Notitie geëxporteerd op"),
    "note_lockedOptions" : MessageLookupByLibrary.simpleMessage("Notitie is vergrendeld, gebruik de opties op het notitiescherm"),
    "note_pinToNotifs" : MessageLookupByLibrary.simpleMessage("Maak notitie vast aan meldingen"),
    "note_removeFromArchive_snackbar" : MessageLookupByLibrary.simpleMessage("Notitie verwijderd uit gearchiveerd"),
    "note_restore_snackbar" : MessageLookupByLibrary.simpleMessage("Notitie hersteld"),
    "note_select" : MessageLookupByLibrary.simpleMessage("Selecteer"),
    "note_share" : MessageLookupByLibrary.simpleMessage("Delen"),
    "note_star" : MessageLookupByLibrary.simpleMessage("Voeg ster toe"),
    "note_unstar" : MessageLookupByLibrary.simpleMessage("Verwijder ster"),
    "notes" : MessageLookupByLibrary.simpleMessage("Notities"),
    "notesMainPageRoute_emptyArchive" : MessageLookupByLibrary.simpleMessage("U heeft geen notities in u archief"),
    "notesMainPageRoute_emptyTrash" : MessageLookupByLibrary.simpleMessage("Je prullenbak is leeg"),
    "notesMainPageRoute_noNotes" : MessageLookupByLibrary.simpleMessage("Nog geen notities toegevoegd..."),
    "notesMainPageRoute_note_deleteDialog_content" : MessageLookupByLibrary.simpleMessage("Als je de notities verweiderd kun je ze niet meer herstellen.\nWeet je het zeker dat je veder wilt gaan?"),
    "notesMainPageRoute_note_deleteDialog_title" : MessageLookupByLibrary.simpleMessage("Geselecteerde notities verwijderen?"),
    "notesMainPageRoute_note_emptyTrash_content" : MessageLookupByLibrary.simpleMessage("Als je de notities verweiderd kun je ze niet meer herstellen.\nWeet je het zeker dat je veder wilt gaan?"),
    "notesMainPageRoute_note_emptyTrash_title" : MessageLookupByLibrary.simpleMessage("Prullenbak legen?"),
    "notesMainPageRoute_note_hiddenContent" : MessageLookupByLibrary.simpleMessage("Verborgen inhoud"),
    "notesMainPageRoute_note_list_selectedEntries" : MessageLookupByLibrary.simpleMessage(" items geselecteerd"),
    "notesMainPageRoute_note_remindersSet" : MessageLookupByLibrary.simpleMessage("Herinneringen ingesteld voor notitie"),
    "notesMainPageRoute_other" : MessageLookupByLibrary.simpleMessage("Andere notities"),
    "notesMainPageRoute_pinnedNote" : MessageLookupByLibrary.simpleMessage("Vastgemaakte notitie"),
    "notesMainPageRoute_starred" : MessageLookupByLibrary.simpleMessage("Items met ster"),
    "notesMainPageRoute_writeNote" : MessageLookupByLibrary.simpleMessage("Maak een notitie"),
    "notes_archive_snackbar" : MessageLookupByLibrary.simpleMessage("Notitie gearchiveerd"),
    "notes_delete_snackbar" : MessageLookupByLibrary.simpleMessage("Notities verwijderd"),
    "notes_removeFromArchive_snackbar" : MessageLookupByLibrary.simpleMessage("Notitie verwijderd uit gearchiveerd"),
    "notes_restore_snackbar" : MessageLookupByLibrary.simpleMessage("Notitie hersteld"),
    "remove" : MessageLookupByLibrary.simpleMessage("Verwijderen"),
    "reset" : MessageLookupByLibrary.simpleMessage("Resetten"),
    "save" : MessageLookupByLibrary.simpleMessage("Opslaan"),
    "searchNotesRoute_filters_case" : MessageLookupByLibrary.simpleMessage("Hoofdlettergevoelig"),
    "searchNotesRoute_filters_color" : MessageLookupByLibrary.simpleMessage("Kleurfilter"),
    "searchNotesRoute_filters_date" : MessageLookupByLibrary.simpleMessage("Datumfilter"),
    "searchNotesRoute_filters_title" : MessageLookupByLibrary.simpleMessage("Zoekfilters"),
    "searchNotesRoute_noQuery" : MessageLookupByLibrary.simpleMessage("Voer iets in om te beginnen met zoeken"),
    "searchNotesRoute_nothingFound" : MessageLookupByLibrary.simpleMessage("Geen notities gevonden die overeenkomen met uw zoektermen"),
    "searchNotesRoute_searchbar" : MessageLookupByLibrary.simpleMessage("Zoeken..."),
    "securityNoteRoute_request_password" : MessageLookupByLibrary.simpleMessage("Een wachtwoord is nodig om de notitie te openen"),
    "securityNoteRoute_request_pin" : MessageLookupByLibrary.simpleMessage("Een PIN is nodig om de notitie te openen"),
    "securityNoteRoute_wrong_password" : MessageLookupByLibrary.simpleMessage("Onjuist wachtwoord"),
    "securityNoteRoute_wrong_pin" : MessageLookupByLibrary.simpleMessage("Onjuiste PIN"),
    "settingsRoute_about" : MessageLookupByLibrary.simpleMessage("Over"),
    "settingsRoute_about_potatonotes" : MessageLookupByLibrary.simpleMessage("Over PotatoNotes"),
    "settingsRoute_about_potatonotes_design" : MessageLookupByLibrary.simpleMessage("Ontwerp, design en logo door RshBfn"),
    "settingsRoute_about_potatonotes_development" : MessageLookupByLibrary.simpleMessage("Ontwikkeld en onderhouden door HrX03"),
    "settingsRoute_about_sourceCode" : MessageLookupByLibrary.simpleMessage("PotatoNotes broncode"),
    "settingsRoute_backupAndRestore" : MessageLookupByLibrary.simpleMessage("Back-up & herstellen"),
    "settingsRoute_backupAndRestore_backup" : MessageLookupByLibrary.simpleMessage("Back-up (experimenteel)"),
    "settingsRoute_backupAndRestore_backup_done" : m2,
    "settingsRoute_backupAndRestore_regenDbEntries" : MessageLookupByLibrary.simpleMessage("Database items opnieuw genereren"),
    "settingsRoute_backupAndRestore_restore" : MessageLookupByLibrary.simpleMessage("Herstellen (experimenteel)"),
    "settingsRoute_backupAndRestore_restore_fail" : MessageLookupByLibrary.simpleMessage("Corrupte of ongeldige DB!"),
    "settingsRoute_backupAndRestore_restore_success" : MessageLookupByLibrary.simpleMessage("Klaar!"),
    "settingsRoute_dev" : MessageLookupByLibrary.simpleMessage("Ontwikkelaarsopties"),
    "settingsRoute_dev_idLabels" : MessageLookupByLibrary.simpleMessage("Toon id labels"),
    "settingsRoute_gestures" : MessageLookupByLibrary.simpleMessage("Gebaren"),
    "settingsRoute_gestures_quickStar" : MessageLookupByLibrary.simpleMessage("Dubbeltik op notitie om ster toe te voegen"),
    "settingsRoute_themes" : MessageLookupByLibrary.simpleMessage("Thema\'s"),
    "settingsRoute_themes_appTheme" : MessageLookupByLibrary.simpleMessage("App thema"),
    "settingsRoute_themes_customAccentColor" : MessageLookupByLibrary.simpleMessage("Aangepaste kleur"),
    "settingsRoute_themes_followSystem" : MessageLookupByLibrary.simpleMessage("Volg systeemthema"),
    "settingsRoute_themes_systemDarkMode" : MessageLookupByLibrary.simpleMessage("Automatische donker thema modus"),
    "settingsRoute_themes_useCustomAccent" : MessageLookupByLibrary.simpleMessage("Gebruik aangepaste accentkleur"),
    "settingsRoute_title" : MessageLookupByLibrary.simpleMessage("Instellingen"),
    "trash" : MessageLookupByLibrary.simpleMessage("Prullenbak"),
    "undo" : MessageLookupByLibrary.simpleMessage("Ongedaan maken"),
    "userInfoRoute_avatar_change" : MessageLookupByLibrary.simpleMessage("Avatar wijzigen"),
    "userInfoRoute_avatar_remove" : MessageLookupByLibrary.simpleMessage("Avatar verwijderen"),
    "userInfoRoute_sortByDate" : MessageLookupByLibrary.simpleMessage("Sorteer notities op datum")
  };
}
