import 'package:flutter/material.dart';

class InfoBox extends StatelessWidget {
  final List<InfoItem> items;

  const InfoBox({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.0, // 👈 this gives the shadow effect
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // same border radius as your container
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300,width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: items.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Icon(item.icon, color: Colors.black54,size: 22,),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item.text,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );

  }
}

class InfoItem {
  final IconData icon;
  final String text;

  InfoItem({required this.icon, required this.text});
}
