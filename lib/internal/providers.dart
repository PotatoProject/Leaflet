import 'package:potato_notes/data/dao/note_helper.dart';
import 'package:potato_notes/data/dao/tag_helper.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/internal/http_client.dart';
import 'package:potato_notes/internal/sync/image_queue.dart';
import 'package:potato_notes/internal/app_info.dart';
import 'package:potato_notes/internal/device_info.dart';
import 'package:potato_notes/internal/preferences.dart';

class _ProvidersSingleton {
  _ProvidersSingleton._();

  AppInfo _appInfo;
  DeviceInfo _deviceInfo;
  Preferences _prefs;
  ImageQueue _imageQueue;
  HttpClient _httpClient;
  NoteHelper _helper;
  TagHelper _tagHelper;

  static final _ProvidersSingleton instance = _ProvidersSingleton._();

  void initProviders(AppDatabase _db) {
    _httpClient = HttpClient();
    _helper = _db.noteHelper;
    _tagHelper = _db.tagHelper;
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

HttpClient get httpClient => _ProvidersSingleton.instance._httpClient;

NoteHelper get helper => _ProvidersSingleton.instance._helper;

TagHelper get tagHelper => _ProvidersSingleton.instance._tagHelper;
