import 'package:dio/dio.dart';
import 'package:fife_lab/constants.dart';
import 'package:fife_lab/models/image_model.dart';
import 'package:fife_lab/providers/loading.dart';
import 'package:file_picker/file_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:convert';
import 'package:collection/collection.dart';
part 'images.g.dart';

@riverpod
class Images extends _$Images {
  @override
  Future<List<ImageModel>> build() async {
    return [];
  }

  Future<void> addImages() async {
    try {
      ref.read(loadingProvider.notifier).setLoadingTrue();
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        withData: false,
        type: FileType.custom,
        allowedExtensions: ['tif', 'png'],
      );
      if (result == null) return;

      final filePaths = result.files.map((file) => file.path).whereType<String>().toList();
      final dio = Dio(BaseOptions(baseUrl: kServer));
      final filePathChunks = filePaths.slices(50);
      List<Future> futures = [];

      for (final chunk in filePathChunks) {
        futures.add(
          dio.post(
            '/upload-images',
            data: jsonEncode(chunk),
          ),
        );
      }
      await Future.wait(futures);
    } catch (_, __) {
      rethrow;
    } finally {
      ref.read(loadingProvider.notifier).setLoadingFalse();
    }
  }
}
