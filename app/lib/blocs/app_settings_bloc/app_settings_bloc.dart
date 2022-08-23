import 'package:shared_preferences/shared_preferences.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'app_settings_event.dart';
part 'app_settings_state.dart';

class AppSettingsBloc extends Bloc<AppSettingsEvent, AppSettingsState> {
  AppSettingsBloc() : super(AppSettingsInitial()) {
    on<AppSettingsChangedEvent>(onChangedAppSettings);
  }

  onChangedAppSettings(
      AppSettingsChangedEvent event, Emitter<AppSettingsState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final String? appThemeMode = prefs.getString('appThemeMode');

    final appSettings = AppSettings(appThemeMode: appThemeMode!);

    emit(AppSettingsChangedState(appSettings));
  }
}
