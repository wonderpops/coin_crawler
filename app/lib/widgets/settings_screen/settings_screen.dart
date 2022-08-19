import 'package:coin_crawler_app/widgets/settings_screen/settings_provider.dart';
import 'package:flutter/material.dart';

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
          child: ListView(children: [
            const _UserAvatar(),
            const SizedBox(height: 32),
            _ProfileSettingsWidget(),
            const SizedBox(height: 32),
            _AppSettingsWidget(),
            const SizedBox(height: 32),
            _BinanceAPISettingsWidget()
          ]),
        ),
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  const _UserAvatar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Hero(
        tag: 'user',
        child: Stack(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: colorScheme.inversePrimary,
              child: Icon(
                Icons.person_outline_outlined,
                color: colorScheme.inverseSurface,
                size: 50,
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {},
                splashColor: colorScheme.tertiary.withOpacity(.3),
                hoverColor: colorScheme.tertiary.withOpacity(.3),
                borderRadius: BorderRadius.circular(60),
                child: Container(
                  alignment: Alignment.center,
                  width: 120,
                  height: 120,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileSettingsWidget extends StatefulWidget {
  _ProfileSettingsWidget({Key? key}) : super(key: key);
  bool isEditing = false;

  @override
  State<_ProfileSettingsWidget> createState() => __ProfileSettingsWidgetState();
}

class __ProfileSettingsWidgetState extends State<_ProfileSettingsWidget> {
  @override
  void initState() {
    _settingsProvider.username.then((value) {
      _usernameController.text = value;
    });
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  final _usernameController = TextEditingController();
  final _settingsProvider = SettingsProvider();
  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('Profile settings',
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
                      _settingsProvider.setUsername(_usernameController.text);

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
          controller: _usernameController,
          decoration: const InputDecoration(label: Text('Username')),
        ),
      ],
    );
  }
}

class _AppSettingsWidget extends StatefulWidget {
  _AppSettingsWidget({Key? key}) : super(key: key);

  @override
  State<_AppSettingsWidget> createState() => __AppSettingsState();
}

class __AppSettingsState extends State<_AppSettingsWidget> {
  @override
  void initState() {
    _settingsProvider.appThemeMode.then((value) {
      _appThemeMode = value;
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String _appThemeMode = '';
  final _settingsProvider = SettingsProvider();
  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Text('App settings',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
        DropdownButtonFormField(
            value: _appThemeMode == '' ? 'Light' : _appThemeMode,
            decoration:
                const InputDecoration(label: Text('Selected app theme')),
            items: const <DropdownMenuItem<String>>[
              DropdownMenuItem(child: Text('Light theme'), value: 'Light'),
              DropdownMenuItem(child: Text('Dark theme'), value: 'Dark'),
              DropdownMenuItem(child: Text('Auto colors theme'), value: 'Auto')
            ],
            onChanged: (value) {
              _settingsProvider.setAppThemeMode(value.toString());
            }),
      ],
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
