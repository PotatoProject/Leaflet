// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a uk locale. All the
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
  String get localeName => 'uk';

  static m0(method, maxLength) =>
      "довжина ${method} не може перевищувати ${maxLength}";

  static m1(method, minLength) =>
      "довжина ${method} не може бути меншою за ${minLength}";

  static m2(path) => "Бекап розташовано в: ${path}";

  static m3(username) => "Ви ввійшли як: ${username}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
        "archive": MessageLookupByLibrary.simpleMessage("Архів"),
        "black": MessageLookupByLibrary.simpleMessage("Чорна"),
        "cancel": MessageLookupByLibrary.simpleMessage("Скасувати"),
        "chooseAction": MessageLookupByLibrary.simpleMessage("Виберіть дію"),
        "confirm": MessageLookupByLibrary.simpleMessage("Підтвердити"),
        "dark": MessageLookupByLibrary.simpleMessage("Темна"),
        "done": MessageLookupByLibrary.simpleMessage("Готово"),
        "home": MessageLookupByLibrary.simpleMessage("Головна"),
        "light": MessageLookupByLibrary.simpleMessage("Світла"),
        "modifyNotesRoute_color_change":
            MessageLookupByLibrary.simpleMessage("Змінити колір нотатки"),
        "modifyNotesRoute_color_dialogTitle":
            MessageLookupByLibrary.simpleMessage("Колір нотаток"),
        "modifyNotesRoute_content":
            MessageLookupByLibrary.simpleMessage("Вміст"),
        "modifyNotesRoute_image":
            MessageLookupByLibrary.simpleMessage("Зображення"),
        "modifyNotesRoute_image_add":
            MessageLookupByLibrary.simpleMessage("Додати зображення"),
        "modifyNotesRoute_image_remove":
            MessageLookupByLibrary.simpleMessage("Видалити зображення"),
        "modifyNotesRoute_image_update":
            MessageLookupByLibrary.simpleMessage("Оновити зображення"),
        "modifyNotesRoute_list": MessageLookupByLibrary.simpleMessage("Список"),
        "modifyNotesRoute_list_entry":
            MessageLookupByLibrary.simpleMessage("Запис"),
        "modifyNotesRoute_list_selectedEntries":
            MessageLookupByLibrary.simpleMessage(" нотаток вибрано"),
        "modifyNotesRoute_reminder":
            MessageLookupByLibrary.simpleMessage("Нагадування"),
        "modifyNotesRoute_reminder_add":
            MessageLookupByLibrary.simpleMessage("Додати нагадування"),
        "modifyNotesRoute_reminder_date":
            MessageLookupByLibrary.simpleMessage("Дата"),
        "modifyNotesRoute_reminder_time":
            MessageLookupByLibrary.simpleMessage("Час"),
        "modifyNotesRoute_reminder_update":
            MessageLookupByLibrary.simpleMessage("Оновити нагадування"),
        "modifyNotesRoute_security_dialog_lengthExceed": m0,
        "modifyNotesRoute_security_dialog_lengthShort": m1,
        "modifyNotesRoute_security_dialog_titlePassword":
            MessageLookupByLibrary.simpleMessage(
                "Встановити чи оновити пароль"),
        "modifyNotesRoute_security_dialog_titlePin":
            MessageLookupByLibrary.simpleMessage("Встановити або оновити PIN"),
        "modifyNotesRoute_security_dialog_valid":
            MessageLookupByLibrary.simpleMessage(" дійсне"),
        "modifyNotesRoute_security_hideContent":
            MessageLookupByLibrary.simpleMessage(
                "Приховати вміст нотатки на головній"),
        "modifyNotesRoute_security_password":
            MessageLookupByLibrary.simpleMessage("Пароль"),
        "modifyNotesRoute_security_pin":
            MessageLookupByLibrary.simpleMessage("PIN-код"),
        "modifyNotesRoute_security_protectionText":
            MessageLookupByLibrary.simpleMessage("Використовувати захист"),
        "modifyNotesRoute_title":
            MessageLookupByLibrary.simpleMessage("Заголовок"),
        "note_archive_snackbar":
            MessageLookupByLibrary.simpleMessage("Нотатка переміщена в архів"),
        "note_delete": MessageLookupByLibrary.simpleMessage("Видалити"),
        "note_delete_snackbar":
            MessageLookupByLibrary.simpleMessage("Нотатку видалено"),
        "note_edit": MessageLookupByLibrary.simpleMessage("Редагувати"),
        "note_emptyTrash":
            MessageLookupByLibrary.simpleMessage("Очистити кошик"),
        "note_export": MessageLookupByLibrary.simpleMessage("Експортувати"),
        "note_exportLocation":
            MessageLookupByLibrary.simpleMessage("Нотатку експортовано в"),
        "note_lockedOptions": MessageLookupByLibrary.simpleMessage(
            "Нотатку заблоковано, використовуйте опції на екрані нотаток"),
        "note_pinToNotifs":
            MessageLookupByLibrary.simpleMessage("Закріпити до сповіщень"),
        "note_removeFromArchive_snackbar":
            MessageLookupByLibrary.simpleMessage("Нотатку видалено з архіву"),
        "note_restore_snackbar":
            MessageLookupByLibrary.simpleMessage("Нотатку відновлено"),
        "note_select": MessageLookupByLibrary.simpleMessage("Вибрати"),
        "note_share": MessageLookupByLibrary.simpleMessage("Поділитись"),
        "note_star": MessageLookupByLibrary.simpleMessage("Позначити"),
        "note_unstar": MessageLookupByLibrary.simpleMessage("Зняти позначення"),
        "notesMainPageRoute_emptyArchive": MessageLookupByLibrary.simpleMessage(
            "У вас немає нотаток в архіві"),
        "notesMainPageRoute_emptyTrash":
            MessageLookupByLibrary.simpleMessage("Корзина пуста"),
        "notesMainPageRoute_noNotes":
            MessageLookupByLibrary.simpleMessage("Нотатки ще не додані"),
        "notesMainPageRoute_note_deleteDialog_content":
            MessageLookupByLibrary.simpleMessage(
                "Після видалення нотаток звідси, ви не можете відновити їх.\nВи дійсно бажаєте продовжити?"),
        "notesMainPageRoute_note_deleteDialog_title":
            MessageLookupByLibrary.simpleMessage("Видалити вибрані нотатки?"),
        "notesMainPageRoute_note_emptyTrash_content":
            MessageLookupByLibrary.simpleMessage(
                "Після видалення нотаток звідси, ви не можете відновити їх.\nВи дійсно бажаєте продовжити?"),
        "notesMainPageRoute_note_emptyTrash_title":
            MessageLookupByLibrary.simpleMessage("Очистити корзину?"),
        "notesMainPageRoute_note_hiddenContent":
            MessageLookupByLibrary.simpleMessage("Вміст сховано"),
        "notesMainPageRoute_note_list_selectedEntries":
            MessageLookupByLibrary.simpleMessage(" нотаток выбрано"),
        "notesMainPageRoute_note_remindersSet":
            MessageLookupByLibrary.simpleMessage(
                "Нагадування встановлено для нотатки"),
        "notesMainPageRoute_other":
            MessageLookupByLibrary.simpleMessage("Інші нотатки"),
        "notesMainPageRoute_pinnedNote":
            MessageLookupByLibrary.simpleMessage("Закріплена нотатка"),
        "notesMainPageRoute_starred":
            MessageLookupByLibrary.simpleMessage("Обрані нотатки"),
        "notesMainPageRoute_writeNote":
            MessageLookupByLibrary.simpleMessage("Написати нотатку"),
        "notes_archive_snackbar":
            MessageLookupByLibrary.simpleMessage("Нотатки переміщені в архів"),
        "notes_delete_snackbar":
            MessageLookupByLibrary.simpleMessage("Нотатки видалено"),
        "notes_removeFromArchive_snackbar":
            MessageLookupByLibrary.simpleMessage("Нотатки видалено з архіву"),
        "notes_restore_snackbar":
            MessageLookupByLibrary.simpleMessage("Нотатки відновлено"),
        "remove": MessageLookupByLibrary.simpleMessage("Видалити"),
        "reset": MessageLookupByLibrary.simpleMessage("Скинути"),
        "save": MessageLookupByLibrary.simpleMessage("Зберегти"),
        "searchNotesRoute_filters_case":
            MessageLookupByLibrary.simpleMessage("З урахуванням регістру"),
        "searchNotesRoute_filters_color":
            MessageLookupByLibrary.simpleMessage("Колірний фільтр"),
        "searchNotesRoute_filters_date":
            MessageLookupByLibrary.simpleMessage("По даті"),
        "searchNotesRoute_filters_title":
            MessageLookupByLibrary.simpleMessage("Фільтри пошуку"),
        "searchNotesRoute_noQuery": MessageLookupByLibrary.simpleMessage(
            "Введіть що-небудь, щоб почати пошук"),
        "searchNotesRoute_nothingFound": MessageLookupByLibrary.simpleMessage(
            "Не знайдено нотаток, що відповідають вашим умовам пошуку"),
        "searchNotesRoute_searchbar":
            MessageLookupByLibrary.simpleMessage("Пошук..."),
        "securityNoteRoute_request_password":
            MessageLookupByLibrary.simpleMessage(
                "Треба пароль, щоб відкрити нотанку"),
        "securityNoteRoute_request_pin": MessageLookupByLibrary.simpleMessage(
            "Треба PIN, щоб відкрити нотанку"),
        "securityNoteRoute_wrong_password":
            MessageLookupByLibrary.simpleMessage("Неправильний пароль"),
        "securityNoteRoute_wrong_pin":
            MessageLookupByLibrary.simpleMessage("Неправильний PIN-код"),
        "settingsRoute_about":
            MessageLookupByLibrary.simpleMessage("Про програму"),
        "settingsRoute_about_potatonotes":
            MessageLookupByLibrary.simpleMessage("Про PotatoNotes"),
        "settingsRoute_about_potatonotes_design":
            MessageLookupByLibrary.simpleMessage(
                "Дизайн, брендинг та логотип: RshBfn"),
        "settingsRoute_about_potatonotes_development":
            MessageLookupByLibrary.simpleMessage(
                "Розробка та підтримка: Hrx03"),
        "settingsRoute_about_sourceCode":
            MessageLookupByLibrary.simpleMessage("Вихідний код PotatoNotes"),
        "settingsRoute_backupAndRestore":
            MessageLookupByLibrary.simpleMessage("Бекап та відновлення"),
        "settingsRoute_backupAndRestore_backup":
            MessageLookupByLibrary.simpleMessage("Бекап (Експерементальний)"),
        "settingsRoute_backupAndRestore_backup_done": m2,
        "settingsRoute_backupAndRestore_regenDbEntries":
            MessageLookupByLibrary.simpleMessage("Регенерувати базу данних"),
        "settingsRoute_backupAndRestore_restore":
            MessageLookupByLibrary.simpleMessage(
                "Відновити (Експерементально)"),
        "settingsRoute_backupAndRestore_restore_fail":
            MessageLookupByLibrary.simpleMessage(
                "База данних пошкоджена або недійсна!"),
        "settingsRoute_backupAndRestore_restore_success":
            MessageLookupByLibrary.simpleMessage("Готово!"),
        "settingsRoute_dev":
            MessageLookupByLibrary.simpleMessage("Параметри для розробників"),
        "settingsRoute_dev_idLabels":
            MessageLookupByLibrary.simpleMessage("Показувати id нотанок"),
        "settingsRoute_gestures": MessageLookupByLibrary.simpleMessage("Жести"),
        "settingsRoute_gestures_quickStar":
            MessageLookupByLibrary.simpleMessage(
                "Подвійне натискання для позначення"),
        "settingsRoute_themes": MessageLookupByLibrary.simpleMessage("Теми"),
        "settingsRoute_themes_appTheme":
            MessageLookupByLibrary.simpleMessage("Тема програми"),
        "settingsRoute_themes_customAccentColor":
            MessageLookupByLibrary.simpleMessage("Користувацький колір"),
        "settingsRoute_themes_followSystem":
            MessageLookupByLibrary.simpleMessage(
                "Використовувати системну тему"),
        "settingsRoute_themes_systemDarkMode":
            MessageLookupByLibrary.simpleMessage("Автоматичний нічний режим"),
        "settingsRoute_themes_useCustomAccent":
            MessageLookupByLibrary.simpleMessage(
                "Використовувати свій колір акценту"),
        "settingsRoute_title":
            MessageLookupByLibrary.simpleMessage("Налаштування"),
        "syncLoginRoute_emailOrUsername": MessageLookupByLibrary.simpleMessage(
            "Ел. пошта або ім\'я користувача"),
        "syncLoginRoute_emptyField": MessageLookupByLibrary.simpleMessage(
            "Це поле не може бути порожнім!"),
        "syncLoginRoute_login": MessageLookupByLibrary.simpleMessage("Вхід"),
        "syncLoginRoute_noteConflictDialog_content":
            MessageLookupByLibrary.simpleMessage(
                "Збережені та синхронізовані нотатки конфліктують.\nЩо ви хочете зробити?"),
        "syncLoginRoute_noteConflictDialog_keep":
            MessageLookupByLibrary.simpleMessage(
                "Зберегти поточні та загрузити їх"),
        "syncLoginRoute_noteConflictDialog_replace":
            MessageLookupByLibrary.simpleMessage(
                "Замінити на збережені у хмарі"),
        "syncLoginRoute_noteConflictDialog_title":
            MessageLookupByLibrary.simpleMessage(
                "Нотатки знайдені в вашому профілі"),
        "syncLoginRoute_password":
            MessageLookupByLibrary.simpleMessage("Пароль"),
        "syncLoginRoute_register":
            MessageLookupByLibrary.simpleMessage("Реєстрація"),
        "syncLoginRoute_successfulRegistration":
            MessageLookupByLibrary.simpleMessage("Успішно зареєстровано"),
        "syncManageRoute_account":
            MessageLookupByLibrary.simpleMessage("Профіль"),
        "syncManageRoute_account_changeImage":
            MessageLookupByLibrary.simpleMessage("Змінити зображення"),
        "syncManageRoute_account_changeUsername":
            MessageLookupByLibrary.simpleMessage("Змінити ім\'я користувача"),
        "syncManageRoute_account_guest":
            MessageLookupByLibrary.simpleMessage("Гість"),
        "syncManageRoute_account_loggedInAs": m3,
        "syncManageRoute_account_logout":
            MessageLookupByLibrary.simpleMessage("Вихід"),
        "syncManageRoute_sync":
            MessageLookupByLibrary.simpleMessage("Синхронізувати"),
        "syncManageRoute_sync_autoSyncInterval":
            MessageLookupByLibrary.simpleMessage(
                "Інтервал часу автосинхронізації (в секундах)"),
        "syncManageRoute_sync_enableAutoSync":
            MessageLookupByLibrary.simpleMessage("Увімкнути автосинхронізацію"),
        "syncRegisterRoute_confirmPassword":
            MessageLookupByLibrary.simpleMessage("Підтвердження пароля"),
        "syncRegisterRoute_confirmPassword_noMatch":
            MessageLookupByLibrary.simpleMessage("Паролі не збігаються"),
        "syncRegisterRoute_email":
            MessageLookupByLibrary.simpleMessage("Ел. пошта"),
        "syncRegisterRoute_email_empty": MessageLookupByLibrary.simpleMessage(
            "Ел. пошта не може бути порожньою"),
        "syncRegisterRoute_email_invalidFormat":
            MessageLookupByLibrary.simpleMessage("Невірний формат ел. пошти"),
        "syncRegisterRoute_password":
            MessageLookupByLibrary.simpleMessage("Пароль"),
        "syncRegisterRoute_password_empty":
            MessageLookupByLibrary.simpleMessage(
                "Пароль не може бути порожнім"),
        "syncRegisterRoute_register":
            MessageLookupByLibrary.simpleMessage("Зареєструватися"),
        "syncRegisterRoute_username":
            MessageLookupByLibrary.simpleMessage("Ім\'я користувача"),
        "syncRegisterRoute_username_empty":
            MessageLookupByLibrary.simpleMessage("Ім\'я не може бути порожнім"),
        "sync_accNotFoundError":
            MessageLookupByLibrary.simpleMessage("Профіль не знайдено"),
        "sync_dbConnectionError": MessageLookupByLibrary.simpleMessage(
            "Виникла проблема при з\'єднанні з базою даних, спробуйте пізніше"),
        "sync_emailAlreadyExistsError": MessageLookupByLibrary.simpleMessage(
            "Введена ел. пошта вже зареєстрована"),
        "sync_invalidCredentialsError": MessageLookupByLibrary.simpleMessage(
            "Неправильне ім\'я користувача/ел. пошта або пароль"),
        "sync_malformedEmailError": MessageLookupByLibrary.simpleMessage(
            "Неправильна чи відсутня ел. пошта"),
        "sync_missingNoteIdError": MessageLookupByLibrary.simpleMessage(
            "Неможливо створити нотатку без id"),
        "sync_notFoundError":
            MessageLookupByLibrary.simpleMessage("Профіль не знайдено"),
        "sync_outOfBoundsError": MessageLookupByLibrary.simpleMessage(
            "Введені дані занадто довгі або занадто короткі"),
        "sync_passOutOfBoundsError": MessageLookupByLibrary.simpleMessage(
            "Введений пароль занадто довгий або занадто короткий"),
        "sync_userNotFoundError":
            MessageLookupByLibrary.simpleMessage("Користувача не зайдено"),
        "sync_usernameAlreadyExistsError": MessageLookupByLibrary.simpleMessage(
            "Введене ім\'я користувача вже зареєстровано"),
        "sync_usernameNotFoundError": MessageLookupByLibrary.simpleMessage(
            "Це ім\'я користувача не зареєстровано"),
        "sync_usernameOutOfBoundsError": MessageLookupByLibrary.simpleMessage(
            "Введене ім\'я користувача занадто довге або занадто коротке"),
        "trash": MessageLookupByLibrary.simpleMessage("Корзина"),
        "undo": MessageLookupByLibrary.simpleMessage("Відмінити"),
        "userInfoRoute_avatar_change":
            MessageLookupByLibrary.simpleMessage("Змінити аватар"),
        "userInfoRoute_avatar_remove":
            MessageLookupByLibrary.simpleMessage("Видалити аватар"),
        "userInfoRoute_sortByDate":
            MessageLookupByLibrary.simpleMessage("Сортувати нотатки за датою"),
        "welcomeRoute_firstPage_catchPhrase":
            MessageLookupByLibrary.simpleMessage(
                "Ваша улюблена програма для заміток"),
        "welcomeRoute_fourthPage_description": MessageLookupByLibrary.simpleMessage(
            "І разом з цим ви нарешті закінчили. Тепер ви, нарешті, можете розважитися! Ура!"),
        "welcomeRoute_fourthPage_thankyou":
            MessageLookupByLibrary.simpleMessage(
                "Дякуємо, що обрали PotatoNotes"),
        "welcomeRoute_fourthPage_title":
            MessageLookupByLibrary.simpleMessage("Налаштування завершено"),
        "welcomeRoute_secondPage_title":
            MessageLookupByLibrary.simpleMessage("Базове налаштування"),
        "welcomeRoute_thirdPage_description": MessageLookupByLibrary.simpleMessage(
            "З безкоштовним аккаунтом PotatoSync, ви можете синхронізувати замітки між декількома пристроями. І отримати його дуже просто!"),
        "welcomeRoute_thirdPage_getStarted":
            MessageLookupByLibrary.simpleMessage("Розпочати"),
        "welcomeRoute_thirdPage_success": MessageLookupByLibrary.simpleMessage(
            "PotatoSync успішно налаштований. Чудово!")
      };
}
