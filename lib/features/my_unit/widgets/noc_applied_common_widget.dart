import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:asetize/core/core.dart';
import '../../../core/util/app_theme/app_color.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../../widgets/common_card_view.dart';

class NocAppliedCard extends StatelessWidget {
  final String? name;
  final String? lastName;
  final String? title;
  final String? status;
  final String? purpose;
  final String ?date;
  final Function()? onTap;

  const NocAppliedCard({
    Key? key,
     this.name,
    this.lastName,
     this.title,
     this.status,
     this.purpose,
     this.date,
     this.onTap,

  }) : super(key: key);

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange; // Waiting action
      case 'rejected':
        return Colors.red; // Not approved
      case 'approved':
        return Colors.green; // Success
      case 'issued':
        return Colors.green; // Issued or finalized
      default:
        return Colors.grey; // Unknown or default state
    }

  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: CommonCardView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  shape: BoxShape.circle
                ),
                padding: EdgeInsets.all(13.1),
                margin: EdgeInsets.only(top: 1),
                child: Icon(CupertinoIcons.doc_text_fill,size: 16,color: AppColors.appBlueColor,),
              ),
              const SizedBox(width: 12,),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [


                    if(name!.isNotEmpty&& lastName!.isNotEmpty )
                      Padding(
                        padding: const EdgeInsets.only(top: 1),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                     "${projectUtil.capitalize(name ?? "")} ${projectUtil.capitalize(lastName ?? "")}",
                                      style: appTextStyle.appTitleStyle2(),
                                      overflow: TextOverflow.ellipsis, // Dots at end when too long
                                      maxLines: 1, // Prevents multi-line overflow
                                      softWrap: false, // Optional: avoids wrapping to next line
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getStatusColor(status ?? '').withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                (status ?? '').isNotEmpty ? status![0].toUpperCase() + status!.substring(1) : '',
                                style: TextStyle(
                                  color: _getStatusColor(status ?? ''),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11,
                                ),
                              ),

                            ),
                          ],
                        ),
                      ),
                    SizedBox(height: name!.isNotEmpty&& lastName!.isNotEmpty ?1: 0),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          purpose ?? '',
                          style: appTextStyle.appSubTitleStyle2(fontSize: 14),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 3),
                          child: Text(
                            date ?? '',
                            style: appTextStyle.appSubTitleStyle2(fontSize: 10),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),

                    // Align(
                    //   alignment: Alignment.centerRight,
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.start,
                    //     children: [
                    //       Text(
                    //         date ?? '',
                    //         style: appTextStyle.appSubTitleStyle2(fontSize: 14),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],

          )
        ),
      ),
    );
  }
}
