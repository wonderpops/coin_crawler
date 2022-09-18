// ignore_for_file: must_be_immutable

import 'package:coin_crawler_app/main_layout_widget.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/app_settings_bloc/app_settings_bloc.dart';
import 'blocs/home_screen_data_loader_bloc/home_screen_data_loader_bloc.dart';

void main() {
  final AppSettingsBloc settingsBloc = AppSettingsBloc();
  settingsBloc.add(AppSettingsLoadedEvent());
  runApp(MainWidget(
    settingsBloc: settingsBloc,
  ));
}

class MainWidget extends StatefulWidget {
  const MainWidget({
    Key? key,
    required this.settingsBloc,
  }) : super(key: key);
  final AppSettingsBloc settingsBloc;

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
        builder: ((ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
      return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => widget.settingsBloc),
          ],
          child: BlocBuilder<AppSettingsBloc, AppSettingsState>(
            bloc: widget.settingsBloc,
            builder: (context, state) {
              // print('State: ${widget.settingsBloc.state}');
              if (state is AppSettingsChangedState) {
                // print('ThemeMode: ${state.appSettings.appThemeMode}');
                final HomeScreenDataLoaderBloc binanceAPIBloc =
                    HomeScreenDataLoaderBloc();
                return BlocProvider(
                  create: (context) => binanceAPIBloc,
                  child: MaterialApp(
                    title: 'Coin Crawler',
                    theme: ThemeData(
                      colorScheme: lightDynamic,
                      brightness: Brightness.light,
                      useMaterial3: true,
                    ),
                    darkTheme: ThemeData(
                      colorScheme: darkDynamic,
                      brightness: Brightness.dark,
                      scaffoldBackgroundColor:
                          const Color.fromRGBO(14, 14, 14, 1),
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
                  ),
                );
              } else if (state is AppSettingsLoadededState) {
                // print('ThemeMode: ${state.appSettings.appThemeMode}');
                final HomeScreenDataLoaderBloc binanceAPIBloc =
                    HomeScreenDataLoaderBloc();
                return BlocProvider(
                  create: (context) => binanceAPIBloc,
                  child: MaterialApp(
                    title: 'Coin Crawler',
                    theme: ThemeData(
                      colorScheme: lightDynamic,
                      brightness: Brightness.light,
                      useMaterial3: true,
                    ),
                    darkTheme: ThemeData(
                      colorScheme: darkDynamic,
                      brightness: Brightness.dark,
                      scaffoldBackgroundColor:
                          const Color.fromRGBO(14, 14, 14, 1),
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
                  ),
                );
              } else {
                return MaterialApp(
                    title: 'Coin Crawler',
                    theme: ThemeData(
                      colorSchemeSeed: const Color.fromARGB(255, 101, 81, 214),
                      brightness: Brightness.light,
                      useMaterial3: true,
                    ),
                    darkTheme: ThemeData(
                      colorSchemeSeed: const Color.fromARGB(255, 101, 81, 214),
                      brightness: Brightness.dark,
                      scaffoldBackgroundColor:
                          const Color.fromRGBO(14, 14, 14, 1),
                      useMaterial3: true,
                    ),
                    themeMode: ThemeMode.light,
                    debugShowCheckedModeBanner: false,
                    home: const Center(child: CircularProgressIndicator()));
              }
            },
          ));
    }));
  }
}
