import 'package:fife_lab/constants.dart';
import 'package:fife_lab/models/image_model.dart';
import 'package:fife_lab/providers/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedImagesWidget extends ConsumerStatefulWidget {
  const SelectedImagesWidget({super.key});

  @override
  ConsumerState createState() => _SelectedImagesWidgetState();
}

class _SelectedImagesWidgetState extends ConsumerState<SelectedImagesWidget> {
  late ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedImageData = ref.watch(selectedImagesProvider);

    return selectedImageData.when(
      data: (selectedImages) {
        if (selectedImages.isEmpty) {
          return Container();
        } else {
          return RawScrollbar(
            thumbColor: Colors.white30,
            controller: scrollController,
            radius: const Radius.circular(20),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 8.0,
                      top: 8.0,
                      bottom: 8.0,
                    ),
                    child: _SelectedImage(image: selectedImages[0]),
                  ),
                  Text(selectedImages[0].imageName),
                ],
              ),
            ),
          );
        }
      },
      error: (err, stack) {
        return Container();
      },
      loading: () {
        return Container();
      },
    );
  }
}

class _SelectedImage extends StatelessWidget {
  final ImageModel image;

  const _SelectedImage({
    required this.image,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(kImageBorderRadius),
      child: Image(
        image: image.image,
        width: double.infinity, // ← take up all the parent’s width
        fit: BoxFit.cover, // or BoxFit.fitWidth if you only care about width
      ),
    );
  }
}
