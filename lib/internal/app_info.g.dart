// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_info.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AppInfo on _AppInfoBase, Store {
  final _$accentDataValueAtom = Atom(name: '_AppInfoBase.accentDataValue');

  @override
  int get accentDataValue {
    _$accentDataValueAtom.reportRead();
    return super.accentDataValue;
  }

  @override
  set accentDataValue(int value) {
    _$accentDataValueAtom.reportWrite(value, super.accentDataValue, () {
      super.accentDataValue = value;
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
  String toString() {
    return '''
accentDataValue: ${accentDataValue}
    ''';
  }
}
