import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:asetize/features/account_books/pages/payment_history_detail_screen.dart';
import 'package:asetize/features/my_unit/pages/my_unit_new_screen.dart';
import 'package:asetize/features/presentation/presentation.dart';
import 'package:asetize/features/my_visitor/models/visitor_model.dart' as VisitorModel;
import '../../../features/add_transaction_receipt/page/transaction_receipt_detail_screen.dart';
import '../../../features/assets_management/pages/assets_detail_screen.dart';
import '../../../features/complaints/pages/complaint_detail_screen.dart';
import '../../../features/feed/pages/comment_new_screen.dart';
import '../../../features/follow_up/models/get_task_list_model.dart';
import '../../../features/follow_up/pages/new_two_follow_up_detail_screen.dart';
import '../../../features/home_screen/pages/all_notice_screen.dart';
import '../../../features/home_screen/pages/notice_detail_page.dart';
import '../../../features/my_unit/pages/noc_applied_detail_screen.dart';
import '../../../features/my_unit/pages/transaction_detail_screen.dart';
import '../../../features/my_visitor/pages/today_my_visitor_detail_screen.dart';
import '../../../features/noc_list/models/noc_request_model.dart';
import '../../../features/noc_list/pages/noc_request_detail_screen.dart';
import '../../../features/notificaion/bloc/notification_bloc/app_notification_bloc.dart';
import '../../../features/notificaion/bloc/notification_bloc/app_notification_event.dart';
import '../../../imports.dart';
import '../../network/api_base_helpers.dart';
import '../one_signal_notification/one_signal_notification_handler.dart';

class AppNavigator {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  String? deviceId;
  //SignUpScreen
  void launchSignUpPage(BuildContext context, {bool canBackArrow = false}) =>
      context.go("/login");

  //Splash screen
  launchSplashScreen(BuildContext context) => context.go("/");

  launchDashBoardScreen(BuildContext context) => context.go("/dashBoard");
  //SignInScreen
  launchSignInPage(BuildContext context) => context.go("/login");
  //SignInScreen
  launchForgotPasswordPage(BuildContext context) =>
      context.go("/login/forgotPassword");

  launchTeamMemberDetailPageComment(BuildContext context, {Object? extra}) =>
      context.go("/post_comment/team_member_detail", extra: extra);

  //PostLikedPeopleListScreen
  launchPostLikedPeopleListPage(BuildContext context, {Object? extra}) =>
      context.go("/dashBoard/post_liked_list", extra: extra);
  //CommentScreen
  launchCommentPage(BuildContext context) =>
      context.go("/dashBoard/post_comment");
  //Notification Screen
  launchNotificationPage(BuildContext context) =>
      context.go("/dashBoard/notification");
  launchTeamMemberDetailPageDashboard(BuildContext context, {Object? extra}) =>
      context.go("/dashBoard/team_member_detail", extra: extra);
  launchAboutPageProfile(BuildContext context, {Object? extra}) =>
      context.go("/dashBoard/about", extra: extra);
  launchMyPostPageProfile(BuildContext context, {Object? extra}) =>
      context.go("/dashBoard/my_post", extra: extra);
  launchMyHousePageProfile(BuildContext context, {Object? extra}) =>
      context.go("/dashBoard/my_house", extra: extra);
  launchEditProfilePage(BuildContext context, {Object? extra}) =>
      context.go("/dashBoard/edit_profile", extra: extra);
  launchSettingsPageProfile(BuildContext context, {Object? extra}) =>
      context.go("/dashBoard/settings", extra: extra);
  launchPolicyPageProfile(BuildContext context, {Object? extra}) =>
      context.go("/dashBoard/policy", extra: extra);
  launchFaqPageProfile(BuildContext context, {Object? extra}) =>
      context.go("/dashBoard/faq", extra: extra);
  MatrimonyScreen(BuildContext context, {Object? extra}) =>
      context.go("/dashBoard/Vehicle_Information", extra: extra);
  VehicleDetaish(BuildContext context, {Object? extra}) =>
      context.go("/dashBoard/Vehicle_Details", extra: extra);
  SearchVehicle(BuildContext context, {Object? extra}) =>
      context.go("/dashBoard/Search_Vehicle", extra: extra);

