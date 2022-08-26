// ignore_for_file: must_be_immutable

import 'package:coin_crawler_app/blocs/binance_api_bloc/binance_api_bloc.dart';
import 'package:coin_crawler_app/main_layout_widget.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/app_settings_bloc/app_settings_bloc.dart';
import 'widgets/settings_screen/settings_provider.dart';

void main() {
  runApp(MainWidget());
}

class MainWidget extends StatefulWidget {
  MainWidget({Key? key}) : super(key: key);
  String themeMode = 'Light';

  static final _defaultLightColorScheme =
      ColorScheme.fromSwatch(primarySwatch: Colors.blue);

  static final _defaultDarkColorScheme = ColorScheme.fromSwatch(
      primarySwatch: Colors.blue, brightness: Brightness.dark);

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  @override
  void initState() {
    final settingsProvider = SettingsProvider();
    settingsProvider.appThemeMode.then((value) {
      widget.themeMode = value;
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingsBloc = AppSettingsBloc();
    final binanceAPIBloc = BinanceAPIBloc();
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => settingsBloc),
          BlocProvider(create: (context) => binanceAPIBloc),
        ],
        child: BlocBuilder<AppSettingsBloc, AppSettingsState>(
          bloc: settingsBloc,
          builder: (context, state) {
            if (state is AppSettingsChangedState) {
              return MaterialApp(
                title: 'Coin Crawler',
                theme: ThemeData(
                  colorSchemeSeed: Color.fromARGB(255, 101, 81, 214),
                  brightness: Brightness.light,
                  useMaterial3: true,
                ),
                darkTheme: ThemeData(
                  colorSchemeSeed: Color.fromARGB(255, 101, 81, 214),
                  brightness: Brightness.dark,
                  scaffoldBackgroundColor: Color.fromRGBO(14, 14, 14, 1),
                  useMaterial3: true,
                ),
                themeMode: state.appSettings.appThemeMode == 'Light'
                    ? ThemeMode.light
                    : state.appSettings.appThemeMode == 'Dark'
                        ? ThemeMode.dark
                        : ThemeMode.system,
                debugShowCheckedModeBanner: false,
                home: const MainLayoutWidget(
                  restorationId: '0',
                ),
              );
            } else {
              return MaterialApp(
                title: 'Coin Crawler',
                theme: ThemeData(
                  colorSchemeSeed: Color.fromARGB(255, 101, 81, 214),
                  brightness: Brightness.light,
                  useMaterial3: true,
                ),
                darkTheme: ThemeData(
                  colorSchemeSeed: Color.fromARGB(255, 101, 81, 214),
                  brightness: Brightness.dark,
                  scaffoldBackgroundColor: Color.fromRGBO(14, 14, 14, 1),
                  useMaterial3: true,
                ),
                themeMode: widget.themeMode == 'Light'
                    ? ThemeMode.light
                    : widget.themeMode == 'Dark'
                        ? ThemeMode.dark
                        : ThemeMode.system,
                debugShowCheckedModeBanner: false,
                home: const MainLayoutWidget(
                  restorationId: '0',
                ),
              );
            }
          },
        ));
  }
}
