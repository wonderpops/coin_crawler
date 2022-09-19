import 'package:binance_spot/binance_spot.dart';
import 'package:coin_crawler_app/blocs/home_screen_data_loader_bloc/home_screen_data_loader_bloc.dart';
import 'package:flutter/material.dart';

class CoinScreenWidget extends StatefulWidget {
  const CoinScreenWidget({Key? key, required this.data}) : super(key: key);
  final CoinPreviewData data;

  @override
  State<CoinScreenWidget> createState() => _CoinScreenState();
}

class _CoinScreenState extends State<CoinScreenWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.data.shortName, style: const TextStyle(fontSize: 22)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Hero(
              tag: widget.data.shortName,
              child: Material(
                type: MaterialType.transparency,
                child: Container(
                  width: double.maxFinite,
                  height: 400,
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
                      children: const [
                        Flexible(flex: 2, child: Placeholder()),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
