// @dart=2.12

import 'package:easy_localization/easy_localization.dart';

class LocaleStrings {
  LocaleStrings._();

  static _$AboutPageLocaleStrings get aboutPage => _$AboutPageLocaleStrings();
  static _$CommonLocaleStrings get common => _$CommonLocaleStrings();
  static _$DrawPageLocaleStrings get drawPage => _$DrawPageLocaleStrings();
  static _$MainPageLocaleStrings get mainPage => _$MainPageLocaleStrings();
  static _$NotePageLocaleStrings get notePage => _$NotePageLocaleStrings();
  static _$SearchPageLocaleStrings get searchPage => _$SearchPageLocaleStrings();
  static _$SettingsPageLocaleStrings get settingsPage => _$SettingsPageLocaleStrings();
  static _$SetupPageLocaleStrings get setupPage => _$SetupPageLocaleStrings();
}

class _$AboutPageLocaleStrings {
  final String title = "about_page.title".tr();
  final String pwaVersion = "about_page.pwa_version".tr();
  final String links = "about_page.links".tr();
  final String contributors = "about_page.contributors".tr();
  final String contributorsHrx = "about_page.contributors.hrx".tr();
  final String contributorsBas = "about_page.contributors.bas".tr();
  final String contributorsNico = "about_page.contributors.nico".tr();
  final String contributorsKat = "about_page.contributors.kat".tr();
  final String contributorsRohit = "about_page.contributors.rohit".tr();
  final String contributorsRshbfn = "about_page.contributors.rshbfn".tr();
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
  String xOfY(Object arg1, Object arg2) => "common.x_of_y".tr(args: [arg1.toString(), arg2.toString()]);
  final String newNote = "common.new_note".tr();
  final String newList = "common.new_list".tr();
  final String newImage = "common.new_image".tr();
  final String newDrawing = "common.new_drawing".tr();
  final String biometricsPrompt = "common.biometrics_prompt".tr();
  final String masterPassModify = "common.master_pass.modify".tr();
  final String masterPassConfirm = "common.master_pass.confirm".tr();
  final String areYouSure = "common.are_you_sure".tr();
  final String caseSensitive = "common.case_sensitive".tr();
  final String colorFilter = "common.color_filter".tr();
  final String dateFilter = "common.date_filter".tr();
  final String dateFilterMode = "common.date_filter_mode".tr();
  final String dateFilterModeAfter = "common.date_filter_mode.after".tr();
  final String dateFilterModeExact = "common.date_filter_mode.exact".tr();
  final String dateFilterModeBefore = "common.date_filter_mode.before".tr();
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

class _$DrawPageLocaleStrings {
  final String colorBlack = "draw_page.color_black".tr();
  final String exitPrompt = "draw_page.exit_prompt".tr();
  final String toolsBrush = "draw_page.tools.brush".tr();
  final String toolsEraser = "draw_page.tools.eraser".tr();
  final String toolsMarker = "draw_page.tools.marker".tr();
  final String toolsColorPicker = "draw_page.tools.color_picker".tr();
  final String toolsRadiusPicker = "draw_page.tools.radius_picker".tr();
}

class _$MainPageLocaleStrings {
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
  final String titleHome = "main_page.title.home".tr();
  final String titleArchive = "main_page.title.archive".tr();
  final String titleTrash = "main_page.title.trash".tr();
  final String titleFavourites = "main_page.title.favourites".tr();
  final String titleTag = "main_page.title.tag".tr();
  final String titleAll = "main_page.title.all".tr();
  final String selectionBarClose = "main_page.selection_bar.close".tr();
  final String selectionBarAddFavourites = "main_page.selection_bar.add_favourites".tr();
  final String selectionBarRemoveFavourites = "main_page.selection_bar.remove_favourites".tr();
  final String selectionBarChangeColor = "main_page.selection_bar.change_color".tr();
  final String selectionBarArchive = "main_page.selection_bar.archive".tr();
  final String selectionBarDelete = "main_page.selection_bar.delete".tr();
  final String selectionBarPin = "main_page.selection_bar.pin".tr();
  final String selectionBarShare = "main_page.selection_bar.share".tr();
  String notesDeleted(num value) => "main_page.notes_deleted".plural(value);
  String notesArchived(num value) => "main_page.notes_archived".plural(value);
  String notesRestored(num value) => "main_page.notes_restored".plural(value);
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

class _$SearchPageLocaleStrings {
  final String textboxHint = "search_page.textbox_hint".tr();
  String tagCreateHint(Object arg1) => "search_page.tag_create_hint".tr(args: [arg1.toString()]);
  final String noteTypeToSearch = "search_page.note.type_to_search".tr();
  final String noteNothingFound = "search_page.note.nothing_found".tr();
}

class _$SettingsPageLocaleStrings {
  final String title = "settings_page.title".tr();
  final String personalizationTitle = "settings_page.personalization.title".tr();
  final String personalizationThemeMode = "settings_page.personalization.theme_mode".tr();
  final String personalizationThemeModeSystem = "settings_page.personalization.theme_mode.system".tr();
  final String personalizationThemeModeLight = "settings_page.personalization.theme_mode.light".tr();
  final String personalizationThemeModeDark = "settings_page.personalization.theme_mode.dark".tr();
  final String personalizationUseAmoled = "settings_page.personalization.use_amoled".tr();
  final String personalizationUseCustomAccent = "settings_page.personalization.use_custom_accent".tr();
  final String personalizationCustomAccent = "settings_page.personalization.custom_accent".tr();
  final String personalizationUseGrid = "settings_page.personalization.use_grid".tr();
  final String personalizationLocale = "settings_page.personalization.locale".tr();
  final String privacyTitle = "settings_page.privacy.title".tr();
  final String privacyUseMasterPass = "settings_page.privacy.use_master_pass".tr();
  final String privacyUseMasterPassDisclaimer = "settings_page.privacy.use_master_pass.disclaimer".tr();
  final String privacyModifyMasterPass = "settings_page.privacy.modify_master_pass".tr();
  final String infoTitle = "settings_page.info.title".tr();
  final String infoAboutApp = "settings_page.info.about_app".tr();
  final String debugTitle = "settings_page.debug.title".tr();
  final String debugShowSetupScreen = "settings_page.debug.show_setup_screen".tr();
  final String debugClearDatabase = "settings_page.debug.clear_database".tr();
  final String debugMigrateDatabase = "settings_page.debug.migrate_database".tr();
  final String debugLogLevel = "settings_page.debug.log_level".tr();
}

class _$SetupPageLocaleStrings {
  final String buttonGetStarted = "setup_page.button.get_started".tr();
  final String buttonFinish = "setup_page.button.finish".tr();
  final String buttonNext = "setup_page.button.next".tr();
  final String buttonBack = "setup_page.button.back".tr();
  final String basicCustomizationTitle = "setup_page.basic_customization.title".tr();
  final String welcomeCatchphrase = "setup_page.welcome.catchphrase".tr();
  final String finishTitle = "setup_page.finish.title".tr();
  final String finishLastWords = "setup_page.finish.last_words".tr();
}

