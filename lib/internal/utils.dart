import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as p;
import 'package:potato_notes/data/dao/note_helper.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/data/model/list_content.dart';
import 'package:potato_notes/data/model/saved_image.dart';
import 'package:potato_notes/internal/backup_restore.dart';
import 'package:potato_notes/internal/device_info.dart';
import 'package:potato_notes/internal/notification_payload.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/locales/locale_strings.g.dart';
import 'package:potato_notes/internal/sync/image/blake/stub.dart';
import 'package:potato_notes/routes/about_page.dart';
import 'package:potato_notes/routes/base_page.dart';
import 'package:potato_notes/routes/note_list_page.dart';
import 'package:potato_notes/routes/note_page.dart';
import 'package:potato_notes/widget/backup_password_prompt.dart';
import 'package:potato_notes/widget/bottom_sheet_base.dart';
import 'package:potato_notes/widget/dismissible_route.dart';
import 'package:potato_notes/widget/note_color_selector.dart';
import 'package:potato_notes/widget/pass_challenge.dart';
import 'package:potato_notes/widget/selection_bar.dart';
import 'package:recase/recase.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqflite/utils/utils.dart' as utils;
import 'package:universal_platform/universal_platform.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

const double kCardBorderRadius = 4;
const EdgeInsets kCardPadding = EdgeInsets.all(4);

class Utils {
  Utils._();

