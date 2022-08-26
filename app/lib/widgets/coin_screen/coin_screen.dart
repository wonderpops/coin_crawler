import 'package:binance_spot/binance_spot.dart';
import 'package:flutter/material.dart';

import '../home_screen/models.dart';

class CoinScreenWidget extends StatefulWidget {
  const CoinScreenWidget({Key? key, required this.data}) : super(key: key);
  final Balance data;

  @override
  State<CoinScreenWidget> createState() => _CoinScreenState();
}

class _CoinScreenState extends State<CoinScreenWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.data.asset, style: const TextStyle(fontSize: 22)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Hero(
              tag: widget.data.asset,
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
                      children: [
                        const Flexible(flex: 2, child: Placeholder()),
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
