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

  static m0(method, maxLength) =>
      "La lunghezza del ${method} non può oltrepassare ${maxLength}";

  static m1(method, minLength) =>
      "La lunghezza del ${method} non può essere minore di ${minLength}";

  static m2(noteSelected) => "${noteSelected} appunto selezionato";

  static m3(noteSelected) => "${noteSelected} appunti selezionati";

  static m4(currentPage, totalPages) =>
      "Pagina ${currentPage} di ${totalPages}";

  static m5(path) => "Backup situato su: ${path}";

  static m6(username) => "Accesso eseguito come: ${username}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
        "archive": MessageLookupByLibrary.simpleMessage("Archivio"),
        "black": MessageLookupByLibrary.simpleMessage("Nero"),
        "cancel": MessageLookupByLibrary.simpleMessage("Annulla"),
        "chooseAction": MessageLookupByLibrary.simpleMessage("Scegli azione"),
        "close": MessageLookupByLibrary.simpleMessage("Chiudi"),
        "confirm": MessageLookupByLibrary.simpleMessage("Conferma"),
        "dark": MessageLookupByLibrary.simpleMessage("Scuro"),
        "done": MessageLookupByLibrary.simpleMessage("Fatto"),
        "home": MessageLookupByLibrary.simpleMessage("Principale"),
        "light": MessageLookupByLibrary.simpleMessage("Chiaro"),
        "modifyNotesRoute_color_change":
            MessageLookupByLibrary.simpleMessage("Cambia colore"),
        "modifyNotesRoute_color_dialogTitle":
            MessageLookupByLibrary.simpleMessage("Selettore del colore"),
        "modifyNotesRoute_content":
            MessageLookupByLibrary.simpleMessage("Contenuto"),
        "modifyNotesRoute_image":
            MessageLookupByLibrary.simpleMessage("Immagine"),
        "modifyNotesRoute_image_add":
            MessageLookupByLibrary.simpleMessage("Aggiungi immagine"),
        "modifyNotesRoute_image_remove":
            MessageLookupByLibrary.simpleMessage("Rimuovi immagine"),
        "modifyNotesRoute_image_update":
            MessageLookupByLibrary.simpleMessage("Aggiorna immagine"),
        "modifyNotesRoute_list": MessageLookupByLibrary.simpleMessage("Lista"),
        "modifyNotesRoute_list_entry":
            MessageLookupByLibrary.simpleMessage("Voce"),
        "modifyNotesRoute_list_selectedEntries":
            MessageLookupByLibrary.simpleMessage(" voci selezionate"),
        "modifyNotesRoute_reminder":
            MessageLookupByLibrary.simpleMessage("Promemoria"),
        "modifyNotesRoute_reminder_add":
            MessageLookupByLibrary.simpleMessage("Aggiungi un promemoria"),
        "modifyNotesRoute_reminder_date":
            MessageLookupByLibrary.simpleMessage("Giorno"),
        "modifyNotesRoute_reminder_time":
            MessageLookupByLibrary.simpleMessage("Ora"),
        "modifyNotesRoute_reminder_update":
            MessageLookupByLibrary.simpleMessage("Aggiorna promemoria"),
        "modifyNotesRoute_security_dialog_lengthExceed": m0,
        "modifyNotesRoute_security_dialog_lengthShort": m1,
        "modifyNotesRoute_security_dialog_titlePassword":
            MessageLookupByLibrary.simpleMessage(
                "Imposta o aggiorna la password"),
        "modifyNotesRoute_security_dialog_titlePin":
            MessageLookupByLibrary.simpleMessage("Imposta o aggiorna il PIN"),
        "modifyNotesRoute_security_dialog_valid":
            MessageLookupByLibrary.simpleMessage(" valido/a"),
        "modifyNotesRoute_security_hideContent":
            MessageLookupByLibrary.simpleMessage(
                "Nascondi contenuto nella pagina principale"),
        "modifyNotesRoute_security_password":
            MessageLookupByLibrary.simpleMessage("Password"),
        "modifyNotesRoute_security_pin":
            MessageLookupByLibrary.simpleMessage("PIN"),
        "modifyNotesRoute_security_protectionText":
            MessageLookupByLibrary.simpleMessage(
                "Utilizza una protezione per nascondere"),
        "modifyNotesRoute_title":
            MessageLookupByLibrary.simpleMessage("Titolo"),
        "note_archive_snackbar":
            MessageLookupByLibrary.simpleMessage("Appunto archiviato"),
        "note_delete": MessageLookupByLibrary.simpleMessage("Elimina"),
        "note_delete_snackbar":
            MessageLookupByLibrary.simpleMessage("Appunto eliminato"),
        "note_edit": MessageLookupByLibrary.simpleMessage("Modifica"),
        "note_emptyTrash":
            MessageLookupByLibrary.simpleMessage("Svuota cestino"),
        "note_export": MessageLookupByLibrary.simpleMessage("Esporta"),
        "note_exportLocation":
            MessageLookupByLibrary.simpleMessage("Appunto esportato su"),
        "note_lockedOptions": MessageLookupByLibrary.simpleMessage(
            "Il contenuto è nascosto, usa le opzioni nello schermo dell\'appunto"),
        "note_pinToNotifs":
            MessageLookupByLibrary.simpleMessage("Fissa nelle notifiche"),
        "note_removeFromArchive_snackbar": MessageLookupByLibrary.simpleMessage(
            "Appunto rimosso dall\'archivio"),
        "note_restore_snackbar":
            MessageLookupByLibrary.simpleMessage("Appunto ripristinato"),
        "note_select": MessageLookupByLibrary.simpleMessage("Seleziona"),
        "note_share": MessageLookupByLibrary.simpleMessage("Condividi"),
        "note_star": MessageLookupByLibrary.simpleMessage("Preferito"),
        "note_unstar": MessageLookupByLibrary.simpleMessage("Non preferito"),
        "notesMainPageRoute_emptyArchive": MessageLookupByLibrary.simpleMessage(
            "Non hai nessun appunto archviato"),
        "notesMainPageRoute_emptyTrash":
            MessageLookupByLibrary.simpleMessage("Il cestino è vuoto"),
        "notesMainPageRoute_noNotes": MessageLookupByLibrary.simpleMessage(
            "Nessun appunto aggiunto... per ora"),
        "notesMainPageRoute_note_deleteDialog_content":
            MessageLookupByLibrary.simpleMessage(
                "Una volta che elimini gli appunti essi non possono essere ripristinati. Continuare?"),
        "notesMainPageRoute_note_deleteDialog_title":
            MessageLookupByLibrary.simpleMessage(
                "Eliminare gli appunti selezionati?"),
        "notesMainPageRoute_note_emptyTrash_content":
            MessageLookupByLibrary.simpleMessage(
                "Una volta che elimini gli appunti essi non possono essere ripristinati. Continuare?"),
        "notesMainPageRoute_note_emptyTrash_title":
            MessageLookupByLibrary.simpleMessage("Svuotare il cestino?"),
        "notesMainPageRoute_note_hiddenContent":
            MessageLookupByLibrary.simpleMessage("Contenuto nascosto"),
        "notesMainPageRoute_note_list_selectedEntries":
            MessageLookupByLibrary.simpleMessage(" voci selezionate"),
        "notesMainPageRoute_note_remindersSet":
            MessageLookupByLibrary.simpleMessage("Promemoria impostati"),
        "notesMainPageRoute_other":
            MessageLookupByLibrary.simpleMessage("Altri appunti"),
        "notesMainPageRoute_pinnedNote":
            MessageLookupByLibrary.simpleMessage("Appunto fissato"),
        "notesMainPageRoute_starred":
            MessageLookupByLibrary.simpleMessage("Appunti preferiti"),
        "notesMainPageRoute_writeNote":
            MessageLookupByLibrary.simpleMessage("Scrivi un appunto"),
        "notes_archive_snackbar":
            MessageLookupByLibrary.simpleMessage("Appunti archiviati"),
        "notes_delete_snackbar":
            MessageLookupByLibrary.simpleMessage("Appunti eliminati"),
        "notes_removeFromArchive_snackbar":
            MessageLookupByLibrary.simpleMessage(
                "Appunti rimossi dall\'archivio"),
        "notes_restore_snackbar":
            MessageLookupByLibrary.simpleMessage("Appunti ripristinati"),
        "remove": MessageLookupByLibrary.simpleMessage("Rimuovi"),
        "reset": MessageLookupByLibrary.simpleMessage("Reimposta"),
        "save": MessageLookupByLibrary.simpleMessage("Salva"),
        "searchNotesRoute_filters_case":
            MessageLookupByLibrary.simpleMessage("Sensibile alle maiuscole"),
        "searchNotesRoute_filters_color":
            MessageLookupByLibrary.simpleMessage("Colore"),
        "searchNotesRoute_filters_date":
            MessageLookupByLibrary.simpleMessage("Data"),
        "searchNotesRoute_filters_title":
            MessageLookupByLibrary.simpleMessage("Filtri"),
        "searchNotesRoute_noQuery": MessageLookupByLibrary.simpleMessage(
            "Scrivi qualcosa per iniziare a cercare"),
        "searchNotesRoute_nothingFound": MessageLookupByLibrary.simpleMessage(
            "Nessun appunto trovato che corrispondesse alla tua ricerca"),
        "searchNotesRoute_searchbar":
            MessageLookupByLibrary.simpleMessage("Cerca..."),
        "securityNoteRoute_request_password":
            MessageLookupByLibrary.simpleMessage(
                "E\' richiesta una password per aprire l\'appunto"),
        "securityNoteRoute_request_pin": MessageLookupByLibrary.simpleMessage(
            "E\' richiesto un PIN per aprire l\'appunto"),
        "securityNoteRoute_wrong_password":
            MessageLookupByLibrary.simpleMessage("Password errata"),
        "securityNoteRoute_wrong_pin":
            MessageLookupByLibrary.simpleMessage("PIN errato"),
        "semantics_back": MessageLookupByLibrary.simpleMessage("Indietro"),
        "semantics_color_beige": MessageLookupByLibrary.simpleMessage("Beige"),
        "semantics_color_blue": MessageLookupByLibrary.simpleMessage("Blu"),
        "semantics_color_green": MessageLookupByLibrary.simpleMessage("Verde"),
        "semantics_color_none": MessageLookupByLibrary.simpleMessage("Nessuno"),
        "semantics_color_orange":
            MessageLookupByLibrary.simpleMessage("Arancione"),
        "semantics_color_pink": MessageLookupByLibrary.simpleMessage("Rosa"),
        "semantics_color_purple": MessageLookupByLibrary.simpleMessage("Viola"),
        "semantics_color_yellow":
            MessageLookupByLibrary.simpleMessage("Giallo"),
        "semantics_hideText":
            MessageLookupByLibrary.simpleMessage("Nascondi testo"),
        "semantics_modifyNotes_addElement":
            MessageLookupByLibrary.simpleMessage("Aggiungi elemento"),
        "semantics_modifyNotes_image":
            MessageLookupByLibrary.simpleMessage("Immagine dell\'appunto"),
        "semantics_modifyNotes_security":
            MessageLookupByLibrary.simpleMessage("Opzioni di sicurezza"),
        "semantics_modifyNotes_star":
            MessageLookupByLibrary.simpleMessage("Aggiungi ai preferiti"),
        "semantics_modifyNotes_unstar":
            MessageLookupByLibrary.simpleMessage("Rimuovi dai preferiti"),
        "semantics_notesMainPage_addNote":
            MessageLookupByLibrary.simpleMessage("Aggiungi appunto"),
        "semantics_notesMainPage_archive": MessageLookupByLibrary.simpleMessage(
            "Archivia appunti selezionati"),
        "semantics_notesMainPage_changeColor":
            MessageLookupByLibrary.simpleMessage("Cambia colore degli appunti"),
        "semantics_notesMainPage_closeSelector":
            MessageLookupByLibrary.simpleMessage("Chiudi selettore"),
        "semantics_notesMainPage_delete":
            MessageLookupByLibrary.simpleMessage("Elimina appunti selezionati"),
        "semantics_notesMainPage_favouritesAdd":
            MessageLookupByLibrary.simpleMessage(
                "Aggiungi appunti ai preferiti"),
        "semantics_notesMainPage_favouritesRemove":
            MessageLookupByLibrary.simpleMessage(
                "Rimuovi appunti dai preferiti"),
        "semantics_notesMainPage_grid":
            MessageLookupByLibrary.simpleMessage("Passa alla vista a griglia"),
        "semantics_notesMainPage_list":
            MessageLookupByLibrary.simpleMessage("Passa alla vista a lista"),
        "semantics_notesMainPage_noteSelected": m2,
        "semantics_notesMainPage_notesSelected": m3,
        "semantics_notesMainPage_openMenu":
            MessageLookupByLibrary.simpleMessage("Apri menu"),
        "semantics_notesMainPage_restore": MessageLookupByLibrary.simpleMessage(
            "Ripristina appunti selezionati"),
        "semantics_notesMainPage_search":
            MessageLookupByLibrary.simpleMessage("Cerca negli appunti"),
        "semantics_showText":
            MessageLookupByLibrary.simpleMessage("Mostra testo"),
        "semantics_welcome_exit":
            MessageLookupByLibrary.simpleMessage("Completa setup"),
        "semantics_welcome_next":
            MessageLookupByLibrary.simpleMessage("Pagina successiva"),
        "semantics_welcome_pageIndicator": m4,
        "semantics_welcome_previous":
            MessageLookupByLibrary.simpleMessage("Pagina precedente"),
        "settingsRoute_about": MessageLookupByLibrary.simpleMessage("Crediti"),
        "settingsRoute_about_potatonotes": MessageLookupByLibrary.simpleMessage(
            "A proposito di PotatoNotes..."),
        "settingsRoute_about_potatonotes_design":
            MessageLookupByLibrary.simpleMessage(
                "Design e icon dell\'app di RshBfn"),
        "settingsRoute_about_potatonotes_development":
            MessageLookupByLibrary.simpleMessage(
                "Sviluppato e supportato da HrX03"),
        "settingsRoute_about_sourceCode": MessageLookupByLibrary.simpleMessage(
            "Codice sorgente di PotatoNotes"),
        "settingsRoute_backupAndRestore":
            MessageLookupByLibrary.simpleMessage("Backup & ripristino"),
        "settingsRoute_backupAndRestore_backup":
            MessageLookupByLibrary.simpleMessage("Backup (Sperimentale)"),
        "settingsRoute_backupAndRestore_backup_done": m5,
        "settingsRoute_backupAndRestore_regenDbEntries":
            MessageLookupByLibrary.simpleMessage(
                "Rigenera le colonne del database"),
        "settingsRoute_backupAndRestore_restore":
            MessageLookupByLibrary.simpleMessage("Ripristino (Sperimentale)"),
        "settingsRoute_backupAndRestore_restore_fail":
            MessageLookupByLibrary.simpleMessage(
                "Database corrotto o non valido!"),
        "settingsRoute_backupAndRestore_restore_success":
            MessageLookupByLibrary.simpleMessage("Fatto!"),
        "settingsRoute_dev":
            MessageLookupByLibrary.simpleMessage("Opzioni sviluppatore"),
        "settingsRoute_dev_idLabels":
            MessageLookupByLibrary.simpleMessage("Mostra etichette dell\'id"),
        "settingsRoute_dev_welcomeScreen": MessageLookupByLibrary.simpleMessage(
            "Mostra la schermata di benvenuto al prossimo avvio"),
        "settingsRoute_gestures": MessageLookupByLibrary.simpleMessage("Gesti"),
        "settingsRoute_gestures_quickStar":
            MessageLookupByLibrary.simpleMessage(
                "Doppio tocco per mettere tra i preferiti"),
        "settingsRoute_themes": MessageLookupByLibrary.simpleMessage("Temi"),
        "settingsRoute_themes_appLanguage":
            MessageLookupByLibrary.simpleMessage("Linguaggio dell\'app"),
        "settingsRoute_themes_appTheme":
            MessageLookupByLibrary.simpleMessage("Tema dell\'app"),
        "settingsRoute_themes_customAccentColor":
            MessageLookupByLibrary.simpleMessage("Colore personalizzato"),
        "settingsRoute_themes_followSystem":
            MessageLookupByLibrary.simpleMessage("Segui il tema di sistema"),
        "settingsRoute_themes_systemDarkMode":
            MessageLookupByLibrary.simpleMessage("Tema scuro di sistema"),
        "settingsRoute_themes_systemDefault":
            MessageLookupByLibrary.simpleMessage("Sistema"),
        "settingsRoute_themes_useCustomAccent":
            MessageLookupByLibrary.simpleMessage(
                "Utilizza un colore di accento personalizzato"),
        "settingsRoute_title":
            MessageLookupByLibrary.simpleMessage("Impostazioni"),
        "syncLoginRoute_emailOrUsername":
            MessageLookupByLibrary.simpleMessage("Email o nome utente"),
        "syncLoginRoute_emptyField": MessageLookupByLibrary.simpleMessage(
            "Questo spazio non può essere vuoto!"),
        "syncLoginRoute_login": MessageLookupByLibrary.simpleMessage("Accedi"),
        "syncLoginRoute_noteConflictDialog_content":
            MessageLookupByLibrary.simpleMessage(
                "Gli appunti salvati e quelli sul cloud vanno in conflitto.\nCosa si desidare fare?"),
        "syncLoginRoute_noteConflictDialog_keep":
            MessageLookupByLibrary.simpleMessage("Mantieni attuali e caricali"),
        "syncLoginRoute_noteConflictDialog_replace":
            MessageLookupByLibrary.simpleMessage(
                "Rimpiazza con quelli sul cloud"),
        "syncLoginRoute_noteConflictDialog_title":
            MessageLookupByLibrary.simpleMessage(
                "Sono stati trovati appunti sul tuo account"),
        "syncLoginRoute_password":
            MessageLookupByLibrary.simpleMessage("Password"),
        "syncLoginRoute_register":
            MessageLookupByLibrary.simpleMessage("Registrati"),
        "syncLoginRoute_successfulRegistration":
            MessageLookupByLibrary.simpleMessage("Registrato con successo"),
        "syncManageRoute_account":
            MessageLookupByLibrary.simpleMessage("Account"),
        "syncManageRoute_account_changeImage":
            MessageLookupByLibrary.simpleMessage("Cambia immagine"),
        "syncManageRoute_account_changeUsername":
            MessageLookupByLibrary.simpleMessage("Cambia username"),
        "syncManageRoute_account_guest":
            MessageLookupByLibrary.simpleMessage("Ospite"),
        "syncManageRoute_account_loggedInAs": m6,
        "syncManageRoute_account_logout":
            MessageLookupByLibrary.simpleMessage("Esci"),
        "syncManageRoute_sync":
            MessageLookupByLibrary.simpleMessage("Sincronizzazione"),
        "syncManageRoute_sync_autoSyncInterval":
            MessageLookupByLibrary.simpleMessage(
                "Intervallo di tempo in secondi per la sincronizzazione automatica"),
        "syncManageRoute_sync_enableAutoSync":
            MessageLookupByLibrary.simpleMessage(
                "Attiva la sincronizzazione automatica"),
        "syncRegisterRoute_confirmPassword":
            MessageLookupByLibrary.simpleMessage("Conferma password"),
        "syncRegisterRoute_confirmPassword_noMatch":
            MessageLookupByLibrary.simpleMessage(
                "Le password non corrispondono"),
        "syncRegisterRoute_email":
            MessageLookupByLibrary.simpleMessage("Email"),
        "syncRegisterRoute_email_empty": MessageLookupByLibrary.simpleMessage(
            "L\'email non può essere vuota"),
        "syncRegisterRoute_email_invalidFormat":
            MessageLookupByLibrary.simpleMessage(
                "Formato dell\'email non valido"),
        "syncRegisterRoute_password":
            MessageLookupByLibrary.simpleMessage("Password"),
        "syncRegisterRoute_password_empty":
            MessageLookupByLibrary.simpleMessage(
                "La password non può essere vuota"),
        "syncRegisterRoute_register":
            MessageLookupByLibrary.simpleMessage("Registrazione"),
        "syncRegisterRoute_username":
            MessageLookupByLibrary.simpleMessage("Nome utente"),
        "syncRegisterRoute_username_empty":
            MessageLookupByLibrary.simpleMessage(
                "Il nome utente non può essere vuoto"),
        "sync_accNotFoundError":
            MessageLookupByLibrary.simpleMessage("Account non trovato"),
        "sync_dbConnectionError": MessageLookupByLibrary.simpleMessage(
            "Si è verificato un errore nel connettersi al database, riprova più tardi"),
        "sync_emailAlreadyExistsError": MessageLookupByLibrary.simpleMessage(
            "L\'email inserita sembra essere già registrata"),
        "sync_invalidCredentialsError": MessageLookupByLibrary.simpleMessage(
            "Combinazione nome utente/email e password non valida"),
        "sync_malformedEmailError": MessageLookupByLibrary.simpleMessage(
            "Email non valida o inesistente"),
        "sync_missingNoteIdError": MessageLookupByLibrary.simpleMessage(
            "Non puoi creare un appunto senza id"),
        "sync_notFoundError": MessageLookupByLibrary.simpleMessage(
            "L\'account non è stato trovato"),
        "sync_outOfBoundsError": MessageLookupByLibrary.simpleMessage(
            "La stringa inserita è troppo lunga o troppo corta"),
        "sync_passOutOfBoundsError": MessageLookupByLibrary.simpleMessage(
            "La password inserita è troppo lunga o troppo corta"),
        "sync_userNotFoundError":
            MessageLookupByLibrary.simpleMessage("Utente non trovato"),
        "sync_usernameAlreadyExistsError": MessageLookupByLibrary.simpleMessage(
            "Il nome utente inserito sembra essere già registrato"),
        "sync_usernameNotFoundError":
            MessageLookupByLibrary.simpleMessage("Nome utente non registrato"),
        "sync_usernameOutOfBoundsError": MessageLookupByLibrary.simpleMessage(
            "Il nome utente inserito è troppo lungo o troppo corto"),
        "trash": MessageLookupByLibrary.simpleMessage("Cestino"),
        "undo": MessageLookupByLibrary.simpleMessage("Annulla"),
        "userInfoRoute_avatar_change":
            MessageLookupByLibrary.simpleMessage("Cambia immagine"),
        "userInfoRoute_avatar_remove":
            MessageLookupByLibrary.simpleMessage("Rimuovi immagine"),
        "userInfoRoute_sortByDate":
            MessageLookupByLibrary.simpleMessage("Ordina gli appunti per data"),
        "welcomeRoute_firstPage_catchPhrase":
            MessageLookupByLibrary.simpleMessage(
                "La tua nuova app per gli appunti preferita"),
        "welcomeRoute_fourthPage_description":
            MessageLookupByLibrary.simpleMessage(
                "E con questo hai finito. Finalmente ti puoi divertire! Evviva!"),
        "welcomeRoute_fourthPage_thankyou":
            MessageLookupByLibrary.simpleMessage(
                "Grazie per aver scelto PotatoNotes"),
        "welcomeRoute_fourthPage_title":
            MessageLookupByLibrary.simpleMessage("Setup completato"),
        "welcomeRoute_secondPage_title":
            MessageLookupByLibrary.simpleMessage("Personalizzazione di base"),
        "welcomeRoute_thirdPage_description": MessageLookupByLibrary.simpleMessage(
            "Con un account gratuito PotatoSync, puoi sincronizzare i tuoi appunti tra dispositivi vari. Ed è super semplice ottenerne uno!"),
        "welcomeRoute_thirdPage_getStarted":
            MessageLookupByLibrary.simpleMessage("Iniziamo"),
        "welcomeRoute_thirdPage_success": MessageLookupByLibrary.simpleMessage(
            "Hai configurato PotatoSync con successo. Ben fatto!")
      };
}
