import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:asetize/features/presentation/widgets/scroll_behavior.dart';

class BottomSheetOnlyCardView extends StatelessWidget {
  final String sheetTitle;
  final TextStyle sheetTitleStyle;
  final TextStyle skipTextStyle;
  final Color topLineColor;
  final double topLineThickness;
  final double topLineWidth;
  final Function()? topLineClickCallBack;
  final Color cardBackgroundColor;
  final double cardShape;
  final Widget child;
  final Widget? child2;
  final bool topLineShow;
  final bool isHideTitle;
  final EdgeInsetsGeometry topLineMargin;
  final CrossAxisAlignment crossAxisAlignment;
  final ScrollPhysics? physics;
  final Function()? onSkipClick;

  const BottomSheetOnlyCardView({
    Key? key,
    this.sheetTitle = "",
    this.onSkipClick,
    this.sheetTitleStyle = const TextStyle(),
    this.skipTextStyle = const TextStyle(fontWeight: FontWeight.w500),
    this.topLineColor = Colors.grey,
    this.topLineThickness = 4,
    this.topLineWidth = 50,
    this.cardBackgroundColor = Colors.red,
    this.cardShape = 30,
    this.topLineClickCallBack,
    required this.child,
    this.topLineShow = false,
    this.isHideTitle = false,
    this.topLineMargin = const EdgeInsets.only(top: 12, bottom: 10),
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.child2,
    this.physics,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: MyBehavior(),
      child: SingleChildScrollView(
        physics: physics ?? const ClampingScrollPhysics(),
        child: Container(
          decoration: BoxDecoration(
              color: cardBackgroundColor,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25))),
          child: Column(
            crossAxisAlignment: crossAxisAlignment,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Visibility(
                    visible: topLineShow,
                    child: InkWell(
                      highlightColor: Colors.brown,
                      onTap: () {
                        if (topLineClickCallBack != null) {
                          topLineClickCallBack!.call();
                        }
                        else {
                           Navigator.pop(context);
                        }

                      },
                      child: Container(
                        height: 4,
                        margin: topLineMargin,
                        width: topLineWidth,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.shade600),

                        /*Divider(
                          color: topLineColor,
                          //height: 10,
                          thickness: topLineThickness,
                          indent: 1,
                          endIndent: 1,
                        ),*/
                      ),
                    ),
                  ),
                ],
              ),
              Stack(children: [
                if(!isHideTitle)Padding(
                  padding:
                  const EdgeInsets.only(left: 20.0, right: 20, top: 0),
                  child: Text(sheetTitle, style: sheetTitleStyle),
                ),
                if(onSkipClick!=null)Align(alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: (){
                      onSkipClick?.call();
                    },
                    child: Padding(
                      padding:
                      const EdgeInsets.only(left: 20.0, right: 20, top: 0),
                      child: Text("Skip", style: skipTextStyle),
                    ),
                  ),
                ),
              ],),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
