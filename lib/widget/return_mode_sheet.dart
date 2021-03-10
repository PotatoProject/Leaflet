import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:potato_notes/data/dao/note_helper.dart';
import 'package:potato_notes/internal/custom_icons.dart';

class ReturnModeSelectionSheet extends StatefulWidget {
  final SearchReturnMode mode;
  final ValueChanged<SearchReturnMode> onModeChanged;

  const ReturnModeSelectionSheet({
    @required this.mode,
    this.onModeChanged,
  });

  @override
  _ReturnModeSelectionSheetState createState() =>
      _ReturnModeSelectionSheetState();
}

class _ReturnModeSelectionSheetState extends State<ReturnModeSelectionSheet> {
  SearchReturnMode _mode;

  @override
  void initState() {
    super.initState();
    _mode = widget.mode;
  }

  @override
  void didUpdateWidget(ReturnModeSelectionSheet old) {
    super.didUpdateWidget(old);
    if (widget.mode != old.mode) {
      _mode = widget.mode;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CheckboxListTile(
          secondary: const Icon(CustomIcons.notes),
          title: const Text("Normal notes"),
          value: _mode.fromNormal,
          onChanged:
              _mode.values.where((e) => e).length > 1 || !_mode.fromNormal
                  ? (value) {
                      _mode = _mode.copyWith(
                        fromNormal: value,
                      );
                      widget.onModeChanged?.call(_mode);
                      setState(() {});
                    }
                  : null,
        ),
        CheckboxListTile(
          secondary: const Icon(MdiIcons.archiveOutline),
          title: const Text("Archived notes"),
          value: _mode.fromArchive,
          onChanged:
              _mode.values.where((e) => e).length > 1 || !_mode.fromArchive
                  ? (value) {
                      _mode = _mode.copyWith(
                        fromArchive: value,
                      );
                      widget.onModeChanged?.call(_mode);
                      setState(() {});
                    }
                  : null,
        ),
        CheckboxListTile(
          secondary: const Icon(Icons.delete_outlined),
          title: const Text("Deleted notes"),
          value: _mode.fromTrash,
          onChanged: _mode.values.where((e) => e).length > 1 || !_mode.fromTrash
              ? (value) {
                  _mode = _mode.copyWith(
                    fromTrash: value,
                  );
                  widget.onModeChanged?.call(_mode);
                  setState(() {});
                }
              : null,
        ),
      ],
    );
  }
}
