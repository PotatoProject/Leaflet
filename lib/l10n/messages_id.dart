// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a id locale. All the
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
  String get localeName => 'id';

  static m0(method, maxLength) =>
      "${method} panjangnya tidak bisa melebihi ${maxLength}";

  static m1(method, minLength) =>
      "${method} panjangnya tidak bisa kurang dari ${minLength}";

  static m2(path) => "Cadangan terletak di: ${path}";

  static m3(username) => "Masuk sebagai: ${username}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
        "archive": MessageLookupByLibrary.simpleMessage("Arsip"),
        "black": MessageLookupByLibrary.simpleMessage("Hitam"),
        "cancel": MessageLookupByLibrary.simpleMessage("Batalkan"),
        "chooseAction": MessageLookupByLibrary.simpleMessage("Pilih tindakan"),
        "confirm": MessageLookupByLibrary.simpleMessage("Konfirmasi"),
        "dark": MessageLookupByLibrary.simpleMessage("Gelap"),
        "done": MessageLookupByLibrary.simpleMessage("Selesai"),
        "light": MessageLookupByLibrary.simpleMessage("Terang"),
        "modifyNotesRoute_color_change":
            MessageLookupByLibrary.simpleMessage("Ubah warna catatan"),
        "modifyNotesRoute_color_dialogTitle":
            MessageLookupByLibrary.simpleMessage("Pemilih warna catatan"),
        "modifyNotesRoute_content": MessageLookupByLibrary.simpleMessage("Isi"),
        "modifyNotesRoute_image":
            MessageLookupByLibrary.simpleMessage("Gambar"),
        "modifyNotesRoute_image_add":
            MessageLookupByLibrary.simpleMessage("Tambahkan gambar"),
        "modifyNotesRoute_image_remove":
            MessageLookupByLibrary.simpleMessage("Hapus gambar"),
        "modifyNotesRoute_image_update":
            MessageLookupByLibrary.simpleMessage("Perbarui gambar"),
        "modifyNotesRoute_list": MessageLookupByLibrary.simpleMessage("Daftar"),
        "modifyNotesRoute_list_entry":
            MessageLookupByLibrary.simpleMessage("Entri"),
        "modifyNotesRoute_list_selectedEntries":
            MessageLookupByLibrary.simpleMessage(" entri yang dipilih"),
        "modifyNotesRoute_reminder":
            MessageLookupByLibrary.simpleMessage("Pengingat"),
        "modifyNotesRoute_reminder_add":
            MessageLookupByLibrary.simpleMessage("Tambahkan pengingat baru"),
        "modifyNotesRoute_reminder_date":
            MessageLookupByLibrary.simpleMessage("Tanggal"),
        "modifyNotesRoute_reminder_time":
            MessageLookupByLibrary.simpleMessage("Waktu"),
        "modifyNotesRoute_reminder_update":
            MessageLookupByLibrary.simpleMessage("Perbarui pengingat"),
        "modifyNotesRoute_security_dialog_lengthExceed": m0,
        "modifyNotesRoute_security_dialog_lengthShort": m1,
        "modifyNotesRoute_security_dialog_titlePassword":
            MessageLookupByLibrary.simpleMessage(
                "Setel atau perbarui kata sandi"),
        "modifyNotesRoute_security_dialog_titlePin":
            MessageLookupByLibrary.simpleMessage("Atur atau Perbarui PIN"),
        "modifyNotesRoute_security_dialog_valid":
            MessageLookupByLibrary.simpleMessage(" valid"),
        "modifyNotesRoute_security_hideContent":
            MessageLookupByLibrary.simpleMessage(
                "Sembunyikan isi catatan di halaman utama"),
        "modifyNotesRoute_security_password":
            MessageLookupByLibrary.simpleMessage("Kata Sandi"),
        "modifyNotesRoute_security_pin":
            MessageLookupByLibrary.simpleMessage("PIN"),
        "modifyNotesRoute_security_protectionText":
            MessageLookupByLibrary.simpleMessage(
                "Gunakan perlindungan untuk menyembunyikan"),
        "modifyNotesRoute_title": MessageLookupByLibrary.simpleMessage("Judul"),
        "note_archive_snackbar":
            MessageLookupByLibrary.simpleMessage("Catatan telah diarsipkan"),
        "note_delete": MessageLookupByLibrary.simpleMessage("Hapus"),
        "note_delete_snackbar":
            MessageLookupByLibrary.simpleMessage("Catatan dihapus"),
        "note_edit": MessageLookupByLibrary.simpleMessage("Ubah"),
        "note_emptyTrash":
            MessageLookupByLibrary.simpleMessage("Kotak sampah kosong"),
        "note_export": MessageLookupByLibrary.simpleMessage("Ekspor"),
        "note_exportLocation":
            MessageLookupByLibrary.simpleMessage("Catatan diekspor pada"),
        "note_lockedOptions": MessageLookupByLibrary.simpleMessage(
            "Catatan terkunci, gunakan opsi pada layar catatan"),
        "note_pinToNotifs":
            MessageLookupByLibrary.simpleMessage("Sematkan ke notifikasi"),
        "note_removeFromArchive_snackbar": MessageLookupByLibrary.simpleMessage(
            "Catatan dihilangkan dari arsip"),
        "note_restore_snackbar":
            MessageLookupByLibrary.simpleMessage("Catatan dipulihkan"),
        "note_select": MessageLookupByLibrary.simpleMessage("Pilih"),
        "note_share": MessageLookupByLibrary.simpleMessage("Bagikan"),
        "note_star": MessageLookupByLibrary.simpleMessage("Bintangi"),
        "note_unstar": MessageLookupByLibrary.simpleMessage("Batal Bintangi"),
        "notes": MessageLookupByLibrary.simpleMessage("Catatan"),
        "notesMainPageRoute_emptyArchive": MessageLookupByLibrary.simpleMessage(
            "Anda tidak memiliki cataran dalam arsip"),
        "notesMainPageRoute_emptyTrash":
            MessageLookupByLibrary.simpleMessage("Kotak sampah anda kosong"),
        "notesMainPageRoute_noNotes": MessageLookupByLibrary.simpleMessage(
            "Belum ada catatan yang ditambahkan"),
        "notesMainPageRoute_note_deleteDialog_content":
            MessageLookupByLibrary.simpleMessage(
                "Setelah catatan terhapus dari sini, anda tak dapat memulihkannya.\nApakah anda yakin untuk melanjutkan?"),
        "notesMainPageRoute_note_deleteDialog_title":
            MessageLookupByLibrary.simpleMessage("Hapus catatan terpilih?"),
        "notesMainPageRoute_note_emptyTrash_content":
            MessageLookupByLibrary.simpleMessage(
                "Setelah catatan terhapus dari sini, anda tak dapat memulihkannya.\nApakah anda yakin untuk melanjutkan?"),
        "notesMainPageRoute_note_emptyTrash_title":
            MessageLookupByLibrary.simpleMessage("Bersihkan kotak sampah?"),
        "notesMainPageRoute_note_hiddenContent":
            MessageLookupByLibrary.simpleMessage("Konten disembunyikan"),
        "notesMainPageRoute_note_list_selectedEntries":
            MessageLookupByLibrary.simpleMessage(" entri terpilih"),
        "notesMainPageRoute_note_remindersSet":
            MessageLookupByLibrary.simpleMessage(
                "Pengingat diatur untuk catatan"),
        "notesMainPageRoute_other":
            MessageLookupByLibrary.simpleMessage("Catatan lain"),
        "notesMainPageRoute_pinnedNote":
            MessageLookupByLibrary.simpleMessage("Catatan tersemat"),
        "notesMainPageRoute_starred":
            MessageLookupByLibrary.simpleMessage("Catatan berbintang"),
        "notesMainPageRoute_writeNote":
            MessageLookupByLibrary.simpleMessage("Tulis sebuah catatan"),
        "notes_archive_snackbar":
            MessageLookupByLibrary.simpleMessage("Catatan telah diarsipkan"),
        "notes_delete_snackbar":
            MessageLookupByLibrary.simpleMessage("Catatan dihapus"),
        "notes_removeFromArchive_snackbar":
            MessageLookupByLibrary.simpleMessage(
                "Catatan dihilangkan dari arsip"),
        "notes_restore_snackbar":
            MessageLookupByLibrary.simpleMessage("Catatan dipulihkan"),
        "remove": MessageLookupByLibrary.simpleMessage("Hapus"),
        "reset": MessageLookupByLibrary.simpleMessage("Setel ulang"),
        "save": MessageLookupByLibrary.simpleMessage("Simpan"),
        "searchNotesRoute_filters_case":
            MessageLookupByLibrary.simpleMessage("Sensitivitas Huruf"),
        "searchNotesRoute_filters_color":
            MessageLookupByLibrary.simpleMessage("Filter Warna"),
        "searchNotesRoute_filters_date":
            MessageLookupByLibrary.simpleMessage("Filter tanggal"),
        "searchNotesRoute_filters_title":
            MessageLookupByLibrary.simpleMessage("Filter Pencarian"),
        "searchNotesRoute_noQuery": MessageLookupByLibrary.simpleMessage(
            "Masukkan sesuatu untuk memulai pencarian"),
        "searchNotesRoute_nothingFound": MessageLookupByLibrary.simpleMessage(
            "Tidak ada catatan yang sesuai dengan pencarian anda"),
        "searchNotesRoute_searchbar":
            MessageLookupByLibrary.simpleMessage("Cari..."),
        "securityNoteRoute_request_password":
            MessageLookupByLibrary.simpleMessage(
                "Kata sandi diperlukan untuk membuka catatan"),
        "securityNoteRoute_request_pin": MessageLookupByLibrary.simpleMessage(
            "PIN diperlukan untuk membuka catatan"),
        "securityNoteRoute_wrong_password":
            MessageLookupByLibrary.simpleMessage("Kata sandi salah"),
        "securityNoteRoute_wrong_pin":
            MessageLookupByLibrary.simpleMessage("PIN salah"),
        "settingsRoute_about": MessageLookupByLibrary.simpleMessage("Tentang"),
        "settingsRoute_about_potatonotes":
            MessageLookupByLibrary.simpleMessage("Tentang PotatoNotes"),
        "settingsRoute_about_potatonotes_design":
            MessageLookupByLibrary.simpleMessage(
                "Desain, penamaan aplikasi dan logo aplikasi oleh RshBfn"),
        "settingsRoute_about_potatonotes_development":
            MessageLookupByLibrary.simpleMessage(
                "Dikembangkan dan dikelola oleh HrX03"),
        "settingsRoute_about_sourceCode":
            MessageLookupByLibrary.simpleMessage("Kode sumber PotatoNotes"),
        "settingsRoute_backupAndRestore":
            MessageLookupByLibrary.simpleMessage("Cadangkan & Pulihkan"),
        "settingsRoute_backupAndRestore_backup":
            MessageLookupByLibrary.simpleMessage("Cadangkan (Eksperimental)"),
        "settingsRoute_backupAndRestore_backup_done": m2,
        "settingsRoute_backupAndRestore_regenDbEntries":
            MessageLookupByLibrary.simpleMessage("Memperbarui entri database"),
        "settingsRoute_backupAndRestore_restore":
            MessageLookupByLibrary.simpleMessage("Pulihkan (Eksperimental)"),
        "settingsRoute_backupAndRestore_restore_fail":
            MessageLookupByLibrary.simpleMessage("DB rusak atau tidak valid!"),
        "settingsRoute_backupAndRestore_restore_success":
            MessageLookupByLibrary.simpleMessage("Selesai!"),
        "settingsRoute_dev":
            MessageLookupByLibrary.simpleMessage("Opsi Pengembang"),
        "settingsRoute_dev_idLabels":
            MessageLookupByLibrary.simpleMessage("Tampilkan label info"),
        "settingsRoute_gestures":
            MessageLookupByLibrary.simpleMessage("Gestur"),
        "settingsRoute_gestures_quickStar":
            MessageLookupByLibrary.simpleMessage(
                "Ketuk dua kali catatan untuk memberi bintang"),
        "settingsRoute_themes": MessageLookupByLibrary.simpleMessage("Tema"),
        "settingsRoute_themes_appTheme":
            MessageLookupByLibrary.simpleMessage("Tema aplikasi"),
        "settingsRoute_themes_customAccentColor":
            MessageLookupByLibrary.simpleMessage("Warna kustom"),
        "settingsRoute_themes_followSystem":
            MessageLookupByLibrary.simpleMessage("Ikuti tema sistem"),
        "settingsRoute_themes_systemDarkMode":
            MessageLookupByLibrary.simpleMessage("Mode tema gelap otomatis"),
        "settingsRoute_themes_useCustomAccent":
            MessageLookupByLibrary.simpleMessage("Gunakan warna label kustom"),
        "settingsRoute_title":
            MessageLookupByLibrary.simpleMessage("Pengaturan"),
        "syncLoginRoute_emailOrUsername":
            MessageLookupByLibrary.simpleMessage("Email atau nama pengguna"),
        "syncLoginRoute_emptyField": MessageLookupByLibrary.simpleMessage(
            "Kolom ini tidak boleh kosong!"),
        "syncLoginRoute_login": MessageLookupByLibrary.simpleMessage("Masuk"),
        "syncLoginRoute_noteConflictDialog_content":
            MessageLookupByLibrary.simpleMessage(
                "Catatan tersimpan dan catatan tersinkron mengalami masalah.\nApa yang akan anda lakukan?"),
        "syncLoginRoute_noteConflictDialog_keep":
            MessageLookupByLibrary.simpleMessage(
                "Simpan yang terkini dan unggah"),
        "syncLoginRoute_noteConflictDialog_replace":
            MessageLookupByLibrary.simpleMessage(
                "Pemulihan tersimpan dengan cloud"),
        "syncLoginRoute_noteConflictDialog_title":
            MessageLookupByLibrary.simpleMessage(
                "Catatan ditemukan pada akun anda"),
        "syncLoginRoute_password":
            MessageLookupByLibrary.simpleMessage("Kata sandi"),
        "syncLoginRoute_register":
            MessageLookupByLibrary.simpleMessage("Registrasi"),
        "syncLoginRoute_successfulRegistration":
            MessageLookupByLibrary.simpleMessage("Registrasi sukses"),
        "syncManageRoute_account": MessageLookupByLibrary.simpleMessage("Akun"),
        "syncManageRoute_account_changeImage":
            MessageLookupByLibrary.simpleMessage("Ubah gambar"),
        "syncManageRoute_account_changeUsername":
            MessageLookupByLibrary.simpleMessage("Ganti nama pengguna"),
        "syncManageRoute_account_guest":
            MessageLookupByLibrary.simpleMessage("Guest"),
        "syncManageRoute_account_loggedInAs": m3,
        "syncManageRoute_account_logout":
            MessageLookupByLibrary.simpleMessage("Keluar"),
        "syncManageRoute_sync": MessageLookupByLibrary.simpleMessage("Sinkron"),
        "syncManageRoute_sync_autoSyncInterval":
            MessageLookupByLibrary.simpleMessage(
                "Selang waktu sinkronisasi otomatis (detik)"),
        "syncManageRoute_sync_enableAutoSync":
            MessageLookupByLibrary.simpleMessage(
                "Aktifkan sinkronisasi otomatis"),
        "syncRegisterRoute_confirmPassword":
            MessageLookupByLibrary.simpleMessage("Konfirmasi sandi"),
        "syncRegisterRoute_confirmPassword_noMatch":
            MessageLookupByLibrary.simpleMessage("Kata sandi tidak cocok"),
        "syncRegisterRoute_email":
            MessageLookupByLibrary.simpleMessage("Email"),
        "syncRegisterRoute_email_empty": MessageLookupByLibrary.simpleMessage(
            "Alamat email tidak boleh kosong"),
        "syncRegisterRoute_email_invalidFormat":
            MessageLookupByLibrary.simpleMessage("Format email tidak benar"),
        "syncRegisterRoute_password":
            MessageLookupByLibrary.simpleMessage("Kata sandi"),
        "syncRegisterRoute_password_empty":
            MessageLookupByLibrary.simpleMessage(
                "Kata sandi tidak boleh kosong"),
        "syncRegisterRoute_register":
            MessageLookupByLibrary.simpleMessage("Registrasi"),
        "syncRegisterRoute_username":
            MessageLookupByLibrary.simpleMessage("Nama pengguna"),
        "syncRegisterRoute_username_empty":
            MessageLookupByLibrary.simpleMessage(
                "Nama pengguna tidak boleh kosong"),
        "sync_accNotFoundError":
            MessageLookupByLibrary.simpleMessage("Akun tidak ditemukan"),
        "sync_dbConnectionError": MessageLookupByLibrary.simpleMessage(
            "Ada kendala saat menghubungkan ke database, coba sesaat lagi"),
        "sync_emailAlreadyExistsError": MessageLookupByLibrary.simpleMessage(
            "Email yang anda masukkan telah digunakan"),
        "sync_invalidCredentialsError": MessageLookupByLibrary.simpleMessage(
            "Nama pengguna/email dan kata sandi salah"),
        "sync_malformedEmailError":
            MessageLookupByLibrary.simpleMessage("Email rusak atau hilang"),
        "sync_missingNoteIdError": MessageLookupByLibrary.simpleMessage(
            "Anda tidak dapat membuat catatan tanpa id"),
        "sync_notFoundError":
            MessageLookupByLibrary.simpleMessage("Akun tidak ditemukan"),
        "sync_outOfBoundsError": MessageLookupByLibrary.simpleMessage(
            "Keyword yang anda masukkan terlalu panjang atau terlalu pendek"),
        "sync_passOutOfBoundsError": MessageLookupByLibrary.simpleMessage(
            "Kata sandi yang anda masukkan terlalu panjang atau terlalu pendek"),
        "sync_userNotFoundError":
            MessageLookupByLibrary.simpleMessage("Pengguna tidak ditemukan"),
        "sync_usernameAlreadyExistsError": MessageLookupByLibrary.simpleMessage(
            "Nama pengguna yang anda masukkan telah digunakan"),
        "sync_usernameNotFoundError": MessageLookupByLibrary.simpleMessage(
            "Nama pengguna ini tidak terdaftar"),
        "sync_usernameOutOfBoundsError": MessageLookupByLibrary.simpleMessage(
            "Nama pengguna yang anda masukkan terlalu panjang atau terlalu pendek"),
        "trash": MessageLookupByLibrary.simpleMessage("Sampah"),
        "undo": MessageLookupByLibrary.simpleMessage("Kembalikan"),
        "userInfoRoute_avatar_change":
            MessageLookupByLibrary.simpleMessage("Ubah avatar"),
        "userInfoRoute_avatar_remove":
            MessageLookupByLibrary.simpleMessage("Hapus avatar"),
        "userInfoRoute_sortByDate": MessageLookupByLibrary.simpleMessage(
            "Urutkan catatan berdasarkan tanggal")
      };
}
