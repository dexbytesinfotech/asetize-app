import 'package:asetize/features/feed/widgets/post_profile.dart';
import '../../../../imports.dart';
import '../../../core/util/app_theme/text_style.dart';

class PostHeader extends StatelessWidget {
  final String? profilePhoto;
  final String? postBy;
  final String? jobTitle;
  final String? postPublishedAt;
  final bool? isShowMoreIcon;
  final Function()? onDeleteTap;
  const PostHeader(
      {super.key,
      this.postPublishedAt,
      this.postBy,
      this.profilePhoto,
      this.jobTitle,
      this.isShowMoreIcon = false,
      this.onDeleteTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 18, right: 0, top: 5, bottom: 5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              PostProfile(imageUrl: profilePhoto),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      postBy ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: AppColors.appBlack,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          height: 0.8),
                    ),
                  //  const SizedBox(height: 4),
                    Text(
                      postPublishedAt ?? '',
                      style: appTextStyle.appNormalSmallTextStyle(
                        color: AppColors.appGrey,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(width: 22,),
              (isShowMoreIcon == true)
                  ? PopupMenuButton(
                      color: AppColors.white,
                      iconColor: AppColors.black,
                      elevation: 1,
                      padding: EdgeInsets.zero,
                      itemBuilder: (BuildContext context) {
                        return [
                          PopupMenuItem(
                            onTap: onDeleteTap,
                            value: 1,
                            child:  Row(
                              children: [
                                Text(AppString.delete,
                                    style: appTextStyle.appNormalTextStyle()

                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Icon(
                                  Icons.delete,
                                  color: AppColors.red,
                                ),
                              ],
                            ),
                          ),
                        ];
                      },
                    )
                  : const SizedBox()
            ],
          ),
        ],
      ),
    );
  }
}
