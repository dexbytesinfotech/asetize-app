import 'package:cached_network_image/cached_network_image.dart';
import 'package:asetize/imports.dart';

class EventCardWidget extends StatelessWidget {
  final String? imageUrl;
  final String? userName;
  final String? message;
  final String? date;

  const EventCardWidget(
      {Key? key, this.imageUrl, this.userName, this.message, this.date})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 0.8, color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(6.5)),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6.5),
            child: CachedNetworkImage(
                placeholder: (context, url) => const ImageLoader(),
                fit: BoxFit.cover,
                imageUrl: imageUrl ??
                    "https://static.vecteezy.com/system/resources/thumbnails/017/567/039/small/urban-condo-modern-flat-cosmopolitan-residential-white-marble-colors-buildings-structure-skyline-background-photo.JPG",
                height: 54,
                width: 54,
                errorWidget: (
                  BuildContext context,
                  String url,
                  Object error,
                ) {
                  return Container(color: Colors.grey);
                }),
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(userName ?? "Nober Pilem",
                        textAlign: TextAlign.start,
                        style: appStyles.userNameTextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500)),
                    WorkplaceIcons.iconImage(
                        imageUrl: WorkplaceIcons.moreIcon,
                        iconSize: const Size(2.5, 2.5),
                        imageColor: AppColors.black),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    WorkplaceIcons.iconImage(
                        imageUrl: WorkplaceIcons.calendarIcon,
                        iconSize: const Size(17, 17),
                        imageColor: AppColors.textBlueColor.withOpacity(0.9)),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(date ?? "31 Jan 2023",
                        textAlign: TextAlign.start,
                        style: appStyles.userJobTitleTextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            texColor:
                                AppColors.textBlueColor.withOpacity(0.8))),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
