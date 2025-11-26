import 'package:asetize/imports.dart';

class AppPermission {
  AppPermission._internal();
  static final AppPermission instance = AppPermission._internal();
  factory AppPermission() {
    return instance;
  }

  List<String> permissions = [];    //MainAppBloc.permissions;

     /* [
    "post-edit",
    "post-add",
    "complaint-edit",
    "complaint-delete",
    "post-list",
    "vehicle-search",
    "handyman-list",
    "vehicle-list",
    "complaint-list",
    "account-book-list",
    "notice-list",
    "vehicle-delete",
    "vehicle-add",
    "post-comment",
   "post-like",
   "post-share",
   "complaint-comment",
    "complaint-status-update",
    "complaint-add",
    "account-book-pay-in-cash",
    "account-book-pay-in-online",
    "account-book-pay-in-cheque",
    "account-book-pay-in",
    "account-book-pay-out",
    "commitee-list",
    "member-list"
  ];*/

  /// This function will call after fetching data from server.
  set setPermissions(List<String> permissions) {
    this.permissions = [];
    this.permissions.addAll(permissions);
  }

  bool canPermission(String permissionFor,{BuildContext? context}) {
    bool status = false;
    if(context!=null){
      status = BlocProvider.of<UserProfileBloc>(context).user.permissions?.firstWhere(
            (value) => value.toLowerCase() == permissionFor.toLowerCase(),
        orElse: () => "", // Return null if not found
      ) !=
          "";
    }

    return status;
  }

}
