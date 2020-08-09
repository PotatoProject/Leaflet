import 'dart:convert';
import 'dart:isolate';
import 'dart:ui';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:in_app_update/in_app_update.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/utils.dart';
import 'package:potato_notes/widget/notes_logo.dart';

class InAppUpdater {
  static final BuildType buildType = _getBuildType(
    const String.fromEnvironment(
      "build_type",
      defaultValue: "github",
    ),
  );

  static BuildType _getBuildType(String buildTypeFromEnv) {
    print(buildTypeFromEnv);
    switch (buildTypeFromEnv.toLowerCase()) {
      case 'fdroid':
        return BuildType.FDROID;
      case 'playstore':
        return BuildType.PLAYSTORE;
      case 'github':
      default:
        return BuildType.GITHUB;
    }
  }

  static Future<AppUpdateInfo> _internalCheckForUpdate() async {
    switch (buildType) {
      case BuildType.FDROID:
        // TODO: implement when app is uploaded to fdroid
        throw UnsupportedError("Implement when app is uploaded to fdroid");
      case BuildType.PLAYSTORE:
        return await InAppUpdate.checkForUpdate();
      case BuildType.GITHUB:
      default:
        Response githubRelease = await http.get(
          "https://api.github.com/repos/HrX03/PotatoNotes/releases/latest",
        );
        Map<dynamic, dynamic> body = json.decode(githubRelease.body);
        int versionCode = int.parse(body["tag_name"].split("+")[1]);
        return AppUpdateInfo(
          versionCode > int.parse(appInfo.packageInfo.buildNumber),
          false,
          true,
          versionCode,
        );
    }
  }

  static void checkForUpdate(BuildContext context,
      {bool showNoUpdatesAvailable = false}) async {
    final updateInfo = await InAppUpdater._internalCheckForUpdate();
    if (updateInfo.updateAvailable) {
      InAppUpdater.update(
        context,
        updateInfo.immediateUpdateAllowed,
        updateInfo.flexibleUpdateAllowed,
      );
    } else {
      if (showNoUpdatesAvailable) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Text("You're already on the latest app version"),
            actions: [
              FlatButton(
                child: Text("Close"),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
        );
      }
    }
  }

  static Future<void> update(
    BuildContext context,
    bool immediateUpdateAllowed,
    bool flexibleUpdateAllowed,
  ) async {
    switch (buildType) {
      case BuildType.FDROID:
        // TODO: implement when app is uploaded to fdroid
        throw UnsupportedError("Implement when app is uploaded to fdroid");
      case BuildType.PLAYSTORE:
        if (flexibleUpdateAllowed) {
          await InAppUpdate.startFlexibleUpdate();
        } else {
          await InAppUpdate.performImmediateUpdate();
        }
        break;
      case BuildType.GITHUB:
      default:
        bool shouldUpdate = await _showUpdateDialog(context);

        if (!shouldUpdate) return;

        Response githubRelease = await http.get(
          "https://api.github.com/repos/HrX03/PotatoNotes/releases/latest",
        );
        Map<dynamic, dynamic> body = json.decode(githubRelease.body);
        String taskId = await FlutterDownloader.enqueue(
          url: body["assets"][0]["browser_download_url"],
          savedDir: (await getTemporaryDirectory()).path,
          showNotification: false,
          openFileFromNotification: false,
        );
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return FadeTransition(
                opacity: animation,
                child: InAppUpdatePage(
                  taskId: taskId,
                ),
              );
            },
          ),
        );
    }
  }

  static Future<bool> _showUpdateDialog(BuildContext context) {
    return showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: Row(
                children: [
                  NotesLogo(
                    height: 24,
                  ),
                  SizedBox(width: 16),
                  Text("Update available!"),
                ],
              ),
              content: Text(
                "A new update is available to download, click update to start downloading and installing the update.",
              ),
              buttonPadding: EdgeInsets.symmetric(horizontal: 16),
              actions: [
                FlatButton(
                  child: Text("Not now".toUpperCase()),
                  onPressed: () => Navigator.pop(context, false),
                  textColor: Utils.defaultAccent,
                ),
                FlatButton(
                  child: Text("Update".toUpperCase()),
                  onPressed: () => Navigator.pop(context, true),
                  color: Utils.defaultAccent,
                  textColor: Theme.of(context).dialogTheme.backgroundColor,
                ),
              ],
            );
          },
        ) ??
        false;
  }
}

class InAppUpdatePage extends StatefulWidget {
  final String taskId;

  InAppUpdatePage({
    @required this.taskId,
  }) : assert(taskId != null);

  @override
  _InAppUpdatePageState createState() => _InAppUpdatePageState();
}

class _InAppUpdatePageState extends State<InAppUpdatePage> {
  ReceivePort _port = ReceivePort();

  DownloadTaskStatus status = DownloadTaskStatus.enqueued;
  int progress;

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add((_) => true, name: "antiPop");

    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      status = data[1];
      progress = data[2];
      print("${widget.taskId} $status $progress");
      setState(() {});
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    BackButtonInterceptor.removeByName("antiPop");
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Center(
              child: NotesLogo(
                penColor: Theme.of(context).scaffoldBackgroundColor,
                height: 106,
              ),
            ),
            Builder(
              builder: (context) {
                switch (status.value) {
                  case 0:
                  case 1:
                  case 2:
                    return ListTile(
                      title: Text(
                        "Downloading update: ${progress ?? 0}%",
                      ),
                      subtitle: LinearProgressIndicator(
                        value: progress != null ? progress / 100 : null,
                        backgroundColor:
                            Theme.of(context).accentColor.withOpacity(0.2),
                      ),
                      trailing: IconButton(
                        icon: Icon(MdiIcons.close),
                        onPressed: () async {
                          await FlutterDownloader.cancel(taskId: widget.taskId);
                          Navigator.pop(context);
                        },
                      ),
                    );
                  case 3:
                    return ListTile(
                      leading: Icon(
                        MdiIcons.check,
                      ),
                      title: Text(
                        "Update ready to install",
                      ),
                      trailing: FlatButton(
                        onPressed: () async {
                          await FlutterDownloader.open(taskId: widget.taskId);
                        },
                        padding: EdgeInsets.all(0),
                        child: Text("INSTALL"),
                      ),
                    );
                  case 4:
                  case 5:
                    return ListTile(
                      leading: Icon(
                        Icons.error_outline,
                      ),
                      title: Text(
                        "Update failed to download",
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(MdiIcons.restore),
                            onPressed: () async {
                              progress = null;
                              status = DownloadTaskStatus.enqueued;
                              setState(() {});
                              await FlutterDownloader.retry(
                                  taskId: widget.taskId);
                            },
                          ),
                          IconButton(
                            icon: Icon(MdiIcons.close),
                            onPressed: () async {
                              await FlutterDownloader.cancel(
                                  taskId: widget.taskId);
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                  default:
                    return Container();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

enum BuildType {
  GITHUB,
  FDROID,
  PLAYSTORE,
}
