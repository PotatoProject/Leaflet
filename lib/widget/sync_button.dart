import 'package:flutter/material.dart';
import 'package:potato_notes/internal/sync/sync_service.dart';

class SyncButton extends StatefulWidget {
  const SyncButton({super.key});

  @override
  State<SyncButton> createState() => _SyncButtonState();
}

class _SyncButtonState extends State<SyncButton> with TickerProviderStateMixin {
  Future? syncFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: syncFuture,
      builder: (context, snapshot) {
        return IconButton(
          onPressed: () {
            setState(() {
              syncFuture = SyncService().sync();
            });
          },
          icon: snapshot.connectionState == ConnectionState.done ||
                  snapshot.connectionState == ConnectionState.none
              ? const Icon(Icons.sync)
              : const CircularProgressIndicator(),
        );
      },
    );
  }
}
