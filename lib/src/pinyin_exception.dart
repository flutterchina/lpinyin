class PinyinException implements Exception {
  final message;

  PinyinException([this.message]);

  String toString() {
    if (message == null) return "Exception";
    return "Exception: $message";
  }
}
