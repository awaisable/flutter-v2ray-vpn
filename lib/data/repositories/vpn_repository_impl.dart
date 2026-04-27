import 'dart:async';
import 'package:flutter_v2ray/flutter_v2ray.dart';

import '../../core/error/failures.dart';
import '../../domain/entities/server_config.dart';
import '../../domain/entities/traffic_stats.dart';
import '../../domain/entities/vpn_status.dart';
import '../../domain/repositories/vpn_repository.dart';

class VpnRepositoryImpl implements VpnRepository {
  late final FlutterV2ray _v2ray;

  final _statusController = StreamController<VpnStatus>.broadcast();
  final _trafficController = StreamController<TrafficStats>.broadcast();

  VpnStatus _currentStatus = VpnStatus.initial;

  // For computing speed deltas
  int _lastUpload = 0;
  int _lastDownload = 0;
  DateTime _lastTrafficTime = DateTime.now();

  VpnRepositoryImpl() {
    _v2ray = FlutterV2ray(
      onStatusChanged: _onStatusChanged,
    );
    _v2ray.initializeV2Ray();
  }

  void _onStatusChanged(V2RayStatus status) {
    final state = _mapState(status.state);

    // Parse traffic from status
    final upload = status.upload;
    final download = status.download;
    final now = DateTime.now();
    final elapsed = now.difference(_lastTrafficTime).inMilliseconds / 1000.0;

    double upSpeed = 0;
    double downSpeed = 0;
    if (elapsed > 0) {
      upSpeed = (upload - _lastUpload) / elapsed;
      downSpeed = (download - _lastDownload) / elapsed;
    }
    _lastUpload = upload;
    _lastDownload = download;
    _lastTrafficTime = now;

    _trafficController.add(TrafficStats(
      uploadSpeed: upSpeed.clamp(0, double.infinity),
      downloadSpeed: downSpeed.clamp(0, double.infinity),
      totalUpload: upload,
      totalDownload: download,
    ));

    _currentStatus = VpnStatus(
      state: state,
      duration: Duration(seconds: status.duration),
    );
    _statusController.add(_currentStatus);
  }

  VpnState _mapState(String raw) {
    switch (raw.toLowerCase()) {
      case 'connected':
        return VpnState.connected;
      case 'connecting':
        return VpnState.connecting;
      case 'disconnecting':
        return VpnState.disconnecting;
      case 'disconnected':
        return VpnState.disconnected;
      default:
        return VpnState.disconnected;
    }
  }

  @override
  Stream<VpnStatus> get statusStream => _statusController.stream;

  @override
  Stream<TrafficStats> get trafficStream => _trafficController.stream;

  @override
  VpnStatus get currentStatus => _currentStatus;

  @override
  Future<Failure?> connect(ServerConfig server) async {
    try {
      final hasPermission = await _v2ray.requestPermission();
      if (!hasPermission) return const PermissionFailure();

      final parser = FlutterV2ray.parseFromURL(server.rawUri);

      await _v2ray.startV2Ray(
        remark: server.remark,
        config: parser.getFullConfiguration(),
        blockedApps: null,
        bypassSubnets: null,
        proxyOnly: false,
      );
      return null;
    } catch (e) {
      return VpnFailure('Failed to connect: $e');
    }
  }

  @override
  Future<void> disconnect() async {
    try {
      _v2ray.stopV2Ray();
    } catch (_) {}
  }

  @override
  Future<int> ping(ServerConfig server) async {
    try {
      final parser = FlutterV2ray.parseFromURL(server.rawUri);
      final delay = await _v2ray.getServerDelay(
        config: parser.getFullConfiguration(),
      );
      return delay;
    } catch (_) {
      return -1;
    }
  }

  void dispose() {
    _statusController.close();
    _trafficController.close();
  }
}
