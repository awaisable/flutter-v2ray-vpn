import 'dart:io';
import 'package:http/http.dart' as http;

import '../../core/error/exceptions.dart';
import '../../core/utils/constants.dart';

abstract class RemoteSubscriptionDataSource {
  Future<String> fetchRawSubscription();
}

class RemoteSubscriptionDataSourceImpl implements RemoteSubscriptionDataSource {
  final http.Client _client;

  const RemoteSubscriptionDataSourceImpl(this._client);

  @override
  Future<String> fetchRawSubscription() async {
    try {
      final response = await _client
          .get(Uri.parse(AppConstants.subscriptionUrl))
          .timeout(AppConstants.fetchTimeout);

      if (response.statusCode == 200) {
        final body = response.body.trim();
        if (body.isEmpty) {
          throw const ParseException('Subscription response body is empty.');
        }
        return body;
      } else {
        throw NetworkException(
          'Subscription server returned HTTP ${response.statusCode}.',
        );
      }
    } on SocketException {
      throw const NetworkException('No internet connection.');
    } on HttpException {
      throw const NetworkException('HTTP error while fetching subscription.');
    } on ParseException {
      rethrow;
    } catch (e) {
      throw NetworkException('Unexpected error: $e');
    }
  }
}
