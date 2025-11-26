import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../core/util/app_theme/app_style.dart';
import 'image_loader.dart';

class CommitteeCardWidget extends StatelessWidget {
  final String? imageUrl;
  final String? userName;
  final String? jobTitle;
  final String? shortDescription;
  final Function()? onClickCallBack;

  const CommitteeCardWidget({
    Key? key,
    this.imageUrl,
    this.userName,
    this.jobTitle,
    this.onClickCallBack,
    this.shortDescription,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClickCallBack,
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.only(left: 2,right: 4,top: 5,bottom: 5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 1.5,
        child:  Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: CachedNetworkImage(
                  placeholder: (context, url) => const ImageLoader(),
                  errorWidget: (context, url, error) => Image.asset(
                    "assets/images/profile_avatar.png",
                    height: 60,
                    width: 60,
                    fit: BoxFit.cover,
                  ),
                  imageUrl: imageUrl ??
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTPhFl6zHkAHKFN0kNZl0jhZLfgeYYy2WzbezLIKbdF0eBJgVBP0ZmkVClZuU61_fF1bSc&usqp=CAU",
                  height: 60,
                  width: 60,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 10,),
                  Text(userName?.trim() ?? "shweta",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: appStyles.userNameTextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 0),
                  Text(shortDescription?.trim() ?? "N/A",
                    textAlign: TextAlign.center,
                    style: appStyles.userJobTitleTextStyle(fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10,),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
