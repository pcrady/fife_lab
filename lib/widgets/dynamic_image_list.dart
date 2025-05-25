import 'package:fife_lab/providers/images.dart';
import 'package:fife_lab/widgets/image_thumbnail_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DynamicImageList extends ConsumerStatefulWidget {
  final double width;
  const DynamicImageList({
    required this.width,
    super.key,
  });

  @override
  ConsumerState createState() => _DynamicImageListState();
}

class _DynamicImageListState extends ConsumerState<DynamicImageList> {
  late ScrollController scrollController;
  static const _breakWidth = 350.0;

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
    final imageData = ref.watch(imagesProvider);

    return imageData.when(
      data: (images) {
        return RawScrollbar(
          thumbColor: Colors.white30,
          controller: scrollController,
          radius: const Radius.circular(20),
          child: widget.width > _breakWidth
              ? GridView.builder(
                  controller: scrollController,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 6),
                  padding: EdgeInsets.only(top: 8.0, left: 8.0, bottom: 8.0),
                  itemCount: images.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ImageThumbnailCard(
                      key: Key(images[index].imageName),
                      image: images[index],
                    );
                  },
                )
              : ListView.builder(
                  controller: scrollController,
                  padding: EdgeInsets.only(top: 8.0, left: 8.0, bottom: 8.0),
                  itemCount: images.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ImageListTile(
                      key: Key(images[index].imageName),
                      image: images[index],
                    );
                  },
                ),
        );
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
