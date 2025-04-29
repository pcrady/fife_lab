import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppBarDropdown<T extends Enum> extends ConsumerStatefulWidget {
  final Function(T) onSelected;
  final List<T> values;
  final String title;
  final bool primary;

  const AppBarDropdown({
    required this.onSelected,
    required this.title,
    required this.values,
    this.primary = false,
    super.key,
  });

  @override
  ConsumerState<AppBarDropdown<T>> createState() => _AppBarDropdownState<T>();
}

class _AppBarDropdownState<T extends Enum> extends ConsumerState<AppBarDropdown<T>> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      offset: Offset(3, widget.primary ? 46 : 42),
      popUpAnimationStyle: AnimationStyle(duration: Duration(milliseconds: 0)),
      menuPadding: EdgeInsets.all(6.0),
      color: Colors.white10,
      onSelected: widget.onSelected,
      itemBuilder: (_) => widget.values.map<PopupMenuEntry<T>>((T val) {
        return PopupMenuItem<T>(
          value: val,
          height: 26.0,
          padding: EdgeInsets.zero,
          child: SizedBox(
            width: double.infinity,
            child: InkWell(
              hoverColor: Colors.blue,
              onTap: () => Navigator.of(context).pop<T>(val),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 8.0,
                  right: 10.0,
                ),
                child: Text(
                  val.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        );
      }).toList(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          widget.title,
          style: TextStyle(
            fontSize: widget.primary ? 28.0 : 22.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
