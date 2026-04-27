import '../entities/server_config.dart';
import '../repositories/vpn_repository.dart';

class PingServerUseCase {
  final VpnRepository _repository;
  const PingServerUseCase(this._repository);

  /// Returns latency in ms, or -1 if unreachable.
  Future<int> call(ServerConfig server) => _repository.ping(server);
}
