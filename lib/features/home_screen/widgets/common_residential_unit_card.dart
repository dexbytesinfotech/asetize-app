import 'package:flutter/material.dart';
import 'package:asetize/widgets/common_card_view.dart';

import '../../../core/util/app_theme/text_style.dart';

class ResidentialUnitCard extends StatelessWidget {
  final String title;
  final String unitNumber;
  final String? address;
  final VoidCallback? onTap;

  const ResidentialUnitCard({
    super.key,
    required this.title,
    required this.unitNumber,
     this.address,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // Make the card tappable
      child: CommonCardView(
        elevation: 1.5,
        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFFDDEEFF), // light blue tint
                Color(0xFFFFE8CC),// Light orange (peachy)
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16.0).copyWith(right: 14),
          child: Row(
            children: [
              // Icon in circle
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(12),
                child: const Icon(Icons.apartment, color: Color(0xff4f46e5)),
              ),
              const SizedBox(width: 16),
              // Title section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: appTextStyle.appTitleStyle(
                        fontSize:18 ,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      unitNumber,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black),
            ],
          ),
        ),
      ),
    );

  }
}
