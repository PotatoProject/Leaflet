// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Note extends DataClass implements Insertable<Note> {
  final String id;
  final String title;
  final String content;
  final bool starred;
  final DateTime creationDate;
  final int color;
  final List<String> images;
  final bool list;
  final List<ListItem> listContent;
  final List<DateTime> reminders;
  final List<String> tags;
  final bool hideContent;
  final bool lockNote;
  final bool usesBiometrics;
  final String folder;
  final DateTime lastChanged;
  final DateTime? lastSynced;
  final bool? deleted;
  final bool? archived;
  Note(
      {required this.id,
      required this.title,
      required this.content,
      required this.starred,
      required this.creationDate,
      required this.color,
      required this.images,
      required this.list,
      required this.listContent,
      required this.reminders,
      required this.tags,
      required this.hideContent,
      required this.lockNote,
      required this.usesBiometrics,
      required this.folder,
      required this.lastChanged,
      this.lastSynced,
      this.deleted,
      this.archived});
  factory Note.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Note(
      id: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      title: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}title'])!,
      content: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}content'])!,
      starred: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}starred'])!,
      creationDate: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}creation_date'])!,
      color: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}color'])!,
      images: $NotesTable.$converter0.mapToDart(const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}images']))!,
      list: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}list'])!,
      listContent: $NotesTable.$converter1.mapToDart(const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}list_content']))!,
      reminders: $NotesTable.$converter2.mapToDart(const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}reminders']))!,
      tags: $NotesTable.$converter3.mapToDart(const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}tags']))!,
      hideContent: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}hide_content'])!,
      lockNote: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}lock_note'])!,
      usesBiometrics: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}uses_biometrics'])!,
      folder: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}folder'])!,
      lastChanged: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}last_changed'])!,
      lastSynced: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}last_synced']),
      deleted: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}deleted']),
      archived: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}archived']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['content'] = Variable<String>(content);
    map['starred'] = Variable<bool>(starred);
    map['creation_date'] = Variable<DateTime>(creationDate);
    map['color'] = Variable<int>(color);
    {
      final converter = $NotesTable.$converter0;
      map['images'] = Variable<String>(converter.mapToSql(images)!);
    }
    map['list'] = Variable<bool>(list);
    {
      final converter = $NotesTable.$converter1;
      map['list_content'] = Variable<String>(converter.mapToSql(listContent)!);
    }
    {
      final converter = $NotesTable.$converter2;
      map['reminders'] = Variable<String>(converter.mapToSql(reminders)!);
    }
    {
      final converter = $NotesTable.$converter3;
      map['tags'] = Variable<String>(converter.mapToSql(tags)!);
    }
    map['hide_content'] = Variable<bool>(hideContent);
    map['lock_note'] = Variable<bool>(lockNote);
    map['uses_biometrics'] = Variable<bool>(usesBiometrics);
    map['folder'] = Variable<String>(folder);
    map['last_changed'] = Variable<DateTime>(lastChanged);
    if (!nullToAbsent || lastSynced != null) {
      map['last_synced'] = Variable<DateTime?>(lastSynced);
    }
    if (!nullToAbsent || deleted != null) {
      map['deleted'] = Variable<bool?>(deleted);
    }
    if (!nullToAbsent || archived != null) {
      map['archived'] = Variable<bool?>(archived);
    }
    return map;
  }

  NotesCompanion toCompanion(bool nullToAbsent) {
    return NotesCompanion(
      id: Value(id),
      title: Value(title),
      content: Value(content),
      starred: Value(starred),
      creationDate: Value(creationDate),
      color: Value(color),
      images: Value(images),
      list: Value(list),
      listContent: Value(listContent),
      reminders: Value(reminders),
      tags: Value(tags),
      hideContent: Value(hideContent),
      lockNote: Value(lockNote),
      usesBiometrics: Value(usesBiometrics),
      folder: Value(folder),
      lastChanged: Value(lastChanged),
      lastSynced: lastSynced == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSynced),
      deleted: deleted == null && nullToAbsent
          ? const Value.absent()
          : Value(deleted),
      archived: archived == null && nullToAbsent
          ? const Value.absent()
          : Value(archived),
    );
  }

  factory Note.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Note(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      content: serializer.fromJson<String>(json['content']),
      starred: serializer.fromJson<bool>(json['starred']),
      creationDate: serializer.fromJson<DateTime>(json['creationDate']),
      color: serializer.fromJson<int>(json['color']),
      images: serializer.fromJson<List<String>>(json['images']),
      list: serializer.fromJson<bool>(json['list']),
      listContent: serializer.fromJson<List<ListItem>>(json['listContent']),
      reminders: serializer.fromJson<List<DateTime>>(json['reminders']),
      tags: serializer.fromJson<List<String>>(json['tags']),
      hideContent: serializer.fromJson<bool>(json['hideContent']),
      lockNote: serializer.fromJson<bool>(json['lockNote']),
      usesBiometrics: serializer.fromJson<bool>(json['usesBiometrics']),
      folder: serializer.fromJson<String>(json['folder']),
      lastChanged: serializer.fromJson<DateTime>(json['lastChanged']),
      lastSynced: serializer.fromJson<DateTime?>(json['lastSynced']),
      deleted: serializer.fromJson<bool?>(json['deleted']),
      archived: serializer.fromJson<bool?>(json['archived']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'content': serializer.toJson<String>(content),
      'starred': serializer.toJson<bool>(starred),
      'creationDate': serializer.toJson<DateTime>(creationDate),
      'color': serializer.toJson<int>(color),
      'images': serializer.toJson<List<String>>(images),
      'list': serializer.toJson<bool>(list),
      'listContent': serializer.toJson<List<ListItem>>(listContent),
      'reminders': serializer.toJson<List<DateTime>>(reminders),
      'tags': serializer.toJson<List<String>>(tags),
      'hideContent': serializer.toJson<bool>(hideContent),
      'lockNote': serializer.toJson<bool>(lockNote),
      'usesBiometrics': serializer.toJson<bool>(usesBiometrics),
      'folder': serializer.toJson<String>(folder),
      'lastChanged': serializer.toJson<DateTime>(lastChanged),
      'lastSynced': serializer.toJson<DateTime?>(lastSynced),
      'deleted': serializer.toJson<bool?>(deleted),
      'archived': serializer.toJson<bool?>(archived),
    };
  }

  Note copyWith(
          {String? id,
          String? title,
          String? content,
          bool? starred,
          DateTime? creationDate,
          int? color,
          List<String>? images,
          bool? list,
          List<ListItem>? listContent,
          List<DateTime>? reminders,
          List<String>? tags,
          bool? hideContent,
          bool? lockNote,
          bool? usesBiometrics,
          String? folder,
          DateTime? lastChanged,
          DateTime? lastSynced,
          bool? deleted,
          bool? archived}) =>
      Note(
        id: id ?? this.id,
        title: title ?? this.title,
        content: content ?? this.content,
        starred: starred ?? this.starred,
        creationDate: creationDate ?? this.creationDate,
        color: color ?? this.color,
        images: images ?? this.images,
        list: list ?? this.list,
        listContent: listContent ?? this.listContent,
        reminders: reminders ?? this.reminders,
        tags: tags ?? this.tags,
        hideContent: hideContent ?? this.hideContent,
        lockNote: lockNote ?? this.lockNote,
        usesBiometrics: usesBiometrics ?? this.usesBiometrics,
        folder: folder ?? this.folder,
        lastChanged: lastChanged ?? this.lastChanged,
        lastSynced: lastSynced ?? this.lastSynced,
        deleted: deleted ?? this.deleted,
        archived: archived ?? this.archived,
      );
  @override
  String toString() {
    return (StringBuffer('Note(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('starred: $starred, ')
          ..write('creationDate: $creationDate, ')
          ..write('color: $color, ')
          ..write('images: $images, ')
          ..write('list: $list, ')
          ..write('listContent: $listContent, ')
          ..write('reminders: $reminders, ')
          ..write('tags: $tags, ')
          ..write('hideContent: $hideContent, ')
          ..write('lockNote: $lockNote, ')
          ..write('usesBiometrics: $usesBiometrics, ')
          ..write('folder: $folder, ')
          ..write('lastChanged: $lastChanged, ')
          ..write('lastSynced: $lastSynced, ')
          ..write('deleted: $deleted, ')
          ..write('archived: $archived')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      title,
      content,
      starred,
      creationDate,
      color,
      images,
      list,
      listContent,
      reminders,
      tags,
      hideContent,
      lockNote,
      usesBiometrics,
      folder,
      lastChanged,
      lastSynced,
      deleted,
      archived);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Note &&
          other.id == this.id &&
          other.title == this.title &&
          other.content == this.content &&
          other.starred == this.starred &&
          other.creationDate == this.creationDate &&
          other.color == this.color &&
          other.images == this.images &&
          other.list == this.list &&
          other.listContent == this.listContent &&
          other.reminders == this.reminders &&
          other.tags == this.tags &&
          other.hideContent == this.hideContent &&
          other.lockNote == this.lockNote &&
          other.usesBiometrics == this.usesBiometrics &&
          other.folder == this.folder &&
          other.lastChanged == this.lastChanged &&
          other.lastSynced == this.lastSynced &&
          other.deleted == this.deleted &&
          other.archived == this.archived);
}

