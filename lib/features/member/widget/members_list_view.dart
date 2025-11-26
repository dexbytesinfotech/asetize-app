import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../../imports.dart';

class MemberListViewWidget extends StatelessWidget {
  final String? imageUrl;
  final String? userName;
  final String? jobTitle;
  final onClickCallBack;

  const MemberListViewWidget({
    Key? key,
    this.imageUrl,
    this.userName,
    this.jobTitle,
    this.onClickCallBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
          splashColor: Colors.grey.shade50,
          highlightColor: Colors.grey.shade50,
          onTap: () {
            onClickCallBack.call();
          },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: CachedNetworkImage(
                placeholder: (context, url) => const ImageLoader(),
                errorWidget: (context, url, error) => SizedBox(
                  height: 50,
                  width: 50,
                  child: Image.asset(
                    "assets/images/profile_avatar.png",
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                height: 50,
                width: 50,
                imageUrl: imageUrl ??
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTPhFl6zHkAHKFN0kNZl0jhZLfgeYYy2WzbezLIKbdF0eBJgVBP0ZmkVClZuU61_fF1bSc&usqp=CAU",
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 15),

            // Wrap Column in Expanded
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    userName ?? "",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textAlign: TextAlign.start,
                    style: appTextStyle.appTitleStyle(),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    jobTitle ?? "",
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: appTextStyle.appSubTitleStyle(),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
