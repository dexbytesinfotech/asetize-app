import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:asetize/core/core.dart';
import 'package:asetize/widgets/common_card_view.dart';
import '../../../core/util/app_theme/app_color.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../presentation/widgets/workplace_widgets.dart';
import '../models/get_follow_up_list_model.dart';
import '../models/get_task_list_model.dart';

class FollowUpDetailCardView extends StatelessWidget {
  final String? title;
  final String? description;
  final String? createdBy;
  final String? status;
  final bool? isStatusCompleted;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final GetFollowUpListData getFollowUpListData;

  const FollowUpDetailCardView({
    super.key,
    this.title,
    this.onEdit,
    this.onDelete,
    this.isStatusCompleted,
    this.description,
    this.createdBy,
    this.status,
    required this.getFollowUpListData
  });

  @override
  Widget build(BuildContext context) {



    Color getStatusColor(String status) {
      switch (status) {
        case 'Completed':
          return const Color(0xFFD3D3D3); // Light Grey
        case "Didn't Pick":
          return const Color(0xFFFFE0B2); // Light Orange
        case 'Agreed':
          return const Color(0xFFC8E6C9); // Light Green
        case 'Follow Up':
          return const Color(0xFFBBDEFB); // Light Blue
        case 'Open':
          return const Color(0xFFFFCDD2); // Light Red
        case 'All Status':
          return const Color(0xFFE0F7FA); // Light Cyan
        case 'Cancelled':
          return const Color(0xFFF8BBD0); // Light Pink
        default:
          return const Color(0xFFE0E0E0); // Default Light Grey
      }
    }

    Color getStatusTextColor(String status) {
      switch (status) {
        case 'Completed':
          return Colors.black87;
        case "Didn't Pick":
          return Colors.orange;
        case 'Agreed':
          return Colors.green;
        case 'Follow Up':
          return Colors.blue;
        case 'Open':
          return Colors.red;
        case 'All Status':
          return Colors.teal;
        case 'Cancelled':
          return Colors.pink;
        default:
          return Colors.black87;
      }
    }
    return CommonCardView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                     Icons.calendar_month,
                  size: 18,
                  color: AppColors.black,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      getFollowUpListData.createdAt ?? 'September 2, 2025',
                      style: appTextStyle.appTitleStyle(),
                    ),
                  ),
                ),

                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                  decoration: BoxDecoration(
                    color: getStatusColor(getFollowUpListData.status ?? ""),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    getFollowUpListData.status?? 'Completed',
                    style: appTextStyle.appTitleStyle2(
                      color: getStatusTextColor(getFollowUpListData.status ?? ""),
                      fontSize: 12,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (isStatusCompleted == true)
                GestureDetector(
                  onTap: () {
                    WorkplaceWidgets.commonEditDeleteBottomSheet(
                      context: context,
                      onEdit: () {
                        debugPrint("Edit Follow-up tapped");
                        onEdit?.call();
                        // 👉 Navigate to edit follow-up
                      },
                      editTitle: "Edit Follow-up",
                      onDeleteConfirmed: () {
                        onDelete?.call(); // 🔥 call parent callback

                        debugPrint("Delete Follow-up tapped");
                        // 👉 Call bloc or API for delete
                      },
                      deleteTitle: "Delete Follow-up",
                      deleteMessage:
                      "Are you sure you want to delete this follow-up?",
                    );
                  },
                  child: const Icon(
                    CupertinoIcons.ellipsis_vertical,
                    size: 20,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              getFollowUpListData.remark ??
                  'Called resident, confirmed payment by Sep 8th',
              style: appTextStyle.appSubTitleStyle2(),
            ),
            const SizedBox(height: 6),
            Text(
              "Created by : ${getFollowUpListData.user?.name}" ?? 'by Sarah Johnson',
              style: appTextStyle.appSubTitleStyle2(fontSize: 12),
            ) ,
            const SizedBox(height: 6),
            if (getFollowUpListData.followupDate != null)
            Text(
              "Next FollowUp Date : ${getFollowUpListData.followupDate}" ?? 'by Sarah Johnson',
              style: appTextStyle.appSubTitleStyle2(fontSize: 12),
            )
          ],
        ),
      ),
    );
  }
}
