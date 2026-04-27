import 'package:http/http.dart' as http;
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/base64_decoder.dart';
import '../../../core/errors/failures.dart';
import '../../models/server_config_model.dart';

abstract class SubscriptionRemoteDataSource {
  Future<List<ServerConfigModel>> fetchServers();
}

class SubscriptionRemoteDataSourceImpl implements SubscriptionRemoteDataSource {
  final http.Client client;

  SubscriptionRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ServerConfigModel>> fetchServers() async {
    try {
      // Fetch subscription data
      final response = await client
          .get(
            Uri.parse(AppConstants.subscriptionUrl),
          )
          .timeout(AppConstants.httpTimeout);

      if (response.statusCode != 200) {
        throw ServerFailure(
          'Failed to fetch subscription: HTTP ${response.statusCode}',
        );
      }

      // Decode Base64 response
      final decodedData = Base64Decoder.decode(response.body);

      // Split into individual URIs
      final uris = Base64Decoder.splitSubscription(decodedData);

      if (uris.isEmpty) {
        throw const ParseFailure('No valid server configurations found');
      }

      // Parse each URI into ServerConfigModel
      final servers = <ServerConfigModel>[];
      for (final uri in uris) {
        try {
          final server = ServerConfigModel.fromUri(uri);
          servers.add(server);
        } catch (e) {
          // Log and skip invalid configurations
          print('Skipping invalid server URI: $e');
          continue;
        }
      }

      if (servers.isEmpty) {
        throw const ParseFailure('All server configurations were invalid');
      }

      return servers;
    } on http.ClientException catch (e) {
      throw NetworkFailure('Network error: ${e.message}');
    } on FormatException catch (e) {
      throw ParseFailure('Parse error: ${e.message}');
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure('Unexpected error: $e');
    }
  }
}
