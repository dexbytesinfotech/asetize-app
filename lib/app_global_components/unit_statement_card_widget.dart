import 'package:asetize/widgets/common_card_view.dart';

import '../core/util/app_theme/text_style.dart';
import '../imports.dart';

class UnitStatementCardWidget extends StatelessWidget {
  final String? title;
  final String description;
  final String? subTitle;
  final String? table;
  final String? amount;
  final String? type;
  final String date;
  final String? status;
  final Color? statusColor;
  final String? paymentMethod;
  final String? balanceAmount;
  final void Function()? onTap;
  const UnitStatementCardWidget(
      {super.key,
      this.title,
      this.description ='',
      this.subTitle,
      this.table,
      this.onTap,
      this.amount,
      this.type,
      this.date ='', this.status, this.statusColor, this.paymentMethod, this.balanceAmount,});

  @override
  Widget build(BuildContext context) {
    Widget balanceText()
    {
      return  balanceAmount?.isNotEmpty == true ? Text('Balance : $balanceAmount',style: const TextStyle(
        color: Colors.grey,
        fontSize: 11,
        fontWeight: FontWeight.w400,
      ),): const SizedBox();
    }

    Widget statusWidget(String status, Color statusColor)
    {
      return status.isNotEmpty ? Container(
        margin: const EdgeInsets.only(left: 5),
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 1),
        decoration: BoxDecoration(
            color:  statusColor == Colors.black ? Colors.grey :statusColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(5)
        ),
        child: Text( status ?? '',style:TextStyle(color:
        statusColor == Colors.black ? Colors.white : statusColor,
            fontSize: 11,fontWeight: FontWeight.normal),),
      ) : const SizedBox();
    }

    return GestureDetector(
      onTap: onTap,
      child: CommonCardView(
        cardColor: Colors.white,
        margin: const EdgeInsets.only(bottom: 10),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        title ?? "",
                        style: appTextStyle.appTitleStyle2(),
                      ),
                       statusWidget(status ?? '', statusColor ?? Colors.black),
                        statusWidget( paymentMethod ?? '', statusColor ?? Colors.black),
                    ],
                  ),
                  Text(
                    amount ?? "",
                    style: appTextStyle.appTitleStyle2(
                      color: type?.toLowerCase() == "credited" || (double.tryParse(amount!.replaceAll(RegExp(r'[^0-9.-]'), '')) ?? 0) <= 0
                          ? AppColors.appGreen
                          : AppColors.red,
                    ),
                  ),
                ],
              ),
               SizedBox(height:description.isNotEmpty? 4:0),
              if(description.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      description ?? "",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: appTextStyle.appSubTitleStyle2(fontSize: 14),
                    ),
                  ),
                  balanceText()
                ],
              ),
              if(subTitle?.isNotEmpty == true) const SizedBox(height: 4),
              if(subTitle?.isNotEmpty == true) Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      subTitle ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: appTextStyle.appSubTitleStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
               SizedBox(height:date.isNotEmpty? 0:  10),
              if(date.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    date ?? "",
                    style: appTextStyle.appSubTitleStyle2(fontSize: 14),
                  ),
                  Row(
                    children: [
                      Text(
                        type ?? "",
                        style: appTextStyle.appSubTitleStyle(),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      type?.toLowerCase() == "credited"
                          ? SvgPicture.asset(
                        'assets/images/left_icon.svg',
                        color: AppColors.appGreen,
                        height: 25,
                      )
                          : SvgPicture.asset(
                        'assets/images/right_icon.svg',
                        color: AppColors.red,
                        height: 25,
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
