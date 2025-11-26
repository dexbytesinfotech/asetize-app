abstract class ConstantC {
  static const String imageNotFoundC =
      'https://user-images.githubusercontent.com/24848110/33519396-7e56363c-d79d-11e7-969b-09782f5ccbab.png';
  static const defaultProfileImage =
      "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b5/Windows_10_Default_Profile_Picture.svg/2048px-Windows_10_Default_Profile_Picture.svg.png";
  static String getGoogleMapStaticImageUrl(
          {String address = "",
          var latitude,
          var longitude,
          String googleMapKey = ""}) =>
      "https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&"
      "zoom=6&"
      "size=600x300%20&"
      "markers=color:0xffc3f5%7Clabel:%7C$latitude,$longitude&"
      "style=feature:road%7Celement:geometry%7Cvisibility:simplified%7Ccolor:0xf5f5f5&"
      "style=feature:water|color:0xc9c9c9&"
      "key=%20$googleMapKey";
}




abstract class ApiConst {

  static const bool isProduction = false;

  static const String baseUrlDevC =
      'https://api-community.dexbytes.in/'; //Development

  static const String baseUrlProC =
      'https://api.societypilot.com/';// Production

  static const String baseUrlC = isProduction ? baseUrlProC : baseUrlDevC;

  static const String baseUrlNonHttpC = "api-community.dexbytes.in";

  static const String baseUrlNonProdHttpC = "api.societypilot.com";

  //API Constants
  static const String userLogin =
      '${baseUrlC}api/customer/login-by-email';
  static const String userLogout =
      '${baseUrlC}api/customer/logout';
  static const String userProfile =
      '${baseUrlC}api/customer/v2/profile';
      // '${baseUrlC}api/customer/profile';
  static const String teamDetails =
      '${baseUrlC}api/user';
  static const String noticeBoardContent =
      '${baseUrlC}api/announcements';

  static const String searchVehicle =
      '${baseUrlC}/api/vehicles/find';

  static const String handymanList =
      '${baseUrlC}api/handyman';

  static const String myUnitInvoices =
      '${baseUrlC}api/invoices';

  static const String myUnitLatestInvoices =
      '${baseUrlC}api/invoices/latest';

  static const String myUnitPayment =
      '${baseUrlC}api/payments';

  static const String businessDetails =
      '${baseUrlC}api/user';

  static const String deleteProfile =
      '${baseUrlC}api/customer/delete';

  static const String profileUpdate =
      '${baseUrlC}api/customer/setting-update';
  //   api/customer/profile-update
  static const String faqUser =
      '${baseUrlC}api/faq/user/member';

  static const String aboutUs =
      '${baseUrlC}api/page/get-by-slug/about-us';
  static const String changePasswords =
      '${baseUrlC}api/customer/change-password';
  static const String updateProfilePhotos =
      '${baseUrlC}api/media';
  static const String homeData =
      '${baseUrlC}api/home';
  static const String birthdayData =
      '${baseUrlC}api/birthday/list';
  static const String workAnniversaryData =
      '${baseUrlC}api/workanniversary/list';
  static const String marriageAnniversaryData =
      '${baseUrlC}api/marriageanniversary/list';
  static const String eventData =
      '${baseUrlC}api/events';

  static const String holidayData =
      '${baseUrlC}api/holidays';

  static const String feedPostData =
      '${baseUrlC}api/posts';

  static const String announcementPostData =
      '${baseUrlC}api/posts';

  static const String leaveType =
      '${baseUrlC}api/leave/types';

  static const String leaveApply =
      '${baseUrlC}api/leaves';

  static const String leaveDataList =
      '${baseUrlC}api/leaves';

  static const String notificationDataList =
      '${baseUrlC}api/customer/notifications';

  static const String postLikeApi =
      '${baseUrlC}api/posts/like';

  static const String singleNotificationPostApi =
      '${baseUrlC}api/posts';

  static const String leaveDataByID =
      '${baseUrlC}api/leaves';

  static const String teamLeaveData =
      '${baseUrlC}api/team/leaves';

  static const String leaveStatusChange =
      '${baseUrlC}api/team/leaves/status';

  static const String teamLeaveDataByID =
      '${baseUrlC}api/team/leaves';