class NotesCompanion extends UpdateCompanion<Note> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> content;
  final Value<bool> starred;
  final Value<DateTime> creationDate;
  final Value<int> color;
  final Value<List<String>> images;
  final Value<bool> list;
  final Value<List<ListItem>> listContent;
  final Value<List<DateTime>> reminders;
  final Value<List<String>> tags;
  final Value<bool> hideContent;
  final Value<bool> lockNote;
  final Value<bool> usesBiometrics;
  final Value<String> folder;
  final Value<DateTime> lastChanged;
  final Value<DateTime?> lastSynced;
  final Value<bool?> deleted;
  final Value<bool?> archived;
  const NotesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.starred = const Value.absent(),
    this.creationDate = const Value.absent(),
    this.color = const Value.absent(),
    this.images = const Value.absent(),
    this.list = const Value.absent(),
    this.listContent = const Value.absent(),
    this.reminders = const Value.absent(),
    this.tags = const Value.absent(),
    this.hideContent = const Value.absent(),
    this.lockNote = const Value.absent(),
    this.usesBiometrics = const Value.absent(),
    this.folder = const Value.absent(),
    this.lastChanged = const Value.absent(),
    this.lastSynced = const Value.absent(),
    this.deleted = const Value.absent(),
    this.archived = const Value.absent(),
  });
  NotesCompanion.insert({
    required String id,
    required String title,
    required String content,
    this.starred = const Value.absent(),
    required DateTime creationDate,
    this.color = const Value.absent(),
    required List<String> images,
    this.list = const Value.absent(),
    required List<ListItem> listContent,
    required List<DateTime> reminders,
    required List<String> tags,
    this.hideContent = const Value.absent(),
    this.lockNote = const Value.absent(),
    this.usesBiometrics = const Value.absent(),
    this.folder = const Value.absent(),
    required DateTime lastChanged,
    this.lastSynced = const Value.absent(),
    this.deleted = const Value.absent(),
    this.archived = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        content = Value(content),
        creationDate = Value(creationDate),
        images = Value(images),
        listContent = Value(listContent),
        reminders = Value(reminders),
        tags = Value(tags),
        lastChanged = Value(lastChanged);
  static Insertable<Note> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? content,
    Expression<bool>? starred,
    Expression<DateTime>? creationDate,
    Expression<int>? color,
    Expression<List<String>>? images,
    Expression<bool>? list,
    Expression<List<ListItem>>? listContent,
    Expression<List<DateTime>>? reminders,
    Expression<List<String>>? tags,
    Expression<bool>? hideContent,
    Expression<bool>? lockNote,
    Expression<bool>? usesBiometrics,
    Expression<String>? folder,
    Expression<DateTime>? lastChanged,
    Expression<DateTime?>? lastSynced,
    Expression<bool?>? deleted,
    Expression<bool?>? archived,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (starred != null) 'starred': starred,
      if (creationDate != null) 'creation_date': creationDate,
      if (color != null) 'color': color,
      if (images != null) 'images': images,
      if (list != null) 'list': list,
      if (listContent != null) 'list_content': listContent,
      if (reminders != null) 'reminders': reminders,
      if (tags != null) 'tags': tags,
      if (hideContent != null) 'hide_content': hideContent,
      if (lockNote != null) 'lock_note': lockNote,
      if (usesBiometrics != null) 'uses_biometrics': usesBiometrics,
      if (folder != null) 'folder': folder,
      if (lastChanged != null) 'last_changed': lastChanged,
      if (lastSynced != null) 'last_synced': lastSynced,
      if (deleted != null) 'deleted': deleted,
      if (archived != null) 'archived': archived,
    });
  }

  NotesCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? content,
      Value<bool>? starred,
      Value<DateTime>? creationDate,
      Value<int>? color,
      Value<List<String>>? images,
      Value<bool>? list,
      Value<List<ListItem>>? listContent,
      Value<List<DateTime>>? reminders,
      Value<List<String>>? tags,
      Value<bool>? hideContent,
      Value<bool>? lockNote,
      Value<bool>? usesBiometrics,
      Value<String>? folder,
      Value<DateTime>? lastChanged,
      Value<DateTime?>? lastSynced,
      Value<bool?>? deleted,
      Value<bool?>? archived}) {
    return NotesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      starred: starred ?? this.starred,
      creationDate: creationDate ?? this.creationDate,
      color: color ?? this.color,
      images: images ?? this.images,
      list: list ?? this.list,
      listContent: listContent ?? this.listContent,
      reminders: reminders ?? this.reminders,
      tags: tags ?? this.tags,
      hideContent: hideContent ?? this.hideContent,
      lockNote: lockNote ?? this.lockNote,
      usesBiometrics: usesBiometrics ?? this.usesBiometrics,
      folder: folder ?? this.folder,
      lastChanged: lastChanged ?? this.lastChanged,
      lastSynced: lastSynced ?? this.lastSynced,
      deleted: deleted ?? this.deleted,
      archived: archived ?? this.archived,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (starred.present) {
      map['starred'] = Variable<bool>(starred.value);
    }
    if (creationDate.present) {
      map['creation_date'] = Variable<DateTime>(creationDate.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (images.present) {
      final converter = $NotesTable.$converter0;
      map['images'] = Variable<String>(converter.mapToSql(images.value)!);
    }
    if (list.present) {
      map['list'] = Variable<bool>(list.value);
    }
    if (listContent.present) {
      final converter = $NotesTable.$converter1;
      map['list_content'] =
          Variable<String>(converter.mapToSql(listContent.value)!);
    }
    if (reminders.present) {
      final converter = $NotesTable.$converter2;
      map['reminders'] = Variable<String>(converter.mapToSql(reminders.value)!);
    }
    if (tags.present) {
      final converter = $NotesTable.$converter3;
      map['tags'] = Variable<String>(converter.mapToSql(tags.value)!);
    }
    if (hideContent.present) {
      map['hide_content'] = Variable<bool>(hideContent.value);
    }
    if (lockNote.present) {
      map['lock_note'] = Variable<bool>(lockNote.value);
    }
    if (usesBiometrics.present) {
      map['uses_biometrics'] = Variable<bool>(usesBiometrics.value);
    }
    if (folder.present) {
      map['folder'] = Variable<String>(folder.value);
    }
    if (lastChanged.present) {
      map['last_changed'] = Variable<DateTime>(lastChanged.value);
    }
    if (lastSynced.present) {
      map['last_synced'] = Variable<DateTime?>(lastSynced.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool?>(deleted.value);
    }
    if (archived.present) {
      map['archived'] = Variable<bool?>(archived.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('starred: $starred, ')
          ..write('creationDate: $creationDate, ')
          ..write('color: $color, ')
          ..write('images: $images, ')
          ..write('list: $list, ')
          ..write('listContent: $listContent, ')
          ..write('reminders: $reminders, ')
          ..write('tags: $tags, ')
          ..write('hideContent: $hideContent, ')
          ..write('lockNote: $lockNote, ')
          ..write('usesBiometrics: $usesBiometrics, ')
          ..write('folder: $folder, ')
          ..write('lastChanged: $lastChanged, ')
          ..write('lastSynced: $lastSynced, ')
          ..write('deleted: $deleted, ')
          ..write('archived: $archived')
          ..write(')'))
        .toString();
  }
}

class $NotesTable extends Notes with TableInfo<$NotesTable, Note> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotesTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String?> id = GeneratedColumn<String?>(
      'id', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String?> title = GeneratedColumn<String?>(
      'title', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _contentMeta = const VerificationMeta('content');
  @override
  late final GeneratedColumn<String?> content = GeneratedColumn<String?>(
      'content', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _starredMeta = const VerificationMeta('starred');
  @override
  late final GeneratedColumn<bool?> starred = GeneratedColumn<bool?>(
      'starred', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (starred IN (0, 1))',
      defaultValue: const Constant(false));
  final VerificationMeta _creationDateMeta =
      const VerificationMeta('creationDate');
  @override
  late final GeneratedColumn<DateTime?> creationDate =
      GeneratedColumn<DateTime?>('creation_date', aliasedName, false,
          type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int?> color = GeneratedColumn<int?>(
      'color', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  final VerificationMeta _imagesMeta = const VerificationMeta('images');
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String?> images =
      GeneratedColumn<String?>('images', aliasedName, false,
              type: const StringType(), requiredDuringInsert: true)
          .withConverter<List<String>>($NotesTable.$converter0);
  final VerificationMeta _listMeta = const VerificationMeta('list');
  @override
  late final GeneratedColumn<bool?> list = GeneratedColumn<bool?>(
      'list', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (list IN (0, 1))',
      defaultValue: const Constant(false));
  final VerificationMeta _listContentMeta =
      const VerificationMeta('listContent');
  @override
  late final GeneratedColumnWithTypeConverter<List<ListItem>, String?>
      listContent = GeneratedColumn<String?>('list_content', aliasedName, false,
              type: const StringType(), requiredDuringInsert: true)
          .withConverter<List<ListItem>>($NotesTable.$converter1);
  final VerificationMeta _remindersMeta = const VerificationMeta('reminders');
  @override
  late final GeneratedColumnWithTypeConverter<List<DateTime>, String?>
      reminders = GeneratedColumn<String?>('reminders', aliasedName, false,
              type: const StringType(), requiredDuringInsert: true)
          .withConverter<List<DateTime>>($NotesTable.$converter2);
  final VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String?> tags =
      GeneratedColumn<String?>('tags', aliasedName, false,
              type: const StringType(), requiredDuringInsert: true)
          .withConverter<List<String>>($NotesTable.$converter3);
  final VerificationMeta _hideContentMeta =
      const VerificationMeta('hideContent');
  @override
  late final GeneratedColumn<bool?> hideContent = GeneratedColumn<bool?>(
      'hide_content', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (hide_content IN (0, 1))',
      defaultValue: const Constant(false));
  final VerificationMeta _lockNoteMeta = const VerificationMeta('lockNote');
  @override
  late final GeneratedColumn<bool?> lockNote = GeneratedColumn<bool?>(
      'lock_note', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (lock_note IN (0, 1))',
      defaultValue: const Constant(false));
  final VerificationMeta _usesBiometricsMeta =
      const VerificationMeta('usesBiometrics');
  @override
  late final GeneratedColumn<bool?> usesBiometrics = GeneratedColumn<bool?>(
      'uses_biometrics', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (uses_biometrics IN (0, 1))',
      defaultValue: const Constant(false));
  final VerificationMeta _folderMeta = const VerificationMeta('folder');
  @override
  late final GeneratedColumn<String?> folder = GeneratedColumn<String?>(
      'folder', aliasedName, false,
      type: const StringType(),
      requiredDuringInsert: false,
      defaultValue: const Constant('default'));
  final VerificationMeta _lastChangedMeta =
      const VerificationMeta('lastChanged');
  @override
  late final GeneratedColumn<DateTime?> lastChanged =
      GeneratedColumn<DateTime?>('last_changed', aliasedName, false,
          type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _lastSyncedMeta = const VerificationMeta('lastSynced');
  @override
  late final GeneratedColumn<DateTime?> lastSynced = GeneratedColumn<DateTime?>(
      'last_synced', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _deletedMeta = const VerificationMeta('deleted');
  @override
  late final GeneratedColumn<bool?> deleted = GeneratedColumn<bool?>(
      'deleted', aliasedName, true,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (deleted IN (0, 1))',
      defaultValue: const Constant(false));
  final VerificationMeta _archivedMeta = const VerificationMeta('archived');
  @override
  late final GeneratedColumn<bool?> archived = GeneratedColumn<bool?>(
      'archived', aliasedName, true,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (archived IN (0, 1))',
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        content,
        starred,
        creationDate,
        color,
        images,
        list,
        listContent,
        reminders,
        tags,
        hideContent,
        lockNote,
        usesBiometrics,
        folder,
        lastChanged,
        lastSynced,
        deleted,
        archived
      ];
  @override
  String get aliasedName => _alias ?? 'notes';
  @override
  String get actualTableName => 'notes';
  @override
  VerificationContext validateIntegrity(Insertable<Note> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('starred')) {
      context.handle(_starredMeta,
          starred.isAcceptableOrUnknown(data['starred']!, _starredMeta));
    }
    if (data.containsKey('creation_date')) {
      context.handle(
          _creationDateMeta,
          creationDate.isAcceptableOrUnknown(
              data['creation_date']!, _creationDateMeta));
    } else if (isInserting) {
      context.missing(_creationDateMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    }
    context.handle(_imagesMeta, const VerificationResult.success());
    if (data.containsKey('list')) {
      context.handle(
          _listMeta, list.isAcceptableOrUnknown(data['list']!, _listMeta));
    }
    context.handle(_listContentMeta, const VerificationResult.success());
    context.handle(_remindersMeta, const VerificationResult.success());
    context.handle(_tagsMeta, const VerificationResult.success());
    if (data.containsKey('hide_content')) {
      context.handle(
          _hideContentMeta,
          hideContent.isAcceptableOrUnknown(
              data['hide_content']!, _hideContentMeta));
    }
    if (data.containsKey('lock_note')) {
      context.handle(_lockNoteMeta,
          lockNote.isAcceptableOrUnknown(data['lock_note']!, _lockNoteMeta));
    }
    if (data.containsKey('uses_biometrics')) {
      context.handle(
          _usesBiometricsMeta,
          usesBiometrics.isAcceptableOrUnknown(
              data['uses_biometrics']!, _usesBiometricsMeta));
    }
    if (data.containsKey('folder')) {
      context.handle(_folderMeta,
          folder.isAcceptableOrUnknown(data['folder']!, _folderMeta));
    }
    if (data.containsKey('last_changed')) {
      context.handle(
          _lastChangedMeta,
          lastChanged.isAcceptableOrUnknown(
              data['last_changed']!, _lastChangedMeta));
    } else if (isInserting) {
      context.missing(_lastChangedMeta);
    }
    if (data.containsKey('last_synced')) {
      context.handle(
          _lastSyncedMeta,
          lastSynced.isAcceptableOrUnknown(
              data['last_synced']!, _lastSyncedMeta));
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta,
          deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    }
    if (data.containsKey('archived')) {
      context.handle(_archivedMeta,
          archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Note map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Note.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $NotesTable createAlias(String alias) {
    return $NotesTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $converter0 =
      const IdListConverter();
  static TypeConverter<List<ListItem>, String> $converter1 =
      const ListContentConverter();
  static TypeConverter<List<DateTime>, String> $converter2 =
      const ReminderListConverter();
  static TypeConverter<List<String>, String> $converter3 =
      const IdListConverter();
}

class Tag extends DataClass implements Insertable<Tag> {
  final String id;
  final String name;
  final DateTime lastChanged;
  final DateTime? lastSynced;
  Tag(
      {required this.id,
      required this.name,
      required this.lastChanged,
      this.lastSynced});
  factory Tag.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Tag(
      id: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
      lastChanged: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}last_changed'])!,
      lastSynced: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}last_synced']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['last_changed'] = Variable<DateTime>(lastChanged);
    if (!nullToAbsent || lastSynced != null) {
      map['last_synced'] = Variable<DateTime?>(lastSynced);
    }
    return map;
  }

  TagsCompanion toCompanion(bool nullToAbsent) {
    return TagsCompanion(
      id: Value(id),
      name: Value(name),
      lastChanged: Value(lastChanged),
      lastSynced: lastSynced == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSynced),
    );
  }

  factory Tag.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tag(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      lastChanged: serializer.fromJson<DateTime>(json['lastChanged']),
      lastSynced: serializer.fromJson<DateTime?>(json['lastSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'lastChanged': serializer.toJson<DateTime>(lastChanged),
      'lastSynced': serializer.toJson<DateTime?>(lastSynced),
    };
  }

  Tag copyWith(
          {String? id,
          String? name,
          DateTime? lastChanged,
          DateTime? lastSynced}) =>
      Tag(
        id: id ?? this.id,
        name: name ?? this.name,
        lastChanged: lastChanged ?? this.lastChanged,
        lastSynced: lastSynced ?? this.lastSynced,
      );
  @override
  String toString() {
    return (StringBuffer('Tag(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('lastChanged: $lastChanged, ')
          ..write('lastSynced: $lastSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, lastChanged, lastSynced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tag &&
          other.id == this.id &&
          other.name == this.name &&
          other.lastChanged == this.lastChanged &&
          other.lastSynced == this.lastSynced);
}

class TagsCompanion extends UpdateCompanion<Tag> {
  final Value<String> id;
  final Value<String> name;
  final Value<DateTime> lastChanged;
  final Value<DateTime?> lastSynced;
  const TagsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.lastChanged = const Value.absent(),
    this.lastSynced = const Value.absent(),
  });
  TagsCompanion.insert({
    required String id,
    required String name,
    required DateTime lastChanged,
    this.lastSynced = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        lastChanged = Value(lastChanged);
  static Insertable<Tag> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<DateTime>? lastChanged,
    Expression<DateTime?>? lastSynced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (lastChanged != null) 'last_changed': lastChanged,
      if (lastSynced != null) 'last_synced': lastSynced,
    });
  }

  TagsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<DateTime>? lastChanged,
      Value<DateTime?>? lastSynced}) {
    return TagsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      lastChanged: lastChanged ?? this.lastChanged,
      lastSynced: lastSynced ?? this.lastSynced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (lastChanged.present) {
      map['last_changed'] = Variable<DateTime>(lastChanged.value);
    }
    if (lastSynced.present) {
      map['last_synced'] = Variable<DateTime?>(lastSynced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TagsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('lastChanged: $lastChanged, ')
          ..write('lastSynced: $lastSynced')
          ..write(')'))
        .toString();
  }
}

class $TagsTable extends Tags with TableInfo<$TagsTable, Tag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TagsTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String?> id = GeneratedColumn<String?>(
      'id', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String?> name = GeneratedColumn<String?>(
      'name', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _lastChangedMeta =
      const VerificationMeta('lastChanged');
  @override
  late final GeneratedColumn<DateTime?> lastChanged =
      GeneratedColumn<DateTime?>('last_changed', aliasedName, false,
          type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _lastSyncedMeta = const VerificationMeta('lastSynced');
  @override
  late final GeneratedColumn<DateTime?> lastSynced = GeneratedColumn<DateTime?>(
      'last_synced', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, name, lastChanged, lastSynced];
  @override
  String get aliasedName => _alias ?? 'tags';
  @override
  String get actualTableName => 'tags';
  @override
  VerificationContext validateIntegrity(Insertable<Tag> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('last_changed')) {
      context.handle(
          _lastChangedMeta,
          lastChanged.isAcceptableOrUnknown(
              data['last_changed']!, _lastChangedMeta));
    } else if (isInserting) {
      context.missing(_lastChangedMeta);
    }
    if (data.containsKey('last_synced')) {
      context.handle(
          _lastSyncedMeta,
          lastSynced.isAcceptableOrUnknown(
              data['last_synced']!, _lastSyncedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Tag map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Tag.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $TagsTable createAlias(String alias) {
    return $TagsTable(attachedDatabase, alias);
  }
}

class Folder extends DataClass implements Insertable<Folder> {
  final String id;
  final String name;
  final int icon;
  final int color;
  final bool readOnly;
  final DateTime lastChanged;
  final DateTime? lastSynced;
  Folder(
      {required this.id,
      required this.name,
      required this.icon,
      required this.color,
      required this.readOnly,
      required this.lastChanged,
      this.lastSynced});
  factory Folder.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Folder(
      id: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
      icon: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}icon'])!,
      color: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}color'])!,
      readOnly: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}read_only'])!,
      lastChanged: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}last_changed'])!,
      lastSynced: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}last_synced']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['icon'] = Variable<int>(icon);
    map['color'] = Variable<int>(color);
    map['read_only'] = Variable<bool>(readOnly);
    map['last_changed'] = Variable<DateTime>(lastChanged);
    if (!nullToAbsent || lastSynced != null) {
      map['last_synced'] = Variable<DateTime?>(lastSynced);
    }
    return map;
  }

  FoldersCompanion toCompanion(bool nullToAbsent) {
    return FoldersCompanion(
      id: Value(id),
      name: Value(name),
      icon: Value(icon),
      color: Value(color),
      readOnly: Value(readOnly),
      lastChanged: Value(lastChanged),
      lastSynced: lastSynced == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSynced),
    );
  }

  factory Folder.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Folder(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      icon: serializer.fromJson<int>(json['icon']),
      color: serializer.fromJson<int>(json['color']),
      readOnly: serializer.fromJson<bool>(json['readOnly']),
      lastChanged: serializer.fromJson<DateTime>(json['lastChanged']),
      lastSynced: serializer.fromJson<DateTime?>(json['lastSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'icon': serializer.toJson<int>(icon),
      'color': serializer.toJson<int>(color),
      'readOnly': serializer.toJson<bool>(readOnly),
      'lastChanged': serializer.toJson<DateTime>(lastChanged),
      'lastSynced': serializer.toJson<DateTime?>(lastSynced),
    };
  }

  Folder copyWith(
          {String? id,
          String? name,
          int? icon,
          int? color,
          bool? readOnly,
          DateTime? lastChanged,
          DateTime? lastSynced}) =>
      Folder(
        id: id ?? this.id,
        name: name ?? this.name,
        icon: icon ?? this.icon,
        color: color ?? this.color,
        readOnly: readOnly ?? this.readOnly,
        lastChanged: lastChanged ?? this.lastChanged,
        lastSynced: lastSynced ?? this.lastSynced,
      );
  @override
  String toString() {
    return (StringBuffer('Folder(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('readOnly: $readOnly, ')
          ..write('lastChanged: $lastChanged, ')
          ..write('lastSynced: $lastSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, icon, color, readOnly, lastChanged, lastSynced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Folder &&
          other.id == this.id &&
          other.name == this.name &&
          other.icon == this.icon &&
          other.color == this.color &&
          other.readOnly == this.readOnly &&
          other.lastChanged == this.lastChanged &&
          other.lastSynced == this.lastSynced);
}

class FoldersCompanion extends UpdateCompanion<Folder> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> icon;
  final Value<int> color;
  final Value<bool> readOnly;
  final Value<DateTime> lastChanged;
  final Value<DateTime?> lastSynced;
  const FoldersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    this.readOnly = const Value.absent(),
    this.lastChanged = const Value.absent(),
    this.lastSynced = const Value.absent(),
  });
  FoldersCompanion.insert({
    required String id,
    required String name,
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    this.readOnly = const Value.absent(),
    required DateTime lastChanged,
    this.lastSynced = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        lastChanged = Value(lastChanged);
  static Insertable<Folder> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? icon,
    Expression<int>? color,
    Expression<bool>? readOnly,
    Expression<DateTime>? lastChanged,
    Expression<DateTime?>? lastSynced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (icon != null) 'icon': icon,
      if (color != null) 'color': color,
      if (readOnly != null) 'read_only': readOnly,
      if (lastChanged != null) 'last_changed': lastChanged,
      if (lastSynced != null) 'last_synced': lastSynced,
    });
  }

  FoldersCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<int>? icon,
      Value<int>? color,
      Value<bool>? readOnly,
      Value<DateTime>? lastChanged,
      Value<DateTime?>? lastSynced}) {
    return FoldersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      readOnly: readOnly ?? this.readOnly,
      lastChanged: lastChanged ?? this.lastChanged,
      lastSynced: lastSynced ?? this.lastSynced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (icon.present) {
      map['icon'] = Variable<int>(icon.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (readOnly.present) {
      map['read_only'] = Variable<bool>(readOnly.value);
    }
    if (lastChanged.present) {
      map['last_changed'] = Variable<DateTime>(lastChanged.value);
    }
    if (lastSynced.present) {
      map['last_synced'] = Variable<DateTime?>(lastSynced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FoldersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('readOnly: $readOnly, ')
          ..write('lastChanged: $lastChanged, ')
          ..write('lastSynced: $lastSynced')
          ..write(')'))
        .toString();
  }
}

class $FoldersTable extends Folders with TableInfo<$FoldersTable, Folder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FoldersTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String?> id = GeneratedColumn<String?>(
      'id', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String?> name = GeneratedColumn<String?>(
      'name', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<int?> icon = GeneratedColumn<int?>(
      'icon', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  final VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int?> color = GeneratedColumn<int?>(
      'color', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  final VerificationMeta _readOnlyMeta = const VerificationMeta('readOnly');
  @override
  late final GeneratedColumn<bool?> readOnly = GeneratedColumn<bool?>(
      'read_only', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (read_only IN (0, 1))',
      defaultValue: const Constant(false));
  final VerificationMeta _lastChangedMeta =
      const VerificationMeta('lastChanged');
  @override
  late final GeneratedColumn<DateTime?> lastChanged =
      GeneratedColumn<DateTime?>('last_changed', aliasedName, false,
          type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _lastSyncedMeta = const VerificationMeta('lastSynced');
  @override
  late final GeneratedColumn<DateTime?> lastSynced = GeneratedColumn<DateTime?>(
      'last_synced', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, icon, color, readOnly, lastChanged, lastSynced];
  @override
  String get aliasedName => _alias ?? 'folders';
  @override
  String get actualTableName => 'folders';
  @override
  VerificationContext validateIntegrity(Insertable<Folder> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
          _iconMeta, icon.isAcceptableOrUnknown(data['icon']!, _iconMeta));
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    }
    if (data.containsKey('read_only')) {
      context.handle(_readOnlyMeta,
          readOnly.isAcceptableOrUnknown(data['read_only']!, _readOnlyMeta));
    }
    if (data.containsKey('last_changed')) {
      context.handle(
          _lastChangedMeta,
          lastChanged.isAcceptableOrUnknown(
              data['last_changed']!, _lastChangedMeta));
    } else if (isInserting) {
      context.missing(_lastChangedMeta);
    }
    if (data.containsKey('last_synced')) {
      context.handle(
          _lastSyncedMeta,
          lastSynced.isAcceptableOrUnknown(
              data['last_synced']!, _lastSyncedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Folder map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Folder.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $FoldersTable createAlias(String alias) {
    return $FoldersTable(attachedDatabase, alias);
  }
}

class NoteImage extends DataClass implements Insertable<NoteImage> {
  final String id;
  final String? hash;
  final String? blurHash;
  final String type;
  final int width;
  final int height;
  final bool uploaded;
  final DateTime lastChanged;
  final DateTime? lastSynced;
  NoteImage(
      {required this.id,
      this.hash,
      this.blurHash,
      required this.type,
      required this.width,
      required this.height,
      required this.uploaded,
      required this.lastChanged,
      this.lastSynced});
  factory NoteImage.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return NoteImage(
      id: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      hash: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}hash']),
      blurHash: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}blur_hash']),
      type: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}type'])!,
      width: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}width'])!,
      height: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}height'])!,
      uploaded: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}uploaded'])!,
      lastChanged: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}last_changed'])!,
      lastSynced: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}last_synced']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || hash != null) {
      map['hash'] = Variable<String?>(hash);
    }
    if (!nullToAbsent || blurHash != null) {
      map['blur_hash'] = Variable<String?>(blurHash);
    }
    map['type'] = Variable<String>(type);
    map['width'] = Variable<int>(width);
    map['height'] = Variable<int>(height);
    map['uploaded'] = Variable<bool>(uploaded);
    map['last_changed'] = Variable<DateTime>(lastChanged);
    if (!nullToAbsent || lastSynced != null) {
      map['last_synced'] = Variable<DateTime?>(lastSynced);
    }
    return map;
  }

  NoteImagesCompanion toCompanion(bool nullToAbsent) {
    return NoteImagesCompanion(
      id: Value(id),
      hash: hash == null && nullToAbsent ? const Value.absent() : Value(hash),
      blurHash: blurHash == null && nullToAbsent
          ? const Value.absent()
          : Value(blurHash),
      type: Value(type),
      width: Value(width),
      height: Value(height),
      uploaded: Value(uploaded),
      lastChanged: Value(lastChanged),
      lastSynced: lastSynced == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSynced),
    );
  }

  factory NoteImage.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NoteImage(
      id: serializer.fromJson<String>(json['id']),
      hash: serializer.fromJson<String?>(json['hash']),
      blurHash: serializer.fromJson<String?>(json['blurHash']),
      type: serializer.fromJson<String>(json['type']),
      width: serializer.fromJson<int>(json['width']),
      height: serializer.fromJson<int>(json['height']),
      uploaded: serializer.fromJson<bool>(json['uploaded']),
      lastChanged: serializer.fromJson<DateTime>(json['lastChanged']),
      lastSynced: serializer.fromJson<DateTime?>(json['lastSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'hash': serializer.toJson<String?>(hash),
      'blurHash': serializer.toJson<String?>(blurHash),
      'type': serializer.toJson<String>(type),
      'width': serializer.toJson<int>(width),
      'height': serializer.toJson<int>(height),
      'uploaded': serializer.toJson<bool>(uploaded),
      'lastChanged': serializer.toJson<DateTime>(lastChanged),
      'lastSynced': serializer.toJson<DateTime?>(lastSynced),
    };
  }

  NoteImage copyWith(
          {String? id,
          String? hash,
          String? blurHash,
          String? type,
          int? width,
          int? height,
          bool? uploaded,
          DateTime? lastChanged,
          DateTime? lastSynced}) =>
      NoteImage(
        id: id ?? this.id,
        hash: hash ?? this.hash,
        blurHash: blurHash ?? this.blurHash,
        type: type ?? this.type,
        width: width ?? this.width,
        height: height ?? this.height,
        uploaded: uploaded ?? this.uploaded,
        lastChanged: lastChanged ?? this.lastChanged,
        lastSynced: lastSynced ?? this.lastSynced,
      );
  @override
  String toString() {
    return (StringBuffer('NoteImage(')
          ..write('id: $id, ')
          ..write('hash: $hash, ')
          ..write('blurHash: $blurHash, ')
          ..write('type: $type, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('uploaded: $uploaded, ')
          ..write('lastChanged: $lastChanged, ')
          ..write('lastSynced: $lastSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, hash, blurHash, type, width, height,
      uploaded, lastChanged, lastSynced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NoteImage &&
          other.id == this.id &&
          other.hash == this.hash &&
          other.blurHash == this.blurHash &&
          other.type == this.type &&
          other.width == this.width &&
          other.height == this.height &&
          other.uploaded == this.uploaded &&
          other.lastChanged == this.lastChanged &&
          other.lastSynced == this.lastSynced);
}

class NoteImagesCompanion extends UpdateCompanion<NoteImage> {
  final Value<String> id;
  final Value<String?> hash;
  final Value<String?> blurHash;
  final Value<String> type;
  final Value<int> width;
  final Value<int> height;
  final Value<bool> uploaded;
  final Value<DateTime> lastChanged;
  final Value<DateTime?> lastSynced;
  const NoteImagesCompanion({
    this.id = const Value.absent(),
    this.hash = const Value.absent(),
    this.blurHash = const Value.absent(),
    this.type = const Value.absent(),
    this.width = const Value.absent(),
    this.height = const Value.absent(),
    this.uploaded = const Value.absent(),
    this.lastChanged = const Value.absent(),
    this.lastSynced = const Value.absent(),
  });
  NoteImagesCompanion.insert({
    required String id,
    this.hash = const Value.absent(),
    this.blurHash = const Value.absent(),
    required String type,
    required int width,
    required int height,
    this.uploaded = const Value.absent(),
    required DateTime lastChanged,
    this.lastSynced = const Value.absent(),
  })  : id = Value(id),
        type = Value(type),
        width = Value(width),
        height = Value(height),
        lastChanged = Value(lastChanged);
  static Insertable<NoteImage> custom({
    Expression<String>? id,
    Expression<String?>? hash,
    Expression<String?>? blurHash,
    Expression<String>? type,
    Expression<int>? width,
    Expression<int>? height,
    Expression<bool>? uploaded,
    Expression<DateTime>? lastChanged,
    Expression<DateTime?>? lastSynced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (hash != null) 'hash': hash,
      if (blurHash != null) 'blur_hash': blurHash,
      if (type != null) 'type': type,
      if (width != null) 'width': width,
      if (height != null) 'height': height,
      if (uploaded != null) 'uploaded': uploaded,
      if (lastChanged != null) 'last_changed': lastChanged,
      if (lastSynced != null) 'last_synced': lastSynced,
    });
  }

  NoteImagesCompanion copyWith(
      {Value<String>? id,
      Value<String?>? hash,
      Value<String?>? blurHash,
      Value<String>? type,
      Value<int>? width,
      Value<int>? height,
      Value<bool>? uploaded,
      Value<DateTime>? lastChanged,
      Value<DateTime?>? lastSynced}) {
    return NoteImagesCompanion(
      id: id ?? this.id,
      hash: hash ?? this.hash,
      blurHash: blurHash ?? this.blurHash,
      type: type ?? this.type,
      width: width ?? this.width,
      height: height ?? this.height,
      uploaded: uploaded ?? this.uploaded,
      lastChanged: lastChanged ?? this.lastChanged,
      lastSynced: lastSynced ?? this.lastSynced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (hash.present) {
      map['hash'] = Variable<String?>(hash.value);
    }
    if (blurHash.present) {
      map['blur_hash'] = Variable<String?>(blurHash.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (width.present) {
      map['width'] = Variable<int>(width.value);
    }
    if (height.present) {
      map['height'] = Variable<int>(height.value);
    }
    if (uploaded.present) {
      map['uploaded'] = Variable<bool>(uploaded.value);
    }
    if (lastChanged.present) {
      map['last_changed'] = Variable<DateTime>(lastChanged.value);
    }
    if (lastSynced.present) {
      map['last_synced'] = Variable<DateTime?>(lastSynced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NoteImagesCompanion(')
          ..write('id: $id, ')
          ..write('hash: $hash, ')
          ..write('blurHash: $blurHash, ')
          ..write('type: $type, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('uploaded: $uploaded, ')
          ..write('lastChanged: $lastChanged, ')
          ..write('lastSynced: $lastSynced')
          ..write(')'))
        .toString();
  }
}

class $NoteImagesTable extends NoteImages
    with TableInfo<$NoteImagesTable, NoteImage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NoteImagesTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String?> id = GeneratedColumn<String?>(
      'id', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _hashMeta = const VerificationMeta('hash');
  @override
  late final GeneratedColumn<String?> hash = GeneratedColumn<String?>(
      'hash', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _blurHashMeta = const VerificationMeta('blurHash');
  @override
  late final GeneratedColumn<String?> blurHash = GeneratedColumn<String?>(
      'blur_hash', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String?> type = GeneratedColumn<String?>(
      'type', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _widthMeta = const VerificationMeta('width');
  @override
  late final GeneratedColumn<int?> width = GeneratedColumn<int?>(
      'width', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _heightMeta = const VerificationMeta('height');
  @override
  late final GeneratedColumn<int?> height = GeneratedColumn<int?>(
      'height', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _uploadedMeta = const VerificationMeta('uploaded');
  @override
  late final GeneratedColumn<bool?> uploaded = GeneratedColumn<bool?>(
      'uploaded', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (uploaded IN (0, 1))',
      defaultValue: const Constant(false));
  final VerificationMeta _lastChangedMeta =
      const VerificationMeta('lastChanged');
  @override
  late final GeneratedColumn<DateTime?> lastChanged =
      GeneratedColumn<DateTime?>('last_changed', aliasedName, false,
          type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _lastSyncedMeta = const VerificationMeta('lastSynced');
  @override
  late final GeneratedColumn<DateTime?> lastSynced = GeneratedColumn<DateTime?>(
      'last_synced', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        hash,
        blurHash,
        type,
        width,
        height,
        uploaded,
        lastChanged,
        lastSynced
      ];
  @override
  String get aliasedName => _alias ?? 'images';
  @override
  String get actualTableName => 'images';
  @override
  VerificationContext validateIntegrity(Insertable<NoteImage> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('hash')) {
      context.handle(
          _hashMeta, hash.isAcceptableOrUnknown(data['hash']!, _hashMeta));
    }
    if (data.containsKey('blur_hash')) {
      context.handle(_blurHashMeta,
          blurHash.isAcceptableOrUnknown(data['blur_hash']!, _blurHashMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('width')) {
      context.handle(
          _widthMeta, width.isAcceptableOrUnknown(data['width']!, _widthMeta));
    } else if (isInserting) {
      context.missing(_widthMeta);
    }
    if (data.containsKey('height')) {
      context.handle(_heightMeta,
          height.isAcceptableOrUnknown(data['height']!, _heightMeta));
    } else if (isInserting) {
      context.missing(_heightMeta);
    }
    if (data.containsKey('uploaded')) {
      context.handle(_uploadedMeta,
          uploaded.isAcceptableOrUnknown(data['uploaded']!, _uploadedMeta));
    }
    if (data.containsKey('last_changed')) {
      context.handle(
          _lastChangedMeta,
          lastChanged.isAcceptableOrUnknown(
              data['last_changed']!, _lastChangedMeta));
    } else if (isInserting) {
      context.missing(_lastChangedMeta);
    }
    if (data.containsKey('last_synced')) {
      context.handle(
          _lastSyncedMeta,
          lastSynced.isAcceptableOrUnknown(
              data['last_synced']!, _lastSyncedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NoteImage map(Map<String, dynamic> data, {String? tablePrefix}) {
    return NoteImage.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $NoteImagesTable createAlias(String alias) {
    return $NoteImagesTable(attachedDatabase, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $NotesTable notes = $NotesTable(this);
  late final $TagsTable tags = $TagsTable(this);
  late final $FoldersTable folders = $FoldersTable(this);
  late final $NoteImagesTable noteImages = $NoteImagesTable(this);
  late final NoteHelper noteHelper = NoteHelper(this as AppDatabase);
  late final TagHelper tagHelper = TagHelper(this as AppDatabase);
  late final FolderHelper folderHelper = FolderHelper(this as AppDatabase);
  late final ImageHelper imageHelper = ImageHelper(this as AppDatabase);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [notes, tags, folders, noteImages];
}
