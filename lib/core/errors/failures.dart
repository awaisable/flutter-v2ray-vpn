abstract class Failure {
  final String message;
  const Failure(this.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'Network connection failed'])
      : super(message);
}

class ServerFailure extends Failure {
  const ServerFailure([String message = 'Server error occurred'])
      : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure([String message = 'Cache operation failed'])
      : super(message);
}

class ParseFailure extends Failure {
  const ParseFailure([String message = 'Failed to parse configuration'])
      : super(message);
}

class VpnFailure extends Failure {
  const VpnFailure([String message = 'VPN operation failed']) : super(message);
}

class PermissionFailure extends Failure {
  const PermissionFailure([String message = 'VPN permission denied'])
      : super(message);
}
