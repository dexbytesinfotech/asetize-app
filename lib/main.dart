import 'package:asetize/imports.dart';
import 'core/util/one_signal_notification/one_signal_notification_handler.dart';
import 'my_app_main.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  OneSignalNotificationsHandler.instance.initPlatformState();

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    print('Flutter error: ${details.exception}');
  };
  return runApp(const MyAppFlutterMain(locale: Locale('en', 'US')));
}

