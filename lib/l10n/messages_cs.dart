// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a cs locale. All the
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
  String get localeName => 'cs';

  static m0(method, maxLength) => "${method} nesmí být delší než ${maxLength}";

  static m1(method, minLength) => "${method} nesmí být kratší než ${minLength}";

  static m2(path) => "Záloha se nachází na: ${path}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "archive" : MessageLookupByLibrary.simpleMessage("Archivovat"),
    "black" : MessageLookupByLibrary.simpleMessage("Černé"),
    "cancel" : MessageLookupByLibrary.simpleMessage("Zrušit"),
    "chooseAction" : MessageLookupByLibrary.simpleMessage("Vybrat akci"),
    "confirm" : MessageLookupByLibrary.simpleMessage("Potvrdit"),
    "dark" : MessageLookupByLibrary.simpleMessage("Tmavé"),
    "done" : MessageLookupByLibrary.simpleMessage("Hotovo"),
    "light" : MessageLookupByLibrary.simpleMessage("Světlé"),
    "modifyNotesRoute_color_change" : MessageLookupByLibrary.simpleMessage("Změnit barvu poznámky"),
    "modifyNotesRoute_color_dialogTitle" : MessageLookupByLibrary.simpleMessage("Výběr barvy poznámky"),
    "modifyNotesRoute_content" : MessageLookupByLibrary.simpleMessage("Obsah"),
    "modifyNotesRoute_image" : MessageLookupByLibrary.simpleMessage("Obrázek"),
    "modifyNotesRoute_image_add" : MessageLookupByLibrary.simpleMessage("Přidat obrázek"),
    "modifyNotesRoute_image_remove" : MessageLookupByLibrary.simpleMessage("Odstranit obrázek"),
    "modifyNotesRoute_image_update" : MessageLookupByLibrary.simpleMessage("Změnit obrázek"),
    "modifyNotesRoute_list" : MessageLookupByLibrary.simpleMessage("Seznam"),
    "modifyNotesRoute_list_entry" : MessageLookupByLibrary.simpleMessage("Položka"),
    "modifyNotesRoute_list_selectedEntries" : MessageLookupByLibrary.simpleMessage(" zaškrtnuté položky"),
    "modifyNotesRoute_reminder" : MessageLookupByLibrary.simpleMessage("Upozornění"),
    "modifyNotesRoute_reminder_add" : MessageLookupByLibrary.simpleMessage("Přidat upozornění"),
    "modifyNotesRoute_reminder_date" : MessageLookupByLibrary.simpleMessage("Datum"),
    "modifyNotesRoute_reminder_time" : MessageLookupByLibrary.simpleMessage("Čas"),
    "modifyNotesRoute_reminder_update" : MessageLookupByLibrary.simpleMessage("Změnit upozornění"),
    "modifyNotesRoute_security_dialog_lengthExceed" : m0,
    "modifyNotesRoute_security_dialog_lengthShort" : m1,
    "modifyNotesRoute_security_dialog_titlePassword" : MessageLookupByLibrary.simpleMessage("Nastavit nebo změnit heslo"),
    "modifyNotesRoute_security_dialog_titlePin" : MessageLookupByLibrary.simpleMessage("Nastavit nebo změnit PIN"),
    "modifyNotesRoute_security_dialog_valid" : MessageLookupByLibrary.simpleMessage(" platný"),
    "modifyNotesRoute_security_hideContent" : MessageLookupByLibrary.simpleMessage("Skrýt obsah poznámky na hlavní stránce"),
    "modifyNotesRoute_security_password" : MessageLookupByLibrary.simpleMessage("Heslo"),
    "modifyNotesRoute_security_pin" : MessageLookupByLibrary.simpleMessage("PIN"),
    "modifyNotesRoute_security_protectionText" : MessageLookupByLibrary.simpleMessage("Použít ochranu pro skrytí"),
    "modifyNotesRoute_title" : MessageLookupByLibrary.simpleMessage("Titulek"),
    "note_archive_snackbar" : MessageLookupByLibrary.simpleMessage("Poznámka archivována"),
    "note_delete" : MessageLookupByLibrary.simpleMessage("Odstranit"),
    "note_delete_snackbar" : MessageLookupByLibrary.simpleMessage("Poznámka odstraněna"),
    "note_edit" : MessageLookupByLibrary.simpleMessage("Upravit"),
    "note_emptryTrash" : MessageLookupByLibrary.simpleMessage("Vysypat koš"),
    "note_export" : MessageLookupByLibrary.simpleMessage("Exportovat"),
    "note_exportLocation" : MessageLookupByLibrary.simpleMessage("Poznámka exportována do"),
    "note_lockedOptions" : MessageLookupByLibrary.simpleMessage("Poznámka je uzamčena, použijte možnosti na obrazovce poznámky"),
    "note_pinToNotifs" : MessageLookupByLibrary.simpleMessage("Připnout do notifikací"),
    "note_removeFromArchive_snackbar" : MessageLookupByLibrary.simpleMessage("Poznámka odstraněna z archivu"),
    "note_restore_snackbar" : MessageLookupByLibrary.simpleMessage("Poznámka obnovena"),
    "note_select" : MessageLookupByLibrary.simpleMessage("Vybrat"),
    "note_share" : MessageLookupByLibrary.simpleMessage("Sdílet"),
    "note_star" : MessageLookupByLibrary.simpleMessage("Oblíbené"),
    "note_unstar" : MessageLookupByLibrary.simpleMessage("Odstranit z oblíbených"),
    "notes" : MessageLookupByLibrary.simpleMessage("Poznámky"),
    "notesMainPageRoute_emptyArchive" : MessageLookupByLibrary.simpleMessage("V archivu nemáte žádné poznámky"),
    "notesMainPageRoute_emptyTrash" : MessageLookupByLibrary.simpleMessage("Koš je prázdný"),
    "notesMainPageRoute_noNotes" : MessageLookupByLibrary.simpleMessage("Zatím nebyly přidány žádné poznámky"),
    "notesMainPageRoute_note_deleteDialog_content" : MessageLookupByLibrary.simpleMessage("Jakmile odstraníte poznámky, není možné je obnovit.\nOpravdu chcete pokračovat?"),
    "notesMainPageRoute_note_deleteDialog_title" : MessageLookupByLibrary.simpleMessage("Odstranit vybrané poznámky?"),
    "notesMainPageRoute_note_emptyTrash_content" : MessageLookupByLibrary.simpleMessage("Jakmile odstraníte poznámky, není možné je obnovit.\nOpravdu chcete pokračovat?"),
    "notesMainPageRoute_note_emptyTrash_title" : MessageLookupByLibrary.simpleMessage("Vysypat koš?"),
    "notesMainPageRoute_note_hiddenContent" : MessageLookupByLibrary.simpleMessage("Skrytý obsah"),
    "notesMainPageRoute_note_list_selectedEntries" : MessageLookupByLibrary.simpleMessage(" položek vybráno"),
    "notesMainPageRoute_note_remindersSet" : MessageLookupByLibrary.simpleMessage("Připomenutí nastavená pro poznámku"),
    "notesMainPageRoute_other" : MessageLookupByLibrary.simpleMessage("Ostatní poznámky"),
    "notesMainPageRoute_pinnedNote" : MessageLookupByLibrary.simpleMessage("Připnutá poznámka"),
    "notesMainPageRoute_starred" : MessageLookupByLibrary.simpleMessage("Oblíbené poznámky"),
    "notesMainPageRoute_writeNote" : MessageLookupByLibrary.simpleMessage("Napsat poznámku"),
    "notes_archive_snackbar" : MessageLookupByLibrary.simpleMessage("Poznámky archivovány"),
    "notes_delete_snackbar" : MessageLookupByLibrary.simpleMessage("Poznámky odstraněny"),
    "notes_removeFromArchive_snackbar" : MessageLookupByLibrary.simpleMessage("Poznámky odstraněny z archivu"),
    "notes_restore_snackbar" : MessageLookupByLibrary.simpleMessage("Poznámky obnoveny"),
    "remove" : MessageLookupByLibrary.simpleMessage("Odstranit"),
    "reset" : MessageLookupByLibrary.simpleMessage("Resetovat"),
    "save" : MessageLookupByLibrary.simpleMessage("Uložit"),
    "searchNotesRoute_filters_case" : MessageLookupByLibrary.simpleMessage("Rozlišit malá a velká písmena"),
    "searchNotesRoute_filters_color" : MessageLookupByLibrary.simpleMessage("Barevný filtr"),
    "searchNotesRoute_filters_date" : MessageLookupByLibrary.simpleMessage("Filtr data"),
    "searchNotesRoute_filters_title" : MessageLookupByLibrary.simpleMessage("Vyhledávací filtry"),
    "searchNotesRoute_noQuery" : MessageLookupByLibrary.simpleMessage("Vložte něco k zahájení hledání"),
    "searchNotesRoute_nothingFound" : MessageLookupByLibrary.simpleMessage("Nebyla nalezena žádná poznámka, která by odpovídala hledaným výrazům"),
    "searchNotesRoute_searchbar" : MessageLookupByLibrary.simpleMessage("Hledat..."),
    "securityNoteRoute_request_password" : MessageLookupByLibrary.simpleMessage("Pro otevření poznámky je požadováno heslo"),
    "securityNoteRoute_request_pin" : MessageLookupByLibrary.simpleMessage("K otevření poznámky je požadován kód PIN"),
    "securityNoteRoute_wrong_password" : MessageLookupByLibrary.simpleMessage("Chybné heslo"),
    "securityNoteRoute_wrong_pin" : MessageLookupByLibrary.simpleMessage("Nesprávný kód PIN"),
    "settingsRoute_about" : MessageLookupByLibrary.simpleMessage("O aplikaci"),
    "settingsRoute_about_potatonotes" : MessageLookupByLibrary.simpleMessage("O PotatoNotes"),
    "settingsRoute_about_potatonotes_design" : MessageLookupByLibrary.simpleMessage("Návrh, značkování aplikace a logo aplikace RshBfn"),
    "settingsRoute_about_potatonotes_development" : MessageLookupByLibrary.simpleMessage("Vyvinuto a aktualizováno HrX03"),
    "settingsRoute_about_sourceCode" : MessageLookupByLibrary.simpleMessage("Zdrojový kód PotatoNotes"),
    "settingsRoute_backupAndRestore" : MessageLookupByLibrary.simpleMessage("Záloha a obnova"),
    "settingsRoute_backupAndRestore_backup" : MessageLookupByLibrary.simpleMessage("Zálohovat (Experimentální)"),
    "settingsRoute_backupAndRestore_backup_done" : m2,
    "settingsRoute_backupAndRestore_regenDbEntries" : MessageLookupByLibrary.simpleMessage("Znovu vygenerovat záznamy v databázi"),
    "settingsRoute_backupAndRestore_restore" : MessageLookupByLibrary.simpleMessage("Obnovit (Experimentální)"),
    "settingsRoute_backupAndRestore_restore_fail" : MessageLookupByLibrary.simpleMessage("Poškozeno nebo neplatné DB!"),
    "settingsRoute_backupAndRestore_restore_success" : MessageLookupByLibrary.simpleMessage("Hotovo!"),
    "settingsRoute_dev" : MessageLookupByLibrary.simpleMessage("Možnosti pro vývojáře"),
    "settingsRoute_dev_idLabels" : MessageLookupByLibrary.simpleMessage("Zobrazit štítky"),
    "settingsRoute_gestures" : MessageLookupByLibrary.simpleMessage("Gesta"),
    "settingsRoute_gestures_quickStar" : MessageLookupByLibrary.simpleMessage("Dvojí poklepání na poznámku pro přidání do oblíbených"),
    "settingsRoute_themes" : MessageLookupByLibrary.simpleMessage("Motivy vzhledu"),
    "settingsRoute_themes_appTheme" : MessageLookupByLibrary.simpleMessage("Vzhled aplikace"),
    "settingsRoute_themes_customAccentColor" : MessageLookupByLibrary.simpleMessage("Vlastní barva"),
    "settingsRoute_themes_followSystem" : MessageLookupByLibrary.simpleMessage("Podle motivu systému"),
    "settingsRoute_themes_systemDarkMode" : MessageLookupByLibrary.simpleMessage("Automatický tmavý motiv"),
    "settingsRoute_themes_useCustomAccent" : MessageLookupByLibrary.simpleMessage("Použít vlastní barvu zvýraznění"),
    "settingsRoute_title" : MessageLookupByLibrary.simpleMessage("Nastavení"),
    "trash" : MessageLookupByLibrary.simpleMessage("Koš"),
    "undo" : MessageLookupByLibrary.simpleMessage("Zpět"),
    "userInfoRoute_avatar_change" : MessageLookupByLibrary.simpleMessage("Změnit profilový obrázek"),
    "userInfoRoute_avatar_remove" : MessageLookupByLibrary.simpleMessage("Odstranit profilový obrázek"),
    "userInfoRoute_sortByDate" : MessageLookupByLibrary.simpleMessage("Seřadit poznámky podle data")
  };
}
