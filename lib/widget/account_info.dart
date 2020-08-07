import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/sync/account_controller.dart';

class AccountInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor:
                    Theme.of(context).iconTheme.color.withOpacity(0.1),
                child: Icon(
                  MdiIcons.accountOutline,
                  size: 24,
                  color: Theme.of(context).iconTheme.color,
                ),
              ),
              SizedBox(
                width: 24,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    prefs.username ?? "",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    prefs.email ?? "",
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Divider(),
        ListTile(
          leading: Icon(MdiIcons.logout),
          title: Text("Logout"),
          onTap: () async {
            Navigator.pop(context);
            await AccountController.logout();
          },
        ),
      ],
    );
  }
}
