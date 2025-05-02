import 'dart:async';
import 'dart:io';
import 'package:fife_lab/lib/app_logger.dart';
import 'package:fife_lab/lib/initializer.dart';
import 'package:fife_lab/models/settings_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:path/path.dart' as path;

part 'settings.g.dart';

@riverpod
class Settings extends _$Settings {
  static const _settingsKey = 'fifeLabSettings';

  @override
  Future<SettingsModel> build() async {
    late SettingsModel settingsModel;
    AppLogger.f('THIS SHOULD NOT HAPPEN');

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final settingsString = prefs.getString(_settingsKey);

      if (settingsString == null) {
        await Initializer.initialised.future;
        settingsModel = SettingsModel(projectsPath: Initializer.projectsDir?.path);
        await _writeStateToDisk(settingsModel);
      } else {
        final settingsModelMap = jsonDecode(settingsString);
        settingsModel = SettingsModel.fromJson(settingsModelMap);
      }
    } catch (err) {
      AppLogger.e(err);
      rethrow;
    }

    if (!await settingsModel.projectDirExists) {
      settingsModel = settingsModel.copyWith(projectName: null);
      await _writeStateToDisk(settingsModel);
    }

    if (!await settingsModel.projectsDirExists) {
      settingsModel = settingsModel.copyWith(projectsPath: null);
      await _writeStateToDisk(settingsModel);
    }

    return settingsModel;
  }

  Future<void> _writeStateToDisk(SettingsModel newState) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final newSettingsString = jsonEncode(newState.toJson());
    await prefs.setString(_settingsKey, newSettingsString);
  }

  Future<void> setColorTheme({
    required ColorTheme colorTheme,
  }) async {
    final previousState = await future;
    final newState = previousState.copyWith(theme: colorTheme);
    await _writeStateToDisk(newState);
    state = AsyncData(newState);
  }

  Future<void> setProject({
    String? projectsPath,
    String? projectName,
  }) async {
    assert(
      !(projectsPath == null && projectName != null),
      'Cannot set a project name without a directory.',
    );

    if (projectsPath != null) {
      final projectsDir = Directory(projectsPath);
      if (!await projectsDir.exists()) {
        throw Exception('Project directory does not exist: ${projectsDir.path}');
      }

      if (projectName != null) {
        await Directory(path.join(projectsDir.path, projectName)).create(recursive: true);
      }
    }

    final prev = await future;
    final updated = prev.copyWith(
      projectsPath: projectsPath,
      projectName: projectName,
    );

    await _writeStateToDisk(updated);
    state = AsyncData(updated);
  }
}
