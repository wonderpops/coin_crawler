class CoinsPreviewCardDataModel {
  final String name;
  final String shortName;

  CoinsPreviewCardDataModel(this.name, this.shortName);
}

List<CoinsPreviewCardDataModel> dataList = [
  CoinsPreviewCardDataModel("Polygon matic / Binance USD", "MATIC/BUSD"),
  CoinsPreviewCardDataModel("Polygon matic / Binance USD", "MATIC/BUS"),
  CoinsPreviewCardDataModel("Polygon matic / Binance USD", "MATIC/BU"),
  CoinsPreviewCardDataModel("Polygon matic / Binance USD", "MATIC/B"),
];

class ActionPreviewDataModel {
  final String coinShortName;
  final double price;
  final double profit;
  final String actionType;
  final DateTime date;

  ActionPreviewDataModel(
      this.coinShortName, this.price, this.profit, this.actionType, this.date);
}

List<ActionPreviewDataModel> actionsList = [
  ActionPreviewDataModel('MATIC/BUSD', 10.2, 0.3, 'sell', DateTime.now()),
  ActionPreviewDataModel('MATIC/BUSD', 9.4, 0.9, 'buy', DateTime.now()),
  ActionPreviewDataModel('MATIC/BUSD', 12.1, 0.2, 'sell', DateTime.now()),
  ActionPreviewDataModel('MATIC/BUSD', 42.05, 0.312, 'sell', DateTime.now()),
  ActionPreviewDataModel('MATIC/BUSD', 123, 12.34, 'buy', DateTime.now()),
];