  static final OverlayEntry _loadingOverlayEntry = OverlayEntry(
    builder: (context) => const SizedBox.expand(
      child: ColoredBox(
        color: Colors.black54,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    ),
  );

  static void deleteNoteSafely(Note note) {
    imageHelper.handleNoteDeletion(note);
    helper.deleteNote(note);
  }

  static void handleNotePagePop(Note note) {
    //ImageService.handleDeletes();
    //helper.listNotes(ReturnMode.LOCAL).then((notes) => {
    //      SyncRoutine.syncNote(notes.firstWhere((local) => local.id == note.id))
    //    });
  }

  static Future<bool?> showPassChallengeSheet(
    BuildContext context, {
    String? description,
  }) async {
    return showNotesModalBottomSheet<bool>(
      context: context,
      builder: (context) => PassChallenge(
        onChallengeSuccess: () => context.pop(true),
        description: description,
      ),
    );
  }

  static Future<bool> showBiometricPrompt() async {
    try {
      return await LocalAuthentication().authenticate(
        localizedReason: "",
        biometricOnly: true,
        stickyAuth: true,
        androidAuthStrings: AndroidAuthMessages(
          signInTitle: LocaleStrings.common.biometricsPrompt,
          cancelButton: LocaleStrings.common.cancel,
        ),
      );
    } catch (e) {
      return false;
    }
  }

  static Future<bool> showNoteLockDialog({
    required BuildContext context,
    required bool showLock,
    bool showBiometrics = false,
    String? description,
  }) async {
    if (showLock && prefs.masterPass != '') {
      bool status;

      final bool bioAuth = showBiometrics && !DeviceInfo.isDesktopOrWeb
          ? await Utils.showBiometricPrompt()
          : false;

      if (bioAuth) {
        status = bioAuth;
      } else {
        status = await Utils.showPassChallengeSheet(
              context,
              description: description,
            ) ??
            false;
      }

      return status;
    }

    return true;
  }

  static Future<String?> showBackupPasswordPrompt({
    required BuildContext context,
    bool confirmationMode = true,
  }) async {
    final String? password = await Utils.showNotesModalBottomSheet(
      context: context,
      builder: (context) =>
          BackupPasswordPrompt(confirmationMode: confirmationMode),
    );

    return password;
  }

  static Future<T?> showNotesModalBottomSheet<T extends Object?>({
    required BuildContext context,
    required WidgetBuilder builder,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
    Clip? clipBehavior,
    Color? barrierColor,
    bool childHandlesScroll = false,
    bool enableDismiss = true,
  }) async {
    return context.push<T?>(
      BottomSheetRoute(
        child: builder(context),
        backgroundColor: backgroundColor,
        elevation: elevation,
        shape: shape,
        clipBehavior: clipBehavior,
        childHandlesScroll: childHandlesScroll,
        enableDismiss: enableDismiss,
      ),
    );
  }

  static void showLoadingOverlay(BuildContext context) =>
      context.overlay!.insert(_loadingOverlayEntry);
  static void hideLoadingOverlay(BuildContext context) =>
      _loadingOverlayEntry.remove();

  static String generateId() {
    return const Uuid().v4();
  }

  static SelectionOptions getSelectionOptionsForMode(ReturnMode mode) {
    return SelectionOptions(
      options: (context, notes) {
        final bool anyStarred = notes.any((item) => item.starred);
        final bool showUnpin = notes.first.pinned;

        return [
          const SelectionOptionEntry(
            title: "Select",
            icon: Icons.check,
            value: 'select',
            showOnlyOnRightClickMenu: true,
          ),
          const SelectionOptionEntry(
            title: "Select all",
            icon: Icons.select_all_outlined,
            value: 'selectall',
            showOnlyOnRightClickMenu: true,
          ),
          if (mode == ReturnMode.normal)
            SelectionOptionEntry(
              title: anyStarred
                  ? LocaleStrings.mainPage.selectionBarRemoveFavourites
                  : LocaleStrings.mainPage.selectionBarAddFavourites,
              icon: anyStarred ? Icons.favorite : Icons.favorite_border,
              value: 'favourites',
            ),
          if (mode == ReturnMode.normal)
            SelectionOptionEntry(
              title: LocaleStrings.mainPage.selectionBarChangeColor,
              icon: Icons.color_lens_outlined,
              value: 'color',
            ),
          if (mode != ReturnMode.archive)
            SelectionOptionEntry(
              title: LocaleStrings.mainPage.selectionBarArchive,
              icon: MdiIcons.archiveOutline,
              value: 'archive',
            ),
          SelectionOptionEntry(
            title: LocaleStrings.mainPage.selectionBarDelete,
            icon: Icons.delete_outline,
            value: mode == ReturnMode.trash ? 'perma_delete' : 'delete',
          ),
          if (mode != ReturnMode.normal)
            SelectionOptionEntry(
              icon: Icons.settings_backup_restore,
              title: LocaleStrings.common.restore,
              value: 'restore',
            ),
          if (UniversalPlatform.isAndroid ||
              UniversalPlatform.isIOS ||
              UniversalPlatform.isMacOS)
            SelectionOptionEntry(
              icon: showUnpin ? MdiIcons.pinOffOutline : MdiIcons.pinOutline,
              title:
                  showUnpin ? "Unpin" : LocaleStrings.mainPage.selectionBarPin,
              value: 'pin',
              oneNoteOnly: true,
            ),
          const SelectionOptionEntry(
            title: "Save locally",
            icon: Icons.save_alt_outlined,
            value: 'export',
          ),
          /* SelectionOptionEntry(
            icon: Icons.share_outlined,
            title: LocaleStrings.mainPage.selectionBarShare,
            value: 'share',
            oneNoteOnly: true,
          ), */
        ];
      },
      onSelected: _onSelected,
    );
  }

  static Future<void> _onSelected(
      BuildContext context, List<Note> notes, String value) async {
    final state = context.selectionState;

    switch (value) {
      case 'select':
        state.selecting = true;
        state.addSelectedNote(notes.first);
        break;
      case 'selectall':
        state.selecting = true;
        final List<Note> notes = await helper.listNotes(state.widget.noteKind);
        for (final Note note in notes) {
          state.addSelectedNote(note);
        }
        break;
      case 'favourites':
        final bool unlocked = await Utils.showNoteLockDialog(
          context: context,
          showLock: notes.any((n) => n.lockNote && !n.isEmpty),
          showBiometrics: notes.any((n) => n.usesBiometrics),
        );

        if (unlocked) {
          final bool anyStarred = notes.any((item) => item.starred);

          for (final Note note in notes) {
            if (anyStarred) {
              await helper.saveNote(
                note.markChanged().copyWith(starred: false),
              );
            } else {
              await helper.saveNote(
                note.markChanged().copyWith(starred: true),
              );
            }
          }

          state.closeSelection();
        }
        break;
      case 'color':
        final bool unlocked = await Utils.showNoteLockDialog(
          context: context,
          showLock: notes.any((n) => n.lockNote && !n.isEmpty),
          showBiometrics: notes.any((n) => n.usesBiometrics),
        );

        if (unlocked) {
          int? selectedColor;

          if (notes.length > 1) {
            final int color = notes.first.color;

            if (notes.every((item) => item.color == color)) {
              selectedColor = color;
            } else {
              selectedColor = 0;
            }
          } else {
            selectedColor = notes.first.color;
          }

          selectedColor = await Utils.showNotesModalBottomSheet<int>(
            context: context,
            builder: (context) => NoteColorSelector(
              selectedColor: selectedColor!,
              onColorSelect: (color) {
                context.pop(color);
              },
            ),
          );

          if (selectedColor != null) {
            for (final Note note in notes) {
              await helper.saveNote(note.copyWith(color: selectedColor));
            }

            state.closeSelection();
          }
        }
        break;
      case 'archive':
        final bool archived = await Utils.deleteNotes(
          context: context,
          notes: notes,
          reason: LocaleStrings.mainPage.notesArchived(notes.length),
          archive: true,
        );

        if (archived) state.closeSelection();
        break;
      case 'delete':
        final List<Note> notesToTrash = notes.where((n) => !n.deleted).toList();

        final bool deleted = await Utils.deleteNotes(
          context: context,
          notes: List.from(notesToTrash),
          reason: LocaleStrings.mainPage.notesDeleted(notes.length),
        );

        if (deleted) state.closeSelection();
        break;
      case 'perma_delete':
        final List<Note> notesToBeDeleted =
            notes.where((n) => n.deleted).toList();

        final bool deleted = await Utils.deleteNotes(
          context: context,
          notes: List.from(notesToBeDeleted),
          reason: LocaleStrings.mainPage.notesDeleted(notes.length),
          permaDelete: true,
        );

        if (deleted) state.closeSelection();
        break;
      case 'restore':
        final bool restored = await Utils.restoreNotes(
          context: context,
          notes: notes,
          reason: LocaleStrings.mainPage.notesRestored(notes.length),
        );

        if (restored) state.closeSelection();
        break;
      case 'pin':
        final bool unlocked = await Utils.showNoteLockDialog(
          context: context,
          showLock: notes.first.lockNote && !notes.first.pinned,
          showBiometrics: notes.first.usesBiometrics,
        );

        if (unlocked) {
          handlePinNotes(context, notes.first);

          state.closeSelection();
        }
        break;
      case 'export':
        final bool unlocked = await Utils.showNoteLockDialog(
          context: context,
          showLock: notes.any((n) => n.lockNote && !n.isEmpty),
          showBiometrics: notes.any((n) => n.usesBiometrics),
          description: notes.length > 1
              ? "Some notes are locked, master pass is required."
              : "The note is locked, master pass is required.",
        );
        final int noteCount = notes.length;

        if (unlocked) {
          final String? password = await Utils.showBackupPasswordPrompt(
            context: context,
            confirmationMode: false,
          );
          if (password != null) {
            Utils.showLoadingOverlay(context);
            for (final Note note in notes) {
              await BackupRestore.saveNote(note, password);
            }
            Utils.hideLoadingOverlay(context);
            context.basePage?.hideCurrentSnackBar();
            context.basePage?.showSnackBar(
              SnackBar(
                content: Text("Exported $noteCount notes."),
                behavior: SnackBarBehavior.floating,
                width: min(640, context.mSize.width - 32),
              ),
            );
          }

          state.closeSelection();
        }
        break;
      case 'share':
        final bool unlocked = await Utils.showNoteLockDialog(
          context: context,
          showLock: notes.first.lockNote,
          showBiometrics: notes.first.usesBiometrics,
        );

        if (unlocked) {
          Share.share(
            (notes.first.title.isNotEmpty ? "${notes.first.title}\n\n" : "") +
                notes.first.content,
          );

          state.closeSelection();
        }
        break;
    }
  }

  static void handlePinNotes(BuildContext context, Note note) {
    if (note.pinned) {
      appInfo.notifications?.cancel(note.notificationId);
    } else {
      appInfo.notifications?.show(
        note.notificationId,
        note.title.isEmpty
            ? LocaleStrings.common.notificationDefaultTitle
            : note.title,
        note.content,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'pinned_notifications',
            LocaleStrings.common.notificationDetailsTitle,
            LocaleStrings.common.notificationDetailsDesc,
            color: Utils.defaultAccent,
            ongoing: true,
            priority: Priority.max,
          ),
          iOS: const IOSNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
          macOS: const MacOSNotificationDetails(),
        ),
        payload: json.encode(
          NotificationPayload(
            action: NotificationAction.pin,
            id: int.parse(note.id.split("-")[0], radix: 16).toUnsigned(31),
            noteId: note.id,
          ).toJson(),
        ),
      );
    }
  }

  static String getNameFromMode(ReturnMode mode, {int tagIndex = 0}) {
    switch (mode) {
      case ReturnMode.normal:
        return LocaleStrings.mainPage.titleHome;
      case ReturnMode.archive:
        return LocaleStrings.mainPage.titleArchive;
      case ReturnMode.trash:
        return LocaleStrings.mainPage.titleTrash;
      case ReturnMode.favourites:
        return LocaleStrings.mainPage.titleFavourites;
      case ReturnMode.tag:
        if (prefs.tags.isNotEmpty) {
          return prefs.tags[tagIndex].name;
        } else {
          return LocaleStrings.mainPage.titleTag;
        }
      case ReturnMode.all:
      default:
        return LocaleStrings.mainPage.titleAll;
    }
  }

  static Color get defaultAccent => const Color(0xFF66BB6A);

  static Future<bool> deleteNotes({
    required BuildContext context,
    required List<Note> notes,
    required String reason,
    bool archive = false,
    bool showAuthDialog = true,
    bool permaDelete = false,
  }) async {
    final bool lockSuccess = await Utils.showNoteLockDialog(
      context: context,
      showLock: notes.any((n) => n.lockNote && !n.isEmpty) && showAuthDialog,
      showBiometrics: notes.any((n) => n.usesBiometrics),
    );
    if (!lockSuccess) return false;

    for (final Note note in notes) {
      if (archive) {
        await helper.saveNote(
            note.markChanged().copyWith(deleted: false, archived: true));
      } else {
        if (permaDelete) {
          Utils.deleteNoteSafely(note);
        } else {
          await helper.saveNote(
              note.markChanged().copyWith(deleted: true, archived: false));
        }
      }
    }

    final List<Note> backupNotes = List.from(notes);

    context.basePage?.hideCurrentSnackBar();
    context.basePage?.showSnackBar(
      SnackBar(
        content: Text(reason),
        behavior: SnackBarBehavior.floating,
        width: min(640, context.mSize.width - 32),
        action: SnackBarAction(
          label: LocaleStrings.common.undo,
          onPressed: () async {
            for (final Note note in backupNotes) {
              await helper.saveNote(note);
            }
          },
        ),
      ),
    );

    return true;
  }

  static Future<bool> restoreNotes({
    required BuildContext context,
    required List<Note> notes,
    required String reason,
    bool archive = false,
    bool showAuthDialog = true,
  }) async {
    final bool lockSuccess = await Utils.showNoteLockDialog(
      context: context,
      showLock: notes.any((n) => n.lockNote && !n.isEmpty) && showAuthDialog,
      showBiometrics: notes.any((n) => n.usesBiometrics),
    );
    if (!lockSuccess) return false;

    for (final Note note in notes) {
      await helper.saveNote(
          note.markChanged().copyWith(deleted: false, archived: false));
    }

    final List<Note> backupNotes = List.from(notes);

    context.basePage?.hideCurrentSnackBar();
    context.basePage?.showSnackBar(
      SnackBar(
        content: Text(reason),
        behavior: SnackBarBehavior.floating,
        width: min(640, context.mSize.width - 32),
        action: SnackBarAction(
          label: LocaleStrings.common.undo,
          onPressed: () async {
            for (final Note note in backupNotes) {
              await helper.saveNote(note);
            }
          },
        ),
      ),
    );

    return true;
  }

  static List<ContributorInfo> get contributors => [
        ContributorInfo(
          name: "Davide Bianco",
          role: LocaleStrings.about.contributorsHrx,
          avatarUrl: "https://avatars.githubusercontent.com/u/29352339",
          socialLinks: const [
            SocialLink(SocialLinkType.github, "HrX03"),
            SocialLink(SocialLinkType.instagram, "b_b_biancoboi"),
            SocialLink(SocialLinkType.twitter, "HrX2003"),
          ],
        ),
        ContributorInfo(
          name: "Bas Wieringa (broodrooster)",
          role: LocaleStrings.about.contributorsBas,
          avatarUrl: "https://avatars.githubusercontent.com/u/31385368",
          socialLinks: const [
            SocialLink(SocialLinkType.github, "broodroosterdev"),
          ],
        ),
        ContributorInfo(
          name: "Nico Franke",
          role: LocaleStrings.about.contributorsNico,
          avatarUrl: "https://avatars.githubusercontent.com/u/23036430",
          socialLinks: const [
            SocialLink(SocialLinkType.github, "ZerNico"),
            SocialLink(SocialLinkType.instagram, "z3rnico"),
            SocialLink(SocialLinkType.twitter, "Z3rNico"),
          ],
        ),
        ContributorInfo(
          name: "SphericalKat",
          role: LocaleStrings.about.contributorsKat,
          avatarUrl: "https://avatars.githubusercontent.com/u/31761843",
          socialLinks: const [
            SocialLink(SocialLinkType.github, "ATechnoHazard"),
          ],
        ),
        ContributorInfo(
          name: "Rohit K.Parida",
          role: LocaleStrings.about.contributorsRohit,
          avatarUrl: "https://avatars.githubusercontent.com/u/18437518",
          socialLinks: const [
            SocialLink(SocialLinkType.twitter, "paridadesigns"),
          ],
        ),
        ContributorInfo(
          name: "RshBfn",
          role: LocaleStrings.about.contributorsRshbfn,
          avatarUrl:
              "https://pbs.twimg.com/profile_images/1306121394241953792/G0zeUpRb.jpg",
          socialLinks: const [
            SocialLink(SocialLinkType.twitter, "RshBfn"),
          ],
        ),
        const ContributorInfo(
          name: "Elias Gagnef",
          role: "Leaflet brand name",
          avatarUrl: "https://avatars.githubusercontent.com/u/46574798",
          socialLinks: [
            SocialLink(SocialLinkType.twitter, "EliasGagnef"),
            SocialLink(SocialLinkType.github, "EliasGagnef"),
            SocialLink(SocialLinkType.steam, "Gagnef"),
          ],
        ),
      ];

  static Future<dynamic> showSecondaryRoute(
    BuildContext context,
    Widget route, {
    bool allowGestures = true,
    bool pushImmediate = false,
  }) async {
    return context.push(
      DismissiblePageRoute(
        builder: (context) => ScaffoldMessenger(
          child: route,
        ),
        allowGestures: allowGestures,
        pushImmediate: pushImmediate,
      ),
    );
  }

  static Widget quickIllustration(
      BuildContext context, Widget illustration, String text) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 128,
          child: Center(
            child: illustration,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: context.theme.iconTheme.color,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  static Future<void> newNote(BuildContext context) async {
    final int currentLength =
        (await helper.listNotes(ReturnMode.normal)).length;
    final String id = generateId();

    await Utils.showSecondaryRoute(
      context,
      NotePage(
        note: NoteX.emptyNote.copyWith(id: id),
        focusTitle: true,
      ),
    );

    deleteLastNoteIfEmpty(context, currentLength, id);
  }

  static Future<void> deleteLastNoteIfEmpty(
    BuildContext context,
    int currentLength,
    String id,
  ) async {
    final List<Note> notes = await helper.listNotes(ReturnMode.normal);
    final int newLength = notes.length;

    if (newLength > currentLength) {
      final Note? lastNote = notes.firstWhereOrNull(
        (element) => element.id == id,
      );
      if (lastNote == null) return;
      Utils.handleNotePagePop(lastNote);

      if (lastNote.isEmpty) {
        Utils.deleteNotes(
          context: context,
          notes: [lastNote],
          reason: LocaleStrings.mainPage.deletedEmptyNote,
        );
      }
    }
  }

  static Future<void> newImage(BuildContext context, ImageSource source) async {
    Note note = NoteX.emptyNote;
    final File? image = await pickImage();

    if (image != null) {
      final SavedImage savedImage =
          await imageHelper.copyToCache(File(image.path));
      note.images.add(savedImage);

      final int currentLength =
          (await helper.listNotes(ReturnMode.normal)).length;
      final String id = generateId();

      note = note.copyWith(id: id);

      await Utils.showSecondaryRoute(
        context,
        NotePage(
          note: note,
        ),
      );

      helper.saveNote(note.markChanged());

      deleteLastNoteIfEmpty(context, currentLength, id);
    }
  }

  static Future<void> newList(BuildContext context) async {
    final int currentLength =
        (await helper.listNotes(ReturnMode.normal)).length;
    final String id = generateId();

    await Utils.showSecondaryRoute(
      context,
      NotePage(
        note: NoteX.emptyNote.copyWith(id: id),
        openWithList: true,
      ),
    );

    deleteLastNoteIfEmpty(context, currentLength, id);
  }

  static Future<void> newDrawing(BuildContext context) async {
    final int currentLength =
        (await helper.listNotes(ReturnMode.normal)).length;
    final String id = generateId();

    await Utils.showSecondaryRoute(
      context,
      NotePage(
        note: NoteX.emptyNote.copyWith(id: id),
        openWithDrawing: true,
      ),
    );

    deleteLastNoteIfEmpty(context, currentLength, id);
  }

  static Future<void> importNotes(BuildContext context) async {
    final List<String>? pickedFiles = await Utils.pickFiles(
      allowedExtensions: ["note"],
    );
    if (pickedFiles == null || pickedFiles.isEmpty) return;

    final String? password =
        await Utils.showBackupPasswordPrompt(context: context);
    if (password == null) return;

    int restoredFiles = 0;
    Utils.showLoadingOverlay(context);
    for (final String file in pickedFiles) {
      if (p.extension(file) != ".note") continue;

      final bool restored = await BackupRestore.restoreNote(file, password);
      if (restored) restoredFiles++;
    }
    Utils.hideLoadingOverlay(context);

    context.scaffoldMessenger.removeCurrentSnackBar();
    context.scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text("$restoredFiles notes were restored."),
        behavior: SnackBarBehavior.floating,
        width: min(640, context.mSize.width - 32),
      ),
    );
  }

  static Future<File?> pickImage() async {
    String? path;

    if (DeviceInfo.isDesktop) {
      final XFile? image = await openFile(
        acceptedTypeGroups: [
          XTypeGroup(
            label: 'images',
            extensions: [
              'png',
              'jpg',
              'jpeg',
              'bmp',
            ],
          ),
        ],
      );

      path = image?.path;
    } else {
      final PickedFile? image =
          await ImagePicker().getImage(source: ImageSource.gallery);

      path = image?.path;
    }

    return path != null ? File(path) : null;
  }

  static Future<String?> pickFile({List<String>? allowedExtensions}) async {
    final dynamic asyncFile = DeviceInfo.isDesktop
        ? await openFile(
            acceptedTypeGroups: [
              XTypeGroup(
                extensions: allowedExtensions,
              ),
            ],
          )
        : (await FilePicker.platform.pickFiles())?.files.first;

    if (asyncFile == null) return null;

    return asyncFile.path as String;
  }

  static Future<List<String>?> pickFiles(
      {List<String>? allowedExtensions}) async {
    final List<dynamic>? asyncFiles = DeviceInfo.isDesktop
        ? await openFiles(
            acceptedTypeGroups: [
              XTypeGroup(
                extensions: allowedExtensions,
              ),
            ],
          )
        : (await FilePicker.platform.pickFiles())?.files;

    if (asyncFiles == null) return null;

    return asyncFiles.map((e) => e.path as String).toList();
  }

  static Future<bool> launchUrl(
    String url, {
    Map<String, String> headers = const {},
  }) async {
    final bool canLaunchLink = await canLaunch(url);

    if (canLaunchLink) {
      return launch(url, headers: headers);
    }

    return false;
  }

  static String get defaultApiUrl => "https://sync.potatoproject.co/api/v2";

  static List<T> asList<T>(dynamic obj) {
    return List<T>.from(obj as List<dynamic>);
  }

  static Map<K, V> asMap<K, V>(dynamic obj) {
    return Map<K, V>.from(obj as Map<dynamic, dynamic>);
  }

  static String hashedPass(String pass) {
    final Blake2 blake = Blake2();
    blake.updateWithString(pass);
    return utils.hex(blake.digest());
  }
}

