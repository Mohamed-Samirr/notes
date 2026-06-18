class CacheException implements Exception {
  final String message;

  const CacheException(this.message);

  @override
  String toString() => 'CacheException: $message';
}

class FirebaseException implements Exception {
  final String message;

  const FirebaseException(this.message);

  @override
  String toString() => 'FirebaseException: $message';
}

class NetworkException implements Exception {
  final String message;

  const NetworkException(this.message);

  @override
  String toString() => 'NetworkException: $message';
}
