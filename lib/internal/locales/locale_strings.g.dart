// @dart=2.12

import 'package:easy_localization/easy_localization.dart';

class LocaleStrings {
  LocaleStrings._();

  static _$CommonLocaleStrings get common => _$CommonLocaleStrings();
  static _$MainPageLocaleStrings get mainPage => _$MainPageLocaleStrings();
  static _$NotePageLocaleStrings get notePage => _$NotePageLocaleStrings();
  static _$SettingsLocaleStrings get settings => _$SettingsLocaleStrings();
  static _$AboutLocaleStrings get about => _$AboutLocaleStrings();
  static _$SearchLocaleStrings get search => _$SearchLocaleStrings();
  static _$DrawingLocaleStrings get drawing => _$DrawingLocaleStrings();
  static _$SetupLocaleStrings get setup => _$SetupLocaleStrings();
  static _$BackupRestoreLocaleStrings get backupRestore => _$BackupRestoreLocaleStrings();
  static _$MiscellaneousLocaleStrings get miscellaneous => _$MiscellaneousLocaleStrings();
}

class _$CommonLocaleStrings {
  final String cancel = "common.cancel".tr();
  final String reset = "common.reset".tr();
  final String restore = "common.restore".tr();
  final String confirm = "common.confirm".tr();
  final String save = "common.save".tr();
  final String delete = "common.delete".tr();
  final String undo = "common.undo".tr();
  final String redo = "common.redo".tr();
  final String edit = "common.edit".tr();
  final String goOn = "common.go_on".tr();
  final String exit = "common.exit".tr();
  final String ok = "common.ok".tr();
  final String share = "common.share".tr();
  final String notNow = "common.not_now".tr();
  final String update = "common.update".tr();
  final String expand = "common.expand".tr();
  final String collapse = "common.collapse".tr();
  final String create = "common.create".tr();
  final String close = "common.close".tr();
  /// First arg is current page, second arg is number of pages, ex. (page) 1 of 8
  String xOfY(Object arg1, Object arg2) => "common.x_of_y".tr(args: [arg1.toString(), arg2.toString()]);
  final String newNote = "common.new_note".tr();
  final String newList = "common.new_list".tr();
  final String newImage = "common.new_image".tr();
  final String newDrawing = "common.new_drawing".tr();
  final String importNote = "common.import_note".tr();
  final String biometricsPrompt = "common.biometrics_prompt".tr();
  final String warningCantUndo = "common.warning_cant_undo".tr();
  final String masterPassModify = "common.master_pass.modify".tr();
  final String masterPassConfirm = "common.master_pass.confirm".tr();
  final String masterPassIncorrect = "common.master_pass.incorrect".tr();
  final String backupPasswordTitle = "common.backup_password.title".tr();
  final String backupPasswordUseMasterPass = "common.backup_password.use_master_pass".tr();
  final String restoreDialogTitle = "common.restore_dialog.title".tr();
  String restoreDialogBackupName(Object arg1) => "common.restore_dialog.backup_name".tr(args: [arg1.toString()]);
  String restoreDialogCreationDate(Object arg1) => "common.restore_dialog.creation_date".tr(args: [arg1.toString()]);
  String restoreDialogAppVersion(Object arg1) => "common.restore_dialog.app_version".tr(args: [arg1.toString()]);
  String restoreDialogNoteCount(Object arg1) => "common.restore_dialog.note_count".tr(args: [arg1.toString()]);
  String restoreDialogTagCount(Object arg1) => "common.restore_dialog.tag_count".tr(args: [arg1.toString()]);
  final String areYouSure = "common.are_you_sure".tr();
  final String colorNone = "common.color.none".tr();
  final String colorRed = "common.color.red".tr();
  final String colorOrange = "common.color.orange".tr();
  final String colorYellow = "common.color.yellow".tr();
  final String colorGreen = "common.color.green".tr();
  final String colorCyan = "common.color.cyan".tr();
  final String colorLightBlue = "common.color.light_blue".tr();
  final String colorBlue = "common.color.blue".tr();
  final String colorPurple = "common.color.purple".tr();
  final String colorPink = "common.color.pink".tr();
  final String notificationDefaultTitle = "common.notification.default_title".tr();
  final String notificationDetailsTitle = "common.notification.details_title".tr();
  final String notificationDetailsDesc = "common.notification.details_desc".tr();
  final String tagNew = "common.tag.new".tr();
  final String tagModify = "common.tag.modify".tr();
  final String tagTextboxHint = "common.tag.textbox_hint".tr();
}

