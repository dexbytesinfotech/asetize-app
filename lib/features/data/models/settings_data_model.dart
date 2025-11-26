class SettingsRawDataModel {
  final String title;
  final String icon;

  SettingsRawDataModel({
    required this.title,
    required this.icon,
  });
}

List<SettingsRawDataModel> settings = [
  SettingsRawDataModel(
    title: "Change Password",
    icon: 'assets/images/change_password_icon.svg',
  ),
  SettingsRawDataModel(
    title: "Notifications",
    icon: 'assets/images/notification_icon.svg',
  ),

];
