import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:asetize/imports.dart';

class NotificationCardWidget extends StatelessWidget {
  final String? imageUrl;
  final String? userName;
  final String? message;
  final String? timeAgo;
  final Color? color;
  final int? postId;
  final int? leaveId;
  final int? isRead;
  final String? postType;
  final Function()? onClickPost;

  const NotificationCardWidget(
      {Key? key,
      this.imageUrl,
      this.userName,
      this.message,
      this.timeAgo,
      this.color,
      this.postId,
      this.leaveId,
      this.postType,
      this.onClickPost,
      this.isRead})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClickPost,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
        decoration: BoxDecoration(
            color: (isRead == 1) ? Colors.transparent:Colors.white,
            border: Border.all(width: 0.7, color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              height: 35.sp,
              width: 35.sp,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: SvgPicture.asset(
                imageUrl ?? "",
                color: AppColors.appWhite,
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HtmlWidget(userName ?? '',
                        textStyle: appStyles.userNameTextStyle(
                            fontSize: 14.5, fontWeight: FontWeight.w300)),
                    // Text(parse(userName).body!.text.trim(),
                    //     textAlign: TextAlign.start,
                    //     style: appStyles.userNameTextStyle(
                    //         fontSize: 14.5, fontWeight: FontWeight.w300)),
                    const SizedBox(
                      height: 3.5,
                    ),
                    HtmlWidget(
                      message ?? '',
                      textStyle: appStyles.userJobTitleTextStyle(
                        fontSize: 16,
                        texColor: AppColors.textBlueColor,
                      ),
                    ),
                    // Text(
                    //   parse(message).body!.text.trim(),
                    //   style: appStyles.userJobTitleTextStyle(
                    //     fontSize: 16,
                    //     texColor: AppColors.buttonBgColor4,
                    //   ),
                    // ),
                    // GradientText(
                    //   parse(message).body!.text.trim(),
                    //   style: appStyles.userJobTitleTextStyle(fontSize: 16),
                    //   gradient: const LinearGradient(
                    //       begin: Alignment.topLeft,
                    //       end: Alignment.topRight,
                    //       colors: [
                    //         AppColors.buttonBgColor4,
                    //         Color(0xFFFF3294)
                    //       ]),
                    // ),
                    const SizedBox(
                      height: 3.5,
                    ),
                    Text(timeAgo ?? "1 hour ago",
                        textAlign: TextAlign.start,
                        style: appStyles.userJobTitleTextStyle(
                            fontSize: 11.5, texColor: const Color(0xFF757575))),
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            (isRead == 0)
                ? Container(
                    height: 10,
                    width: 10,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.textBlueColor))
                : Container(),
          ],
        ),
      ),
    );
  }
}