  static const String notificationDisplay =
      '${baseUrlC}api/customer/notification/display';

  static const String notificationRead =
      '${baseUrlC}api/customer/notification/read';

  static const String notificationReadDisplay =
      '${baseUrlC}api/customer/notification/read-display';

  static const String familyApi =
      '${baseUrlC}api/family';


  static const String vendorList =
      '${baseUrlC}api/assets/vendor';


  static const String addVendor =
      '${baseUrlC}api/assets/vendor';

  static const String policyData =
      '${baseUrlC}api/policy';

  static const String postComment =
      '${baseUrlC}api/posts/comment';

  static const String postCreate =
      '${baseUrlC}api/user/posts';

  static const String spotlightCreate =
      '${baseUrlC}api/user/spotlight';

  static const String userPostData =
      '${baseUrlC}api/user/posts';

  static const String deleteUserPost =
      '${baseUrlC}api/user/posts';

  static const String deleteComment =
      '${baseUrlC}api/posts/comment';

  static const String spotlightData =
      '${baseUrlC}api/spotlight';

  static const String spotlightRecentData =
      '${baseUrlC}api/spotlight-recent';

  static const String likeSpotlight =
      '${baseUrlC}api/spotlight/like';

  /// post and delete spotlight comment API
  static const String spotlightComment =
      '${baseUrlC}api/spotlight/comment';

  /// get and delete user spotlight API
  static const String userSpotlight =
      '${baseUrlC}api/user/spotlight';

  static const String announcementsApi =
      '${baseUrlC}api/announcements';

  static const String guestCustomerLogin =
      '${baseUrlC}api/guest/customer/login-by-email';

  static const String verifyOtp =
      '${baseUrlC}api/guest/customer/verify-otp';

  static const String resendOtp =
      '${baseUrlC}api/guest/customer/resend-otp';

  static const String updateToken =
      '${baseUrlC}api/customer/push-device-update';

  static const String addVehicle =
      '${baseUrlC}api/vehicles';

  static const String findVehicle =
      '${baseUrlC}api/vehicles/findv2/';
  static const String myVehicleList =
      '${baseUrlC}api/vehicles';
  static const String deleteMyVehicle =
      '${baseUrlC}api/vehicles/';

  static const String deleteNocRequest =
      '${baseUrlC}api/nocs/';

  static const String deleteUpcomingVisitor =
      '${baseUrlC}api/pre/visitor/';

  static const String deletePayee =
      '${baseUrlC}api/beneficiaries/';

  static const String deleteTaskComment =
      '${baseUrlC}api/tasks';

  static const String deleteQuotation =
      '${baseUrlC}api/quotations';

  static const String deleteTaskFollowUp =
      '${baseUrlC}api/tasks';

  static const String deleteTask =
      '${baseUrlC}api/tasks';


  static const String deleteExpenses =
      '${baseUrlC}api/expenses/';

  static const String deleteDuplicateEntry =
      '${baseUrlC}api/receipt/message/';

  static const String totalDues =
      '${baseUrlC}api/invoices/dues';

  static const String commiteeMembers =
      '${baseUrlC}api/committee/users';

  static const String taskMembers =
      '${baseUrlC}api/task/users';

  static const String complaintCategoryList =
      '${baseUrlC}api/ticket/category';

  static const String complaintList =
      '${baseUrlC}api/tickets';

  static const String applyComplaint =
      '${baseUrlC}api/tickets';

  // static const String complaintDetail =
  //     '${baseUrlC}api/ticket/{id}';

  static const String houseBlock =
      '${baseUrlC}api/blocks';

  static const String invoicesSummary =
      '${baseUrlC}api/invoices/summary';

  static const String monthlySummary =
      '${baseUrlC}api/monthly/summary';

  static const String managerMonthlySummary =
      '${baseUrlC}api/manager/monthly/summary';

  static const String invoicesStatement =
      '${baseUrlC}api/invoices/statements';

  static const String updateStatus =
      '${baseUrlC}api/tickets';

  static const String postComplaintComment =
      '${baseUrlC}api/tickets/comment';

  static const String expenseCategory =
      '${baseUrlC}api/expenses/category';

  static const String postExpenses =
      '${baseUrlC}api/expenses';


