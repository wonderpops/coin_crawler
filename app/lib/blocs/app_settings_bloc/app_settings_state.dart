part of 'app_settings_bloc.dart';

@immutable
abstract class AppSettingsState {}

class AppSettingsInitial extends AppSettingsState {}

class AppSettingsLoadededState extends AppSettingsState {
  final AppSettings appSettings;

  AppSettingsLoadededState(this.appSettings);
}

class AppSettingsChangedState extends AppSettingsState {
  final AppSettings appSettings;

  AppSettingsChangedState(this.appSettings);
}

class AppSettings {
  final String appThemeMode;

  AppSettings({required this.appThemeMode});
}
