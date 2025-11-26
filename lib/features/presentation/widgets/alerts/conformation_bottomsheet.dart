import 'package:asetize/imports.dart';

class ConformationBottomSheet extends StatelessWidget {
  final headerTitle;
  final view;
  final sheetDismissCallback;
  final screenWidth;
  ConformationBottomSheet(
      {Key? key,
      this.headerTitle,
      this.view,
      this.sheetDismissCallback,
      this.screenWidth})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    Widget divider() {
      return Container(
        color: AppColors.appTransColor,
        padding: EdgeInsets.only(
            top: AppDimens().verticalMarginPadding(value: 22),
            bottom: AppDimens().verticalMarginPadding(value: 13),
            left: AppDimens().horizontalMarginPadding(value: 0),
            right: AppDimens().verticalMarginPadding(value: 0)),
        width: AppDimens().widthDynamic(value: 120),
        child: Container(
          height: AppDimens().heightDynamic(value: 4),
          decoration: const BoxDecoration(
            color: AppColors.appDividerColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
        ),
      );
    }

    return Container(
      color: AppColors.appTransColor,
      child: Padding(
        padding: const EdgeInsets.only(left: 0, right: 0, top: 0),
        child: Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0)),
          ),
          elevation: 0.0,
          margin: const EdgeInsets.only(left: 0, right: 0, top: 0),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: GestureDetector(
                  onTap: sheetDismissCallback,
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: AppDimens().verticalMarginPadding(value: 0)),
                    child: divider(),
                  ),
                ),
              ),
              Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: EdgeInsets.only(
                        top: (headerTitle != null && headerTitle != "")
                            ? AppDimens().verticalMarginPadding(value: 12)
                            : 0,
                        bottom: AppDimens().verticalMarginPadding(
                            value: 8), // bottom margin also added in divider
                        left: AppDimens().verticalMarginPadding(value: 25),
                        right: AppDimens().verticalMarginPadding(value: 25)),
                    child: Text(
                      headerTitle ?? "",
                      style: TextStyle(
                          fontFamily: AppFonts().mediumFont,
                          fontSize: AppDimens().fontSize(value: 20),
                          color: AppColors.textHeadingColor),
                    ),
                  )),
              view
            ],
          ),
        ),
      ),
    );
  }
}
