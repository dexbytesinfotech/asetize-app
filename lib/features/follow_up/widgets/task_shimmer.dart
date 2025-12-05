import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class TaskFullPageShimmer extends StatelessWidget {
  const TaskFullPageShimmer({super.key});

  Widget shimmerBox({
    required double height,
    required double radius,
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade200, // 🔥 Soft highlight
      period: const Duration(milliseconds: 1500), // 🔥 Slow shimmer
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey.shade200, // 🔥 Light background
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: ListView(
        padding: const EdgeInsets.only(top: 10),
        children: [
          /// Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: shimmerBox(height: 36, radius: 12),
          ),

          const SizedBox(height: 12),

          /// Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(child: shimmerBox(height: 32, radius: 10)),
                const SizedBox(width: 12),
                Expanded(child: shimmerBox(height: 32, radius: 10)),
              ],
            ),
          ),

          const SizedBox(height: 12),

          /// Cards
          ...List.generate(
            5,
                (index) => Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: shimmerBox(height: 100, radius: 20),
            ),
          ),
        ],
      ),
    );
  }
}
