import 'package:cached_network_image/cached_network_image.dart';
import 'package:asetize/widgets/common_card_view.dart';

import '../../../core/util/app_permission.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../../imports.dart';

class MemberCardWidget extends StatelessWidget {
  final String? imageUrl;
  final String? title;
  final String? subTitle;
  final VoidCallback? onClickCallBack;
  final void Function()? onLongPress;
  final void Function()? onTap;
  const MemberCardWidget({super.key, this.imageUrl, this.title,this.subTitle, this.onLongPress, this.onClickCallBack, this.onTap });

  @override
  Widget build(BuildContext context) {

    return  InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: CommonCardView(
        elevation: 0.3,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 15),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: CachedNetworkImage(
                  placeholder: (context, url) => const ImageLoader(),
                  errorWidget: (context, url, error) => SizedBox(
                    height: 40,
                    width: 40,
                    child: Image.asset(
                      "assets/images/profile_avatar.png",
                      height: 40,
                      width: 40,
                      fit: BoxFit.cover,
                    ),
                  ),
                  height: 40,
                  width: 40,
                  imageUrl: imageUrl ??
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTPhFl6zHkAHKFN0kNZl0jhZLfgeYYy2WzbezLIKbdF0eBJgVBP0ZmkVClZuU61_fF1bSc&usqp=CAU",
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 15),
              Expanded( // Prevents overflow issues
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title ?? "",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: appTextStyle.appTitleStyle2(),
                    ),
                    Text(
                      subTitle ?? "",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: appTextStyle.appSubTitleStyle2(),
                    ),
                  ],
                ),
              ),
              if (AppPermission.instance.canPermission(AppString.managerVehicleAdd, context: context))
                InkWell(
                  onTap: (){
                    onClickCallBack?.call();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 3),
                    child: SvgPicture.asset(
                      'assets/images/new-car.svg',
                      height: 28,
                      width: 28,
                      color: Colors.black87,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );

  }
}
