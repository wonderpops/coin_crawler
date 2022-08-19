import 'package:coin_crawler_app/widgets/settings_screen/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class SettingsScreenWidget extends StatelessWidget {
  const SettingsScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Settings', style: TextStyle(fontSize: 22)),
        ),
        backgroundColor: colorScheme.background,
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(children: [_BinanceAPISettingsWidget()]),
        ),
      ),
    );
  }
}

class _BinanceAPISettingsWidget extends StatefulWidget {
  _BinanceAPISettingsWidget({Key? key}) : super(key: key);
  bool isEditing = false;

  @override
  State<_BinanceAPISettingsWidget> createState() =>
      _BinanceAPISettingsWidgetState();
}

class _BinanceAPISettingsWidgetState extends State<_BinanceAPISettingsWidget> {
  @override
  void initState() {
    _settingsProvider.binanceAPIKey.then((value) {
      _binanceAPIKeyController.text = value;
    });
    _settingsProvider.binanceAPISecret.then((value) {
      _binanceAPISecretController.text = value;
    });
    super.initState();
  }

  @override
  void dispose() {
    _binanceAPIKeyController.dispose();
    _binanceAPISecretController.dispose();
    super.dispose();
  }

  final _binanceAPIKeyController = TextEditingController();
  final _binanceAPISecretController = TextEditingController();
  final _settingsProvider = SettingsProvider();
  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('Binance API settings',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            !widget.isEditing
                ? IconButton(
                    onPressed: () {
                      widget.isEditing = true;
                      setState(() {});
                    },
                    icon: Icon(Icons.edit, color: colorScheme.primary))
                : IconButton(
                    onPressed: () {
                      widget.isEditing = false;
                      _settingsProvider
                          .setBinanceAPIKey(_binanceAPIKeyController.text);
                      _settingsProvider.setBinanceAPISecret(
                          _binanceAPISecretController.text);

                      setState(() {});
                    },
                    icon: Icon(
                      Icons.check_outlined,
                      color: colorScheme.primary,
                    )),
          ],
        ),
        TextField(
          enabled: widget.isEditing,
          controller: _binanceAPIKeyController,
          decoration: const InputDecoration(label: Text('API Key')),
        ),
        TextField(
          enabled: widget.isEditing,
          controller: _binanceAPISecretController,
          decoration: const InputDecoration(label: Text('API Secret')),
          obscureText: true,
        ),
      ],
    );
  }
}
