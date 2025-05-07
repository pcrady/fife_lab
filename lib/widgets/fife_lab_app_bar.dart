import 'package:fife_lab/screens/testing_screen.dart';
import 'package:fife_lab/widgets/dropdown_buttons/file_dropdown.dart';
import 'package:fife_lab/widgets/dropdown_buttons/functions_dropdow.dart';
import 'package:fife_lab/widgets/dropdown_buttons/fife_lab_dropdown.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FifeLabAppBar extends ConsumerStatefulWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  const FifeLabAppBar({super.key});

  @override
  ConsumerState createState() => _FifeLabAppBarState();
}

class _FifeLabAppBarState extends ConsumerState<FifeLabAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      leading: Icon(
        Icons.science_outlined,
        size: 32,
        color: Colors.lightGreenAccent,
      ),
      centerTitle: false,
      title: Row(
        children: [
          FifeLabDropdown(),
          FileDropdown(),
          FunctionsDropdown(),
          kDebugMode
              ? TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TestingScreen()),
                    );
                  },
                  child: Text('Testing'),
                )
              : Container(),
        ],
      ),
    );
  }
}
