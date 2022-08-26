// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:binance_spot/binance_spot.dart';
import 'package:coin_crawler_app/blocs/binance_api_bloc/binance_api_bloc.dart';
import 'package:coin_crawler_app/widgets/coin_screen/coin_screen.dart';
import 'package:coin_crawler_app/widgets/home_screen/models.dart';
import 'package:coin_crawler_app/widgets/settings_screen/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../settings_screen/settings_provider.dart';

class HomeScreenWidget extends StatefulWidget {
  const HomeScreenWidget({Key? key}) : super(key: key);

  @override
  State<HomeScreenWidget> createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends State<HomeScreenWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 16),
        const _TopScreenGreetingWidget(),
        const SizedBox(height: 32),
        _WalletPreviewWidget(),
        const SizedBox(height: 32),
        const _CoinsPreviewWidget(),
        const SizedBox(height: 32),
        const _LastActionsWidget(),
        const SizedBox(height: 32),
      ],
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
  _WalletPreviewWidget({Key? key}) : super(key: key);
  bool isOpen = false;

  @override
  State<_WalletPreviewWidget> createState() => _WalletPreviewWidgetState();
}

class _WalletPreviewWidgetState extends State<_WalletPreviewWidget> {
  @override
  void initState() {
    super.initState();
  }

  Text _calcWalletProfit(List snapshots, int period) {
    double diff = (snapshots[0].data.totalAssetOfBtc -
        snapshots[period].data.totalAssetOfBtc);

    // print(
    //     'a: ${snapshots[0].data.totalAssetOfBtc}, b: ${snapshots[period].data.totalAssetOfBtc}, diff: $diff');

    // diff = roundDouble(diff, 8);

    if (diff > 0) {
      return Text('+${diff.toStringAsFixed(8)}',
          style: const TextStyle(fontSize: 14, color: Colors.green));
    } else if (diff < 0) {
      return Text(
        '${diff.toStringAsFixed(8)}',
        style: const TextStyle(fontSize: 14, color: Colors.red),
      );
    } else {
      return Text(
        diff.toString(),
        style: const TextStyle(fontSize: 14),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    final bloc = context.watch<BinanceAPIBloc>();

    if (bloc.state is! BinanceAPIWalletPreviewLoadedState) {
      bloc.add(LoadWalletPreviewEvent());
    }

    // if (bloc.state is BinanceAPIWalletPreviewLoadedState) {
    //   print(bloc.state);
    // }

    print(bloc.state);

    return BlocConsumer<BinanceAPIBloc, BinanceAPIState>(
        listener: (context, state) {
      if (state is BinanceAPIWalletPreviewLoadedState) {
        inspect(state.walletPreviewData.data);
      }
    }, builder: (context, state) {
      if (state is BinanceAPIWalletPreviewLoadedState) {
        final snapshots = state.walletPreviewData.data.snapshotVos;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            width: double.maxFinite,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: colorScheme.secondaryContainer,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Wallet',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Material(
                              color: colorScheme.secondary.withOpacity(.4),
                              child: IconButton(
                                onPressed: () {
                                  widget.isOpen = !widget.isOpen;
                                  setState(() {});
                                },
                                padding: const EdgeInsets.all(4),
                                icon: Icon(widget.isOpen
                                    ? Icons.arrow_drop_up
                                    : Icons.arrow_drop_down),
                              ),
                            ),
                          ))
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
                        'BTC ',
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(
                        snapshots[0].data.totalAssetOfBtc.toString(),
                        style: TextStyle(fontSize: 24),
                      ),
                      const SizedBox(width: 16),
                      _calcWalletProfit(snapshots, 1),
                    ],
                  ),
                  AnimatedContainer(
                    curve: Curves.fastOutSlowIn,
                    duration: const Duration(seconds: 1),
                    height: widget.isOpen ? 200 : 0,
                    child: Placeholder(),
                  )
                ],
              ),
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
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Wallet',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Material(
                              color: colorScheme.secondary.withOpacity(.4),
                              child: IconButton(
                                onPressed: () {
                                  widget.isOpen = !widget.isOpen;
                                  setState(() {});
                                },
                                padding: const EdgeInsets.all(4),
                                icon: Icon(widget.isOpen
                                    ? Icons.arrow_drop_up
                                    : Icons.arrow_drop_down),
                              ),
                            ),
                          ))
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
                      const Text(
                        'Loading...',
                        style: TextStyle(fontSize: 24),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        '(+ 0.012)',
                        style: '(+ 0.012)'.contains('+')
                            ? const TextStyle(fontSize: 14, color: Colors.green)
                            : const TextStyle(fontSize: 14, color: Colors.red),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }
    });
  }
}

class _CoinBalancePreview extends StatelessWidget {
  const _CoinBalancePreview({Key? key, required this.b}) : super(key: key);
  final Balance b;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [Text(b.asset), Text(b.free.toString())],
      ),
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
    return BlocBuilder<BinanceAPIBloc, BinanceAPIState>(
      builder: (context, state) {
        if (state is BinanceAPIWalletPreviewLoadedState) {
          final snapshot = state.walletPreviewData.data.snapshotVos[0];
          int listLength = snapshot.data.balances.length;
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
                      return carouselView(
                          context, index, snapshot.data.balances);
                    }),
              ),
            ],
          );
        } else {
          int listLength = 2;
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
                    Text('($currentPageIncremented/)',
                        style: const TextStyle(fontSize: 18)),
                  ],
                ),
              ),
              // SizedBox(
              //   height: 250,
              //   child: PageView.builder(
              //       itemCount: dataList.length,
              //       physics: const ClampingScrollPhysics(),
              //       controller: _carouselPageController,
              //       onPageChanged: (value) {
              //         _currentPage = value;
              //         setState(() {});
              //       },
              //       itemBuilder: (context, index) {
              //         return carouselView(context, index, dataList);
              //       }),
              // ),
            ],
          );
        }
      },
    );
  }

  Widget carouselView(context, int index, List coins) {
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
        return BlocBuilder<BinanceAPIBloc, BinanceAPIState>(
          builder: (context, state) {
            return Transform.scale(
              scale: value.abs(),
              child: carouselCard(coins[index]),
            );
          },
        );
      },
    );
  }

  Widget carouselCard(Balance data) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Hero(
              tag: data.asset,
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CoinScreenWidget(data: data)));
                    },
                    child: Container(
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: const [
                            BoxShadow(
                                offset: Offset(0, 4),
                                blurRadius: 4,
                                color: Colors.black26)
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              flex: 0,
                              child: Text(data.asset,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            ),
                            const Flexible(flex: 2, child: Placeholder()),
                            Flexible(
                              flex: 0,
                              child: Text('Total: ${data.free} ${data.asset}',
                                  style: const TextStyle(fontSize: 18)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
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
