import 'package:flutter/material.dart';
import 'package:potato_notes/internal/migration_task.dart';

class ImportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.import_export_outlined),
        title: Text("Import notes"),
        textTheme: Theme.of(context).textTheme,
      ),
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 16,
              top: 56 + 16 + MediaQuery.of(context).padding.top,
            ),
            children: <Widget>[
              Text(
                  "If you have any notes from the older version you can import those on the new version"),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: TextButton(
              child: Text("Import notes"),
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => AlertDialog(
                    content: StreamBuilder(
                      stream: MigrationTask.migrate(),
                      builder: (context, snapshot) => Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Importing notes..."),
                          SizedBox(
                            height: 16,
                          ),
                          LinearProgressIndicator(
                            value: snapshot.data as double?,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      extendBody: true,
    );
  }
}
