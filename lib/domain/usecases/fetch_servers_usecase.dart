import '../entities/server_config.dart';
import '../repositories/server_repository.dart';
import '../../core/error/failures.dart';

class FetchServersUseCase {
  final ServerRepository _repository;
  const FetchServersUseCase(this._repository);

  Future<({List<ServerConfig> servers, Failure? failure})> call() =>
      _repository.fetchServers();
}