class _$MainPageLocaleStrings {
  final String writeNote = "main_page.write_note".tr();
  final String settings = "main_page.settings".tr();
  final String search = "main_page.search".tr();
  final String account = "main_page.account".tr();
  final String restorePromptArchive = "main_page.restore_prompt.archive".tr();
  final String restorePromptTrash = "main_page.restore_prompt.trash".tr();
  final String tagDeletePrompt = "main_page.tag_delete_prompt".tr();
  final String deletedEmptyNote = "main_page.deleted_empty_note".tr();
  final String emptyStateHome = "main_page.empty_state.home".tr();
  final String emptyStateArchive = "main_page.empty_state.archive".tr();
  final String emptyStateTrash = "main_page.empty_state.trash".tr();
  final String emptyStateFavourites = "main_page.empty_state.favourites".tr();
  final String emptyStateTag = "main_page.empty_state.tag".tr();
  /// Gets displayed when the note has overflowing list items
  String noteListXMoreItems(num value) => "main_page.note_list_x_more_items".plural(value);
  final String titleNotes = "main_page.title.notes".tr();
  final String titleArchive = "main_page.title.archive".tr();
  final String titleTrash = "main_page.title.trash".tr();
  final String titleFavourites = "main_page.title.favourites".tr();
  final String titleTag = "main_page.title.tag".tr();
  final String titleAll = "main_page.title.all".tr();
  final String selectionBarClose = "main_page.selection_bar.close".tr();
  final String selectionBarSelect = "main_page.selection_bar.select".tr();
  final String selectionBarSelectAll = "main_page.selection_bar.select_all".tr();
  final String selectionBarAddFavourites = "main_page.selection_bar.add_favourites".tr();
  final String selectionBarRemoveFavourites = "main_page.selection_bar.remove_favourites".tr();
  final String selectionBarChangeColor = "main_page.selection_bar.change_color".tr();
  /// Verb not noun, to archive
  final String selectionBarArchive = "main_page.selection_bar.archive".tr();
  final String selectionBarDelete = "main_page.selection_bar.delete".tr();
  final String selectionBarPermaDelete = "main_page.selection_bar.perma_delete".tr();
  /// Pin to notifications shade
  final String selectionBarPin = "main_page.selection_bar.pin".tr();
  /// Unpin from notifications shade
  final String selectionBarUnpin = "main_page.selection_bar.unpin".tr();
  /// Option to export note to local storage
  final String selectionBarSave = "main_page.selection_bar.save".tr();
  final String selectionBarSaveNoteLocked = "main_page.selection_bar.save.note_locked".tr();
  final String selectionBarSaveSuccess = "main_page.selection_bar.save.success".tr();
  final String selectionBarSaveOopsie = "main_page.selection_bar.save.oopsie".tr();
  final String selectionBarShare = "main_page.selection_bar.share".tr();
  String notesDeleted(num value) => "main_page.notes_deleted".plural(value);
  String notesPermaDeleted(num value) => "main_page.notes_perma_deleted".plural(value);
  String notesArchived(num value) => "main_page.notes_archived".plural(value);
  String notesRestored(num value) => "main_page.notes_restored".plural(value);
  final String exportSuccess = "main_page.export.success".tr();
  final String exportFailure = "main_page.export.failure".tr();
}

