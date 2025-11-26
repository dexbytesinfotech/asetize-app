import 'package:flutter/material.dart';

import '../../../imports.dart';

class AssignBottomSheet extends StatefulWidget {
  final String title; // e.g., "Assign To"
  final List<Map<String, String>> people;
  // Example: [{ "name": "John Smith", "role": "Manager" }]
  final String selectedName;
  final Function(String) onAssign;

  const AssignBottomSheet({
    super.key,
    required this.title,
    required this.people,
    required this.selectedName,
    required this.onAssign,
  });

  @override
  State<AssignBottomSheet> createState() => _AssignBottomSheetState();
}

class _AssignBottomSheetState extends State<AssignBottomSheet> {
  String? selectedPerson;

  @override
  void initState() {
    super.initState();
    selectedPerson = widget.selectedName;
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
          borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// Title
            Row(
              children: [
                Icon(       Icons.person_add_outlined, // <-- Dynamic icon
                  size: 30,                   color: Colors.black,
                ),
                SizedBox(width: 15,),
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),

            /// Close Button
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration:  BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade100, // keeps button visible
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

          // People List
          Expanded(
            child: ListView.builder(
              itemCount: widget.people.length,
              itemBuilder: (context, index) {
                final person = widget.people[index];
                final isSelected = person["name"] == selectedPerson;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedPerson = person["name"];
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 6),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.grey.shade200 : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? AppColors.textBlueColor : Colors.grey.shade300,
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.grey.shade300,
                          child: const Icon(Icons.person, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              person["name"] ?? "",
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              person["role"] ?? "",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Assign Button
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.textBlueColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
              ),
              onPressed: () {
                if (selectedPerson != null) {
                  widget.onAssign(selectedPerson!);
                  Navigator.pop(context);
                }
              },
              child: const Text(
                "Assign Task",
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
