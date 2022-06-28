import 'package:liblymph/utils.dart';
import 'package:yatl/yatl.dart';

class CommonLocaleStrings extends LocaleStrings {
  CommonLocaleStrings._(YatlCore core) : super(core);

  String get cancel {
    return core.translate("common.cancel");
  }

  String get reset {
    return core.translate("common.reset");
  }

  String get restore {
    return core.translate("common.restore");
  }

  String get confirm {
    return core.translate("common.confirm");
  }

  String get save {
    return core.translate("common.save");
  }

  String get delete {
    return core.translate("common.delete");
  }

  String get undo {
    return core.translate("common.undo");
  }

  String get redo {
    return core.translate("common.redo");
  }

  String get edit {
    return core.translate("common.edit");
  }

  String get goOn {
    return core.translate("common.go_on");
  }

  String get exit {
    return core.translate("common.exit");
  }

  String get ok {
    return core.translate("common.ok");
  }

  String get share {
    return core.translate("common.share");
  }

  String get notNow {
    return core.translate("common.not_now");
  }

  String get update {
    return core.translate("common.update");
  }

  String get expand {
    return core.translate("common.expand");
  }

  String get collapse {
    return core.translate("common.collapse");
  }

  String get create {
    return core.translate("common.create");
  }

  String get close {
    return core.translate("common.close");
  }

  /// First arg is current page, second arg is number of pages, ex. (page) 1 of 8
  String xOfY(Object arg0, Object arg1) {
    return core.translate(
      "common.x_of_y",
      arguments: [arg0.toString(), arg1.toString()],
    );
  }

  String get quickTip {
    return core.translate("common.quick_tip");
  }

  String get newNote {
    return core.translate("common.new_note");
  }

  String get newList {
    return core.translate("common.new_list");
  }

  String get newImage {
    return core.translate("common.new_image");
  }

  String get newDrawing {
    return core.translate("common.new_drawing");
  }

  String get importNote {
    return core.translate("common.import_note");
  }

  String get biometricsPrompt {
    return core.translate("common.biometrics_prompt");
  }

  String get masterPassModify {
    return core.translate("common.master_pass.modify");
  }

  String get masterPassConfirm {
    return core.translate("common.master_pass.confirm");
  }

  String get masterPassIncorrect {
    return core.translate("common.master_pass.incorrect");
  }

  String get backupPasswordTitle {
    return core.translate("common.backup_password.title");
  }

  String get backupPasswordUseMasterPass {
    return core.translate("common.backup_password.use_master_pass");
  }

  String get restoreDialogTitle {
    return core.translate("common.restore_dialog.title");
  }

  String restoreDialogBackupName(Object arg0) {
    return core.translate(
      "common.restore_dialog.backup_name",
      arguments: [arg0.toString()],
    );
  }

  String restoreDialogCreationDate(Object arg0) {
    return core.translate(
      "common.restore_dialog.creation_date",
      arguments: [arg0.toString()],
    );
  }

  String restoreDialogAppVersion(Object arg0) {
    return core.translate(
      "common.restore_dialog.app_version",
      arguments: [arg0.toString()],
    );
  }

  String restoreDialogNoteCount(Object arg0) {
    return core.translate(
      "common.restore_dialog.note_count",
      arguments: [arg0.toString()],
    );
  }

  String restoreDialogTagCount(Object arg0) {
    return core.translate(
      "common.restore_dialog.tag_count",
      arguments: [arg0.toString()],
    );
  }

  String get areYouSure {
    return core.translate("common.are_you_sure");
  }

  String get colorNone {
    return core.translate("common.color.none");
  }

  String get colorRed {
    return core.translate("common.color.red");
  }

  String get colorOrange {
    return core.translate("common.color.orange");
  }

  String get colorYellow {
    return core.translate("common.color.yellow");
  }

  String get colorGreen {
    return core.translate("common.color.green");
  }

  String get colorCyan {
    return core.translate("common.color.cyan");
  }

  String get colorLightBlue {
    return core.translate("common.color.light_blue");
  }

  String get colorBlue {
    return core.translate("common.color.blue");
  }

  String get colorPurple {
    return core.translate("common.color.purple");
  }

  String get colorPink {
    return core.translate("common.color.pink");
  }

  String get notificationDefaultTitle {
    return core.translate("common.notification.default_title");
  }

