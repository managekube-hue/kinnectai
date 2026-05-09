import 'dart:io';

class ErrorRegistry {
  ErrorRegistry._();

  static const Map<String, String> _known = {
    'SocketException': 'KIN-NET-001',
    'TimeoutException': 'KIN-NET-002',
    'FormatException': 'KIN-DATA-001',
    'StateError': 'KIN-STATE-001',
  };

  static String mapException(Object exception) {
    final type = exception.runtimeType.toString();
    if (_known.containsKey(type)) {
      return _known[type]!;
    }
    if (exception is SocketException) {
      return 'KIN-NET-001';
    }
    return 'KIN-UNK-000';
  }
}
