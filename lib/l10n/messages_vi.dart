// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a vi locale. All the
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
  String get localeName => 'vi';

  static m0(method, maxLength) => "${method} không được vượt quá ${maxLength} kí tự";

  static m1(method, minLength) => "${method} không được ngắn hơn ${minLength} kí tự";

  static m2(path) => "Bản sao lưu được lưu ở: ${path}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "archive" : MessageLookupByLibrary.simpleMessage("Lưu trữ"),
    "black" : MessageLookupByLibrary.simpleMessage("Đen"),
    "cancel" : MessageLookupByLibrary.simpleMessage("Hủy"),
    "chooseAction" : MessageLookupByLibrary.simpleMessage("Chọn hành động"),
    "confirm" : MessageLookupByLibrary.simpleMessage("Xác nhận"),
    "dark" : MessageLookupByLibrary.simpleMessage("Tối"),
    "done" : MessageLookupByLibrary.simpleMessage("Xong"),
    "light" : MessageLookupByLibrary.simpleMessage("Sáng"),
    "modifyNotesRoute_color_change" : MessageLookupByLibrary.simpleMessage("Đổi màu nền ghi chú"),
    "modifyNotesRoute_color_dialogTitle" : MessageLookupByLibrary.simpleMessage("Chọn màu nền ghi chú"),
    "modifyNotesRoute_content" : MessageLookupByLibrary.simpleMessage("Nội dung"),
    "modifyNotesRoute_image" : MessageLookupByLibrary.simpleMessage("Ảnh"),
    "modifyNotesRoute_image_add" : MessageLookupByLibrary.simpleMessage("Thêm ảnh"),
    "modifyNotesRoute_image_remove" : MessageLookupByLibrary.simpleMessage("Xóa ảnh"),
    "modifyNotesRoute_image_update" : MessageLookupByLibrary.simpleMessage("Cập nhật ảnh"),
    "modifyNotesRoute_list" : MessageLookupByLibrary.simpleMessage("Danh sách"),
    "modifyNotesRoute_list_entry" : MessageLookupByLibrary.simpleMessage("Mục danh sách"),
    "modifyNotesRoute_list_selectedEntries" : MessageLookupByLibrary.simpleMessage(" mục đã hoàn thành"),
    "modifyNotesRoute_reminder" : MessageLookupByLibrary.simpleMessage("Lời nhắc"),
    "modifyNotesRoute_reminder_add" : MessageLookupByLibrary.simpleMessage("Thêm lời nhắc mới"),
    "modifyNotesRoute_reminder_date" : MessageLookupByLibrary.simpleMessage("Ngày"),
    "modifyNotesRoute_reminder_time" : MessageLookupByLibrary.simpleMessage("Thời gian"),
    "modifyNotesRoute_reminder_update" : MessageLookupByLibrary.simpleMessage("Cập nhật lời nhắc"),
    "modifyNotesRoute_security_dialog_lengthExceed" : m0,
    "modifyNotesRoute_security_dialog_lengthShort" : m1,
    "modifyNotesRoute_security_dialog_titlePassword" : MessageLookupByLibrary.simpleMessage("Đặt hoặc đổi mật khẩu"),
    "modifyNotesRoute_security_dialog_titlePin" : MessageLookupByLibrary.simpleMessage("Đặt hoặc đổi mã PIN"),
    "modifyNotesRoute_security_dialog_valid" : MessageLookupByLibrary.simpleMessage(" hợp lệ"),
    "modifyNotesRoute_security_hideContent" : MessageLookupByLibrary.simpleMessage("Ẩn nội dung ghi chú ở trang chính"),
    "modifyNotesRoute_security_password" : MessageLookupByLibrary.simpleMessage("Mật khẩu"),
    "modifyNotesRoute_security_pin" : MessageLookupByLibrary.simpleMessage("Mã PIN"),
    "modifyNotesRoute_security_protectionText" : MessageLookupByLibrary.simpleMessage("Sử dụng khóa bảo mật để ẩn"),
    "modifyNotesRoute_title" : MessageLookupByLibrary.simpleMessage("Tiêu đề"),
    "note_archive_snackbar" : MessageLookupByLibrary.simpleMessage("Đã lưu trữ ghi chú"),
    "note_delete" : MessageLookupByLibrary.simpleMessage("Xóa"),
    "note_delete_snackbar" : MessageLookupByLibrary.simpleMessage("Đã xóa ghi chú"),
    "note_edit" : MessageLookupByLibrary.simpleMessage("Sửa"),
    "note_emptryTrash" : MessageLookupByLibrary.simpleMessage("Dọn sạch thùng rác"),
    "note_export" : MessageLookupByLibrary.simpleMessage("Xuất"),
    "note_exportLocation" : MessageLookupByLibrary.simpleMessage("Ghi chú đã được xuất đến"),
    "note_lockedOptions" : MessageLookupByLibrary.simpleMessage("Ghi chú đã bị khóa, sử dụng các tùy chọn trong màn hình ghi chú"),
    "note_pinToNotifs" : MessageLookupByLibrary.simpleMessage("Ghim vào thông báo"),
    "note_removeFromArchive_snackbar" : MessageLookupByLibrary.simpleMessage("Đã xóa ghi chú khỏi mục lưu trữ"),
    "note_restore_snackbar" : MessageLookupByLibrary.simpleMessage("Đã khôi phục ghi chú"),
    "note_select" : MessageLookupByLibrary.simpleMessage("Chọn"),
    "note_share" : MessageLookupByLibrary.simpleMessage("Chia sẻ"),
    "note_star" : MessageLookupByLibrary.simpleMessage("Đánh dấu"),
    "note_unstar" : MessageLookupByLibrary.simpleMessage("Bỏ đánh dấu"),
    "notes" : MessageLookupByLibrary.simpleMessage("Ghi chú"),
    "notesMainPageRoute_emptyArchive" : MessageLookupByLibrary.simpleMessage("Bạn không có ghi chú nào trong mục lưu trữ"),
    "notesMainPageRoute_emptyTrash" : MessageLookupByLibrary.simpleMessage("Không có gì trong thùng rác"),
    "notesMainPageRoute_noNotes" : MessageLookupByLibrary.simpleMessage("Chưa có ghi chú"),
    "notesMainPageRoute_note_deleteDialog_content" : MessageLookupByLibrary.simpleMessage("Một khi đã xóa ghi chú ở đây, bạn sẽ không thể khôi phục chúng.\nBạn có chắc chắn muốn xóa không?"),
    "notesMainPageRoute_note_deleteDialog_title" : MessageLookupByLibrary.simpleMessage("Xóa ghi chú đã chọn?"),
    "notesMainPageRoute_note_emptyTrash_content" : MessageLookupByLibrary.simpleMessage("Một khi đã xóa ghi chú ở đây, bạn sẽ không thể khôi phục chúng.\nBạn có chắc chắn muốn xóa không?"),
    "notesMainPageRoute_note_emptyTrash_title" : MessageLookupByLibrary.simpleMessage("Dọn sạch thùng rác?"),
    "notesMainPageRoute_note_hiddenContent" : MessageLookupByLibrary.simpleMessage("Nội dung bị ẩn"),
    "notesMainPageRoute_note_list_selectedEntries" : MessageLookupByLibrary.simpleMessage(" mục đã chọn"),
    "notesMainPageRoute_note_remindersSet" : MessageLookupByLibrary.simpleMessage("Lời nhâc cho ghi chú đã được đặt"),
    "notesMainPageRoute_other" : MessageLookupByLibrary.simpleMessage("Ghi chú khác"),
    "notesMainPageRoute_pinnedNote" : MessageLookupByLibrary.simpleMessage("Ghi chú đã ghim"),
    "notesMainPageRoute_starred" : MessageLookupByLibrary.simpleMessage("Ghi chú được đánh dấu sao"),
    "notesMainPageRoute_writeNote" : MessageLookupByLibrary.simpleMessage("Viết ghi chú"),
    "notes_archive_snackbar" : MessageLookupByLibrary.simpleMessage("Đã lưu trữ các ghi chú"),
    "notes_delete_snackbar" : MessageLookupByLibrary.simpleMessage("Đã xóa các ghi chú"),
    "notes_removeFromArchive_snackbar" : MessageLookupByLibrary.simpleMessage("Đã xóa các ghi chú khỏi mục lưu trữ"),
    "notes_restore_snackbar" : MessageLookupByLibrary.simpleMessage("Đã khôi phục các ghi chú"),
    "remove" : MessageLookupByLibrary.simpleMessage("Xóa"),
    "reset" : MessageLookupByLibrary.simpleMessage("Thiết lập lại"),
    "save" : MessageLookupByLibrary.simpleMessage("Lưu"),
    "searchNotesRoute_filters_case" : MessageLookupByLibrary.simpleMessage("Phân biệt chữ hoa-thường"),
    "searchNotesRoute_filters_color" : MessageLookupByLibrary.simpleMessage("Lọc theo màu"),
    "searchNotesRoute_filters_date" : MessageLookupByLibrary.simpleMessage("Lọc theo ngày"),
    "searchNotesRoute_filters_title" : MessageLookupByLibrary.simpleMessage("Bộ lọc tìm kiếm"),
    "searchNotesRoute_noQuery" : MessageLookupByLibrary.simpleMessage("Nhập bất cứ gì vào đây để tìm kiếm"),
    "searchNotesRoute_nothingFound" : MessageLookupByLibrary.simpleMessage("Không tìm thấy ghi chú nào khớp với từ khóa của bạn"),
    "searchNotesRoute_searchbar" : MessageLookupByLibrary.simpleMessage("Tìm kiếm…"),
    "securityNoteRoute_request_password" : MessageLookupByLibrary.simpleMessage("Yêu cầu mật khẩu để mở ghi chú"),
    "securityNoteRoute_request_pin" : MessageLookupByLibrary.simpleMessage("Yêu cầu mã PIN để mở ghi chú"),
    "securityNoteRoute_wrong_password" : MessageLookupByLibrary.simpleMessage("Sai mật khẩu"),
    "securityNoteRoute_wrong_pin" : MessageLookupByLibrary.simpleMessage("Sai mã PIN"),
    "settingsRoute_about" : MessageLookupByLibrary.simpleMessage("Thông tin"),
    "settingsRoute_about_potatonotes" : MessageLookupByLibrary.simpleMessage("Thông tin về PotatoNotes"),
    "settingsRoute_about_potatonotes_design" : MessageLookupByLibrary.simpleMessage("Thiết kế giao diện và biểu tượng ứng dụng bởi RshBfn"),
    "settingsRoute_about_potatonotes_development" : MessageLookupByLibrary.simpleMessage("Được phát triển và duy trì bởi HrX03"),
    "settingsRoute_about_sourceCode" : MessageLookupByLibrary.simpleMessage("Mã nguồn của PotatoNotes"),
    "settingsRoute_backupAndRestore" : MessageLookupByLibrary.simpleMessage("Sao lưu & khôi phục"),
    "settingsRoute_backupAndRestore_backup" : MessageLookupByLibrary.simpleMessage("Sao lưu (Thử nghiệm)"),
    "settingsRoute_backupAndRestore_backup_done" : m2,
    "settingsRoute_backupAndRestore_regenDbEntries" : MessageLookupByLibrary.simpleMessage("Tạo mới cơ sở dữ liệu"),
    "settingsRoute_backupAndRestore_restore" : MessageLookupByLibrary.simpleMessage("Khôi phục (Thử nghiệm)"),
    "settingsRoute_backupAndRestore_restore_fail" : MessageLookupByLibrary.simpleMessage("Dữ liệu bị hỏng hoặc không hợp lệ!"),
    "settingsRoute_backupAndRestore_restore_success" : MessageLookupByLibrary.simpleMessage("Xong!"),
    "settingsRoute_dev" : MessageLookupByLibrary.simpleMessage("Tùy chọn nhà phát triển"),
    "settingsRoute_dev_idLabels" : MessageLookupByLibrary.simpleMessage("Hiển thị id của nhãn"),
    "settingsRoute_gestures" : MessageLookupByLibrary.simpleMessage("Cử chỉ"),
    "settingsRoute_gestures_quickStar" : MessageLookupByLibrary.simpleMessage("Chạm đúp vào ghi chú để đánh dấu sao"),
    "settingsRoute_themes" : MessageLookupByLibrary.simpleMessage("Giao diện"),
    "settingsRoute_themes_appTheme" : MessageLookupByLibrary.simpleMessage("Giao diện ứng dụng"),
    "settingsRoute_themes_customAccentColor" : MessageLookupByLibrary.simpleMessage("Màu tùy chỉnh"),
    "settingsRoute_themes_followSystem" : MessageLookupByLibrary.simpleMessage("Theo giao diện hệ thống"),
    "settingsRoute_themes_systemDarkMode" : MessageLookupByLibrary.simpleMessage("Giao diện tối tự động"),
    "settingsRoute_themes_useCustomAccent" : MessageLookupByLibrary.simpleMessage("Dùng màu chủ đề tùy chỉnh"),
    "settingsRoute_title" : MessageLookupByLibrary.simpleMessage("Cài đặt"),
    "trash" : MessageLookupByLibrary.simpleMessage("Thùng rác"),
    "undo" : MessageLookupByLibrary.simpleMessage("Hoàn tác"),
    "userInfoRoute_avatar_change" : MessageLookupByLibrary.simpleMessage("Đổi ảnh đại diện"),
    "userInfoRoute_avatar_remove" : MessageLookupByLibrary.simpleMessage("Xóa ảnh đại diện"),
    "userInfoRoute_sortByDate" : MessageLookupByLibrary.simpleMessage("Sắp xếp ghi chú theo ngày")
  };
}
