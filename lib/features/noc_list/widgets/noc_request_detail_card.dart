// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:asetize/core/core.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/util/app_theme/app_color.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../../widgets/common_card_view.dart';
import '../../../widgets/common_detail_view_row.dart';
import '../../data/models/user_response_model.dart';
import '../../member/pages/member_unit_screen.dart';
import '../models/noc_singal_request_model.dart';

class NocRequestDetailCard extends StatelessWidget {
  final SingalData nocRequestData;

  const NocRequestDetailCard({
    super.key,
    required this.nocRequestData,
  });

  @override
  @override
  Widget build(BuildContext context) {
    final rawStatus = nocRequestData.status ?? '';
    final status = rawStatus.isNotEmpty
        ? rawStatus
            .replaceAll('_', ' ')
            .split(' ')
            .map((word) => word.isNotEmpty
                ? word[0].toUpperCase() + word.substring(1).toLowerCase()
                : '')
            .join(' ')
        : '';

    final statusColor = _getStatusColor(status);
    final purpose = nocRequestData.purpose ?? '';
    final requesterName = nocRequestData.requester ?? '';
    final submittedDate = nocRequestData.createdAt ?? '';

    final contactNumberForOnwerTenant = projectUtil.formatPhoneNumberWithCountryCode(
    countryCode: nocRequestData.countryCode!, // or from dynamic user input or data
    phoneNumber: nocRequestData.phone!,
  );

    final contactNumberForOnwer = projectUtil.formatPhoneNumberWithCountryCode(
      countryCode: nocRequestData.requestedByCountryCode!, // or from dynamic user input or data
      phoneNumber: nocRequestData.requestedByPhone!,
    );

    final contactNumberForBroker = projectUtil.formatPhoneNumberWithCountryCode(
      countryCode:nocRequestData.broker?.countryCode ?? "", // or from dynamic user input or data
      phoneNumber: nocRequestData.broker?.phone ?? "",
    );

    return Column(
      children: [

        topStatusCard(status,purpose),
        CommonCardView(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:  [

                  titleText('Owner Details'),

                  if ((nocRequestData.requestedBy ?? '').trim().isNotEmpty)
                    CommonDetailViewRow(title: "Owner Name",
                        icons: CupertinoIcons.person_alt_circle,
                        value: nocRequestData.requestedBy ?? '',
                        number: contactNumberForOnwer?? '',
                        isShowBt: true
                    ),

                  if ((nocRequestData.title ?? '').trim().isNotEmpty)
                    CommonDetailViewRow(
                      title: AppString.ownerHouseNumber,
                      value: nocRequestData.title ?? '',
                      btName:AppString.checkDues,
                      isShowBt: true,
                      onTapCallBack: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MemberUnitScreen(
                                  userName: nocRequestData.requester ?? '',
                                  houses: [
                                    Houses(
                                      id: nocRequestData.houseId,
                                      title: nocRequestData.title,
                                    )
                                  ])),
                        );
                      },
                    ),
                  Divider(height: 0,thickness: 0.35,),



                  if (purpose == 'Sale of Property') ...[

                    titleText('Buyer Details'),

                    if ((nocRequestData.firstName ?? '').trim().isNotEmpty || (nocRequestData.lastName ?? '').trim().isNotEmpty)
                      CommonDetailViewRow(
                          title: AppString.buyerName,
                          value:'${projectUtil.capitalize(nocRequestData.firstName ?? "")} ${ projectUtil.capitalize(nocRequestData?.lastName ?? "")}',
                          isShowBt: (nocRequestData.phone ?? '').trim().isNotEmpty == true?true:false,
                          number:contactNumberForOnwerTenant ?? "",
                          icons: CupertinoIcons.person_alt_circle),

                    // if ((nocRequestData.phone ?? '').trim().isNotEmpty)
                    //   CommonDetailViewRow(title: AppString.buyerPhoneNumber,
                    //       value:nocRequestData.phone ?? "",
                    //       number:nocRequestData.phone ?? "",
                    //       icons: CupertinoIcons.phone,
                    //       isShowBt: true),

                    if ((nocRequestData.address ?? '').trim().isNotEmpty)
                      CommonDetailViewRow(title: AppString.buyerAddress, value:nocRequestData.address ?? ""),

                    Divider(height: 0,thickness: 0.35,),
                  ]

                  else if (purpose == 'Rental Agreement') ...[

                    titleText('Tenant Details'),

                    if ((nocRequestData.firstName ?? '').trim().isNotEmpty || (nocRequestData.lastName ?? '').trim().isNotEmpty)
                      CommonDetailViewRow(
                          title: AppString.tenantName,
                          isShowBt: true,
                          number:contactNumberForOnwerTenant ?? "",
                          value:'${projectUtil.capitalize(nocRequestData.firstName ?? "")} ${ projectUtil.capitalize(nocRequestData?.lastName ?? "")}',icons: CupertinoIcons.person_alt_circle),

                    if ((nocRequestData.address ?? '').trim().isNotEmpty)
                      CommonDetailViewRow(title: AppString.tenantAddress, value:nocRequestData.address ?? ""),

                    if (nocRequestData.isCompletedPoliceVerification != null)
                      CommonDetailViewRow(
                        icons: CupertinoIcons.person_alt_circle,
                        title: AppString.policeVerificationStatus,
                        isShowStatus: true,
                        value:(nocRequestData.isCompletedPoliceVerification == true || nocRequestData.isCompletedPoliceVerification == '1') ? 'Completed' : 'Pending',),

                    Divider(height: 0,thickness: 0.35,),
                  ],


                  titleText('Request Details'),

                  CommonDetailViewRow(title: AppString.purpose, value:purpose,icons: CupertinoIcons.doc_text),


                  if ((nocRequestData.broker?.name ?? '').trim().isNotEmpty)
                    CommonDetailViewRow(
                        title: AppString.brokerNameKey,
                        value:nocRequestData.broker?.name ?? '',
                        icons: CupertinoIcons.person_alt_circle,
                        isShowBt: true,
                        number: contactNumberForBroker ?? '',

                    ),


                  if ((nocRequestData.title ?? '').trim().isNotEmpty && nocRequestData.firstName == "")
                    CommonDetailViewRow(title: AppString.houseNumber, value:nocRequestData.title ?? '',icons: CupertinoIcons.person_alt_circle),


                  if ((nocRequestData.createdAt ?? '').trim().isNotEmpty)
                    CommonDetailViewRow(title: AppString.submissionDate, value:nocRequestData.createdAt ?? '',icons: Icons.calendar_month),



                  if ((nocRequestData.issueDate ?? '').trim().isNotEmpty)
                    CommonDetailViewRow(title: AppString.approvedDate, value:nocRequestData.issueDate ?? '',icons: Icons.calendar_month),
                  if ((nocRequestData.approvedBy ?? '').trim().isNotEmpty)

                  CommonDetailViewRow(
                      title: nocRequestData.status
                          ?.toLowerCase() ==
                          'rejected'
                          ? AppString.rejectedBy
                          : AppString.approvedBy,
                      value:
                      nocRequestData.approvedBy ?? '',
                      icons: CupertinoIcons.person_alt_circle),
                  // if ((nocRequestData.approvedBy ?? '').trim().isNotEmpty)
                  //   CommonDetailViewRow(title: AppString.approvedBy, value:nocRequestData.approvedBy ?? '',icons: CupertinoIcons.person_alt_circle),

                  // if ((nocRequestData.remarkForRejection ?? '').trim().isNotEmpty)
                  //   CommonDetailViewRow(title: AppString.reasonForRejection, value:nocRequestData.remarkForRejection ?? '',icons: CupertinoIcons.clear_circled),


                  if ((nocRequestData.remarks ?? '').trim().isNotEmpty)
                    CommonDetailViewRow(title: AppString.remarks, value:nocRequestData.remarks ?? '',icons: CupertinoIcons.text_bubble),

                ],
              ),
            )),

      ],
    );
  }

  Widget buildButton({
    required IconData icon,
    required String text,
    required Color color,
    required Color iconColor,
    required Color borderColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, color: iconColor, size: 22),
    );
  }

  makingPhoneCall(number) async {
    String formattedPhoneNumber = '$number';

    var url = Uri.parse('tel:$formattedPhoneNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget buildTitleWithStatus(String label, String value, String status,
      Color statusColor, String number) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (status.isEmpty)
            const SizedBox(
              height: 8,
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: appTextStyle.appSubTitleStyle(
                      fontWeight: FontWeight.w400, fontSize: 16)),
              if (status.isNotEmpty)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: appTextStyle.appSubTitleStyle(
                        fontWeight: FontWeight.w500,
                        color: statusColor,
                        fontSize: 12),
                  ),
                ),
            ],
          ),
          const SizedBox(
            height: 3,
          ),
          InkWell(
            onTap: () async {
              await makingPhoneCall(number);
            },
            child: Row(
              children: [
                Text(value, style: appTextStyle.appTitleStyle()),
                const SizedBox(
                  width: 10,
                ),
                // if(nocRequestData.firstName!.isNotEmpty)
                buildButton(
                  icon: Icons.phone,
                  text: 'Call',
                  color: Colors.transparent,
                  iconColor: Colors.blue,
                  borderColor: Colors.transparent,
                  onTap: () async {
                    await makingPhoneCall(number);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget titleText(title) {
    return Padding(
      padding: const EdgeInsets.only(top: 18,bottom: 12),
      child: Text(
        title,
        style: appTextStyle.appTitleStyle2(
            fontSize: 18, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget topStatusCard(status, purpose) {
    return CommonCardView(
      cardColor: _getStatusColor(status).safeOpacity(0.02),
      elevation: 1.5,
      margin: EdgeInsets.symmetric(horizontal: 20).copyWith(top: 10),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _getStatusColor(status).safeOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                CupertinoIcons.doc_text,
                size: 18,
                color: Colors.black,
              ),
            ),
            SizedBox(width: 15),
            // Make Column take remaining width
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$status",
                    style: appTextStyle.appTitleStyle2(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "NOC Request for $purpose",
                    style: appTextStyle.appSubTitleStyle2(
                      color: Colors.grey.shade700,
                    ),
                  ),
                  if( nocRequestData.remarkForRejection?.isNotEmpty ?? false)
                  Text(
                    nocRequestData.remarkForRejection ?? '',
                    style: appTextStyle.appSubTitleStyle2(
                      color: Colors.grey.shade700,
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


}

Color _getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'pending':
      return Colors.orange;
    case 'rejected':
      return Colors.red;
    case 'approved':
      return Colors.green;
    case 'issued':
      return Colors.green;
    default:
      return Colors.black12;
  }
}
