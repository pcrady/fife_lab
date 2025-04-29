import 'dart:async';
import 'package:fife_lab/lib/app_logger.dart';
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
    late SettingsModel settingsModel;

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final settingsString = prefs.getString(_settingsKey);

      if (settingsString == null) {
        settingsModel = SettingsModel();
        final newSettingsString = jsonEncode(settingsModel.toJson());
        prefs.setString(_settingsKey, newSettingsString);
      } else {
        final settingsModelMap = jsonDecode(settingsString);
        settingsModel = SettingsModel.fromJson(settingsModelMap);
      }
    } catch (err) {
      AppLogger.e(err);
      rethrow;
    }

    return settingsModel;
  }

  Future<void> _writeStateToDisk(SettingsModel newState) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final newSettingsString = jsonEncode(newState.toJson());
    prefs.setString(_settingsKey, newSettingsString);
  }

  Future<void> setColorTheme({
    required ColorTheme colorTheme,
  }) async {
    final previousState = await future;
    final newState = previousState.copyWith(theme: colorTheme);
    await _writeStateToDisk(newState);
    state = AsyncData(newState);
  }
}
