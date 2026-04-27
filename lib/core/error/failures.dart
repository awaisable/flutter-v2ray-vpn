abstract class Failure {
  final String message;
  const Failure(this.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection. Please check your network.']);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Failed to reach the subscription server.']);
}

class ParseFailure extends Failure {
  const ParseFailure([super.message = 'Failed to parse server configuration.']);
}

class VpnFailure extends Failure {
  const VpnFailure([super.message = 'VPN operation failed.']);
}

class PermissionFailure extends Failure {
  const PermissionFailure([super.message = 'VPN permission was denied.']);
}

class EmptyConfigFailure extends Failure {
  const EmptyConfigFailure([super.message = 'No valid servers found in the subscription.']);
}
