import 'package:potato_notes/data/dao/note_helper.dart';
import 'package:potato_notes/data/dao/tag_helper.dart';
import 'package:potato_notes/internal/app_info.dart';
import 'package:potato_notes/internal/device_info.dart';
import 'package:potato_notes/internal/preferences.dart';
import 'package:potato_notes/internal/sync/image_queue.dart';

final AppInfo appInfo = AppInfo();

final DeviceInfo deviceInfo = DeviceInfo();

final Preferences prefs = Preferences();

final ImageQueue imageQueue = ImageQueue();

late NoteHelper helper;

late TagHelper tagHelper;
