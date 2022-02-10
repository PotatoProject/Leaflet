import 'dart:io';

import 'package:dio/dio.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/sync/controller.dart';
import 'package:potato_notes/internal/sync/note_controller.dart';
import 'package:potato_notes/internal/utils.dart';

class SettingController extends Controller {
  Future<String> get(String key) async {
    try {
      final Response getResult = await dio.get(
        url("setting/$key"),
        options: Options(
          headers: Controller.tokenHeaders,
        ),
      );
      return NoteController.handleResponse(getResult).toString();
    } on SocketException {
      throw "Could not connect to server";
    } catch (e) {
      rethrow;
    }
  }

  Future<String> set(String key, String value) async {
    try {
      final Response setResult = await dio.put(
        url("setting/$key"),
        data: value,
        options: Options(
          headers: Controller.tokenHeaders,
        ),
      );
      return NoteController.handleResponse(setResult).toString();
    } on SocketException {
      throw "Could not connect to server";
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, String>> getChanged(int lastUpdated) async {
    try {
      final Response getResult = await dio.get(
        url("setting/changed?last_updated=$lastUpdated"),
        options: Options(
          headers: Controller.tokenHeaders,
        ),
      );
      NoteController.handleResponse(getResult);
      final Map<String, dynamic> data =
          Utils.asMap<String, dynamic>(getResult.data);
      return data.map(
        (key, value) => MapEntry(key, value.toString()),
      );
    } on SocketException {
      throw "Could not connect to server";
    }
  }

  @override
  String get prefix => "notes";
}
