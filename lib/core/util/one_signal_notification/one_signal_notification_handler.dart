import 'package:onesignal_flutter/onesignal_flutter.dart';
import '../../../features/about_us/pages/about_us_screen.dart';
import '../../../features/notificaion/bloc/notification_bloc/app_notification_bloc.dart';
import '../../../features/notificaion/bloc/notification_bloc/app_notification_event.dart';
import '../../../imports.dart';
export 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:html/parser.dart';

import '../app_navigator/app_navigator.dart';

class OneSignalNotificationsHandler {
  // Instance variables
  Future Function()? refreshPage;
  static bool notificationListenerAdded = false;
  static bool listenerAdded = false;
  static BuildContext? mContext;
  late OneSignalNotifications oneSignalNotifications;

  // Prevent duplicate navigation
  static bool isNavigating = false;
  static String onReceivedNotificationId = "";
  static String onClickedNotificationId = "";

  late final void Function(OSNotificationClickEvent event) clickListener;
  late final void Function(OSNotificationWillDisplayEvent event) foregroundListener;

  // Singleton setup
  static final OneSignalNotificationsHandler instance =
  OneSignalNotificationsHandler._internal();

  factory OneSignalNotificationsHandler() {
    return instance;
  }

  OneSignalNotificationsHandler._internal() {
    // Click Listener
    clickListener = (OSNotificationClickEvent event) {
      debugPrint('NOTIFICATION CLICK LISTENER CALLED WITH EVENT: $event');
      String title = parse(event.notification.title!).body!.text.trim();
      String body = parse(event.notification.body!).body!.text.trim();
      title = const HtmlEscape().convert(title);
      body = const HtmlEscape().convert(body);
      event.notification.title = title;
      event.notification.body = body;

      onClick(event);
    };

    // Foreground Listener
    foregroundListener = (OSNotificationWillDisplayEvent event) {
      String title = parse(event.notification.title!).body!.text.trim();
      String body = parse(event.notification.body!).body!.text.trim();
      title = const HtmlEscape().convert(title);
      body = const HtmlEscape().convert(body);
      event.notification.title = title;
      event.notification.body = body;

      event.preventDefault();
      event.notification.display();

      refreshPage?.call(); // ✅ Safe usage now
      onMessageReceived(event);
    };
  }

  Future<void> setAppContext(BuildContext context) async {
    mContext = context;
  }

  Future<void> initPlatformState() async {
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    OneSignal.initialize('1d11a4bf-5edc-4fd0-bcd0-aa3c7a6dd92b'); //App ID
    OneSignal.Notifications.requestPermission(true);
    oneSignalNotifications = OneSignal.Notifications;

    addObservers();
    removeClickListeners();
    addClickListeners();
  }

  String? getToken() {
    OneSignalPushSubscription data = OneSignal.User.pushSubscription;
    String? token = data.id;

    if (token != null) {
      PrefUtils().saveStr(WorkplaceNotificationConst.deviceTokenC, token);
    }

    return token;
  }

  Future<String?> refreshToken()  async {
    try {
      await OneSignal.User.pushSubscription.optOut();
      await Future.delayed(const Duration(seconds: 2));
      OneSignal.initialize('1d11a4bf-5edc-4fd0-bcd0-aa3c7a6dd92b');
      await Future.delayed(const Duration(seconds: 1));
      await OneSignal.User.pushSubscription.optIn();
      return getToken();
    } catch (e) {
      print(e);
    }
    return "";
  }

  void removeClickListeners() {
    try {
      OneSignal.Notifications.removeClickListener(clickListener);
      OneSignal.Notifications.removeForegroundWillDisplayListener(foregroundListener);
      notificationListenerAdded = false;
    } catch (e) {
      debugPrint("$e");
    }
  }

  void addClickListeners() {
    if (notificationListenerAdded) return;

    oneSignalNotifications.addClickListener(clickListener);
    oneSignalNotifications.addForegroundWillDisplayListener(foregroundListener);
    notificationListenerAdded = true;
  }

  void addObservers() {
    OneSignal.User.pushSubscription.addObserver((state) {
      String? token = state.current.id;
      if (token != null) {
        PrefUtils().saveStr(WorkplaceNotificationConst.deviceTokenC, token);
      }
    });

    OneSignal.User.addObserver((state) {
      var userState = state.jsonRepresentation();
      debugPrint('OneSignal user changed: $userState');
    });

    OneSignal.Notifications.addPermissionObserver((state) {
      debugPrint("Has permission ${state.toString()}");
    });
  }

  static void onClick(OSNotificationClickEvent event) {
    if (isNavigating) {
      debugPrint("Navigation already in progress. Skipping...");
      return;
    }

    isNavigating = true;

    try {
      if (event.notification.additionalData != null) {
        if (mContext != null &&
              onClickedNotificationId != event.notification.notificationId) {
          onClickedNotificationId = event.notification.notificationId;
          Map<String, dynamic> data = event.notification.additionalData!;
          String? notificationId = event.notification.notificationId;

          appNavigator.onTapNotification(
              mContext!, data, notificationId: notificationId);
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            redirectOnKilledMode(event);
          });
        }
      }
    } catch (e) {
      debugPrint("Error in onClick: $e");
    } finally {
      isNavigating = false;
    }
  }

  static void onMessageReceived(OSNotificationWillDisplayEvent event) async {
    debugPrint('NOTIFICATION RECEIVED EVENT: $event');

    if (event.notification.additionalData != null) {
      if (mContext != null &&
          onReceivedNotificationId != event.notification.notificationId) {
        onReceivedNotificationId = event.notification.notificationId;
        BlocProvider.of<AppNotificationBloc>(mContext!)
            .add(const OnNotificationReceivedEvent());
      }
    }
  }

  static void markNotificationAsRead({required int msgId}) {
    if (mContext != null) {
      // BlocProvider.of<AppNotificationBloc>(mContext!).add(
      //     MarkNotificationRedirectReadDisplayEvent(
      //         mContext: mContext!, msgId: msgId));
    } else {
      debugPrint("Context is null. Cannot mark notification as read.");
    }
  }

  static void clearNotificationBadgeCount({int? notificationId}) {
    try {
      if (notificationId != null) {
        OneSignal.Notifications.removeNotification(notificationId);
      } else {
        OneSignal.Notifications.clearAll();
      }
    } catch (e) {
      print(e);
    }
  }

  static void redirectOnKilledMode(OSNotificationClickEvent event) {
    Future.delayed(const Duration(seconds: 1), () {
      if (mContext == null) {
        redirectOnKilledMode(event);
        return;
      }

      if (onClickedNotificationId != event.notification.notificationId) {
        Map<String, dynamic> data = event.notification.additionalData!;
        onClickedNotificationId = event.notification.notificationId;
        String? notificationId = event.notification.notificationId;

        appNavigator.onTapNotification(
            mContext!, data, notificationId: notificationId);
      }
    });
  }
}
