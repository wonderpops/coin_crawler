import 'dart:developer';

import 'package:binance_spot/binance_spot.dart';
import 'package:bloc/bloc.dart';
import 'package:coin_crawler_app/providers/binance_api_provider.dart';
import 'package:meta/meta.dart';

part 'home_screen_data_loader_event.dart';
part 'home_screen_data_loader_state.dart';

class HomeScreenDataLoaderBloc
    extends Bloc<HomeScreenDataLoaderEvent, HomeScreenDataLoaderState> {
  final _bAPIProvider = BinanceAPIProvider();
  HomeScreenDataLoaderBloc() : super(HomeScreenDataLoaderInitial()) {
    on<LoadHomeScreenDataEvent>(onLoadWalletPreview);
  }

  onLoadWalletPreview(LoadHomeScreenDataEvent event,
      Emitter<HomeScreenDataLoaderState> emit) async {
    emit(HomeScreenDataLoaderLoadingState());

    final walletData = await _bAPIProvider.getWalletPreviewData();
    final List<CoinPreviewData> coinsData = [];

    for (var coin in walletData.snapshotVos[0].data.balances) {
      try {
        List<Kline> candles = await _bAPIProvider.getCoinCandleData(coin.asset);
        coinsData.add(CoinPreviewData(
            shortName: coin.asset, candles: candles, amount: coin.free));
      } catch (e) {
        // inspect(e);
      }
    }

    // inspect(coinsData);

    print('home screen data loaded');

    emit(HomeScreenDataLoaderLoadedState(
        walletPreviewData: WalletPreviewData(data: walletData),
        coinsPreviewData: coinsData));

    // await Future.delayed(Duration(seconds: 3));
  }
}
