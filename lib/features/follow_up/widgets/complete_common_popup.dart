import 'package:flutter/material.dart';

class CommonPopup extends StatelessWidget {
  final String title;
  final String subtitle;
  final String remarkLabel;
  final String remarkHint;
  final bool showPhotoButton;
  final VoidCallback? onPhotoTap;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;
  final String confirmText;
  final String cancelText;

  const CommonPopup({
    super.key,
    required this.title,
    required this.subtitle,
    required this.remarkLabel,
    required this.remarkHint,
    this.showPhotoButton = false,
    this.onPhotoTap,
    required this.onCancel,
    required this.onConfirm,
    this.confirmText = "Confirm",
    this.cancelText = "Cancel",
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9, // 🔹 90% of screen width
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: onCancel,
                    child: const Icon(Icons.close, size: 20),
                  )
                ],
              ),
              const SizedBox(height: 8),

              /// Subtitle
              Text(
                subtitle,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 16),

              /// Remark Field
              Text(
                remarkLabel,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              TextField(
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: remarkHint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.all(10),
                ),
              ),
              const SizedBox(height: 16),

              /// Photo Button (Optional)
              if (showPhotoButton) ...[
                const Text(
                  "Photo (Optional)",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                OutlinedButton.icon(
                  onPressed: onPhotoTap,
                  icon: const Icon(Icons.camera_alt_outlined),
                  label: const Text("Take Photo"),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],

              /// Bottom Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: onCancel,
                    child: Text(cancelText),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(confirmText),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

  }
}
