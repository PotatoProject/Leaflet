import 'package:flutter/material.dart';
import 'package:potato_notes/internal/locales/locale_strings.g.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/widget/dialog_sheet_base.dart';

class PassChallenge extends StatefulWidget {
  final bool editMode;
  final ValueChanged<String>? onSave;
  final VoidCallback? onChallengeSuccess;
  final String? description;

  const PassChallenge({
    this.editMode = false,
    this.onSave,
    this.onChallengeSuccess,
    this.description,
  });

  @override
  _PassChallengeState createState() => _PassChallengeState();
}

class _PassChallengeState extends State<PassChallenge> {
  final TextEditingController controller = TextEditingController();

  bool showPass = false;
  String? status;

  @override
  void initState() {
    controller.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DialogSheetBase(
      title: Text(
        widget.editMode
            ? LocaleStrings.common.masterPassModify
            : LocaleStrings.common.masterPassConfirm,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.description != null) Text(widget.description!),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: TextFormField(
              autofocus: true,
              keyboardType: TextInputType.visiblePassword,
              controller: controller,
              obscureText: !showPass,
              onChanged: (_) => setState(() => status = null),
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(
                    showPass
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  onPressed: () => setState(() => showPass = !showPass),
                ),
                errorText: status,
              ),
              onFieldSubmitted:
                  controller.text.length >= 4 ? (_) => _onConfirm() : null,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: controller.text.length >= 4 ? _onConfirm : null,
          child: Text(
            widget.editMode
                ? LocaleStrings.common.save
                : LocaleStrings.common.confirm,
          ),
        ),
      ],
    );
  }

  void _onConfirm() {
    if (widget.editMode) {
      widget.onSave?.call(controller.text);
    } else {
      final String controllerHash = Utils.hashedPass(controller.text);

      if (controllerHash == prefs.masterPass) {
        setState(() => status = null);
        widget.onChallengeSuccess?.call();
      } else {
        setState(() => status = "Incorrect master pass");
      }
    }
  }
}
