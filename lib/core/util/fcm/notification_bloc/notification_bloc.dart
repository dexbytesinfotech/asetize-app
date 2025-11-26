import 'package:flutter_bloc/flutter_bloc.dart';
import '../../local_constant.dart';
import '../../pref_util.dart';
import '../../project_util.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(NotificationInitStat());

  @override
  Stream<NotificationState> mapEventToState(NotificationEvent event) async* {
    if (event is NotificationListGetEvent) {
      /*  yield NotificationInProgressState();
      try {
        Map data = event.requestData!;
        String? websiteId = data["website_id"];
        String? guestId = data["guest_id"];
        String url =
            "?website_id=$websiteId&wbs_cmd=notifications.get&guest_id=$guestId";
        //LoadingWidget.startLoadingWidget(event.context);
        var response = await apiRequest.getNotification(
            context: event.context, requestData: url);
        // LoadingWidget.endLoadingWidget(event.context);
        //Store login data
        if (response != null &&
            response.status &&
            response.responseData != null) {
          NotificationListModel notificationList;
          projectUtil.printP(response.responseData);
          notificationList = NotificationListModel.fromJson(
              json.decode(response.responseData));
          if (notificationList != null &&
              notificationList.notificationData != null) {
            yield NotificationListGetDoneState(
                notificationResponse: notificationList);
          } else {
            yield NotificationNoDataState(message: notificationList.message);
          }
          */ /* else {
              yield PasswordErrorState(
                  context: event.context,
                  errorMessage: response.message,
                  emailId: enteredEmail);
            }*/ /*
        } else {
          yield NotificationNoDataState(message: "No data");
        }
      } catch (e) {
        // debugPrint("$e");
      }
   */
    } else if (event is AllNotificationBadgeZeroEvent) {
      yield NotificationInProgressState();
      //Remove saved count when click message menu icon
      if (event.removeMenuNotificationDot!) {
        PrefUtils()
            .saveInt(WorkplaceNotificationConst.notificationUnreadCountC, 0);
      }
      //Remove badge count only
      projectUtil.removeBadge();
      yield AllNotificationBadgeZeroState();
    } else if (event is AllNotificationBadgeRefreshEvent) {
      yield AllNotificationBadgeRefreshState();
    } else if (event is NotificationRedirectEvent) {
      yield NotificationRedirectToState(
          notificationData: event.notificationData);
    } else if (event is NotificationReadEvent) {
      /* yield NotificationInProgressState();
      try {
        Map data = event.requestData!;
        String? notificationId = data["notification_id"];
        String url =
            "?wbs_cmd=notifications.read&notification_id=$notificationId";
        var response = await apiRequest.getNotification(
            context: event.context, requestData: url);
        //Store login data
        if (response != null &&
            response.status &&
            response.responseData != null) {
          try {
            BlocProvider.of<MainAppBloc>(event.context!).add(NotificationRefreshEvent());
          } catch (e) {
            projectUtil.printP("$e");
            // TODO
          }

        } else {

        }
      } catch (e) {
        // debugPrint("$e");
      }*/
    } else if (event is ShowerUpdateEvent) {
      yield ShowerUpdateDoneState(newShowerAdded: event.anyNewShowerAdded);
    }
  }
}