class _$NotePageLocaleStrings {
  final String titleHint = "note_page.title_hint".tr();
  final String contentHint = "note_page.content_hint".tr();
  final String listItemHint = "note_page.list_item_hint".tr();
  final String addEntryHint = "note_page.add_entry_hint".tr();
  final String toolbarTags = "note_page.toolbar.tags".tr();
  final String toolbarColor = "note_page.toolbar.color".tr();
  final String toolbarAddItem = "note_page.toolbar.add_item".tr();
  final String privacyTitle = "note_page.privacy.title".tr();
  final String privacyHideContent = "note_page.privacy.hide_content".tr();
  final String privacyLockNote = "note_page.privacy.lock_note".tr();
  final String privacyLockNoteMissingPass = "note_page.privacy.lock_note.missing_pass".tr();
  final String privacyUseBiometrics = "note_page.privacy.use_biometrics".tr();
  final String toggleList = "note_page.toggle_list".tr();
  final String imageGallery = "note_page.image_gallery".tr();
  final String imageCamera = "note_page.image_camera".tr();
  final String drawing = "note_page.drawing".tr();
  final String addedFavourites = "note_page.added_favourites".tr();
  final String removedFavourites = "note_page.removed_favourites".tr();
}

class _$SettingsLocaleStrings {
  final String title = "settings.title".tr();
  final String personalizationTitle = "settings.personalization.title".tr();
  final String personalizationThemeMode = "settings.personalization.theme_mode".tr();
  final String personalizationThemeModeSystem = "settings.personalization.theme_mode.system".tr();
  final String personalizationThemeModeLight = "settings.personalization.theme_mode.light".tr();
  final String personalizationThemeModeDark = "settings.personalization.theme_mode.dark".tr();
  final String personalizationUseAmoled = "settings.personalization.use_amoled".tr();
  final String personalizationUseCustomAccent = "settings.personalization.use_custom_accent".tr();
  final String personalizationCustomAccent = "settings.personalization.custom_accent".tr();
  final String personalizationUseGrid = "settings.personalization.use_grid".tr();
  final String personalizationLocale = "settings.personalization.locale".tr();
  final String personalizationLocaleDeviceDefault = "settings.personalization.locale.device_default".tr();
  final String privacyTitle = "settings.privacy.title".tr();
  final String privacyUseMasterPass = "settings.privacy.use_master_pass".tr();
  final String privacyUseMasterPassDisclaimer = "settings.privacy.use_master_pass.disclaimer".tr();
  final String privacyModifyMasterPass = "settings.privacy.modify_master_pass".tr();
  final String backupRestoreTitle = "settings.backup_restore.title".tr();
  final String backupRestoreBackup = "settings.backup_restore.backup".tr();
  final String backupRestoreBackupDesc = "settings.backup_restore.backup_desc".tr();
  final String backupRestoreBackupNothingToRestoreTitle = "settings.backup_restore.backup.nothing_to_restore.title".tr();
  final String backupRestoreBackupNothingToRestoreDesc = "settings.backup_restore.backup.nothing_to_restore.desc".tr();
  final String backupRestoreRestore = "settings.backup_restore.restore".tr();
  final String backupRestoreRestoreDesc = "settings.backup_restore.restore_desc".tr();
  final String backupRestoreRestoreStatusSuccess = "settings.backup_restore.restore.status.success".tr();
  final String backupRestoreRestoreStatusWrongFormat = "settings.backup_restore.restore.status.wrong_format".tr();
  final String backupRestoreRestoreStatusWrongPassword = "settings.backup_restore.restore.status.wrong_password".tr();
  final String backupRestoreRestoreStatusAlreadyExists = "settings.backup_restore.restore.status.already_exists".tr();
  final String backupRestoreRestoreStatusUnknown = "settings.backup_restore.restore.status.unknown".tr();
  final String backupRestoreImport = "settings.backup_restore.import".tr();
  final String backupRestoreImportDesc = "settings.backup_restore.import_desc".tr();
  final String infoTitle = "settings.info.title".tr();
  final String infoAboutApp = "settings.info.about_app".tr();
  final String infoUpdateCheck = "settings.info.update_check".tr();
  final String infoBugReport = "settings.info.bug_report".tr();
  final String debugTitle = "settings.debug.title".tr();
  final String debugShowSetupScreen = "settings.debug.show_setup_screen".tr();
  final String debugLoadingOverlay = "settings.debug.loading_overlay".tr();
  final String debugClearDatabase = "settings.debug.clear_database".tr();
  final String debugMigrateDatabase = "settings.debug.migrate_database".tr();
  final String debugGenerateTrash = "settings.debug.generate_trash".tr();
  final String debugLogLevel = "settings.debug.log_level".tr();
}

