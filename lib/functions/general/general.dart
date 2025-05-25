import 'package:fife_lab/functions/general/selected_images.dart';
import 'package:fife_lab/providers/images.dart';
import 'package:fife_lab/widgets/dynamic_image_list.dart';
import 'package:fife_lab/widgets/image_thumbnail_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class General extends ConsumerStatefulWidget {
  const General({super.key});

  @override
  ConsumerState createState() => _GeneralState();
}

class _GeneralState extends ConsumerState<General> {
  static const _maxSlidePosition = 200.0;
  double relativeDividerPosition = _maxSlidePosition;


  @override
  Widget build(BuildContext context) {
    final imageData = ref.watch(imagesProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: relativeDividerPosition,
              child: DynamicImageList(width: relativeDividerPosition),
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onPanUpdate: (DragUpdateDetails details) {
                var relativePosition = relativeDividerPosition;
                relativePosition += details.delta.dx;
                if (relativePosition > constraints.maxWidth - _maxSlidePosition) {
                  relativePosition = constraints.maxWidth - _maxSlidePosition;
                } else if (relativePosition < _maxSlidePosition) {
                  relativePosition = _maxSlidePosition;
                }
                setState(() {
                  relativeDividerPosition = relativePosition;
                });
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: VerticalDivider(),
                ),
              ),
            ),
            SizedBox(
              width: constraints.maxWidth - relativeDividerPosition - 20,
              child: SelectedImagesWidget(),
            ),
          ],
        );
      },
    );
  }
}
