abstract class IFileController {
  Future<FileLimit> getLimit();
}

class FileLimit {
  int used;
  int available;

  FileLimit(this.used, this.available);
}
