import '../entities/server_config.dart';
import '../entities/vpn_status.dart';
import '../entities/traffic_stats.dart';
import '../../core/error/failures.dart';

abstract class VpnRepository {
  Stream<VpnStatus> get statusStream;
  Stream<TrafficStats> get trafficStream;

  Future<Failure?> connect(ServerConfig server);
  Future<void> disconnect();
  Future<int> ping(ServerConfig server); // returns ms, -1 on failure
  VpnStatus get currentStatus;
}
