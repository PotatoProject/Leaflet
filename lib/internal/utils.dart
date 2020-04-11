import 'package:flutter/material.dart';
import 'package:potato_notes/internal/preferences.dart';
import 'package:potato_notes/widget/pass_challenge.dart';

class Utils {
  static Future<dynamic> showPassChallengeSheet(BuildContext context, PassType passType) async {
    return await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => PassChallenge(
        passType: passType,
        editMode: false,
        onChallengeSuccess: () => Navigator.pop(context, true),
        onSave: null,
      ),
    );
  }
}