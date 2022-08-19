import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider {
  final storage = const FlutterSecureStorage();

  Future<String> get username async {
    final prefs = await SharedPreferences.getInstance();
    final String? username = prefs.getString('username');
    return username ?? '';
  }

  setUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
  }

  Future<String> get appThemeMode async {
    final prefs = await SharedPreferences.getInstance();
    final String? appThemeMode = prefs.getString('appThemeMode');
    return appThemeMode ?? 'Light';
  }

  setAppThemeMode(String appThemeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('appThemeMode', appThemeMode);
  }

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
