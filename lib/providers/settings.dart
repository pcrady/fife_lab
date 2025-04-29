import 'dart:async';
import 'package:fife_lab/models/settings_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

part 'settings.g.dart';

@riverpod
class Settings extends _$Settings {
  static const _settingsKey = 'settings';

  @override
  Future<SettingsModel> build() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    late SettingsModel settingsModel;
    final settingsString = prefs.getString(_settingsKey);

    if (settingsString == null) {
      settingsModel = SettingsModel();
      final newSettingsString = jsonEncode(settingsModel.toJson());
      prefs.setString(_settingsKey, newSettingsString);
    } else {
      final settingsModelMap = jsonDecode(settingsString);
      settingsModel = SettingsModel.fromJson(settingsModelMap);
    }

    return settingsModel;
  }

  Future<void> setColorTheme({
    required ColorTheme colorTheme,
  }) async {
    final previousState = await future;
    state = AsyncData(previousState.copyWith(theme: colorTheme));
  }
}
