import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/util/app_theme/text_style.dart';
import '../../../imports.dart';

class TeamsGridViewWidget extends StatelessWidget {
  final String? imageUrl;
  final String? userName;
  final String? jobTitle;
  final onClickCallBack;

  const TeamsGridViewWidget({
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50), //18
              child: CachedNetworkImage(
                placeholder: (context, url) => const ImageLoader(),
                errorWidget: (context, url, error) => SizedBox(
                  height: 70,
                  width: 70,
                  child: Image.asset(
                    "assets/images/profile_avatar.png",
                    height: 70,
                    width: 70,
                    fit: BoxFit.cover,
                  ),
                ),
                height: 70,
                width: 70,
                imageUrl: imageUrl ??
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTPhFl6zHkAHKFN0kNZl0jhZLfgeYYy2WzbezLIKbdF0eBJgVBP0ZmkVClZuU61_fF1bSc&usqp=CAU",
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Flexible(
              child: Text(
                userName ?? "",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                textAlign: TextAlign.center,
                style: appTextStyle.appTitleStyle(
                    fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(
              height: 1,
            ),
            Text(
              jobTitle ?? "",
              textAlign: TextAlign.center,
              maxLines: 3,
              style: appTextStyle.appSubTitleStyle(fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