  static const String uploadVouchers =
      '${baseUrlC}api/expenses/upload-vouchers';

  static const String paymentMethod =
      '${baseUrlC}api/payments/methods';

  static const String complaintDetail =
      '${baseUrlC}api/tickets/show';
  static const String addTransactionReceipt =
      '${baseUrlC}api/invoices/pending';

  static const String paymentSummary =
      '${baseUrlC}api/history/summary';

  static const String printStatement =
      '${baseUrlC}api/payments/receipt/print';

  static const String addNewPayee =
      '${baseUrlC}api/beneficiaries';

  static const String paymentHistory =
      '${baseUrlC}api/history';

  static const String paymentHistoryDetail =
      '${baseUrlC}api/history/detail';

  static const String invoiceHistoryDetail =
      '${baseUrlC}api/invoices/detail';
  static const String casePayment =
      '${baseUrlC}api/payments/pay';

  static const String submitUploadTransactionReceipt =
      '${baseUrlC}api/receipt/message';
  static const String getListOfReceipts =
      '${baseUrlC}api/receipt/message/user';
  static const String addAccountTransactionReceipt =
      '${baseUrlC}api/account/invoices/pending';

  static const String getPendingList =
      '${baseUrlC}api/receipt/message';
  static const String rejectReceipt =
      '${baseUrlC}api/receipt/message/';

  static const String expenseApproved =
      '${baseUrlC}api/expenses';

  static const String signUpApi =
      '${baseUrlC}api/community/signup';

  static const String sentOTPForMobileNumberVerification =
      '${baseUrlC}api/otp/send';


  static const String otpVerification =
      '${baseUrlC}api/otp/verify';

  static const String termsAndCondition =
      '${baseUrlC}api/page/get-by-slug/';


  static const String guestEmailLogin =
      '${baseUrlC}api/guest/customer/login-by-email';

  static const String guestOtpVerify =
      '${baseUrlC}api/guest/customer/verify-otp';

  static const String guestOtpResend =
      '${baseUrlC}api/guest/customer/resend-otp';

  static const String guestUpdateProfile =
      '${baseUrlC}api/customer/profile-update';

  static const String guestSearchByCompany =
      '${baseUrlC}api/company';

  static const String guestCompanyJoin =
      '${baseUrlC}api/company/join';

  // static const String guestProfile =
  //     '${baseUrlC}api/guest/customer/profile';

  static const String invoicesManagerSummary =
      '${baseUrlC}api/manager/invoices/summary';

  static const String invoicesManagerStatement =
      '${baseUrlC}api/manager/invoices/statements';

  static const String invoicesManagerDetail =
      '${baseUrlC}api/manager/invoices/detail';

  static const String paymentsManagerDetail =
      '${baseUrlC}api/manager/invoices/transactions';

  static const String addVehicleForManager =
      '${baseUrlC}api/company/info';

  static const String getHouseDetail =
      '${baseUrlC}api/house/details';

  static const String setPrimaryMember =
      '${baseUrlC}api/house/set-primary-memeber';


  static const String enableDisableContact =
      '${baseUrlC}api/house/enable-disable-contact-display';

  static const String addMemberByManager =
      '${baseUrlC}api/house/add-memeber';

  static const String verifyPhoneNumber =
      '${baseUrlC}api/user/find-by-mobile';

  static const String allVehicleList =
      '${baseUrlC}api/vehicles';

  static const String newProfileUpdate =
      '${baseUrlC}api/customer/profile-update';

  static const String systemSettings =
      '${baseUrlC}api/system/settings';

  static const String contactShowStatusUpdate =
      '${baseUrlC}api/house/user-enable-disable-contact-display';

  static const String deleteMember =
      '${baseUrlC}api/house/delete-memeber';

  static const String loginByMobile =
      '${baseUrlC}api/guest/customer/login-by-mobile';

  static const String invoiceTransaction =
      '${baseUrlC}api/invoices/transactions';

  static const String invoiceManagerTransaction =
      '${baseUrlC}api/manager/invoices/transactions';

  static  const String paymentReceipt =
      '${baseUrlC}api/payments/receipt';

  static const String generateTitleDescription =
      '${baseUrlC}api/tasks/generate-title-description';

