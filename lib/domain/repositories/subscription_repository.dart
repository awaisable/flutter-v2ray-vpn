import '../entities/server_config.dart';

abstract class SubscriptionRepository {
  Future<List<ServerConfig>> fetchServers({bool forceRefresh = false});
  Future<void> clearCache();
}
