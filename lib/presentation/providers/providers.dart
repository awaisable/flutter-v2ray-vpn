import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../core/utils/base64_decoder.dart';
import '../../data/datasources/remote_subscription_datasource.dart';
import '../../data/repositories/server_repository_impl.dart';
import '../../data/repositories/vpn_repository_impl.dart';
import '../../domain/entities/server_config.dart';
import '../../domain/entities/traffic_stats.dart';
import '../../domain/entities/vpn_status.dart';
import '../../domain/repositories/server_repository.dart';
import '../../domain/repositories/vpn_repository.dart';
import '../../domain/usecases/connect_vpn_usecase.dart';
import '../../domain/usecases/fetch_servers_usecase.dart';
import '../../domain/usecases/ping_server_usecase.dart';

// ── Infrastructure ────────────────────────────────────────────────────────────

final httpClientProvider = Provider<http.Client>((ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return client;
});

final base64DecoderProvider = Provider<Base64DecoderService>(
  (_) => Base64DecoderService(),
);

final remoteDataSourceProvider = Provider<RemoteSubscriptionDataSource>((ref) {
  return RemoteSubscriptionDataSourceImpl(ref.watch(httpClientProvider));
});

final serverRepositoryProvider = Provider<ServerRepository>((ref) {
  return ServerRepositoryImpl(
    dataSource: ref.watch(remoteDataSourceProvider),
    decoder: ref.watch(base64DecoderProvider),
  );
});

final vpnRepositoryProvider = Provider<VpnRepository>((ref) {
  final repo = VpnRepositoryImpl();
  ref.onDispose(repo.dispose);
  return repo;
});

// ── Use Cases ─────────────────────────────────────────────────────────────────

final fetchServersUseCaseProvider = Provider<FetchServersUseCase>((ref) {
  return FetchServersUseCase(ref.watch(serverRepositoryProvider));
});

final connectVpnUseCaseProvider = Provider<ConnectVpnUseCase>((ref) {
  return ConnectVpnUseCase(ref.watch(vpnRepositoryProvider));
});

final disconnectVpnUseCaseProvider = Provider<DisconnectVpnUseCase>((ref) {
  return DisconnectVpnUseCase(ref.watch(vpnRepositoryProvider));
});

final pingServerUseCaseProvider = Provider<PingServerUseCase>((ref) {
  return PingServerUseCase(ref.watch(vpnRepositoryProvider));
});

// ── Server List ───────────────────────────────────────────────────────────────

class ServerListNotifier extends AsyncNotifier<List<ServerConfig>> {
  String? _lastError;
  String? get lastError => _lastError;

  @override
  Future<List<ServerConfig>> build() => _fetch();

  Future<List<ServerConfig>> _fetch() async {
    final useCase = ref.read(fetchServersUseCaseProvider);
    final result = await useCase();
    if (result.failure != null) {
      _lastError = result.failure!.message;
    } else {
      _lastError = null;
    }
    return result.servers;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }
}

final serverListProvider =
    AsyncNotifierProvider<ServerListNotifier, List<ServerConfig>>(
  ServerListNotifier.new,
);

// ── Selected Server ───────────────────────────────────────────────────────────

final selectedServerProvider = StateProvider<ServerConfig?>((ref) => null);

// ── Search Query ──────────────────────────────────────────────────────────────

final searchQueryProvider = StateProvider<String>((ref) => '');

final filteredServersProvider = Provider<List<ServerConfig>>((ref) {
  final servers = ref.watch(serverListProvider).valueOrNull ?? [];
  final query = ref.watch(searchQueryProvider).toLowerCase();
  if (query.isEmpty) return servers;
  return servers
      .where((s) =>
          s.remark.toLowerCase().contains(query) ||
          s.address.toLowerCase().contains(query))
      .toList();
});

// ── VPN Status ────────────────────────────────────────────────────────────────

final vpnStatusProvider = StreamProvider<VpnStatus>((ref) {
  return ref.watch(vpnRepositoryProvider).statusStream;
});

// ── Traffic Stats ─────────────────────────────────────────────────────────────

final trafficStatsProvider = StreamProvider<TrafficStats>((ref) {
  return ref.watch(vpnRepositoryProvider).trafficStream;
});

// ── Per-server Ping ───────────────────────────────────────────────────────────

final pingProvider =
    FutureProvider.family<int, ServerConfig>((ref, server) async {
  final useCase = ref.watch(pingServerUseCaseProvider);
  return useCase(server);
});