  static const String addAssetCategory =
      '${baseUrlC}api/assets/category';


  static const String generatedVoucher =
      '${baseUrlC}api/expenses/generate-voucher';

  static const String notificationCountApi =
      '${baseUrlC}api/notification/notification-count';

  static const String petApi =
      '${baseUrlC}api/pets';

  static const String updateNoc =
      '${baseUrlC}api/nocs';

  static const String updatePreVisitor =
      '${baseUrlC}api/pre/visitor';

  static const String updateExpenses =
      '${baseUrlC}api/expenses';

  static const String suspenseEntry =
      '${baseUrlC}api/payments/suspense/pay';

  static const String suspenseHistoryList =
      '${baseUrlC}api/payments/suspense/list';

  static const String suspenseHouseAssign =
      '${baseUrlC}api/payments/suspense/assign';

  static const String visitorCheckoutAPi =
      '${baseUrlC}api/house/visitor';

  static const String nocList =
      '${baseUrlC}api/nocs';

  static const String payeeList =
      '${baseUrlC}api/beneficiaries';

  static const String assetsCategory =
      '${baseUrlC}api/assets/category';


  static const String assetsLocations =
      '${baseUrlC}api/assets/locations';


  static const String showDummyData =
      'https://jsonplaceholder.typicode.com/users';

  static const String getVoucherNumber =
      '${baseUrlC}api/vouchers/next';


  static const String getTaskFiltersList =
      '${baseUrlC}api/filters/tasks';


  static const String howToPayList =
      '${baseUrlC}api/company/how-to-pay';

  static const String nocListUpdate =
      '${baseUrlC}api/nocs';

  static const String expensesUploadVoucher =
      '${baseUrlC}api/expenses/upload-voucher';

  static const String updatePayee =
      '${baseUrlC}api/beneficiaries';

  static const String markTaskAsComplete =
      '${baseUrlC}api/tasks';


  static const String addQuotation =
      '${baseUrlC}api/tasks';


  static const String assignTask =
      '${baseUrlC}api/tasks';


  static const String approvedQuotation =
      '${baseUrlC}api/quotations';



  static const String rejectQuotation =
      '${baseUrlC}api/quotations';



  static const String updateTaskComment =
      '${baseUrlC}api/tasks';


  static const String createFollowUp =
      '${baseUrlC}api/tasks';

  static const String updateFollowUp =
      '${baseUrlC}api/tasks';

  static const String onCommentOnTask =
      '${baseUrlC}api/tasks';
  static const String getCommentList =
      '${baseUrlC}api/tasks';


  static const String getAssetDetailList =
      '${baseUrlC}api/assets';

  static const String taskHistoryList =
      '${baseUrlC}api/tasks';

  static const String getQuotationsList =
      '${baseUrlC}api/tasks';

  static const String paymentCancel =
      '${baseUrlC}api/payments';

  static const String paymentSuccess =
      '${baseUrlC}api/payments';

  static const String nocSubmit =
      '${baseUrlC}api/nocs';

  static const String paymentsInitiate =
      '${baseUrlC}api/payments/initiate';

  static const String paymentGatewayDetail =
      '${baseUrlC}api/gateways/details';

  static const String preVisitorSubmitApi =
      '${baseUrlC}api/pre/visitor';

  static const String createTask =
      '${baseUrlC}api/tasks';

  static const String updateTask =
      '${baseUrlC}api/tasks';

  static const String brokerList =
      '${baseUrlC}api/brokers';

  static const String addAsset =
      '${baseUrlC}api/assets';


  static const String assetFilterList =
      '${baseUrlC}api/assets/filters';


  static const String assetStatusChange=
      '${baseUrlC}api/assets';

  static const String updateAsset=
      '${baseUrlC}api/assets';

  static const String assetsMemberList =
      '${baseUrlC}api/assets/members';

  static const String unassignedBarcodesAssets =
      '${baseUrlC}api/barcodes/unassigned-assets';

  static const String assignedBarcodesToAssets =
      '${baseUrlC}api/barcode/assign';

  static const String assetConfirmation=
      '${baseUrlC}api/assets';

  static const String assetAcceptRemainder=
      '${baseUrlC}api/assets';


  static const String assetHistory=
      '${baseUrlC}api/assets';


}
