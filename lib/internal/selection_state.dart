import 'package:flutter/material.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/widget/selection_bar.dart';

class SelectionStateWidget extends StatelessWidget {
  final Widget child;
  final SelectionState state;

  SelectionStateWidget({
    required this.child,
    required SelectionOptions options,
    required Folder folder,
    ValueChanged<bool>? onSelectionChanged,
  }) : state = SelectionState(
          options: options,
          folder: folder,
          onSelectionChanged: onSelectionChanged,
        );

  const SelectionStateWidget.withState({
    required this.child,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return _ChangeNotifierWidget(
      notifier: state,
      child: child,
    );
  }
}

class SelectionState extends ChangeNotifier {
  final SelectionOptions _selectionOptions;
  final ValueChanged<bool>? onSelectionChanged;
  final Folder _folder;

  SelectionState({
    required SelectionOptions options,
    required Folder folder,
    this.onSelectionChanged,
  })  : _folder = folder,
        _selectionOptions = options;

  final ValueNotifier<bool> _selecting = ValueNotifier(false);
  final List<Note> _selectionList = [];

  SelectionOptions get selectionOptions => _selectionOptions;
  Folder get folder => _folder;

  ValueNotifier<bool> get selectingNotifier => _selecting;
  bool get selecting => _selecting.value;
  set selecting(bool value) {
    _selecting.value = value;
    onSelectionChanged?.call(value);
    notifyListeners();
  }

  List<Note> get selectionList => _selectionList;

  void addSelectedNote(Note note) {
    _selectionList.add(note);
    notifyListeners();
  }

  void removeSelectedNoteWhere(bool Function(Note) test) {
    _selectionList.removeWhere(test);
    notifyListeners();
  }

  void closeSelection() {
    selecting = false;
    _selectionList.clear();
    notifyListeners();
  }

  static SelectionState of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<
            _ChangeNotifierInheritedWidget<SelectionState>>()!
        .state;
  }

  static SelectionState? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<
            _ChangeNotifierInheritedWidget<SelectionState>>()
        ?.state;
  }
}

class _ChangeNotifierWidget<T extends ChangeNotifier> extends StatefulWidget {
  final Widget child;
  final T notifier;

  const _ChangeNotifierWidget({
    required this.child,
    required this.notifier,
  });

  @override
  _ChangeNotifierWidgetState<T> createState() =>
      _ChangeNotifierWidgetState<T>();
}

class _ChangeNotifierWidgetState<T extends ChangeNotifier>
    extends State<_ChangeNotifierWidget<T>> {
  @override
  void initState() {
    super.initState();
    widget.notifier.addListener(_update);
  }

  @override
  void dispose() {
    widget.notifier.removeListener(_update);
    super.dispose();
  }

  void _update() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return _ChangeNotifierInheritedWidget<T>(
      state: widget.notifier,
      child: widget.child,
    );
  }
}

class _ChangeNotifierInheritedWidget<T extends ChangeNotifier>
    extends InheritedWidget {
  final T state;

  const _ChangeNotifierInheritedWidget({
    required Widget child,
    required this.state,
    Key? key,
  }) : super(child: child, key: key);

  @override
  bool updateShouldNotify(covariant _ChangeNotifierInheritedWidget oldWidget) =>
      true;
}
