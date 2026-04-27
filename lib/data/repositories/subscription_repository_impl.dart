import 'package:connectivity_plus/connectivity_plus.dart';
import '../../domain/entities/server_config.dart';
import '../../domain/repositories/subscription_repository.dart';
import '../../core/errors/failures.dart';
import '../datasources/remote/subscription_remote_datasource.dart';
import '../datasources/local/server_cache_datasource.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final SubscriptionRemoteDataSource remoteDataSource;
  final ServerCacheDataSource cacheDataSource;
  final Connectivity connectivity;

  SubscriptionRepositoryImpl({
    required this.remoteDataSource,
    required this.cacheDataSource,
    required this.connectivity,
  });

  @override
  Future<List<ServerConfig>> fetchServers({bool forceRefresh = false}) async {
    try {
      // Check network connectivity
      final connectivityResult = await connectivity.checkConnectivity();
      final hasConnection = connectivityResult != ConnectivityResult.none;

      // If no connection, return cached data
      if (!hasConnection) {
        final cachedServers = await cacheDataSource.getCachedServers();
        if (cachedServers.isEmpty) {
          throw const NetworkFailure('No internet connection and no cached data available');
        }
        return cachedServers;
      }

      // Check if cache is valid and not forcing refresh
      if (!forceRefresh) {
        final isCacheValid = await cacheDataSource.isCacheValid();
        if (isCacheValid) {
          final cachedServers = await cacheDataSource.getCachedServers();
          if (cachedServers.isNotEmpty) {
            return cachedServers;
          }
        }
      }

      // Fetch fresh data from remote
      final servers = await remoteDataSource.fetchServers();

      // Cache the fetched servers
      await cacheDataSource.cacheServers(servers);

      return servers;
    } on Failure {
      // If remote fetch fails, try to return cached data
      try {
        final cachedServers = await cacheDataSource.getCachedServers();
        if (cachedServers.isNotEmpty) {
          return cachedServers;
        }
      } catch (_) {
        // Ignore cache errors and rethrow original failure
      }
      rethrow;
    } catch (e) {
      throw ServerFailure('Failed to fetch servers: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await cacheDataSource.clearCache();
    } catch (e) {
      throw CacheFailure('Failed to clear cache: $e');
    }
  }
}
