// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:binance_spot/binance_spot.dart';
import 'package:coin_crawler_app/providers/binance_api_provider.dart';
import 'package:coin_crawler_app/widgets/coin_screen/coin_screen.dart';
import 'package:coin_crawler_app/widgets/home_screen/models.dart';
import 'package:coin_crawler_app/widgets/settings_screen/settings_screen.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../blocs/home_screen_data_loader_bloc/home_screen_data_loader_bloc.dart';

class HomeScreenWidget extends StatefulWidget {
  const HomeScreenWidget({Key? key}) : super(key: key);

  @override
  State<HomeScreenWidget> createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends State<HomeScreenWidget> {
  @override
  void initState() {
    final bAPIBloc = context.read<HomeScreenDataLoaderBloc>();
    if (bAPIBloc.state is HomeScreenDataLoaderInitial) {
      bAPIBloc.add(LoadHomeScreenDataEvent());
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        final bAPIBloc = context.read<HomeScreenDataLoaderBloc>();
        bAPIBloc.add(LoadHomeScreenDataEvent());
        await bAPIBloc.stream.firstWhere(
            ((element) => element is HomeScreenDataLoaderLoadedState));
      },
      child: ListView(
        children: const [
          SizedBox(height: 16),
          _TopScreenGreetingWidget(),
          SizedBox(height: 32),
          _WalletPreviewWidget(),
          SizedBox(height: 32),
          _CoinsPreviewWidget(),
          SizedBox(height: 32),
          _LastActionsWidget(),
          SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _TopScreenGreetingWidget extends StatelessWidget {
  const _TopScreenGreetingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Good Evening,',
                style: TextStyle(fontSize: 24),
              ),
              Text(
                'Wonderpop',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              )
            ],
          ),
          Row(
            children: [
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 12),
                      child: Icon(Icons.notifications_none,
                          color: colorScheme.inverseSurface),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        // showModalBottomSheet(
                        //     backgroundColor: Colors.transparent,
                        //     context: context,
                        //     builder: (context) {
                        //       //   return _NotificationsBoxWidget(
                        //       //       notifications: notifications);
                        //     });
                      },
                      splashColor: colorScheme.tertiary.withOpacity(.3),
                      hoverColor: colorScheme.tertiary.withOpacity(.3),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        alignment: Alignment.center,
                        width: 48,
                        height: 48,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: true,
                    child: Positioned(
                        top: 8,
                        right: 10,
                        child: Container(
                          height: 8,
                          width: 8,
                          decoration: BoxDecoration(
                              color: colorScheme.tertiary,
                              borderRadius: BorderRadius.circular(8)),
                        )),
                  )
                ],
              ),
              const SizedBox(width: 16),
              Hero(
                tag: 'user',
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: colorScheme.inversePrimary,
                      child: Icon(Icons.person_outline_outlined,
                          color: colorScheme.inverseSurface),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const SettingsScreenWidget()));
                        },
                        splashColor: colorScheme.tertiary.withOpacity(.3),
                        hoverColor: colorScheme.tertiary.withOpacity(.3),
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          alignment: Alignment.center,
                          width: 60,
                          height: 60,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _WalletPreviewWidget extends StatefulWidget {
  const _WalletPreviewWidget({Key? key}) : super(key: key);

  @override
  State<_WalletPreviewWidget> createState() => _WalletPreviewWidgetState();
}

