import 'dart:io';

import 'package:fife_lab/lib/app_logger.dart';
import 'package:fife_lab/models/settings_model.dart';
import 'package:fife_lab/providers/settings.dart';
import 'package:fife_lab/widgets/dropdown_buttons/app_bar_dropdown.dart';
import 'package:fife_lab/widgets/fife_lab_dialog.dart';
import 'package:file_picker/file_picker.dart';
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
        {
          FifeLabDialog.showDialogWrapper(
            title: 'New Project',
            content: _NewProject(),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
            context: context,
          );
        }
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

class _NewProject extends ConsumerStatefulWidget {
  const _NewProject({super.key});

  @override
  ConsumerState<_NewProject> createState() => _NewProjectState();
}

class _NewProjectState extends ConsumerState<_NewProject> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _projectDirController;
  bool _projectsDirExists = false;

  @override
  void initState() {
    _projectDirController = TextEditingController();

    _projectDirController.addListener(() async {
      final exists = await Directory(_projectDirController.text).exists();
      setState(() => _projectsDirExists = exists);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final settings = await ref.read(settingsProvider.future);
      _projectDirController.text = settings.projectsDirPath ?? 'None';
    });
    super.initState();
  }

  @override
  void dispose() {
    _projectDirController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1200,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text('Projects Directory: '),
                Expanded(
                  child: TextFormField(
                    controller: _projectDirController,
                    decoration: InputDecoration(
                      hintText: 'Enter a message',
                      suffixIcon: IconButton(
                        onPressed: () async {
                          try {
                            // TODO this requires further config
                            String? projectsDirPath = await FilePicker.platform.getDirectoryPath(
                              dialogTitle: 'Select Your Projects Directory',
                            );
                            if (projectsDirPath != null) {
                              await ref.read(settingsProvider.notifier).setProjectsDir(projectsDirPath: projectsDirPath);
                            }
                          } catch (err, stack) {
                            AppLogger.e(err, stackTrace: stack);
                          }
                        },
                        icon: Icon(Icons.keyboard_arrow_down),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Row(
              children: [Text(_projectsDirExists ? 'Exists' : 'Does not Exist')],
            ),
          ],
        ),
      ),
    );
  }
}
