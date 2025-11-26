import 'package:asetize/imports.dart';
import '../../../core/util/app_theme/text_style.dart';

class DetailsScreenAppBar extends StatelessWidget {
  final String title;
  final bool isHideIcon;
  final bool isHideLine;
  final Color? appBarColor;
  const DetailsScreenAppBar({
    super.key,
    required this.title,
    this.isHideIcon = false,
    this.isHideLine = false,
    this.appBarColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFF5F5F5),
      padding: const EdgeInsets.only(left: 4, right: 10),
      child: Row(
        children: [
          isHideIcon
              ? Container()
              : IconButton(
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new_sharp,
                    color: Colors.black,
                  )),
          const SizedBox(
            width: 12,
          ),
          Text(title,
              textAlign: TextAlign.center,
            style:appTextStyle.appBarTitleStyle(),

          ),
        ],
      ),
    );
  }
}