class _WalletPreviewWidgetState extends State<_WalletPreviewWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return BlocConsumer<HomeScreenDataLoaderBloc, HomeScreenDataLoaderState>(
        listener: (context, state) {
      if (state is HomeScreenDataLoaderLoadedState) {
        inspect(state);
      }
    }, builder: (context, state) {
      if (state is HomeScreenDataLoaderLoadedState) {
        final snapshots = state.walletPreviewData.data.snapshotVos;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            width: double.maxFinite,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: colorScheme.secondaryContainer,
            ),
            child: Row(
              children: [
                Flexible(
                  flex: 4,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 16, top: 16, bottom: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'Wallet',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            // Container(
                            //     decoration: BoxDecoration(
                            //       borderRadius: BorderRadius.circular(30),
                            //     ),
                            //     child: ClipRRect(
                            //       borderRadius: BorderRadius.circular(30),
                            //       child: Material(
                            //         color: colorScheme.secondary.withOpacity(.4),
                            //         child: IconButton(
                            //           onPressed: () {
                            //             widget.isOpen = !widget.isOpen;
                            //             setState(() {});
                            //           },
                            //           padding: const EdgeInsets.all(4),
                            //           icon: Icon(widget.isOpen
                            //               ? Icons.arrow_drop_up
                            //               : Icons.arrow_drop_down),
                            //         ),
                            //       ),
                            //     ))
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Total balance',
                          style: TextStyle(
                              fontSize: 18, color: colorScheme.inverseSurface),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'BTC',
                              style: TextStyle(fontSize: 14),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              snapshots[0].data.totalAssetOfBtc.toString(),
                              style: const TextStyle(fontSize: 24),
                            ),
                          ],
                        ),
                        Row(
                          children: [_WalletProfitWidget(snapshots: snapshots)],
                        )
                      ],
                    ),
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                      child: Stack(
                        children: [
                          SizedBox(
                            height: 162,
                            child: SfCartesianChart(
                                plotAreaBorderColor: Colors.transparent,
                                primaryXAxis: DateTimeAxis(isVisible: false),
                                primaryYAxis: NumericAxis(isVisible: false),
                                margin: const EdgeInsets.all(0.2),
                                series: <
                                    SplineAreaSeries<SnapshotVos, DateTime>>[
                                  SplineAreaSeries<SnapshotVos, DateTime>(
                                      splineType: SplineType.monotonic,
                                      color:
                                          colorScheme.primary.withOpacity(.2),
                                      borderWidth: 4,
                                      borderGradient: LinearGradient(
                                          colors: <Color>[
                                            colorScheme.surfaceTint,
                                            colorScheme.tertiary
                                          ],
                                          stops: const <double>[
                                            0,
                                            1
                                          ]),
                                      dataSource: snapshots,
                                      xValueMapper: (SnapshotVos snap, _) =>
                                          DateTime.fromMicrosecondsSinceEpoch(
                                              snap.updateTime),
                                      yValueMapper: (SnapshotVos snap, _) =>
                                          snap.data.totalAssetOfBtc)
                                ]),
                          ),
                          Container(
                              height: 162,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                stops: const [0, 0.5],
                                colors: [
                                  colorScheme.secondaryContainer,
                                  colorScheme.secondaryContainer
                                      .withOpacity(.1),
                                ],
                              ))),
                        ],
                      )),
                ),
              ],
            ),
          ),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            width: double.maxFinite,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: colorScheme.secondaryContainer,
            ),
            child: Row(
              children: [
                Flexible(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Wallet',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Total balance',
                          style: TextStyle(
                              fontSize: 18, color: colorScheme.inverseSurface),
                        ),
                        Shimmer.fromColors(
                          baseColor: Colors.grey,
                          highlightColor: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(.2),
                                  borderRadius: BorderRadius.circular(30)),
                              height: 18,
                              width: double.maxFinite,
                            ),
                          ),
                        ),
                        Shimmer.fromColors(
                          baseColor: Colors.grey,
                          highlightColor: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(.2),
                                  borderRadius: BorderRadius.circular(30)),
                              height: 12,
                              width: double.maxFinite,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Flexible(flex: 3, child: SizedBox())
              ],
            ),
          ),
        );
      }
    });
  }
}

class _WalletProfitWidget extends StatefulWidget {
  _WalletProfitWidget({Key? key, required this.snapshots}) : super(key: key);
  final List snapshots;
  int period = 1;

  @override
  State<_WalletProfitWidget> createState() => __WalletProfitWidgetState();
}