class _$AboutLocaleStrings {
  final String title = "about.title".tr();
  final String pwaVersion = "about.pwa_version".tr();
  final String links = "about.links".tr();
  final String contributors = "about.contributors".tr();
  final String contributorsHrx = "about.contributors.hrx".tr();
  final String contributorsBas = "about.contributors.bas".tr();
  final String contributorsNico = "about.contributors.nico".tr();
  final String contributorsKat = "about.contributors.kat".tr();
  final String contributorsRohit = "about.contributors.rohit".tr();
  final String contributorsRshbfn = "about.contributors.rshbfn".tr();
  final String contributorsElias = "about.contributors.elias".tr();
  final String contributorsAkshit = "about.contributors.akshit".tr();
}

class _$SearchLocaleStrings {
  final String textboxHint = "search.textbox_hint".tr();
  final String tagCreateEmptyHint = "search.tag_create_empty_hint".tr();
  String tagCreateHint(Object arg1) => "search.tag_create_hint".tr(args: [arg1.toString()]);
  final String typeToSearch = "search.type_to_search".tr();
  final String nothingFound = "search.nothing_found".tr();
  final String noteFiltersCaseSensitive = "search.note.filters.case_sensitive".tr();
  final String noteFiltersFavourites = "search.note.filters.favourites".tr();
  final String noteFiltersLocations = "search.note.filters.locations".tr();
  final String noteFiltersLocationsNormal = "search.note.filters.locations.normal".tr();
  final String noteFiltersLocationsArchive = "search.note.filters.locations.archive".tr();
  final String noteFiltersLocationsTrash = "search.note.filters.locations.trash".tr();
  final String noteFiltersLocationsNormalTitle = "search.note.filters.locations.normal_title".tr();
  final String noteFiltersLocationsArchiveTitle = "search.note.filters.locations.archive_title".tr();
  final String noteFiltersLocationsTrashTitle = "search.note.filters.locations.trash_title".tr();
  final String noteFiltersColor = "search.note.filters.color".tr();
  final String noteFiltersDate = "search.note.filters.date".tr();
  final String noteFiltersDateModeTitle = "search.note.filters.date.mode_title".tr();
  final String noteFiltersDateModeAfter = "search.note.filters.date.mode_after".tr();
  final String noteFiltersDateModeExact = "search.note.filters.date.mode_exact".tr();
  final String noteFiltersDateModeBefore = "search.note.filters.date.mode_before".tr();
  final String noteFiltersTags = "search.note.filters.tags".tr();
  String noteFiltersTagsSelected(num value) => "search.note.filters.tags.selected".plural(value);
  final String noteFiltersClear = "search.note.filters.clear".tr();
}

class _$DrawingLocaleStrings {
  final String colorBlack = "drawing.color_black".tr();
  final String exitPrompt = "drawing.exit_prompt".tr();
  final String clearCanvasWarning = "drawing.clear_canvas_warning".tr();
  final String toolsBrush = "drawing.tools.brush".tr();
  final String toolsEraser = "drawing.tools.eraser".tr();
  final String toolsMarker = "drawing.tools.marker".tr();
  final String toolsColorPicker = "drawing.tools.color_picker".tr();
  final String toolsRadiusPicker = "drawing.tools.radius_picker".tr();
  final String toolsClear = "drawing.tools.clear".tr();
}

