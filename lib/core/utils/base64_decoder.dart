import 'dart:convert';

import '../error/exceptions.dart';

/// Decodes a Base64 (or Base64URL) encoded string and splits it into
/// individual V2Ray URI lines (vmess://, vless://, etc.).
class Base64DecoderService {
  /// Returns a list of non-empty URI strings.
  /// Throws [ParseException] if the input cannot be decoded.
  List<String> decodeSubscription(String raw) {
    if (raw.trim().isEmpty) {
      throw const ParseException('Subscription response is empty.');
    }

    String decoded;
    try {
      // Normalize: replace URL-safe chars and add padding
      final normalized = _normalize(raw.trim());
      final bytes = base64.decode(normalized);
      decoded = utf8.decode(bytes);
    } catch (_) {
      // Some subscriptions are plain-text (not Base64); try as-is
      decoded = raw;
    }

    return decoded
        .split(RegExp(r'[\r\n]+'))
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty && _isSupportedUri(l))
        .toList();
  }

  String _normalize(String input) {
    // Replace URL-safe Base64 chars
    var s = input.replaceAll('-', '+').replaceAll('_', '/');
    // Add padding
    final pad = s.length % 4;
    if (pad == 2) s += '==';
    if (pad == 3) s += '=';
    return s;
  }

  bool _isSupportedUri(String line) =>
      line.startsWith('vmess://') ||
      line.startsWith('vless://') ||
      line.startsWith('trojan://') ||
      line.startsWith('ss://');
}
