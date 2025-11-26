import 'package:flutter/material.dart';

class CommonDropdown<T> extends StatelessWidget {
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final String hintText;
  final Function(T?) onChanged;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final bool isExpanded;

  const CommonDropdown({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
    this.hintText = "Select an option",
    this.width,
    this.height,
    this.padding,
    this.isExpanded = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
                width: 0.8, color: Colors.transparent),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.shade200,
                  spreadRadius: 3,
                  offset: const Offset(0, 1),
                  blurRadius: 3)
            ]),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          hint: Text(hintText, style:TextStyle(
              fontSize: 14, color: Colors.grey.shade600)),
          style: TextStyle(fontSize: 16,color: Colors.black,),
          isExpanded: isExpanded,
          alignment: AlignmentDirectional.centerStart,
          iconEnabledColor: Colors.grey.shade500,

          icon: const Icon(Icons.keyboard_arrow_down),
          iconSize: 28,
          elevation: 1,// for drop down sheet
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
