import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_v2ray_vpn/core/utils/uri_parser.dart';

void main() {
  group('UriParser', () {
    group('VMess', () {
      test('should parse valid VMess URI', () {
        // Base64 encoded: {"v":"2","ps":"Test Server","add":"example.com","port":"443","id":"test-uuid","aid":"0","net":"tcp","type":"none","tls":"tls"}
        const vmessUri =
            'vmess://eyJ2IjoiMiIsInBzIjoiVGVzdCBTZXJ2ZXIiLCJhZGQiOiJleGFtcGxlLmNvbSIsInBvcnQiOiI0NDMiLCJpZCI6InRlc3QtdXVpZCIsImFpZCI6IjAiLCJuZXQiOiJ0Y3AiLCJ0eXBlIjoibm9uZSIsInRscyI6InRscyJ9';

        final config = UriParser.parseVMessUri(vmessUri);

        expect(config['ps'], 'Test Server');
        expect(config['add'], 'example.com');
        expect(config['port'], '443');
        expect(config['id'], 'test-uuid');
        expect(config['net'], 'tcp');
      });

      test('should throw FormatException for invalid VMess URI', () {
        const invalidUri = 'vmess://invalid-base64!!!';
        expect(
          () => UriParser.parseVMessUri(invalidUri),
          throwsFormatException,
        );
      });

      test('should throw FormatException for non-VMess URI', () {
        const vlessUri = 'vless://test@example.com:443';
        expect(
          () => UriParser.parseVMessUri(vlessUri),
          throwsFormatException,
        );
      });
    });

    group('VLess', () {
      test('should parse valid VLess URI', () {
        const vlessUri =
            'vless://test-uuid@example.com:443?type=tcp&security=tls&sni=example.com#Test%20Server';

        final config = UriParser.parseVLessUri(vlessUri);

        expect(config['id'], 'test-uuid');
        expect(config['add'], 'example.com');
        expect(config['port'], '443');
        expect(config['ps'], 'Test Server');
        expect(config['type'], 'tcp');
        expect(config['security'], 'tls');
        expect(config['sni'], 'example.com');
      });

      test('should parse VLess URI without remark', () {
        const vlessUri = 'vless://test-uuid@example.com:443';

        final config = UriParser.parseVLessUri(vlessUri);

        expect(config['id'], 'test-uuid');
        expect(config['add'], 'example.com');
        expect(config['port'], '443');
        expect(config['ps'], '');
      });

      test('should throw FormatException for invalid VLess URI', () {
        const invalidUri = 'vless://invalid-format';
        expect(
          () => UriParser.parseVLessUri(invalidUri),
          throwsFormatException,
        );
      });

      test('should throw FormatException for non-VLess URI', () {
        const vmessUri = 'vmess://eyJ2IjoiMiJ9';
        expect(
          () => UriParser.parseVLessUri(vmessUri),
          throwsFormatException,
        );
      });
    });

    group('getProtocol', () {
      test('should identify VMess protocol', () {
        const uri = 'vmess://test';
        expect(UriParser.getProtocol(uri), 'vmess');
      });

      test('should identify VLess protocol', () {
        const uri = 'vless://test';
        expect(UriParser.getProtocol(uri), 'vless');
      });

      test('should throw FormatException for unknown protocol', () {
        const uri = 'trojan://test';
        expect(
          () => UriParser.getProtocol(uri),
          throwsFormatException,
        );
      });
    });
  });
}