extension NoteX on Note {
  static Note get emptyNote => Note(
        id: "",
        title: "",
        content: "",
        starred: false,
        creationDate: DateTime.now(),
        lastModifyDate: DateTime.now(),
        color: 0,
        images: [],
        list: false,
        listContent: [],
        reminders: [],
        tags: [],
        hideContent: false,
        lockNote: false,
        usesBiometrics: false,
        deleted: false,
        archived: false,
        synced: false,
      );

  static Note fromSyncMap(Map<String, dynamic> syncMap) {
    final Map<String, dynamic> newMap = {};
    syncMap.forEach((key, value) {
      Object? newValue = value;
      String newKey = ReCase(key).camelCase;
      switch (key) {
        case "style_json":
          final List<int> map = Utils.asList<int>(
            json.decode(value.toString()),
          );
          final List<int> data = List<int>.from(map.map((i) => i)).toList();
          newValue = data;
          break;
        case "images":
          final List<Map<String, dynamic>> list =
              Utils.asList<Map<String, dynamic>>(
            json.decode(value.toString()),
          );
          final List<SavedImage> images =
              list.map((i) => SavedImage.fromJson(i)).toList();
          newValue = images;
          break;
        case "list_content":
          final List<Map<String, dynamic>> map =
              Utils.asList<Map<String, dynamic>>(
            json.decode(value.toString()),
          );
          final List<ListItem> content = Utils.asList<ListItem>(
            map.map((i) => ListItem.fromJson(i)).toList(),
          );
          newValue = content;
          break;
        case "reminders":
          final List<String> map =
              Utils.asList<String>(json.decode(value.toString()));
          final List<DateTime> reminders = Utils.asList<DateTime>(
            map.map((i) => DateTime.parse(i)).toList(),
          );
          newValue = reminders;
          break;
        case "tags":
          final List<String> map = Utils.asList<String>(
            json.decode(value.toString()),
          );
          newValue = map;
          break;
        case "note_id":
          newKey = "id";
          break;
      }
      newMap.putIfAbsent(newKey, () => newValue);
    });

    return Note.fromJson(fillInMissingFields(newMap));
  }

