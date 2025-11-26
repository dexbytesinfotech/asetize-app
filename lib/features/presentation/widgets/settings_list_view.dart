import 'package:flutter/cupertino.dart';
import 'package:asetize/features/data/models/settings_data_model.dart';
import 'package:asetize/imports.dart';

class SettingsListView extends StatelessWidget {
  final onClickListCallBack;
  final bool isHideIconVisible;
  final bool notification;
  final bool enableDelete;

  const SettingsListView({
    super.key,
    this.onClickListCallBack,
    this.isHideIconVisible = false,
    this.notification = false,
    this.enableDelete = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.only(left: 0, right: 0, bottom: 10, top: 0),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: settings.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return (index == 3)
          ? Material(
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: Colors.grey.shade100,
                      highlightColor: Colors.grey.shade100,
                      onTap: () {
                        if (index != 1)
                          onClickListCallBack?.call(settings[index].title);
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 21),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 0.27,
                                    color: index == 2
                                        ? Colors.white
                                        : Colors.grey.shade400))),
                        padding: const EdgeInsets.all(18).copyWith(
                            left: 5, right: 5, bottom: index == 2 ? 10 : 18),
                        child: Row(
                          children: [
                            WorkplaceIcons.iconImage(
                              imageUrl: settings[index].icon,
                              iconSize: const Size(22, 22),
                              imageColor: index == 2
                                  ? Colors.red.shade800
                                  : Colors.black87,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    settings[index]
                                        .title, //title of setting screen
                                    textAlign: TextAlign.start,
                                    style: appStyles.onBoardingTitleStyle(
                                      fontSize: 14.5,
                                      height: 1.1,
                                      fontWeight: FontWeight.w400,
                                      texColor: index == 2
                                          ? Colors.red.shade800
                                          : const Color(0xFF252525),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                index == 1
                                    ? CupertinoSwitch(
                                        activeColor: AppColors
                                            .textBlueColor, //const Color(0xFF20a7bd),
                                        trackColor: Colors.grey,
                                        value: notification,
                                        onChanged: (bool value) {
                                          onClickListCallBack
                                              ?.call(settings[index].title);
                                        })
                                    //Switch(
                                    //     value: notification,
                                    //     activeColor:
                                    //         AppColors.buttonBorderColor,
                                    //     onChanged: (bool value) {
                                    //       if (index == 1) {
                                    //         onClickListCallBack
                                    //             ?.call(settings[index].title);
                                    //       }
                                    //       // This is called when the user toggles the switch.
                                    //       // setState(() {
                                    //       //   light = value;
                                    //       // });
                                    //     },
                                    //   )
                                    : const Icon(
                                        Icons.arrow_forward_ios,
                                        size: 14,
                                        color: Colors.black87,
                                      ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ))
            : Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.grey.shade100,
                  highlightColor: Colors.grey.shade100,
                  onTap: () {
                    // if (index != 1) {
                    //   onClickListCallBack?.call(settings[index].title);
                    // }
                    onClickListCallBack?.call(settings[index].title);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 21),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                width: 0.27,
                                color: index == 2
                                    ? Colors.white
                                    : Colors.grey.shade400))),
                    padding: const EdgeInsets.all(18).copyWith(
                        left: 5, right: 5, bottom: index == 2 ? 10 : 18),
                    child: Row(
                      children: [
                        WorkplaceIcons.iconImage(
                          imageUrl: settings[index].icon,
                          iconSize: const Size(22, 22),
                          imageColor:
                              index == 2 ? Colors.red.shade800 : Colors.black87,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                settings[index].title, //title of setting screen
                                textAlign: TextAlign.start,
                                style: appStyles.onBoardingTitleStyle(
                                  fontSize: 14.5,
                                  height: 1.1,
                                  fontWeight: FontWeight.w400,
                                  texColor: index == 2
                                      ? Colors.red.shade800
                                      : const Color(0xFF252525),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            index == 1
                                ? CupertinoSwitch(
                                    activeColor: AppColors
                                        .textBlueColor, //const Color(0xFF20a7bd),
                                    trackColor: Colors.grey,
                                    value: notification,
                                    onChanged: (bool value) {
                                      onClickListCallBack
                                          ?.call(settings[index].title);
                                    })

                                // Switch(
                                //         value: notification,
                                //         activeColor: AppColors.buttonBorderColor,
                                //         onChanged: (bool value) {
                                //           if (index == 1)
                                //             onClickListCallBack
                                //                 ?.call(settings[index].title);
                                //           // This is called when the user toggles the switch.
                                //           // setState(() {
                                //           //   light = value;
                                //           // });
                                //         },
                                //       )

                                : const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 14,
                                    color: Colors.black87,
                                  ),
                          ],
                        )
                      ],
                    ),
                  ),
                ));
      },
    );
  }
}
