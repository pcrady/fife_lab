import 'package:fife_lab/providers/images.dart';
import 'package:fife_lab/widgets/image_thumbnail_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConvexHull extends ConsumerStatefulWidget {
  const ConvexHull({super.key});

  @override
  ConsumerState createState() => _ConvexHullState();
}

class _ConvexHullState extends ConsumerState<ConvexHull> {
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
    final asyncData = ref.watch(imagesProvider);
    return asyncData.when(
      data: (images) {
        return RawScrollbar(
          thumbColor: Colors.white30,
          controller: scrollController,
          radius: const Radius.circular(20),
          child: GridView.builder(
            controller: scrollController,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
            ),
            itemCount: images.length,
            itemBuilder: (BuildContext context, int index) {
              return ImageThumbnailCard(
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