  static Map<String, dynamic> fillInMissingFields(
      Map<String, dynamic> original) {
    final Map<String, dynamic> derivated = Map.from(original);
    derivated.putIfAbsent('id', () => '');
    derivated.putIfAbsent('title', () => '');
    derivated.putIfAbsent('content', () => '');
    derivated.putIfAbsent('styleJson', () => []);
    derivated.putIfAbsent('starred', () => false);
    derivated.putIfAbsent('creationDate', () => DateTime.now());
    derivated.putIfAbsent('lastModifyDate', () => DateTime.now());
    derivated.putIfAbsent('color', () => 0);
    derivated.putIfAbsent('images', () => []);
    derivated.putIfAbsent('list', () => false);
    derivated.putIfAbsent('listContent', () => []);
    derivated.putIfAbsent('reminders', () => []);
    derivated.putIfAbsent('tags', () => []);
    derivated.putIfAbsent('hideContent', () => false);
    derivated.putIfAbsent('lockNote', () => false);
    derivated.putIfAbsent('usesBiometrics', () => false);
    derivated.putIfAbsent('deleted', () => false);
    derivated.putIfAbsent('archived', () => false);
    derivated.putIfAbsent('synced', () => false);
    return derivated;
  }

  bool get isEmpty {
    final bool titleEmpty = title.isEmpty;
    final bool contentEmpty = content.isEmpty;
    final bool imagesEmpty = images.isEmpty;
    final bool listContentEmpty = listContent.isEmpty;
    final bool listContentItemsEmpty = listContent.every(
      (element) => element.text.trim().isEmpty,
    );

    return titleEmpty &&
        contentEmpty &&
        imagesEmpty &&
        (listContentEmpty || listContentItemsEmpty);
  }

