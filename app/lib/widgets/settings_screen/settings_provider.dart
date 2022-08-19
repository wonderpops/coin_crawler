import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SettingsProvider {
  final storage = const FlutterSecureStorage();

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  Future<String> get binanceAPIKey async {
    return await storage.read(
            key: 'binance_api_key', aOptions: _getAndroidOptions()) ??
        '';
  }

  setBinanceAPIKey(String key) async {
    await storage.write(
        key: 'binance_api_key', value: key, aOptions: _getAndroidOptions());
  }

  Future<String> get binanceAPISecret async {
    return await storage.read(
            key: 'binance_api_secret', aOptions: _getAndroidOptions()) ??
        '';
  }

  setBinanceAPISecret(String key) async {
    await storage.write(
        key: 'binance_api_secret', value: key, aOptions: _getAndroidOptions());
  }
}
