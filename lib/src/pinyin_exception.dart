/// Pinyin Exception.
class PinyinException implements Exception {
  final dynamic message;

  PinyinException([this.message]);

  String toString() {
    Object? message = this.message;
    if (message == null) return "Exception";
    return "Exception: $message";
  }
}
