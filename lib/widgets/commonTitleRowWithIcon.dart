import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/util/app_permission.dart';
import '../core/util/app_theme/app_color.dart';
import '../core/util/app_theme/text_style.dart';


class CommonTitleRowWithIcon extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final String title;
  final void Function()? onTapButtonCallBack;
  final Color btColor;
  final Color? iconColor;
  final bool isShowBt;


  const CommonTitleRowWithIcon({super.key,
    this.icon = CupertinoIcons.person_2_fill,
    this.iconSize = 20,
    this.title = '',
    this.onTapButtonCallBack,
    this.btColor = AppColors.appBlueColor,
    this.isShowBt = false,
    this.iconColor

  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 0, top: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 2, right: 5),
                child: Icon(
                  icon,
                  color: iconColor?? Colors.black,
                  size: iconSize,
                ),
              ),
              Text(
                title,
                style: appTextStyle.appTitleStyle(
                    fontWeight: FontWeight.bold, fontSize: 19),
              ),
            ],
          ),
          if (isShowBt)
            IconButton(
                onPressed: onTapButtonCallBack,
                icon: Container(
                  decoration:
                  BoxDecoration(color: btColor.withOpacity(0.15), shape: BoxShape.circle),
                  padding: EdgeInsets.all(5),
                  child: Icon(
                    Icons.add,
                    size: 20,
                    color: btColor,
                  ),
                )),
        ],
      ),
    );
  }
}
