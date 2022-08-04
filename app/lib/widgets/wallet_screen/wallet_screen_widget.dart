import 'package:flutter/material.dart';

class WalletScreenWidget extends StatelessWidget {
  const WalletScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: 100,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).colorScheme.tertiaryContainer,
              ),
              height: 60,
            ),
          );
        });
  }
}
