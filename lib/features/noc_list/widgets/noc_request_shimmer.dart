import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class NocRequestShimmer extends StatelessWidget {
  const NocRequestShimmer({super.key});

  Widget shimmerContainer({
    required double height,
    required double width,
    double radius = 8,
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade200,
      period: const Duration(milliseconds: 1500), // 🔥 Slow shimmer

      // 🔥 Soft highlight
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.grey.shade200, // 🔥 Light background
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }

  /// Single Card Layout Shimmer
  Widget nocCardShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade200,
      period: const Duration(milliseconds: 1500),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5), // reduced spacing

        padding: const EdgeInsets.all(14).copyWith(top: 18,bottom: 18),
        decoration: BoxDecoration(
          color: Colors.grey.shade200, // 🔥 Light background
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// First Row -> Name + Status Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                shimmerContainer(height: 14, width: 160, radius: 6), // Name
                shimmerContainer(height: 22, width: 70, radius: 30), // Status Tag
              ],
            ),

            const SizedBox(height: 12),

            shimmerContainer(height: 14, width: 120, radius: 6), // Subtitle
            const SizedBox(height: 6),
            shimmerContainer(height: 14, width: 100, radius: 6), // Date
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: const Color(0xFFF7F7F7),

      body: ListView(

        padding: const EdgeInsets.only(top: 4),

        children: [
          /// 🔍 Search Bar
          ...List.generate(6, (index) => nocCardShimmer()),
        ],
      ),
    );
  }
}
