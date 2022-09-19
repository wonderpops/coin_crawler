part of 'home_screen_data_loader_bloc.dart';

@immutable
abstract class HomeScreenDataLoaderState {}

class HomeScreenDataLoaderInitial extends HomeScreenDataLoaderState {}

class HomeScreenDataLoaderLoadingState extends HomeScreenDataLoaderState {}

class HomeScreenDataLoaderLoadedState extends HomeScreenDataLoaderState {
  final UserData userData;
  final WalletPreviewData walletPreviewData;
  final List<CoinPreviewData> coinsPreviewData;

  HomeScreenDataLoaderLoadedState(
      {required this.userData,
      required this.walletPreviewData,
      required this.coinsPreviewData});
}

class WalletPreviewData {
  final Snapshots data;

  WalletPreviewData({required this.data});
}

class CoinPreviewData {
  final String shortName;
  final List<Kline> candles;
  final double amount;

  CoinPreviewData(
      {required this.shortName, required this.candles, required this.amount});
}

class UserData {
  final String username;
  UserData({required this.username});
}
