import 'dart:convert';
import 'dart:math';
import '../../domain/entities/server_config.dart';

/// Parses a raw V2Ray share URI into a [ServerConfig] domain entity.
class ServerConfigModel {
  static ServerConfig? fromUri(String uri) {
    try {
      if (uri.startsWith('vmess://')) return _parseVmess(uri);
      if (uri.startsWith('vless://')) return _parseVless(uri);
      if (uri.startsWith('trojan://')) return _parseTrojan(uri);
      if (uri.startsWith('ss://')) return _parseShadowsocks(uri);
    } catch (_) {
      // Skip malformed URIs silently
    }
    return null;
  }

  // ── VMess ──────────────────────────────────────────────────────────────────
  static ServerConfig _parseVmess(String uri) {
    final encoded = uri.substring('vmess://'.length);
    final jsonStr = utf8.decode(base64.decode(_pad(encoded)));
    final map = json.decode(jsonStr) as Map<String, dynamic>;

    final address = map['add']?.toString() ?? '';
    final port = int.tryParse(map['port']?.toString() ?? '0') ?? 0;
    final remark = Uri.decodeComponent(map['ps']?.toString() ?? address);

    return ServerConfig(
      id: _id(uri),
      remark: remark.isEmpty ? '$address:$port' : remark,
      protocol: 'vmess',
      address: address,
      port: port,
      rawUri: uri,
    );
  }

  // ── VLess ──────────────────────────────────────────────────────────────────
  static ServerConfig _parseVless(String uri) {
    // vless://uuid@host:port?params#remark
    final withoutScheme = uri.substring('vless://'.length);
    final hashIdx = withoutScheme.indexOf('#');
    final remark = hashIdx != -1
        ? Uri.decodeComponent(withoutScheme.substring(hashIdx + 1))
        : '';
    final main = hashIdx != -1
        ? withoutScheme.substring(0, hashIdx)
        : withoutScheme;

    final atIdx = main.indexOf('@');
    final hostPart = atIdx != -1 ? main.substring(atIdx + 1) : main;
    final qIdx = hostPart.indexOf('?');
    final hostPort = qIdx != -1 ? hostPart.substring(0, qIdx) : hostPart;

    final lastColon = hostPort.lastIndexOf(':');
    final address = lastColon != -1 ? hostPort.substring(0, lastColon) : hostPort;
    final port = lastColon != -1
        ? int.tryParse(hostPort.substring(lastColon + 1)) ?? 0
        : 0;

    return ServerConfig(
      id: _id(uri),
      remark: remark.isEmpty ? '$address:$port' : remark,
      protocol: 'vless',
      address: address,
      port: port,
      rawUri: uri,
    );
  }

  // ── Trojan ─────────────────────────────────────────────────────────────────
  static ServerConfig _parseTrojan(String uri) {
    // trojan://password@host:port#remark
    final withoutScheme = uri.substring('trojan://'.length);
    final hashIdx = withoutScheme.indexOf('#');
    final remark = hashIdx != -1
        ? Uri.decodeComponent(withoutScheme.substring(hashIdx + 1))
        : '';
    final main = hashIdx != -1
        ? withoutScheme.substring(0, hashIdx)
        : withoutScheme;

    final atIdx = main.indexOf('@');
    final hostPart = atIdx != -1 ? main.substring(atIdx + 1) : main;
    final qIdx = hostPart.indexOf('?');
    final hostPort = qIdx != -1 ? hostPart.substring(0, qIdx) : hostPart;

    final lastColon = hostPort.lastIndexOf(':');
    final address = lastColon != -1 ? hostPort.substring(0, lastColon) : hostPort;
    final port = lastColon != -1
        ? int.tryParse(hostPort.substring(lastColon + 1)) ?? 0
        : 0;

    return ServerConfig(
      id: _id(uri),
      remark: remark.isEmpty ? '$address:$port' : remark,
      protocol: 'trojan',
      address: address,
      port: port,
      rawUri: uri,
    );
  }

  // ── Shadowsocks ────────────────────────────────────────────────────────────
  static ServerConfig _parseShadowsocks(String uri) {
    // ss://BASE64(method:password)@host:port#remark  OR  ss://BASE64#remark
    final withoutScheme = uri.substring('ss://'.length);
    final hashIdx = withoutScheme.indexOf('#');
    final remark = hashIdx != -1
        ? Uri.decodeComponent(withoutScheme.substring(hashIdx + 1))
        : '';
    final main = hashIdx != -1
        ? withoutScheme.substring(0, hashIdx)
        : withoutScheme;

    String address = '';
    int port = 0;

    final atIdx = main.indexOf('@');
    if (atIdx != -1) {
      final hostPort = main.substring(atIdx + 1);
      final lastColon = hostPort.lastIndexOf(':');
      address = lastColon != -1 ? hostPort.substring(0, lastColon) : hostPort;
      port = lastColon != -1
          ? int.tryParse(hostPort.substring(lastColon + 1)) ?? 0
          : 0;
    }

    return ServerConfig(
      id: _id(uri),
      remark: remark.isEmpty ? '$address:$port' : remark,
      protocol: 'ss',
      address: address,
      port: port,
      rawUri: uri,
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────
  static String _pad(String s) {
    s = s.replaceAll('-', '+').replaceAll('_', '/');
    final pad = s.length % 4;
    if (pad == 2) return '$s==';
    if (pad == 3) return '$s=';
    return s;
  }

  /// Deterministic short ID from the URI
  static String _id(String uri) {
    var hash = 0;
    for (final c in uri.codeUnits) {
      hash = (hash * 31 + c) & 0x7FFFFFFF;
    }
    return hash.toRadixString(16).padLeft(8, '0');
  }
}
