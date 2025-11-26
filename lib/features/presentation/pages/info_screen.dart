import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:asetize/core/core.dart';
import 'package:asetize/features/presentation/presentation.dart';
import 'package:asetize/features/presentation/widgets/app_button_common.dart';
import 'package:asetize/features/presentation/widgets/basic_view_container/container_first.dart';
import 'package:asetize/features/presentation/widgets/detail_screen_appbar.dart';
import '../../sign_up/pages/sign_up_screen.dart';
import 'package:flutter/services.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  @override
  Widget build(BuildContext context) {
    return ContainerFirst(
        contextCurrentView: context,
        isSingleChildScrollViewNeed: false,
        isFixedDeviceHeight: true,
        isListScrollingNeed: true,
        statusBarColor: AppColors.textBlueColor.withOpacity(0.2),
        appBarHeight: 56,
        appBar: DetailsScreenAppBar(
          title: '',
          appBarColor: AppColors.textBlueColor.withOpacity(0.2),
        ),
        containChild: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              // height: MediaQuery.of(context).size.height / 1.8,
              width: MediaQuery.of(context).size.width,
              color: AppColors.textBlueColor.withOpacity(0.2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SvgPicture.asset('assets/images/frame.svg',),
                  const SizedBox(
                    height: 35,
                  ),
                  Column(
                 children: [
                   const Padding(
                     padding: EdgeInsets.only(left: 25, right: 25),
                     child: Text(AppString.infoText1,
                       textAlign: TextAlign.center,
                       style: TextStyle(fontSize: 20,color: AppColors.black),
                     ),
                   ),
                   const SizedBox(
                     height: 35,
                   ),
                   Padding(
                     padding: const EdgeInsets.only(left: 45, right: 45),
                     child: Container(
                       color: AppColors.white,
                       padding: const EdgeInsets.symmetric(
                           horizontal: 10, vertical: 10),
                       child: const Text(AppString.infoText2,
                         textAlign: TextAlign.center,
                         style: TextStyle(fontSize: 20,color: AppColors.black),
                       ),
                     ),
                   ),
                   const SizedBox(height: 30,)
                 ],
               )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 35, right: 35, bottom: 40, top: 40),
              child: Column(
                children: [
                  AppButton(
                    buttonName: 'Demo Request',
                    buttonColor: AppColors.textBlueColor,
                    buttonBorderColor: AppColors.textBlueColor,
                    textStyle: appStyles.buttonTextStyle1(
                      texColor: AppColors.white,
                    ),
                    backCallback: () {},
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  AppButton(
                    buttonName: 'View App',
                    buttonColor: AppColors.white,
                    buttonBorderColor: AppColors.textBlueColor,
                    textStyle: appStyles.buttonTextStyle1(
                      texColor: AppColors.textBlueColor,
                    ),
                    backCallback: () {
                      showDialog(
                          context: context,
                         // barrierDismissible: true, // disables popup to close if tapped outside popup (need a button to close)
                          builder: (context) => AlertDialog(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                            title: const Text(AppString.infoPopupTitle, textAlign: TextAlign.center,),
                            titlePadding: const EdgeInsets.only(top: 20),
                            titleTextStyle: const TextStyle(
                              color: AppColors.black,
                              fontSize: 20,
                             // fontWeight: FontWeight.w300,
                            ),
                            contentPadding: const EdgeInsets.only(left: 15,right: 15,top: 15,bottom: 15),
                            content: const Text(AppString.infoPopupContent ,
                              textAlign: TextAlign.center,
                            ),
                            contentTextStyle:TextStyle(
                              color: AppColors.black.withOpacity(0.5),
                              fontSize: 16,
                              // fontWeight: FontWeight.w300,
                            ),
                            actionsPadding: const EdgeInsets.only(bottom: 20),
                            actionsAlignment: MainAxisAlignment.center,
                            actions: [
                              ElevatedButton(
                                  onPressed: (){
                                    Navigator.pop(context);
                                    Navigator.push(
                                        context,
                                        SlideLeftRoute(
                                            widget:  const SignUpScreen()));
                                  },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.textBlueColor,
                                  foregroundColor: AppColors.appWhite,
                                  padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 15),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius:BorderRadius.all(
                                      Radius.circular(30),
                                  )
                                ),
                                ),
                                  child: Text(
                                    AppString.infoPopupButtonName,
                                    style: appStyles.subTitleStyle(
                                      fontSize: AppDimens().fontSize(value: 15),
                                      fontWeight: FontWeight.w500,
                                      texColor: AppColors.appWhite,
                                      fontFamily: AppFonts().defaultFont,
                                    ),
                                  ),
                              )
                            ],
                          ));
                    },
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