  String get notificationDetailsTitle {
    return core.translate("common.notification.details_title");
  }

  String get notificationDetailsDesc {
    return core.translate("common.notification.details_desc");
  }

  String get tagNew {
    return core.translate("common.tag.new");
  }

  String get tagModify {
    return core.translate("common.tag.modify");
  }

  String get tagTextboxHint {
    return core.translate("common.tag.textbox_hint");
  }
}

class MainPageLocaleStrings extends LocaleStrings {
  MainPageLocaleStrings._(YatlCore core) : super(core);

  String get writeNote {
    return core.translate("main_page.write_note");
  }

  String get settings {
    return core.translate("main_page.settings");
  }

  String get search {
    return core.translate("main_page.search");
  }

  String get account {
    return core.translate("main_page.account");
  }

  String get restorePromptArchive {
    return core.translate("main_page.restore_prompt.archive");
  }

  String get restorePromptTrash {
    return core.translate("main_page.restore_prompt.trash");
  }

  String get tagDeletePrompt {
    return core.translate("main_page.tag_delete_prompt");
  }

  String get deletedEmptyNote {
    return core.translate("main_page.deleted_empty_note");
  }

  String get emptyStateHome {
    return core.translate("main_page.empty_state.home");
  }

  String get emptyStateArchive {
    return core.translate("main_page.empty_state.archive");
  }

  String get emptyStateTrash {
    return core.translate("main_page.empty_state.trash");
  }

  String get emptyStateFavourites {
    return core.translate("main_page.empty_state.favourites");
  }

  String get emptyStateTag {
    return core.translate("main_page.empty_state.tag");
  }

  /// Gets displayed when the note has overflowing list items
  String noteListXMoreItems(num amount) {
    return core.plural(
      "main_page.note_list_x_more_items",
      amount,
    );
  }

  String get titleNotes {
    return core.translate("main_page.title.notes");
  }

  String get titleArchive {
    return core.translate("main_page.title.archive");
  }

  String get titleTrash {
    return core.translate("main_page.title.trash");
  }

  String get titleFavourites {
    return core.translate("main_page.title.favourites");
  }

  String get titleTag {
    return core.translate("main_page.title.tag");
  }

  String get titleAll {
    return core.translate("main_page.title.all");
  }

  String get selectionBarClose {
    return core.translate("main_page.selection_bar.close");
  }

  String get selectionBarSelect {
    return core.translate("main_page.selection_bar.select");
  }

  String get selectionBarSelectAll {
    return core.translate("main_page.selection_bar.select_all");
  }

  String get selectionBarAddFavourites {
    return core.translate("main_page.selection_bar.add_favourites");
  }

  String get selectionBarRemoveFavourites {
    return core.translate("main_page.selection_bar.remove_favourites");
  }

  String get selectionBarChangeColor {
    return core.translate("main_page.selection_bar.change_color");
  }

  /// Verb not noun, to archive
  String get selectionBarArchive {
    return core.translate("main_page.selection_bar.archive");
  }

  String get selectionBarDelete {
    return core.translate("main_page.selection_bar.delete");
  }

  String get selectionBarPermaDelete {
    return core.translate("main_page.selection_bar.perma_delete");
  }

  /// Pin to notifications shade
  String get selectionBarPin {
    return core.translate("main_page.selection_bar.pin");
  }

  /// Unpin from notifications shade
  String get selectionBarUnpin {
    return core.translate("main_page.selection_bar.unpin");
  }

  /// Option to export note to local storage
  String get selectionBarSave {
    return core.translate("main_page.selection_bar.save");
  }

  String get selectionBarSaveNoteLocked {
    return core.translate("main_page.selection_bar.save.note_locked");
  }

  String get selectionBarSaveSuccess {
    return core.translate("main_page.selection_bar.save.success");
  }

  String get selectionBarSaveOopsie {
    return core.translate("main_page.selection_bar.save.oopsie");
  }

  String get selectionBarShare {
    return core.translate("main_page.selection_bar.share");
  }

  String notesDeleted(num amount) {
    return core.plural(
      "main_page.notes_deleted",
      amount,
    );
  }

  String notesPermaDeleted(num amount) {
    return core.plural(
      "main_page.notes_perma_deleted",
      amount,
    );
  }

  String notesArchived(num amount) {
    return core.plural(
      "main_page.notes_archived",
      amount,
    );
  }

