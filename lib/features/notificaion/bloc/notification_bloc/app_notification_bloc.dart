import 'package:asetize/imports.dart';
import '../../../../core/network/api_base_helpers.dart';
import '../../../../core/util/app_navigator/app_navigator.dart';
import '../../../../core/util/one_signal_notification/one_signal_notification_handler.dart';
import 'app_notification_event.dart';
import 'app_notification_state.dart';

class AppNotificationBloc
    extends Bloc<AppNotificationEvent, AppNotificationState> {
  GetAppNotificationList getNotificationList =
      GetAppNotificationList(RepositoryImpl(WorkplaceDataSourcesImpl()));
  PutMarkNotificationDisplayed markNotificationDisplayed =
      PutMarkNotificationDisplayed(RepositoryImpl(WorkplaceDataSourcesImpl()));
  PutMarkNotificationRead markNotificationRead =
      PutMarkNotificationRead(RepositoryImpl(WorkplaceDataSourcesImpl()));
  PutMarkNotificationReadDisplay markNotificationReadDisplay =
      PutMarkNotificationReadDisplay(
          RepositoryImpl(WorkplaceDataSourcesImpl()));

  List<NotificationDataList> notificationList = [];
  bool isNotificationEnabled = false;
  String notificationUrl = "";

  int notificationCount = 0;

  AppNotificationBloc() : super(AppNotificationInitState()) {
    on<GetAppNotificationListEvent>((event, emit) async {
      emit(AppNotificationLoadingState());
      // await fetchNotificationData(event.mContext!);
      Either<Failure, NotificationDataModel> response =
          await getNotificationList.call('');
      response.fold((left) {
        if (left is UnauthorizedFailure) {
          appNavigator.tokenExpireUserLogout(event.mContext!);
        }
      }, (right) {
        notificationList = right.data ?? [];
        UserProfileBloc userProfileBloc = BlocProvider.of<UserProfileBloc>(event.mContext!);
        userProfileBloc.add(UpdateNotificationCountEvent());
        emit(FetchAppNotificationDataState());
      });
    });

    on<OnNotificationReceivedEvent>((event, emit) async {
      emit(NotificationCountLoadingState());
      notificationCount = notificationCount + 1;
      emit(NotificationCountDoneState(notificationCount: notificationCount));
    });

    on<MarkNotificationDisplayedEvent>((event, emit) async {
      emit(NotificationCountDoneState());
      Either<Failure, dynamic> response =
          await markNotificationDisplayed.call('');
      response.fold((left) {
        if (left is UnauthorizedFailure) {
          appNavigator.tokenExpireUserLogout(event.mContext!);
        }
      }, (right) {
        ///Clear badge count
      OneSignalNotificationsHandler.clearNotificationBadgeCount();
      notificationCount =  0 ;
      emit(NotificationCountDoneState(notificationCount: notificationCount));
      });
    });

    on<OnNotificationStatusChangeEvent>((event, emit) async {
      isNotificationEnabled = event.enabledState;
      emit(NotificationEnabledStatusState(event.enabledState));
    });

    on<MarkNotificationReadEvent>((event, emit) async {
      updateManListForRed(event.messageID);

      Either<Failure, dynamic> response = await markNotificationRead
          .call(MarkNotificationReadParams(messageID: event.messageID));
      response.fold((left) {
        if (left is UnauthorizedFailure) {
          appNavigator.tokenExpireUserLogout(event.mContext!);
        }
      }, (right) {

        emit(MarkNotificationReadState(
            leaveId: event.leaveId));
      });
    });

    on<MarkNotificationRedirectReadDisplayEvent>((event, emit) async {
      Either<Failure, dynamic> response = await markNotificationReadDisplay
          .call(MarkNotificationReadDisplayParams(messageID: event.msgId));
      response.fold((left) {
        if (left is UnauthorizedFailure) {
          appNavigator.tokenExpireUserLogout(event.mContext!);
        }
      }, (right) {
        emit(MarkNotificationReadDisplayedState());
      });
    });


    on<OnGetNotificationCountEvent>((event, emit) async {
      emit(NotificationCountLoadingState());
      Either<Failure, dynamic> response = await ApiBaseHelpers().get(
        Uri.parse(ApiConst.notificationCountApi),
        ApiBaseHelpers.headers(),
      );

      response.fold((left) {
        // if (left is UnauthorizedFailure) {
        //  // appNavigator.tokenExpireUserLogout(event.mContext!);
        // }
        emit(NotificationCountDoneState());
      }, (right) {

        try {
          print('Notification >> ${right["data"]}');
          if(right["data"]!=null){
                    notificationCount = right['data']['notification_count'];
                  }
        } catch (e) {
          print(e);
        }
        emit(NotificationCountDoneState(notificationCount: notificationCount));
      });
    });


  }

  void updateManListForRed(int? messageID) {
    if (notificationList.isNotEmpty) {
      notificationList = notificationList.map((notification) {
        if (notification.id == messageID) {
          notification.isRead = 1;
          return notification;
        } else {
          return notification;
        }
      }).toList();
    }
  }

}
