class Failure {
  final String messageId;

  Failure(this.messageId);

  @override
  String toString() => messageId.toString();
}

class NoConnectionFailure extends Failure {
  NoConnectionFailure() : super("no_connection");
}

class FileNotFoundFailure extends Failure {
  FileNotFoundFailure() : super("file_not_found");
}

enum FailureType { FILE_NOT_FOUND, NO_CONNECTION }
