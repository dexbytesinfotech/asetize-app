import 'package:flutter/material.dart';
import 'package:asetize/core/core.dart';
import '../../../core/util/app_permission.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../../widgets/common_card_view.dart';
import '../pages/follow_up_detail_screen.dart';
import '../pages/new_follow_up_detail_screen.dart';
import '../../presentation/widgets/app_button_common.dart';
import '../../presentation/widgets/workplace_widgets.dart';

class FollowUpCardView extends StatelessWidget {
  final String unit;
  final String name;
  final String? title;
  final String createdDate;
  final String? assignButtonName;
  final bool isComingFromMyTask;
  final String dueDate;
  final String status;
  final String statusTag;
  final String? note;
  final String? assign;
  final String? priority;
  final String? phoneNumber;
  final VoidCallback onMarkComplete;
  final VoidCallback onAssign;
  final VoidCallback onTab;
  final VoidCallback onAddFollowUp;
  final Color? tagColor;
  final Color? tagTextColor;
  final bool isLoading; // New parameter for loading state
  final bool isLoadingForComplete;
  final bool isLoadingForAssign;
  const FollowUpCardView(
      {super.key,
      required this.unit,
      required this.name,

        this.title,
        this.assignButtonName,
      required this.createdDate,
      required this.dueDate,
      required this.status,
         this.assign,
        required this.priority,

      required this.statusTag,
      required this.phoneNumber,
      this.note,
        this.isLoading = false, // Default to false
      required this.onMarkComplete,
      required this.onAddFollowUp,    required this.onAssign,
      required this.onTab,
        this.isLoadingForComplete = false,
        this.isLoadingForAssign = false,
      this.tagColor,
        this.isComingFromMyTask= false,
      this.tagTextColor});

