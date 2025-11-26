import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CupertinoCustomPicker extends StatelessWidget {
  final List valuesList;
  final String selected;
  final Function(dynamic)? onItemClicked;
  final ValueChanged<int>? onSelectedItemChanged;

  const CupertinoCustomPicker({
    super.key,
    required this.valuesList,
     this.onItemClicked,
    required this.selected,
    required this.onSelectedItemChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoPicker(
      itemExtent: 40,
      scrollController: FixedExtentScrollController(
        initialItem: valuesList.indexOf(selected),
      ),
      onSelectedItemChanged: (index) {
        // Play system click sound when item changes
        SystemSound.play(SystemSoundType.click);

        // Call the provided callback if it's not null
        if (onSelectedItemChanged != null) {
          onSelectedItemChanged!(index);
        }
      },
      children: valuesList
          .map((item) => InkWell(onTap: (){
            onItemClicked?.call(item);
      },
            child: Center(
                  child: Text(
                    item,
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
          ))
          .toList(),
    );
  }
}
