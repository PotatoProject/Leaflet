import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:potato_notes/data/dao/note_helper.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/data/model/list_content.dart';
import 'package:potato_notes/data/model/saved_image.dart';
import 'package:potato_notes/internal/device_info.dart';
import 'package:potato_notes/internal/notification_payload.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/locales/locale_strings.g.dart';
import 'package:potato_notes/internal/sync/image/image_helper.dart';
import 'package:potato_notes/routes/about_page.dart';
import 'package:potato_notes/routes/base_page.dart';
import 'package:potato_notes/routes/note_list_page.dart';
import 'package:potato_notes/routes/note_page.dart';
import 'package:potato_notes/widget/bottom_sheet_base.dart';
import 'package:potato_notes/widget/dismissible_route.dart';
import 'package:potato_notes/widget/note_color_selector.dart';
import 'package:potato_notes/widget/pass_challenge.dart';
import 'package:potato_notes/widget/selection_bar.dart';
import 'package:recase/recase.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

const double kCardBorderRadius = 4;
const EdgeInsets kCardPadding = const EdgeInsets.all(4);

class Utils {
  Utils._();

  static deleteNoteSafely(Note note) {
    ImageHelper.handleNoteDeletion(note);
    helper.deleteNote(note);
  }

  static handleNotePagePop(Note note) {
    //ImageService.handleDeletes();
    //helper.listNotes(ReturnMode.LOCAL).then((notes) => {
    //      SyncRoutine.syncNote(notes.firstWhere((local) => local.id == note.id))
    //    });
  }

  static Future<dynamic> showPassChallengeSheet(BuildContext context) async {
    return await showNotesModalBottomSheet(
      context: context,
      builder: (context) => PassChallenge(
        editMode: false,
        onChallengeSuccess: () => Navigator.pop(context, true),
        onSave: null,
      ),
    );
  }

  static Future<bool> showBiometricPrompt() async {
    return await LocalAuthentication().authenticate(
      localizedReason: "",
      biometricOnly: true,
      stickyAuth: true,
      androidAuthStrings: AndroidAuthMessages(
        signInTitle: LocaleStrings.common.biometricsPrompt,
        cancelButton: LocaleStrings.common.cancel,
      ),
    );
  }

  static Future<dynamic> showNotesModalBottomSheet({
    @required BuildContext context,
    @required WidgetBuilder builder,
    Color backgroundColor,
    double elevation,
    ShapeBorder shape,
    Clip clipBehavior,
    Color barrierColor,
    bool childHandlesScroll = false,
  }) async {
    return await Navigator.push(
      context,
      BottomSheetRoute(
        child: builder(context),
        backgroundColor: backgroundColor,
        elevation: elevation,
        shape: shape,
        clipBehavior: clipBehavior,
        childHandlesScroll: childHandlesScroll,
      ),
    );
  }

  static String generateId() {
    return Uuid().v4();
  }