  Map<String, dynamic> toSyncMap() {
    final Map<String, dynamic> originalMap = toJson();
    final Map<String, dynamic> newMap = {};
    originalMap.forEach((key, value) {
      Object? newValue = value;
      String newKey = ReCase(key).snakeCase;
      switch (key) {
        case "styleJson":
          {
            final List<int> style = Utils.asList<int>(value);
            newValue = json.encode(style);
            break;
          }
        case "images":
          {
            final List<SavedImage> images = Utils.asList<SavedImage>(value);
            newValue = json.encode(images);
            break;
          }
        case "listContent":
          {
            final List<ListItem> listContent = Utils.asList<ListItem>(value);
            newValue = json.encode(listContent);
            break;
          }
        case "reminders":
          {
            final List<DateTime> reminders = Utils.asList<DateTime>(value);
            newValue = json.encode(reminders);
            break;
          }
        case "tags":
          {
            final List<String> tags = Utils.asList<String>(value);
            newValue = json.encode(tags);
            break;
          }
      }
      if (key == "id") {
        newKey = "note_id";
      }
      newMap.putIfAbsent(newKey, () => newValue);
    });
    return newMap;
  }

  Note markChanged() {
    return copyWith(synced: false, lastModifyDate: DateTime.now());
  }

  int get notificationId =>
      int.parse(id.split("-")[0], radix: 16).toUnsigned(31);