  @override
  Widget build(BuildContext context) {


    final canManageTaskAssign =
    AppPermission.instance.canPermission(AppString.manageTaskAssign, context: context);
    final canTaskAssign =
    AppPermission.instance.canPermission(AppString.taskAssign, context: context);

    final canShowAssign = isComingFromMyTask ?canTaskAssign :canManageTaskAssign;


    final canManageTaskComplete =
    AppPermission.instance.canPermission(AppString.manageTaskComplete, context: context);
    final canTaskComplete =
    AppPermission.instance.canPermission(AppString.taskComplete, context: context);


    final canShowComplete = isComingFromMyTask?canTaskComplete : canManageTaskComplete;


    final canManageTaskFollowUp =
    AppPermission.instance.canPermission(AppString.manageTaskFollowUp, context: context);
    final canTaskFollowUp =
    AppPermission.instance.canPermission(AppString.taskFollowUp, context: context);

    final canShowFollowUp = isComingFromMyTask ? canTaskFollowUp:  canManageTaskFollowUp;








    String _getCleanUnit(String unit) {
      return unit.replaceAll(',', '').trim();
    }
    Widget sideBox = const SizedBox(height: 3);

    final restrictedStatuses = ["closed", "cancelled", "completed", "agreed"];

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


    Widget getPriorityIcon(String priority, {double size = 25}) {
      switch (priority) {
        case 'Low':
          return Icon(Icons.keyboard_double_arrow_down_rounded, color: AppColors.textDarkGreenColor, size: size);
        case 'Medium':
          return Icon(Icons.drag_handle, color: Colors.orange, size: 30);
        case 'High':
          return Icon(Icons.keyboard_double_arrow_up, color: Colors.red, size: size);
        case 'Urgent':
          return Stack(
            alignment: Alignment.center,
            children: [
              Icon(Icons.keyboard_double_arrow_up, color: Colors.red, size: size + 4), // मोटा
              Positioned(
                top: -4,
                child: Icon(Icons.keyboard_double_arrow_up, color: Colors.red, size: size + 4),
              ),
            ],
          );
        default:
          return Icon(Icons.keyboard_arrow_up, color: Colors.grey, size: size);
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





    return GestureDetector(
      onTap: onTab,
      child: CommonCardView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded( // whole left section
                    child: GestureDetector(
                      onTap: () {
                        if ((phoneNumber ?? '').isNotEmpty) {
                          projectUtil.makingPhoneCall(phoneNumber: phoneNumber!);
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min, // ✅ prevents icon from being pushed away
                        children: [
                          Flexible( // ✅ allow ellipsis but don't push icon
                            child: Text(
                              _getCleanUnit(unit).isNotEmpty ? unit : (title ?? ''),
                              style: appTextStyle.appTitleStyle2(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                          if ((phoneNumber ?? '').isNotEmpty)
                            const Icon(Icons.phone, color: AppColors.appBlueColor, size: 20),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    decoration: BoxDecoration(
                      color: getStatusColor(status).withOpacity(0.4),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      statusTag,
                      style: appTextStyle.appTitleStyle(
                        color: getStatusTextColor(status),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  getPriorityIcon(priority ?? '', size: 25),

                ],
              ),

              const SizedBox(height: 1),
              Row(
                children: [
                   Icon(
                    Icons.access_time_sharp,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    "Created: $createdDate",
                    style: appTextStyle.appSubTitleStyle2(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              if (dueDate.isNotEmpty)
              sideBox,

              if (dueDate.isNotEmpty)
                Row(
                  children: [
                    WorkplaceWidgets.calendarIcon(color: Colors.black, size: 16),
                    const SizedBox(width: 5),
                    Text(
                      "Due: $dueDate",
                      style: appTextStyle.appSubTitleStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),




                  ],
                ),
              if (note != null && note!.isNotEmpty)
              sideBox,
              if (note != null && note!.isNotEmpty) ...[
                sideBox,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 3),
                      child: Icon(Icons.message,size: 15.5, color: Colors.black),
                    ),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(note??"",
                        style: appTextStyle.appSubTitleStyle(fontWeight: FontWeight.w400,fontSize: 14,),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
              if (assign != null && assign!.isNotEmpty) ...[
                sideBox,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 3),
                      child: Icon(Icons.person_2_outlined,size: 18, color: Colors.black),
                    ),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text( "Assigned to: $assign",
                        style: appTextStyle.appSubTitleStyle(fontWeight: FontWeight.w400,fontSize: 14,),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),


              ],
              // if (priority != null && priority!.isNotEmpty) ...[
              //   sideBox,
              //   Row(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       const Padding(
              //         padding: EdgeInsets.only(top: 3),
              //         child: Icon(Icons.label_important_outline
              //             ,size: 18, color: Colors.black),
              //       ),
              //       const SizedBox(width: 5),
              //       Flexible(
              //         child: Text( "Priority: $priority",
              //           style: appTextStyle.appSubTitleStyle(fontWeight: FontWeight.w400,fontSize: 14,),
              //           maxLines: 1,
              //           overflow: TextOverflow.ellipsis,
              //         ),
              //       ),
              //     ],
              //   ),
              //
              //
              // ],

              if (!restrictedStatuses.contains(status.toLowerCase()))
                const SizedBox(height: 12),
              if (!restrictedStatuses.contains(status.toLowerCase()))
                Row(
                  children: [
                    if (canShowAssign)
                      Expanded(
                        child: AppButton(
                          buttonHeight: 35,
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          buttonName: assignButtonName??'Assign',
                          buttonColor: AppColors.textBlueColor,
                          buttonBorderColor: Colors.grey,
                          backCallback: onAssign,
                          flutterIcon: Icons.person_2_outlined, // ✅ Assign icon
                          isShowIcon: true,
                          iconSize: const Size(18, 18),
                        ),
                      ),
                    if (canShowAssign)
                      const SizedBox(width: 12),

                    if (canShowComplete)

                      Expanded(
                        child: AppButton(
                          buttonHeight: 35,
                          textStyle: const TextStyle(
                            color: AppColors.white,
                            fontSize: 14,
                          ),
                          buttonName: 'Complete',
                          buttonColor: AppColors.textDarkGreenColor,
                          buttonBorderColor: Colors.grey,
                          backCallback: onMarkComplete,
                          isLoader: isLoadingForComplete,
                          flutterIcon: Icons.check, // ✅ Complete icon
                          isShowIcon: true,
                          iconSize: const Size(18, 18),
                        ),
                      ),
                    if (canShowComplete)
                      const SizedBox(width: 12),

                    if (canShowFollowUp)
                      Expanded(
                        child: AppButton(
                          buttonHeight: 35,
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          buttonName: 'Follow-up',
                          buttonColor: AppColors.orange,
                          buttonBorderColor: Colors.grey,
                          backCallback: onAddFollowUp,
                          flutterIcon: Icons.messenger_outline, // ✅ Follow-up icon
                          isShowIcon: true,
                          iconSize: const Size(18, 18),
                        ),
                      ),
                  ],
                )


            ],
          ),
        ),
      ),
    );
  }
}
