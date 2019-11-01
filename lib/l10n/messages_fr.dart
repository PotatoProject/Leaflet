// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a fr locale. All the
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
  String get localeName => 'fr';

  static m0(method, maxLength) => "La longueur de ${method} ne peut pas dépasser ${maxLength} caractères";

  static m1(method, minLength) => "La longueur de ${method} ne peut pas être inférieure à ${minLength} caractères";

  static m2(path) => "Sauvegarde effectuée, et se trouve à : ${path}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "archive" : MessageLookupByLibrary.simpleMessage("Archive"),
    "black" : MessageLookupByLibrary.simpleMessage("Noir"),
    "cancel" : MessageLookupByLibrary.simpleMessage("Annuler"),
    "chooseAction" : MessageLookupByLibrary.simpleMessage("Choisissez une option"),
    "confirm" : MessageLookupByLibrary.simpleMessage("Confirmer"),
    "dark" : MessageLookupByLibrary.simpleMessage("Sombre"),
    "done" : MessageLookupByLibrary.simpleMessage("Terminé"),
    "light" : MessageLookupByLibrary.simpleMessage("Clair"),
    "modifyNotesRoute_color_change" : MessageLookupByLibrary.simpleMessage("Changer la couleur de la note"),
    "modifyNotesRoute_color_dialogTitle" : MessageLookupByLibrary.simpleMessage("Couleur de la note"),
    "modifyNotesRoute_content" : MessageLookupByLibrary.simpleMessage("Contenu"),
    "modifyNotesRoute_image" : MessageLookupByLibrary.simpleMessage("Image"),
    "modifyNotesRoute_image_add" : MessageLookupByLibrary.simpleMessage("Ajouter une image"),
    "modifyNotesRoute_image_remove" : MessageLookupByLibrary.simpleMessage("Supprimer l\'image"),
    "modifyNotesRoute_image_update" : MessageLookupByLibrary.simpleMessage("Changer l\'image"),
    "modifyNotesRoute_list" : MessageLookupByLibrary.simpleMessage("Liste"),
    "modifyNotesRoute_list_entry" : MessageLookupByLibrary.simpleMessage("Entrée"),
    "modifyNotesRoute_list_selectedEntries" : MessageLookupByLibrary.simpleMessage(" entrées vérifiées"),
    "modifyNotesRoute_reminder" : MessageLookupByLibrary.simpleMessage("Rappel"),
    "modifyNotesRoute_reminder_add" : MessageLookupByLibrary.simpleMessage("Ajouter un rappel"),
    "modifyNotesRoute_reminder_date" : MessageLookupByLibrary.simpleMessage("Date"),
    "modifyNotesRoute_reminder_time" : MessageLookupByLibrary.simpleMessage("Temps"),
    "modifyNotesRoute_reminder_update" : MessageLookupByLibrary.simpleMessage("Rappel de mise à jour"),
    "modifyNotesRoute_security_dialog_lengthExceed" : m0,
    "modifyNotesRoute_security_dialog_lengthShort" : m1,
    "modifyNotesRoute_security_dialog_titlePassword" : MessageLookupByLibrary.simpleMessage("Définir ou changer le mot de passe"),
    "modifyNotesRoute_security_dialog_titlePin" : MessageLookupByLibrary.simpleMessage("Définir ou changer le code PIN"),
    "modifyNotesRoute_security_dialog_valid" : MessageLookupByLibrary.simpleMessage(" valide"),
    "modifyNotesRoute_security_hideContent" : MessageLookupByLibrary.simpleMessage("Masquer le contenu de la note sur le menu principal"),
    "modifyNotesRoute_security_password" : MessageLookupByLibrary.simpleMessage("Mot de passe"),
    "modifyNotesRoute_security_pin" : MessageLookupByLibrary.simpleMessage("PIN"),
    "modifyNotesRoute_security_protectionText" : MessageLookupByLibrary.simpleMessage("Utiliser une protection pour cacher les notes"),
    "modifyNotesRoute_title" : MessageLookupByLibrary.simpleMessage("Titre"),
    "note_archive_snackbar" : MessageLookupByLibrary.simpleMessage("Note archivée"),
    "note_delete" : MessageLookupByLibrary.simpleMessage("Supprimer"),
    "note_delete_snackbar" : MessageLookupByLibrary.simpleMessage("Note supprimée"),
    "note_edit" : MessageLookupByLibrary.simpleMessage("Modifier"),
    "note_emptryTrash" : MessageLookupByLibrary.simpleMessage("Corbeille vide"),
    "note_export" : MessageLookupByLibrary.simpleMessage("Exporter"),
    "note_exportLocation" : MessageLookupByLibrary.simpleMessage("Note exportée à"),
    "note_lockedOptions" : MessageLookupByLibrary.simpleMessage("Cette note est verouillée, veuillez utiliser les options sur l\'écran de la note pour changer cela"),
    "note_pinToNotifs" : MessageLookupByLibrary.simpleMessage("Épingler en tant que notification"),
    "note_removeFromArchive_snackbar" : MessageLookupByLibrary.simpleMessage("Note supprimée des archives"),
    "note_restore_snackbar" : MessageLookupByLibrary.simpleMessage("Note restaurée"),
    "note_select" : MessageLookupByLibrary.simpleMessage("Sélectionner"),
    "note_share" : MessageLookupByLibrary.simpleMessage("Partager"),
    "note_star" : MessageLookupByLibrary.simpleMessage("Ajouter aux favoris"),
    "note_unstar" : MessageLookupByLibrary.simpleMessage("Supprimer des favoris"),
    "notes" : MessageLookupByLibrary.simpleMessage("Notes"),
    "notesMainPageRoute_emptyArchive" : MessageLookupByLibrary.simpleMessage("Vous n\'avez aucune note dans l\'archive"),
    "notesMainPageRoute_emptyTrash" : MessageLookupByLibrary.simpleMessage("Votre corbeille est vide"),
    "notesMainPageRoute_noNotes" : MessageLookupByLibrary.simpleMessage("Aucune note ajoutée... Pour le moment"),
    "notesMainPageRoute_note_deleteDialog_content" : MessageLookupByLibrary.simpleMessage("Une fois que les notes seront supprimées, vous ne pourrez pas les récupérer.\nÊtes-vous sûr de vouloir continuer ?"),
    "notesMainPageRoute_note_deleteDialog_title" : MessageLookupByLibrary.simpleMessage("Supprimer les notes sélectionnées ?"),
    "notesMainPageRoute_note_emptyTrash_content" : MessageLookupByLibrary.simpleMessage("Une fois que les notes seront supprimées, vous ne pourrez pas les récupérer.\nÊtes-vous sûr de vouloir continuer ?"),
    "notesMainPageRoute_note_emptyTrash_title" : MessageLookupByLibrary.simpleMessage("Vider la corbeille ?"),
    "notesMainPageRoute_note_hiddenContent" : MessageLookupByLibrary.simpleMessage("Contenu masqué"),
    "notesMainPageRoute_note_list_selectedEntries" : MessageLookupByLibrary.simpleMessage(" entrées sélectionnées"),
    "notesMainPageRoute_note_remindersSet" : MessageLookupByLibrary.simpleMessage("Rappel défini pour la note"),
    "notesMainPageRoute_other" : MessageLookupByLibrary.simpleMessage("Autres notes"),
    "notesMainPageRoute_pinnedNote" : MessageLookupByLibrary.simpleMessage("Note épinglée"),
    "notesMainPageRoute_starred" : MessageLookupByLibrary.simpleMessage("Notes favorites"),
    "notesMainPageRoute_writeNote" : MessageLookupByLibrary.simpleMessage("Écrire une Note"),
    "notes_archive_snackbar" : MessageLookupByLibrary.simpleMessage("Notes archivées"),
    "notes_delete_snackbar" : MessageLookupByLibrary.simpleMessage("Notes supprimées"),
    "notes_removeFromArchive_snackbar" : MessageLookupByLibrary.simpleMessage("Notes supprimées des archives"),
    "notes_restore_snackbar" : MessageLookupByLibrary.simpleMessage("Notes restaurées"),
    "remove" : MessageLookupByLibrary.simpleMessage("Supprimer"),
    "reset" : MessageLookupByLibrary.simpleMessage("Réinitialiser"),
    "save" : MessageLookupByLibrary.simpleMessage("Sauvegarder"),
    "searchNotesRoute_filters_case" : MessageLookupByLibrary.simpleMessage("Sensible à la casse"),
    "searchNotesRoute_filters_color" : MessageLookupByLibrary.simpleMessage("Filtrer par couleur"),
    "searchNotesRoute_filters_date" : MessageLookupByLibrary.simpleMessage("Filtrer par date"),
    "searchNotesRoute_filters_title" : MessageLookupByLibrary.simpleMessage("Filtres de recherches"),
    "searchNotesRoute_noQuery" : MessageLookupByLibrary.simpleMessage("Ecrivez quelque chose pour pouvoir le rechercher"),
    "searchNotesRoute_nothingFound" : MessageLookupByLibrary.simpleMessage("Aucune note a été trouvée correspondant à votre recherche"),
    "searchNotesRoute_searchbar" : MessageLookupByLibrary.simpleMessage("Rechercher..."),
    "securityNoteRoute_request_password" : MessageLookupByLibrary.simpleMessage("Un mot de passe est obligatoire pour ouvrir cette note"),
    "securityNoteRoute_request_pin" : MessageLookupByLibrary.simpleMessage("Un code PIN est obligatoire pour ouvrir cette note"),
    "securityNoteRoute_wrong_password" : MessageLookupByLibrary.simpleMessage("Mot de passe incorrect"),
    "securityNoteRoute_wrong_pin" : MessageLookupByLibrary.simpleMessage("Code PIN incorrect"),
    "settingsRoute_about" : MessageLookupByLibrary.simpleMessage("À propos"),
    "settingsRoute_about_potatonotes" : MessageLookupByLibrary.simpleMessage("À propos de PotatoNotes"),
    "settingsRoute_about_potatonotes_design" : MessageLookupByLibrary.simpleMessage("Design, apposition de l\'application et logo de l\'application fait par RshBfn"),
    "settingsRoute_about_potatonotes_development" : MessageLookupByLibrary.simpleMessage("Développé et maintenu par HrX03"),
    "settingsRoute_about_sourceCode" : MessageLookupByLibrary.simpleMessage("Code source de PotatoNotes"),
    "settingsRoute_backupAndRestore" : MessageLookupByLibrary.simpleMessage("Sauvegarder et restaurer"),
    "settingsRoute_backupAndRestore_backup" : MessageLookupByLibrary.simpleMessage("Sauvegarder (expérimental)"),
    "settingsRoute_backupAndRestore_backup_done" : m2,
    "settingsRoute_backupAndRestore_regenDbEntries" : MessageLookupByLibrary.simpleMessage("Régénérer les entrées de la base de données"),
    "settingsRoute_backupAndRestore_restore" : MessageLookupByLibrary.simpleMessage("Restaurer (expérimental)"),
    "settingsRoute_backupAndRestore_restore_fail" : MessageLookupByLibrary.simpleMessage("Base de données corrompues ou invalide !"),
    "settingsRoute_backupAndRestore_restore_success" : MessageLookupByLibrary.simpleMessage("Terminé !"),
    "settingsRoute_dev" : MessageLookupByLibrary.simpleMessage("Options pour les développeurs"),
    "settingsRoute_dev_idLabels" : MessageLookupByLibrary.simpleMessage("Afficher les étiquettes"),
    "settingsRoute_gestures" : MessageLookupByLibrary.simpleMessage("Gestes"),
    "settingsRoute_gestures_quickStar" : MessageLookupByLibrary.simpleMessage("Tapez deux fois sur une note pour la mettre en favori"),
    "settingsRoute_themes" : MessageLookupByLibrary.simpleMessage("Thèmes"),
    "settingsRoute_themes_appTheme" : MessageLookupByLibrary.simpleMessage("Thème de l\'application"),
    "settingsRoute_themes_customAccentColor" : MessageLookupByLibrary.simpleMessage("Couleur personnalisée"),
    "settingsRoute_themes_followSystem" : MessageLookupByLibrary.simpleMessage("Suivre le thème du système"),
    "settingsRoute_themes_systemDarkMode" : MessageLookupByLibrary.simpleMessage("Thème sombre automatique"),
    "settingsRoute_themes_useCustomAccent" : MessageLookupByLibrary.simpleMessage("Utiliser une couleur d\'accentuation différente"),
    "settingsRoute_title" : MessageLookupByLibrary.simpleMessage("Paramètres"),
    "trash" : MessageLookupByLibrary.simpleMessage("Poubelle"),
    "undo" : MessageLookupByLibrary.simpleMessage("Annuler"),
    "userInfoRoute_avatar_change" : MessageLookupByLibrary.simpleMessage("Changer la photo de profil"),
    "userInfoRoute_avatar_remove" : MessageLookupByLibrary.simpleMessage("Supprimer la photo de profil"),
    "userInfoRoute_sortByDate" : MessageLookupByLibrary.simpleMessage("Trier les notes par leur date")
  };
}
