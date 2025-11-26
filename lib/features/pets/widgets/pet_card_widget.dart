import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../../imports.dart';
import '../../../widgets/common_card_view.dart';

class PetCardWidget extends StatelessWidget {
  final String? imageUrl;
  final String? userName;
  final String? jobTitle;
  final Color? cardColor;
  final bool? isVaccinated;
  final void Function()? onLongPress;
  final void Function()? onTab;
  final EdgeInsetsGeometry? margin;
  const PetCardWidget({
    Key? key,
    this.imageUrl,
    this.cardColor=  Colors.white,
    this.userName,
    this.jobTitle,
    this.onLongPress,
    this.onTab,
    this.isVaccinated,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onLongPress: onLongPress,
      onTap: onTab,
      child: CommonCardView(
        cardColor: cardColor ?? Colors.white, // Set card color based on status
        elevation: 0.5,
        margin: margin ??  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: CachedNetworkImage(
                    placeholder: (context, url) => const ImageLoader(),
                    errorWidget: (context, url, error) => Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        shape: BoxShape.circle
                      ),
                      alignment: Alignment.center,
                      height: 40,
                      width: 40,
                      child:Text(jobTitle!.contains('Dog')?'🐕':jobTitle!.contains('Fish')?"🐠":jobTitle!.contains('Bird')?"🦜":"🐱",style: TextStyle(fontSize: 18),)
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
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              userName ?? "",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: appTextStyle.appTitleStyle2(),
                            ),


                          ]
                      ),
                      Text(
                        jobTitle ?? "",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: appTextStyle.appSubTitleStyle2(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 15),
                Image.asset(
                  isVaccinated == true ?  "assets/images/vaccinated.png" : "assets/images/not_vaccinated.png",
                  height: 22,
                  width: 22,
                  fit: BoxFit.cover,
                )
              ],
            ),
          ),
        ),
      ),
    );


  }
}