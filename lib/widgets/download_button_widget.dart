import 'package:flutter/material.dart';
import '../core/util/app_theme/app_color.dart';

class DownloadButtonWidget extends StatelessWidget {
  final String? buttonName;
  final onTapCallBack;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final double? height;
  final double horizontalRadius;
  const DownloadButtonWidget({super.key, this.buttonName, this.onTapCallBack, this.margin, this.borderRadius, this.horizontalRadius =  18, this.height = 45});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTapCallBack.call();
      },
      child: Container(
        height: height,
        margin: margin ?? EdgeInsets.symmetric(horizontal: horizontalRadius ).copyWith(top: 10,bottom: 15),
        decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(width: 1,color: AppColors.appBlueColor),
            borderRadius: BorderRadius.circular(borderRadius??10)
        ),
        child:Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.download,color: AppColors.appBlueColor,),
            Text(
              buttonName ?? "Download Receipt",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.appBlueColor,
                decorationColor: AppColors.appBlueColor,
              ),
            ),
          ],),

      ),
    );
  }
}
