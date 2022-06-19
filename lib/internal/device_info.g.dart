// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_info.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$DeviceInfo on _DeviceInfoBase, Store {
  late final _$_canCheckBiometricsValueAtom =
      Atom(name: '_DeviceInfoBase._canCheckBiometricsValue', context: context);

  @override
  bool get _canCheckBiometricsValue {
    _$_canCheckBiometricsValueAtom.reportRead();
    return super._canCheckBiometricsValue;
  }

  @override
  set _canCheckBiometricsValue(bool value) {
    _$_canCheckBiometricsValueAtom
        .reportWrite(value, super._canCheckBiometricsValue, () {
      super._canCheckBiometricsValue = value;
    });
  }

  late final _$_availableBiometricsValueAtom =
      Atom(name: '_DeviceInfoBase._availableBiometricsValue', context: context);

  @override
  List<BiometricType> get _availableBiometricsValue {
    _$_availableBiometricsValueAtom.reportRead();
    return super._availableBiometricsValue;
  }

  @override
  set _availableBiometricsValue(List<BiometricType> value) {
    _$_availableBiometricsValueAtom
        .reportWrite(value, super._availableBiometricsValue, () {
      super._availableBiometricsValue = value;
    });
  }

  late final _$_canUseSystemAccentValueAtom =
      Atom(name: '_DeviceInfoBase._canUseSystemAccentValue', context: context);

  @override
  bool get _canUseSystemAccentValue {
    _$_canUseSystemAccentValueAtom.reportRead();
    return super._canUseSystemAccentValue;
  }

  @override
  set _canUseSystemAccentValue(bool value) {
    _$_canUseSystemAccentValueAtom
        .reportWrite(value, super._canUseSystemAccentValue, () {
      super._canUseSystemAccentValue = value;
    });
  }

  late final _$_isLandscapeValueAtom =
      Atom(name: '_DeviceInfoBase._isLandscapeValue', context: context);

  @override
  bool get _isLandscapeValue {
    _$_isLandscapeValueAtom.reportRead();
    return super._isLandscapeValue;
  }

  @override
  set _isLandscapeValue(bool value) {
    _$_isLandscapeValueAtom.reportWrite(value, super._isLandscapeValue, () {
      super._isLandscapeValue = value;
    });
  }

  late final _$_uiSizeFactorValueAtom =
      Atom(name: '_DeviceInfoBase._uiSizeFactorValue', context: context);

  @override
  int get _uiSizeFactorValue {
    _$_uiSizeFactorValueAtom.reportRead();
    return super._uiSizeFactorValue;
  }

  @override
  set _uiSizeFactorValue(int value) {
    _$_uiSizeFactorValueAtom.reportWrite(value, super._uiSizeFactorValue, () {
      super._uiSizeFactorValue = value;
    });
  }

  late final _$loadDataAsyncAction =
      AsyncAction('_DeviceInfoBase.loadData', context: context);

  @override
  Future<void> loadData() {
    return _$loadDataAsyncAction.run(() => super.loadData());
  }

  late final _$_DeviceInfoBaseActionController =
      ActionController(name: '_DeviceInfoBase', context: context);

  @override
  void setCanUseSystemAccent(bool value) {
    final _$actionInfo = _$_DeviceInfoBaseActionController.startAction(
        name: '_DeviceInfoBase.setCanUseSystemAccent');
    try {
      return super.setCanUseSystemAccent(value);
    } finally {
      _$_DeviceInfoBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateDeviceInfo(MediaQueryData mq, bool canUseSystemAccent) {
    final _$actionInfo = _$_DeviceInfoBaseActionController.startAction(
        name: '_DeviceInfoBase.updateDeviceInfo');
    try {
      return super.updateDeviceInfo(mq, canUseSystemAccent);
    } finally {
      _$_DeviceInfoBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
