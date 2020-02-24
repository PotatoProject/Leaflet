// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ru locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ru';

  static m0(method, maxLength) =>
      "длина ${method} не может превышать ${maxLength}";

  static m1(method, minLength) =>
      "длина ${method} не может быть меньше ${minLength}";

  static m2(noteSelected) => "${noteSelected} заметка выбрана";

  static m3(noteSelected) => "${noteSelected} заметок выбрано";

  static m4(currentPage, totalPages) =>
      "Страница ${currentPage} из ${totalPages}";

  static m5(path) => "Бэкап расположен в: ${path}";

  static m6(username) => "Вход выполнен как: ${username}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
        "archive": MessageLookupByLibrary.simpleMessage("Архив"),
        "black": MessageLookupByLibrary.simpleMessage("Черная"),
        "cancel": MessageLookupByLibrary.simpleMessage("Отмена"),
        "chooseAction":
            MessageLookupByLibrary.simpleMessage("Выберите действие"),
        "close": MessageLookupByLibrary.simpleMessage("Закрыть"),
        "confirm": MessageLookupByLibrary.simpleMessage("Подтвердить"),
        "dark": MessageLookupByLibrary.simpleMessage("Темная"),
        "done": MessageLookupByLibrary.simpleMessage("Готово"),
        "home": MessageLookupByLibrary.simpleMessage("Главная страница"),
        "light": MessageLookupByLibrary.simpleMessage("Светлая"),
        "modifyNotesRoute_color_change":
            MessageLookupByLibrary.simpleMessage("Изменить цвет записки"),
        "modifyNotesRoute_color_dialogTitle":
            MessageLookupByLibrary.simpleMessage("Цвет записок"),
        "modifyNotesRoute_content":
            MessageLookupByLibrary.simpleMessage("Содержимое"),
        "modifyNotesRoute_image":
            MessageLookupByLibrary.simpleMessage("Изображение"),
        "modifyNotesRoute_image_add":
            MessageLookupByLibrary.simpleMessage("Добавить изображение"),
        "modifyNotesRoute_image_remove":
            MessageLookupByLibrary.simpleMessage("Удалить изображение"),
        "modifyNotesRoute_image_update":
            MessageLookupByLibrary.simpleMessage("Обновить изображение"),
        "modifyNotesRoute_list": MessageLookupByLibrary.simpleMessage("Список"),
        "modifyNotesRoute_list_entry":
            MessageLookupByLibrary.simpleMessage("Запись"),
        "modifyNotesRoute_list_selectedEntries":
            MessageLookupByLibrary.simpleMessage(" записей выделено"),
        "modifyNotesRoute_reminder":
            MessageLookupByLibrary.simpleMessage("Напоминание"),
        "modifyNotesRoute_reminder_add":
            MessageLookupByLibrary.simpleMessage("Добавить напоминание"),
        "modifyNotesRoute_reminder_date":
            MessageLookupByLibrary.simpleMessage("Дата"),
        "modifyNotesRoute_reminder_time":
            MessageLookupByLibrary.simpleMessage("Время"),
        "modifyNotesRoute_reminder_update":
            MessageLookupByLibrary.simpleMessage("Обновить напоминание"),
        "modifyNotesRoute_security_dialog_lengthExceed": m0,
        "modifyNotesRoute_security_dialog_lengthShort": m1,
        "modifyNotesRoute_security_dialog_titlePassword":
            MessageLookupByLibrary.simpleMessage(
                "Установить или обновить пароль"),
        "modifyNotesRoute_security_dialog_titlePin":
            MessageLookupByLibrary.simpleMessage("Установить или обновить PIN"),
        "modifyNotesRoute_security_dialog_valid":
            MessageLookupByLibrary.simpleMessage(" верно"),
        "modifyNotesRoute_security_hideContent":
            MessageLookupByLibrary.simpleMessage(
                "Прятать содержание заметок на главной"),
        "modifyNotesRoute_security_password":
            MessageLookupByLibrary.simpleMessage("Пароль"),
        "modifyNotesRoute_security_pin":
            MessageLookupByLibrary.simpleMessage("PIN-код"),
        "modifyNotesRoute_security_protectionText":
            MessageLookupByLibrary.simpleMessage("Использовать защиту"),
        "modifyNotesRoute_title":
            MessageLookupByLibrary.simpleMessage("Заголовок"),
        "note_archive_snackbar":
            MessageLookupByLibrary.simpleMessage("Заметка перемещена в архив"),
        "note_delete": MessageLookupByLibrary.simpleMessage("Удалить"),
        "note_delete_snackbar":
            MessageLookupByLibrary.simpleMessage("Заметка удалена"),
        "note_edit": MessageLookupByLibrary.simpleMessage("Изменить"),
        "note_emptyTrash":
            MessageLookupByLibrary.simpleMessage("Очистить корзину"),
        "note_export": MessageLookupByLibrary.simpleMessage("Экспортировать"),
        "note_exportLocation":
            MessageLookupByLibrary.simpleMessage("Заметка экспортирована в"),
        "note_lockedOptions": MessageLookupByLibrary.simpleMessage(
            "Заметка заблокирована, используйте опции на экране заметки"),
        "note_pinToNotifs":
            MessageLookupByLibrary.simpleMessage("Закрепить в уведомлениях"),
        "note_removeFromArchive_snackbar":
            MessageLookupByLibrary.simpleMessage("Заметка убрана из архива"),
        "note_restore_snackbar":
            MessageLookupByLibrary.simpleMessage("Заметка восстановлена"),
        "note_select": MessageLookupByLibrary.simpleMessage("Выбрать"),
        "note_share": MessageLookupByLibrary.simpleMessage("Поделиться"),
        "note_star": MessageLookupByLibrary.simpleMessage("Пометить"),
        "note_unstar": MessageLookupByLibrary.simpleMessage("Снять пометку"),
        "notesMainPageRoute_emptyArchive":
            MessageLookupByLibrary.simpleMessage("У вас нет заметок в архиве"),
        "notesMainPageRoute_emptyTrash":
            MessageLookupByLibrary.simpleMessage("Корзина пуста"),
        "notesMainPageRoute_noNotes":
            MessageLookupByLibrary.simpleMessage("Заметки еще не добавлены"),
        "notesMainPageRoute_note_deleteDialog_content":
            MessageLookupByLibrary.simpleMessage(
                "Как только заметки будут удалены отсюда, вы не можете их восстановить.\nВы уверены, что хотите продолжить?"),
        "notesMainPageRoute_note_deleteDialog_title":
            MessageLookupByLibrary.simpleMessage("Удалить выбранные заметки?"),
        "notesMainPageRoute_note_emptyTrash_content":
            MessageLookupByLibrary.simpleMessage(
                "Как только заметки будут удалены отсюда, вы не можете их восстановить.\nВы уверены, что хотите продолжить?"),
        "notesMainPageRoute_note_emptyTrash_title":
            MessageLookupByLibrary.simpleMessage("Очистить корзину?"),
        "notesMainPageRoute_note_hiddenContent":
            MessageLookupByLibrary.simpleMessage("Содержимое скрыто"),
        "notesMainPageRoute_note_list_selectedEntries":
            MessageLookupByLibrary.simpleMessage(" записей выбрано"),
        "notesMainPageRoute_note_remindersSet":
            MessageLookupByLibrary.simpleMessage(
                "Напоминания установлены для заметки"),
        "notesMainPageRoute_other":
            MessageLookupByLibrary.simpleMessage("Другие заметки"),
        "notesMainPageRoute_pinnedNote":
            MessageLookupByLibrary.simpleMessage("Закрепленная заметка"),
        "notesMainPageRoute_starred":
            MessageLookupByLibrary.simpleMessage("Помеченные заметки"),
        "notesMainPageRoute_writeNote":
            MessageLookupByLibrary.simpleMessage("Написать заметку"),
        "notes_archive_snackbar":
            MessageLookupByLibrary.simpleMessage("Заметки перемещены в архив"),
        "notes_delete_snackbar":
            MessageLookupByLibrary.simpleMessage("Заметки удалены"),
        "notes_removeFromArchive_snackbar":
            MessageLookupByLibrary.simpleMessage("Заметки убрана из архива"),
        "notes_restore_snackbar":
            MessageLookupByLibrary.simpleMessage("Заметки восстановлены"),
        "remove": MessageLookupByLibrary.simpleMessage("Удалить"),
        "reset": MessageLookupByLibrary.simpleMessage("Сбросить"),
        "save": MessageLookupByLibrary.simpleMessage("Сохранить"),
        "searchNotesRoute_filters_case":
            MessageLookupByLibrary.simpleMessage("Учитывать регистр"),
        "searchNotesRoute_filters_color":
            MessageLookupByLibrary.simpleMessage("Цветовой фильтр"),
        "searchNotesRoute_filters_date":
            MessageLookupByLibrary.simpleMessage("По дате"),
        "searchNotesRoute_filters_title":
            MessageLookupByLibrary.simpleMessage("Фильтры поиска"),
        "searchNotesRoute_noQuery": MessageLookupByLibrary.simpleMessage(
            "Введите что-либо, чтобы начать поиск"),
        "searchNotesRoute_nothingFound": MessageLookupByLibrary.simpleMessage(
            "Не найдено записок соответствующих критериям поиска"),
        "searchNotesRoute_searchbar":
            MessageLookupByLibrary.simpleMessage("Поиск..."),
        "securityNoteRoute_request_password":
            MessageLookupByLibrary.simpleMessage(
                "Требуется пароль, чтобы открыть заметку"),
        "securityNoteRoute_request_pin": MessageLookupByLibrary.simpleMessage(
            "Требуется PIN, чтобы открыть заметку"),
        "securityNoteRoute_wrong_password":
            MessageLookupByLibrary.simpleMessage("Неверный пароль"),
        "securityNoteRoute_wrong_pin":
            MessageLookupByLibrary.simpleMessage("Неверный PIN-код"),
        "semantics_back": MessageLookupByLibrary.simpleMessage("Назад"),
        "semantics_color_beige":
            MessageLookupByLibrary.simpleMessage("Бежевый"),
        "semantics_color_blue": MessageLookupByLibrary.simpleMessage("Синий"),
        "semantics_color_green":
            MessageLookupByLibrary.simpleMessage("Зеленый"),
        "semantics_color_none": MessageLookupByLibrary.simpleMessage("Нет"),
        "semantics_color_orange":
            MessageLookupByLibrary.simpleMessage("Оранжевый"),
        "semantics_color_pink": MessageLookupByLibrary.simpleMessage("Розовый"),
        "semantics_color_purple":
            MessageLookupByLibrary.simpleMessage("Фиолетовый"),
        "semantics_color_yellow":
            MessageLookupByLibrary.simpleMessage("Желтый"),
        "semantics_hideText":
            MessageLookupByLibrary.simpleMessage("Скрыть текст"),
        "semantics_modifyNotes_addElement":
            MessageLookupByLibrary.simpleMessage("Добавить элемент"),
        "semantics_modifyNotes_image":
            MessageLookupByLibrary.simpleMessage("Изображение заметки"),
        "semantics_modifyNotes_security":
            MessageLookupByLibrary.simpleMessage("Параметры безопасности"),
        "semantics_modifyNotes_star":
            MessageLookupByLibrary.simpleMessage("Звездная заметка"),
        "semantics_modifyNotes_unstar":
            MessageLookupByLibrary.simpleMessage("Убрать звезду"),
        "semantics_notesMainPage_addNote":
            MessageLookupByLibrary.simpleMessage("Добавить новую заметку"),
        "semantics_notesMainPage_archive": MessageLookupByLibrary.simpleMessage(
            "Архивировать выбранные заметки"),
        "semantics_notesMainPage_changeColor":
            MessageLookupByLibrary.simpleMessage("Изменить цвет заметок"),
        "semantics_notesMainPage_closeSelector":
            MessageLookupByLibrary.simpleMessage("Закрыть селектор"),
        "semantics_notesMainPage_delete":
            MessageLookupByLibrary.simpleMessage("Удалить выбранные заметки"),
        "semantics_notesMainPage_favouritesAdd":
            MessageLookupByLibrary.simpleMessage(
                "Добавить заметки в избранное"),
        "semantics_notesMainPage_favouritesRemove":
            MessageLookupByLibrary.simpleMessage(
                "Удалить заметки из избранных"),
        "semantics_notesMainPage_grid": MessageLookupByLibrary.simpleMessage(
            "Переключиться к старому виду"),
        "semantics_notesMainPage_list":
            MessageLookupByLibrary.simpleMessage("Переключиться к новому виду"),
        "semantics_notesMainPage_noteSelected": m2,
        "semantics_notesMainPage_notesSelected": m3,
        "semantics_notesMainPage_openMenu":
            MessageLookupByLibrary.simpleMessage("Открыть меню"),
        "semantics_notesMainPage_restore": MessageLookupByLibrary.simpleMessage(
            "Восстановить выбранные файлы"),
        "semantics_notesMainPage_search":
            MessageLookupByLibrary.simpleMessage("Поиск заметок"),
        "semantics_showText":
            MessageLookupByLibrary.simpleMessage("Показать текст"),
        "semantics_welcome_exit":
            MessageLookupByLibrary.simpleMessage("Выйти из настроек"),
        "semantics_welcome_next":
            MessageLookupByLibrary.simpleMessage("След. страница"),
        "semantics_welcome_pageIndicator": m4,
        "semantics_welcome_previous":
            MessageLookupByLibrary.simpleMessage("Пред. страница "),
        "settingsRoute_about":
            MessageLookupByLibrary.simpleMessage("О программе"),
        "settingsRoute_about_potatonotes":
            MessageLookupByLibrary.simpleMessage("О PotatoNotes"),
        "settingsRoute_about_potatonotes_design":
            MessageLookupByLibrary.simpleMessage(
                "Дизайн, брендинг и логотип: RshBfn"),
        "settingsRoute_about_potatonotes_development":
            MessageLookupByLibrary.simpleMessage(
                "Разработка и поддержка: HrX03"),
        "settingsRoute_about_sourceCode":
            MessageLookupByLibrary.simpleMessage("Исходный код PotatoNotes"),
        "settingsRoute_backupAndRestore":
            MessageLookupByLibrary.simpleMessage("Бэкап и восстановление"),
        "settingsRoute_backupAndRestore_backup":
            MessageLookupByLibrary.simpleMessage("Бэкап (Экспериментальный)"),
        "settingsRoute_backupAndRestore_backup_done": m5,
        "settingsRoute_backupAndRestore_regenDbEntries":
            MessageLookupByLibrary.simpleMessage("Регенерировать базу данных"),
        "settingsRoute_backupAndRestore_restore":
            MessageLookupByLibrary.simpleMessage(
                "Восстановить (Экспериментальное)"),
        "settingsRoute_backupAndRestore_restore_fail":
            MessageLookupByLibrary.simpleMessage(
                "База данных повреждена или недействительна!"),
        "settingsRoute_backupAndRestore_restore_success":
            MessageLookupByLibrary.simpleMessage("Готово!"),
        "settingsRoute_dev":
            MessageLookupByLibrary.simpleMessage("Опции для разработчиков"),
        "settingsRoute_dev_idLabels":
            MessageLookupByLibrary.simpleMessage("Показывать id записок"),
        "settingsRoute_dev_welcomeScreen": MessageLookupByLibrary.simpleMessage(
            "Показывать экран приветствия при следующем запуске"),
        "settingsRoute_gestures": MessageLookupByLibrary.simpleMessage("Жесты"),
        "settingsRoute_gestures_quickStar":
            MessageLookupByLibrary.simpleMessage("Двойное нажатие для пометки"),
        "settingsRoute_themes": MessageLookupByLibrary.simpleMessage("Темы"),
        "settingsRoute_themes_appLanguage":
            MessageLookupByLibrary.simpleMessage("Язык приложения"),
        "settingsRoute_themes_appTheme":
            MessageLookupByLibrary.simpleMessage("Тема приложения"),
        "settingsRoute_themes_customAccentColor":
            MessageLookupByLibrary.simpleMessage("Пользовательский цвет"),
        "settingsRoute_themes_followSystem":
            MessageLookupByLibrary.simpleMessage("Следовать системной теме"),
        "settingsRoute_themes_systemDarkMode":
            MessageLookupByLibrary.simpleMessage("Автоматический ночной режим"),
        "settingsRoute_themes_systemDefault":
            MessageLookupByLibrary.simpleMessage("Система"),
        "settingsRoute_themes_useCustomAccent":
            MessageLookupByLibrary.simpleMessage(
                "Использовать пользовательский акцент"),
        "settingsRoute_title":
            MessageLookupByLibrary.simpleMessage("Настройки"),
        "syncLoginRoute_emailOrUsername": MessageLookupByLibrary.simpleMessage(
            "Эл. почта или имя пользователя"),
        "syncLoginRoute_emptyField": MessageLookupByLibrary.simpleMessage(
            "Это поле не может быть пустым!"),
        "syncLoginRoute_login": MessageLookupByLibrary.simpleMessage("Вход"),
        "syncLoginRoute_noteConflictDialog_content":
            MessageLookupByLibrary.simpleMessage(
                "Сохранённые и синхронизированные заметки конфликтуют.\nЧто вы хотите сделать?"),
        "syncLoginRoute_noteConflictDialog_keep":
            MessageLookupByLibrary.simpleMessage(
                "Сохранить текущие и загрузить их"),
        "syncLoginRoute_noteConflictDialog_replace":
            MessageLookupByLibrary.simpleMessage(
                "Заменить на сохранённые в облаке"),
        "syncLoginRoute_noteConflictDialog_title":
            MessageLookupByLibrary.simpleMessage(
                "Заметки найдены в вашей учетной записи"),
        "syncLoginRoute_password":
            MessageLookupByLibrary.simpleMessage("Пароль"),
        "syncLoginRoute_register":
            MessageLookupByLibrary.simpleMessage("Регистрация"),
        "syncLoginRoute_successfulRegistration":
            MessageLookupByLibrary.simpleMessage("Успешно зарегистрировано"),
        "syncManageRoute_account":
            MessageLookupByLibrary.simpleMessage("Профиль"),
        "syncManageRoute_account_changeImage":
            MessageLookupByLibrary.simpleMessage("Изменить изображение"),
        "syncManageRoute_account_changeUsername":
            MessageLookupByLibrary.simpleMessage("Изменить имя пользователя"),
        "syncManageRoute_account_guest":
            MessageLookupByLibrary.simpleMessage("Гость"),
        "syncManageRoute_account_loggedInAs": m6,
        "syncManageRoute_account_logout":
            MessageLookupByLibrary.simpleMessage("Выход"),
        "syncManageRoute_sync":
            MessageLookupByLibrary.simpleMessage("Синхронизировать"),
        "syncManageRoute_sync_autoSyncInterval":
            MessageLookupByLibrary.simpleMessage(
                "Интервал времени автосинхронизации (в секундах)"),
        "syncManageRoute_sync_enableAutoSync":
            MessageLookupByLibrary.simpleMessage("Включить автосинхронизацию"),
        "syncRegisterRoute_confirmPassword":
            MessageLookupByLibrary.simpleMessage("Подтверждение пароля"),
        "syncRegisterRoute_confirmPassword_noMatch":
            MessageLookupByLibrary.simpleMessage("Пароли не совпадают"),
        "syncRegisterRoute_email":
            MessageLookupByLibrary.simpleMessage("Эл. почта"),
        "syncRegisterRoute_email_empty": MessageLookupByLibrary.simpleMessage(
            "Эл. почта не может быть пустой"),
        "syncRegisterRoute_email_invalidFormat":
            MessageLookupByLibrary.simpleMessage("Неверный формат эл. почты"),
        "syncRegisterRoute_password":
            MessageLookupByLibrary.simpleMessage("Пароль"),
        "syncRegisterRoute_password_empty":
            MessageLookupByLibrary.simpleMessage("Пароль не может быть пустым"),
        "syncRegisterRoute_register":
            MessageLookupByLibrary.simpleMessage("Зарегистрироваться"),
        "syncRegisterRoute_username":
            MessageLookupByLibrary.simpleMessage("Имя пользователя"),
        "syncRegisterRoute_username_empty":
            MessageLookupByLibrary.simpleMessage("Имя не может быть пустым"),
        "sync_accNotFoundError":
            MessageLookupByLibrary.simpleMessage("Профиль не найден"),
        "sync_dbConnectionError": MessageLookupByLibrary.simpleMessage(
            "Возникла проблема при подключении к базе данных, повторите попытку позже"),
        "sync_emailAlreadyExistsError": MessageLookupByLibrary.simpleMessage(
            "Введенный вами адрес эл. почты уже зарегистрирован"),
        "sync_invalidCredentialsError": MessageLookupByLibrary.simpleMessage(
            "Неверное имя пользователя/эл. почта и/или пароль"),
        "sync_malformedEmailError": MessageLookupByLibrary.simpleMessage(
            "Неправильная или отсутствующая эл. почта"),
        "sync_missingNoteIdError": MessageLookupByLibrary.simpleMessage(
            "Вы не можете создать заметку без id"),
        "sync_notFoundError":
            MessageLookupByLibrary.simpleMessage("Профиль не найден"),
        "sync_outOfBoundsError": MessageLookupByLibrary.simpleMessage(
            "Введённые данные слишком долгие или слишком короткие"),
        "sync_passOutOfBoundsError": MessageLookupByLibrary.simpleMessage(
            "Введённый пароль слишком короткий или слишком долгий"),
        "sync_userNotFoundError":
            MessageLookupByLibrary.simpleMessage("Пользователь не найден"),
        "sync_usernameAlreadyExistsError": MessageLookupByLibrary.simpleMessage(
            "Введённое имя пользователя уже зарегистрировано"),
        "sync_usernameNotFoundError": MessageLookupByLibrary.simpleMessage(
            "Это имя пользователя не зарегистрировано"),
        "sync_usernameOutOfBoundsError": MessageLookupByLibrary.simpleMessage(
            "Введенное имя пользователя слишком длинное или слишком короткое"),
        "trash": MessageLookupByLibrary.simpleMessage("Корзина"),
        "undo": MessageLookupByLibrary.simpleMessage("Отменить"),
        "userInfoRoute_avatar_change":
            MessageLookupByLibrary.simpleMessage("Изменить аватар"),
        "userInfoRoute_avatar_remove":
            MessageLookupByLibrary.simpleMessage("Удалить аватар"),
        "userInfoRoute_sortByDate":
            MessageLookupByLibrary.simpleMessage("Сортировать заметки по дате"),
        "welcomeRoute_firstPage_catchPhrase":
            MessageLookupByLibrary.simpleMessage(
                "Ваше новое любимое приложение для заметок"),
        "welcomeRoute_fourthPage_description": MessageLookupByLibrary.simpleMessage(
            "И с этим вы, наконец, сделали. Теперь вы, наконец, можете повеселиться! Ура!"),
        "welcomeRoute_fourthPage_thankyou":
            MessageLookupByLibrary.simpleMessage(
                "Спасибо за выбор PotatoNotes"),
        "welcomeRoute_fourthPage_title":
            MessageLookupByLibrary.simpleMessage("Настройка завершена"),
        "welcomeRoute_secondPage_title":
            MessageLookupByLibrary.simpleMessage("Основные настройки"),
        "welcomeRoute_thirdPage_description": MessageLookupByLibrary.simpleMessage(
            "С помощью бесплатной учетной записи PotatoSync вы можете синхронизировать свои заметки между несколькими устройствами. Это очень просто!"),
        "welcomeRoute_thirdPage_getStarted":
            MessageLookupByLibrary.simpleMessage("Начать"),
        "welcomeRoute_thirdPage_success": MessageLookupByLibrary.simpleMessage(
            "PotatoSync настроен успешно. Отлично сработано!")
      };
}
