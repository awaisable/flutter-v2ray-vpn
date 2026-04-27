import 'package:flutter/foundation.dart';

@immutable
class ServerConfig {
  final String id;
  final String remark;
  final String protocol; // vmess | vless | trojan | ss
  final String address;
  final int port;
  final String rawUri;

  const ServerConfig({
    required this.id,
    required this.remark,
    required this.protocol,
    required this.address,
    required this.port,
    required this.rawUri,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is ServerConfig && other.id == id);

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'ServerConfig($protocol, $remark, $address:$port)';
}