  String notesRestored(num amount) {
    return core.plural(
      "main_page.notes_restored",
      amount,
    );
  }

  String get exportSuccess {
    return core.translate("main_page.export.success");
  }

  String get exportFailure {
    return core.translate("main_page.export.failure");
  }

  /// First argument is the path to reach the setting to import notes, in english it will be Settings > Backup and Restore > Import. Second argument is the translated string for the 'Open from previous version database' string.
  String importPsa(Object arg0, Object arg1) {
    return core.translate(
      "main_page.import_psa",
      arguments: [arg0.toString(), arg1.toString()],
    );
  }
}

class NotePageLocaleStrings extends LocaleStrings {
  NotePageLocaleStrings._(YatlCore core) : super(core);

  String get titleHint {
    return core.translate("note_page.title_hint");
  }

  String get contentHint {
    return core.translate("note_page.content_hint");
  }

  String get listItemHint {
    return core.translate("note_page.list_item_hint");
  }

  String get addEntryHint {
    return core.translate("note_page.add_entry_hint");
  }

  String get toolbarTags {
    return core.translate("note_page.toolbar.tags");
  }

  String get toolbarColor {
    return core.translate("note_page.toolbar.color");
  }

  String get toolbarAddItem {
    return core.translate("note_page.toolbar.add_item");
  }

  String get privacyTitle {
    return core.translate("note_page.privacy.title");
  }

  String get privacyHideContent {
    return core.translate("note_page.privacy.hide_content");
  }

  String get privacyLockNote {
    return core.translate("note_page.privacy.lock_note");
  }

  String get privacyLockNoteMissingPass {
    return core.translate("note_page.privacy.lock_note.missing_pass");
  }

  String get privacyUseBiometrics {
    return core.translate("note_page.privacy.use_biometrics");
  }

  String get toggleList {
    return core.translate("note_page.toggle_list");
  }

  String get imageGallery {
    return core.translate("note_page.image_gallery");
  }

  String get imageCamera {
    return core.translate("note_page.image_camera");
  }

  String get drawing {
    return core.translate("note_page.drawing");
  }

  String get addedFavourites {
    return core.translate("note_page.added_favourites");
  }

  String get removedFavourites {
    return core.translate("note_page.removed_favourites");
  }
}

class SettingsLocaleStrings extends LocaleStrings {
  SettingsLocaleStrings._(YatlCore core) : super(core);

  String get title {
    return core.translate("settings.title");
  }

  String get personalizationTitle {
    return core.translate("settings.personalization.title");
  }

  String get personalizationThemeMode {
    return core.translate("settings.personalization.theme_mode");
  }

  String get personalizationThemeModeSystem {
    return core.translate("settings.personalization.theme_mode.system");
  }

  String get personalizationThemeModeLight {
    return core.translate("settings.personalization.theme_mode.light");
  }

  String get personalizationThemeModeDark {
    return core.translate("settings.personalization.theme_mode.dark");
  }

  String get personalizationUseAmoled {
    return core.translate("settings.personalization.use_amoled");
  }

  String get personalizationUseCustomAccent {
    return core.translate("settings.personalization.use_custom_accent");
  }

  String get personalizationCustomAccent {
    return core.translate("settings.personalization.custom_accent");
  }

  String get personalizationUseGrid {
    return core.translate("settings.personalization.use_grid");
  }

  String get personalizationLocale {
    return core.translate("settings.personalization.locale");
  }

  String get personalizationLocaleDeviceDefault {
    return core.translate("settings.personalization.locale.device_default");
  }

  /// Used to tell the user how much a certain language is translated, like 50% translated or so
  String personalizationLocaleXTranslated(Object arg0) {
    return core.translate(
      "settings.personalization.locale.x_translated",
      arguments: [arg0.toString()],
    );
  }

  String get privacyTitle {
    return core.translate("settings.privacy.title");
  }

  String get privacyUseMasterPass {
    return core.translate("settings.privacy.use_master_pass");
  }

  String get privacyUseMasterPassDisclaimer {
    return core.translate("settings.privacy.use_master_pass.disclaimer");
  }

  String get privacyModifyMasterPass {
    return core.translate("settings.privacy.modify_master_pass");
  }

  String get backupRestoreTitle {
    return core.translate("settings.backup_restore.title");
  }

