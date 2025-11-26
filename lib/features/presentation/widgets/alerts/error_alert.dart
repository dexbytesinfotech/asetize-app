import 'package:asetize/imports.dart';

class ErrorAlert {
  ErrorAlert(
      {Key? key,
      required BuildContext context,
      String alertTitle = "",
      bool isItForInternet = false,
      @required message,
      @required callBackYes}) {
    errorDialog(context, isItForInternet, alertTitle, message, callBackYes);
  }
  alertPopUp(BuildContext context, success, msg, callback) {
    return showDialog(
        context: context,
        builder: (context1) {
          //mContext = context1;
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this r
            content: GestureDetector(
              onTap: () => callback(context1),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  /*gradient: new LinearGradient(
                        colors: AppColors().gredientColor,
                        begin: const FractionalOffset(0.2, 1.0),
                        end: const FractionalOffset(0.0, 0.75),
                        stops: [0.0, 0.9],
                        tileMode: TileMode.clamp)*/
                ),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(
                            top: AppDimens().verticalMarginPadding(value: 20),
                            bottom:
                                AppDimens().verticalMarginPadding(value: 0)),
                        child: Align(
                          alignment: Alignment.center,
                          child: SvgPicture.asset(
                              success
                                  ? "assets/images/home/payment_info/success_right.svg"
                                  : "assets/images/home/payment_info/error.svg",
                              width: AppDimens().widthDynamic(value: 87),
                              height: AppDimens().widthDynamic(value: 87),
                              fit: BoxFit.scaleDown),
                        )),
                    Padding(
                        padding: EdgeInsets.only(
                            top: AppDimens().verticalMarginPadding(value: 20),
                            left:
                                AppDimens().horizontalMarginPadding(value: 15),
                            right:
                                AppDimens().horizontalMarginPadding(value: 15),
                            bottom:
                                AppDimens().verticalMarginPadding(value: 20)),
                        child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              msg ?? "",
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontFamily: AppFonts().defaultFont,
                                  color: AppColors.textSubHeadingColor,
                                  fontSize: AppDimens().fontSize(value: 20),
                                  fontWeight: FontWeight.w600),
                            )))
                  ],
                ),
              ),
            ),
            contentPadding: const EdgeInsets.all(0.0),
          );
          // }
        });
  }

  Future<bool?> errorDialog(BuildContext? context1, bool? isItForInternet,
      String? alertTitle, String? message, callBackYes) {
    return showDialog(
        context: context1!,
        barrierDismissible: !isItForInternet!,
        builder: (context1) {
          //mContext = context1;
          return AlertDialog(
            title: Text(alertTitle!,
                style: const TextStyle(
                    color: AppColors.lightBlack, fontSize: 0.0)),
            content: Text(
              message ?? "",
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black),
            ),
            contentPadding: const EdgeInsets.only(left: 20, right: 20, top: 10),
            actions: <Widget>[
              TextButton(
                child: const Text("OK", style: TextStyle(fontSize: 18.0)),
                onPressed: () {
                  if (callBackYes != null) {
                    callBackYes(context1);
                  } else {
                    Navigator.pop(context1);
                  }
                },
              )
            ],
          );
        });
  }
}
