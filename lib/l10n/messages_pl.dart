// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a pl locale. All the
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
  String get localeName => 'pl';

  static m0(method, maxLength) =>
      "Długość ${method} nie może przekroczyć ${maxLength}";

  static m1(method, minLength) =>
      "Długość ${method} nie może być krótsza niż ${minLength}";

  static m2(noteSelected) => "${noteSelected} wybrano notatkę";

  static m3(noteSelected) => "${noteSelected} wybrano notatki";

  static m4(currentPage, totalPages) => "Strona ${currentPage} z ${totalPages}";

  static m5(path) => "Kopia zapasowa zlokalizowana w: ${path}";

  static m6(username) => "Zalogowano jako: ${username}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
        "archive": MessageLookupByLibrary.simpleMessage("Archiwizuj"),
        "black": MessageLookupByLibrary.simpleMessage("Czarny"),
        "cancel": MessageLookupByLibrary.simpleMessage("Anuluj"),
        "chooseAction": MessageLookupByLibrary.simpleMessage("Wybierz akcję"),
        "close": MessageLookupByLibrary.simpleMessage("Zamknij"),
        "confirm": MessageLookupByLibrary.simpleMessage("Potwierdź"),
        "dark": MessageLookupByLibrary.simpleMessage("Ciemny"),
        "done": MessageLookupByLibrary.simpleMessage("Gotowe"),
        "home": MessageLookupByLibrary.simpleMessage("Start"),
        "light": MessageLookupByLibrary.simpleMessage("Jasny"),
        "modifyNotesRoute_color_change":
            MessageLookupByLibrary.simpleMessage("Zmień kolor notatki"),
        "modifyNotesRoute_color_dialogTitle":
            MessageLookupByLibrary.simpleMessage("Wybór koloru notatki"),
        "modifyNotesRoute_content":
            MessageLookupByLibrary.simpleMessage("Zawartość"),
        "modifyNotesRoute_image": MessageLookupByLibrary.simpleMessage("Obraz"),
        "modifyNotesRoute_image_add":
            MessageLookupByLibrary.simpleMessage("Dodaj obraz"),
        "modifyNotesRoute_image_remove":
            MessageLookupByLibrary.simpleMessage("Usuń zdjęcie"),
        "modifyNotesRoute_image_update":
            MessageLookupByLibrary.simpleMessage("Aktualizuj obraz"),
        "modifyNotesRoute_list": MessageLookupByLibrary.simpleMessage("Lista"),
        "modifyNotesRoute_list_entry":
            MessageLookupByLibrary.simpleMessage("Wpis"),
        "modifyNotesRoute_list_selectedEntries":
            MessageLookupByLibrary.simpleMessage(" sprawdzonych wpisów"),
        "modifyNotesRoute_reminder":
            MessageLookupByLibrary.simpleMessage("Przypomnienie"),
        "modifyNotesRoute_reminder_add":
            MessageLookupByLibrary.simpleMessage("Dodaj nowe przypomnienie"),
        "modifyNotesRoute_reminder_date":
            MessageLookupByLibrary.simpleMessage("Data"),
        "modifyNotesRoute_reminder_time":
            MessageLookupByLibrary.simpleMessage("Czas"),
        "modifyNotesRoute_reminder_update":
            MessageLookupByLibrary.simpleMessage("Aktualizuj przypomnienie"),
        "modifyNotesRoute_security_dialog_lengthExceed": m0,
        "modifyNotesRoute_security_dialog_lengthShort": m1,
        "modifyNotesRoute_security_dialog_titlePassword":
            MessageLookupByLibrary.simpleMessage("Ustaw lub aktualizuj hasło"),
        "modifyNotesRoute_security_dialog_titlePin":
            MessageLookupByLibrary.simpleMessage("Ustaw lub aktualizuj PIN"),
        "modifyNotesRoute_security_dialog_valid":
            MessageLookupByLibrary.simpleMessage(" ważny"),
        "modifyNotesRoute_security_hideContent":
            MessageLookupByLibrary.simpleMessage(
                "Ukryj zawartość notatki na stronie głównej"),
        "modifyNotesRoute_security_password":
            MessageLookupByLibrary.simpleMessage("Hasło"),
        "modifyNotesRoute_security_pin":
            MessageLookupByLibrary.simpleMessage("PIN"),
        "modifyNotesRoute_security_protectionText":
            MessageLookupByLibrary.simpleMessage(
                "Użyj zabezpieczenia dla ukrycia"),
        "modifyNotesRoute_title": MessageLookupByLibrary.simpleMessage("Tytuł"),
        "note_archive_snackbar":
            MessageLookupByLibrary.simpleMessage("Zarchiwizowano notatkę"),
        "note_delete": MessageLookupByLibrary.simpleMessage("Usuń"),
        "note_delete_snackbar":
            MessageLookupByLibrary.simpleMessage("Notatka usunięta"),
        "note_edit": MessageLookupByLibrary.simpleMessage("Edytuj"),
        "note_emptyTrash":
            MessageLookupByLibrary.simpleMessage("Opróżnij kosz"),
        "note_export": MessageLookupByLibrary.simpleMessage("Wyeksportuj"),
        "note_exportLocation":
            MessageLookupByLibrary.simpleMessage("Notatka wyeksportowana do"),
        "note_lockedOptions": MessageLookupByLibrary.simpleMessage(
            "Notatka jest zablokowana, użyj opcji na ekranie notatki"),
        "note_pinToNotifs":
            MessageLookupByLibrary.simpleMessage("Przypnij do powiadomień"),
        "note_removeFromArchive_snackbar":
            MessageLookupByLibrary.simpleMessage("Usunięto notatkę z archiwum"),
        "note_restore_snackbar":
            MessageLookupByLibrary.simpleMessage("Przywrócono notatkę"),
        "note_select": MessageLookupByLibrary.simpleMessage("Wybierz"),
        "note_share": MessageLookupByLibrary.simpleMessage("Udostępnij"),
        "note_star": MessageLookupByLibrary.simpleMessage("Gwiazdka"),
        "note_unstar": MessageLookupByLibrary.simpleMessage("Usuń gwiazdkę"),
        "notesMainPageRoute_emptyArchive": MessageLookupByLibrary.simpleMessage(
            "Nie masz żadnych notatek w archiwum"),
        "notesMainPageRoute_emptyTrash":
            MessageLookupByLibrary.simpleMessage("Twój kosz jest pusty"),
        "notesMainPageRoute_noNotes":
            MessageLookupByLibrary.simpleMessage("Nie dodano żadnych notatek"),
        "notesMainPageRoute_note_deleteDialog_content":
            MessageLookupByLibrary.simpleMessage(
                "Nie można przywrócić notatek po ich usunięciu.\nCzy na pewno chcesz kontynuować?"),
        "notesMainPageRoute_note_deleteDialog_title":
            MessageLookupByLibrary.simpleMessage("Usunąć zaznaczone notatki?"),
        "notesMainPageRoute_note_emptyTrash_content":
            MessageLookupByLibrary.simpleMessage(
                "Nie można przywrócić notatek po ich usunięciu.\nCzy na pewno chcesz kontynuować?"),
        "notesMainPageRoute_note_emptyTrash_title":
            MessageLookupByLibrary.simpleMessage("Opróżnić kosz?"),
        "notesMainPageRoute_note_hiddenContent":
            MessageLookupByLibrary.simpleMessage("Ukryta zawartość"),
        "notesMainPageRoute_note_list_selectedEntries":
            MessageLookupByLibrary.simpleMessage(" wybranych wpisów"),
        "notesMainPageRoute_note_remindersSet":
            MessageLookupByLibrary.simpleMessage("Przypomnienie"),
        "notesMainPageRoute_other":
            MessageLookupByLibrary.simpleMessage("Pozostałe notatki"),
        "notesMainPageRoute_pinnedNote":
            MessageLookupByLibrary.simpleMessage("Przypięta notatka"),
        "notesMainPageRoute_starred":
            MessageLookupByLibrary.simpleMessage("Oznaczone gwiazdką"),
        "notesMainPageRoute_writeNote":
            MessageLookupByLibrary.simpleMessage("Napisz notatkę"),
        "notes_archive_snackbar":
            MessageLookupByLibrary.simpleMessage("Zarchiwizowano notatki"),
        "notes_delete_snackbar":
            MessageLookupByLibrary.simpleMessage("Usunięto notatki"),
        "notes_removeFromArchive_snackbar":
            MessageLookupByLibrary.simpleMessage("Usunięto notatki z archiwum"),
        "notes_restore_snackbar":
            MessageLookupByLibrary.simpleMessage("Przywrócono notatki"),
        "remove": MessageLookupByLibrary.simpleMessage("Usuń"),
        "reset": MessageLookupByLibrary.simpleMessage("Przywróć domyślne"),
        "save": MessageLookupByLibrary.simpleMessage("Zapisz"),
        "searchNotesRoute_filters_case": MessageLookupByLibrary.simpleMessage(
            "Rozróżniaj małe i duże litery"),
        "searchNotesRoute_filters_color":
            MessageLookupByLibrary.simpleMessage("Filtr kolorów"),
        "searchNotesRoute_filters_date":
            MessageLookupByLibrary.simpleMessage("Filtr daty"),
        "searchNotesRoute_filters_title":
            MessageLookupByLibrary.simpleMessage("Filtry wyszukiwania"),
        "searchNotesRoute_noQuery": MessageLookupByLibrary.simpleMessage(
            "Wprowadź coś, aby rozpocząć wyszukiwanie"),
        "searchNotesRoute_nothingFound": MessageLookupByLibrary.simpleMessage(
            "Nie znaleziono notatek pasujących do twoich kryteriów wyszukiwania"),
        "searchNotesRoute_searchbar":
            MessageLookupByLibrary.simpleMessage("Szukaj..."),
        "securityNoteRoute_request_password":
            MessageLookupByLibrary.simpleMessage(
                "Aby otworzyć notatkę, wymagane jest podanie hasła"),
        "securityNoteRoute_request_pin": MessageLookupByLibrary.simpleMessage(
            "Proszony jest kod PIN, aby otworzyć notatkę"),
        "securityNoteRoute_wrong_password":
            MessageLookupByLibrary.simpleMessage("Nieprawidłowe hasło"),
        "securityNoteRoute_wrong_pin":
            MessageLookupByLibrary.simpleMessage("Nieprawidłowy kod PIN"),
        "semantics_back": MessageLookupByLibrary.simpleMessage("Wróć"),
        "semantics_color_beige": MessageLookupByLibrary.simpleMessage("Beżowy"),
        "semantics_color_blue":
            MessageLookupByLibrary.simpleMessage("Niebieski"),
        "semantics_color_green":
            MessageLookupByLibrary.simpleMessage("Zielony"),
        "semantics_color_none": MessageLookupByLibrary.simpleMessage("Żaden"),
        "semantics_color_orange":
            MessageLookupByLibrary.simpleMessage("Pomarańczowy"),
        "semantics_color_pink": MessageLookupByLibrary.simpleMessage("Różowy"),
        "semantics_color_purple":
            MessageLookupByLibrary.simpleMessage("Fioletowy"),
        "semantics_color_yellow": MessageLookupByLibrary.simpleMessage("Żółty"),
        "semantics_hideText":
            MessageLookupByLibrary.simpleMessage("Ukryj tekst"),
        "semantics_modifyNotes_addElement":
            MessageLookupByLibrary.simpleMessage("Dodaj element"),
        "semantics_modifyNotes_image":
            MessageLookupByLibrary.simpleMessage("Obraz notatki"),
        "semantics_modifyNotes_security":
            MessageLookupByLibrary.simpleMessage("Ustawienia bezpieczeństwa"),
        "semantics_modifyNotes_star":
            MessageLookupByLibrary.simpleMessage("Oznacz gwiazdką"),
        "semantics_modifyNotes_unstar":
            MessageLookupByLibrary.simpleMessage("Usuń gwiazdkę"),
        "semantics_notesMainPage_addNote":
            MessageLookupByLibrary.simpleMessage("Dodaj nową notatkę"),
        "semantics_notesMainPage_archive":
            MessageLookupByLibrary.simpleMessage("Archiwizuj wybrane notatki"),
        "semantics_notesMainPage_changeColor":
            MessageLookupByLibrary.simpleMessage("Zmień kolor notatki"),
        "semantics_notesMainPage_closeSelector":
            MessageLookupByLibrary.simpleMessage("Zamknij"),
        "semantics_notesMainPage_delete":
            MessageLookupByLibrary.simpleMessage("Usuń zaznaczone notatki"),
        "semantics_notesMainPage_favouritesAdd":
            MessageLookupByLibrary.simpleMessage("Dodaj do ulubionych"),
        "semantics_notesMainPage_favouritesRemove":
            MessageLookupByLibrary.simpleMessage("Usuń z ulubionych"),
        "semantics_notesMainPage_grid":
            MessageLookupByLibrary.simpleMessage("Przejdź do widoku siatki"),
        "semantics_notesMainPage_list":
            MessageLookupByLibrary.simpleMessage("Przejdź do widoku listy"),
        "semantics_notesMainPage_noteSelected": m2,
        "semantics_notesMainPage_notesSelected": m3,
        "semantics_notesMainPage_openMenu":
            MessageLookupByLibrary.simpleMessage("Otwórz menu"),
        "semantics_notesMainPage_restore":
            MessageLookupByLibrary.simpleMessage("Przywróć wybrane notatki"),
        "semantics_notesMainPage_search":
            MessageLookupByLibrary.simpleMessage("Przeszukaj notatki"),
        "semantics_showText":
            MessageLookupByLibrary.simpleMessage("Pokaż tekst"),
        "semantics_welcome_exit":
            MessageLookupByLibrary.simpleMessage("Zakończ konfigurację"),
        "semantics_welcome_next":
            MessageLookupByLibrary.simpleMessage("Następna strona"),
        "semantics_welcome_pageIndicator": m4,
        "semantics_welcome_previous":
            MessageLookupByLibrary.simpleMessage("Poprzednia strona"),
        "settingsRoute_about": MessageLookupByLibrary.simpleMessage("O"),
        "settingsRoute_about_potatonotes":
            MessageLookupByLibrary.simpleMessage("O PotatoNotes"),
        "settingsRoute_about_potatonotes_design":
            MessageLookupByLibrary.simpleMessage(
                "Projekt, marka aplikacji i logo aplikacji przez RshBfn"),
        "settingsRoute_about_potatonotes_development":
            MessageLookupByLibrary.simpleMessage(
                "Opracowane i rozwijane przez HrX03"),
        "settingsRoute_about_sourceCode":
            MessageLookupByLibrary.simpleMessage("Kod źródłowy PotatoNotes"),
        "settingsRoute_backupAndRestore": MessageLookupByLibrary.simpleMessage(
            "Kopia zapasowa i przywracanie"),
        "settingsRoute_backupAndRestore_backup":
            MessageLookupByLibrary.simpleMessage(
                "Kopia zapasowa (eksperymentalna)"),
        "settingsRoute_backupAndRestore_backup_done": m5,
        "settingsRoute_backupAndRestore_regenDbEntries":
            MessageLookupByLibrary.simpleMessage(
                "Wygeneruj ponownie wpisy bazy danych"),
        "settingsRoute_backupAndRestore_restore":
            MessageLookupByLibrary.simpleMessage("Przywróć (eksperymentalne)"),
        "settingsRoute_backupAndRestore_restore_fail":
            MessageLookupByLibrary.simpleMessage(
                "Uszkodzona lub nieprawidłowa baza danych!"),
        "settingsRoute_backupAndRestore_restore_success":
            MessageLookupByLibrary.simpleMessage("Gotowe!"),
        "settingsRoute_dev":
            MessageLookupByLibrary.simpleMessage("Opcje programistyczne"),
        "settingsRoute_dev_idLabels": MessageLookupByLibrary.simpleMessage(
            "Pokaż etykiety identyfikatorów"),
        "settingsRoute_dev_welcomeScreen": MessageLookupByLibrary.simpleMessage(
            "Pokaż ekran powitalny przy następnym uruchomieniu"),
        "settingsRoute_gestures": MessageLookupByLibrary.simpleMessage("Gesty"),
        "settingsRoute_gestures_quickStar":
            MessageLookupByLibrary.simpleMessage(
                "Dwukrotnie stuknij na notatkę, by dodać gwiazdkę"),
        "settingsRoute_themes": MessageLookupByLibrary.simpleMessage("Motywy"),
        "settingsRoute_themes_appLanguage":
            MessageLookupByLibrary.simpleMessage("Język aplikacji"),
        "settingsRoute_themes_appTheme":
            MessageLookupByLibrary.simpleMessage("Motyw aplikacji"),
        "settingsRoute_themes_customAccentColor":
            MessageLookupByLibrary.simpleMessage("Własny kolor"),
        "settingsRoute_themes_followSystem":
            MessageLookupByLibrary.simpleMessage("Z motywu systemu"),
        "settingsRoute_themes_systemDarkMode":
            MessageLookupByLibrary.simpleMessage("Automatyczny tryb ciemny"),
        "settingsRoute_themes_systemDefault":
            MessageLookupByLibrary.simpleMessage("System"),
        "settingsRoute_themes_useCustomAccent":
            MessageLookupByLibrary.simpleMessage(
                "Użyj niestandardowego koloru akcentu"),
        "settingsRoute_title":
            MessageLookupByLibrary.simpleMessage("Ustawienia"),
        "syncLoginRoute_emailOrUsername": MessageLookupByLibrary.simpleMessage(
            "E-mail lub nazwa użytkownika"),
        "syncLoginRoute_emptyField":
            MessageLookupByLibrary.simpleMessage("To pole nie może być puste!"),
        "syncLoginRoute_login":
            MessageLookupByLibrary.simpleMessage("Zaloguj się"),
        "syncLoginRoute_noteConflictDialog_content":
            MessageLookupByLibrary.simpleMessage(
                "Wystąpił konflikt z zapisanymi i zsynchronizowanymi notatkami. Co chcesz zrobić?"),
        "syncLoginRoute_noteConflictDialog_keep":
            MessageLookupByLibrary.simpleMessage(
                "Zachowaj bieżące i prześlij je"),
        "syncLoginRoute_noteConflictDialog_replace":
            MessageLookupByLibrary.simpleMessage("Zastąp zapisane chmurą"),
        "syncLoginRoute_noteConflictDialog_title":
            MessageLookupByLibrary.simpleMessage(
                "Notatki znalezione na Twoim koncie"),
        "syncLoginRoute_password":
            MessageLookupByLibrary.simpleMessage("Hasło"),
        "syncLoginRoute_register":
            MessageLookupByLibrary.simpleMessage("Zarejestruj się"),
        "syncLoginRoute_successfulRegistration":
            MessageLookupByLibrary.simpleMessage(
                "Zarejestrowano z powodzeniem"),
        "syncManageRoute_account":
            MessageLookupByLibrary.simpleMessage("Konto"),
        "syncManageRoute_account_changeImage":
            MessageLookupByLibrary.simpleMessage("Zmień obraz"),
        "syncManageRoute_account_changeUsername":
            MessageLookupByLibrary.simpleMessage("Zmień nazwę użytkownika"),
        "syncManageRoute_account_guest":
            MessageLookupByLibrary.simpleMessage("Gość"),
        "syncManageRoute_account_loggedInAs": m6,
        "syncManageRoute_account_logout":
            MessageLookupByLibrary.simpleMessage("Wyloguj się"),
        "syncManageRoute_sync":
            MessageLookupByLibrary.simpleMessage("Synchronizuj"),
        "syncManageRoute_sync_autoSyncInterval":
            MessageLookupByLibrary.simpleMessage(
                "Interwał czasu automatycznej synchronizacji (sekundy)"),
        "syncManageRoute_sync_enableAutoSync":
            MessageLookupByLibrary.simpleMessage(
                "Włącz automatyczną synchronizację"),
        "syncRegisterRoute_confirmPassword":
            MessageLookupByLibrary.simpleMessage("Potwierdź hasło"),
        "syncRegisterRoute_confirmPassword_noMatch":
            MessageLookupByLibrary.simpleMessage("Hasło nie pasuje"),
        "syncRegisterRoute_email":
            MessageLookupByLibrary.simpleMessage("E-mail"),
        "syncRegisterRoute_email_empty": MessageLookupByLibrary.simpleMessage(
            "Adres e-mail nie może być pusty"),
        "syncRegisterRoute_email_invalidFormat":
            MessageLookupByLibrary.simpleMessage("Nieprawidłowy format e-mail"),
        "syncRegisterRoute_password":
            MessageLookupByLibrary.simpleMessage("Hasło"),
        "syncRegisterRoute_password_empty":
            MessageLookupByLibrary.simpleMessage("Hasło nie może być puste"),
        "syncRegisterRoute_register":
            MessageLookupByLibrary.simpleMessage("Zarejestruj się"),
        "syncRegisterRoute_username":
            MessageLookupByLibrary.simpleMessage("Nazwa użytkownika"),
        "syncRegisterRoute_username_empty":
            MessageLookupByLibrary.simpleMessage(
                "Nazwa użytkownika nie może być pusta"),
        "sync_accNotFoundError": MessageLookupByLibrary.simpleMessage(
            "Konto nie zostało znalezione"),
        "sync_dbConnectionError": MessageLookupByLibrary.simpleMessage(
            "Wystąpił problem z połączeniem z bazą danych, spróbuj ponownie później"),
        "sync_emailAlreadyExistsError": MessageLookupByLibrary.simpleMessage(
            "Wprowadzony adres e-mail wydaje się być już zarejestrowany"),
        "sync_invalidCredentialsError": MessageLookupByLibrary.simpleMessage(
            "Zła kombinacja nazwy użytkownika/adresu e-mail i hasła"),
        "sync_malformedEmailError": MessageLookupByLibrary.simpleMessage(
            "Niepoprawny lub brakujący adres e-mail"),
        "sync_missingNoteIdError": MessageLookupByLibrary.simpleMessage(
            "Nie możesz utworzyć notatki bez identyfikatora"),
        "sync_notFoundError": MessageLookupByLibrary.simpleMessage(
            "Konto nie zostało znalezione"),
        "sync_outOfBoundsError": MessageLookupByLibrary.simpleMessage(
            "Wprowadzone dane są zbyt długie lub zbyt krótkie"),
        "sync_passOutOfBoundsError": MessageLookupByLibrary.simpleMessage(
            "Wprowadzone hasło jest zbyt długie lub za krótkie"),
        "sync_userNotFoundError": MessageLookupByLibrary.simpleMessage(
            "Użytkownik nie został znaleziony"),
        "sync_usernameAlreadyExistsError": MessageLookupByLibrary.simpleMessage(
            "Podana nazwa użytkownika wydaje się być już zarejestrowana"),
        "sync_usernameNotFoundError": MessageLookupByLibrary.simpleMessage(
            "Ta nazwa użytkownika nie jest zarejestrowana"),
        "sync_usernameOutOfBoundsError": MessageLookupByLibrary.simpleMessage(
            "Wprowadzona nazwa użytkownika jest zbyt długa lub zbyt krótka"),
        "trash": MessageLookupByLibrary.simpleMessage("Kosz"),
        "undo": MessageLookupByLibrary.simpleMessage("Cofnij"),
        "userInfoRoute_avatar_change":
            MessageLookupByLibrary.simpleMessage("Zmień awatar"),
        "userInfoRoute_avatar_remove":
            MessageLookupByLibrary.simpleMessage("Usuń awatar"),
        "userInfoRoute_sortByDate":
            MessageLookupByLibrary.simpleMessage("Sortuj notatki według daty"),
        "welcomeRoute_firstPage_catchPhrase":
            MessageLookupByLibrary.simpleMessage(
                "Twoja nowa aplikacja do ulubionych notatek"),
        "welcomeRoute_fourthPage_description":
            MessageLookupByLibrary.simpleMessage(
                "I w końcu skończyłeś. Nareszcie możesz się bawić! Hurra!"),
        "welcomeRoute_fourthPage_thankyou":
            MessageLookupByLibrary.simpleMessage(
                "Dziękujemy za wybranie PotatoNotes"),
        "welcomeRoute_fourthPage_title":
            MessageLookupByLibrary.simpleMessage("Konfiguracja ukończona"),
        "welcomeRoute_secondPage_title":
            MessageLookupByLibrary.simpleMessage("Podstawowe dostosowywanie"),
        "welcomeRoute_thirdPage_description": MessageLookupByLibrary.simpleMessage(
            "Dzięki darmowemu kontu PotatoSync możesz synchronizować swoje notatki między wieloma urządzeniami. I bardzo łatwo jest je uzyskać!"),
        "welcomeRoute_thirdPage_getStarted":
            MessageLookupByLibrary.simpleMessage("Rozpocznij"),
        "welcomeRoute_thirdPage_success": MessageLookupByLibrary.simpleMessage(
            "PotatoSync został skonfigurowany pomyślnie. Dobra robota!")
      };
}