class _$SetupLocaleStrings {
  final String buttonGetStarted = "setup.button.get_started".tr();
  final String buttonFinish = "setup.button.finish".tr();
  final String buttonNext = "setup.button.next".tr();
  final String buttonBack = "setup.button.back".tr();
  final String welcomeCatchphrase = "setup.welcome.catchphrase".tr();
  final String basicCustomizationTitle = "setup.basic_customization.title".tr();
  final String restoreImportTitle = "setup.restore_import.title".tr();
  final String restoreImportDesc = "setup.restore_import.desc".tr();
  final String finishTitle = "setup.finish.title".tr();
  final String finishLastWords = "setup.finish.last_words".tr();
}

class _$BackupRestoreLocaleStrings {
  final String backupTitle = "backup_restore.backup.title".tr();
  final String backupPassword = "backup_restore.backup.password".tr();
  final String backupName = "backup_restore.backup.name".tr();
  String backupNumOfNotes(Object arg1) => "backup_restore.backup.num_of_notes".tr(args: [arg1.toString()]);
  final String backupProtectedNotesPrompt = "backup_restore.backup.protected_notes_prompt".tr();
  final String backupCreating = "backup_restore.backup.creating".tr();
  /// First argument is current progress, second argument is total progress, so like 1 of 100
  String backupCreatingProgress(Object arg1, Object arg2) => "backup_restore.backup.creating_progress".tr(args: [arg1.toString(), arg2.toString()]);
  final String backupCompleteSuccess = "backup_restore.backup.complete.success".tr();
  final String backupCompleteFailure = "backup_restore.backup.complete.failure".tr();
  /// At the end of the phrase the path to the file will be appended
  final String backupCompleteDescSuccess = "backup_restore.backup.complete_desc.success".tr();
  final String backupCompleteDescSuccessNoFile = "backup_restore.backup.complete_desc.success.no_file".tr();
  final String backupCompleteDescFailure = "backup_restore.backup.complete_desc.failure".tr();
  final String restoreTitle = "backup_restore.restore.title".tr();
  final String restoreFileOpen = "backup_restore.restore.file_open".tr();
  /// The argument is the backup name
  String restoreFromFile(Object arg1) => "backup_restore.restore.from_file".tr(args: [arg1.toString()]);
  /// First argument is the note count in backup, second argument is tag count and third arg is creation date
  String restoreInfo(Object arg1, Object arg2, Object arg3) => "backup_restore.restore.info".tr(args: [arg1.toString(), arg2.toString(), arg3.toString()]);
  final String restoreNoBackups = "backup_restore.restore.no_backups".tr();
  final String restoreFailure = "backup_restore.restore.failure".tr();
  final String importTitle = "backup_restore.import.title".tr();
  final String importOpenDb = "backup_restore.import.open_db".tr();
  final String importOpenPrevious = "backup_restore.import.open_previous".tr();
  final String importOpenPreviousUnsupportedPlatform = "backup_restore.import.open_previous.unsupported_platform".tr();
  final String importOpenPreviousNoFile = "backup_restore.import.open_previous.no_file".tr();
  final String importNotesLoaded = "backup_restore.import.notes_loaded".tr();
  final String selectNotes = "backup_restore.select_notes".tr();
  final String replaceExisting = "backup_restore.replace_existing".tr();
}

class _$MiscellaneousLocaleStrings {
  final String updaterUpdateAvailable = "miscellaneous.updater.update_available".tr();
  final String updaterUpdateAvailableDesc = "miscellaneous.updater.update_available_desc".tr();
  final String updaterAlreadyOnLatest = "miscellaneous.updater.already_on_latest".tr();
  final String updaterAlreadyOnLatestDesc = "miscellaneous.updater.already_on_latest_desc".tr();
}

