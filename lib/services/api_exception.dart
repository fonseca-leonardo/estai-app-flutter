class ApiException implements Exception {
  final String message;
  final Uri? uri;
  final int? statusCode;

  ApiException(this.message, {this.uri, this.statusCode});

  @override
  String toString() {
    if (uri != null) {
      return 'ApiException: $message (URI: $uri)';
    }
    return 'ApiException: $message';
  }
}
