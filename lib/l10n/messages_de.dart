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
      "${method} lengte kan niet groter zijn dan ${maxLength}";

  static m1(method, minLength) =>
      "${method} lengte kan niet kleiner zijn dan ${minLength}";

  static m2(noteSelected) => "${noteSelected} notitie geselecteerd";

  static m3(noteSelected) => "${noteSelected} notities geselecteerd";

  static m4(currentPage, totalPages) =>
      "Pagina ${currentPage} van ${totalPages}";

  static m5(path) => "Back-up in: ${path}";

  static m6(username) => "Ingelogd als: ${username}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
        "archive": MessageLookupByLibrary.simpleMessage("Archiveren"),
        "black": MessageLookupByLibrary.simpleMessage("Zwart"),
        "cancel": MessageLookupByLibrary.simpleMessage("Annuleren"),
        "chooseAction": MessageLookupByLibrary.simpleMessage("Kies een actie"),
        "close": MessageLookupByLibrary.simpleMessage("Sluiten"),
        "confirm": MessageLookupByLibrary.simpleMessage("Bevestigen"),
        "dark": MessageLookupByLibrary.simpleMessage("Donker"),
        "done": MessageLookupByLibrary.simpleMessage("Gereed"),
        "home": MessageLookupByLibrary.simpleMessage("Startpagina"),
        "light": MessageLookupByLibrary.simpleMessage("Licht"),
        "modifyNotesRoute_color_change":
            MessageLookupByLibrary.simpleMessage("Wijzig notitiekleur"),
        "modifyNotesRoute_color_dialogTitle":
            MessageLookupByLibrary.simpleMessage("Selecteer notitiekleur"),
        "modifyNotesRoute_content":
            MessageLookupByLibrary.simpleMessage("Inhoud"),
        "modifyNotesRoute_image":
            MessageLookupByLibrary.simpleMessage("Afbeelding"),
        "modifyNotesRoute_image_add":
            MessageLookupByLibrary.simpleMessage("Voeg afbeelding toe"),
        "modifyNotesRoute_image_remove":
            MessageLookupByLibrary.simpleMessage("Verwijder afbeelding"),
        "modifyNotesRoute_image_update":
            MessageLookupByLibrary.simpleMessage("Werk afbeelding bij"),
        "modifyNotesRoute_list": MessageLookupByLibrary.simpleMessage("Lijst"),
        "modifyNotesRoute_list_entry":
            MessageLookupByLibrary.simpleMessage("Invoer"),
        "modifyNotesRoute_list_selectedEntries":
            MessageLookupByLibrary.simpleMessage(" afgevinkte items"),
        "modifyNotesRoute_reminder":
            MessageLookupByLibrary.simpleMessage("Herinnering"),
        "modifyNotesRoute_reminder_add": MessageLookupByLibrary.simpleMessage(
            "Voeg een nieuwe herinnering toe"),
        "modifyNotesRoute_reminder_date":
            MessageLookupByLibrary.simpleMessage("Datum"),
        "modifyNotesRoute_reminder_time":
            MessageLookupByLibrary.simpleMessage("Tijd"),
        "modifyNotesRoute_reminder_update":
            MessageLookupByLibrary.simpleMessage("Herinnering bijwerken"),
        "modifyNotesRoute_security_dialog_lengthExceed": m0,
        "modifyNotesRoute_security_dialog_lengthShort": m1,
        "modifyNotesRoute_security_dialog_titlePassword":
            MessageLookupByLibrary.simpleMessage(
                "Wachtwoord instellen of bijwerken"),
        "modifyNotesRoute_security_dialog_titlePin":
            MessageLookupByLibrary.simpleMessage(
                "Pincode instellen of bijwerken"),
        "modifyNotesRoute_security_dialog_valid":
            MessageLookupByLibrary.simpleMessage(" geldig"),
        "modifyNotesRoute_security_hideContent":
            MessageLookupByLibrary.simpleMessage(
                "Verberg notitieinhoud op hoofdpagina"),
        "modifyNotesRoute_security_password":
            MessageLookupByLibrary.simpleMessage("Wachtwoord"),
        "modifyNotesRoute_security_pin":
            MessageLookupByLibrary.simpleMessage("Pincode"),
        "modifyNotesRoute_security_protectionText":
            MessageLookupByLibrary.simpleMessage("Beveilig het verbergen"),
        "modifyNotesRoute_title": MessageLookupByLibrary.simpleMessage("Titel"),
        "note_archive_snackbar":
            MessageLookupByLibrary.simpleMessage("Notitie gearchiveerd"),
        "note_delete": MessageLookupByLibrary.simpleMessage("Verwijder"),
        "note_delete_snackbar":
            MessageLookupByLibrary.simpleMessage("Notitie verwijderd"),
        "note_edit": MessageLookupByLibrary.simpleMessage("Bewerk"),
        "note_emptyTrash":
            MessageLookupByLibrary.simpleMessage("Prullenbak leegmaken"),
        "note_export": MessageLookupByLibrary.simpleMessage("Exporteren"),
        "note_exportLocation":
            MessageLookupByLibrary.simpleMessage("Notitie geëxporteerd op"),
        "note_lockedOptions": MessageLookupByLibrary.simpleMessage(
            "Notitie is vergrendeld, gebruik de opties op het notitiescherm"),
        "note_pinToNotifs": MessageLookupByLibrary.simpleMessage(
            "Maak notitie vast aan meldingen"),
        "note_removeFromArchive_snackbar": MessageLookupByLibrary.simpleMessage(
            "Notitie verwijderd uit gearchiveerd"),
        "note_restore_snackbar":
            MessageLookupByLibrary.simpleMessage("Notitie hersteld"),
        "note_select": MessageLookupByLibrary.simpleMessage("Selecteer"),
        "note_share": MessageLookupByLibrary.simpleMessage("Delen"),
        "note_star": MessageLookupByLibrary.simpleMessage("Voeg ster toe"),
        "note_unstar": MessageLookupByLibrary.simpleMessage("Verwijder ster"),
        "notesMainPageRoute_emptyArchive": MessageLookupByLibrary.simpleMessage(
            "U heeft geen notities in uw archief"),
        "notesMainPageRoute_emptyTrash":
            MessageLookupByLibrary.simpleMessage("Je prullenbak is leeg"),
        "notesMainPageRoute_noNotes": MessageLookupByLibrary.simpleMessage(
            "Nog geen notities toegevoegd..."),
        "notesMainPageRoute_note_deleteDialog_content":
            MessageLookupByLibrary.simpleMessage(
                "Als je de notities verwijderd kun je ze niet meer herstellen.\nWeet je het zeker dat je verder wilt gaan?"),
        "notesMainPageRoute_note_deleteDialog_title":
            MessageLookupByLibrary.simpleMessage(
                "Geselecteerde notities verwijderen?"),
        "notesMainPageRoute_note_emptyTrash_content":
            MessageLookupByLibrary.simpleMessage(
                "Als je de notities verweiderd kun je ze niet meer herstellen.\nWeet je het zeker dat je veder wilt gaan?"),
        "notesMainPageRoute_note_emptyTrash_title":
            MessageLookupByLibrary.simpleMessage("Prullenbak legen?"),
        "notesMainPageRoute_note_hiddenContent":
            MessageLookupByLibrary.simpleMessage("Verborgen inhoud"),
        "notesMainPageRoute_note_list_selectedEntries":
            MessageLookupByLibrary.simpleMessage(" items geselecteerd"),
        "notesMainPageRoute_note_remindersSet":
            MessageLookupByLibrary.simpleMessage(
                "Herinneringen ingesteld voor notitie"),
        "notesMainPageRoute_other":
            MessageLookupByLibrary.simpleMessage("Andere notities"),
        "notesMainPageRoute_pinnedNote":
            MessageLookupByLibrary.simpleMessage("Vastgemaakte notitie"),
        "notesMainPageRoute_starred":
            MessageLookupByLibrary.simpleMessage("Items met ster"),
        "notesMainPageRoute_writeNote":
            MessageLookupByLibrary.simpleMessage("Maak een notitie"),
        "notes_archive_snackbar":
            MessageLookupByLibrary.simpleMessage("Notitie gearchiveerd"),
        "notes_delete_snackbar":
            MessageLookupByLibrary.simpleMessage("Notities verwijderd"),
        "notes_removeFromArchive_snackbar":
            MessageLookupByLibrary.simpleMessage(
                "Notitie verwijderd uit gearchiveerd"),
        "notes_restore_snackbar":
            MessageLookupByLibrary.simpleMessage("Notitie hersteld"),
        "remove": MessageLookupByLibrary.simpleMessage("Verwijderen"),
        "reset": MessageLookupByLibrary.simpleMessage("Standaardwaarden"),
        "save": MessageLookupByLibrary.simpleMessage("Opslaan"),
        "searchNotesRoute_filters_case":
            MessageLookupByLibrary.simpleMessage("Hoofdlettergevoelig"),
        "searchNotesRoute_filters_color":
            MessageLookupByLibrary.simpleMessage("Kleurfilter"),
        "searchNotesRoute_filters_date":
            MessageLookupByLibrary.simpleMessage("Datumfilter"),
        "searchNotesRoute_filters_title":
            MessageLookupByLibrary.simpleMessage("Zoekfilters"),
        "searchNotesRoute_noQuery": MessageLookupByLibrary.simpleMessage(
            "Voer iets in om te beginnen met zoeken"),
        "searchNotesRoute_nothingFound": MessageLookupByLibrary.simpleMessage(
            "Geen notities gevonden die overeenkomen met uw zoektermen"),
        "searchNotesRoute_searchbar":
            MessageLookupByLibrary.simpleMessage("Zoeken..."),
        "securityNoteRoute_request_password":
            MessageLookupByLibrary.simpleMessage(
                "Een wachtwoord is nodig om de notitie te openen"),
        "securityNoteRoute_request_pin": MessageLookupByLibrary.simpleMessage(
            "Een PIN is nodig om de notitie te openen"),
        "securityNoteRoute_wrong_password":
            MessageLookupByLibrary.simpleMessage("Onjuist wachtwoord"),
        "securityNoteRoute_wrong_pin":
            MessageLookupByLibrary.simpleMessage("Onjuiste PIN"),
        "semantics_back": MessageLookupByLibrary.simpleMessage("Terug"),
        "semantics_color_beige": MessageLookupByLibrary.simpleMessage("Beige"),
        "semantics_color_blue": MessageLookupByLibrary.simpleMessage("Blauw"),
        "semantics_color_green": MessageLookupByLibrary.simpleMessage("Groen"),
        "semantics_color_none": MessageLookupByLibrary.simpleMessage("Geen"),
        "semantics_color_orange":
            MessageLookupByLibrary.simpleMessage("Oranje"),
        "semantics_color_pink": MessageLookupByLibrary.simpleMessage("Roze"),
        "semantics_color_purple": MessageLookupByLibrary.simpleMessage("Paars"),
        "semantics_color_yellow": MessageLookupByLibrary.simpleMessage("Geel"),
        "semantics_hideText":
            MessageLookupByLibrary.simpleMessage("Verberg Tekst"),
        "semantics_modifyNotes_addElement":
            MessageLookupByLibrary.simpleMessage("Element toevoegen"),
        "semantics_modifyNotes_image":
            MessageLookupByLibrary.simpleMessage("Notitie afbeelding"),
        "semantics_modifyNotes_security":
            MessageLookupByLibrary.simpleMessage("Beveiligingsopties"),
        "semantics_modifyNotes_star":
            MessageLookupByLibrary.simpleMessage("Ster notitie"),
        "semantics_modifyNotes_unstar":
            MessageLookupByLibrary.simpleMessage("Ster verwijderen"),
        "semantics_notesMainPage_addNote":
            MessageLookupByLibrary.simpleMessage("Voeg een nieuwe notitie toe"),
        "semantics_notesMainPage_archive": MessageLookupByLibrary.simpleMessage(
            "Geselecteerde notities archiveren"),
        "semantics_notesMainPage_changeColor":
            MessageLookupByLibrary.simpleMessage("Notitie kleur wijzigen"),
        "semantics_notesMainPage_closeSelector":
            MessageLookupByLibrary.simpleMessage("Sluit kiezer"),
        "semantics_notesMainPage_delete": MessageLookupByLibrary.simpleMessage(
            "Geselecteerde notities verwijderen"),
        "semantics_notesMainPage_favouritesAdd":
            MessageLookupByLibrary.simpleMessage(
                "Notities toevoegen aan favorieten"),
        "semantics_notesMainPage_favouritesRemove":
            MessageLookupByLibrary.simpleMessage(
                "Notities uit favorieten verwijderen"),
        "semantics_notesMainPage_grid": MessageLookupByLibrary.simpleMessage(
            "Schakel over naar rasterweergave"),
        "semantics_notesMainPage_list": MessageLookupByLibrary.simpleMessage(
            "Schakel over naar lijstweergave"),
        "semantics_notesMainPage_noteSelected": m2,
        "semantics_notesMainPage_notesSelected": m3,
        "semantics_notesMainPage_openMenu":
            MessageLookupByLibrary.simpleMessage("Menu openen"),
        "semantics_notesMainPage_restore": MessageLookupByLibrary.simpleMessage(
            "Geselecteerde notities herstellen"),
        "semantics_notesMainPage_search":
            MessageLookupByLibrary.simpleMessage("Notities zoeken"),
        "semantics_showText":
            MessageLookupByLibrary.simpleMessage("Toon tekst"),
        "semantics_welcome_exit":
            MessageLookupByLibrary.simpleMessage("Setup afsluiten"),
        "semantics_welcome_next":
            MessageLookupByLibrary.simpleMessage("Volgende pagina"),
        "semantics_welcome_pageIndicator": m4,
        "semantics_welcome_previous":
            MessageLookupByLibrary.simpleMessage("Vorige pagina"),
        "settingsRoute_about": MessageLookupByLibrary.simpleMessage("Over"),
        "settingsRoute_about_potatonotes":
            MessageLookupByLibrary.simpleMessage("Over PotatoNotes"),
        "settingsRoute_about_potatonotes_design":
            MessageLookupByLibrary.simpleMessage(
                "Ontwerp, design en logo door RshBfn"),
        "settingsRoute_about_potatonotes_development":
            MessageLookupByLibrary.simpleMessage(
                "Ontwikkeld en onderhouden door HrX03"),
        "settingsRoute_about_sourceCode":
            MessageLookupByLibrary.simpleMessage("PotatoNotes broncode"),
        "settingsRoute_backupAndRestore":
            MessageLookupByLibrary.simpleMessage("Back-up & herstellen"),
        "settingsRoute_backupAndRestore_backup":
            MessageLookupByLibrary.simpleMessage("Back-up (experimenteel)"),
        "settingsRoute_backupAndRestore_backup_done": m5,
        "settingsRoute_backupAndRestore_regenDbEntries":
            MessageLookupByLibrary.simpleMessage(
                "Database items opnieuw genereren"),
        "settingsRoute_backupAndRestore_restore":
            MessageLookupByLibrary.simpleMessage("Herstellen (experimenteel)"),
        "settingsRoute_backupAndRestore_restore_fail":
            MessageLookupByLibrary.simpleMessage("Corrupte of ongeldige DB!"),
        "settingsRoute_backupAndRestore_restore_success":
            MessageLookupByLibrary.simpleMessage("Klaar!"),
        "settingsRoute_dev":
            MessageLookupByLibrary.simpleMessage("Ontwikkelaarsopties"),
        "settingsRoute_dev_idLabels":
            MessageLookupByLibrary.simpleMessage("Toon id labels"),
        "settingsRoute_dev_welcomeScreen": MessageLookupByLibrary.simpleMessage(
            "Toon welkomstscherm bij de volgende start"),
        "settingsRoute_gestures":
            MessageLookupByLibrary.simpleMessage("Gebaren"),
        "settingsRoute_gestures_quickStar":
            MessageLookupByLibrary.simpleMessage(
                "Dubbeltik op notitie om ster toe te voegen"),
        "settingsRoute_themes":
            MessageLookupByLibrary.simpleMessage("Thema\'s"),
        "settingsRoute_themes_appLanguage":
            MessageLookupByLibrary.simpleMessage("App taal"),
        "settingsRoute_themes_appTheme":
            MessageLookupByLibrary.simpleMessage("App thema"),
        "settingsRoute_themes_customAccentColor":
            MessageLookupByLibrary.simpleMessage("Aangepaste kleur"),
        "settingsRoute_themes_followSystem":
            MessageLookupByLibrary.simpleMessage("Volg systeemthema"),
        "settingsRoute_themes_systemDarkMode":
            MessageLookupByLibrary.simpleMessage(
                "Automatische donker thema modus"),
        "settingsRoute_themes_systemDefault":
            MessageLookupByLibrary.simpleMessage("Systeem"),
        "settingsRoute_themes_useCustomAccent":
            MessageLookupByLibrary.simpleMessage(
                "Gebruik aangepaste accentkleur"),
        "settingsRoute_title":
            MessageLookupByLibrary.simpleMessage("Instellingen"),
        "syncLoginRoute_emailOrUsername": MessageLookupByLibrary.simpleMessage(
            "E-mailadres of gebruikersnaam"),
        "syncLoginRoute_emptyField": MessageLookupByLibrary.simpleMessage(
            "Dit veld mag niet leeg zijn!"),
        "syncLoginRoute_login":
            MessageLookupByLibrary.simpleMessage("Aanmelden"),
        "syncLoginRoute_noteConflictDialog_content":
            MessageLookupByLibrary.simpleMessage(
                "Opgeslagen notities en gesynchroniseerde notities kunnen niet samengevoegd worden.\nWat wilt u doen?"),
        "syncLoginRoute_noteConflictDialog_keep":
            MessageLookupByLibrary.simpleMessage("Huidige houden en uploaden"),
        "syncLoginRoute_noteConflictDialog_replace":
            MessageLookupByLibrary.simpleMessage(
                "Vervang opgeslagen notities met die in de cloud"),
        "syncLoginRoute_noteConflictDialog_title":
            MessageLookupByLibrary.simpleMessage(
                "Notities gevonden op je account"),
        "syncLoginRoute_password":
            MessageLookupByLibrary.simpleMessage("Wachtwoord"),
        "syncLoginRoute_register":
            MessageLookupByLibrary.simpleMessage("Registreer"),
        "syncLoginRoute_successfulRegistration":
            MessageLookupByLibrary.simpleMessage("Registratie succesvol"),
        "syncManageRoute_account":
            MessageLookupByLibrary.simpleMessage("Account"),
        "syncManageRoute_account_changeImage":
            MessageLookupByLibrary.simpleMessage("Afbeelding wijzigen"),
        "syncManageRoute_account_changeUsername":
            MessageLookupByLibrary.simpleMessage("Gebruikersnaam wijzigen"),
        "syncManageRoute_account_guest":
            MessageLookupByLibrary.simpleMessage("Gast"),
        "syncManageRoute_account_loggedInAs": m6,
        "syncManageRoute_account_logout":
            MessageLookupByLibrary.simpleMessage("Uitloggen"),
        "syncManageRoute_sync":
            MessageLookupByLibrary.simpleMessage("Synchroniseren"),
        "syncManageRoute_sync_autoSyncInterval":
            MessageLookupByLibrary.simpleMessage(
                "Tijdsinterval automatische synchronisatie (seconden)"),
        "syncManageRoute_sync_enableAutoSync":
            MessageLookupByLibrary.simpleMessage(
                "Automatische synchronisatie inschakelen"),
        "syncRegisterRoute_confirmPassword":
            MessageLookupByLibrary.simpleMessage("Bevestig wachtwoord"),
        "syncRegisterRoute_confirmPassword_noMatch":
            MessageLookupByLibrary.simpleMessage(
                "Wachtwoord komt niet overeen"),
        "syncRegisterRoute_email":
            MessageLookupByLibrary.simpleMessage("E-mailadres"),
        "syncRegisterRoute_email_empty":
            MessageLookupByLibrary.simpleMessage("E-mail mag niet leeg zijn"),
        "syncRegisterRoute_email_invalidFormat":
            MessageLookupByLibrary.simpleMessage("Ongeldig e-mailformaat"),
        "syncRegisterRoute_password":
            MessageLookupByLibrary.simpleMessage("Wachtwoord"),
        "syncRegisterRoute_password_empty":
            MessageLookupByLibrary.simpleMessage(
                "Wachtwoord mag niet leeg zijn"),
        "syncRegisterRoute_register":
            MessageLookupByLibrary.simpleMessage("Registreer"),
        "syncRegisterRoute_username":
            MessageLookupByLibrary.simpleMessage("Gebruikersnaam"),
        "syncRegisterRoute_username_empty":
            MessageLookupByLibrary.simpleMessage(
                "Gebruikersnaam mag niet leeg zijn"),
        "sync_accNotFoundError": MessageLookupByLibrary.simpleMessage(
            "Het account is niet gevonden"),
        "sync_dbConnectionError": MessageLookupByLibrary.simpleMessage(
            "Er was een probleem met het verbinden met de database, probeer het later opnieuw"),
        "sync_emailAlreadyExistsError": MessageLookupByLibrary.simpleMessage(
            "Het e-mailadres dat u hebt ingevoerd lijkt al geregistreerd te zijn"),
        "sync_invalidCredentialsError": MessageLookupByLibrary.simpleMessage(
            "Verkeerde gebruikersnaam/e-mail en wachtwoord combinatie"),
        "sync_malformedEmailError": MessageLookupByLibrary.simpleMessage(
            "Misvormde of ontbrekende e-mail"),
        "sync_missingNoteIdError": MessageLookupByLibrary.simpleMessage(
            "U kunt geen notitie maken zonder een id"),
        "sync_notFoundError": MessageLookupByLibrary.simpleMessage(
            "Het account is niet gevonden"),
        "sync_outOfBoundsError": MessageLookupByLibrary.simpleMessage(
            "De invoer die u hebt ingevoerd is te lang of te kort"),
        "sync_passOutOfBoundsError": MessageLookupByLibrary.simpleMessage(
            "Het wachtwoord dat je hebt ingevoerd is te lang of te kort"),
        "sync_userNotFoundError": MessageLookupByLibrary.simpleMessage(
            "De gebruiker is niet gevonden"),
        "sync_usernameAlreadyExistsError": MessageLookupByLibrary.simpleMessage(
            "De gebruikersnaam die je hebt ingevoerd lijkt al geregistreerd te zijn"),
        "sync_usernameNotFoundError": MessageLookupByLibrary.simpleMessage(
            "Deze gebruikersnaam is niet geregistreerd"),
        "sync_usernameOutOfBoundsError": MessageLookupByLibrary.simpleMessage(
            "De gebruikersnaam die je hebt ingevoerd is te lang of te kort"),
        "trash": MessageLookupByLibrary.simpleMessage("Prullenbak"),
        "undo": MessageLookupByLibrary.simpleMessage("Ongedaan maken"),
        "userInfoRoute_avatar_change":
            MessageLookupByLibrary.simpleMessage("Avatar wijzigen"),
        "userInfoRoute_avatar_remove":
            MessageLookupByLibrary.simpleMessage("Avatar verwijderen"),
        "userInfoRoute_sortByDate":
            MessageLookupByLibrary.simpleMessage("Sorteer notities op datum"),
        "welcomeRoute_firstPage_catchPhrase":
            MessageLookupByLibrary.simpleMessage(
                "Je nieuwe favoriete app voor notities"),
        "welcomeRoute_fourthPage_description": MessageLookupByLibrary.simpleMessage(
            "En hiermee ben je eindelijk klaar. Nu kun je eindelijk plezier hebben! Hoera!"),
        "welcomeRoute_fourthPage_thankyou":
            MessageLookupByLibrary.simpleMessage(
                "Bedankt voor het kiezen van PotatoNotes"),
        "welcomeRoute_fourthPage_title":
            MessageLookupByLibrary.simpleMessage("Installatie voltooid"),
        "welcomeRoute_secondPage_title":
            MessageLookupByLibrary.simpleMessage("Basis personalisatie"),
        "welcomeRoute_thirdPage_description": MessageLookupByLibrary.simpleMessage(
            "Met een gratis PotatoSync account kunt u uw notities synchroniseren tussen meerdere apparaten. En het is super eenvoudig om er een te krijgen!"),
        "welcomeRoute_thirdPage_getStarted":
            MessageLookupByLibrary.simpleMessage("Aan de slag"),
        "welcomeRoute_thirdPage_success": MessageLookupByLibrary.simpleMessage(
            "PotatoSync is succesvol geconfigureerd. Goed gedaan!")
      };
}
