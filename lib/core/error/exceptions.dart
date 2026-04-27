class NetworkException implements Exception {
  final String message;
  const NetworkException([this.message = 'Network error occurred.']);
  @override
  String toString() => 'NetworkException: $message';
}

class ParseException implements Exception {
  final String message;
  const ParseException([this.message = 'Failed to parse configuration.']);
  @override
  String toString() => 'ParseException: $message';
}

class VpnException implements Exception {
  final String message;
  const VpnException([this.message = 'VPN error occurred.']);
  @override
  String toString() => 'VpnException: $message';
}
