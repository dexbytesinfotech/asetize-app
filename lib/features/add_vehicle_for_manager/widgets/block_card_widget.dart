import 'package:flutter/material.dart';
import 'package:asetize/widgets/common_card_view.dart';

import '../../../core/util/app_theme/app_color.dart';

class BlockCardView extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final int? membersCount;
  final int? vehiclesCount;

  const BlockCardView({
    super.key,
    required this.title,
    this.membersCount,
    this.vehiclesCount,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CommonCardView(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    title.trim(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),

                ],
              ),

              Row(
                children: [
                  if(vehiclesCount!= null && vehiclesCount!>=1) Text(
                    '$vehiclesCount',style: const TextStyle(color: AppColors.black),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  if(vehiclesCount!= null && vehiclesCount!>=1)  const Icon(
                    Icons.car_rental,
                    color: Colors.grey,
                    size: 15,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  if(membersCount!= null && membersCount!>=1) Text(
                    '$membersCount',style: const TextStyle(color: AppColors.black),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  if(membersCount!= null && membersCount!>=1) const Icon(
                    Icons.group,
                    color: Colors.grey,
                    size: 15,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                    size: 18,
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
