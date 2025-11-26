class UserProfileRawDataModel {
  final String title;
  final String icon;

  UserProfileRawDataModel({
    required this.title,
    required this.icon,
  });
}

List<UserProfileRawDataModel> moreData = [
  UserProfileRawDataModel(
    title: "Save",
    icon: 'assets/images/save_icon.svg',
  ),
  UserProfileRawDataModel(
    title: "Share via",
    icon: 'assets/images/share_icon.svg',
  ),
  UserProfileRawDataModel(
    title: "Report post",
    icon: 'assets/images/report_icon.svg',
  ),
];