  bool get pinned {
    return appInfo.activeNotifications.any(
      (e) => e.id == notificationId,
    );
  }

  List<String> get actualTags {
    final List<String> actualTags = [];
    for (final String tag in tags) {
      final Tag? actualTag = prefs.tags.firstWhereOrNull(
        (t) => t.id == tag,
      );
      if (actualTag != null) actualTags.add(actualTag.id);
    }
    return actualTags;
  }
}

extension TagX on Tag {
  Tag markChanged() {
    return copyWith(lastModifyDate: DateTime.now());
  }
}

extension PackageInfoX on PackageInfo {
  int get buildNumberInt {
    // This terrible hack is necessary on windows because of a bug on
    // package_info_plus where each field gets a null character
    // appended at the end
    final String cleanBuildNumber = buildNumber.replaceAll('\u0000', '');
    return int.tryParse(cleanBuildNumber) ?? -1;
  }
}

extension UriX on Uri {
  ImageProvider toImageProvider() {
    if (data != null) {
      return MemoryImage(data!.contentAsBytes());
    } else if (scheme.startsWith("http") || scheme.startsWith("blob")) {
      return NetworkImage(toString());
    } else {
      return FileImage(File(path));
    }
  }
}

extension ResponseX on Response {
  dynamic get bodyJson {
    try {
      return json.decode(body);
    } on FormatException {
      return body;
    }
  }
}

