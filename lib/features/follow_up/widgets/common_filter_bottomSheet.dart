import 'package:flutter/material.dart';
import 'package:asetize/core/core.dart';

import '../../../imports.dart';

class CommonFilterBottomSheet extends StatefulWidget {
  final String title; // Dynamic title (e.g., "Choose Duration")
  final List<String> options; // Dynamic options from calling screen
  final String selectedOption;
  final Function(String) onApply;
  final IconData icon; // <-- Dynamic Icon

  const CommonFilterBottomSheet({
    super.key,
    required this.title,
    required this.options,
    required this.selectedOption,
    required this.onApply,
    required this.icon, // <-- Pass icon from outside
  });

  @override
  State<CommonFilterBottomSheet> createState() =>
      _CommonFilterBottomSheetState();
}

class _CommonFilterBottomSheetState extends State<CommonFilterBottomSheet> {
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.selectedOption;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            height: 55,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(15)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [

                    Icon(       Icons.filter_list, // <-- Dynamic icon
                        size: 30,                   color: Colors.black,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 3),
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                      'assets/images/cross_icon.svg',
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 5),

          // Scrollable options
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.options.length,
              itemBuilder: (context, index) {
                final option = widget.options[index];
                return Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 18.0, vertical: 2.0),
                  child: RadioListTile<String>(
                    controlAffinity: ListTileControlAffinity.trailing,
                    value: option,
                    groupValue: selectedValue,
                    onChanged: (val) {
                      setState(() {
                        selectedValue = val;
                      });
                    },
                    title: Text(
                      option,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w400),
                    ),
                    activeColor: AppColors.textBlueColor,
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                  ),
                );
              },
            ),
          ),

          // Sticky Apply Button
          Container(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.textBlueColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0)),
              ),
              onPressed: () {
                if (selectedValue != null) {
                  widget.onApply(selectedValue!);
                  Navigator.pop(context);
                }
              },
              child: const Text(
                "APPLY",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
