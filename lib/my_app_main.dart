import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:asetize/features/add_transaction_receipt/bloc/add_transaction_receipt_bloc.dart';
import 'package:asetize/features/presentation/bloc/business_bloc/business_bloc.dart';
import 'package:asetize/features/tag_text_field/bloc/tag_text_field_bloc.dart';
import 'package:asetize/imports.dart';
import 'core/util/app_navigator/app_navigator.dart';
import 'default_error_screen.dart';
import 'features/about_us/bloc/about_bloc/about_bloc.dart';
import 'features/account_books/bloc/account_book_bloc.dart';
import 'features/approval_pending_screen/bloc/approval_pending_bloc.dart';
import 'features/add_vehicle_for_manager/bloc/add_vehicle_manager_bloc.dart';
import 'features/assets_management/bloc/assets_management_bloc.dart';
import 'features/booking/bloc/booking_bloc.dart';
import 'features/commitee_member_tab/bloc/commitee_member_bloc.dart';
import 'features/complaints/bloc/complaint_bloc/complaint_bloc.dart';
import 'features/complaints/bloc/house_block_bloc/house_block_bloc.dart';
import 'features/create_post/bloc/create_post_bloc.dart';
import 'features/faq/bloc/faq_bloc/faq_bloc.dart';
import 'features/find_helper/bloc/find_helper_bloc.dart';
import 'features/follow_up/bloc/follow_up_bloc.dart';
import 'features/home_screen/bloc/home_new_bloc.dart';
import 'features/login/bloc/sign_in_bloc/sign_in_bloc.dart';
import 'features/member/bloc/team_member/team_member_bloc.dart';
import 'features/my_unit/bloc/my_unit_bloc.dart';
import 'features/my_vehicle/bloc/my_vehicle_bloc.dart';
import 'features/my_visitor/bloc/my_visitor_bloc.dart';
import 'features/new_sign_up/bloc/new_signup_bloc.dart';
import 'features/noc_list/bloc/noc_request_bloc.dart';
import 'features/notificaion/bloc/notification_bloc/app_notification_bloc.dart';
import 'features/otp/bloc/otp_bloc.dart';
import 'features/pets/bloc/pet_bloc.dart';
import 'features/policy/bloc/policy_bloc/policy_bloc.dart';
import 'features/sign_up/bloc/sign_up_bloc.dart';
import 'features/vehicle_identification_form/bloc/vehicle_identification_form_bloc.dart';

class MyAppFlutterMain extends StatefulWidget {
  final Locale? locale;

  const MyAppFlutterMain({
    Key? key,
    this.locale,
  }) : super(key: key);

  static void setLocale(BuildContext? context, Locale newLocale) async {
    _MyAppState? state = context!.findAncestorStateOfType<_MyAppState>();
    state!.changeLanguage(newLocale);
  }

  @override
  State createState() => _MyAppState();
}

class _MyAppState extends State<MyAppFlutterMain> with WidgetsBindingObserver {
  bool isCheckedLang = false;
  bool isInit = false;
  Locale _locale = const Locale('en', 'US');
  final Locale _localeDefult = const Locale('en', 'US');
  String? jsonString;

  _MyAppState() {
    getLanguage();
  }

