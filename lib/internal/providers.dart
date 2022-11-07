import 'package:dio/dio.dart';
import 'package:intl/locale.dart';
import 'package:liblymph/database.dart';
import 'package:liblymph/providers.dart';
import 'package:monet/monet.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:potato_notes/generated/locale.dart';
import 'package:potato_notes/internal/app_config.dart';
import 'package:potato_notes/internal/app_directories.dart';
import 'package:potato_notes/internal/app_info.dart';
import 'package:potato_notes/internal/backup_delegate.dart';
import 'package:potato_notes/internal/database.dart';
import 'package:potato_notes/internal/device_info.dart';
import 'package:potato_notes/internal/keystore.dart';
import 'package:potato_notes/internal/preferences.dart';
import 'package:potato_notes/internal/shared_prefs.dart';
import 'package:yatl/yatl.dart';
import 'package:yatl_gen/src/api.dart';

class _ProvidersSingleton extends Providers {
  _ProvidersSingleton._();

  late Keystore _keystore;
  late MonetProvider _monet;
  late SharedPrefs _sharedPrefs;
  late AppConfig _appConfig;
  late AppInfo _appInfo;
  late DeviceInfo _deviceInfo;
  late Preferences _prefs;
  late BackupDelegate _backupDelegate;
  late Dio _dio;
  late YatlCore _yatl;
  late GeneratedLocales _locales;
  late GeneratedLocaleStrings _strings;
  late PocketBase _pocketBase;

  static void init() => Providers.provideInstance(_ProvidersSingleton._());

  Future<void> initKeystore() async {
    _keystore = await Keystore.newInstance();
  }

  Future<void> initCriticalProviders() async {
    _monet = await MonetProvider.newInstance();
    _sharedPrefs = await SharedPrefs.newInstance();
    _appConfig = await AppConfig.load();
    directories = await AppDirectories.initWithDefaults();
    database = AppDatabase(constructLeafletDb());
    this.noteHelper = database.noteHelper;
    this.tagHelper = database.tagHelper;
    this.folderHelper = database.folderHelper;
    this.imageHelper = database.imageHelper;

    _locales = GeneratedLocales();
    _yatl = YatlCore(
      loader: LocalesTranslationsLoader(_locales),
      supportedLocales: _locales.supportedLocales,
      fallbackLocale: Locale.parse("en_US"),
    );
    _strings = GeneratedLocaleStrings(_yatl);
    _pocketBase = PocketBase("https://potatosync.fly.dev");
    //TODO: remove the temporary login
    await _pocketBase.users
        .authViaEmail("myth.usa538+1@gmail.com", "dDbu6sy9ADJYTQ");
  }

  Future<void> initProviders() async {
    _dio = Dio();

    _prefs = Preferences();
    await _prefs.loadData();
    _deviceInfo = DeviceInfo();
    await _deviceInfo.loadData();
    _appInfo = AppInfo();
    await _appInfo.loadData();

    _backupDelegate = BackupDelegate();
  }
}

_ProvidersSingleton get _instance => Providers.instance as _ProvidersSingleton;

void initProvidersInstance() => _ProvidersSingleton.init();

Future<void> initKeystore() async => _instance.initKeystore();

Future<void> initCriticalProviders() async => _instance.initCriticalProviders();

Future<void> initProviders() async => _instance.initProviders();

Keystore get keystore => _instance._keystore;

MonetProvider get monet => _instance._monet;

AppConfig get appConfig => _instance._appConfig;

SharedPrefs get sharedPrefs => _instance._sharedPrefs;

AppInfo get appInfo => _instance._appInfo;

AppDirectories get appDirectories => _instance.directories as AppDirectories;

DeviceInfo get deviceInfo => _instance._deviceInfo;

Preferences get prefs => _instance._prefs;

BackupDelegate get backupDelegate => _instance._backupDelegate;

Dio get dio => _instance._dio;

AppDatabase get db => _instance.database;

NoteHelper get noteHelper => _instance.noteHelper;

TagHelper get tagHelper => _instance.tagHelper;

FolderHelper get folderHelper => _instance.folderHelper;

ImageHelper get imageHelper => _instance.imageHelper;

YatlCore get yatl => _instance._yatl;

GeneratedLocales get locales => _instance._locales;

GeneratedLocaleStrings get strings => _instance._strings;

PocketBase get pocketbase => _instance._pocketBase;