class __WalletProfitWidgetState extends State<_WalletProfitWidget> {
  Text _calcWalletProfit(List snapshots, int period) {
    snapshots = snapshots.reversed.toList();
    double diff = (snapshots[0].data.totalAssetOfBtc -
        snapshots[period].data.totalAssetOfBtc);

    double p_diff = 100 * diff / snapshots[0].data.totalAssetOfBtc;

    // print('$diff, $p_diff');

    // print(
    //     'a: ${snapshots[0].data.totalAssetOfBtc}, b: ${snapshots[period].data.totalAssetOfBtc}, diff: $diff');

    // diff = roundDouble(diff, 8);

    if (diff > 0) {
      return Text('(+${p_diff.toStringAsFixed(2)}%)',
          style: const TextStyle(fontSize: 14, color: Colors.green));
    } else if (diff < 0) {
      return Text(
        '(${p_diff.toStringAsFixed(2)}%)',
        style: const TextStyle(fontSize: 14, color: Colors.red),
      );
    } else {
      return Text(
        '(${p_diff.toString()}%)',
        style: const TextStyle(fontSize: 14),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _calcWalletProfit(widget.snapshots, widget.period),
        ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                  onTap: () {
                    if (widget.period == 1) {
                      widget.period = 6;
                    } else {
                      widget.period = 1;
                    }
                    setState(() {});
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(widget.period == 1
                        ? 'for last 24 hours'
                        : 'for last week'),
                  ))),
        ),
      ],
    );
  }
}

class _CoinsPreviewWidget extends StatefulWidget {
  const _CoinsPreviewWidget({Key? key}) : super(key: key);

  @override
  State<_CoinsPreviewWidget> createState() => _CoinsPreviewWidgetState();
}

