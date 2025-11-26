import 'package:flutter/material.dart';
import '../../../core/util/app_theme/app_color.dart';
import '../../../core/util/app_theme/text_style.dart';

class FilterBottomSheetHelper {
  static void showFilterBottomSheet({
    required BuildContext context,
    required List<String> options,
    required List<String> selectedFilters,
    required String title,
    required VoidCallback onReset,
    required VoidCallback onUpdate,
    required Function(List<String>) onSelectionChange,
  }) {
    List<String> tempSelectedFilters = List.from(selectedFilters);

    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                 contentPadding: const EdgeInsets.only(left: 40,top: 10),
                  title: Center(
                    child: Text(
                      title,
                      style: appTextStyle.appNormalSmallTextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  trailing: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context); // Close the bottom sheet
                      },
                    ),
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.only(top: 5, left: 15,bottom: 10,right: 15),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final option = options[index];
                      return CheckboxListTile(
                        contentPadding:  EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.trailing,
                        title: Text(
                          option,
                          style: appTextStyle.appNormalSmallTextStyle(),
                        ),
                        value: tempSelectedFilters.contains(option),
                        onChanged: (value) {
                          setState(() {
                            if (value == true) {
                              tempSelectedFilters.add(option);
                            } else {
                              tempSelectedFilters.remove(option);
                            }
                          });
                        },
                        dense: true,
                        activeColor: const Color(0xFF1976D2),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: GestureDetector(
                          onTap: () {
                            tempSelectedFilters.clear(); // Clear temporary selection
                            Navigator.pop(context); // Close the bottom sheet
                            onReset(); // Apply reset filter// Apply reset filter;
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8),
                              ),
                              color: AppColors.appWhite,
                              border: Border.all(
                                // OxFF0D47A1
                                color: AppColors.textBlueColor,
                                width: 0.7, // Set the border width
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                'Clear',
                                style: appTextStyle.appNormalTextStyle(color: AppColors.black),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Flexible(
                        child: GestureDetector(
                          onTap: () {
                            onSelectionChange(tempSelectedFilters); // Update only here
                            Navigator.pop(context); // Close bottom sheet
                            onUpdate(); // Apply the updated filters
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                              color: AppColors.textBlueColor,
                            ),
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                'Apply',
                                style: appTextStyle.appNormalTextStyle(color: AppColors.appWhite),

                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            );
          },
        );
      },
    );
  }
}
