import 'package:easy_localization/easy_localization.dart';

class LocaleStrings {
  // no constructor for you
  LocaleStrings._();

  static _CommonLocaleStrings get common => _CommonLocaleStrings();
  static _AboutPageLocaleStrings get aboutPage => _AboutPageLocaleStrings();
  static _DrawPageLocaleStrings get drawPage => _DrawPageLocaleStrings();
  static _MainPageLocaleStrings get mainPage => _MainPageLocaleStrings();
  static _NotePageLocaleStrings get notePage => _NotePageLocaleStrings();
  static _SearchPageLocaleStrings get searchPage => _SearchPageLocaleStrings();
  static _SettingsPageLocaleStrings get settingsPage =>
      _SettingsPageLocaleStrings();
  static _SetupPageLocaleStrings get setupPage => _SetupPageLocaleStrings();
}

class _CommonLocaleStrings {
  final cancel = "common.cancel".tr();
  final reset = "common.reset".tr();
  final restore = "common.restore".tr();
  final confirm = "common.confirm".tr();
  final save = "common.save".tr();
  final delete = "common.delete".tr();
  final undo = "common.undo".tr();
  final redo = "common.redo".tr();
  final edit = "common.edit".tr();
  final goOn = "common.go_on".tr();
  final exit = "common.exit".tr();
  final newNote = "common.new_note".tr();
  final newList = "common.new_list".tr();
  final newImage = "common.new_image".tr();
  final newDrawing = "common.new_drawing".tr();
  final biometricsPrompt = "common.biometrics_prompt".tr();
  final masterPassModify = "common.master_pass.modify".tr();
  final masterPassConfirm = "common.master_pass.confirm".tr();
  final areYouSure = "common.are_you_sure".tr();
  final caseSensitive = "common.case_sensitive".tr();
  final colorFilter = "common.color_filter".tr();
  final dateFilter = "common.date_filter".tr();
  final dateFilterMode = "common.date_filter_mode".tr();
  final dateFilterModeAfter = "common.date_filter_mode.after".tr();
  final dateFilterModeExact = "common.date_filter_mode.exact".tr();
  final dateFilterModeBefore = "common.date_filter_mode.before".tr();
  final colorNone = "common.color.none".tr();
  final colorRed = "common.color.red".tr();
  final colorOrange = "common.color.orange".tr();
  final colorYellow = "common.color.yellow".tr();
  final colorGreen = "common.color.green".tr();
  final colorCyan = "common.color.cyan".tr();
  final colorLightBlue = "common.color.light_blue".tr();
  final colorBlue = "common.color.blue".tr();
  final colorPurple = "common.color.purple".tr();
  final colorPink = "common.color.pink".tr();
  final notificationDefaultTitle = "common.notification.default_title".tr();
  final notificationDetailsTitle = "common.notification.details_title".tr();
  final notificationDetailsDesc = "common.notification.details_desc".tr();
  final tagNew = "common.tag.new".tr();
  final tagModify = "common.tag.modify".tr();
  final tagTextboxHint = "common.tag.textbox_hint".tr();

  String xOfY(int currentPage, int maxPages) => "common.x_of_y".tr(
        args: [currentPage.toString(), maxPages.toString()],
      );
}

class _AboutPageLocaleStrings {
  final title = "about_page.title".tr();
  final pwaVersion = "about_page.pwa_version".tr();
  final links = "about_page.links".tr();
  final contributors = "about_page.contributors".tr();
  final contributorsHrX = "about_page.contributors.hrx".tr();
  final contributorsBas = "about_page.contributors.bas".tr();
  final contributorsNico = "about_page.contributors.nico".tr();
  final contributorsKat = "about_page.contributors.kat".tr();
  final contributorsRohit = "about_page.contributors.rohit".tr();
  final contributorsRshBfn = "about_page.contributors.rshbfn".tr();
}

class _DrawPageLocaleStrings {
  final colorBlack = "draw_page.color_black".tr();
  final exitPrompt = "draw_page.exit_prompt".tr();
  final toolsBrush = "draw_page.tools.brush".tr();
  final toolsEraser = "draw_page.tools.eraser".tr();
  final toolsMarker = "draw_page.tools.marker".tr();
  final toolsColorPicker = "draw_page.tools.color_picker".tr();
  final toolsRadiusPicker = "draw_page.tools.radius_picker".tr();
}

