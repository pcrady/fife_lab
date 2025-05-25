import 'package:dio/dio.dart';
import 'package:fife_lab/constants.dart';
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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kImageBorderRadius),
          border: widget.image.selected ? Border.all(color: Colors.green, width: 2) : null,
          image: DecorationImage(
            image: widget.image.imageThumbnail,
            fit: BoxFit.cover,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) {
            setState(() => mouseHover = true);
          },
          onExit: (_) {
            setState(() => mouseHover = false);
          },
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
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
                                if (selectedImages.contains(widget.image)) {
                                  await ref.read(imagesProvider.notifier).deleteImages(images: selectedImages);
                                } else {
                                  await ref.read(imagesProvider.notifier).deleteImages(images: [widget.image]);
                                }
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

class ImageListTile extends ConsumerWidget {
  final ImageModel image;

  const ImageListTile({
    required this.image,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        final pressed = HardwareKeyboard.instance.logicalKeysPressed;
        final isShiftDown = pressed.any((k) => k == LogicalKeyboardKey.shiftLeft || k == LogicalKeyboardKey.shiftRight);

        if (isShiftDown) {
          final selectedImages = await ref.read(selectedImagesProvider.future);

          if (selectedImages.isEmpty) {
            ref.read(imagesProvider.notifier).selectImages(images: [image]);
          } else {
            final allImages = await ref.read(imagesProvider.future);
            final first = selectedImages.first;
            final a = allImages.indexOf(first);
            final b = allImages.indexOf(image);
            final idx = [a, b]..sort();
            final range = allImages.sublist(idx[0], idx[1] + 1);
            ref.read(imagesProvider.notifier).selectImages(images: range);
          }
        } else {
          ref.read(imagesProvider.notifier).selectImages(images: [image]);
        }
      },
      child: Container(
        color: Colors.transparent,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kImageBorderRadius),
            side: image.selected ? BorderSide(color: Colors.green, width: 2.0) : BorderSide.none,
          ),
          color: Color(0xFF1e112b),
          child: ListTile(
            key: Key(image.imageName),
            mouseCursor: SystemMouseCursors.click,
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(kImageBorderRadius),
              child: Image(
                image: image.imageThumbnail,
                width: 32, // ← take up all the parent’s width
                fit: BoxFit.cover, // or BoxFit.fitWidth if you only care about width
              ),
            ),
            title: Text(
              image.imageName,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.white),
            ),
            dense: true,
          ),
        ),
      ),
    );
  }
}
