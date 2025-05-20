import 'package:dio/dio.dart';
import 'package:fife_lab/lib/app_logger.dart';
import 'package:fife_lab/models/image_model.dart';
import 'package:fife_lab/providers/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImageThumbnailCard extends ConsumerStatefulWidget {
  final ImageModel image;

  const ImageThumbnailCard({
    required this.image,
    super.key,
  });

  @override
  ConsumerState<ImageThumbnailCard> createState() => _ImageThumbnailCardState();
}

class _ImageThumbnailCardState extends ConsumerState<ImageThumbnailCard> {
  bool mouseHover = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        clipBehavior: Clip.antiAlias,
        foregroundDecoration: BoxDecoration(
          border: widget.image.selected ? Border.all(color: Colors.green, width: 2) : null,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) {
            setState(() => mouseHover = true);
          },
          onExit: (_) {
            setState(() => mouseHover = false);
          },
          child: GestureDetector(
            onTap: () async {
              final pressed = HardwareKeyboard.instance.logicalKeysPressed;
              final isShiftDown = pressed.any((k) => k == LogicalKeyboardKey.shiftLeft || k == LogicalKeyboardKey.shiftRight);

              if (isShiftDown) {
                final selectedImages = await ref.read(selectedImagesProvider.future);

                if (selectedImages.isEmpty) {
                  ref.read(imagesProvider.notifier).selectImages(images: [widget.image]);
                } else {
                  final allImages = await ref.read(imagesProvider.future);
                  final first = selectedImages.first;
                  final a = allImages.indexOf(first);
                  final b = allImages.indexOf(widget.image);
                  final idx = [a, b]..sort();
                  final range = allImages.sublist(idx[0], idx[1] + 1);
                  ref.read(imagesProvider.notifier).selectImages(images: range);
                }
              } else {
                ref.read(imagesProvider.notifier).selectImages(images: [widget.image]);
              }
            },
            child: Stack(
              clipBehavior: Clip.antiAlias,
              children: [
                Image(
                  key: UniqueKey(),
                  image: widget.image.imageThumbnail,
                ),
                mouseHover
                    ? Positioned(
                        right: 4.0,
                        top: 4.0,
                        child: GestureDetector(
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 18.0,
                          ),
                          onTap: () async {
                            try {
                              final selectedImages = await ref.read(selectedImagesProvider.future);
                              if (selectedImages.isNotEmpty) {
                                await ref.read(imagesProvider.notifier).deleteImages(images: selectedImages);
                              } else {
                                await ref.read(imagesProvider.notifier).deleteImages(images: [widget.image]);
                              }
                            } catch (err, stack) {
                              AppLogger.e(err, stackTrace: stack);
                            }
                          },
                        ),
                      )
                    : Container(),
                Positioned(
                  left: 8.0,
                  bottom: 8.0,
                  child: Text(
                    widget.image.imageName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
