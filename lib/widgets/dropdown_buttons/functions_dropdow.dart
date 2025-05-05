import 'package:fife_lab/functions/fife_lab_function.dart';
import 'package:fife_lab/providers/settings.dart';
import 'package:fife_lab/widgets/dropdown_buttons/app_bar_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum _Function {
  general('General'),
  convexHull('Convex Hull');

  const _Function(this.function);

  final String function;

  @override
  String toString() => function;
}

class FunctionsDropdown extends ConsumerStatefulWidget {
  const FunctionsDropdown({super.key});

  @override
  ConsumerState createState() => _FunctionsDropdownState();
}

class _FunctionsDropdownState extends ConsumerState<FunctionsDropdown> {
  void onSelected(_Function function) async {
    final settings = ref.read(settingsProvider.notifier);
    switch (function) {
      case _Function.general:
        await settings.setFunction(function: FifeLabFunction.general);
        break;
      case _Function.convexHull:
        await settings.setFunction(function: FifeLabFunction.convexHull);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBarDropdown(
      onSelected: onSelected,
      values: _Function.values,
      title: 'Functions',
    );
  }
}
