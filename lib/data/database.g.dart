// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps
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
  final String pin;
  final String password;
  final bool usesBiometrics;
  final bool deleted;
  final bool archived;
  final bool synced;
  Note(
      {@required this.id,
      this.title,
      @required this.content,
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
      this.pin,
      this.password,
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
      pin: stringType.mapFromDatabaseResponse(data['${effectivePrefix}pin']),
      password: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}password']),
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
  factory Note.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
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
      pin: serializer.fromJson<String>(json['pin']),
      password: serializer.fromJson<String>(json['password']),
      usesBiometrics: serializer.fromJson<bool>(json['usesBiometrics']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      archived: serializer.fromJson<bool>(json['archived']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson(
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return {
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
      'pin': serializer.toJson<String>(pin),
      'password': serializer.toJson<String>(password),
      'usesBiometrics': serializer.toJson<bool>(usesBiometrics),
      'deleted': serializer.toJson<bool>(deleted),
      'archived': serializer.toJson<bool>(archived),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  @override
  T createCompanion<T extends UpdateCompanion<Note>>(bool nullToAbsent) {
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
      pin: pin == null && nullToAbsent ? const Value.absent() : Value(pin),
      password: password == null && nullToAbsent
          ? const Value.absent()
          : Value(password),
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
    ) as T;
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
          String pin,
          String password,
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
        pin: pin ?? this.pin,
        password: password ?? this.password,
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
          ..write('pin: $pin, ')
          ..write('password: $password, ')
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
                                                          pin.hashCode,
                                                          $mrjc(
                                                              password.hashCode,
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
                                                                              .hashCode)))))))))))))))))));
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is Note &&
          other.id == id &&
          other.title == title &&
          other.content == content &&
          other.styleJson == styleJson &&
          other.starred == starred &&
          other.creationDate == creationDate &&
          other.lastModifyDate == lastModifyDate &&
          other.color == color &&
          other.images == images &&
          other.list == list &&
          other.listContent == listContent &&
          other.reminders == reminders &&
          other.hideContent == hideContent &&
          other.pin == pin &&
          other.password == password &&
          other.usesBiometrics == usesBiometrics &&
          other.deleted == deleted &&
          other.archived == archived &&
          other.synced == synced);
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
  final Value<String> pin;
  final Value<String> password;
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
    this.pin = const Value.absent(),
    this.password = const Value.absent(),
    this.usesBiometrics = const Value.absent(),
    this.deleted = const Value.absent(),
    this.archived = const Value.absent(),
    this.synced = const Value.absent(),
  });
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
      Value<String> pin,
      Value<String> password,
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
      pin: pin ?? this.pin,
      password: password ?? this.password,
      usesBiometrics: usesBiometrics ?? this.usesBiometrics,
      deleted: deleted ?? this.deleted,
      archived: archived ?? this.archived,
      synced: synced ?? this.synced,
    );
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
    return GeneratedTextColumn('content', $tableName, false, minTextLength: 1);
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

  final VerificationMeta _pinMeta = const VerificationMeta('pin');
  GeneratedTextColumn _pin;
  @override
  GeneratedTextColumn get pin => _pin ??= _constructPin();
  GeneratedTextColumn _constructPin() {
    return GeneratedTextColumn(
      'pin',
      $tableName,
      true,
    );
  }

  final VerificationMeta _passwordMeta = const VerificationMeta('password');
  GeneratedTextColumn _password;
  @override
  GeneratedTextColumn get password => _password ??= _constructPassword();
  GeneratedTextColumn _constructPassword() {
    return GeneratedTextColumn(
      'password',
      $tableName,
      true,
    );
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
        pin,
        password,
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
  VerificationContext validateIntegrity(NotesCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    } else if (id.isRequired && isInserting) {
      context.missing(_idMeta);
    }
    if (d.title.present) {
      context.handle(
          _titleMeta, title.isAcceptableValue(d.title.value, _titleMeta));
    } else if (title.isRequired && isInserting) {
      context.missing(_titleMeta);
    }
    if (d.content.present) {
      context.handle(_contentMeta,
          content.isAcceptableValue(d.content.value, _contentMeta));
    } else if (content.isRequired && isInserting) {
      context.missing(_contentMeta);
    }
    context.handle(_styleJsonMeta, const VerificationResult.success());
    if (d.starred.present) {
      context.handle(_starredMeta,
          starred.isAcceptableValue(d.starred.value, _starredMeta));
    } else if (starred.isRequired && isInserting) {
      context.missing(_starredMeta);
    }
    if (d.creationDate.present) {
      context.handle(
          _creationDateMeta,
          creationDate.isAcceptableValue(
              d.creationDate.value, _creationDateMeta));
    } else if (creationDate.isRequired && isInserting) {
      context.missing(_creationDateMeta);
    }
    if (d.lastModifyDate.present) {
      context.handle(
          _lastModifyDateMeta,
          lastModifyDate.isAcceptableValue(
              d.lastModifyDate.value, _lastModifyDateMeta));
    } else if (lastModifyDate.isRequired && isInserting) {
      context.missing(_lastModifyDateMeta);
    }
    if (d.color.present) {
      context.handle(
          _colorMeta, color.isAcceptableValue(d.color.value, _colorMeta));
    } else if (color.isRequired && isInserting) {
      context.missing(_colorMeta);
    }
    context.handle(_imagesMeta, const VerificationResult.success());
    if (d.list.present) {
      context.handle(
          _listMeta, list.isAcceptableValue(d.list.value, _listMeta));
    } else if (list.isRequired && isInserting) {
      context.missing(_listMeta);
    }
    context.handle(_listContentMeta, const VerificationResult.success());
    context.handle(_remindersMeta, const VerificationResult.success());
    if (d.hideContent.present) {
      context.handle(_hideContentMeta,
          hideContent.isAcceptableValue(d.hideContent.value, _hideContentMeta));
    } else if (hideContent.isRequired && isInserting) {
      context.missing(_hideContentMeta);
    }
    if (d.pin.present) {
      context.handle(_pinMeta, pin.isAcceptableValue(d.pin.value, _pinMeta));
    } else if (pin.isRequired && isInserting) {
      context.missing(_pinMeta);
    }
    if (d.password.present) {
      context.handle(_passwordMeta,
          password.isAcceptableValue(d.password.value, _passwordMeta));
    } else if (password.isRequired && isInserting) {
      context.missing(_passwordMeta);
    }
    if (d.usesBiometrics.present) {
      context.handle(
          _usesBiometricsMeta,
          usesBiometrics.isAcceptableValue(
              d.usesBiometrics.value, _usesBiometricsMeta));
    } else if (usesBiometrics.isRequired && isInserting) {
      context.missing(_usesBiometricsMeta);
    }
    if (d.deleted.present) {
      context.handle(_deletedMeta,
          deleted.isAcceptableValue(d.deleted.value, _deletedMeta));
    } else if (deleted.isRequired && isInserting) {
      context.missing(_deletedMeta);
    }
    if (d.archived.present) {
      context.handle(_archivedMeta,
          archived.isAcceptableValue(d.archived.value, _archivedMeta));
    } else if (archived.isRequired && isInserting) {
      context.missing(_archivedMeta);
    }
    if (d.synced.present) {
      context.handle(
          _syncedMeta, synced.isAcceptableValue(d.synced.value, _syncedMeta));
    } else if (synced.isRequired && isInserting) {
      context.missing(_syncedMeta);
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
  Map<String, Variable> entityToSql(NotesCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.title.present) {
      map['title'] = Variable<String, StringType>(d.title.value);
    }
    if (d.content.present) {
      map['content'] = Variable<String, StringType>(d.content.value);
    }
    if (d.styleJson.present) {
      final converter = $NotesTable.$converter0;
      map['style_json'] =
          Variable<String, StringType>(converter.mapToSql(d.styleJson.value));
    }
    if (d.starred.present) {
      map['starred'] = Variable<bool, BoolType>(d.starred.value);
    }
    if (d.creationDate.present) {
      map['creation_date'] =
          Variable<DateTime, DateTimeType>(d.creationDate.value);
    }
    if (d.lastModifyDate.present) {
      map['last_modify_date'] =
          Variable<DateTime, DateTimeType>(d.lastModifyDate.value);
    }
    if (d.color.present) {
      map['color'] = Variable<int, IntType>(d.color.value);
    }
    if (d.images.present) {
      final converter = $NotesTable.$converter1;
      map['images'] =
          Variable<String, StringType>(converter.mapToSql(d.images.value));
    }
    if (d.list.present) {
      map['list'] = Variable<bool, BoolType>(d.list.value);
    }
    if (d.listContent.present) {
      final converter = $NotesTable.$converter2;
      map['list_content'] =
          Variable<String, StringType>(converter.mapToSql(d.listContent.value));
    }
    if (d.reminders.present) {
      final converter = $NotesTable.$converter3;
      map['reminders'] =
          Variable<String, StringType>(converter.mapToSql(d.reminders.value));
    }
    if (d.hideContent.present) {
      map['hide_content'] = Variable<bool, BoolType>(d.hideContent.value);
    }
    if (d.pin.present) {
      map['pin'] = Variable<String, StringType>(d.pin.value);
    }
    if (d.password.present) {
      map['password'] = Variable<String, StringType>(d.password.value);
    }
    if (d.usesBiometrics.present) {
      map['uses_biometrics'] = Variable<bool, BoolType>(d.usesBiometrics.value);
    }
    if (d.deleted.present) {
      map['deleted'] = Variable<bool, BoolType>(d.deleted.value);
    }
    if (d.archived.present) {
      map['archived'] = Variable<bool, BoolType>(d.archived.value);
    }
    if (d.synced.present) {
      map['synced'] = Variable<bool, BoolType>(d.synced.value);
    }
    return map;
  }

  @override
  $NotesTable createAlias(String alias) {
    return $NotesTable(_db, alias);
  }

  static ContentStyleConverter $converter0 = const ContentStyleConverter();
  static ImageListConverter $converter1 = const ImageListConverter();
  static ListContentConverter $converter2 = const ListContentConverter();
  static ReminderListConverter $converter3 = const ReminderListConverter();
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(const SqlTypeSystem.withDefaults(), e);
  $NotesTable _notes;
  $NotesTable get notes => _notes ??= $NotesTable(this);
  NoteHelper _noteHelper;
  NoteHelper get noteHelper => _noteHelper ??= NoteHelper(this as AppDatabase);
  @override
  List<TableInfo> get allTables => [notes];
}
