import 'package:dio/dio.dart';
import 'package:fife_lab/constants.dart';
import 'package:fife_lab/lib/app_logger.dart';
import 'package:fife_lab/providers/settings.dart';
import 'package:file_picker/file_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:convert';
part 'images.g.dart';

@riverpod
class Images extends _$Images {
  @override
  Future<List<String>> build() async {
    return [];
  }

  Future<void> addImages() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      withData: false,
      type: FileType.custom,
      allowedExtensions: ['tif', 'png'],
    );
    if (result == null) return;

    final filePaths = result.files.map((file) => file.path).whereType<String>().toList();
    final dio = Dio(BaseOptions(baseUrl: kServer));

    final response = await dio.post(
      '/uploadimages',
      data: jsonEncode(filePaths),
    );
    AppLogger.f(response);
  }
}
