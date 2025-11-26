import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'image_loader.dart';

class BusinessListViewWidget extends StatelessWidget {
  final String? imageUrl;
  final String? userName;
  final String? jobTitle;
  final Function? onClickCallBack;

  const BusinessListViewWidget({
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
        onTap: () {
            onClickCallBack!.call();

        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 3,
                blurRadius: 5,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
            border: Border.all(color: Colors.grey.shade300, width: 1.5),
          ),
          // padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 20,),
              ClipRRect(
                // borderRadius: BorderRadius.circular(50), //18
                borderRadius: BorderRadius.circular(50),
                child: CachedNetworkImage(
                  placeholder: (context, url) => const ImageLoader(),
                  errorWidget: (context, url, error) => SizedBox(
                    height: 80,
                    width: 80,
                    child: Image.asset(
                      "assets/images/profile_avatar.png",
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  height: 80,
                  width: 80,
                  imageUrl: imageUrl ??
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTPhFl6zHkAHKFN0kNZl0jhZLfgeYYy2WzbezLIKbdF0eBJgVBP0ZmkVClZuU61_fF1bSc&usqp=CAU",
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 5,),
              // const SizedBox(height: 12),
              Text(
                userName ?? "Mohit Panchal",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              // const SizedBox(height: 6),
              // Text(
              //   jobTitle ?? "Jr. Flutter Developer",
              //   style: TextStyle(
              //     fontSize: 12,
              //     color: Colors.grey.shade600,
              //   ),
              //   textAlign: TextAlign.center,
              //   overflow: TextOverflow.ellipsis,
              //   maxLines: 1,
              // ),
              SizedBox(height: 0,),
            ],
          ),
        ),
      ),
    );
  }
}