class _MainPageLocaleStrings {
  final settings = "main_page.settings".tr();
  final search = "main_page.search".tr();
  final account = "main_page.account".tr();
  final restorePromptArchive = "main_page.restore_prompt.archive".tr();
  final restorePromptTrash = "main_page.restore_prompt.trash".tr();
  final tagDeletePrompt = "main_page.tag_delete_prompt".tr();
  final deletedEmptyNote = "main_page.deleted_empty_note".tr();
  final emptyStateHome = "main_page.empty_state.home".tr();
  final emptyStateArchive = "main_page.empty_state.archive".tr();
  final emptyStateTrash = "main_page.empty_state.trash".tr();
  final emptyStateFavourites = "main_page.empty_state.favourites".tr();
  final emptyStateTag = "main_page.empty_state.tag".tr();
  final titleHome = "main_page.title.home".tr();
  final titleArchive = "main_page.title.archive".tr();
  final titleTrash = "main_page.title.trash".tr();
  final titleFavourites = "main_page.title.favourites".tr();
  final titleTag = "main_page.title.tag".tr();
  final titleAll = "main_page.title.all".tr();
  final selectionBarClose = "main_page.selection_bar.close".tr();
  final selectionBarAddFav = "main_page.selection_bar.add_favourites".tr();
  final selectionBarRmFav = "main_page.selection_bar.remove_favourites".tr();
  final selectionBarChangeColor = "main_page.selection_bar.change_color".tr();
  final selectionBarArchive = "main_page.selection_bar.archive".tr();
  final selectionBarDelete = "main_page.selection_bar.delete".tr();
  final selectionBarPin = "main_page.selection_bar.pin".tr();
  final selectionBarShare = "main_page.selection_bar.share".tr();

  String notesDeleted(num value) => "main_page.notes_deleted".plural(value);
  String notesArchived(num value) => "main_page.notes_archived".plural(value);
  String notesRestored(num value) => "main_page.notes_restored".plural(value);
}

class _NotePageLocaleStrings {
  final titleHint = "note_page.title_hint".tr();
  final contentHint = "note_page.content_hint".tr();
  final listItemHint = "note_page.list_item_hint".tr();
  final addEntryHint = "note_page.add_entry_hint".tr();
  final toolbarTags = "note_page.toolbar.tags".tr();
  final toolbarColor = "note_page.toolbar.color".tr();
  final toolbarAddItem = "note_page.toolbar.add_item".tr();
  final privacyTitle = "note_page.privacy.title".tr();
  final privacyHideContent = "note_page.privacy.hide_content".tr();
  final privacyLockNote = "note_page.privacy.lock_note".tr();
  final privacyLockNoteMissingPass =
      "note_page.privacy.lock_note.missing_pass".tr();
  final privacyUseBiometrics = "note_page.privacy.use_biometrics".tr();
  final toggleList = "note_page.toggle_list".tr();
  final imageGallery = "note_page.image_gallery".tr();
  final imageCamera = "note_page.image_camera".tr();
  final drawing = "note_page.drawing".tr();
  final addedFavourites = "note_page.added_favourites".tr();
  final removedFavourites = "note_page.removed_favourites".tr();
}

class _SearchPageLocaleStrings {
  final textboxHint = "search_page.textbox_hint".tr();
  final noteTypeToSearch = "search_page.note.type_to_search".tr();
  final noteNothingFound = "search_page.note.nothing_found".tr();

  String tagCreateHint(String tag) =>
      "search_page.tag_create_hint".tr(args: [tag]);
}

class _SettingsPageLocaleStrings {
  final title = "settings_page.title".tr();
  final personalizationTitle = "settings_page.personalization.title".tr();
  final personalizationThemeMode =
      "settings_page.personalization.theme_mode".tr();
  final personalizationThemeModeSystem =
      "settings_page.personalization.theme_mode.system".tr();
  final personalizationThemeModeLight =
      "settings_page.personalization.theme_mode.light".tr();
  final personalizationThemeModeDark =
      "settings_page.personalization.theme_mode.dark".tr();
  final personalizationUseAmoled =
      "settings_page.personalization.use_amoled".tr();
  final personalizationUseCustomAccent =
      "settings_page.personalization.use_custom_accent".tr();
  final personalizationCustomAccent =
      "settings_page.personalization.custom_accent".tr();
  final personalizationUseGrid = "settings_page.personalization.use_grid".tr();
  final personalizationLocale = "settings_page.personalization.locale".tr();
  final privacyTitle = "settings_page.privacy.title".tr();
  final privacyUseMasterPass = "settings_page.privacy.use_master_pass".tr();
  final privacyUseMasterPassDisclaimer =
      "settings_page.privacy.use_master_pass.disclaimer".tr();
  final privacyModifyMasterPass =
      "settings_page.privacy.modify_master_pass".tr();
  final infoTitle = "settings_page.info.title".tr();
  final infoAboutApp = "settings_page.info.about_app".tr();
  final debugTitle = "settings_page.debug.title".tr();
  final debugShowSetupScreen = "settings_page.debug.show_setup_screen".tr();
  final debugClearDatabase = "settings_page.debug.clear_database".tr();
  final debugMigrateDatabase = "settings_page.debug.migrate_database".tr();
  final debugLogLevel = "settings_page.debug.log_level".tr();
}

class _SetupPageLocaleStrings {
  final buttonGetStarted = "setup_page.button.get_started".tr();
  final buttonFinish = "setup_page.button.finish".tr();
  final buttonNext = "setup_page.button.next".tr();
  final buttonBack = "setup_page.button.back".tr();
  final basicCustomizationTitle = "setup_page.basic_customization.title".tr();
  final welcomeCatchphrase = "setup_page.welcome.catchphrase".tr();
  final finishTitle = "setup_page.finish.title".tr();
  final finishLastWords = "setup_page.finish.last_words".tr();
}
