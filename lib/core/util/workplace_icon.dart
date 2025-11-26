import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

abstract class WorkplaceIcons {
  static const String backArrow = 'assets/images/back_arrow_workplace.svg';
  static const String emailIcon = 'assets/images/email_icon.svg';
  static const String personIcon = 'assets/images/person_icon.svg';
  static const String passwordIcon = 'assets/images/password_icon.svg';
  static const String moreIcon = 'assets/images/more_icon.svg';
  static const String crossIcon = 'assets/images/cross_icon.svg';
  static const String editIcon = 'assets/images/edit_icon_4.svg';
  static const String editButtonIcon = 'assets/images/edit_button_dark_icon.svg';
  static const String bagIcon = 'assets/images/bag_icon.svg';
  static const String galleryIcon = 'assets/images/photos_icon.svg';
  static const String  carVehicle= "assets/images/car_vehicle.svg";
  static const String cameraIcon = 'assets/images/camera_icon.svg';
  static const String  bikeVehicle = "assets/images/bike_vehicle.svg";
  static const String callIcon = 'assets/images/call_icon.svg';
  static const String deniedIcon = 'assets/images/denied_icon.svg';
  static const String groupIcon = 'assets/images/group_icon.svg';
  static const String  scooty = "assets/images/scooter_vehicle.svg";
  static const String  busNewIcon = "assets/images/bus_new_icon.svg";
  static const String  autoRickshaw = "assets/images/auto_rickshaw_icon.svg";
  static const String  vanNewIcon = "assets/images/delivery_van.svg";
  static const String calendarIcon = 'assets/images/calendar_icon.png';
  // static const String editIcon = 'assets/images/calendar_icon.png';
  static const String settingsIcon = 'assets/images/setting_icon.svg';
  static const String shareIcon = 'assets/images/share_icon.svg';
  static const String notificationIcon = 'assets/images/notification_icon.svg';
  static const String logOutIcon = 'assets/images/log_out_icon.svg';
  static const String allowedIcon = 'assets/images/allowed_icon.svg';
  static const String briefcaseIcon = 'assets/images/briefcase_icon.svg';
  static const String clockIcon = 'assets/images/clock_icon.svg';
  static const String cardBackgroundImages =
      'assets/images/card_background.svg';
  static const String birthdayCakeIcon =
      'assets/images/profile_birthday_cake.svg';
  static const String leaveIcon = 'assets/images/leave_icon.svg';
  static const String whfIcon = 'assets/images/wfh_icon.svg';
  static const String announcementIcon = 'assets/images/announcement_icon.svg';
  static const String postIcon = 'assets/images/post_comment_new.svg';
  static const String postCommentIcon = 'assets/images/post_comment_new.svg';
  static const String complaintIcon = 'assets/images/complaint.svg';
  static const String payment = 'assets/images/payment_new.svg';
  static const String invoice = 'assets/images/invoice_new.svg';
  static const String joinRequest = 'assets/images/join_request_new.svg';

  static const String docFormat = 'assets/images/docx-file.svg';
  static const String pdfFormat =
      'assets/images/pdf_file.svg';
  static const String imageFormat = 'assets/images/image_document.svg';
  static const String splashScreenIcon = 'assets/images/splash_ScreenIcon.png';
  static const String splashScreenPoweredBYIcon = 'assets/images/powered_by.svg';

  static const String spotlightIcon = 'assets/images/star_image.svg';
  static const String spotlightStarIcon = 'assets/images/star.svg';
  static const String appLogoImage = 'assets/images/app_logo.png';
  static const String appLogoOldImage = 'assets/images/app_logo_image.png';

  static dynamic iconImage(
      {required String imageUrl,
      Size? iconSize,
      Color? imageColor,
      bool isFile = false}) {
    return isFile
        ? FileImage(
            File(imageUrl),
            scale: 1,
          )
        : (iconSize != null
            ? (imageUrl.contains(".svg")
                ? SvgPicture.asset(
                    imageUrl,
                    height: iconSize.height,
                    width: iconSize.width,
                    color: imageColor,
                  )
                : Image(
                    image: AssetImage(imageUrl),
                    height: iconSize.height,
                    width: iconSize.height,
                    color: imageColor,
                  ))
            : (imageUrl.contains(".svg")
                ? SvgPicture.asset(
                    imageUrl,
                    color: imageColor,
                  )
                : Image(
                    image: AssetImage(imageUrl),
                    color: imageColor,
                  )));
  }

  static SvgPicture iconImageProvider(
      {required String imageUrl,
      Size? iconSize,
      Color? imageColor,
      bool? isFile = false}) {
    return SvgPicture.asset(
      imageUrl,
      height: iconSize?.height,
      width: iconSize?.width,
      color: imageColor,
    );
  }
}
