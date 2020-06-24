import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:potato_notes/internal/preferences.dart';
import 'package:provider/provider.dart';

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
  Preferences prefs;
  TextEditingController controller;

  bool showPass = false;
  String status;

  @override
  Widget build(BuildContext context) {
    if (prefs == null) prefs = Provider.of<Preferences>(context);
    if (controller == null)
      controller = TextEditingController(
        text: widget.editMode ? prefs.masterPass ?? "" : "",
      );

    controller.addListener(() => setState(() {}));

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
              (widget.editMode ? "Modify " : "Confirm ") + "master pass",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.visiblePassword,
                    controller: controller,
                    obscureText: !showPass,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    showPass
                        ? CommunityMaterialIcons.eye_outline
                        : CommunityMaterialIcons.eye_off_outline,
                  ),
                  onPressed: () => setState(() => showPass = !showPass),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  status ?? "",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
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