  launchLeaveApplyPageProfile(BuildContext context, {Object? extra}) =>
      context.go("/dashBoard/leave_apply", extra: extra);
  launchCreateSpotlightPage(BuildContext context, {Object? extra}) =>
      context.go("/dashBoard/create_spotlight", extra: extra);
  launchSpotlightPage(BuildContext context, {Object? extra}) =>
      context.go("/dashBoard/spotlight", extra: extra);
  launchMySpotlightPage(BuildContext context, {Object? extra}) =>
      context.go("/dashBoard/my_spotlight", extra: extra);
  launchSpotlightDetails(BuildContext context, {Object? extra}) =>
      context.go("/dashBoard/spotlight_details", extra: extra);
  launchSpotlightGroupDetails(BuildContext context, {Object? extra}) =>
      context.go("/dashBoard/spotlight_group_details", extra: extra);
  launchAnnouncementDetailPageProfile(BuildContext context, {Object? extra}) =>
      context.go("/dashBoard/announcement_details", extra: extra);
  launchAnnouncementPageProfile(BuildContext context, {Object? extra}) =>
      context.go("/dashBoard/announcement", extra: extra);

  // Future<void> launchLogOutAndSign(BuildContext context) async {
  //   MainAppBloc mainAppBloc = MainAppBloc();
  //   await PrefUtils()
  //       .readStr(WorkplaceNotificationConst.deviceIdC)
  //       .then((value) {
  //     if (value.isNotEmpty) {
  //       mainAppBloc.add(LogOutEvent(
  //         context: MainAppBloc.getDashboardContext,
  //         deviceId: value,
  //       ));
  //     }
  //   });
  // }

  //SignInScreen
  void launchVerificationCodePage(BuildContext context,
      {String userEmail = ""}) {
    // Navigator.push(
    //   context,
    //   SlideRightRoute(widget: const SignInScreen()),
    // );
  }

  void popBackStack(BuildContext context) {
    context.go("/dashBoard");
    // Navigator.pop(context);
  }

  Future<void> launchLogOutAndSignUp(BuildContext context) async {
    MainAppBloc mainAppBloc = BlocProvider.of<MainAppBloc>(context);
    await PrefUtils()
        .readStr(WorkplaceNotificationConst.deviceIdC)
        .then((value) {
      if (value.isNotEmpty) {
        mainAppBloc.add(LogOutEvent(
          context: MainAppBloc.getDashboardContext,
          deviceId: value,
        ));
      }
    });
  }

  Future<void> tokenExpireUserLogout(BuildContext context) async {
    MainAppBloc mainAppBloc = BlocProvider.of<MainAppBloc>(context);
    mainAppBloc.add(ExpireTokenEvent(
      context: MainAppBloc.getDashboardContext ?? context ,
    ));
  }



