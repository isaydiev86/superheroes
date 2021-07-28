
class ApiException implements Exception{
  final String message;

  ApiException(this.message);

  String toString() {
    Object? message = this.message;
    if (message == null) return "Exception";
    return "$message";
  }
}