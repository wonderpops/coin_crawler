import 'dart:developer';

import 'package:binance_spot/binance_spot.dart';
import 'package:either_dart/either.dart';
import 'package:coin_crawler_app/widgets/settings_screen/settings_provider.dart';

class BinanceAPIProvider {
  final _settingsProvider = SettingsProvider();

  Future<BinanceSpot> _getBinanceAPISpot() async {
    String accessKey = await _settingsProvider.binanceAPIKey;
    String secretKey = await _settingsProvider.binanceAPISecret;
    return BinanceSpot(
      key: accessKey,
      secret: secretKey,
    );
  }

  Future<Snapshots> getWalletPreviewData() async {
    BinanceSpot binanceSpot = await _getBinanceAPISpot();
    // inspect(binanceSpot);
    final walletData =
        await binanceSpot.dailyAccountSnapshot(type: 'SPOT', recvWindow: 60000);

    if (walletData.isRight) {
      return (walletData.right);
    } else {
      throw Exception('Error loading wallet data');
    }
  }

  Future<List<Kline>> getCoinCandleData(String coin) async {
    BinanceSpot binanceSpot = await _getBinanceAPISpot();
    String coinPair;
    if (coin == 'BUSD') {
      coinPair = 'BUSDUSDT';
    } else {
      coinPair = '${coin}BUSD';
    }

    final coinData = await binanceSpot.candlestickData(
        symbol: coinPair, interval: Interval.INTERVAL_15m, limit: 96);

    inspect(coinData);

    if (coinData.isRight) {
      return (coinData.right);
    } else {
      throw Exception('Error loading coin data');
    }
  }
}
