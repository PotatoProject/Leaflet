// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_info.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AppInfo on _AppInfoBase, Store {
  final _$_accentDataValueAtom = Atom(name: '_AppInfoBase._accentDataValue');

  @override
  int get _accentDataValue {
    _$_accentDataValueAtom.reportRead();
    return super._accentDataValue;
  }

  @override
  set _accentDataValue(int value) {
    _$_accentDataValueAtom.reportWrite(value, super._accentDataValue, () {
      super._accentDataValue = value;
    });
  }

  final _$_activeNotificationsValueAtom =
      Atom(name: '_AppInfoBase._activeNotificationsValue');

  @override
  List<ActiveNotification> get _activeNotificationsValue {
    _$_activeNotificationsValueAtom.reportRead();
    return super._activeNotificationsValue;
  }

  @override
  set _activeNotificationsValue(List<ActiveNotification> value) {
    _$_activeNotificationsValueAtom
        .reportWrite(value, super._activeNotificationsValue, () {
      super._activeNotificationsValue = value;
    });
  }

  final _$_AppInfoBaseActionController = ActionController(name: '_AppInfoBase');

  @override
  void updateAccent(dynamic event) {
    final _$actionInfo = _$_AppInfoBaseActionController.startAction(
        name: '_AppInfoBase.updateAccent');
    try {
      return super.updateAccent(event);
    } finally {
      _$_AppInfoBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void pollForActiveNotifications() {
    final _$actionInfo = _$_AppInfoBaseActionController.startAction(
        name: '_AppInfoBase.pollForActiveNotifications');
    try {
      return super.pollForActiveNotifications();
    } finally {
      _$_AppInfoBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
