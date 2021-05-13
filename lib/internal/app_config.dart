import 'dart:convert';

import 'package:flutter/services.dart';

class AppConfig {
  AppConfig._({
    required this.bugReportUrl,
    required this.buildType,
  });

  final String? bugReportUrl;
  final String buildType;

  static Future<AppConfig> load() async {
    final String jsonString = await rootBundle.loadString('config.json');
    final Map<String, dynamic> json =
        jsonDecode(jsonString) as Map<String, dynamic>;

    return AppConfig._(
      bugReportUrl: json['bug_report_url'] as String?,
      buildType: json['build_type'] as String? ?? "github",
    );
  }
}
