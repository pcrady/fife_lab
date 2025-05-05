import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class General extends ConsumerStatefulWidget {
  const General({super.key});

  @override
  ConsumerState createState() => _GeneralState();
}

class _GeneralState extends ConsumerState<General> {
  @override
  Widget build(BuildContext context) {
    return Text('General');
  }
}