class _CoinsPreviewWidgetState extends State<_CoinsPreviewWidget> {
  late PageController _carouselPageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _carouselPageController =
        PageController(initialPage: _currentPage, viewportFraction: 0.6);
  }

  @override
  void dispose() {
    super.dispose();
    _carouselPageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeScreenDataLoaderBloc, HomeScreenDataLoaderState>(
      builder: (context, state) {
        if (state is HomeScreenDataLoaderLoadedState) {
          final coinsData = state.coinsPreviewData;
          int listLength = coinsData.length;
          int currentPageIncremented = _currentPage + 1;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Row(
                  children: [
                    const Text('Coins ',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    Text('($currentPageIncremented/$listLength)',
                        style: const TextStyle(fontSize: 18)),
                  ],
                ),
              ),
              SizedBox(
                height: 250,
                child: PageView.builder(
                    itemCount: listLength,
                    physics: const ClampingScrollPhysics(),
                    controller: _carouselPageController,
                    onPageChanged: (value) {
                      _currentPage = value;
                      setState(() {});
                    },
                    itemBuilder: (context, index) {
                      return carouselView(context, index, coinsData);
                    }),
              ),
            ],
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Row(
                  children: [
                    const Text('Coins ',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    const Text('(', style: TextStyle(fontSize: 18)),
                    Shimmer.fromColors(
                      baseColor: Colors.grey,
                      highlightColor: Colors.white,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.grey.withOpacity(.2)),
                        height: 26,
                        width: 35,
                      ),
                    ),
                    const Text(')', style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
              SizedBox(
                height: 250,
                child: PageView.builder(
                    itemCount: dataList.length,
                    physics: const ClampingScrollPhysics(),
                    controller: _carouselPageController,
                    onPageChanged: (value) {
                      _currentPage = value;
                      setState(() {});
                    },
                    itemBuilder: (context, index) {
                      return carouselView(context, index);
                    }),
              ),
            ],
          );
        }
      },
    );
  }

  Widget carouselView(context, int index, [List<CoinPreviewData>? coins]) {
    return AnimatedBuilder(
      animation: _carouselPageController,
      builder: (context, child) {
        double value = 0;
        if (_carouselPageController.position.haveDimensions) {
          if (index.toDouble() > (_carouselPageController.page ?? 0)) {
            value = (0.5 /
                    ((_carouselPageController.page ?? 0) - index.toDouble())
                        .abs()) +
                0.25;
          } else if (index.toDouble() < (_carouselPageController.page ?? 0)) {
            value = (0.5 /
                    (((_carouselPageController.page ?? 0) - index.toDouble()) *
                            -1)
                        .abs()) +
                0.25;
          } else {
            value = (_carouselPageController.page ?? 0) + index.toDouble() == 0
                ? 1
                : index.toDouble();
          }
          // value = (_carouselPageController.page ?? 0) - index.toDouble() + 1;
          value = (value).clamp(0.5, 1);
        } else if (index.toDouble() == 0) {
          value = 1;
        } else {
          value = 0.75;
        }
        // print("value $value index $index");
        return Transform.scale(
          scale: value.abs(),
          child: coins == null
              ? notLoadedCarouselCard()
              : loadedCarouselCard(coins[index]),
        );
      },
    );
  }

  Widget notLoadedCarouselCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey,
      highlightColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.grey.withOpacity(.2)),
          height: 250,
          width: double.maxFinite,
        ),
      ),
    );
  }

  Widget loadedCarouselCard(CoinPreviewData data) {
    final colorScheme = Theme.of(context).colorScheme;
    return Stack(
      children: [
        Column(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Hero(
                  tag: data.shortName,
                  child: Material(
                    type: MaterialType.transparency,
                    child: Container(
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            flex: 0,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, top: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(data.shortName,
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                      'Amount: ${data.amount} ${data.shortName}',
                                      style: const TextStyle(fontSize: 15)),
                                  Text('Price: ${data.candles.last.close} \$',
                                      style: const TextStyle(fontSize: 15)),
                                  Text(
                                      'Total: ${(data.candles.last.close * data.amount).toStringAsFixed(2)} \$',
                                      style: const TextStyle(fontSize: 15)),
                                ],
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 2,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: SfCartesianChart(
                                  plotAreaBorderColor: Colors.transparent,
                                  primaryXAxis: DateTimeAxis(isVisible: false),
                                  primaryYAxis: NumericAxis(isVisible: false),
                                  margin: const EdgeInsets.all(0.1),
                                  series: <SplineAreaSeries<Kline, DateTime>>[
                                    SplineAreaSeries<Kline, DateTime>(
                                        splineType: SplineType.monotonic,
                                        color:
                                            colorScheme.primary.withOpacity(.2),
                                        borderWidth: 4,
                                        borderGradient: LinearGradient(
                                            colors: <Color>[
                                              colorScheme.surfaceTint,
                                              colorScheme.tertiary
                                            ],
                                            stops: const <double>[
                                              0,
                                              1
                                            ]),
                                        dataSource: data.candles,
                                        xValueMapper: (Kline candle, _) =>
                                            DateTime.fromMicrosecondsSinceEpoch(
                                                candle.closeTimestamp),
                                        yValueMapper: (Kline snap, _) =>
                                            snap.close)
                                  ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Material(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CoinScreenWidget(data: data)));
              },
              splashColor: colorScheme.tertiary.withOpacity(.3),
              hoverColor: colorScheme.tertiary.withOpacity(.3),
              borderRadius: BorderRadius.circular(30),
              child: Container(
                alignment: Alignment.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LastActionsWidget extends StatefulWidget {
  const _LastActionsWidget({Key? key}) : super(key: key);

  @override
  State<_LastActionsWidget> createState() => _LastActionsWidgetState();
}

class _LastActionsWidgetState extends State<_LastActionsWidget> {
  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Last actions',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: colorScheme.secondaryContainer),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Table(
                    border: TableBorder(
                        horizontalInside:
                            BorderSide(color: colorScheme.onBackground)),
                    columnWidths: const {
                      0: FlexColumnWidth(2),
                      2: FlexColumnWidth(1),
                      3: FlexColumnWidth(1),
                      4: FlexColumnWidth(4)
                    },
                    children: actionsList.map<TableRow>((d) {
                      return TableRow(children: [
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.bottom,
                          child: SizedBox(
                            height: 60,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                d.coinShortName,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Text(
                            d.profit.toString(),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Text(
                            d.actionType,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        const TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Text(
                            // TODO replace with real date
                            '20:30 02/08',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ]);
                    }).toList(),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      actionsList += [
                        ActionPreviewDataModel(
                            'MATIC/BUSD', 10.2, 0.3, 'sell', DateTime.now()),
                        ActionPreviewDataModel(
                            'MATIC/BUSD', 9.4, 0.9, 'buy', DateTime.now()),
                        ActionPreviewDataModel(
                            'MATIC/BUSD', 12.1, 0.2, 'sell', DateTime.now()),
                        ActionPreviewDataModel(
                            'MATIC/BUSD', 42.05, 0.312, 'sell', DateTime.now()),
                        ActionPreviewDataModel(
                            'MATIC/BUSD', 123, 12.34, 'buy', DateTime.now()),
                      ];
                      setState(() {});
                    },
                    child: const Text('Load more...'),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
