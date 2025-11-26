import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:asetize/features/presentation/presentation.dart';
import 'package:asetize/widgets/common_card_view.dart';

import '../../../core/util/animation/slide_left_route.dart';
import '../../../core/util/app_theme/text_style.dart';

class ComplaintCard extends StatelessWidget {
  final String userName;
  final String userImageUrl;
  final String complaintImageUrl;
  final String date;
  final String flatNumber;
  final String complaintType;
  final String message;
  final String title;
  final String likeCount;
  final cardClickCallBack;

  const ComplaintCard({super.key,
    required this.userName,
    required this.userImageUrl,
    required this.complaintImageUrl,
    required this.date,
    required this.flatNumber,
    required this.complaintType,
    required this.likeCount,
    required this.cardClickCallBack,
    required this.message,
    required this.title,});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        cardClickCallBack.call();
      },
      child: CommonCardView(
        margin: const EdgeInsets.only(left: 12,right: 15,top: 10,bottom: 10),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row: User Info
              Row(
                children: [
                   CircularImage(
                    image: userImageUrl,
                    name:  '',
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:  [
                        Text(
                          userName,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black
                          ),
                        ),
                        Text(
                          date,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),
              Text('$title $flatNumber',style:appTextStyle.appTitleStyle()),

              Divider(height: 20, color: Colors.grey.shade300),
              // Complaint Type and Image

              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message ,
                    style: appTextStyle.appSubTitleStyle2(fontSize: 13),
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 10),
                  if(complaintImageUrl.isNotEmpty)GestureDetector(
                    onTap: ()
                    {
                      Navigator.of(context).push(FadeRoute(
                          widget: FullPhotoView(
                            title: '',
                            profileImgUrl:complaintImageUrl ,
                          )));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        placeholder: (context, url) => const ImageLoader(),
                        imageUrl: complaintImageUrl, //'https://www.houseyog.com/blog/wp-content/uploads/test-the-colours.jpg',
                        height: 60,
                        width: 60,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => SizedBox(
                          height: 60,
                          width: 60,
                          child: Image.asset(
                            "https://www.houseyog.com/blog/wp-content/uploads/test-the-colours.jpg",
                            height: 60,
                            width: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
           /*   Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if(complaintImageUrl.isNotEmpty)ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      placeholder: (context, url) => const ImageLoader(),
                      imageUrl: complaintImageUrl, //'https://www.houseyog.com/blog/wp-content/uploads/test-the-colours.jpg',
                      height: 140,
                      width: 110,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => SizedBox(
                        height: 140,
                        width: 110,
                        child: Image.asset(
                          "https://www.houseyog.com/blog/wp-content/uploads/test-the-colours.jpg",
                          height: 140,
                          width: 110,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  complaintImageUrl.isNotEmpty ? const SizedBox(width: 10) : const SizedBox(width:0),
                  Flexible(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:  [
                          Text('$title $flatNumber',style:  const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),),
                          const SizedBox(height: 4),
                          Text(
                            message ,
                            style: const TextStyle(fontSize: 14,color: Colors.black),
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.justify,
                          ),
                        ]),
                  ),

                ],
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