  static SelectionOptions getSelectionOptionsForMode(ReturnMode mode) {
    return SelectionOptions(
      options: (context, notes) {
        final bool anyStarred = notes.any((item) => item.starred);
        final bool showUnpin = notes.first.pinned;

        return [
          SelectionOptionEntry(
            title: "Select",
            icon: Icons.check,
            value: 'select',
            showOnlyOnRightClickMenu: true,
          ),
          SelectionOptionEntry(
            title: "Select all",
            icon: Icons.select_all_outlined,
            value: 'selectall',
            showOnlyOnRightClickMenu: true,
          ),
          if (mode == ReturnMode.NORMAL)
            SelectionOptionEntry(
              title: anyStarred
                  ? LocaleStrings.mainPage.selectionBarRemoveFavourites
                  : LocaleStrings.mainPage.selectionBarAddFavourites,
              icon: anyStarred ? Icons.favorite : Icons.favorite_border,
              value: 'favourites',
            ),
          if (mode == ReturnMode.NORMAL)
            SelectionOptionEntry(
              title: LocaleStrings.mainPage.selectionBarChangeColor,
              icon: Icons.color_lens_outlined,
              value: 'color',
            ),
          if (mode != ReturnMode.ARCHIVE)
            SelectionOptionEntry(
              title: LocaleStrings.mainPage.selectionBarArchive,
              icon: MdiIcons.archiveOutline,
              value: 'archive',
            ),
          SelectionOptionEntry(
            title: LocaleStrings.mainPage.selectionBarDelete,
            icon: Icons.delete_outline,
            value: 'delete',
          ),
          if (mode != ReturnMode.NORMAL)
            SelectionOptionEntry(
              icon: Icons.settings_backup_restore,
              title: LocaleStrings.common.restore,
              value: 'restore',
            ),
          if (Platform.isAndroid || Platform.isIOS || Platform.isMacOS)
            SelectionOptionEntry(
              icon: showUnpin ? MdiIcons.pinOffOutline : MdiIcons.pinOutline,
              title:
                  showUnpin ? "Unpin" : LocaleStrings.mainPage.selectionBarPin,
              value: 'pin',
              oneNoteOnly: true,
            ),
          SelectionOptionEntry(
            icon: Icons.share_outlined,
            title: LocaleStrings.mainPage.selectionBarShare,
            value: 'share',
            oneNoteOnly: true,
          ),
        ];
      },
      onSelected: _onSelected,
    );
  }

