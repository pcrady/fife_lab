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

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final settingsString = prefs.getString(_settingsKey);

      if (settingsString == null) {
        await Initializer.initialised.future;
        settingsModel = SettingsModel(
          projectsDirPath: Initializer.projectsDir?.path,
        );
        await _writeStateToDisk(settingsModel);
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

  Future<void> setProjectsDir({
    required Directory projectsDir,
  }) async {
    if (!await projectsDir.exists()) {
      throw 'Project Directory: ${projectsDir.path} does not exist.';
    }
    final previousState = await future;
    final newState = previousState.copyWith(projectsDirPath: projectsDir.path);
    await _writeStateToDisk(newState);
    state = AsyncData(newState);
  }

  Future<void> setProjectName({
    required String projectName,
  }) async {
    final previousState = await future;
    final newState = previousState.copyWith(projectName: projectName);
    await _writeStateToDisk(newState);
    state = AsyncData(newState);

    final projectsDirPath = newState.projectsDirPath;

    if (projectsDirPath != null) {
      final exists = await Directory(projectsDirPath).exists();
      if (!exists) {
        throw 'Project Directory: $projectsDirPath does not exist.';
      }

      final projectDir = Directory(path.join(projectsDirPath, newState.projectName));
      projectDir.create(recursive: true);
    }
  }

  Future<void> setProjectDir({
    required Directory projectDir,
  }) async {
    final projectName = path.basename(projectDir.path);
    final projectsDirPath = projectDir.parent.path;

    final previousState = await future;
    final newState = previousState.copyWith(
      projectsDirPath: projectsDirPath,
      projectName: projectName,
    );
    await _writeStateToDisk(newState);
    state = AsyncData(newState);
  }
}
