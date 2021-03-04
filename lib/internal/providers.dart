import 'package:dio/dio.dart';
import 'package:potato_notes/data/dao/note_helper.dart';
import 'package:potato_notes/data/dao/tag_helper.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/internal/sync/image_queue.dart';
import 'package:potato_notes/internal/app_info.dart';
import 'package:potato_notes/internal/device_info.dart';
import 'package:potato_notes/internal/preferences.dart';
import 'package:potato_notes/internal/sync/token_interceptor.dart';

class _ProvidersSingleton {
  _ProvidersSingleton._();

  AppInfo _appInfo;
  DeviceInfo _deviceInfo;
  Preferences _prefs;
  ImageQueue _imageQueue;
  Dio _dio;
  NoteHelper _helper;
  TagHelper _tagHelper;

  static final _ProvidersSingleton instance = _ProvidersSingleton._();

  void initProviders(AppDatabase _db) {
    _helper = _db.noteHelper;
    _tagHelper = _db.tagHelper;
    _dio = Dio();
    _dio.interceptors.add(TokenInterceptor());
    _prefs = Preferences();
    _deviceInfo = DeviceInfo();
    _imageQueue = ImageQueue();
    _appInfo = AppInfo();
  }
}

void initProviders(AppDatabase _db) =>
    _ProvidersSingleton.instance.initProviders(_db);

AppInfo get appInfo => _ProvidersSingleton.instance._appInfo;

DeviceInfo get deviceInfo => _ProvidersSingleton.instance._deviceInfo;

Preferences get prefs => _ProvidersSingleton.instance._prefs;

ImageQueue get imageQueue => _ProvidersSingleton.instance._imageQueue;

Dio get dio => _ProvidersSingleton.instance._dio;

NoteHelper get helper => _ProvidersSingleton.instance._helper;

TagHelper get tagHelper => _ProvidersSingleton.instance._tagHelper;
