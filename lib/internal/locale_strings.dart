import 'package:easy_localization/easy_localization.dart';

class LocaleStrings {
  // no constructor for you
  LocaleStrings._();

  static _CommonLocaleStrings get common => _CommonLocaleStrings();
}

class _CommonLocaleStrings {
  final cancel = "common.cancel".tr();
  final reset = "common.reset".tr();
  final confirm = "common.confirm".tr();
  final undo = "common.undo".tr();
  final exit = "common.exit".tr();
  final biometricsPrompt = "common.biometrics_prompt".tr();
  final modifyMasterPass = "common.modify_master_pass".tr();
  final confermMasterPass = "common.conferm_master_pass".tr();
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
}