  String get backupRestoreBackup {
    return core.translate("settings.backup_restore.backup");
  }

  String get backupRestoreBackupDesc {
    return core.translate("settings.backup_restore.backup_desc");
  }

  String get backupRestoreBackupNothingToRestoreTitle {
    return core
        .translate("settings.backup_restore.backup.nothing_to_restore.title");
  }

  String get backupRestoreBackupNothingToRestoreDesc {
    return core
        .translate("settings.backup_restore.backup.nothing_to_restore.desc");
  }

  String get backupRestoreRestore {
    return core.translate("settings.backup_restore.restore");
  }

  String get backupRestoreRestoreDesc {
    return core.translate("settings.backup_restore.restore_desc");
  }

  String get backupRestoreRestoreStatusSuccess {
    return core.translate("settings.backup_restore.restore.status.success");
  }

  String get backupRestoreRestoreStatusWrongFormat {
    return core
        .translate("settings.backup_restore.restore.status.wrong_format");
  }

  String get backupRestoreRestoreStatusWrongPassword {
    return core
        .translate("settings.backup_restore.restore.status.wrong_password");
  }

  String get backupRestoreRestoreStatusAlreadyExists {
    return core
        .translate("settings.backup_restore.restore.status.already_exists");
  }

  String get backupRestoreRestoreStatusUnknown {
    return core.translate("settings.backup_restore.restore.status.unknown");
  }

  String get backupRestoreImport {
    return core.translate("settings.backup_restore.import");
  }

  String get backupRestoreImportDesc {
    return core.translate("settings.backup_restore.import_desc");
  }

  String get infoTitle {
    return core.translate("settings.info.title");
  }

  String get infoAboutApp {
    return core.translate("settings.info.about_app");
  }

  String get infoUpdateCheck {
    return core.translate("settings.info.update_check");
  }

  String get infoTranslate {
    return core.translate("settings.info.translate");
  }

  String get infoBugReport {
    return core.translate("settings.info.bug_report");
  }

  String get debugTitle {
    return core.translate("settings.debug.title");
  }

  String get debugShowSetupScreen {
    return core.translate("settings.debug.show_setup_screen");
  }

  String get debugLoadingOverlay {
    return core.translate("settings.debug.loading_overlay");
  }

  String get debugClearDatabase {
    return core.translate("settings.debug.clear_database");
  }

  String get debugMigrateDatabase {
    return core.translate("settings.debug.migrate_database");
  }

  String get debugGenerateTrash {
    return core.translate("settings.debug.generate_trash");
  }

  String get debugLogLevel {
    return core.translate("settings.debug.log_level");
  }
}

class AboutLocaleStrings extends LocaleStrings {
  AboutLocaleStrings._(YatlCore core) : super(core);

  String get title {
    return core.translate("about.title");
  }

  String get pwaVersion {
    return core.translate("about.pwa_version");
  }

  String get links {
    return core.translate("about.links");
  }

  String get contributors {
    return core.translate("about.contributors");
  }

  String get contributorsHrx {
    return core.translate("about.contributors.hrx");
  }

  String get contributorsBas {
    return core.translate("about.contributors.bas");
  }

  String get contributorsNico {
    return core.translate("about.contributors.nico");
  }

  String get contributorsKat {
    return core.translate("about.contributors.kat");
  }

  String get contributorsRohit {
    return core.translate("about.contributors.rohit");
  }

  String get contributorsRshbfn {
    return core.translate("about.contributors.rshbfn");
  }

  String get contributorsElias {
    return core.translate("about.contributors.elias");
  }

  String get contributorsAkshit {
    return core.translate("about.contributors.akshit");
  }
}

class SearchLocaleStrings extends LocaleStrings {
  SearchLocaleStrings._(YatlCore core) : super(core);

  String get textboxHint {
    return core.translate("search.textbox_hint");
  }

  String get tagCreateEmptyHint {
    return core.translate("search.tag_create_empty_hint");
  }

  String tagCreateHint(Object arg0) {
    return core.translate(
      "search.tag_create_hint",
      arguments: [arg0.toString()],
    );
  }

  String get typeToSearch {
    return core.translate("search.type_to_search");
  }

  String get nothingFound {
    return core.translate("search.nothing_found");
  }

  String get noteFiltersCaseSensitive {
    return core.translate("search.note.filters.case_sensitive");
  }

