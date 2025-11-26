import 'package:asetize/imports.dart';
import '../../../../core/util/app_theme/text_style.dart';

class CommonAppBar extends StatelessWidget {
  final String? title;
  final double fontSize;
  final Color? textColor;
  final Color? backgroundColor;
  // final Function? navigationCallBack;
  final Color? iconColor;
  final String? icon;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onLeftIconClickCallBack;
  final bool isHideIcon;
  final bool isThen;
  final FontWeight fontWeight;
  final Widget? action;
  final bool isHideBorderLine;
  const CommonAppBar({
    Key? key,
    this.title,
    this.fontSize = 18,
    this.onLeftIconClickCallBack,
    this.textColor,
    this.icon,
    this.backgroundColor,
    this.iconColor,
    this.isHideIcon = false,
    this.isThen = true,
    this.padding,
    this.isHideBorderLine = false,
    this.fontWeight = FontWeight.w800,  this.action,
    // this.navigationCallBack,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor ?? Color(0xFFF5F5F5),//Color(0xFFf9fafb),
      padding: padding ?? const EdgeInsets.only(left: 5.0,bottom: 0),
      child: Material(
        color: Colors.transparent,
        elevation: 0,
        child: Container(
          // decoration: BoxDecoration(
          //     border: Border(
          //         bottom: BorderSide(
          //           width: 1.0,//isHideBorderLine == true?1.00:0.5,
          //           color: Colors.black//isHideBorderLine == true?Colors.black:Colors.black,
          //         ))
          // ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              isHideIcon
                  ? Container()
                  : IconButton(
                      splashRadius: 23,
                onPressed: () {
                  if (onLeftIconClickCallBack != null) {
                    onLeftIconClickCallBack?.call();
                  } else {
                    Navigator.pop(context, isThen);
                  }
                },
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.black,
                      ),
                    ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 1),
                  child: Text(
                    title ?? "",
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: appTextStyle.appBarTitleStyle(),
                  ),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 3,right: 18),
                child: action
              ),

            ],
          ),
        ),
      ),
    );
  }
}

