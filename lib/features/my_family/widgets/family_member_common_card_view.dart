import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/util/app_permission.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../../imports.dart';
import '../../../widgets/common_card_view.dart';

class FamilyMemberCommonCardView extends StatelessWidget {
  final String? imageUrl;
  final String? userName;
  final String? jobTitle;
  final String? category;
  final Color? cardColor;
  final bool? isPublicContact;
  final bool isShowImageProfile;
  final bool isShowCallButton;
  bool? isPrimary;
  bool isShowCategory;
  final void Function()? onLongPress;
  final void Function()? onTab;
  final void Function()? onTabSetPrimary;
  final EdgeInsetsGeometry? margin;
   FamilyMemberCommonCardView({
    Key? key,
    this.imageUrl ,
    this.cardColor=  Colors.white,
    this.userName,
     this.category,
    this.jobTitle,
     this.isPublicContact,
    this.onLongPress,
    this.onTab,
     this.onTabSetPrimary,
    this.isPrimary,
    this.margin,
     this.isShowImageProfile = true,
     this.isShowCategory = false,
     this.isShowCallButton = false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onLongPress: onLongPress,
      onTap: onTab,
      child: CommonCardView(
        cardColor: cardColor ?? Colors.white,
        margin: margin ??  const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, ),
                child: Row(
                  children: [
                    isShowImageProfile?
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
                    ): SizedBox(),
                    const SizedBox(width: 15),
                    Expanded( // Prevents overflow issues
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Row(
                                  children: [
                                    Text(
                                      userName ?? "",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: appTextStyle.appTitleStyle2(),
                                    ),
                                    if(isShowCallButton)
                                    GestureDetector(
                                      onTap: () async {
                                        if ((jobTitle ?? '').isNotEmpty) {
                                          final phone = jobTitle!.startsWith('+91')
                                              ? jobTitle!
                                              : '+91${jobTitle!}';
                                          projectUtil.makingPhoneCall(phoneNumber: phone);
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 1),
                                        margin: const EdgeInsets.only(left: 15),
                                        decoration: BoxDecoration(
                                          border: Border.all(width: 1, color: AppColors.appBlueColor),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          'Call',
                                          style: appTextStyle.appSubTitleStyle2(
                                            color: AppColors.appBlueColor,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              if (isPrimary == true)
                               Container(
                                 padding: EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                                 decoration: BoxDecoration(
                                   color: AppColors.appBlueColor,
                                   borderRadius: BorderRadius.circular(10)
                                 ),
                                child:const Text(
                                  'Primary',
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              if (isShowCategory == true)
                              Container(
                                 padding: EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                                 decoration: BoxDecoration(
                                   color: AppColors.buttonBgColor3,
                                   borderRadius: BorderRadius.circular(10)
                                 ),
                                child: Text(
                                  category ?? '',
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              )


                            ]
                          ),
                          Row(
                            children: [

                              Text(
                                jobTitle ?? "",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: appTextStyle.appSubTitleStyle2(),
                              ),
                              const SizedBox(width: 5),
                              isPublicContact?? false? const SizedBox():
                              SvgPicture.asset('assets/images/disable_contact.svg',
                                height: 15,
                                width: 15,
                                color: Colors.red,
                              )




                            ],
                          ),
                        ],
                      ),
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