  String get noteFiltersFavourites {
    return core.translate("search.note.filters.favourites");
  }

  String get noteFiltersLocations {
    return core.translate("search.note.filters.locations");
  }

  String get noteFiltersLocationsNormal {
    return core.translate("search.note.filters.locations.normal");
  }

  String get noteFiltersLocationsArchive {
    return core.translate("search.note.filters.locations.archive");
  }

  String get noteFiltersLocationsTrash {
    return core.translate("search.note.filters.locations.trash");
  }

  String get noteFiltersLocationsNormalTitle {
    return core.translate("search.note.filters.locations.normal_title");
  }

  String get noteFiltersLocationsArchiveTitle {
    return core.translate("search.note.filters.locations.archive_title");
  }

  String get noteFiltersLocationsTrashTitle {
    return core.translate("search.note.filters.locations.trash_title");
  }

  String get noteFiltersColor {
    return core.translate("search.note.filters.color");
  }

  String get noteFiltersDate {
    return core.translate("search.note.filters.date");
  }

  String get noteFiltersDateModeTitle {
    return core.translate("search.note.filters.date.mode_title");
  }

  String get noteFiltersDateModeAfter {
    return core.translate("search.note.filters.date.mode_after");
  }

  String get noteFiltersDateModeExact {
    return core.translate("search.note.filters.date.mode_exact");
  }

  String get noteFiltersDateModeBefore {
    return core.translate("search.note.filters.date.mode_before");
  }

  String get noteFiltersTags {
    return core.translate("search.note.filters.tags");
  }

  String noteFiltersTagsSelected(num amount) {
    return core.plural(
      "search.note.filters.tags.selected",
      amount,
    );
  }

  String get noteFiltersClear {
    return core.translate("search.note.filters.clear");
  }
}

class DrawingLocaleStrings extends LocaleStrings {
  DrawingLocaleStrings._(YatlCore core) : super(core);

  String get colorBlack {
    return core.translate("drawing.color_black");
  }

  String get exitPrompt {
    return core.translate("drawing.exit_prompt");
  }

  String get clearCanvasWarning {
    return core.translate("drawing.clear_canvas_warning");
  }

  String get toolsBrush {
    return core.translate("drawing.tools.brush");
  }

  String get toolsEraser {
    return core.translate("drawing.tools.eraser");
  }

  String get toolsMarker {
    return core.translate("drawing.tools.marker");
  }

  String get toolsColorPicker {
    return core.translate("drawing.tools.color_picker");
  }

  String get toolsRadiusPicker {
    return core.translate("drawing.tools.radius_picker");
  }

  String get toolsClear {
    return core.translate("drawing.tools.clear");
  }
}

class SetupLocaleStrings extends LocaleStrings {
  SetupLocaleStrings._(YatlCore core) : super(core);

  String get buttonGetStarted {
    return core.translate("setup.button.get_started");
  }

  String get buttonFinish {
    return core.translate("setup.button.finish");
  }

  String get buttonNext {
    return core.translate("setup.button.next");
  }

  String get buttonBack {
    return core.translate("setup.button.back");
  }

  String get welcomeCatchphrase {
    return core.translate("setup.welcome.catchphrase");
  }

  String get basicCustomizationTitle {
    return core.translate("setup.basic_customization.title");
  }

  String get restoreImportTitle {
    return core.translate("setup.restore_import.title");
  }

  String get restoreImportDesc {
    return core.translate("setup.restore_import.desc");
  }

  String get restoreImportRestoreBtn {
    return core.translate("setup.restore_import.restore_btn");
  }

  String get restoreImportImportBtn {
    return core.translate("setup.restore_import.import_btn");
  }

  String get finishTitle {
    return core.translate("setup.finish.title");
  }

  String get finishLastWords {
    return core.translate("setup.finish.last_words");
  }
}

class BackupRestoreLocaleStrings extends LocaleStrings {
  BackupRestoreLocaleStrings._(YatlCore core) : super(core);

  String get backupTitle {
    return core.translate("backup_restore.backup.title");
  }

  String get backupPassword {
    return core.translate("backup_restore.backup.password");
  }

  String get backupName {
    return core.translate("backup_restore.backup.name");
  }

  String backupNumOfNotes(Object arg0) {
    return core.translate(
      "backup_restore.backup.num_of_notes",
      arguments: [arg0.toString()],
    );
  }

