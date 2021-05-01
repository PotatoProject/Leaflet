import 'package:flutter/material.dart';
import 'package:potato_notes/internal/custom_icons.dart';
import 'package:potato_notes/internal/locales/locale_strings.g.dart';
import 'package:potato_notes/internal/extensions.dart';
import 'package:potato_notes/routes/settings_page.dart';

class BasicCustomizationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(CustomIcons.settings_outline),
        title: Text(LocaleStrings.setup.basicCustomizationTitle),
        textTheme: context.theme.textTheme,
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          top: 56 + context.padding.top,
        ),
        child: const SettingsPage(trimmed: true),
      ),
    );
  }
}
