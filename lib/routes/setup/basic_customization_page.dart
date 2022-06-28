import 'package:flutter/material.dart';
import 'package:potato_notes/internal/custom_icons.dart';
import 'package:potato_notes/internal/extensions.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/routes/settings_page.dart';

class BasicCustomizationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(CustomIcons.settings_outline),
        title: Text(strings.setup.basicCustomizationTitle),
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          top: 56 + context.padding.top,
          bottom: context.padding.bottom,
        ),
        child: const SettingsPage(trimmed: true),
      ),
    );
  }
}
