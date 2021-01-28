import 'package:dio/dio.dart';
import 'package:fresh_dio/fresh_dio.dart';
import 'package:potato_notes/data/dao/note_helper.dart';
import 'package:potato_notes/data/dao/tag_helper.dart';
import 'package:potato_notes/internal/sync/image_queue.dart';
import 'package:potato_notes/internal/app_info.dart';
import 'package:potato_notes/internal/device_info.dart';
import 'package:potato_notes/internal/preferences.dart';
import 'package:potato_notes/internal/sync/token_interceptor.dart';

void initProviders() {
  _appInfo = AppInfo();
  _deviceInfo = DeviceInfo();
  _prefs = Preferences();
  _imageQueue = ImageQueue();
  _dio = new Dio();
  _dio.interceptors.add(TokenInterceptor());
}

AppInfo _appInfo;
DeviceInfo _deviceInfo;
Preferences _prefs;
ImageQueue _imageQueue;
Dio _dio;

AppInfo get appInfo => _appInfo;

DeviceInfo get deviceInfo => _deviceInfo;

Preferences get prefs => _prefs;

ImageQueue get imageQueue => _imageQueue;

Dio get dio => _dio;

NoteHelper helper;

TagHelper tagHelper;
