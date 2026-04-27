import 'dart:convert';
import 'base64_decoder.dart';

class UriParser {
  /// Parses a VMess URI and returns a map of configuration parameters
  /// Format: vmess://[Base64 encoded JSON]
  static Map<String, dynamic> parseVMessUri(String uri) {
    if (!uri.startsWith('vmess://')) {
      throw FormatException('Invalid VMess URI: must start with vmess://');
    }

    try {
      // Extract Base64 part
      final base64Part = uri.substring(8); // Remove 'vmess://'
      
      // Decode Base64
      final jsonString = Base64Decoder.decodeUrlSafe(base64Part);
      
      // Parse JSON
      final config = json.decode(jsonString) as Map<String, dynamic>;
      
      return config;
    } catch (e) {
      throw FormatException('Failed to parse VMess URI: $e');
    }
  }

  /// Parses a VLess URI and returns a map of configuration parameters
  /// Format: vless://[UUID]@[address]:[port]?[parameters]#[remark]
  static Map<String, dynamic> parseVLessUri(String uri) {
    if (!uri.startsWith('vless://')) {
      throw FormatException('Invalid VLess URI: must start with vless://');
    }

    try {
      // Remove 'vless://' prefix
      final withoutScheme = uri.substring(8);
      
      // Split by '#' to separate remark
      final parts = withoutScheme.split('#');
      final mainPart = parts[0];
      final remark = parts.length > 1 ? Uri.decodeComponent(parts[1]) : '';
      
      // Split by '?' to separate parameters
      final mainAndParams = mainPart.split('?');
      final userAndHost = mainAndParams[0];
      final queryString = mainAndParams.length > 1 ? mainAndParams[1] : '';
      
      // Parse user@host:port
      final atIndex = userAndHost.indexOf('@');
      if (atIndex == -1) {
        throw FormatException('Invalid VLess URI: missing @ separator');
      }
      
      final userId = userAndHost.substring(0, atIndex);
      final hostAndPort = userAndHost.substring(atIndex + 1);
      
      // Parse host:port
      final colonIndex = hostAndPort.lastIndexOf(':');
      if (colonIndex == -1) {
        throw FormatException('Invalid VLess URI: missing port');
      }
      
      final address = hostAndPort.substring(0, colonIndex);
      final port = int.parse(hostAndPort.substring(colonIndex + 1));
      
      // Parse query parameters
      final params = Uri.splitQueryString(queryString);
      
      return {
        'id': userId,
        'add': address,
        'port': port.toString(),
        'ps': remark,
        'type': params['type'] ?? 'tcp',
        'security': params['security'] ?? 'none',
        'encryption': params['encryption'] ?? 'none',
        'flow': params['flow'] ?? '',
        'sni': params['sni'] ?? '',
        'host': params['host'] ?? '',
        'path': params['path'] ?? '',
        'headerType': params['headerType'] ?? 'none',
      };
    } catch (e) {
      throw FormatException('Failed to parse VLess URI: $e');
    }
  }

  /// Determines the protocol type from a URI
  static String getProtocol(String uri) {
    if (uri.startsWith('vmess://')) {
      return 'vmess';
    } else if (uri.startsWith('vless://')) {
      return 'vless';
    } else {
      throw FormatException('Unknown protocol in URI: $uri');
    }
  }
}
