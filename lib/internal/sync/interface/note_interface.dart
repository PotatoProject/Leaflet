import 'package:dartz/dartz.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/internal/sync/sync_helper.dart';

abstract class NoteInterface {
  static Future<Either<Failure, String>> add(Note note) async {
    return Left(Failure("Uninplemented"));
  }

  static Future<Either<Failure, String>> update(String id,
      Map<String, dynamic> noteDelta) async {
    return Left(Failure("Uninplemented"));
  }

  static Future<Either<Failure, String>> delete(String id) async {
    return Left(Failure("Uninplemented"));
  }

  static Future<Either<Failure, String>> deleteAll() async {
    return Left(Failure("Uninplemented"));
  }

  static Future<Either<Failure, List<Note>>> list(int lastUpdated) async {
    return Left(Failure("Uninplemented"));
  }

  static Future<Either<Failure, List<String>>> listDeleted(List<String> localIdList) async {
    return Left(Failure("Uninplemented"));
  }
}
