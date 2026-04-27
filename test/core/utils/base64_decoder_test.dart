import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_v2ray_vpn/core/utils/base64_decoder.dart';

void main() {
  group('Base64Decoder', () {
    test('should decode valid Base64 string', () {
      const base64String = 'SGVsbG8gV29ybGQ='; // "Hello World"
      final result = Base64Decoder.decode(base64String);
      expect(result, 'Hello World');
    });

    test('should decode URL-safe Base64 string', () {
      const urlSafeBase64 = 'SGVsbG8gV29ybGQ'; // Without padding
      final result = Base64Decoder.decodeUrlSafe(urlSafeBase64);
      expect(result, 'Hello World');
    });

    test('should split subscription into individual URIs', () {
      const decodedData = '''
vmess://eyJ2IjoiMiIsInBzIjoidGVzdCJ9
vless://test@example.com:443
vmess://eyJ2IjoiMiIsInBzIjoidGVzdDIifQ==
''';
      final uris = Base64Decoder.splitSubscription(decodedData);
      expect(uris.length, 3);
      expect(uris[0].startsWith('vmess://'), true);
      expect(uris[1].startsWith('vless://'), true);
      expect(uris[2].startsWith('vmess://'), true);
    });

    test('should filter out non-URI lines', () {
      const decodedData = '''
# Comment line
vmess://eyJ2IjoiMiIsInBzIjoidGVzdCJ9

vless://test@example.com:443
invalid line
''';
      final uris = Base64Decoder.splitSubscription(decodedData);
      expect(uris.length, 2);
    });

    test('should throw FormatException for invalid Base64', () {
      const invalidBase64 = 'This is not Base64!!!';
      expect(
        () => Base64Decoder.decode(invalidBase64),
        throwsFormatException,
      );
    });
  });
}
