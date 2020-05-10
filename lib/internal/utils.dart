import 'package:flutter/material.dart';
import 'package:potato_notes/widget/pass_challenge.dart';

class Utils {
  static Future<dynamic> showPassChallengeSheet(BuildContext context) async {
    return await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => PassChallenge(
        editMode: false,
        onChallengeSuccess: () => Navigator.pop(context, true),
        onSave: null,
      ),
    );
  }
}