extension SafeGetList<T> on List<T> {
  T get(int index) {
    if (index >= length) {
      return last;
    } else {
      return this[index];
    }
  }

  T? maybeGet(int index) {
    if (index >= length) {
      return null;
    } else {
      return this[index];
    }
  }
}

extension ContextProviders on BuildContext {
  ThemeData get theme => Theme.of(this);

  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get mSize => mediaQuery.size;
  EdgeInsets get padding => mediaQuery.padding;
  EdgeInsets get viewInsets => mediaQuery.viewInsets;
  EdgeInsets get viewPadding => mediaQuery.viewPadding;

  BasePageState? get basePage => BasePage.maybeOf(this);
  TextDirection get directionality => Directionality.of(this);

  NavigatorState get navigator => Navigator.of(this);
  void pop<T extends Object?>([T? result]) => navigator.pop<T?>(result);
  Future<T?> push<T extends Object?>(Route<T> route) =>
      navigator.push<T?>(route);

  NoteListPageState get selectionState => SelectionState.of(this);

  ScaffoldMessengerState get scaffoldMessenger => ScaffoldMessenger.of(this);

  FocusScopeNode get focusScope => FocusScope.of(this);

  DismissibleRouteState? get dismissibleRoute => DismissibleRoute.maybeOf(this);

  OverlayState? get overlay => Overlay.of(this);
}

class SuspendedCurve extends Curve {
  /// Creates a suspended curve.
  const SuspendedCurve(
    this.startingPoint, {
    this.curve = Curves.easeOutCubic,
  });

  /// The progress value at which [curve] should begin.
  ///
  /// This defaults to [Curves.easeOutCubic].
  final double startingPoint;

  /// The curve to use when [startingPoint] is reached.
  final Curve curve;

  @override
  double transform(double t) {
    assert(t >= 0.0 && t <= 1.0);
    assert(startingPoint >= 0.0 && startingPoint <= 1.0);

    if (t < startingPoint) {
      return t;
    }

    if (t == 1.0) {
      return t;
    }

    final double curveProgress = (t - startingPoint) / (1 - startingPoint);
    final double transformed = curve.transform(curveProgress);
    return lerpDouble(startingPoint, 1, transformed)!;
  }
}
