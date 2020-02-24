// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a de locale. All the
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
  String get localeName => 'de';

  static m0(method, maxLength) =>
      "${method} Länge darf ${maxLength} nicht überschreiten";

  static m1(method, minLength) =>
      "${method} Länge darf nicht kürzer als ${minLength} sein";

  static m2(path) => "Backup in Pfad: ${path}";

  static m3(username) => "Angemeldet als: ${username}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
        "archive": MessageLookupByLibrary.simpleMessage("Archiv"),
        "black": MessageLookupByLibrary.simpleMessage("Schwarz"),
        "cancel": MessageLookupByLibrary.simpleMessage("Abbrechen"),
        "chooseAction": MessageLookupByLibrary.simpleMessage("Aktion wählen"),
        "confirm": MessageLookupByLibrary.simpleMessage("Bestätigen"),
        "dark": MessageLookupByLibrary.simpleMessage("Dunkel"),
        "done": MessageLookupByLibrary.simpleMessage("Fertig"),
        "home": MessageLookupByLibrary.simpleMessage("Hauptseite"),
        "light": MessageLookupByLibrary.simpleMessage("Hell"),
        "modifyNotesRoute_color_change":
            MessageLookupByLibrary.simpleMessage("Notizfarbe ändern"),
        "modifyNotesRoute_color_dialogTitle":
            MessageLookupByLibrary.simpleMessage("Notizfarbenauswahl"),
        "modifyNotesRoute_content":
            MessageLookupByLibrary.simpleMessage("Inhalt"),
        "modifyNotesRoute_image": MessageLookupByLibrary.simpleMessage("Bild"),
        "modifyNotesRoute_image_add":
            MessageLookupByLibrary.simpleMessage("Profilbild hinzufügen"),
        "modifyNotesRoute_image_remove":
            MessageLookupByLibrary.simpleMessage("Bild entfernen"),
        "modifyNotesRoute_image_update":
            MessageLookupByLibrary.simpleMessage("Profilbild Aktualisieren"),
        "modifyNotesRoute_list": MessageLookupByLibrary.simpleMessage("Liste"),
        "modifyNotesRoute_list_entry":
            MessageLookupByLibrary.simpleMessage("Eintrag"),
        "modifyNotesRoute_list_selectedEntries":
            MessageLookupByLibrary.simpleMessage(" überprüfte Einträge"),
        "modifyNotesRoute_reminder":
            MessageLookupByLibrary.simpleMessage("Erinnern"),
        "modifyNotesRoute_reminder_add":
            MessageLookupByLibrary.simpleMessage("Neue erinnerung hinzufügen"),
        "modifyNotesRoute_reminder_date":
            MessageLookupByLibrary.simpleMessage("Datum"),
        "modifyNotesRoute_reminder_time":
            MessageLookupByLibrary.simpleMessage("Zeit"),
        "modifyNotesRoute_reminder_update":
            MessageLookupByLibrary.simpleMessage("Erinnerungen aktualisieren"),
        "modifyNotesRoute_security_dialog_lengthExceed": m0,
        "modifyNotesRoute_security_dialog_lengthShort": m1,
        "modifyNotesRoute_security_dialog_titlePassword":
            MessageLookupByLibrary.simpleMessage(
                "Passwort festlegen oder aktualisieren"),
        "modifyNotesRoute_security_dialog_titlePin":
            MessageLookupByLibrary.simpleMessage(
                "PIN festlegen oder aktualisieren"),
        "modifyNotesRoute_security_dialog_valid":
            MessageLookupByLibrary.simpleMessage(" gültig"),
        "modifyNotesRoute_security_hideContent":
            MessageLookupByLibrary.simpleMessage(
                "Notizen Inhalt auf Hauptbildschirm"),
        "modifyNotesRoute_security_password":
            MessageLookupByLibrary.simpleMessage("Passwort"),
        "modifyNotesRoute_security_pin":
            MessageLookupByLibrary.simpleMessage("PIN"),
        "modifyNotesRoute_security_protectionText":
            MessageLookupByLibrary.simpleMessage(
                "Verwende einen Schutz zum Verstecken"),
        "modifyNotesRoute_title": MessageLookupByLibrary.simpleMessage("Titel"),
        "note_archive_snackbar":
            MessageLookupByLibrary.simpleMessage("Notiz archiviert"),
        "note_delete": MessageLookupByLibrary.simpleMessage("Löschen"),
        "note_delete_snackbar":
            MessageLookupByLibrary.simpleMessage("Notiz gelöscht"),
        "note_edit": MessageLookupByLibrary.simpleMessage("Bearbeiten"),
        "note_emptyTrash":
            MessageLookupByLibrary.simpleMessage("Papierkorb leeren"),
        "note_export": MessageLookupByLibrary.simpleMessage("Exportieren"),
        "note_exportLocation":
            MessageLookupByLibrary.simpleMessage("Notiz exportiert am"),
        "note_lockedOptions": MessageLookupByLibrary.simpleMessage(
            "Notiz ist gesperrt, verwenden Sie die Optionen auf dem Notizbildschirm"),
        "note_pinToNotifs": MessageLookupByLibrary.simpleMessage(
            "An Benachrichtigungen anheften"),
        "note_removeFromArchive_snackbar":
            MessageLookupByLibrary.simpleMessage("Notiz aus Archiv entfernt"),
        "note_restore_snackbar":
            MessageLookupByLibrary.simpleMessage("Notiz wiederhergestellt"),
        "note_select": MessageLookupByLibrary.simpleMessage("Auswählen"),
        "note_share": MessageLookupByLibrary.simpleMessage("Teilen"),
        "note_star":
            MessageLookupByLibrary.simpleMessage("Mit Stern markieren"),
        "note_unstar":
            MessageLookupByLibrary.simpleMessage("Stern-Markierung entfernen"),
        "notesMainPageRoute_emptyArchive": MessageLookupByLibrary.simpleMessage(
            "Sie haben keine Notizen im Archiv"),
        "notesMainPageRoute_emptyTrash":
            MessageLookupByLibrary.simpleMessage("Ihr Papierkorb ist leer"),
        "notesMainPageRoute_noNotes": MessageLookupByLibrary.simpleMessage(
            "Keine notizen hinzugefügt... bisher"),
        "notesMainPageRoute_note_deleteDialog_content":
            MessageLookupByLibrary.simpleMessage(
                "Sobald die Notizen von hier gelöscht wurden, können Sie sie nicht wiederherstellen.\nSind Sie sicher, dass Sie fortfahren möchten?"),
        "notesMainPageRoute_note_deleteDialog_title":
            MessageLookupByLibrary.simpleMessage(
                "Ausgewählte Notizen löschen?"),
        "notesMainPageRoute_note_emptyTrash_content":
            MessageLookupByLibrary.simpleMessage(
                "Sobald die Notizen von hier gelöscht wurden, können Sie sie nicht wiederherstellen.\nSind Sie sicher, dass Sie fortfahren möchten?"),
        "notesMainPageRoute_note_emptyTrash_title":
            MessageLookupByLibrary.simpleMessage("Papierkorb leeren?"),
        "notesMainPageRoute_note_hiddenContent":
            MessageLookupByLibrary.simpleMessage("Inhalt versteckt"),
        "notesMainPageRoute_note_list_selectedEntries":
            MessageLookupByLibrary.simpleMessage(" einträge ausgewählt"),
        "notesMainPageRoute_note_remindersSet":
            MessageLookupByLibrary.simpleMessage(
                "Erinnerungen für Notizen setzen"),
        "notesMainPageRoute_other":
            MessageLookupByLibrary.simpleMessage("Andere Notizen"),
        "notesMainPageRoute_pinnedNote":
            MessageLookupByLibrary.simpleMessage("Angeheftete Notizen"),
        "notesMainPageRoute_starred":
            MessageLookupByLibrary.simpleMessage("Wichtig Notizen"),
        "notesMainPageRoute_writeNote":
            MessageLookupByLibrary.simpleMessage("Notiz schreiben"),
        "notes_archive_snackbar":
            MessageLookupByLibrary.simpleMessage("Notizen archiviert"),
        "notes_delete_snackbar":
            MessageLookupByLibrary.simpleMessage("Notizen gelöscht"),
        "notes_removeFromArchive_snackbar":
            MessageLookupByLibrary.simpleMessage("Notizen aus Archiv entfernt"),
        "notes_restore_snackbar":
            MessageLookupByLibrary.simpleMessage("Notizen wiederhergestellt"),
        "remove": MessageLookupByLibrary.simpleMessage("Entfernen"),
        "reset": MessageLookupByLibrary.simpleMessage("Zurücksetzen"),
        "save": MessageLookupByLibrary.simpleMessage("Speichern"),
        "searchNotesRoute_filters_case": MessageLookupByLibrary.simpleMessage(
            "Unterscheide Groß-/Kleinschreibung"),
        "searchNotesRoute_filters_color":
            MessageLookupByLibrary.simpleMessage("Farbfilter"),
        "searchNotesRoute_filters_date":
            MessageLookupByLibrary.simpleMessage("Datumsfilter"),
        "searchNotesRoute_filters_title":
            MessageLookupByLibrary.simpleMessage("Suchfilter"),
        "searchNotesRoute_noQuery": MessageLookupByLibrary.simpleMessage(
            "Geben Sie etwas ein, um die Suche zu starten"),
        "searchNotesRoute_nothingFound": MessageLookupByLibrary.simpleMessage(
            "Keine Notizen gefunden, die mit Ihren Suchbegriffen übereinstimmen"),
        "searchNotesRoute_searchbar":
            MessageLookupByLibrary.simpleMessage("Suchen..."),
        "securityNoteRoute_request_password":
            MessageLookupByLibrary.simpleMessage(
                "Zum Öffnen der Notiz wird ein Passwort angefordert"),
        "securityNoteRoute_request_pin": MessageLookupByLibrary.simpleMessage(
            "Zum Öffnen der Notiz wird eine PIN angefordert"),
        "securityNoteRoute_wrong_password":
            MessageLookupByLibrary.simpleMessage("Falsches Passwort"),
        "securityNoteRoute_wrong_pin":
            MessageLookupByLibrary.simpleMessage("Falsche PIN"),
        "settingsRoute_about": MessageLookupByLibrary.simpleMessage("Über uns"),
        "settingsRoute_about_potatonotes":
            MessageLookupByLibrary.simpleMessage("Über PotatoNotes"),
        "settingsRoute_about_potatonotes_design":
            MessageLookupByLibrary.simpleMessage(
                "Design, App-Branding und App-Logo von RshBfn"),
        "settingsRoute_about_potatonotes_development":
            MessageLookupByLibrary.simpleMessage(
                "Entwickelt und betreut von HrX03"),
        "settingsRoute_about_sourceCode":
            MessageLookupByLibrary.simpleMessage("PotatoNotes Quellcode"),
        "settingsRoute_backupAndRestore":
            MessageLookupByLibrary.simpleMessage("Sichern & Wiederherstellen"),
        "settingsRoute_backupAndRestore_backup":
            MessageLookupByLibrary.simpleMessage("Sichern (experimentell)"),
        "settingsRoute_backupAndRestore_backup_done": m2,
        "settingsRoute_backupAndRestore_regenDbEntries":
            MessageLookupByLibrary.simpleMessage(
                "Datenbankeinträge neu generieren"),
        "settingsRoute_backupAndRestore_restore":
            MessageLookupByLibrary.simpleMessage(
                "Wiederherstellen (experimentell)"),
        "settingsRoute_backupAndRestore_restore_fail":
            MessageLookupByLibrary.simpleMessage(
                "Beschädigte oder ungültige DB!"),
        "settingsRoute_backupAndRestore_restore_success":
            MessageLookupByLibrary.simpleMessage("Fertig!"),
        "settingsRoute_dev":
            MessageLookupByLibrary.simpleMessage("Entwickleroptionen"),
        "settingsRoute_dev_idLabels":
            MessageLookupByLibrary.simpleMessage("ID-Labels anzeigen"),
        "settingsRoute_gestures":
            MessageLookupByLibrary.simpleMessage("Gesten"),
        "settingsRoute_gestures_quickStar":
            MessageLookupByLibrary.simpleMessage(
                "Doppeltippen auf Notiz zum mit Stern zu markieren"),
        "settingsRoute_themes": MessageLookupByLibrary.simpleMessage("Themen"),
        "settingsRoute_themes_appTheme":
            MessageLookupByLibrary.simpleMessage("App-Thema"),
        "settingsRoute_themes_customAccentColor":
            MessageLookupByLibrary.simpleMessage("Benutzerdefinierte Farbe"),
        "settingsRoute_themes_followSystem":
            MessageLookupByLibrary.simpleMessage("System-Thema folgen"),
        "settingsRoute_themes_systemDarkMode":
            MessageLookupByLibrary.simpleMessage("Nachtmodus-Thema"),
        "settingsRoute_themes_useCustomAccent":
            MessageLookupByLibrary.simpleMessage(
                "Verwende benutzerdefinierte Akzentfarbe"),
        "settingsRoute_title":
            MessageLookupByLibrary.simpleMessage("Einstellungen"),
        "syncLoginRoute_emailOrUsername":
            MessageLookupByLibrary.simpleMessage("E-Mail oder Nutzername"),
        "syncLoginRoute_emptyField": MessageLookupByLibrary.simpleMessage(
            "Dieses Feld darf nicht leer sein!"),
        "syncLoginRoute_login":
            MessageLookupByLibrary.simpleMessage("Anmeldung"),
        "syncLoginRoute_noteConflictDialog_content":
            MessageLookupByLibrary.simpleMessage(
                "Konflikt zwischen gespeicherten und synchronisierten Notizen. Was möchten Sie tun?"),
        "syncLoginRoute_noteConflictDialog_keep":
            MessageLookupByLibrary.simpleMessage(
                "Aktuelle behalten und hochladen"),
        "syncLoginRoute_noteConflictDialog_replace":
            MessageLookupByLibrary.simpleMessage(
                "Ersetze gespeicherte mit Cloud"),
        "syncLoginRoute_noteConflictDialog_title":
            MessageLookupByLibrary.simpleMessage(
                "Notizen auf Ihrem Konto gefunden"),
        "syncLoginRoute_password":
            MessageLookupByLibrary.simpleMessage("Passwort"),
        "syncLoginRoute_register":
            MessageLookupByLibrary.simpleMessage("Registrieren"),
        "syncLoginRoute_successfulRegistration":
            MessageLookupByLibrary.simpleMessage("Erfolgreich registriert"),
        "syncManageRoute_account":
            MessageLookupByLibrary.simpleMessage("Konto"),
        "syncManageRoute_account_changeImage":
            MessageLookupByLibrary.simpleMessage("Bild ändern"),
        "syncManageRoute_account_changeUsername":
            MessageLookupByLibrary.simpleMessage("Benutzername ändern"),
        "syncManageRoute_account_guest":
            MessageLookupByLibrary.simpleMessage("Gast"),
        "syncManageRoute_account_loggedInAs": m3,
        "syncManageRoute_account_logout":
            MessageLookupByLibrary.simpleMessage("Abmelden"),
        "syncManageRoute_sync":
            MessageLookupByLibrary.simpleMessage("Synchronisieren"),
        "syncManageRoute_sync_autoSyncInterval":
            MessageLookupByLibrary.simpleMessage(
                "Auto-Sync Zeitintervall (Sekunden)"),
        "syncManageRoute_sync_enableAutoSync":
            MessageLookupByLibrary.simpleMessage("Auto-Sync aktivieren"),
        "syncRegisterRoute_confirmPassword":
            MessageLookupByLibrary.simpleMessage("Passwort bestätigen"),
        "syncRegisterRoute_confirmPassword_noMatch":
            MessageLookupByLibrary.simpleMessage(
                "Passwörter stimmen nicht überein"),
        "syncRegisterRoute_email":
            MessageLookupByLibrary.simpleMessage("E-Mail"),
        "syncRegisterRoute_email_empty":
            MessageLookupByLibrary.simpleMessage("Name darf nicht leer sein"),
        "syncRegisterRoute_email_invalidFormat":
            MessageLookupByLibrary.simpleMessage("Ungültiges E-Mail-Format"),
        "syncRegisterRoute_password":
            MessageLookupByLibrary.simpleMessage("Passwort"),
        "syncRegisterRoute_password_empty":
            MessageLookupByLibrary.simpleMessage(
                "Passwort darf nicht leer sein"),
        "syncRegisterRoute_register":
            MessageLookupByLibrary.simpleMessage("Registrieren"),
        "syncRegisterRoute_username":
            MessageLookupByLibrary.simpleMessage("Benutzername"),
        "syncRegisterRoute_username_empty":
            MessageLookupByLibrary.simpleMessage(
                "Benutzername darf nicht leer sein"),
        "sync_accNotFoundError": MessageLookupByLibrary.simpleMessage(
            "Das Konto wurde nicht gefunden"),
        "sync_dbConnectionError": MessageLookupByLibrary.simpleMessage(
            "Beim Verbinden mit der Datenbank ist ein Problem aufgetreten, versuche es später erneut"),
        "sync_emailAlreadyExistsError": MessageLookupByLibrary.simpleMessage(
            "Die eingegebene E-Mail scheint bereits registriert zu sein"),
        "sync_invalidCredentialsError": MessageLookupByLibrary.simpleMessage(
            "Falsche Kombination von Benutzername/E-Mail und Passwort"),
        "sync_malformedEmailError": MessageLookupByLibrary.simpleMessage(
            "Falsche oder fehlende E-Mail"),
        "sync_missingNoteIdError": MessageLookupByLibrary.simpleMessage(
            "Sie können keine Notiz ohne ID erstellen"),
        "sync_notFoundError": MessageLookupByLibrary.simpleMessage(
            "Das Konto wurde nicht gefunden"),
        "sync_outOfBoundsError": MessageLookupByLibrary.simpleMessage(
            "Die Eingabe ist zu lang oder zu kurz"),
        "sync_passOutOfBoundsError": MessageLookupByLibrary.simpleMessage(
            "Das eingegebene Passwort ist zu lang oder zu kurz"),
        "sync_userNotFoundError": MessageLookupByLibrary.simpleMessage(
            "Der Benutzer wurde nicht gefunden"),
        "sync_usernameAlreadyExistsError": MessageLookupByLibrary.simpleMessage(
            "Der eingegebene Benutzername scheint bereits registriert zu sein"),
        "sync_usernameNotFoundError": MessageLookupByLibrary.simpleMessage(
            "Dieser Benutzername ist nicht registriert"),
        "sync_usernameOutOfBoundsError": MessageLookupByLibrary.simpleMessage(
            "Der eingegebene Benutzername ist zu lang oder zu kurz"),
        "trash": MessageLookupByLibrary.simpleMessage("Papierkorb"),
        "undo": MessageLookupByLibrary.simpleMessage("Rückgängig machen"),
        "userInfoRoute_avatar_change":
            MessageLookupByLibrary.simpleMessage("Profilbild ändern"),
        "userInfoRoute_avatar_remove":
            MessageLookupByLibrary.simpleMessage("Profilbild entfernen"),
        "userInfoRoute_sortByDate": MessageLookupByLibrary.simpleMessage(
            "Notizen nach Datum sortieren"),
        "welcomeRoute_firstPage_catchPhrase":
            MessageLookupByLibrary.simpleMessage(
                "Ihre neue Lieblings-Notiz-App"),
        "welcomeRoute_fourthPage_description": MessageLookupByLibrary.simpleMessage(
            "Und damit bist du endlich fertig! Jetzt kannst du endlich Spaß haben!"),
        "welcomeRoute_fourthPage_thankyou":
            MessageLookupByLibrary.simpleMessage(
                "Danke, dass du PotatoNotes gewählt hast"),
        "welcomeRoute_fourthPage_title":
            MessageLookupByLibrary.simpleMessage("Einrichtung abgeschlossen"),
        "welcomeRoute_secondPage_title":
            MessageLookupByLibrary.simpleMessage("Grundlegende Anpassungen"),
        "welcomeRoute_thirdPage_description": MessageLookupByLibrary.simpleMessage(
            "Mit einem kostenlosen PotatoSync-Konto kannst du deine Notizen zwischen mehreren Geräten synchronisieren. Und es ist super einfach, eins zu erstellen!"),
        "welcomeRoute_thirdPage_getStarted":
            MessageLookupByLibrary.simpleMessage("Los geht\'s"),
        "welcomeRoute_thirdPage_success": MessageLookupByLibrary.simpleMessage(
            "PotatoSync wurde erfolgreich konfiguriert. Gut gemacht!")
      };
}
