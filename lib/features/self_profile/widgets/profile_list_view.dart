import 'package:asetize/features/data/models/profile_data_model.dart';
import 'package:asetize/imports.dart';

class ProfileListRowWidget extends StatelessWidget {
  final onClickListCallBack;
  final bool isHideIconVisible;
  final String appVersion;

  ProfileListRowWidget(
      {Key? key,
      this.onClickListCallBack,
      this.isHideIconVisible = false,
      required this.appVersion})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var brightness = SchedulerBinding.instance.window.platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    return ListView.builder(
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.only(left: 0, right: 0, bottom: 66, top: 0),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: userProfile.length + 1,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            (userProfile.length == index)
                ? Padding(
                    padding: const EdgeInsets.only(left: 28, right: 28,top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'v$appVersion',
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.black.withOpacity(0.8)),
                        ),
                      ],
                    ),
                  )
                : Material(
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: Colors.grey.shade100,
                      highlightColor: Colors.grey.shade100,
                      onTap: () {
                        onClickListCallBack?.call(userProfile[index].title);
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 21),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 0.27,
                                    color: (userProfile[index].title.toLowerCase() == "logout")
                                        ? Colors.white
                                        : Colors.grey.shade400))),
                        padding: const EdgeInsets.all(18).copyWith(
                            left: 5, right: 5, bottom: index == 5 ? 10 : 18),
                        child: Row(
                          children: [
                            WorkplaceIcons.iconImage(
                              imageUrl: userProfile[index].icon,
                              iconSize: userProfile[index].title.toLowerCase().trim() == "update profile" ? const Size(18, 18) : const Size(22, 22),
                              imageColor: (userProfile[index].title.toLowerCase() == "logout")
                                  ? Colors.red.shade800
                                  : Colors.black,
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Flexible(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    userProfile[index].title,
                                    textAlign: TextAlign.start,
                                    style: appStyles.onBoardingTitleStyle(
                                      fontSize: 14.5,
                                      height: 1.1,
                                      fontWeight: FontWeight.w400,
                                      texColor: (userProfile[index].title.toLowerCase() == "logout")
                                          ? Colors.red.shade800
                                          : Colors.black.withOpacity(.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                             Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                (userProfile[index].title.toLowerCase() == "logout")? const SizedBox() : const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 14,
                                  color: Colors.black87,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ],
        );
      },
    );
  }
}
