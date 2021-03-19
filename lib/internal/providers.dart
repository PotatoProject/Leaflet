import 'package:dio/dio.dart';
import 'package:potato_notes/data/dao/note_helper.dart';
import 'package:potato_notes/data/dao/tag_helper.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/internal/shared_prefs.dart';
import 'package:potato_notes/internal/sync/image/image_helper.dart';
import 'package:potato_notes/internal/sync/image_queue.dart';
import 'package:potato_notes/internal/app_info.dart';
import 'package:potato_notes/internal/device_info.dart';
import 'package:potato_notes/internal/preferences.dart';
import 'package:potato_notes/internal/sync/sync_routine.dart';
import 'package:potato_notes/internal/sync/request_interceptor.dart';

class _ProvidersSingleton {
  _ProvidersSingleton._();

  late SharedPrefs _sharedPrefs;
  late AppInfo _appInfo;
  late DeviceInfo _deviceInfo;
  late Preferences _prefs;
  late ImageQueue _imageQueue;
  late Dio _dio;
  late NoteHelper _helper;
  late TagHelper _tagHelper;
  late SyncRoutine _syncRoutine;
  late ImageHelper _imageHelper;

  static final _ProvidersSingleton instance = _ProvidersSingleton._();

  Future<void> initProviders(AppDatabase _db) async {
    _sharedPrefs = await SharedPrefs.newInstance();
    _helper = _db.noteHelper;
    _tagHelper = _db.tagHelper;
    _dio = Dio();
    _dio.interceptors.add(RequestInterceptor());
    _prefs = Preferences();
    _deviceInfo = DeviceInfo();
    _imageQueue = ImageQueue();
    _appInfo = AppInfo();
    _syncRoutine = SyncRoutine();
    _imageHelper = ImageHelper();
  }
}

Future<void> initProviders(AppDatabase _db) async =>
    _ProvidersSingleton.instance.initProviders(_db);

SharedPrefs get sharedPrefs => _ProvidersSingleton.instance._sharedPrefs;

AppInfo get appInfo => _ProvidersSingleton.instance._appInfo;

DeviceInfo get deviceInfo => _ProvidersSingleton.instance._deviceInfo;

Preferences get prefs => _ProvidersSingleton.instance._prefs;

ImageQueue get imageQueue => _ProvidersSingleton.instance._imageQueue;

Dio get dio => _ProvidersSingleton.instance._dio;

NoteHelper get helper => _ProvidersSingleton.instance._helper;

TagHelper get tagHelper => _ProvidersSingleton.instance._tagHelper;

SyncRoutine get syncRoutine => _ProvidersSingleton.instance._syncRoutine;

ImageHelper get imageHelper => _ProvidersSingleton.instance._imageHelper;