  String get backupProtectedNotesPrompt {
    return core.translate("backup_restore.backup.protected_notes_prompt");
  }

  String get backupCreating {
    return core.translate("backup_restore.backup.creating");
  }

  /// First argument is current progress, second argument is total progress, so like 1 of 100
  String backupCreatingProgress(Object arg0, Object arg1) {
    return core.translate(
      "backup_restore.backup.creating_progress",
      arguments: [arg0.toString(), arg1.toString()],
    );
  }

  String get backupCompleteSuccess {
    return core.translate("backup_restore.backup.complete.success");
  }

  String get backupCompleteFailure {
    return core.translate("backup_restore.backup.complete.failure");
  }

  /// At the end of the phrase the path to the file will be appended
  String get backupCompleteDescSuccess {
    return core.translate("backup_restore.backup.complete_desc.success");
  }

  String get backupCompleteDescSuccessNoFile {
    return core
        .translate("backup_restore.backup.complete_desc.success.no_file");
  }

  String get backupCompleteDescFailure {
    return core.translate("backup_restore.backup.complete_desc.failure");
  }

  String get restoreTitle {
    return core.translate("backup_restore.restore.title");
  }

  String get restoreFileOpen {
    return core.translate("backup_restore.restore.file_open");
  }

  /// The argument is the backup name
  String restoreFromFile(Object arg0) {
    return core.translate(
      "backup_restore.restore.from_file",
      arguments: [arg0.toString()],
    );
  }

  /// First argument is the note count in backup, second argument is tag count and third arg is creation date
  String restoreInfo(Object arg0, Object arg1, Object arg2) {
    return core.translate(
      "backup_restore.restore.info",
      arguments: [arg0.toString(), arg1.toString(), arg2.toString()],
    );
  }

  String get restoreNoBackups {
    return core.translate("backup_restore.restore.no_backups");
  }

  String get restoreFailure {
    return core.translate("backup_restore.restore.failure");
  }

  String get importTitle {
    return core.translate("backup_restore.import.title");
  }

  String get importOpenDb {
    return core.translate("backup_restore.import.open_db");
  }

  String get importOpenPrevious {
    return core.translate("backup_restore.import.open_previous");
  }

  String get importOpenPreviousUnsupportedPlatform {
    return core
        .translate("backup_restore.import.open_previous.unsupported_platform");
  }

  String get importOpenPreviousNoFile {
    return core.translate("backup_restore.import.open_previous.no_file");
  }

  String get importNotesLoaded {
    return core.translate("backup_restore.import.notes_loaded");
  }

  String get selectNotes {
    return core.translate("backup_restore.select_notes");
  }

  String get replaceExisting {
    return core.translate("backup_restore.replace_existing");
  }
}

class MiscellaneousLocaleStrings extends LocaleStrings {
  MiscellaneousLocaleStrings._(YatlCore core) : super(core);

  String get updaterUpdateAvailable {
    return core.translate("miscellaneous.updater.update_available");
  }

  String get updaterUpdateAvailableDesc {
    return core.translate("miscellaneous.updater.update_available_desc");
  }

  String get updaterAlreadyOnLatest {
    return core.translate("miscellaneous.updater.already_on_latest");
  }

  String get updaterAlreadyOnLatestDesc {
    return core.translate("miscellaneous.updater.already_on_latest_desc");
  }
}

class GeneratedLocaleStrings extends LocaleStrings {
  GeneratedLocaleStrings(YatlCore core) : super(core);

  late final CommonLocaleStrings common = CommonLocaleStrings._(core);

  late final MainPageLocaleStrings mainPage = MainPageLocaleStrings._(core);

  late final NotePageLocaleStrings notePage = NotePageLocaleStrings._(core);

  late final SettingsLocaleStrings settings = SettingsLocaleStrings._(core);

  late final AboutLocaleStrings about = AboutLocaleStrings._(core);

  late final SearchLocaleStrings search = SearchLocaleStrings._(core);

  late final DrawingLocaleStrings drawing = DrawingLocaleStrings._(core);

  late final SetupLocaleStrings setup = SetupLocaleStrings._(core);

  late final BackupRestoreLocaleStrings backupRestore =
      BackupRestoreLocaleStrings._(core);

  late final MiscellaneousLocaleStrings miscellaneous =
      MiscellaneousLocaleStrings._(core);
}
