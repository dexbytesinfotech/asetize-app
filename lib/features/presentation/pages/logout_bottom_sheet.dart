import 'package:asetize/imports.dart';
import 'package:asetize/core/util/app_navigator/app_navigator.dart';

class LogOutBottomSheetScreen extends StatefulWidget {
  const LogOutBottomSheetScreen({
    Key? key,
  }) : super(key: key);
  @override
  State createState() => _LogOutBottomSheetScreenState();
}

class _LogOutBottomSheetScreenState extends State<LogOutBottomSheetScreen> {
  TextEditingController inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    topTextView() {
      return Container(
        color: Colors.transparent,
        margin: const EdgeInsets.only(
          left: 22,
          right: 0,
        ),
        child: Row(
          children: [
            WorkplaceIcons.iconImage(
              imageUrl: WorkplaceIcons.logOutIcon,
              imageColor: Colors.red.shade800,
              iconSize: const Size(24, 24), //imageColor:Colors.white
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              AppString.trans(context, AppString.logoutConfirmation),
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textNormalColor1),
            ),
            const SizedBox(
              width: 8,
            ),

          ],
        ),
      );
    }

    bottomButton() {
      return Container(
        height: 50,
        margin: const EdgeInsets.only(left: 25, right: 25, bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.red.shade700,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                      border: Border.all(
                        width: 1,
                        color: Colors.red.shade700,
                      ),
                      ),
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(AppString.no,
                        style: TextStyle(
                          fontFamily: AppFonts().defaultFont,
                          fontWeight: FontWeight.w500,
                          fontSize: AppDimens().fontSize(value: 15),
                          color: AppColors.white,
                        )),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Flexible(
              child: GestureDetector(
                onTap: () => appNavigator.launchLogOutAndSignUp(context),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                      border: Border.all(
                        width: 1,
                        color: AppColors.appBlueColor,
                      ),
                      color: Colors.transparent),
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(AppString.yes,
                        style: TextStyle(
                          fontFamily: AppFonts().defaultFont,
                          fontWeight: FontWeight.w500,
                          fontSize: AppDimens().fontSize(value: 15),
                          color: AppColors.black,
                        )),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return BottomSheetOnlyCardView(
      cardBackgroundColor: Colors.white,
      topLineShow: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          topTextView(),
          const SizedBox(
            height: 45,
          ),
          bottomButton(),
          const SizedBox(
            height: 25,
          ),
          // SizedBox(
          //   height: AppDimens().heightFullScreen() >= 700 ? 18 : 0,
          // ),
        ],
      ),
    );
  }
}




