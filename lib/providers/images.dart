import 'package:dio/dio.dart';
import 'package:fife_lab/constants.dart';
import 'package:fife_lab/providers/settings.dart';
import 'package:file_picker/file_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'images.g.dart';

@riverpod
class Images extends _$Images {
  @override
  Future<List<String>> build() async {
    final dio = Dio();
    final project = await ref.watch(settingsProvider.selectAsync((settings) => settings.projectPath));
    final response = await dio.get(kServer);
    final data = List<Map<String, dynamic>>.from(response.data);
    return [];
  }

}
