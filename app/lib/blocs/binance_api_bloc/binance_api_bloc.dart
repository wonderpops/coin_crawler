import 'package:binance_spot/binance_spot.dart';
import 'package:bloc/bloc.dart';
import 'package:coin_crawler_app/providers/binance_api_provider.dart';
import 'package:meta/meta.dart';

part 'binance_api_event.dart';
part 'binance_api_state.dart';

class BinanceAPIBloc extends Bloc<BinanceAPIEvent, BinanceAPIState> {
  final _bAPIProvider = BinanceAPIProvider();
  BinanceAPIBloc() : super(BinanceApiInitial()) {
    on<LoadWalletPreviewEvent>(onLoadWalletPreview);
  }

  onLoadWalletPreview(
      LoadWalletPreviewEvent event, Emitter<BinanceAPIState> emit) async {
    final walletData = await _bAPIProvider.loadWalletPreviewData();
    print('data_loaded');

    emit(BinanceAPIWalletPreviewLoadedState(
        WalletPreviewData(data: walletData['walletData'])));
  }
}
