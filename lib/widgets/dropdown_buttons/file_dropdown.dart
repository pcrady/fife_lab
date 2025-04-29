import 'package:fife_lab/widgets/dropdown_buttons/app_bar_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum _Selection {
  newProject('New Project'),
  openProject('Open Project'),
  addImages('Add Images'),
  exportProject('Export Project');

  const _Selection(this.value);

  final String value;

  @override
  String toString() => value;
}

class FileDropdown extends ConsumerStatefulWidget {
  const FileDropdown({super.key});

  @override
  ConsumerState createState() => _FileDropdownState();
}

class _FileDropdownState extends ConsumerState<FileDropdown> {
  void onSelected(_Selection selection) {
    switch (selection) {
      case _Selection.newProject:
        // TODO: Handle this case.
        throw UnimplementedError();
      case _Selection.openProject:
        // TODO: Handle this case.
        throw UnimplementedError();
      case _Selection.addImages:
        // TODO: Handle this case.
        throw UnimplementedError();
      case _Selection.exportProject:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBarDropdown(
      onSelected: onSelected,
      values: _Selection.values,
      title: 'File',
    );
  }
}
