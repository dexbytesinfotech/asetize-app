import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:asetize/core/core.dart';
import 'package:asetize/widgets/common_card_view.dart';

import '../../../core/util/app_theme/app_color.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../models/task_history_list_model.dart';

class FollowUpHistoryCardView extends StatelessWidget {
  final TaskHistoryListData? taskHistoryListData;

  const FollowUpHistoryCardView({super.key, this.taskHistoryListData});

  @override
  Widget build(BuildContext context) {
    return CommonCardView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.safeOpacity(0.15),
              ),
              child: const Icon(
                CupertinoIcons.clock,
                size: 14,
                color: AppColors.black,
              ),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title (Activity type or fallback to UpdatedAt)
                  Text(
                    _getActivityTitle(taskHistoryListData?.description ?? ""),
                    style: appTextStyle.appTitleStyle(),
                  ),

                  Text(
                    "${taskHistoryListData?.user?.name ?? 'Unknown'} • ${taskHistoryListData?.updatedAt ?? ''}",
                    style: appTextStyle.appSubTitleStyle2(fontSize: 13),
                  ),

                  const SizedBox(height: 6),

                  // Description
                  Text(
                    taskHistoryListData?.description ?? "",
                    style: appTextStyle.appSubTitleStyle2(),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  /// Extracts activity type for title (e.g., Commented, Updated, Follow-up)
  String _getActivityTitle(String description) {
    if (description.toLowerCase().contains("updated")) {
      return "Follow-up Added";
    } else if (description.toLowerCase().contains("assigned")) {
      return "Task Assigned";
    } else if (description.toLowerCase().contains("registered")) {
      return "Complaint Registered";
    } else if (description.toLowerCase().contains("commented")) {
      return "Comment Added";
    }
    return "Activity";
  }
}
