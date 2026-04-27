import '../entities/server_config.dart';
import '../repositories/vpn_repository.dart';
import '../../core/error/failures.dart';

class ConnectVpnUseCase {
  final VpnRepository _repository;
  const ConnectVpnUseCase(this._repository);

  Future<Failure?> call(ServerConfig server) => _repository.connect(server);
}

class DisconnectVpnUseCase {
  final VpnRepository _repository;
  const DisconnectVpnUseCase(this._repository);

  Future<void> call() => _repository.disconnect();
}
