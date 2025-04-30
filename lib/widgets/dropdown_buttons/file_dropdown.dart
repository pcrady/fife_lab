import 'dart:io';
import 'package:fife_lab/lib/app_logger.dart';
import 'package:fife_lab/providers/settings.dart';
import 'package:fife_lab/widgets/dropdown_buttons/app_bar_dropdown.dart';
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
        showDialog(
          context: context,
          builder: (_) => const _NewProjectDialog(),
        );
        break;
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

class _NewProjectDialog extends ConsumerStatefulWidget {
  const _NewProjectDialog({super.key});

  @override
  ConsumerState<_NewProjectDialog> createState() => _NewProjectDialogState();
}

class _NewProjectDialogState extends ConsumerState<_NewProjectDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _projectDirController;
  late final TextEditingController _projectNameController;
  bool _projectsDirExists = false;

  @override
  void initState() {
    _projectDirController = TextEditingController();
    _projectNameController = TextEditingController();
    _projectNameController.addListener(() => setState(() {}));

    _projectDirController.addListener(() async {
      try {
        final exists = await Directory(_projectDirController.text).exists();
        setState(() => _projectsDirExists = exists);
      } catch (err, stack) {
        AppLogger.e(err, stackTrace: stack);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final settings = await ref.read(settingsProvider.future);
        _projectDirController.text = settings.projectsDirPath ?? 'None';
      } catch (err, stack) {
        AppLogger.e(err, stackTrace: stack);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _projectDirController.dispose();
    _projectNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('New Project'),
      content: SizedBox(
        width: 600,
        height: 160,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _projectDirController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (_) {
                  return _projectsDirExists ? null : 'Projects Directory does not Exist';
                },
                decoration: InputDecoration(
                  hintText: 'Enter a directory to store your projects',
                  label: Text('Projects Directory'),
                  suffixIcon: IconButton(
                    onPressed: () async {
                      try {
                        final settingsModel = await ref.read(settingsProvider.future);
                        String? projectsDirPath = await FilePicker.platform.getDirectoryPath(
                          dialogTitle: 'Select Your Projects Directory',
                          initialDirectory: settingsModel.projectsDirPath,
                        );
                        if (projectsDirPath != null) {
                          final settings = ref.read(settingsProvider.notifier);
                          await settings.setProjectsDir(projectsDirPath: projectsDirPath);
                          _projectDirController.text = projectsDirPath;
                        }
                      } catch (err, stack) {
                        AppLogger.e(err, stackTrace: stack);
                      }
                    },
                    icon: Icon(Icons.keyboard_arrow_down),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _projectNameController,
                decoration: InputDecoration(
                  hintText: 'Enter a name for your project',
                  label: Text('Project Name'),
                ),
              ),
              SizedBox(height: 16),
              Text('Project Path: ${_projectDirController.text}/${_projectNameController.text}'),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
        TextButton(
          onPressed: () async {
            try {
              final settings = ref.read(settingsProvider.notifier);
              await settings.setProjectsDir(projectsDirPath: _projectDirController.text);
              await settings.setProject(projectName: _projectNameController.text);
            } catch (err, stack) {
              AppLogger.e(err, stackTrace: stack);
            }
            Navigator.of(context).pop();
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}
