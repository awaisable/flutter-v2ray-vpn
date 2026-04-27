import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../core/utils/base64_decoder.dart';
import '../../domain/entities/server_config.dart';
import '../../domain/repositories/server_repository.dart';
import '../datasources/remote_subscription_datasource.dart';
import '../models/server_config_model.dart';

class ServerRepositoryImpl implements ServerRepository {
  final RemoteSubscriptionDataSource _dataSource;
  final Base64DecoderService _decoder;

  List<ServerConfig> _cache = [];

  ServerRepositoryImpl({
    required RemoteSubscriptionDataSource dataSource,
    required Base64DecoderService decoder,
  })  : _dataSource = dataSource,
        _decoder = decoder;

  @override
  Future<({List<ServerConfig> servers, Failure? failure})>
      fetchServers() async {
    try {
      final raw = await _dataSource.fetchRawSubscription();
      final uris = _decoder.decodeSubscription(raw);

      if (uris.isEmpty) {
        return (servers: _cache, failure: const EmptyConfigFailure());
      }

      final servers = uris
          .map(ServerConfigModel.fromUri)
          .whereType<ServerConfig>()
          .toList();

      if (servers.isEmpty) {
        return (servers: _cache, failure: const ParseFailure());
      }

      _cache = servers;
      return (servers: servers, failure: null);
    } on NetworkException catch (e) {
      return (servers: _cache, failure: NetworkFailure(e.message));
    } on ParseException catch (e) {
      return (servers: _cache, failure: ParseFailure(e.message));
    } catch (e) {
      return (servers: _cache, failure: ServerFailure(e.toString()));
    }
  }

  @override
  List<ServerConfig> getCachedServers() => List.unmodifiable(_cache);
}
