import 'package:asetize/imports.dart';

class AlreadyHaveAccountRow extends StatelessWidget {
  final String? leftText;
  final String? rightText;
  final String subtitleText;
  final TextStyle leftTextStyle;
  final TextStyle rightTextStyle;
  final String? imageIcon;
  final double borderRadius;
  final Color color;
  final FontWeight fontWeight;
  final EdgeInsetsGeometry? margin;
  final signInCallBack;
  final subtitleTextCallBack;
  final EdgeInsetsGeometry? padding;
  final bool isSubtitleTextVisible;
  final bool isRightTextVisible;

  const AlreadyHaveAccountRow({
    Key? key,
    this.leftText,
    this.rightText,
    this.leftTextStyle = const TextStyle(
        fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white),
    this.rightTextStyle = const TextStyle(
        fontSize: 15.5, fontWeight: FontWeight.w600, color: Color(0xffFE9654)),
    this.borderRadius = 40,
    this.color = Colors.black,
    this.fontWeight = FontWeight.w800,
    this.imageIcon,
    this.margin,
    this.padding,
    this.signInCallBack,
    this.subtitleText = "",
    this.isSubtitleTextVisible = false,
    this.subtitleTextCallBack,
    this.isRightTextVisible = true,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 60,
        margin: margin ??
            const EdgeInsets.symmetric(
              horizontal: 0,
            ),
        padding: padding ??
            const EdgeInsets.only(
              left: 0,
            ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    leftText ??
                        "${AppString.trans(context, AppString.didntReceiveCode)}?",
                    style: leftTextStyle),
                SizedBox(
                  height: isSubtitleTextVisible ? 6 : 0,
                ),
                Visibility(
                  visible: isSubtitleTextVisible,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        subtitleTextCallBack?.call();
                      },
                      child: Row(
                        children: [
                          Text(subtitleText, style: rightTextStyle),
                          const SizedBox(
                            width: 5,
                          ),
                          /* iconApps.iconImage(
                            imageUrl: iconApps.resendIcon,
                            imageColor: Colors.black,
                            iconSize: Size(18, 18),//imageColor:Colors.white
                          ),*/
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              width: 1,
            ),
            Material(
              color: Colors.transparent,
              child: Visibility(
                visible: isRightTextVisible,
                child: InkWell(
                  onTap: () {
                    signInCallBack?.call();
                    print("click on sign in");
                  },
                  child: Text(
                      rightText ?? AppString.trans(context, AppString.signIn),
                      style: rightTextStyle),
                ),
              ),
            )
          ],
        ));
  }
}
