import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:asetize/widgets/common_card_view.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../../imports.dart';

class AmenityTypeWidget extends StatelessWidget {
  final String? imageUrl;
  final String? amenityName;
  final String? description;
  final Color? cardColor;
  final void Function()? onTab;
  final EdgeInsetsGeometry? margin;
  final double horizontalMargin; // ✅ Added this line
  final double horizontalPadding; // ✅ Added this line
  final double horizontalImagePadding; // ✅ Added this line
  final bool isShowIcon;

  const AmenityTypeWidget({
    Key? key,
    this.imageUrl,
    this.cardColor = Colors.white,
    this.amenityName,
    this.description,
    this.onTab,
    this.margin,
    this.isShowIcon =  true,
    this.horizontalMargin = 9.0,
    this.horizontalPadding = 9.0, // ✅ Default padding value
    this.horizontalImagePadding = 0, // ✅ Default padding value
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double imageHeight = 45;

    return InkWell(
      onTap: onTab,
      child: CommonCardView(
        cardColor: cardColor ?? Colors.white,
        margin: margin ??  EdgeInsets.symmetric(horizontal: horizontalMargin, vertical: 6),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 0,
            horizontal: horizontalPadding, // ✅ Used here
          ),
          child: Stack(
            children: [
              Padding(
                padding:  EdgeInsets.symmetric(vertical: 10, horizontal:horizontalImagePadding ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        placeholder: (context, url) => const ImageLoader(),
                        errorWidget: (context, url, error) => SizedBox(
                          height: imageHeight,
                          width: imageHeight,
                          child: Image.asset(
                            "assets/images/profile_avatar.png",
                            height: imageHeight,
                            width: imageHeight,
                            fit: BoxFit.cover,
                          ),
                        ),
                        height: imageHeight,
                        width: imageHeight,
                        imageUrl: imageUrl ?? "",
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            amenityName ?? "",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: appTextStyle.appTitleStyle2(),
                          ),
                          Text(
                            description ?? "",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: appTextStyle.appSubTitleStyle2(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 15),
                    if (isShowIcon)
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 15,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
