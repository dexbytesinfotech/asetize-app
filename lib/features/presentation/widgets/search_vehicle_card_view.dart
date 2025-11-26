import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:asetize/core/util/app_theme/app_color.dart';
import 'package:asetize/widgets/common_card_view.dart';


class SearchVehicleCardView extends StatelessWidget {
  final String title;
  final String rcNumber;
  final String flatNumber;
  final String phoneNumber;
  final String type;
  final onTapPhoneCallBack;
  final onTapWhatsAppCallBack;

  const SearchVehicleCardView({super.key,
    required this.title,
    required this.rcNumber,
    required this.flatNumber,
    required this.type,
    this.onTapPhoneCallBack,
    this.onTapWhatsAppCallBack, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {

    String vehicleTypeImage(String vehicleType)
    {
      String url = "";
      switch(vehicleType.toString())
      {
        case "car":
          url = "assets/images/car_vehicle.svg";
          break;
        case "bike":
          url = "assets/images/bike_vehicle.svg";
          break;
        case "scooty":
          url = "assets/images/scooter_vehicle.svg";
          break;
        default:
          url = "assets/images/car_vehicle.svg";
      }
      return url;
    }



    Widget buildDetailText(String label, String? value) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 124,
            child: Text(
              '$label',
              style: const TextStyle(
                  fontWeight: FontWeight.normal, fontSize: 14, color: Colors.black),
            ),
          ),
          Expanded(
            child: Text(
              value ?? 'N/A',
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
        ],
      );
    }



    return CommonCardView(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 10,top: 15),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade200, // Light grey background for contrast
              ),
              child: SvgPicture.asset(
                vehicleTypeImage(type ?? ""),
                height: 50,
                width: 50,
                color: AppColors.textBlueColor,
              ),
            ),
            const SizedBox(width: 10),


            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  buildDetailText(
                    'Vehicle Number :',
                    rcNumber,
                  ),
                  const SizedBox(height: 10),
                  buildDetailText(
                    'Phone Number :',
                    phoneNumber,
                  ),
                  const SizedBox(height: 10),
                  if(flatNumber.isNotEmpty)
                  buildDetailText(
                    'Flat Number :',
                     flatNumber,
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.only(right: 25,top: 5),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: (){
                            onTapPhoneCallBack.call();
                          },
                          child: Container(
                            height: 35,
                            width: 90,
                            decoration: BoxDecoration(
                              color: AppColors.textBlueColor,
                                border: Border.all(width: 1,  color: AppColors.textBlueColor,),
                                borderRadius: BorderRadius.circular(8)
                            ),
                            child:const Icon(
                              Icons.phone,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10,),
                        GestureDetector(
                          onTap: (){
                            onTapWhatsAppCallBack.call();
                          },
                          child: Container(
                            height: 35,
                            width: 90,
                            decoration: BoxDecoration(
                              color: Colors.green.shade500,
                                border: Border.all(width: 1,color: Colors.white),
                                borderRadius: BorderRadius.circular(8)
                            ),
                            child:const Icon(
                              FontAwesomeIcons.whatsapp,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
