import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:potato_notes/internal/locale_strings.dart';
import 'package:potato_notes/internal/providers.dart';

class PassChallenge extends StatefulWidget {
  final bool editMode;
  final Function(String) onSave;
  final Function() onChallengeSuccess;

  PassChallenge({
    this.editMode = false,
    this.onSave,
    this.onChallengeSuccess,
  });

  @override
  _PassChallengeState createState() => _PassChallengeState();
}

class _PassChallengeState extends State<PassChallenge> {
  TextEditingController controller;

  bool showPass = false;
  String status;

  @override
  void initState() {
    controller = TextEditingController(
      text: widget.editMode ? prefs.masterPass ?? "" : "",
    );

    controller.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool numericPass =
        !widget.editMode ? int.tryParse(prefs.masterPass) != null : false;

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              widget.editMode
                  ? LocaleStrings.common.masterPassConfirm
                  : LocaleStrings.common.masterPassModify,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: TextFormField(
              keyboardType: numericPass
                  ? TextInputType.numberWithOptions(
                      signed: false, decimal: false)
                  : TextInputType.visiblePassword,
              controller: controller,
              obscureText: !showPass,
              onChanged: (_) => setState(() => status = null),
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(
                    showPass
                        ? CommunityMaterialIcons.eye_outline
                        : CommunityMaterialIcons.eye_off_outline,
                  ),
                  onPressed: () => setState(() => showPass = !showPass),
                ),
                errorText: status,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Spacer(),
                FlatButton(
                  onPressed: controller.text.length >= 4
                      ? widget.editMode
                          ? () => widget.onSave(controller.text)
                          : () {
                              if (prefs.masterPass == controller.text) {
                                setState(() => status = null);
                                widget.onChallengeSuccess();
                              } else
                                setState(
                                    () => status = "Incorrect master pass");
                            }
                      : null,
                  child: Text(widget.editMode ? "Save" : "Confirm"),
                  color: Theme.of(context).accentColor,
                  disabledColor: Theme.of(context).disabledColor,
                  textColor: Theme.of(context).cardColor,
                  disabledTextColor: Theme.of(context).cardColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
