import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:potato_notes/internal/locales/locale_strings.g.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/sync/account_controller.dart';
import 'package:potato_notes/internal/sync/image/files_controller.dart';
import 'package:potato_notes/internal/sync/image/image_helper.dart';

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
              FutureBuilder<String>(
                future: ImageHelper.getAvatar(),
                builder: (context, snapshot) {
                  return CircleAvatar(
                    radius: 32,
                    backgroundColor:
                        Theme.of(context).iconTheme.color.withOpacity(0.1),
                    backgroundImage: snapshot.hasData
                        ? CachedNetworkImageProvider(snapshot.data)
                        : null,
                    child: snapshot.hasData
                        ? null
                        : Icon(
                            Icons.person_outlined,
                            size: 24,
                            color: Theme.of(context).iconTheme.color,
                          ),
                  );
                },
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
        FutureBuilder(
          future: FilesController.getStats(),
          builder: (context, snapshot) {
            return ListTile(
              leading: Icon(Icons.image_outlined),
              title: Text("Image upload capacity"),
              subtitle: LinearProgressIndicator(
                value: snapshot.hasData
                    ? snapshot.data.used / snapshot.data.limit
                    : null,
                backgroundColor: Theme.of(context).accentColor.withOpacity(0.2),
              ),
              trailing: Text(
                snapshot.hasData
                    ? LocaleStrings.common
                    .xOfY(snapshot.data.used, snapshot.data.limit)
                    : '-',
              ),
            );
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.logout),
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
