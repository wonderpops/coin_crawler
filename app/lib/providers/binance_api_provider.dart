import 'package:binance_spot/binance_spot.dart';
import 'package:coin_crawler_app/widgets/settings_screen/settings_provider.dart';

class BinanceAPIProvider {
  final _settingsProvider = SettingsProvider();

  Future<BinanceSpot> getBinanceAPISwagger() async {
    String accessKey = await _settingsProvider.binanceAPIKey;
    String secretKey = await _settingsProvider.binanceAPISecret;
    return BinanceSpot(
      key: accessKey,
      secret: secretKey,
    );
  }

  Future<Map<String, dynamic>> loadWalletPreviewData() async {
    BinanceSpot binanceSpot = await getBinanceAPISwagger();
    final walletData =
        await binanceSpot.dailyAccountSnapshot(type: 'SPOT', recvWindow: 10000);

    // final walletData.left =

    return {
      'walletData': walletData.isRight ? walletData.right : walletData.left,
    };

    // return {
    //   'walletData': binanceSpot,
    // };
  }
}
