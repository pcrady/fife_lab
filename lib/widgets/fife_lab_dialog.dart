import 'package:flutter/material.dart';

class FifeLabDialog extends StatefulWidget {
  final String title;
  final Widget content;
  final List<Widget> actions;

  const FifeLabDialog({
    required this.title,
    required this.content,
    required this.actions,
    super.key,
  });

  static void showDialogWrapper({
    required String title,
    required Widget content,
    required List<Widget> actions,
    required BuildContext context,
  }) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return FifeLabDialog(
          title: title,
          content: content,
          actions: actions,
        );
      },
    );
  }

  @override
  State<FifeLabDialog> createState() => _FifeLabDialogState();
}

class _FifeLabDialogState extends State<FifeLabDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      title: Text(widget.title),
      content: widget.content,
      actions: widget.actions,
    );
  }
}
