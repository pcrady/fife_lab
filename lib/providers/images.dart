import 'package:dio/dio.dart';
import 'package:fife_lab/constants.dart';
import 'package:fife_lab/lib/app_logger.dart';
import 'package:fife_lab/models/responses.dart';
import 'package:fife_lab/models/image_model.dart';
import 'package:fife_lab/providers/loading.dart';
import 'package:fife_lab/providers/settings.dart';
import 'package:file_picker/file_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:convert';
import 'package:collection/collection.dart';
part 'images.g.dart';

@riverpod
class Images extends _$Images {
  @override
  Future<List<ImageModel>> build() async {
    ref.watch(settingsProvider);
    final dio = Dio(BaseOptions(baseUrl: kServer));
    final response = await dio.get('/get-all-images');
    List<dynamic> data = response.data;
    final images = data.map((e) => ImageModel.fromJson(e)).toList()..sort((a, b) => a.imageName.compareTo(b.imageName));
    return images;
  }

  Future<Response> uploadWrapper(List<String> chunk) async {
    final dio = Dio(BaseOptions(baseUrl: kServer));
    final response = await dio.post(
      '/add-images',
      data: jsonEncode(chunk),
    );
    ref.read(loadingProvider.notifier).incrementLoadingValue();
    return response;
  }

  Future<void> addImages() async {
    final loading = ref.read(loadingProvider.notifier);
    try {
      loading.setLoadingTrue('Converting Images...');
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        withData: false,
        type: FileType.custom,
        allowedExtensions: ['tif', 'png'],
      );
      if (result == null) return;

      final filePaths = result.files.map((file) => file.path).whereType<String>().toList();
      final filePathChunks = filePaths.slices(100);

      loading.setLoadingTotal(loadingTotal: filePathChunks.length.toDouble());
      List<Future> futures = [];

      for (final chunk in filePathChunks) {
        futures.add(uploadWrapper(chunk));
      }

      List<String> failedImages = [];
      final responses = await Future.wait(futures);

      for (final response in responses) {
        final addImagesResponse = AddImagesResponse.fromJson(response.data);
        failedImages.addAll(addImagesResponse.failedImages);
      }

      if (failedImages.isNotEmpty) {
        throw 'Failed to add: $failedImages';
      }

      final corruptedImages = await checkForCorruptedImages();
      if (corruptedImages.isNotEmpty) {
        throw 'Corrupted Images: $corruptedImages';
      }
    } catch (_, __) {
      rethrow;
    } finally {
      loading.setLoadingFalse();
      ref.invalidateSelf();
    }
  }

  Future<List<String>> checkForCorruptedImages() async {
    try {
      ref.read(loadingProvider.notifier).setLoadingTrue('Verifying Image Integrity...');
      final dio = Dio(BaseOptions(baseUrl: kServer));
      final response = await dio.get('/verify-images');
      return List<String>.from(response.data);
    } catch (err, stack) {
      AppLogger.e(err, stackTrace: stack);
      rethrow;
    } finally {
      ref.read(loadingProvider.notifier).setLoadingFalse();
    }
  }

  Future<void> deleteImages({
    required List<ImageModel> images,
  }) async {
    try {
      final dio = Dio(BaseOptions(baseUrl: kServer));
      final imageData = images.map((e) => e.toJson()).toList();
      await dio.post('/remove-images', data: imageData);
    } catch (err, stack) {
      AppLogger.e(err, stackTrace: stack);
      rethrow;
    } finally {
      ref.invalidateSelf();
    }
  }
}
