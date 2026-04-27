import '../entities/server_config.dart';
import '../../core/error/failures.dart';

abstract class ServerRepository {
  /// Fetches and parses the remote subscription.
  /// Returns a [Failure] on any error.
  Future<({List<ServerConfig> servers, Failure? failure})> fetchServers();

  /// Returns the cached server list (may be empty on first launch).
  List<ServerConfig> getCachedServers();
}
