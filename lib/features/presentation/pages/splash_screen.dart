import 'package:local_auth/local_auth.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_handler/share_handler.dart';
import 'package:asetize/features/presentation/widgets/animated_splash_screen.dart';
import 'package:asetize/imports.dart';
import 'package:asetize/init.dart';
import '../../new_sign_up/pages/new_login_with_email_screen.dart';

class SplashScreen extends StatefulWidget {
  final bool isLoggedIn;
  const SplashScreen({Key? key, this.isLoggedIn = false}) : super(key: key);
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  final LocalAuthentication auth = LocalAuthentication();///
  late DateTime startTime;
  bool splashTimeEnded = false;
  bool initFunctionEnded = false;
  static InitVar? initVar;
  late MainAppBloc mainAppBloc;
  late UserProfileBloc userProfileBloc;
  SharedMedia? media;

  @override
  void initState() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      PrefUtils().saveStr(WorkplaceNotificationConst.appVersionVersionC,packageInfo.version);
    });
    mainAppBloc = BlocProvider.of<MainAppBloc>(context);
    userProfileBloc = BlocProvider.of<UserProfileBloc>(context);
    mainAppBloc.add(SystemSettingEvent(mContext: context));

    super.initState();

  }

  Future<String> initializeSettings(BuildContext context) async {
    /// Mobile device configuration
    await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp],
    );
    /// Removing stored badge count
    projectUtil.removeBadge();

    projectUtil.logEventTime("SplashSc  reen Build Started");


    initVar = await workplaceInit(context: context);
    bool isEnabled = await PrefUtils.isFingerprintEnabled();
    if (isEnabled) {
      int attempts = 0;
      while (attempts < 3) {
        bool authenticated = await PrefUtils.authenticateWithBiometrics();
        if (authenticated) {
          return "/dashBoard"; // If authenticated, move to dashboard
        } else {
          attempts++;
        }
      }
      return "/login"; // Redirect to login if authentication fails
    } else {
      if (initVar != null) {
        if ((initVar!.isNetConnected == false && initVar!.token.isNotEmpty) ||  (initVar!.isNetConnected == true && initVar!.token.isNotEmpty && initVar!.isCompleteProfile==true && initVar!.selectedCompanyId!=null && initVar!.selectedCompanyId!.isNotEmpty)) {

          mainAppBloc.add(UpdateTokenEvent(mContext : context));
          return "/dashBoard"; // If logged in, go to dashboard (No further checks)
        }
        else if (initVar!.token.isEmpty) {
          return "/login";
        }
        else if (initVar!.isCompleteProfile==false) {
          return "/login/profileSetup"; // If profile is complete, go to search setup
        }
        else if (initVar!.selectedCompanyId==null || initVar!.selectedCompanyId!.isEmpty) {
          return "/login/searchYourSocietyFo  rm"; // If pending, go to pending screen
        }
        else {
          return "/login"; // Default redirect if no conditions match
        }
      }
      return "/login"; // Default redirect if no conditions match
    }

  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,//const Color(0xFF01012c),
        body: AnimatedSplashScreen(
            duration: 1500,
            splash: Image.asset(WorkplaceIcons.appLogoImage,),
            backgroundView: const Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: SizedBox(
                    ))),
            nextScreen: const NewLoginWithEmail(),
            splashIconSize: MediaQuery.of(context).size.shortestSide * 0.6,
            animationDuration: const Duration(milliseconds: 500),
            splashTransition: SplashTransition.fadeScale,
            function: () => initializeSettings(context),
            type: SplashType.backgroundScreenReturn,
            backgroundColor: Colors.white, //Color(0xFF01012c)
        ));
  }
}
