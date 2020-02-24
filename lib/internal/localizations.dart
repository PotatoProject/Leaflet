import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:potato_notes/internal/app_info.dart';
import 'package:potato_notes/l10n/messages_all.dart';

class AppLocalizations {
  static Future<AppLocalizations> load(Locale locale) {
    final String name =
        locale.countryCode == null ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((bool _) {
      Intl.defaultLocale = localeName;
      return new AppLocalizations();
    });
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  /* -- General strings -- */

  String get home => Intl.message("Home", name: "home");
  String get trash => Intl.message("Trash", name: "trash");
  String get archive => Intl.message("Archive", name: "archive");

  String get done => Intl.message("Done", name: "done");
  String get save => Intl.message("Save", name: "save");
  String get confirm => Intl.message("Confirm", name: "confirm");
  String get cancel => Intl.message("Cancel", name: "cancel");
  String get remove => Intl.message("Remove", name: "remove");
  String get reset => Intl.message("Reset", name: "reset");
  String get undo => Intl.message("Undo", name: "undo");

  String get chooseAction =>
      Intl.message("Choose action", name: "chooseAction");

  String get light => Intl.message("Light", name: "light");
  String get dark => Intl.message("Dark", name: "dark");
  String get black => Intl.message("Black", name: "black");

  /* -- Semantics related -- */

  String get semantics_color_beige => Intl.message(
        "Beige",
        name: "semantics_color_beige",
      );

  String get semantics_color_blue => Intl.message(
        "Blue",
        name: "semantics_color_blue",
      );

  String get semantics_color_green => Intl.message(
        "Green",
        name: "semantics_color_green",
      );

  String get semantics_color_none => Intl.message(
        "None",
        name: "semantics_color_none",
      );

  String get semantics_color_orange => Intl.message(
        "Orange",
        name: "semantics_color_orange",
      );

  String get semantics_color_pink => Intl.message(
        "Pink",
        name: "semantics_color_pink",
      );

  String get semantics_color_purple => Intl.message(
        "Purple",
        name: "semantics_color_purple",
      );

  String get semantics_color_yellow => Intl.message(
        "Yellow",
        name: "semantics_color_yellow",
      );
  
  /* -- NotesMainPageRoute related -- */

  String get notesMainPageRoute_noNotes => Intl.message(
        "No notes added... yet",
        name: "notesMainPageRoute_noNotes",
      );

  String get notesMainPageRoute_emptyTrash => Intl.message(
        "Your trash is empty",
        name: "notesMainPageRoute_emptyTrash",
      );

  String get notesMainPageRoute_emptyArchive => Intl.message(
        "You don't have any notes in the archive",
        name: "notesMainPageRoute_emptyArchive",
      );

  String get notesMainPageRoute_writeNote => Intl.message(
        "Write a note",
        name: "notesMainPageRoute_writeNote",
      );

  String get notesMainPageRoute_starred => Intl.message(
        "Starred notes",
        name: "notesMainPageRoute_starred",
      );

  String get notesMainPageRoute_other => Intl.message(
        "Other notes",
        name: "notesMainPageRoute_other",
      );

  String get notesMainPageRoute_note_hiddenContent => Intl.message(
        "Content hidden",
        name: "notesMainPageRoute_note_hiddenContent",
      );

  String get notesMainPageRoute_note_remindersSet => Intl.message(
        "Reminders set for note",
        name: "notesMainPageRoute_note_remindersSet",
      );

  String get notesMainPageRoute_note_deleteDialog_title => Intl.message(
        "Delete selected notes?",
        name: "notesMainPageRoute_note_deleteDialog_title",
      );

  String get notesMainPageRoute_note_deleteDialog_content => Intl.message(
        "Once the notes are deleted from here you can't restore them.\nAre you sure you want to continue?",
        name: "notesMainPageRoute_note_deleteDialog_content",
      );

  String get notesMainPageRoute_note_emptyTrash_title => Intl.message(
        "Empty trash?",
        name: "notesMainPageRoute_note_emptyTrash_title",
      );

  String get notesMainPageRoute_note_emptyTrash_content => Intl.message(
        "Once the notes are deleted from here you can't restore them.\nAre you sure you want to continue?",
        name: "notesMainPageRoute_note_emptyTrash_content",
      );

  String get notesMainPageRoute_note_list_selectedEntries => Intl.message(
        " entries selected",
        name: "notesMainPageRoute_note_list_selectedEntries",
      );

  String get notesMainPageRoute_pinnedNote => Intl.message(
        "Pinned note",
        name: "notesMainPageRoute_pinnedNote",
      );

  /* -- UserInfoRoute related -- */

  String get userInfoRoute_sortByDate => Intl.message(
        "Sort notes by date",
        name: "userInfoRoute_sortByDate",
      );

  String get userInfoRoute_avatar_change => Intl.message(
        "Change avatar",
        name: "userInfoRoute_avatar_change",
      );

  String get userInfoRoute_avatar_remove => Intl.message(
        "Remove avatar",
        name: "userInfoRoute_avatar_remove",
      );

  /* -- ModifyNotesRoute related -- */

  String get modifyNotesRoute_title => Intl.message(
        "Title",
        name: "modifyNotesRoute_title",
        desc: "Title textfield hint",
      );

  String get modifyNotesRoute_content => Intl.message(
        "Content",
        name: "modifyNotesRoute_content",
        desc: "Content textfield hint",
      );

  String get modifyNotesRoute_list => Intl.message(
        "List",
        name: "modifyNotesRoute_list",
      );

  String get modifyNotesRoute_list_entry => Intl.message(
        "Entry",
        name: "modifyNotesRoute_list_entry",
        desc: "List entry textfield hint",
      );

  String get modifyNotesRoute_list_selectedEntries => Intl.message(
        " checked entries",
        name: "modifyNotesRoute_list_selectedEntries",
        desc: "Text that appears on checked entries header widget",
      );

  String get modifyNotesRoute_image => Intl.message(
        "Image",
        name: "modifyNotesRoute_image",
      );

  String get modifyNotesRoute_image_add => Intl.message(
        "Add image",
        name: "modifyNotesRoute_image_add",
      );

  String get modifyNotesRoute_image_update => Intl.message(
        "Update image",
        name: "modifyNotesRoute_image_update",
      );

  String get modifyNotesRoute_image_remove => Intl.message(
        "Remove image",
        name: "modifyNotesRoute_image_remove",
      );

  String get modifyNotesRoute_reminder => Intl.message(
        "Reminder",
        name: "modifyNotesRoute_reminder",
      );

  String get modifyNotesRoute_reminder_add => Intl.message(
        "Add a new reminder",
        name: "modifyNotesRoute_reminder_add",
      );

  String get modifyNotesRoute_reminder_update => Intl.message(
        "Update reminder",
        name: "modifyNotesRoute_reminder_update",
      );

  String get modifyNotesRoute_reminder_time => Intl.message(
        "Time",
        name: "modifyNotesRoute_reminder_time",
      );

  String get modifyNotesRoute_reminder_date => Intl.message(
        "Date",
        name: "modifyNotesRoute_reminder_date",
      );

  String get modifyNotesRoute_security_hideContent => Intl.message(
        "Hide note content on main page",
        name: "modifyNotesRoute_security_hideContent",
      );

  String get modifyNotesRoute_security_protectionText => Intl.message(
        "Use a protection for hiding",
        name: "modifyNotesRoute_security_protectionText",
      );

  String get modifyNotesRoute_security_pin => Intl.message(
        "PIN",
        name: "modifyNotesRoute_security_pin",
      );

  String get modifyNotesRoute_security_password => Intl.message(
        "Password",
        name: "modifyNotesRoute_security_password",
      );

  String get modifyNotesRoute_security_dialog_titlePin => Intl.message(
        "Set or update PIN",
        name: "modifyNotesRoute_security_dialog_titlePin",
      );

  String get modifyNotesRoute_security_dialog_titlePassword => Intl.message(
        "Set or update password",
        name: "modifyNotesRoute_security_dialog_titlePassword",
      );

  String modifyNotesRoute_security_dialog_lengthExceed(
          String method, String maxLength) =>
      Intl.message(
        "$method length can't exceed $maxLength",
        name: "modifyNotesRoute_security_dialog_lengthExceed",
        args: [method, maxLength],
      );

  String modifyNotesRoute_security_dialog_lengthShort(
          String method, String minLength) =>
      Intl.message(
        "$method length can't be less than $minLength",
        name: "modifyNotesRoute_security_dialog_lengthShort",
        args: [method, minLength],
      );

  String get modifyNotesRoute_security_dialog_valid => Intl.message(
        " valid",
        name: "modifyNotesRoute_security_dialog_valid",
      );

  String get modifyNotesRoute_color_dialogTitle => Intl.message(
        "Note color selector",
        name: "modifyNotesRoute_color_dialogTitle",
      );

  String get modifyNotesRoute_color_change => Intl.message(
        "Change note color",
        name: "modifyNotesRoute_color_change",
        desc:
            "Used in the three dots menu on modify notes route, for modifying note color",
      );

  /* -- SettingsRoute related -- */

  String get settingsRoute_title => Intl.message(
        "Settings",
        name: "settingsRoute_title",
      );

  String get settingsRoute_themes => Intl.message(
        "Themes",
        name: "settingsRoute_themes",
      );

  String get settingsRoute_themes_followSystem => Intl.message(
        "Follow system theme",
        name: "settingsRoute_themes_followSystem",
      );

  String get settingsRoute_themes_systemDarkMode => Intl.message(
        "Auto dark theme mode",
        name: "settingsRoute_themes_systemDarkMode",
      );

  String get settingsRoute_themes_appTheme => Intl.message(
        "App theme",
        name: "settingsRoute_themes_appTheme",
      );

  String get settingsRoute_themes_useCustomAccent => Intl.message(
        "Use custom accent color",
        name: "settingsRoute_themes_useCustomAccent",
      );

  String get settingsRoute_themes_customAccentColor => Intl.message(
        "Custom color",
        name: "settingsRoute_themes_customAccentColor",
      );

  String get settingsRoute_gestures => Intl.message(
        "Gestures",
        name: "settingsRoute_gestures",
      );

  String get settingsRoute_gestures_quickStar => Intl.message(
        "Double tap note to star",
        name: "settingsRoute_gestures_quickStar",
      );

  String get settingsRoute_backupAndRestore => Intl.message(
        "Backup & restore",
        name: "settingsRoute_backupAndRestore",
      );

  String get settingsRoute_backupAndRestore_backup => Intl.message(
        "Backup (Experimental)",
        name: "settingsRoute_backupAndRestore_backup",
      );

  String settingsRoute_backupAndRestore_backup_done(String path) =>
      Intl.message(
        "Backup located at: $path",
        name: "settingsRoute_backupAndRestore_backup_done",
        args: [path],
      );

  String get settingsRoute_backupAndRestore_restore => Intl.message(
        "Restore (Experimental)",
        name: "settingsRoute_backupAndRestore_restore",
      );

  String get settingsRoute_backupAndRestore_restore_success => Intl.message(
        "Done!",
        name: "settingsRoute_backupAndRestore_restore_success",
      );

  String get settingsRoute_backupAndRestore_restore_fail => Intl.message(
        "Corrupted or invalid DB!",
        name: "settingsRoute_backupAndRestore_restore_fail",
      );

  String get settingsRoute_backupAndRestore_regenDbEntries => Intl.message(
        "Regenerate database entries",
        name: "settingsRoute_backupAndRestore_regenDbEntries",
      );

  String get settingsRoute_about => Intl.message(
        "About",
        name: "settingsRoute_about",
      );

  String get settingsRoute_about_potatonotes => Intl.message(
        "About PotatoNotes",
        name: "settingsRoute_about_potatonotes",
      );

  String get settingsRoute_about_potatonotes_development => Intl.message(
        "Developed and mantained by HrX03",
        name: "settingsRoute_about_potatonotes_development",
      );

  String get settingsRoute_about_potatonotes_design => Intl.message(
        "Design, app branding and app logo by RshBfn",
        name: "settingsRoute_about_potatonotes_design",
      );

  String get settingsRoute_about_sourceCode => Intl.message(
        "PotatoNotes source code",
        name: "settingsRoute_about_sourceCode",
      );

  String get settingsRoute_dev => Intl.message(
        "Developer options",
        name: "settingsRoute_dev",
      );

  String get settingsRoute_dev_idLabels => Intl.message(
        "Show id labels",
        name: "settingsRoute_dev_idLabels",
      );

  /* -- SearchNotesRoute related -- */

  String get searchNotesRoute_searchbar => Intl.message(
        "Search...",
        name: "searchNotesRoute_searchbar",
      );

  String get searchNotesRoute_noQuery => Intl.message(
        "Input something to start the search",
        name: "searchNotesRoute_noQuery",
      );

  String get searchNotesRoute_nothingFound => Intl.message(
        "No notes found that match your search terms",
        name: "searchNotesRoute_nothingFound",
      );

  String get searchNotesRoute_filters_title => Intl.message(
        "Search filters",
        name: "searchNotesRoute_filters_title",
      );

  String get searchNotesRoute_filters_case => Intl.message(
        "Case sensitive",
        name: "searchNotesRoute_filters_case",
      );

  String get searchNotesRoute_filters_color => Intl.message(
        "Color filter",
        name: "searchNotesRoute_filters_color",
      );

  String get searchNotesRoute_filters_date => Intl.message(
        "Date filter",
        name: "searchNotesRoute_filters_date",
      );

  /* -- SecurityNoteRoute related -- */

  String get securityNoteRoute_request_pin => Intl.message(
        "A PIN is requested to open the note",
        name: "securityNoteRoute_request_pin",
      );

  String get securityNoteRoute_request_password => Intl.message(
        "A password is requested to open the note",
        name: "securityNoteRoute_request_password",
      );

  String get securityNoteRoute_wrong_pin => Intl.message(
        "Wrong PIN",
        name: "securityNoteRoute_wrong_pin",
      );

  String get securityNoteRoute_wrong_password => Intl.message(
        "Wrong password",
        name: "securityNoteRoute_wrong_password",
      );

  /* -- SyncLoginRoute related -- */

  String get syncLoginRoute_emailOrUsername => Intl.message(
        "Email or username",
        name: "syncLoginRoute_emailOrUsername",
      );

  String get syncLoginRoute_emptyField => Intl.message(
        "This field can't be empty!",
        name: "syncLoginRoute_emptyField",
      );

  String get syncLoginRoute_password => Intl.message(
        "Password",
        name: "syncLoginRoute_password",
      );

  String get syncLoginRoute_register => Intl.message(
        "Register",
        name: "syncLoginRoute_register",
      );

  String get syncLoginRoute_successfulRegistration => Intl.message(
        "Registered with success",
        name: "syncLoginRoute_successfulRegistration",
      );

  String get syncLoginRoute_login => Intl.message(
        "Login",
        name: "syncLoginRoute_login",
      );

  String get syncLoginRoute_noteConflictDialog_title => Intl.message(
        "Notes found on your account",
        name: "syncLoginRoute_noteConflictDialog_title",
      );

  String get syncLoginRoute_noteConflictDialog_content => Intl.message(
        "Saved notes and synced notes conflict.\nWhat do you want to do?",
        name: "syncLoginRoute_noteConflictDialog_content",
      );

  String get syncLoginRoute_noteConflictDialog_keep => Intl.message(
        "Keep current and upload them",
        name: "syncLoginRoute_noteConflictDialog_keep",
      );

  String get syncLoginRoute_noteConflictDialog_replace => Intl.message(
        "Replace saved with cloud",
        name: "syncLoginRoute_noteConflictDialog_replace",
      );

  /* -- SyncRegisterRoute related -- */

  String get syncRegisterRoute_register => Intl.message(
        "Register",
        name: "syncRegisterRoute_register",
      );

  String get syncRegisterRoute_username => Intl.message(
        "Username",
        name: "syncRegisterRoute_username",
      );

  String get syncRegisterRoute_username_empty => Intl.message(
        "Username can't be empty",
        name: "syncRegisterRoute_username_empty",
      );

  String get syncRegisterRoute_email => Intl.message(
        "Email",
        name: "syncRegisterRoute_email",
      );

  String get syncRegisterRoute_email_empty => Intl.message(
        "Email can't be empty",
        name: "syncRegisterRoute_email_empty",
      );

  String get syncRegisterRoute_email_invalidFormat => Intl.message(
        "Invalid email format",
        name: "syncRegisterRoute_email_invalidFormat",
      );

  String get syncRegisterRoute_password => Intl.message(
        "Password",
        name: "syncRegisterRoute_password",
      );

  String get syncRegisterRoute_password_empty => Intl.message(
        "Password can't be empty",
        name: "syncRegisterRoute_password_empty",
      );

  String get syncRegisterRoute_confirmPassword => Intl.message(
        "Confirm password",
        name: "syncRegisterRoute_confirmPassword",
      );

  String get syncRegisterRoute_confirmPassword_noMatch => Intl.message(
        "Password don't match",
        name: "syncRegisterRoute_confirmPassword_noMatch",
      );

  /* -- SyncManageRoute related -- */

  String get syncManageRoute_account => Intl.message(
        "Account",
        name: "syncManageRoute_account",
      );

  String syncManageRoute_account_loggedInAs(String username) =>
      Intl.message("Logged in as: $username",
          name: "syncManageRoute_account_loggedInAs", args: [username]);

  String get syncManageRoute_account_logout => Intl.message(
        "Logout",
        name: "syncManageRoute_account_logout",
      );

  String get syncManageRoute_account_guest => Intl.message(
        "Guest",
        name: "syncManageRoute_account_guest",
      );

  String get syncManageRoute_account_changeUsername => Intl.message(
        "Change username",
        name: "syncManageRoute_account_changeUsername",
      );

  String get syncManageRoute_account_changeImage => Intl.message(
        "Change image",
        name: "syncManageRoute_account_changeImage",
      );

  String get syncManageRoute_sync => Intl.message(
        "Sync",
        name: "syncManageRoute_sync",
      );

  String get syncManageRoute_sync_enableAutoSync => Intl.message(
        "Enable auto sync",
        name: "syncManageRoute_sync_enableAutoSync",
      );

  String get syncManageRoute_sync_autoSyncInterval => Intl.message(
        "Auto-sync time interval (seconds)",
        name: "syncManageRoute_sync_autoSyncInterval",
      );

  /* -- WelcomeRoute related -- */

  String get welcomeRoute_firstPage_catchPhrase => Intl.message(
        "Your new favourite notes app",
        name: "welcomeRoute_firstPage_catchPhrase",
      );

  String get welcomeRoute_secondPage_title => Intl.message(
        "Basic customization",
        name: "welcomeRoute_secondPage_title",
      );

  String get welcomeRoute_thirdPage_description => Intl.message(
        "With a free PotatoSync account, you can sync your notes between multiple devices. And it’s super easy to get one!",
        name: "welcomeRoute_thirdPage_description",
      );

  String get welcomeRoute_thirdPage_success => Intl.message(
        "PotatoSync has been configured successfully. Well done!",
        name: "welcomeRoute_thirdPage_success",
      );

  String get welcomeRoute_thirdPage_getStarted => Intl.message(
        "Get started",
        name: "welcomeRoute_thirdPage_getStarted",
      );

  String get welcomeRoute_fourthPage_title => Intl.message(
        "Setup complete",
        name: "welcomeRoute_fourthPage_title",
      );

  String get welcomeRoute_fourthPage_description => Intl.message(
        "And with this you’re finally done. Now you can finally have fun! Hooray!",
        name: "welcomeRoute_fourthPage_description",
      );

  String get welcomeRoute_fourthPage_thankyou => Intl.message(
        "Thanks for choosing PotatoNotes",
        name: "welcomeRoute_fourthPage_thankyou",
      );

  /* -- General note related -- */

  String get note_select => Intl.message(
        "Select",
        name: "note_select",
        desc: "String for selecting a note",
      );

  String get note_edit => Intl.message(
        "Edit",
        name: "note_edit",
        desc: "String for editing a note",
      );

  String get note_emptyTrash => Intl.message(
        "Empty trash",
        name: "note_emptyTrash",
      );

  String get note_delete => Intl.message(
        "Delete",
        name: "note_delete",
        desc: "String for deleting a note",
      );

  String get note_delete_snackbar => Intl.message(
        "Note deleted",
        name: "note_delete_snackbar",
        desc: "Appears on snackbar upon note deletion",
      );

  String get notes_delete_snackbar => Intl.message(
        "Notes deleted",
        name: "notes_delete_snackbar",
        desc: "Appears on snackbar upon notes deletion",
      );

  String get note_restore_snackbar => Intl.message(
        "Note restored",
        name: "note_restore_snackbar",
      );

  String get notes_restore_snackbar => Intl.message(
        "Notes restored",
        name: "notes_restore_snackbar",
      );

  String get note_archive_snackbar => Intl.message(
        "Note archived",
        name: "note_archive_snackbar",
        desc: "Appears on snackbar upon note archivation",
      );

  String get notes_archive_snackbar => Intl.message(
        "Notes archived",
        name: "notes_archive_snackbar",
        desc: "Appears on snackbar upon notes archivation",
      );

  String get note_removeFromArchive_snackbar => Intl.message(
        "Note removed from archived",
        name: "note_removeFromArchive_snackbar",
        desc: "Appears on snackbar upon note archivation",
      );

  String get notes_removeFromArchive_snackbar => Intl.message(
        "Notes removed from archived",
        name: "notes_removeFromArchive_snackbar",
        desc: "Appears on snackbar upon notes archivation",
      );

  String get note_star => Intl.message(
        "Star",
        name: "note_star",
        desc: "String for starring a note",
      );

  String get note_unstar => Intl.message(
        "Unstar",
        name: "note_unstar",
        desc: "String for unstarring a note",
      );

  String get note_share => Intl.message(
        "Share",
        name: "note_share",
        desc: "String for sharing a note",
      );

  String get note_export => Intl.message(
        "Export",
        name: "note_export",
        desc: "String for exporting a note",
      );

  String get note_exportLocation => Intl.message(
        "Note exported at",
        name: "note_exportLocation",
        desc:
            "Used on the snackbar that appears when exporting a note, followed by the note path",
      );

  String get note_lockedOptions => Intl.message(
        "Note is locked, use the options on the note screen",
        name: "note_lockedOptions",
      );

  String get note_pinToNotifs => Intl.message(
        "Pin to notifications",
        name: "note_pinToNotifs",
        desc: "String for pinning a note to notifications",
      );

  /* -- Sync api related -- */

  String get sync_malformedEmailError => Intl.message(
        "Malformed or missing email",
        name: "sync_malformedEmailError",
      );

  String get sync_usernameOutOfBoundsError => Intl.message(
        "The username you entered is too long or too short",
        name: "sync_usernameOutOfBoundsError",
      );

  String get sync_passOutOfBoundsError => Intl.message(
        "The password you entered is too long or too short",
        name: "sync_passOutOfBoundsError",
      );

  String get sync_dbConnectionError => Intl.message(
        "There was a problem connecting to the database, retry later",
        name: "sync_dbConnectionError",
      );

  String get sync_emailAlreadyExistsError => Intl.message(
        "The email you entered seems to be already registered",
        name: "sync_emailAlreadyExistsError",
      );

  String get sync_usernameAlreadyExistsError => Intl.message(
        "The username you entered seems to be already registered",
        name: "sync_usernameAlreadyExistsError",
      );

  String get sync_usernameNotFoundError => Intl.message(
        "This username isn't registered",
        name: "sync_usernameNotFoundError",
      );

  String get sync_invalidCredentialsError => Intl.message(
        "Bad username/email and password combination",
        name: "sync_invalidCredentialsError",
      );

  String get sync_notFoundError => Intl.message(
        "The account was not found",
        name: "sync_notFoundError",
      );

  String get sync_userNotFoundError => Intl.message(
        "The user was not found",
        name: "sync_userNotFoundError",
      );

  String get sync_outOfBoundsError => Intl.message(
        "The input you entered is too long or too short",
        name: "sync_outOfBoundsError",
      );

  String get sync_accNotFoundError => Intl.message(
        "The account was not found",
        name: "sync_accNotFoundError",
      );

  String get sync_missingNoteIdError => Intl.message(
        "You can't create a note without an id",
        name: "sync_missingNoteIdError",
      );
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppInfoProvider.supportedLocales.contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return AppLocalizations.load(locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}
