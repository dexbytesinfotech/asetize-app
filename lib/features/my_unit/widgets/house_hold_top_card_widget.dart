// ignore_for_file: prefer_const_constructors

import '../../../core/util/app_theme/text_style.dart';
import '../../../imports.dart';
import '../../../widgets/common_card_view.dart';

class HouseHoldTopCardWidget extends StatelessWidget {
  final String? houseNumber;
  final String? sizeInSqFit;
  final String? openingBalance;
  const HouseHoldTopCardWidget({super.key,this.sizeInSqFit,
    this.openingBalance, this.houseNumber,});

  @override
  Widget build(BuildContext context) {
    return CommonCardView(
      margin: EdgeInsets.symmetric(horizontal: 5),
      elevation: 0.5,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
        child: Row(
          children: [
            if(houseNumber?.isNotEmpty == true) Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppString.houseNumber,
                        style: appTextStyle.appSubTitleStyle(fontWeight: FontWeight.w400,fontSize: 14,color: Colors.grey.shade600),
                      ),
                      SizedBox(height: 2,),
                      Text(
                        houseNumber ?? "",
                        style: appTextStyle.appTitleStyle(fontWeight: FontWeight.w600,fontSize: 16),
                      ),
                    ],
                  ),
            Spacer(),
            if(sizeInSqFit?.isNotEmpty == true)  Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      AppString.houseSize,
                      style: appTextStyle.appSubTitleStyle(fontWeight: FontWeight.w400,fontSize: 14,color: Colors.grey.shade600),
                    ),
                    SizedBox(height: 2,),
                    Text(
                      sizeInSqFit ?? "",
                      style: appTextStyle.appSubTitleStyle(fontWeight: FontWeight.w600,fontSize: 16),
                    ),
                  ],
                ),
          ],
        )
      ),
    );
  }
}