part of 'app_settings_bloc.dart';

@immutable
abstract class AppSettingsEvent {}

class AppGetAppSettings extends AppSettingsEvent {
  final String appThemeMode;

  AppGetAppSettings(this.appThemeMode);
}

class AppSettingsChangedEvent extends AppSettingsEvent {}
