import 'dart:io';

import 'package:potato_notes/data/dao/note_helper.dart';
import 'package:potato_notes/data/dao/tag_helper.dart';
import 'package:potato_notes/internal/app_info.dart';
import 'package:potato_notes/internal/device_info.dart';
import 'package:potato_notes/internal/preferences.dart';
import 'package:potato_notes/internal/sync/image/image_service.dart';

AppInfo appInfo;

DeviceInfo deviceInfo;

Preferences prefs;

NoteHelper helper;

TagHelper tagHelper;

Directory tempDirectory;

ImageService imageService;
