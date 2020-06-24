// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Note extends DataClass implements Insertable<Note> {
  final int id;
  final String title;
  final String content;
  final ContentStyle styleJson;
  final bool starred;
  final DateTime creationDate;
  final DateTime lastModifyDate;
  final int color;
  final ImageList images;
  final bool list;
  final ListContent listContent;
  final ReminderList reminders;
  final bool hideContent;
  final bool lockNote;
  final bool usesBiometrics;
  final bool deleted;
  final bool archived;
  final bool synced;
  Note(
      {@required this.id,
      this.title,
      this.content,
      @required this.styleJson,
      @required this.starred,
      @required this.creationDate,
      @required this.lastModifyDate,
      @required this.color,
      @required this.images,
      @required this.list,
      @required this.listContent,
      @required this.reminders,
      @required this.hideContent,
      @required this.lockNote,
      @required this.usesBiometrics,
      @required this.deleted,
      @required this.archived,
      @required this.synced});
  factory Note.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final boolType = db.typeSystem.forDartType<bool>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return Note(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      title:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}title']),
      content:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}content']),
      styleJson: $NotesTable.$converter0.mapToDart(stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}style_json'])),
      starred:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}starred']),
      creationDate: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}creation_date']),
      lastModifyDate: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}last_modify_date']),
      color: intType.mapFromDatabaseResponse(data['${effectivePrefix}color']),
      images: $NotesTable.$converter1.mapToDart(
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}images'])),
      list: boolType.mapFromDatabaseResponse(data['${effectivePrefix}list']),
      listContent: $NotesTable.$converter2.mapToDart(stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}list_content'])),
      reminders: $NotesTable.$converter3.mapToDart(stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}reminders'])),
      hideContent: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}hide_content']),
      lockNote:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}lock_note']),
      usesBiometrics: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}uses_biometrics']),
      deleted:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}deleted']),
      archived:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}archived']),
      synced:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}synced']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || content != null) {
      map['content'] = Variable<String>(content);
    }
    if (!nullToAbsent || styleJson != null) {
      final converter = $NotesTable.$converter0;
      map['style_json'] = Variable<String>(converter.mapToSql(styleJson));
    }
    if (!nullToAbsent || starred != null) {
      map['starred'] = Variable<bool>(starred);
    }
    if (!nullToAbsent || creationDate != null) {
      map['creation_date'] = Variable<DateTime>(creationDate);
    }
    if (!nullToAbsent || lastModifyDate != null) {
      map['last_modify_date'] = Variable<DateTime>(lastModifyDate);
    }
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<int>(color);
    }
    if (!nullToAbsent || images != null) {
      final converter = $NotesTable.$converter1;
      map['images'] = Variable<String>(converter.mapToSql(images));
    }
    if (!nullToAbsent || list != null) {
      map['list'] = Variable<bool>(list);
    }
    if (!nullToAbsent || listContent != null) {
      final converter = $NotesTable.$converter2;
      map['list_content'] = Variable<String>(converter.mapToSql(listContent));
    }
    if (!nullToAbsent || reminders != null) {
      final converter = $NotesTable.$converter3;
      map['reminders'] = Variable<String>(converter.mapToSql(reminders));
    }
    if (!nullToAbsent || hideContent != null) {
      map['hide_content'] = Variable<bool>(hideContent);
    }
    if (!nullToAbsent || lockNote != null) {
      map['lock_note'] = Variable<bool>(lockNote);
    }
    if (!nullToAbsent || usesBiometrics != null) {
      map['uses_biometrics'] = Variable<bool>(usesBiometrics);
    }
    if (!nullToAbsent || deleted != null) {
      map['deleted'] = Variable<bool>(deleted);
    }
    if (!nullToAbsent || archived != null) {
      map['archived'] = Variable<bool>(archived);
    }
    if (!nullToAbsent || synced != null) {
      map['synced'] = Variable<bool>(synced);
    }
    return map;
  }

  NotesCompanion toCompanion(bool nullToAbsent) {
    return NotesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
      content: content == null && nullToAbsent
          ? const Value.absent()
          : Value(content),
      styleJson: styleJson == null && nullToAbsent
          ? const Value.absent()
          : Value(styleJson),
      starred: starred == null && nullToAbsent
          ? const Value.absent()
          : Value(starred),
      creationDate: creationDate == null && nullToAbsent
          ? const Value.absent()
          : Value(creationDate),
      lastModifyDate: lastModifyDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastModifyDate),
      color:
          color == null && nullToAbsent ? const Value.absent() : Value(color),
      images:
          images == null && nullToAbsent ? const Value.absent() : Value(images),
      list: list == null && nullToAbsent ? const Value.absent() : Value(list),
      listContent: listContent == null && nullToAbsent
          ? const Value.absent()
          : Value(listContent),
      reminders: reminders == null && nullToAbsent
          ? const Value.absent()
          : Value(reminders),
      hideContent: hideContent == null && nullToAbsent
          ? const Value.absent()
          : Value(hideContent),
      lockNote: lockNote == null && nullToAbsent
          ? const Value.absent()
          : Value(lockNote),
      usesBiometrics: usesBiometrics == null && nullToAbsent
          ? const Value.absent()
          : Value(usesBiometrics),
      deleted: deleted == null && nullToAbsent
          ? const Value.absent()
          : Value(deleted),
      archived: archived == null && nullToAbsent
          ? const Value.absent()
          : Value(archived),
      synced:
          synced == null && nullToAbsent ? const Value.absent() : Value(synced),
    );
  }

  factory Note.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Note(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      content: serializer.fromJson<String>(json['content']),
      styleJson: serializer.fromJson<ContentStyle>(json['styleJson']),
      starred: serializer.fromJson<bool>(json['starred']),
      creationDate: serializer.fromJson<DateTime>(json['creationDate']),
      lastModifyDate: serializer.fromJson<DateTime>(json['lastModifyDate']),
      color: serializer.fromJson<int>(json['color']),
      images: serializer.fromJson<ImageList>(json['images']),
      list: serializer.fromJson<bool>(json['list']),
      listContent: serializer.fromJson<ListContent>(json['listContent']),
      reminders: serializer.fromJson<ReminderList>(json['reminders']),
      hideContent: serializer.fromJson<bool>(json['hideContent']),
      lockNote: serializer.fromJson<bool>(json['lockNote']),
      usesBiometrics: serializer.fromJson<bool>(json['usesBiometrics']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      archived: serializer.fromJson<bool>(json['archived']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'content': serializer.toJson<String>(content),
      'styleJson': serializer.toJson<ContentStyle>(styleJson),
      'starred': serializer.toJson<bool>(starred),
      'creationDate': serializer.toJson<DateTime>(creationDate),
      'lastModifyDate': serializer.toJson<DateTime>(lastModifyDate),
      'color': serializer.toJson<int>(color),
      'images': serializer.toJson<ImageList>(images),
      'list': serializer.toJson<bool>(list),
      'listContent': serializer.toJson<ListContent>(listContent),
      'reminders': serializer.toJson<ReminderList>(reminders),
      'hideContent': serializer.toJson<bool>(hideContent),
      'lockNote': serializer.toJson<bool>(lockNote),
      'usesBiometrics': serializer.toJson<bool>(usesBiometrics),
      'deleted': serializer.toJson<bool>(deleted),
      'archived': serializer.toJson<bool>(archived),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  Note copyWith(
          {int id,
          String title,
          String content,
          ContentStyle styleJson,
          bool starred,
          DateTime creationDate,
          DateTime lastModifyDate,
          int color,
          ImageList images,
          bool list,
          ListContent listContent,
          ReminderList reminders,
          bool hideContent,
          bool lockNote,
          bool usesBiometrics,
          bool deleted,
          bool archived,
          bool synced}) =>
      Note(
        id: id ?? this.id,
        title: title ?? this.title,
        content: content ?? this.content,
        styleJson: styleJson ?? this.styleJson,
        starred: starred ?? this.starred,
        creationDate: creationDate ?? this.creationDate,
        lastModifyDate: lastModifyDate ?? this.lastModifyDate,
        color: color ?? this.color,
        images: images ?? this.images,
        list: list ?? this.list,
        listContent: listContent ?? this.listContent,
        reminders: reminders ?? this.reminders,
        hideContent: hideContent ?? this.hideContent,
        lockNote: lockNote ?? this.lockNote,
        usesBiometrics: usesBiometrics ?? this.usesBiometrics,
        deleted: deleted ?? this.deleted,
        archived: archived ?? this.archived,
        synced: synced ?? this.synced,
      );
  @override
  String toString() {
    return (StringBuffer('Note(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('styleJson: $styleJson, ')
          ..write('starred: $starred, ')
          ..write('creationDate: $creationDate, ')
          ..write('lastModifyDate: $lastModifyDate, ')
          ..write('color: $color, ')
          ..write('images: $images, ')
          ..write('list: $list, ')
          ..write('listContent: $listContent, ')
          ..write('reminders: $reminders, ')
          ..write('hideContent: $hideContent, ')
          ..write('lockNote: $lockNote, ')
          ..write('usesBiometrics: $usesBiometrics, ')
          ..write('deleted: $deleted, ')
          ..write('archived: $archived, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          title.hashCode,
          $mrjc(
              content.hashCode,
              $mrjc(
                  styleJson.hashCode,
                  $mrjc(
                      starred.hashCode,
                      $mrjc(
                          creationDate.hashCode,
                          $mrjc(
                              lastModifyDate.hashCode,
                              $mrjc(
                                  color.hashCode,
                                  $mrjc(
                                      images.hashCode,
                                      $mrjc(
                                          list.hashCode,
                                          $mrjc(
                                              listContent.hashCode,
                                              $mrjc(
                                                  reminders.hashCode,
                                                  $mrjc(
                                                      hideContent.hashCode,
                                                      $mrjc(
                                                          lockNote.hashCode,
                                                          $mrjc(
                                                              usesBiometrics
                                                                  .hashCode,
                                                              $mrjc(
                                                                  deleted
                                                                      .hashCode,
                                                                  $mrjc(
                                                                      archived
                                                                          .hashCode,
                                                                      synced
                                                                          .hashCode))))))))))))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Note &&
          other.id == this.id &&
          other.title == this.title &&
          other.content == this.content &&
          other.styleJson == this.styleJson &&
          other.starred == this.starred &&
          other.creationDate == this.creationDate &&
          other.lastModifyDate == this.lastModifyDate &&
          other.color == this.color &&
          other.images == this.images &&
          other.list == this.list &&
          other.listContent == this.listContent &&
          other.reminders == this.reminders &&
          other.hideContent == this.hideContent &&
          other.lockNote == this.lockNote &&
          other.usesBiometrics == this.usesBiometrics &&
          other.deleted == this.deleted &&
          other.archived == this.archived &&
          other.synced == this.synced);
}

class NotesCompanion extends UpdateCompanion<Note> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> content;
  final Value<ContentStyle> styleJson;
  final Value<bool> starred;
  final Value<DateTime> creationDate;
  final Value<DateTime> lastModifyDate;
  final Value<int> color;
  final Value<ImageList> images;
  final Value<bool> list;
  final Value<ListContent> listContent;
  final Value<ReminderList> reminders;
  final Value<bool> hideContent;
  final Value<bool> lockNote;
  final Value<bool> usesBiometrics;
  final Value<bool> deleted;
  final Value<bool> archived;
  final Value<bool> synced;
  const NotesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.styleJson = const Value.absent(),
    this.starred = const Value.absent(),
    this.creationDate = const Value.absent(),
    this.lastModifyDate = const Value.absent(),
    this.color = const Value.absent(),
    this.images = const Value.absent(),
    this.list = const Value.absent(),
    this.listContent = const Value.absent(),
    this.reminders = const Value.absent(),
    this.hideContent = const Value.absent(),
    this.lockNote = const Value.absent(),
    this.usesBiometrics = const Value.absent(),
    this.deleted = const Value.absent(),
    this.archived = const Value.absent(),
    this.synced = const Value.absent(),
  });
  NotesCompanion.insert({
    @required int id,
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    @required ContentStyle styleJson,
    this.starred = const Value.absent(),
    this.creationDate = const Value.absent(),
    this.lastModifyDate = const Value.absent(),
    this.color = const Value.absent(),
    @required ImageList images,
    this.list = const Value.absent(),
    @required ListContent listContent,
    @required ReminderList reminders,
    this.hideContent = const Value.absent(),
    this.lockNote = const Value.absent(),
    this.usesBiometrics = const Value.absent(),
    this.deleted = const Value.absent(),
    this.archived = const Value.absent(),
    this.synced = const Value.absent(),
  })  : id = Value(id),
        styleJson = Value(styleJson),
        images = Value(images),
        listContent = Value(listContent),
        reminders = Value(reminders);
  static Insertable<Note> custom({
    Expression<int> id,
    Expression<String> title,
    Expression<String> content,
    Expression<String> styleJson,
    Expression<bool> starred,
    Expression<DateTime> creationDate,
    Expression<DateTime> lastModifyDate,
    Expression<int> color,
    Expression<String> images,
    Expression<bool> list,
    Expression<String> listContent,
    Expression<String> reminders,
    Expression<bool> hideContent,
    Expression<bool> lockNote,
    Expression<bool> usesBiometrics,
    Expression<bool> deleted,
    Expression<bool> archived,
    Expression<bool> synced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (styleJson != null) 'style_json': styleJson,
      if (starred != null) 'starred': starred,
      if (creationDate != null) 'creation_date': creationDate,
      if (lastModifyDate != null) 'last_modify_date': lastModifyDate,
      if (color != null) 'color': color,
      if (images != null) 'images': images,
      if (list != null) 'list': list,
      if (listContent != null) 'list_content': listContent,
      if (reminders != null) 'reminders': reminders,
      if (hideContent != null) 'hide_content': hideContent,
      if (lockNote != null) 'lock_note': lockNote,
      if (usesBiometrics != null) 'uses_biometrics': usesBiometrics,
      if (deleted != null) 'deleted': deleted,
      if (archived != null) 'archived': archived,
      if (synced != null) 'synced': synced,
    });
  }

  NotesCompanion copyWith(
      {Value<int> id,
      Value<String> title,
      Value<String> content,
      Value<ContentStyle> styleJson,
      Value<bool> starred,
      Value<DateTime> creationDate,
      Value<DateTime> lastModifyDate,
      Value<int> color,
      Value<ImageList> images,
      Value<bool> list,
      Value<ListContent> listContent,
      Value<ReminderList> reminders,
      Value<bool> hideContent,
      Value<bool> lockNote,
      Value<bool> usesBiometrics,
      Value<bool> deleted,
      Value<bool> archived,
      Value<bool> synced}) {
    return NotesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      styleJson: styleJson ?? this.styleJson,
      starred: starred ?? this.starred,
      creationDate: creationDate ?? this.creationDate,
      lastModifyDate: lastModifyDate ?? this.lastModifyDate,
      color: color ?? this.color,
      images: images ?? this.images,
      list: list ?? this.list,
      listContent: listContent ?? this.listContent,
      reminders: reminders ?? this.reminders,
      hideContent: hideContent ?? this.hideContent,
      lockNote: lockNote ?? this.lockNote,
      usesBiometrics: usesBiometrics ?? this.usesBiometrics,
      deleted: deleted ?? this.deleted,
      archived: archived ?? this.archived,
      synced: synced ?? this.synced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (styleJson.present) {
      final converter = $NotesTable.$converter0;
      map['style_json'] = Variable<String>(converter.mapToSql(styleJson.value));
    }
    if (starred.present) {
      map['starred'] = Variable<bool>(starred.value);
    }
    if (creationDate.present) {
      map['creation_date'] = Variable<DateTime>(creationDate.value);
    }
    if (lastModifyDate.present) {
      map['last_modify_date'] = Variable<DateTime>(lastModifyDate.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (images.present) {
      final converter = $NotesTable.$converter1;
      map['images'] = Variable<String>(converter.mapToSql(images.value));
    }
    if (list.present) {
      map['list'] = Variable<bool>(list.value);
    }
    if (listContent.present) {
      final converter = $NotesTable.$converter2;
      map['list_content'] =
          Variable<String>(converter.mapToSql(listContent.value));
    }
    if (reminders.present) {
      final converter = $NotesTable.$converter3;
      map['reminders'] = Variable<String>(converter.mapToSql(reminders.value));
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
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (archived.present) {
      map['archived'] = Variable<bool>(archived.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    return map;
  }
}

class $NotesTable extends Notes with TableInfo<$NotesTable, Note> {
  final GeneratedDatabase _db;
  final String _alias;
  $NotesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _titleMeta = const VerificationMeta('title');
  GeneratedTextColumn _title;
  @override
  GeneratedTextColumn get title => _title ??= _constructTitle();
  GeneratedTextColumn _constructTitle() {
    return GeneratedTextColumn(
      'title',
      $tableName,
      true,
    );
  }

  final VerificationMeta _contentMeta = const VerificationMeta('content');
  GeneratedTextColumn _content;
  @override
  GeneratedTextColumn get content => _content ??= _constructContent();
  GeneratedTextColumn _constructContent() {
    return GeneratedTextColumn(
      'content',
      $tableName,
      true,
    );
  }

  final VerificationMeta _styleJsonMeta = const VerificationMeta('styleJson');
  GeneratedTextColumn _styleJson;
  @override
  GeneratedTextColumn get styleJson => _styleJson ??= _constructStyleJson();
  GeneratedTextColumn _constructStyleJson() {
    return GeneratedTextColumn(
      'style_json',
      $tableName,
      false,
    );
  }

  final VerificationMeta _starredMeta = const VerificationMeta('starred');
  GeneratedBoolColumn _starred;
  @override
  GeneratedBoolColumn get starred => _starred ??= _constructStarred();
  GeneratedBoolColumn _constructStarred() {
    return GeneratedBoolColumn('starred', $tableName, false,
        defaultValue: Constant(false));
  }

  final VerificationMeta _creationDateMeta =
      const VerificationMeta('creationDate');
  GeneratedDateTimeColumn _creationDate;
  @override
  GeneratedDateTimeColumn get creationDate =>
      _creationDate ??= _constructCreationDate();
  GeneratedDateTimeColumn _constructCreationDate() {
    return GeneratedDateTimeColumn('creation_date', $tableName, false,
        defaultValue: Constant(DateTime.now()));
  }

  final VerificationMeta _lastModifyDateMeta =
      const VerificationMeta('lastModifyDate');
  GeneratedDateTimeColumn _lastModifyDate;
  @override
  GeneratedDateTimeColumn get lastModifyDate =>
      _lastModifyDate ??= _constructLastModifyDate();
  GeneratedDateTimeColumn _constructLastModifyDate() {
    return GeneratedDateTimeColumn('last_modify_date', $tableName, false,
        defaultValue: Constant(DateTime.now()));
  }

  final VerificationMeta _colorMeta = const VerificationMeta('color');
  GeneratedIntColumn _color;
  @override
  GeneratedIntColumn get color => _color ??= _constructColor();
  GeneratedIntColumn _constructColor() {
    return GeneratedIntColumn('color', $tableName, false,
        defaultValue: Constant(0));
  }

  final VerificationMeta _imagesMeta = const VerificationMeta('images');
  GeneratedTextColumn _images;
  @override
  GeneratedTextColumn get images => _images ??= _constructImages();
  GeneratedTextColumn _constructImages() {
    return GeneratedTextColumn(
      'images',
      $tableName,
      false,
    );
  }

  final VerificationMeta _listMeta = const VerificationMeta('list');
  GeneratedBoolColumn _list;
  @override
  GeneratedBoolColumn get list => _list ??= _constructList();
  GeneratedBoolColumn _constructList() {
    return GeneratedBoolColumn('list', $tableName, false,
        defaultValue: Constant(false));
  }

  final VerificationMeta _listContentMeta =
      const VerificationMeta('listContent');
  GeneratedTextColumn _listContent;
  @override
  GeneratedTextColumn get listContent =>
      _listContent ??= _constructListContent();
  GeneratedTextColumn _constructListContent() {
    return GeneratedTextColumn(
      'list_content',
      $tableName,
      false,
    );
  }

  final VerificationMeta _remindersMeta = const VerificationMeta('reminders');
  GeneratedTextColumn _reminders;
  @override
  GeneratedTextColumn get reminders => _reminders ??= _constructReminders();
  GeneratedTextColumn _constructReminders() {
    return GeneratedTextColumn(
      'reminders',
      $tableName,
      false,
    );
  }

  final VerificationMeta _hideContentMeta =
      const VerificationMeta('hideContent');
  GeneratedBoolColumn _hideContent;
  @override
  GeneratedBoolColumn get hideContent =>
      _hideContent ??= _constructHideContent();
  GeneratedBoolColumn _constructHideContent() {
    return GeneratedBoolColumn('hide_content', $tableName, false,
        defaultValue: Constant(false));
  }

  final VerificationMeta _lockNoteMeta = const VerificationMeta('lockNote');
  GeneratedBoolColumn _lockNote;
  @override
  GeneratedBoolColumn get lockNote => _lockNote ??= _constructLockNote();
  GeneratedBoolColumn _constructLockNote() {
    return GeneratedBoolColumn('lock_note', $tableName, false,
        defaultValue: Constant(false));
  }

  final VerificationMeta _usesBiometricsMeta =
      const VerificationMeta('usesBiometrics');
  GeneratedBoolColumn _usesBiometrics;
  @override
  GeneratedBoolColumn get usesBiometrics =>
      _usesBiometrics ??= _constructUsesBiometrics();
  GeneratedBoolColumn _constructUsesBiometrics() {
    return GeneratedBoolColumn('uses_biometrics', $tableName, false,
        defaultValue: Constant(false));
  }

  final VerificationMeta _deletedMeta = const VerificationMeta('deleted');
  GeneratedBoolColumn _deleted;
  @override
  GeneratedBoolColumn get deleted => _deleted ??= _constructDeleted();
  GeneratedBoolColumn _constructDeleted() {
    return GeneratedBoolColumn('deleted', $tableName, false,
        defaultValue: Constant(false));
  }

  final VerificationMeta _archivedMeta = const VerificationMeta('archived');
  GeneratedBoolColumn _archived;
  @override
  GeneratedBoolColumn get archived => _archived ??= _constructArchived();
  GeneratedBoolColumn _constructArchived() {
    return GeneratedBoolColumn('archived', $tableName, false,
        defaultValue: Constant(false));
  }

  final VerificationMeta _syncedMeta = const VerificationMeta('synced');
  GeneratedBoolColumn _synced;
  @override
  GeneratedBoolColumn get synced => _synced ??= _constructSynced();
  GeneratedBoolColumn _constructSynced() {
    return GeneratedBoolColumn('synced', $tableName, false,
        defaultValue: Constant(false));
  }

  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        content,
        styleJson,
        starred,
        creationDate,
        lastModifyDate,
        color,
        images,
        list,
        listContent,
        reminders,
        hideContent,
        lockNote,
        usesBiometrics,
        deleted,
        archived,
        synced
      ];
  @override
  $NotesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'notes';
  @override
  final String actualTableName = 'notes';
  @override
  VerificationContext validateIntegrity(Insertable<Note> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title'], _titleMeta));
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content'], _contentMeta));
    }
    context.handle(_styleJsonMeta, const VerificationResult.success());
    if (data.containsKey('starred')) {
      context.handle(_starredMeta,
          starred.isAcceptableOrUnknown(data['starred'], _starredMeta));
    }
    if (data.containsKey('creation_date')) {
      context.handle(
          _creationDateMeta,
          creationDate.isAcceptableOrUnknown(
              data['creation_date'], _creationDateMeta));
    }
    if (data.containsKey('last_modify_date')) {
      context.handle(
          _lastModifyDateMeta,
          lastModifyDate.isAcceptableOrUnknown(
              data['last_modify_date'], _lastModifyDateMeta));
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color'], _colorMeta));
    }
    context.handle(_imagesMeta, const VerificationResult.success());
    if (data.containsKey('list')) {
      context.handle(
          _listMeta, list.isAcceptableOrUnknown(data['list'], _listMeta));
    }
    context.handle(_listContentMeta, const VerificationResult.success());
    context.handle(_remindersMeta, const VerificationResult.success());
    if (data.containsKey('hide_content')) {
      context.handle(
          _hideContentMeta,
          hideContent.isAcceptableOrUnknown(
              data['hide_content'], _hideContentMeta));
    }
    if (data.containsKey('lock_note')) {
      context.handle(_lockNoteMeta,
          lockNote.isAcceptableOrUnknown(data['lock_note'], _lockNoteMeta));
    }
    if (data.containsKey('uses_biometrics')) {
      context.handle(
          _usesBiometricsMeta,
          usesBiometrics.isAcceptableOrUnknown(
              data['uses_biometrics'], _usesBiometricsMeta));
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta,
          deleted.isAcceptableOrUnknown(data['deleted'], _deletedMeta));
    }
    if (data.containsKey('archived')) {
      context.handle(_archivedMeta,
          archived.isAcceptableOrUnknown(data['archived'], _archivedMeta));
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced'], _syncedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id, synced};
  @override
  Note map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Note.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $NotesTable createAlias(String alias) {
    return $NotesTable(_db, alias);
  }

  static TypeConverter<ContentStyle, String> $converter0 =
      const ContentStyleConverter();
  static TypeConverter<ImageList, String> $converter1 =
      const ImageListConverter();
  static TypeConverter<ListContent, String> $converter2 =
      const ListContentConverter();
  static TypeConverter<ReminderList, String> $converter3 =
      const ReminderListConverter();
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $NotesTable _notes;
  $NotesTable get notes => _notes ??= $NotesTable(this);
  NoteHelper _noteHelper;
  NoteHelper get noteHelper => _noteHelper ??= NoteHelper(this as AppDatabase);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [notes];
}
