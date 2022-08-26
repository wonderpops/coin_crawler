part of 'binance_api_bloc.dart';

@immutable
abstract class BinanceAPIState {}

class BinanceApiInitial extends BinanceAPIState {}

class BinanceAPIWalletPreviewLoadedState extends BinanceAPIState {
  final WalletPreviewData walletPreviewData;

  BinanceAPIWalletPreviewLoadedState(this.walletPreviewData);
}

class WalletPreviewData {
  final Snapshots data;

  WalletPreviewData({required this.data});
}