  var supportedLocales1 = const [
    Locale('en', 'US'),
    Locale('ko', 'KR'),
  ];

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.detached ||
        state == AppLifecycleState.inactive) {}
  }

  @override
  void initState() {
    getHomeExpansionData();
    projectUtil.statusBarColor(
        statusBarColor: AppColors.appStatusBarColor,
        isAppStatusDarkBrightness: false);
    try {
      //  versionCheck(context);
    } catch (e) {
      debugPrint("$e");
    }
    super.initState();
  }

  changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
      String languageCode = locale.languageCode;
      String? countryCode = locale.countryCode;
      var localDetails = {
        "languageCode": languageCode,
        "countryCode": countryCode
      };

      String localDetailsStr = jsonEncode(localDetails);
      PrefUtils()
          .saveStr(WorkplaceNotificationConst.languageCodeC, localDetailsStr);
    });
  }

  getLanguage() async {
    PrefUtils()
        .readBool(WorkplaceNotificationConst.isNotFirstTime)
        .then((value) {
      if (value == false) {
        _locale = _localeDefult;
        PrefUtils().saveStr(WorkplaceNotificationConst.selectedLanguageC,
            WorkplaceNotificationConst.selectedLanguageKoreanC);
        changeLanguage(_locale);
        PrefUtils().saveBool(WorkplaceNotificationConst.isNotFirstTime, true);
      } else {
        String languageCode, countryCode;
        PrefUtils()
            .readStr(WorkplaceNotificationConst.languageCodeC)
            .then((value) {
          if (value != '') {
            Map localDetails = json.decode(value);
            languageCode = localDetails["languageCode"];
            countryCode = localDetails["countryCode"];
            if (languageCode != '' && countryCode != '') {
              setState(() {
                _locale = Locale(languageCode, countryCode);
              });
            } else {
              setState(() {
                _locale = _localeDefult;
              });
            }
          }
        });
      }
    });
  }

  Future<void> getHomeExpansionData() async {
    await PrefUtils().readStr("home_options").then((value) {
      if (value.isNotEmpty) {
        try {
          MainAppBloc.homeOptions.addAll(jsonDecode(value));
          print(MainAppBloc.homeOptions);
        } catch (e) {
          debugPrint('$e');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.locale != null && !isInit) {
      setState(() {
        isInit = true;
        _locale = widget.locale!;
      });
    }
    projectUtil.statusBarColor();
    ScreenUtil.init(context);
    return MultiBlocProvider(
        providers: [
          BlocProvider<MainAppBloc>(
            create: (context) => MainAppBloc(MainAppDataProvider()),
          ),
          BlocProvider<SignInBloc>(
            create: (context) => SignInBloc(),
          ),
          BlocProvider<FaqBloc>(
            create: (context) => FaqBloc(),
          ),
          BlocProvider<AppNotificationBloc>(
            create: (context) => AppNotificationBloc(),
          ),
          BlocProvider<NewSignupBloc>(
            create: (context) => NewSignupBloc(),
          ),
          BlocProvider<MyUnitBloc>(
            create: (context) => MyUnitBloc(),
          ),
          BlocProvider<NocRequestBloc>(
            create: (context) => NocRequestBloc(),
          ),
          BlocProvider<AddVehicleManagerBloc>(
            create: (context) => AddVehicleManagerBloc(),
          ),
          BlocProvider<VehicleFormBloc>(
            create: (context) => VehicleFormBloc(),
          ),
          BlocProvider<FindHelperBloc>(
            create: (context) => FindHelperBloc(),
          ),
          BlocProvider<MyVehicleListBloc>(
            create: (context) => MyVehicleListBloc(),
          ),
          BlocProvider<AddTransactionReceiptBloc>(
            create: (context) => AddTransactionReceiptBloc(),
          ),
          BlocProvider<UserProfileBloc>(
            create: (context) => UserProfileBloc(),
          ),
          BlocProvider<TeamMemberBloc>(
            create: (context) => TeamMemberBloc(),
          ),

          BlocProvider<AssetsManagementBloc>(
            create: (context) => AssetsManagementBloc(),
          ),
          BlocProvider<HomeBloc>(
            create: (context) => HomeBloc(),
          ),
          BlocProvider<BusinessBloc>(
            create: (context) => BusinessBloc(),
          ),
          BlocProvider<FollowUpBloc>(
            create: (context) => FollowUpBloc(),
          ),
          BlocProvider<HomeNewBloc>(
            create: (context) => HomeNewBloc(),
          ),
          BlocProvider<WorkplaceNetworkBloc>(
              create: (context) => WorkplaceNetworkBloc()),
          BlocProvider<AboutBloc>(create: (context) => AboutBloc()),
          BlocProvider<FeedBloc>(
              create: (context) => FeedBloc(FeedsDataProvider())),
          BlocProvider<PolicyBloc>(create: (context) => PolicyBloc()),
          BlocProvider<CreatePostBloc>(
              create: (context) => CreatePostBloc(CreatePostDataProvider())),
          BlocProvider<SignUpBloc>(create: (context) => SignUpBloc()),
          BlocProvider<OtpBloc>(create: (context) => OtpBloc()),
          BlocProvider<CommitteeMemberBloc>(
              create: (context) => CommitteeMemberBloc()),
          BlocProvider<TagTextFieldBloc>(
              create: (context) =>
                  TagTextFieldBloc(TagTextFieldDataProvider())),
          BlocProvider<ComplaintBloc>(create: (context) => ComplaintBloc()),
          BlocProvider<HouseBlockBloc>(create: (context) => HouseBlockBloc()),
          BlocProvider<AccountBookBloc>(create: (context) => AccountBookBloc()),
          BlocProvider<ApprovalPendingBloc>(
              create: (context) => ApprovalPendingBloc()),
          BlocProvider<PetBloc>(create: (context) => PetBloc()),
          BlocProvider<BookingBloc>(create: (context) => BookingBloc()),
        ],
        child: MaterialApp.router(
            builder: (context,child){
              ErrorWidget.builder = (FlutterErrorDetails errorDetails){
                return CustomErrorWidget(errorDetails:errorDetails);
              };
              return child!;
            },
            key: appNavigator.navigatorKey,
            debugShowCheckedModeBanner: false,
            title: 'Base App',
            // List all of the app's supported locales here
            supportedLocales: supportedLocales1,
            locale: _locale,
            themeMode: ThemeMode.system,
            theme: MyThemes.lightTheme,
            darkTheme: MyThemes.darkTheme,
            // These delegates make sure that the localization data for the proper language is loaded
            localizationsDelegates: const [
              // THIS CLASS WILL BE ADDED LATER
              // A class which loads the translations from JSON files
              AppLocalizations.delegate,
              // Built-in localization of basic text for Material widgets
              GlobalMaterialLocalizations.delegate,
              // Built-in localization for text direction LTR/RTL
              GlobalWidgetsLocalizations.delegate,
            ],
            // Returns a locale which will be used by the app
            localeResolutionCallback: (locale, supportedLocales) {
              return supportedLocales.first;
            },
            routerConfig: Routes.router));
  }
}
