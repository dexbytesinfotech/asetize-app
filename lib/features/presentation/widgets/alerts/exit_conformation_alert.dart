import 'package:asetize/imports.dart';

class ExitConformationAlert {
  ExitConformationAlert(
      {Key? key,
      required BuildContext context,
      String extraMsg = "",
      required msg,
      noCallback,
      required callback}) {
    alertPopUp(context, extraMsg, msg, noCallback, callback);
  }
  alertPopUp(BuildContext context, extraMsg, msg, noCallback, callback) {
    String yesText = "YES";
    String noText = "NO";

    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context1) {
//            mContext = context1;
          return MediaQuery(
            data: AppDimens().setTextScaleFactor(context: context),
            child: AlertDialog(
              backgroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)), //this r
              content: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  // shrinkWrap: true,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(
                            top: AppDimens().verticalMarginPadding(value: 20),
                            bottom:
                                AppDimens().verticalMarginPadding(value: 0)),
                        child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              msg ?? "",
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textBlueColor,
                              ),
                            ))),
                    (extraMsg != null && extraMsg != "")
                        ? Padding(
                            padding: EdgeInsets.only(
                                top:
                                    AppDimens().verticalMarginPadding(value: 5),
                                bottom: AppDimens()
                                    .verticalMarginPadding(value: 0)),
                            child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  extraMsg ?? "",
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontFamily: AppFonts().defaultFont,
                                      color: AppColors.textBlueColor,
                                      fontSize: AppDimens().fontSize(value: 16),
                                      fontWeight: FontWeight.w500),
                                )))
                        : Container(),
                    Padding(
                        padding: EdgeInsets.only(
                            top: AppDimens().verticalMarginPadding(value: 20),
                            left:
                                AppDimens().horizontalMarginPadding(value: 15),
                            right:
                                AppDimens().horizontalMarginPadding(value: 15),
                            bottom:
                                AppDimens().verticalMarginPadding(value: 20)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                if (noCallback != null) {
                                  noCallback(context1);
                                } else {
                                  Navigator.pop(context1);
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                  right: AppDimens()
                                      .horizontalMarginPadding(value: 10),
                                ),
                                width: AppDimens().widthDynamic(value: 90),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                    border: Border.all(
                                      width: 1,
                                      color: AppColors.textBlueColor,
                                    ),
                                    color: Colors.transparent),
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                      (noText != '')
                                          ? noText
                                          : AppString.noText,
                                      style: TextStyle(
                                        fontFamily: AppFonts().defaultFont,
                                        fontWeight: FontWeight.w500,
                                        fontSize:
                                            AppDimens().fontSize(value: 15),
                                        color: AppColors.textBlueColor,
                                      )),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (callback != null) {
                                  callback(context1);
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                  left: AppDimens()
                                      .horizontalMarginPadding(value: 10),
                                ),
                                width: AppDimens().widthDynamic(value: 90),
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  color: AppColors.textBlueColor,
                                ),
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                      (yesText != '')
                                          ? yesText
                                          : AppString.yesText,
                                      style: TextStyle(
                                          fontFamily: AppFonts().defaultFont,
                                          fontWeight: FontWeight.w500,
                                          fontSize:
                                              AppDimens().fontSize(value: 15),
                                          color: AppColors.white)),
                                ),
                              ),
                            ),
                          ],
                        ))
                  ],
                ),
              ),
              contentPadding: const EdgeInsets.all(0.0),
            ),
          );
          // }
        });
  }
}
