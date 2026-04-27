import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/errors/failures.dart';
import '../../models/server_config_model.dart';

abstract class ServerCacheDataSource {
  Future<void> cacheServers(List<ServerConfigModel> servers);
  Future<List<ServerConfigModel>> getCachedServers();
  Future<bool> isCacheValid();
  Future<void> clearCache();
}

class ServerCacheDataSourceImpl implements ServerCacheDataSource {
  final SharedPreferences sharedPreferences;

  ServerCacheDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheServers(List<ServerConfigModel> servers) async {
    try {
      final jsonList = servers.map((server) => server.toJson()).toList();
      final jsonString = json.encode(jsonList);
      
      await sharedPreferences.setString(
        AppConstants.cachedServersKey,
        jsonString,
      );
      
      await sharedPreferences.setInt(
        AppConstants.cacheTimestampKey,
        DateTime.now().millisecondsSinceEpoch,
      );
    } catch (e) {
      throw CacheFailure('Failed to cache servers: $e');
    }
  }

  @override
  Future<List<ServerConfigModel>> getCachedServers() async {
    try {
      final jsonString = sharedPreferences.getString(AppConstants.cachedServersKey);
      
      if (jsonString == null) {
        return [];
      }

      final jsonList = json.decode(jsonString) as List<dynamic>;
      return jsonList
          .map((json) => ServerConfigModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw CacheFailure('Failed to retrieve cached servers: $e');
    }
  }

  @override
  Future<bool> isCacheValid() async {
    try {
      final timestamp = sharedPreferences.getInt(AppConstants.cacheTimestampKey);
      
      if (timestamp == null) {
        return false;
      }

      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();
      final difference = now.difference(cacheTime);

      return difference < AppConstants.cacheExpiry;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await sharedPreferences.remove(AppConstants.cachedServersKey);
      await sharedPreferences.remove(AppConstants.cacheTimestampKey);
    } catch (e) {
      throw CacheFailure('Failed to clear cache: $e');
    }
  }
}