  /// Redirect on Selected Screen
  Future<void> onTapNotification(BuildContext mContext,Map<String,dynamic> notificationData,{String? notificationId}) async {
    /*{
      "type":"invoice",
      "company_id":"1",
      "house_id":"2",
      "message_id":"25",
      "invoice_id":"1096"
    }*/

    String redirectionType = notificationData['type'];
    String companyIdStr = notificationData.containsKey('company_id')?notificationData['company_id']:"";
    String companyNameStr = notificationData.containsKey('company_name')?notificationData['company_name']:"";
    String houseIdStr = notificationData.containsKey('house_id')?notificationData['house_id']??"":"";
    String messageId = notificationData.containsKey('message_id')?notificationData['message_id']:"";

    redirectTo(BuildContext mContext){

      Future.delayed(const Duration(milliseconds: 300)).then((value) {
        if(houseIdStr.trim().isNotEmpty) {
          UserProfileBloc userProfileBloc = BlocProvider.of<UserProfileBloc>(mContext);
          Houses? house = userProfileBloc.user.houses!=null?userProfileBloc.user.houses![0]:null;
          int houseId = int.parse(houseIdStr);
          house = userProfileBloc.user.houses?.firstWhere((value) => value.id == houseId);
          userProfileBloc.add(OnChangeCurrentUnitEvent(selectedUnit: house));
        }
        ///Clear badge count
        if(notificationId!=null) {

          /// Call Api to make notification is read
          if(messageId.isNotEmpty) {
            /// Reduce count by 1
            try {
              OneSignalNotificationsHandler.clearNotificationBadgeCount(notificationId: int.parse(notificationId));
            } catch (e) {
              print(e);
            }
            BlocProvider.of<AppNotificationBloc>(mContext)
                .add(MarkNotificationReadEvent(
                messageID: int.parse(messageId)
            ));
          }
        }
        projectUtil.printP("notificationClick and redirect screen =>notificationData $notificationData");
        switch (redirectionType) {
          case "post":
            String invoiceIdStr = notificationData['id'];
            int id = int.parse(invoiceIdStr);
            Navigator.push(
              mContext,
              SlideLeftRoute(
                  widget: CommentNewScreen(
                    showFullDescription:
                    true,
                    postId: id,
                    focusOnTextField: false,
                  )),
            );
            break;
          case "noc-request":
            String invoiceIdStr = notificationData['id'];
            int id = int.parse(invoiceIdStr);
            Navigator.push(
              mContext,
              SlideLeftRoute(
                widget:NocRequestDetailScreen(
                  nocRequestData: NocRequestData(
                    id: id
                  ),
                ),
              ),
            );
            break;
          case "expense":
            String invoiceIdStr = notificationData['id'];
            int id = int.parse(invoiceIdStr);
            Navigator.push(
              mContext,
              SlideLeftRoute(
                widget:PaymentHistoryDetailScreen(
               id: id,
               tableName: "expense" ,
                ),
              ),
            );
            break;
            case "noc":
            String invoiceIdStr = notificationData['id'];
            int id = int.parse(invoiceIdStr);
            Navigator.push(
              mContext,
              SlideLeftRoute(
                widget: NocAppliedDetailScreen(
                  id: id,
                  title: '',

                ),
              ),
            );

            break;

            case "visitor":
            String invoiceIdStr = notificationData['id'];
            int id = int.parse(invoiceIdStr);
            Navigator.push(
              mContext,
              SlideLeftRoute(
                widget: VisitorDetailScreen(
                  visitorData: VisitorModel.VisitorData(
                      entryId: id
                  ),

                ),
              ),
            );

            break;
            case "post_comment":
              String invoiceIdStr = notificationData['id'];
              int id = int.parse(invoiceIdStr);
              Navigator.push(
                mContext,
                SlideLeftRoute(
                    widget:
                        CommentNewScreen(
                          showFullDescription:
                          true,
                          postId: id,
                          focusOnTextField: true,
                        )),
              );
            break;

          case "complaint":
            String invoiceIdStr = notificationData['id'];
            int id = int.parse(invoiceIdStr);
            Navigator.push(
              mContext,
              SlideLeftRoute(
                  widget:
                      ComplaintDetailScreen(
                        complaintId: id
                      )),
            );
            break;

            case "complaint_comment":
              String invoiceIdStr = notificationData['id'];
              int id = int.parse(invoiceIdStr);
              Navigator.push(
                mContext,
                SlideLeftRoute(
                    widget:
                        ComplaintDetailScreen(
                            complaintId: id
                        )),
              );
            break;

          case "payment":
            String invoiceIdStr = notificationData['id'];
            int id = int.parse(houseIdStr);
            /// Commented as per requirement
            // Navigator.push(
            //     mContext,
            //     MaterialPageRoute(
            //         builder: (context) =>
            //             TransactionDetailScreen(
            //               comeFrom: ComeFromForDetails.unitPayment,
            //               id: id,
            //               tableName: 'payment',
            //               date: '',
            //               title: '',
            //               receiptNumber: '',
            //             )));

            Navigator.push(
                mContext,
                SlideLeftRoute(
                    widget:
                       const MyUnitNewScreen(comeFor: 'payment')));
            break;
          case "invoice":
            // String invoiceIdStr = notificationData['id'];
            // int id = int.parse(invoiceIdStr);
            /// Commented as per requirement
            // Navigator.push(
            //     mContext,
            //     MaterialPageRoute(
            //         builder: (context) =>
            //             TransactionDetailScreen(
            //               comeFrom: ComeFromForDetails.unitStatement,
            //               id: id,
            //               tableName: 'invoice',
            //               date: '',
            //               title: '',
            //               receiptNumber: '',
            //             )));
            Navigator.push(
                mContext,
                SlideLeftRoute(
                    widget:
                    const MyUnitNewScreen(comeFor: "invoice",)));
            break;
          case "join_request":
            Navigator.push(
              mContext,
              SlideLeftRoute(
                  widget:
                  const MyUnitNewScreen()),
            );
            break;

            case "announcement":
            Navigator.push(
              mContext,
              SlideLeftRoute(
                  widget:
                  const AllNoticeScreen()),
            );
            break;



            case "payment_acknowledge":
            Navigator.push(
              mContext,
              SlideLeftRoute(
                  widget:
                  const TransactionReceiptDetailScreen()),
            );
            break;

          case "task_comment":
            String taskCommentId = notificationData['id'];
            print(taskCommentId);
            int id = int.parse(taskCommentId);
            Navigator.push(
              mContext,
              SlideLeftRoute(
                  widget:
                   NewFollowUpDetailScreen(
                       taskListData: TaskListData(
                         id:id,

                       )
                  )),
            );
            break;


          case "task_assigned":
            String taskAssignedId = notificationData['id'];
            print(taskAssignedId);
            int id = int.parse(taskAssignedId);
            Navigator.push(
              mContext,
              SlideLeftRoute(
                  widget:
                  NewFollowUpDetailScreen(
                      taskListData: TaskListData(
                          id:id
                      )
                  )),
            );
            break;

          case "task":
            String taskId = notificationData['id'];
            int id = int.parse(taskId);
            Navigator.push(
              mContext,
              SlideLeftRoute(
                  widget:
                  NewFollowUpDetailScreen(
                    isShowMarkCompletedButton: false,
                      taskListData: TaskListData(
                          id:id
                      )
                  )),
            );
            break;

            case "asset_assigned":
            String taskId = notificationData['id'];
            int id = int.parse(taskId);
            Navigator.push(
              mContext,
              SlideLeftRoute(
                  widget:
                  AssetsListDetailScreen(
                    assetId: id,

                  )),
            );
            break;


            case "asset_acceptance_reminder":
            String taskId = notificationData['id'];
            int id = int.parse(taskId);
            Navigator.push(
              mContext,
              SlideLeftRoute(
                  widget:
                  AssetsListDetailScreen(
                    assetId: id,

                  )),
            );
            break;

          default:
            break;
        }
      });
    }

    if(companyIdStr.isNotEmpty){
      final savedCompanyId = WorkplaceDataSourcesImpl.selectedCompanySaveId;
      int companyId = int.parse(companyIdStr);
      projectUtil.printP("notificationClick => savedId $savedCompanyId    ==  incoming $companyId");
      UserProfileBloc userProfileBloc = BlocProvider.of<UserProfileBloc>(mContext);
      /// No Need to change selected company
      if(companyIdStr == savedCompanyId){
        if(houseIdStr.trim().isNotEmpty) {
          int houseId = int.parse(houseIdStr);
          userProfileBloc.add(
              OnCompanyChangInBackground(mContext: mContext, houseId: houseId,companyId: companyId,companyName: companyNameStr));
        }
        redirectTo(mContext);
      }
      /// Need to auto change Company
      else
      {
        String message = AppString.receivedANewMessageContent.replaceAll("[Society Name]", companyNameStr);
        showDialog(
          barrierDismissible: false,
          context: mContext,
          builder: (ctx) {
            bool isLoading = false;
            return
              BlocListener<UserProfileBloc, UserProfileState>(
                // bloc: homeNewBloc,
                listener: (context, state) {
              if (state is UserProfileFetched ) {
                redirectTo(mContext);
                Navigator.pop(ctx);
              }
              if (state is UserProfileError ) {
                Navigator.pop(ctx);
              }
            },
            child:
              BlocBuilder<UserProfileBloc, UserProfileState>(
                bloc: userProfileBloc,
                builder: (context, state) {
                  if (state is UserProfileFetching) {
                    isLoading = true;
                  }
                  else {
                    isLoading = false;
                  }
                  return
                    Stack(
                      children: [
                        WorkplaceWidgets.titleContentPopup(
                        buttonName1: AppString.capitalSkip,
                        buttonName2: AppString.yes,
                        onPressedButton1TextColor: AppColors.black,
                        onPressedButton2TextColor: AppColors.white,
                        onPressedButton1Color: Colors.grey.shade200,
                        onPressedButton2Color: AppColors.appBlueColor,
                        onPressedButton1: () {
                          Navigator.pop(ctx);
                        },
                        onPressedButton2: () async {
                          int? houseId;
                          if(houseIdStr.trim().isNotEmpty) {
                            houseId = int.parse(houseIdStr);
                          }
                          userProfileBloc.add(OnCompanyChangInBackground(mContext: mContext,companyId: companyId,houseId: houseId,companyName: companyNameStr));
                          // redirectTo(mContext);
                          // Navigator.pop(ctx);
                        },
                        title: AppString.newNotificationReceived,
                        content: message,
                                          ),
                        if(isLoading)  SizedBox(
                            height: MediaQuery.of(context).size.height, child: WorkplaceWidgets.progressLoader(context))
                      ],
                    );
                }));
          },
        );

      }
    }
  }


}

AppNavigator appNavigator = AppNavigator();