  static Future<void> _onSelected(
      BuildContext context, List<Note> notes, String value) async {
    final state = SelectionState.of(context);

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
        final bool anyStarred = notes.any((item) => item.starred);

        for (Note note in notes) {
          if (anyStarred)
            await helper.saveNote(
              note.markChanged().copyWith(starred: false),
            );
          else
            await helper.saveNote(
              note.markChanged().copyWith(starred: true),
            );
        }

        state.closeSelection();
        break;
      case 'color':
        int selectedColor;

        if (notes.length > 1) {
          int color = notes.first.color;

          if (notes.every((item) => item.color == color))
            selectedColor = color;
          else
            selectedColor = 0;
        } else
          selectedColor = notes.first.color;

        selectedColor = await Utils.showNotesModalBottomSheet(
          context: context,
          builder: (context) => NoteColorSelector(
            selectedColor: selectedColor,
            onColorSelect: (color) {
              Navigator.pop(context, color);
            },
          ),
        );

        if (selectedColor != null) {
          for (Note note in notes)
            await helper.saveNote(note.copyWith(color: selectedColor));

          state.closeSelection();
        }
        break;
      case 'archive':
        await Utils.deleteNotes(
          context: context,
          notes: notes,
          reason: LocaleStrings.mainPage.notesArchived(notes.length),
          archive: true,
        );

        state.closeSelection();
        break;
      case 'delete':
        final List<Note> notesToTrash = notes.where((n) => !n.deleted).toList();
        final List<Note> notesToBeDeleted =
            notes.where((n) => n.deleted).toList();

        notesToBeDeleted.forEach((n) => Utils.deleteNoteSafely(n));

        await Utils.deleteNotes(
          context: context,
          notes: notesToTrash.toList(),
          reason: LocaleStrings.mainPage.notesDeleted(notes.length),
        );

        state.closeSelection();
        break;
      case 'restore':
        await Utils.restoreNotes(
          context: context,
          notes: notes,
          reason: LocaleStrings.mainPage.notesRestored(notes.length),
        );

        state.closeSelection();
        break;
      case 'pin':
        handlePinNotes(context, notes.first);

        state.closeSelection();
        break;
      case 'share':
        final bool status = notes.first.lockNote
            ? await Utils.showPassChallengeSheet(context)
            : true;
        if (status ?? false) {
          Share.share(
            (notes.first.title.isNotEmpty ? notes.first.title + "\n\n" : "") +
                notes.first.content,
          );
        }

        state.closeSelection();
        break;
    }
  }

  static void handlePinNotes(BuildContext context, Note note) {
    if (note.pinned) {
      appInfo.notifications.cancel(note.notificationId);
    } else {
      appInfo.notifications.show(
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
          iOS: IOSNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
          macOS: MacOSNotificationDetails(),
        ),
        payload: json.encode(
          NotificationPayload(
            action: NotificationAction.PIN,
            id: int.parse(note.id.split("-")[0], radix: 16).toUnsigned(31),
            noteId: note.id,
          ).toJson(),
        ),
      );
    }
  }

  static String getNameFromMode(ReturnMode mode, {int tagIndex = 0}) {
    switch (mode) {
      case ReturnMode.NORMAL:
        return LocaleStrings.mainPage.titleHome;
      case ReturnMode.ARCHIVE:
        return LocaleStrings.mainPage.titleArchive;
      case ReturnMode.TRASH:
        return LocaleStrings.mainPage.titleTrash;
      case ReturnMode.FAVOURITES:
        return LocaleStrings.mainPage.titleFavourites;
      case ReturnMode.TAG:
        if (prefs.tags.isNotEmpty) {
          return prefs.tags[tagIndex].name;
        } else {
          return LocaleStrings.mainPage.titleTag;
        }
        break;
      case ReturnMode.ALL:
      default:
        return LocaleStrings.mainPage.titleAll;
    }
  }

  static get defaultAccent => Color(0xFF66BB6A);

  static Future<void> deleteNotes({
    @required BuildContext context,
    @required List<Note> notes,
    @required String reason,
    bool archive = false,
  }) async {
    for (final Note note in notes) {
      if (archive) {
        await helper.saveNote(
            note.markChanged().copyWith(deleted: false, archived: true));
      } else {
        await helper.saveNote(
            note.markChanged().copyWith(deleted: true, archived: false));
      }
    }

    final List<Note> backupNotes = List.from(notes);

    BasePage.of(context)?.hideCurrentSnackBar();
    BasePage.of(context)?.showSnackBar(
      SnackBar(
        content: Text(reason),
        behavior: SnackBarBehavior.floating,
        width: min(640, MediaQuery.of(context).size.width - 32),
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
  }

  static Future<void> restoreNotes({
    @required BuildContext context,
    @required List<Note> notes,
    @required String reason,
    bool archive = false,
  }) async {
    for (final Note note in notes) {
      await helper.saveNote(
          note.markChanged().copyWith(deleted: false, archived: false));
    }

    final List<Note> backupNotes = List.from(notes);

    BasePage.of(context)?.hideCurrentSnackBar();
    BasePage.of(context)?.showSnackBar(
      SnackBar(
        content: Text(reason),
        behavior: SnackBarBehavior.floating,
        width: min(640, MediaQuery.of(context).size.width - 32),
        action: SnackBarAction(
          label: LocaleStrings.common.undo,
          onPressed: () async {
            for (Note note in backupNotes) {
              await helper.saveNote(note);
            }
          },
        ),
      ),
    );
  }

  static List<ContributorInfo> get contributors => [
        ContributorInfo(
          name: "Davide Bianco",
          role: LocaleStrings.about.contributorsHrx,
          avatarUrl: "https://avatars.githubusercontent.com/u/29352339",
          socialLinks: [
            SocialLink(SocialLinkType.GITHUB, "HrX03"),
            SocialLink(SocialLinkType.INSTAGRAM, "b_b_biancoboi"),
            SocialLink(SocialLinkType.TWITTER, "HrX2003"),
          ],
        ),
        ContributorInfo(
          name: "Bas Wieringa (broodrooster)",
          role: LocaleStrings.about.contributorsBas,
          avatarUrl: "https://avatars.githubusercontent.com/u/31385368",
          socialLinks: [
            SocialLink(SocialLinkType.GITHUB, "broodroosterdev"),
          ],
        ),
        ContributorInfo(
          name: "Nico Franke",
          role: LocaleStrings.about.contributorsNico,
          avatarUrl: "https://avatars.githubusercontent.com/u/23036430",
          socialLinks: [
            SocialLink(SocialLinkType.GITHUB, "ZerNico"),
            SocialLink(SocialLinkType.INSTAGRAM, "z3rnico"),
            SocialLink(SocialLinkType.TWITTER, "Z3rNico"),
          ],
        ),
        ContributorInfo(
          name: "SphericalKat",
          role: LocaleStrings.about.contributorsKat,
          avatarUrl: "https://avatars.githubusercontent.com/u/31761843",
          socialLinks: [
            SocialLink(SocialLinkType.GITHUB, "ATechnoHazard"),
          ],
        ),
        ContributorInfo(
          name: "Rohit K.Parida",
          role: LocaleStrings.about.contributorsRohit,
          avatarUrl: "https://avatars.githubusercontent.com/u/18437518",
          socialLinks: [
            SocialLink(SocialLinkType.TWITTER, "paridadesigns"),
          ],
        ),
        ContributorInfo(
          name: "RshBfn",
          role: LocaleStrings.about.contributorsRshbfn,
          avatarUrl:
              "https://pbs.twimg.com/profile_images/1306121394241953792/G0zeUpRb.jpg",
          socialLinks: [
            SocialLink(SocialLinkType.TWITTER, "RshBfn"),
          ],
        ),
        ContributorInfo(
          name: "Elias Gagnef",
          role: "Leaflet brand name",
          avatarUrl: "https://avatars.githubusercontent.com/u/46574798",
          socialLinks: [
            SocialLink(SocialLinkType.TWITTER, "EliasGagnef"),
            SocialLink(SocialLinkType.GITHUB, "EliasGagnef"),
            SocialLink(SocialLinkType.STEAM, "Gagnef"),
          ],
        ),
      ];

  static Future<dynamic> showSecondaryRoute(
    BuildContext context,
    Widget route, {
    bool allowGestures = true,
    bool pushImmediate = false,
  }) async {
    return Navigator.of(context).push(
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
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 148,
          child: Center(
            child: illustration,
          ),
        ),
        SizedBox(height: 24),
        Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).iconTheme.color,
          ),
          textAlign: TextAlign.center,
        )
      ],
    );
  }

  static void newNote(BuildContext context) async {
    final int currentLength =
        (await helper.listNotes(ReturnMode.NORMAL)).length;
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

  static void deleteLastNoteIfEmpty(
    BuildContext context,
    int currentLength,
    String id,
  ) async {
    final List<Note> notes = await helper.listNotes(ReturnMode.NORMAL);
    final int newLength = notes.length;

    if (newLength > currentLength) {
      final Note lastNote = notes.firstWhere(
        (element) => element.id == id,
        orElse: () => null,
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

  static void newImage(BuildContext context, ImageSource source) async {
    Note note = NoteX.emptyNote;
    final File image = await pickImage();

    if (image != null) {
      final SavedImage savedImage =
          await ImageHelper.copyToCache(File(image.path));
      note.images.add(savedImage);

      final int currentLength =
          (await helper.listNotes(ReturnMode.NORMAL)).length;
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

  static void newList(BuildContext context) async {
    final int currentLength =
        (await helper.listNotes(ReturnMode.NORMAL)).length;
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

  static void newDrawing(BuildContext context) async {
    final int currentLength =
        (await helper.listNotes(ReturnMode.NORMAL)).length;
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

  static Future<File> pickImage() async {
    String path;

    try {
      if (DeviceInfo.isDesktop) {
        final XFile image = await openFile(
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

        path = image.path;
      } else {
        final PickedFile image =
            await ImagePicker().getImage(source: ImageSource.gallery);

        path = image.path;
      }
    } catch (e) {}

    return path != null ? File(path) : null;
  }

  static Future<bool> launchUrl(
    String url, {
    Map<String, String> headers,
  }) async {
    bool canLaunchLink = await canLaunch(url);

    if (canLaunchLink) {
      return await launch(url, headers: headers);
    }

    return false;
  }

  static String get defaultApiUrl => "https://sync.potatoproject.co/api/v2";
}

extension NoteX on Note {
  static Note get emptyNote => Note(
        id: null,
        title: "",
        content: "",
        styleJson: [],
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
    Map<String, dynamic> newMap = Map();
    syncMap.forEach((key, value) {
      Object newValue = value;
      String newKey = ReCase(key).camelCase;
      switch (key) {
        case "style_json":
          {
            final List<dynamic> map = json.decode(value);
            final List<int> data =
                List<int>.from(map.map((i) => i as int)).toList();
            newValue = data;
            break;
          }
        case "images":
          {
            final List<dynamic> list = json.decode(value);
            final List<SavedImage> images =
                list.map((i) => SavedImage.fromJson(i)).toList();
            newValue = images;
            break;
          }
        case "list_content":
          {
            final List<dynamic> map = json.decode(value);
            final List<ListItem> content =
                List<ListItem>.from(map.map((i) => ListItem.fromJson(i)))
                    .toList();
            newValue = content;
            break;
          }
        case "reminders":
          {
            final List<dynamic> map = json.decode(value);
            final List<DateTime> reminders =
                List<DateTime>.from(map.map((i) => DateTime.parse(i))).toList();
            newValue = reminders;
            break;
          }
        case "tags":
          {
            var map = json.decode(value);
            List<String> tagIds = List<String>.from(map).toList();
            newValue = tagIds;
          }
      }
      if (key == "note_id") {
        newKey = "id";
      }
      newMap.putIfAbsent(newKey, () => newValue);
    });
    return Note.fromJson(newMap);
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
    final Map<String, dynamic> originalMap = this.toJson();
    final Map<String, dynamic> newMap = Map();
    originalMap.forEach((key, value) {
      Object newValue = value;
      String newKey = ReCase(key).snakeCase;
      switch (key) {
        case "styleJson":
          {
            final List<int> style = value;
            newValue = json.encode(style);
            break;
          }
        case "images":
          {
            final List<SavedImage> images = value;
            newValue = json.encode(images);
            break;
          }
        case "listContent":
          {
            final List<ListItem> listContent = value;
            newValue = json.encode(listContent);
            break;
          }
        case "reminders":
          {
            final List<DateTime> reminders = value;
            newValue = json.encode(reminders);
            break;
          }
        case "tags":
          {
            final List<String> tags = value;
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
      int.parse(this.id.split("-")[0], radix: 16).toUnsigned(31);

  bool get pinned {
    return appInfo.activeNotifications.any(
      (e) => e.id == notificationId,
    );
  }
}

extension TagX on Tag {
  Tag markChanged() {
    return copyWith(lastModifyDate: DateTime.now());
  }
}

extension UriX on Uri {
  ImageProvider toImageProvider() {
    if (data != null) {
      return MemoryImage(data.contentAsBytes());
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
    } else
      return this[index];
  }

  T maybeGet(int index) {
    if (index >= length) {
      return null;
    } else
      return this[index];
  }
}

extension ContextProviders on BuildContext {
  ThemeData get theme => Theme.of(this);

  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get size => mediaQuery.size;
  EdgeInsets get padding => mediaQuery.padding;
  EdgeInsets get viewInsets => mediaQuery.viewInsets;
  EdgeInsets get viewPadding => mediaQuery.viewPadding;

  BasePageState get basePage => BasePage.of(this);
  TextDirection get directionality => Directionality.of(this);

  NavigatorState get navigator => Navigator.of(this);
  void pop<T extends Object>(T result) => navigator.pop<T>(result);
  Future<T> push<T extends Object>(Route<T> route) => navigator.push<T>(route);
}

class SuspendedCurve extends Curve {
  /// Creates a suspended curve.
  const SuspendedCurve(
    this.startingPoint, {
    this.curve = Curves.easeOutCubic,
  })  : assert(startingPoint != null),
        assert(curve != null);

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
    return lerpDouble(startingPoint, 1, transformed);
  }
}
