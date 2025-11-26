// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//
// import '../../../core/util/app_theme/app_color.dart';
//
// class ContactButtonsRow extends StatelessWidget {
//   final String? contact;
//   final Function(String)?onPhonePress;
//   final Function(String)? onWhatsAppPress;
//
//   const ContactButtonsRow({
//     Key? key,
//     this.contact,
//     this.onPhonePress,
//     this.onWhatsAppPress,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.end,
//       children: [
//         ElevatedButton.icon(
//           onPressed: () => onPhonePress(contact!),
//           icon: const Padding(
//             padding: EdgeInsets.only(left: 5),
//             child: Icon(
//               Icons.phone,
//               color: Colors.blue,
//               size: 26,
//             ),
//           ),
//           label: const SizedBox.shrink(),
//           style: ElevatedButton.styleFrom(
//             elevation: 1.5,
//             minimumSize: const Size(30, 45),
//             maximumSize: const Size(105, 50),
//             padding: const EdgeInsets.symmetric(
//               vertical: 0.0,
//               horizontal: 13.0,
//             ),
//             foregroundColor: Colors.white,
//             backgroundColor: AppColors.white,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8.0),
//               side: const BorderSide(
//                 color: Colors.blue,
//                 width: 0.7,
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(
//           width: 12,
//         ),
//         ElevatedButton.icon(
//           onPressed: () => onWhatsAppPress(contact!),
//           icon: const Padding(
//             padding: EdgeInsets.only(left: 5),
//             child: Icon(
//               FontAwesomeIcons.whatsapp,
//               color: Colors.green,
//               size: 26,
//             ),
//           ),
//           label: const SizedBox.shrink(),
//           style: ElevatedButton.styleFrom(
//             elevation: 1.5,
//             minimumSize: const Size(30, 45),
//             maximumSize: const Size(105, 50),
//             padding: const EdgeInsets.symmetric(
//               vertical: 0.0,
//               horizontal: 13.0,
//             ),
//             foregroundColor: Colors.white,
//             backgroundColor: AppColors.white,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8.0),
//               side: const BorderSide(
//                 color: Colors.green,
//                 width: 0.7,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
// // ContactButtonsRow(
// // contact: formattedContact,
// // onPhonePress: (contact) => _launchURL(contact),
// // onWhatsAppPress: (contact) => makingWhatsAppCall(contact),
// // )
