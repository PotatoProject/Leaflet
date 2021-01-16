import 'package:potato_notes/data/dao/note_helper.dart';
import 'package:potato_notes/data/dao/tag_helper.dart';
import 'package:potato_notes/internal/sync/image_queue.dart';
import 'package:potato_notes/internal/app_info.dart';
import 'package:potato_notes/internal/device_info.dart';
import 'package:potato_notes/internal/preferences.dart';

void initProviders() {
  _appInfo = AppInfo();
  _deviceInfo = DeviceInfo();
  _prefs = Preferences();
  _imageQueue = ImageQueue();
}

AppInfo _appInfo;
DeviceInfo _deviceInfo;
Preferences _prefs;
ImageQueue _imageQueue;

AppInfo get appInfo => _appInfo;

DeviceInfo get deviceInfo => _deviceInfo;

Preferences get prefs => _prefs;

ImageQueue get imageQueue => _imageQueue;

NoteHelper helper;

TagHelper tagHelper;
