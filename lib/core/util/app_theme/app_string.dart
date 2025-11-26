import 'dart:core';

import 'package:flutter/material.dart';
import 'package:asetize/core/util/utils.dart';

abstract class AppString {
  static BuildContext? context;

  //appString.trans(context,appString.basicInfo);
  static String trans(BuildContext context, String key) {
    if (key.trim() != "") {
      var data = AppLocalizations.of(context)?.translate(key);
      if (data == null) {
        return "";
      }
      return data;
    } else {
      return "";
      return "";
    }
  }
  static const String sellerName = 'Seller Name';
  static const String updateButton = 'Update';
  static const String set = 'Set';
  static const String otherDetail = 'Other Detail';
  static const String enterOtherDetail = 'Enter Other Detail';
  static const String searchPayee = 'Search Payee';
  static const String selectPayee = 'Select Payee To'; // Added for the payee field
  static const String enterChequeNumber = 'Enter Cheque Number'; // Added for the payee field
  static const String enterVoucherNumber = 'Enter Voucher Number'; // Added for the payee field

  static const String addNewPayee = 'Add New Payee';
  static const String updatePayee = 'Update';
  static const String editPayee = 'Edit Payee';
  static const String voucherNumber = 'Voucher Number: ';
  static const String chequeNumber = 'Cheque Number';
  static const String ownerName = 'Owner Name';
  static const String deletePayeeTitle = "Delete Payee";
  static const String deleteExpenseTitle = "Delete Expense";
  static const String deletePayeeContent = "Are you sure you want to delete this payee? This action cannot be undone.";
  static const String deleteExpenseContent = "Are you sure you want to delete this expense? This action cannot be undone.";
  static const String issuedDate = 'Issued Date';
  static const String approvedBy = 'Approved By';
  static const String rejectedBy = 'Rejected By';
  static const String approvedDate = 'Approved Date';
  static const String reasonForRejection = 'Reason for Rejection';
  static const String payees = 'Payees';
  static const String noPayeesFound = 'No Payees Found';



  // Conditional strings
  static const String saleOfProperty = 'Sale of Property';
  static const String rentalAgreement = 'Rental Agreement';
  static const String selectCountry = '';
  static const String sellerHouseNumber = 'Seller House Number';
  static const String requestedBy = 'Requested By';
  static const String buyerName = 'Buyer Name';
  static const String buyerAddress = 'Buyer Address';
  static const String buyerPhoneNumber = 'Buyer Phone Number';
  static const String ownerHouseNumber = 'Owner House Number';
  static const String tenantName = 'Tenant Name';
  static const String tenantPhoneNumber = 'Tenant Phone Number';
  static const String tenantAddress = 'Tenant Address';
  static const String policeVerificationStatus = 'Police Verification Status';
  static const String brokerNameKey = 'Broker Name';
  static const String submissionDate = 'Submission Date';
  static const String issueDate = 'Issue Date';
  static const String remarks = 'Remarks';
  static const String enterRemarks = 'Enter remark';
  static const String remark = 'Remark';
  static const String purpose = 'Purpose';
  static const String addressRequired = 'Address is required';
  static const String policeVerificationRequired = 'Please select police verification status'; // Used in validateFields
  static const String descriptionFieldRequired = 'The description field is required';
  static const String categoryFieldRequired = 'The category field is required';
  static const String paymentModeFieldRequired = 'The payment mode field is required';
  static const String amountFieldRequired = 'The amount field is required';
  static const String selectProfession = 'Select Profession';
  static const String selectExpenseDate = 'Select Expense Date';
  static const String enterDescription = 'Enter a Description';
  static const String description = 'Description';
  static const String preRegisterVisitor = 'Pre-Register Visitor';
  static const String preApproval = 'Create Visitor Pass';
  static const String visitorType = 'Visitor Type';
  static const String selectVisitDate = 'Select Visit Date';
  static const String selectVisitDateHint = 'Select visit date';
  static const String selectVisitTime = 'Select Visit Time';
  static const String selectVisitTimeHint = 'Select visit time';
  static const String timeMustBeFuture = 'Time must be future';
  static const String invalidTimeFormat = 'Invalid time format';
  static const String visitPurpose = 'Visit Purpose';
  static const String selectTheVisitorType = 'Select visitor type';
  static const String selectTheVisitPurpose = 'Select visit purpose';
  static const String visitorTypeRequired = 'Visitor type required';
  static const String dateRequired = 'Date required';
  static const String timeRequired = 'Time required';
  static const String visitTypeRequired = 'Visit purpose required';
  static const String suspensePaymentsAppbar = "Suspense Payments";
  static String nocTitleFor(String title, String? status) {
    final isDetail = status == 'approved' || status == 'issued';
    return isDetail ? 'NOC Detail for $title' : 'NOC Request for $title';
  }

  static String requestNOCFor(String title) => 'NOC Request for $title';

  static String nameRequiredError = 'Name is required';
  static const String visitorHistory = "Visitor History";
  static const String suspensePaymentsLabel = "Suspense Payments";
  static const String managePayee = "Manage Payee";

  static String unitRequiredError = 'Please select a unit';
  static const String appName = 'Base Flutter App';
  static const String visitorAllowSuccessfully = "Visitor Allow successfully";
  static const String visitorInvitedSuccessfully = "Visitor invited successfully.";
  static const String nocDeletedSuccessfully = "Noc Deleted Successfully.";
  static const String upcomingVisitorDeletedSuccessfully = "Upcoming Visitor Deleted Successfully.";

  static const String visitorDenySuccessfully = "Visitor Deny successfully";
  static const String allPrevious = 'All Previous';
  static const String upcomingVisitors = 'Upcoming Visitors';
  static const String today = 'Today';
  static const String myVisitor = 'My Visitor';
  static const String requestForNOC = 'Request For NOC';

  static const String suspiciousAmount = 'Suspense Amount';
  static const String assignToHouse = 'Assign to House';
  static const String warningMessageAssignToHouse = 'Assigning a house to suspense is a one-time action and cannot be undone. Double-check your selection before continuing.';
  static const String profileSetup = 'profileSetup';
  static const String showerBegins = 'showerBegins';
  static const String start = 'start';
  static const String submit = "Submit";
  static const String saveAndAddNew = "Save & Add New";
  static const String generateVoucher = "Generate Voucher";
  static const String voucherImage = "Voucher Image";
  static const String taskImage = "Task Image";
  static const String workOrderImage = "Work Order Image";
  static const String taskImages = "Task Images";
  static const String quotationImage = "Quotation Image";
  static const String add = "Add";
  static const String editExpense = "Edit Expense";
  static const String transfer = "Transfer";
  static const String selectUnitWithStar = 'Select Unit *';
  static const String continueBt = 'continue';
  static const String society = 'Search Your Society';
  static const String addHome = 'Add Home';
  static const String findAHelper = 'Find a Help';
  static const String searchSociety = 'Search Your Society';
  static const String searchFlatNumber = 'Search Flat Number';
  static const String searchYourFlatNumber = 'Search Your  Flat Number';
  static const String searchBlock = 'Search Block';
  static const String searchHouseNumber = 'Search House Number';
  static const String searchHouseNumberHint = 'Search house number';
  static const String searchMember = 'Search members';
  static const String next = 'next';
  static const String nexts = 'Pre-Register Visitor';
  static const String sendOtp = 'Send OTP';
  static const String getStartedNew = 'Get Started';
  static const String verify = 'Verify';
  static const String flatNumber = 'Flat Number';
  static const String createProfile = 'createProfile';
  static const String nextSmall = 'nextSmall';
  static const String editPhoto = 'editPhoto';
  static const String choose = 'choose';
  static const String addPhoto = 'addPhoto';
  static const String remove = 'remove';
  static String registrationErrorFormat =
      "Please enter at least 8 characters";
  static String blockErrorFormat =
      "lease enter at least 8 characters";

  static const String pleaseEnterPassword = 'pleaseEnterPassword';
  static const String pleaseEnterCurrentPassword = 'pleaseEnterCurrentPassword';
  static const String pleaseReEnterPassword = 'pleaseReEnterPassword';
  static const String firstName = 'firstName';
  static const String firstNameLabel = 'First Name';
  static const String firstNameCapital = 'First Name';
  static const String name = 'name';
  static const String nameCapital = 'Name';
  static const String chooseAvatar = 'chooseAvatar';
  static const String age = 'age';
  static const String enterValidEmail = 'enterValidEmail';
  static const String enterAPassword = 'enterAPassword';
  static const String enterValidPassword = 'enterValidPassword';
  static const String enterFirstEmail = 'enterFirstEmail';
  static const String signUpEmail = 'signUpEmail';
  static const String welcome = 'welcome';
  static const String signInTitle = 'signInTitle';
  static const String verificationCodeTitle = 'verificationCodeTitle';
  static const String acceptTermsCondition1 = 'acceptTermsCondition1';
  static const String terms = 'terms';
  static const String and = 'and';
  static const String policy = 'Policy';
  static const String privacyPolicy = 'privacyPolicy';
  static const String pleaseEnterNewPassword = 'pleaseEnterNewPassword';
  static const String changePassword = 'changePassword';
  static const String newPassword = 'newPassword';
  static const String currentPassword = 'currentPassword';
  static const String confirm = 'confirm';
  static const String email = 'email';
  static const String swipeToStart = 'swipeToStart';
  static const String pleaseEnterEmail = 'pleaseEnterEmail';
  static const String loginT = 'login';
  static const String createAccountButton = 'createAccountButton';
  static const String newCode = 'newCode';
  static const String lastName = 'Last Name';
  static const String password = 'password';
  static const String passwordCapital = 'Password';
  static const String verificationCode = 'verificationCode';
  static const String confirmPassword = 'Confirm Password';
  static const String enterFirstName = 'Enter Your First Name';
  static const String enterName = 'enterName';
  static const String enterLastName = 'Enter Your Last Name';
  static const String enterLastNameHint = 'Enter last name';
  static const String enterPassword = 'Enter Password';
  static const String enterVerificationCode = 'enterVerificationCode';
  static const String enterConfirmPassword = 'Enter Confirm Password';
  static const String howManyEmployees = 'howManyEmployees';
  static const String createPassword = 'createPassword';
  static const String mustContain1LetterAndNumber =
      'mustContain1LetterAndNumber';
  static const String passwordContain =
      'The password must be at least 8 characters.';
  static const String completeSetUPButton = 'completeSetUPButton';
  static const String validName = 'validName';
  static const String signIn = 'signIn';
  static const String back = 'back';
  static const String signUpButton = 'signUpButton';
  static const String createAPassword = 'createAPassword';

  static const String send = 'send';
  static const String sendButton = 'Send';
  static const String payOut = "PAY OUT";
  static const String payIn = "PAY IN";
  static const String approved = "Approved";
  static const String enterReceiptNumber = "Enter receipt number";
  static const String receiptNumber = "Receipt Number";
  static const String approveRequest = 'Approve Request';

  static const String assetConfirmation= 'Asset Confirmation';
  static const String confirmSuspenseEntry = 'Confirm Suspense Entry';
  static const String signOut = 'signOut';
  static const String aboutDrawer = 'aboutDrawer';

  static const String requestNOC = 'Request NOC';
  static const String submitNocPayment = 'Submit NOC Payment';
  static const String createVisitorPass = 'Create Visitor Pass';
  static const String updateVisitorPass = 'Update Visitor Pass';
  static const String submitRequest = 'Submit Request';
  static const String editProfile = 'editProfile';
  static const String passwordLength = 'passwordLength';
  static const String viewProfile = 'viewProfile';
  static const String titleText = 'titleText';
  static const String departmentText = 'departmentText';
  static const String save = 'save';
  static const String saveButton = 'Save';

  static const String tryAgain = 'Something went wrong please try again';
  //Button text
  static const String buttonSave = "buttonSave";
  static const String buttonUpdate = "buttonUpdate";
  static const String buttonCancel = "Cancel";
  static const String buttonApply = "Apply";
  static const String buttonConfirm = "Confirm";
  static const String buttonGallery = "Media";
  static const String buttonCamera = "Photo";
  //Alert message
  static const String logoutConfirmation = "logoutConfirmation";

  static const String deletePostMessage = "Are you sure to delete this post?";
  static const String deleteGroupChannelMessage =
      "Are you sure to delete this Group Channel?";
  static const String leftGroupMessage = "Are you sure to left this group?";
  static const String noInternetConnection =
      "No internet connection available. Please check your network!";
  static const String noText = "No";
  static const String yesText = "Yes";

  static const String notificationHeading = 'notificationHeading';

  static const String general = 'general';

  //error messages
  static const String passwordNotBlank = 'Please enter the password.';
  static const String screenTermsAndConditions = "Terms and conditions";

  //Login screen static const Strings
  static const String contactText =
      "If you have problems to login, please get in contact at ";
  static const String acceptTermsAndConditions =
      'Check here to indicate that you have read and agree to the "';
  static const String termsAndConditions = 'terms of the main flutter app';

  static const String messageHeading = 'messageHeading';
  static const String messageScreenSubtitle1 = 'messageScreenSubtitle1';
  static const String chatBoxHintText = 'chatBoxHintText';

  //Contact email id
  static const String contactEmail = "dexbytes@gmail.com";

  static const String emailNotBlank = 'Please enter your number';
  static const String validEmail = 'Please enter a valid mobile number.';

  //confirmation message
  static const String confirmationMessage =
      "Are you sure you want to delete this notification?";
  static const String confirmationLogoutMessage =
      "Are you sure you want to sign out?";

  static const String confirmationChangePasswordOTPMessage =
      "It will send an OTP to your email, Do you want to change your password?";

  static const String confirmationChangeEmailOTPMessage =
      "It will send an OTP to your email, Do you want to change your email?";
  static const String confirmationExitMessage =
      "Are you sure you want to exit from the app?";
  static const String confirmationDeletePostMessage =
      "Are you sure you want to delete this post?";
  static const String confirmationDeleteGroupMessage =
      "Are you sure you want to delete this group?";
  static const String confirmationLeftGroupMessage =
      "Are you sure you want to leave this group?";

  static const String dateFormat = 'dd/MM/yyyy';
  static const String timeFormat = 'hh:mm a';

  static const String logout = 'logout';

  static const String signUpText = "signUpText";
  static const String signUpWith = "signUpWith";
  static const String personalEmail = "personalEmail";
  static const String recommendedText = "recommendedText";
  static const String contactWillText = "contactWillText";
  static const String hintText = "hintText";
  static const String continueBtnT = "continueBtnT";
  static const String byTappingText = "byTappingText";
  static const String termsOfServices = "termsOfServices";
  static const String contactManagement = "contactManagement";
  static const String signUpToday = "signUpToday";
  static const String noPaymentRequired = "noPaymentRequired";
  static const String getStarted = "getStarted";
  static const String step1Of2 = "step1Of2";
  static const String secretCode = "secretCode";
  static const String codeExpires = "codeExpires";
  static const String junkFolder = "junkFolder";
  static const String resendCode = "resendCode";
  static const String resendCodeNew = "resendCodeNew";
  static const String needHelp = "needHelp";
  static const String contactUs = "contactUs";
  static const String step2Of2 = "step20f2";
  static const String enterYourName = "enterYourName";
  static const String headingFirstName = "First Name";
  static const String headingLastName = "Last Name";
  static const String howManyContactText = "howManyContactText";
  static const String firstBtnValue = "firstBtnValue";
  static const String secondBtnValue = "secondBtnValue";
  static const String thirdBtnValue = "thirdBtnValue";
  static const String swipeBtn = "swipeBtn";
  static const String stepText2Of2 = "stepText2Of2";
  static const String signInText = "signInText";
  static const String signInEmail = "signInEmail";
  static const String hiNickText = "hiNickText";
  static const String setUpYours = "setUpYours";
  static const String step1Of3 = "step1Of3";
  static const String importContact = "importContact";
  static const String skip = "skip";
  static const String capitalSkip = "Skip";
  static const String nextBtn = "nextBtn";
  static const String didntReceiveCode = 'didntReceiveCode';
  static const String pleaseEnterOtp = "pleaseEnterOtp";
  static const String pleaseEnterCorrectOtp = "pleaseEnterCorrectOtp";
  static const String invalidName = 'invalidName';
  static const String enterFullName = "enterFullName";
  static const String phoneNumber = 'phoneNumber';
  static const String correctPhone = 'correctPhone';
  static const String enterValidAddress = "enterValidAddress";
  static const String errorSelectTheUnit = "Please Select The Unit ";
  static const String errorForEnterAmount = "Please Enter Amount ";
  static const String enterEmail = "Enter Email  ";
  static const String enterEmailHint = "Enter Email  ";

  static const String emailHintError = "Please enter a valid email.";
  static const String emailHintError1 = "Email cannot be empty.";
  static const String transactionReceiptUpload = "Payment Screenshot";
  static const String addTransactionReceipt = "Add Transaction Receipt";
  static const String uploadHint = "Allowed types: jpeg, png, jpg";
  static const String uploadSizeHint = "Up to 5MB size";
  static const String uploadMaxImageHint = "Maximum of 1 image";
  static const String selectUnitHint = "Select The Unit";
  static const String houseFlatNumber = "House / Flat Number";
  static const String enterReason = "enterReason";
  static const String enterCustomerId = "enterCustomerId";
  static const String errorMessageSelectUnit = "emailHintError";
  static const String nameError = "Please enter name";
  static const String registrationError = "Please enter a valid registration number.";
  static const String blockError = "Please enter Block";
  static const String vehicleTypeError = "Please select vehicle type";
  static const String vehicleMakeError = "Please select vehicle make";
  static const String vehicleModelError = "Please select vehicle model";
  static const String vehicleColorError = "Please select vehicle color";
  static const String workEmail = "workEmail";
  static const String confirmPasswordName = "confirmPasswordName";
  static const String invalidCurrentPassword = "invalidCurrentPassword";
  static const String pleaseEnterNewCPassword = 'pleaseEnterNewCPassword';
  static const String passwordMustBeSame = "passwordMustBeSame";
  static const String pleaseReEnterConfirmPassword =
      'pleaseReEnterConfirmPassword';

  static const String deleteConfirmation = "deleteConfirmation";
  static const String deletePopupTitle = "deletePopupTitle";
  static const String deletePopupContent = "deletePopupContent";
  static const String upcomingBirthday = "Upcoming Birthday";
  static const String upcomingWorkAnniversary = "Upcoming Work Anniversaries";
  static const String upcomingMarriageAnniversary =
      "Upcoming Marriage Anniversaries";
  static const String upcomingHoliday = "Upcoming Holidays";
  static const String events = "Events";
  static const String noEvents = 'No Events';
  static const String announcements = "Announcements";
  static const String errorFetchingContacts = "Error fetching contacts:";
  static const String todayLeave = "On Leave Today";
  static const String whfLeave = "On WFH Today";
  static const String faq = "FAQ";
  static const String noFaq = "No FAQ";
  static const String birthdays = "Birthdays";
  static const String noBirthdays = "No birthday";
  static const String noUpcomingBirthdays = "No upcoming birthday";
  static const String event = "Events";
  static const String aboutUS = "About Us";
  static const String allTicket = "All Ticket";
  static const String announcement = "Announcement";
  static const String noAnnouncement = 'No Announcement';
  static const String somethingWentWrong = 'Something went wrong here...';
  static const String technicalIssue =
      'Sorry we are having some technical issue.You may refresh the page or try again later';
  static const String noUpComingWA = 'No upcoming work anniversary';
  static const String addFamily = "Add Family Member Details";
  static const String editFamily = "Edit Family Member Details";
  static const String memberAdded = "Member Added successfully";
  static const String memberEdited = "Member Details edited successfully";
  static const String workAnniversary = 'Work Anniversaries';
  static const String noWorkAnniversary = 'No WorkAnniversary';
  static const String noWhf = 'No WHF on today';
  static const String noLeaveToday = 'No leave on today';
  static const String noDataFound = 'No data found';
  static const String ourTeam = 'Our Team';
  static const String members = 'Members';
  static const String familyMembers = 'Family Members';
  static const String myFamily = 'My Family';
  static const String vehicles = 'Vehicles';
  static const String newOwner = 'New Owner:';
  static const String newTenant = 'New Tenant:';
  static const String passwordUpdated = 'Password updated successfully';
  static const String changePasswordTitle = 'Change Password';
  static const String ok = "OK";
  static const String posts = 'Posts';
  static const String feedback = 'Feedback';
  static const String home = 'Home';
  static const String businessDetails = 'Business Details';
  static const String noticeBoard = 'Notice Board';
  static const String business = 'Business';
  static const String businessAssociatedMembers = 'Associated Members';
  static const String noPosts = 'No Posts';
  static const String holidays = 'Holidays';
  static const String newVersionReady = 'New Version Is Ready!';
  static const String committee = 'Committee';
  static const String noHolidays = 'No Holiday';
  static const String enterVehicleNumber = 'Enter vehicle number';
  static const String receiptsUploadedSuccessfully =
      "Receipts uploaded successfully!";
  static const String pendingConfirmation = "Pending Confirmation";

  static const String updateNow = 'Update Now';
  static const String updateContent= "Get the security updates and improved features.";

  static const String oTPCodeVerification = "OTP Code Verification";
  static const String oTPVerification = "OTP Verification";
  static const String otpText = "We have sent an OTP on your email";
  static const String applicationSubmittedSuccessfully =
      "Your complaint has been successfully registered!";
  static const String profileUpdatedSuccessfully =
      "Profile updated successfully";
  static const String receipt = "Receipt";
  static const String joinHouseRequest= "Your request to join the house is still pending approval. You may follow up with the admin if needed.";
  static const String noPendingDues = "The amount will be credited as an advance payment and automatically deducted from the next bill";
  static const String selectTheGender = "Select The Gender";
  static const String selectTheRelationship = "Select The Relationship";
  static const String didNotReceiveTheCode = "Didn\'t receive the code?";
  static const String enterDigitCode = "Enter a 4-digit code";
  static const String invoices = "Invoices";
  static const String youCanResendCode = "You can resend code in ";
  static const String addPaymentNew = " Add Payment";
  static const String addPayment = "Payment";
  static const String expensesAddedSuccessfully =
      "Payment submitted successfully!";
  static const String paymentConfirmed =
      "Payment has been successfully confirmed!";
  static const String paymentRejected = "Payment has been Rejected!";
  static const String memberAddedSuccessfully = "Member Added Successfully";
  static const String yourRequestSendSuccessful =
      "Your request send  successful!";
  static const String otpSendSuccessfully = "OTP sent successfully.";
  static const String otpResendSuccessfully = "OTP resent successfully.";
  static const String otpVerifiedSuccessfully = "OTP verified successfully.";
  static const String welcomeToTheSocietyHub = "Welcome To The Society Pilot";
  static const String paymentConfirmation = "Payment Confirmation";
  static const String noUpcomingMA = 'No upcoming marriage anniversary';
  static const String marriageAnniversaries = 'Marriage Anniversaries';
  static const String noMarriageAnniversary = 'No MarriageAnniversary';
  static const String notifications = "Notifications";
  static const String noNotifications = 'No notifications';
  static const String settings = "Settings";
  static const String myUnit = "My Unit";
  static const String myUnits = "My Units";
  static const String signUp = "Sign Up";
  static const String completeProfile = "Complete Your Profile";
  static const String addMember = "Add Member";
  static const String addFamilyMember = "Add Family Member";
  static const String noSocietyFound = "No Society Found";
  static const String addSociety = "Add Society";
  static const String approvalStatus = "Approval Status";
  static const String approvalPending = "Approval Pending";
  static const String visitingDetail = 'Visiting Detail';
  static const String approvalPendingDescription =
      "Your account needs approval from your Society Office or Management Committee to ensure that only verified residents get access to Asetize.";
  static const String applicationSubmitted = "Application submitted to society";
  static const String invoiceCopy = "Invoice Copy";
  static const String howToPay = "How To Pay";
  static const String paymentDetails= "Payment Details";
  static const String selectNOC = "Select NOC";
  static const String followUpNotAdded = "Follow-up not added. Please add a follow-up before marking the task as completed.";
  static const String print = "Print";
  static const String flatNumberHint = "Flat/House Number";
  static const String pickADate = "Pick a date";
  static const String writeAdditionalNote = "Add any additional note here...";
  static const String nextFollowUpDate = 'Next Follow-up Date';
  static const String followUpStatus = 'Follow-up Status';
  static const String selectStatus = 'Select status';
  static const String houseOwner = "House Owner";
  static const String canceledSuccessfully = "Visitor pass canceled successfully.";
  static const String notice = "Notice";
  static const String selectFromContacts = 'Select from\nContacts';
  static const String addManually =     'Add\nManually';
  static const String   selectedGuest =   'Selected Guest';
  static const String nocReport = 'NOC Report';
  static const String pdfViewer = "PDF Viewer";
  static const String requestDetails =  'Request Details:';

  static const String enterAddress = 'Enter address';
  static const String enterFirstNameHint = 'Enter first name';
  static const String paymentReceipt = 'Payment Receipt';
  static const String voucher = 'Voucher';
  static const String addExpenses = 'Add Expenses';
  static const String category = "Category";
  static const String payeeTo = "Payee To";
  static const String selectPayeeTo = "Select Payee To";

  static const String  filters =  'Filters';
  static const String  chooseDuration =  'Choose Duration';
  static const String  enterAmount =  "Enter an Amount";
  static const String  apply =  'APPLY';
  static const String  selectVendor =  "Select vendor";
  static const String camera = "Camera";
  static const String gallery = "Gallery";

  static const String uploadedNocReport = 'Uploaded Noc Report';

  static const String uploadPDF = "Upload PDF";

  static const String additionalNotes = 'Additional Notes ';
  static const String pendingPoliceVerificationContent = 'Please be advised that the NOC cannot be processed until successful police verification of your prospective tenant.';
  static const String reasonForNOCRequired = 'Reason for NOC is required';
  static const String showNoDuesPopup = "You have no pending dues at the moment. Everything is up to date!";

  static const String nocPaymentPopup = "Requesting a No Objection Certificate (NOC) requires a payment of ₹300.";

  static const String remarkForNOCRequired = 'Remark for NOC is required';

  static const String titleReasonForNOC = 'Select Reason for NOC';
  static const String titleBroker = 'Select Broker Name';

  static const String enterAdditionalNotes = 'Enter additional notes';

  static const String requestedOn = "Requested on: ";
  static const String reasonForNOCLabel = 'Reason for NOC';
  static const String brokerName = 'Broker Name ';
  static const String nOCRequestDetail = 'NOC Request Detail';
  static const String selectReasonForNOC = 'Select reason for NOC *';
  static const String selectBrokerName = 'Select broker name';
  static const String recentTransactions = 'Recent Transactions';
  static const String contactPermissionRequired = 'Contact permission is required to select contacts.';
  static const String applicationSubmittedDescription =
      "We've sent your request to your society admin";
  static const String reminding = "We’re reminding";
  static const String  noFlatNumberFound =  'No flat number found';
  static const String selectYourBlock = 'Select Your Block/Tower';
  static const String blockTower = "Block/Tower";
  static const String searchVisitorsContacts = 'Search visitors contacts';
  static const String visitorsContacts = 'Visitors Contacts';
  static const String remindingDescription = "We send reminders every 24 Hours";
  static const String verificationByAdmin = "Verification by Society Admin";
  static const String verificationByAdminDescription =
      "Most approvals happen within 72 hours.";
  static const String findCarOwner = "Find Car Owner";
  static const String noContactsFound = 'No contacts found';
  static const String oneGuestMustBeSelected = 'At least one guest must be selected.';
  static const String findVehicle = "Find Vehicle";
  static const String findVehicleOwner = "Find Vehicle Owner";
  static const String myVehicle = "My Vehicle";
  static const String myVehicles = "My Vehicles";
  static const String selectTimeInFuture = 'Please select a time in the future.';
  static const String vehicleDetail = "Add Vehicle Detail";
  static const String suspenseEntry = "Suspense Entry";
  static const String nocRequestPayment = "NOC Request Payment";
  static const String nocRequest = 'NOC Request';
  static const String noc = 'NOC';
  static const String suspenseHistory = "Suspense History";
  static const String suspenseHistoryDetail = "Suspense Payment Detail";
  static const String suspenseHistoryLabel = "Suspense History";
  static const String suspenseHistoryTitle = "Suspense History";
  static const String complaintsAppBarHeading = "Complaints";
  static const String hurryFullPresent = 'Hurry! Full Present';
  static const String leaveWFH = 'Leave/WFH';
  static const String myLeave = 'My Leave';
  static const String selectVisitor = 'Select Visitor';
  static const String leaveRequests = "Leave Request's ";
  static const String leaveRequest = "Leave Request";
  static const String leaveDetails = "Leave Detail";
  static const String noLeaveDetails = 'No Leave Detail';
  static const String noLeaveRequest = 'No Leave Request';
  static const String history = 'History';
  static const String amountPayable = 'AMOUNT PAYABLE';
  static const String birthdayLeave = "Birthday Leave";
  static const String applyLeave = "Apply Leave";
  static const String requestConfirmation = 'Request Confirmation';
  static const String requestConfirmationContent =
      'Are you sure you want to accept the leave request?';
  static const String rejectConfirmation = 'Reject Confirmation';
  static const String rejectConfirmationContent =
      'Are you sure you want to reject the leave request?';
  static const String cancelLeave = 'Cancel Leave';
  static const String cancelLeaveContent =
      'Are your sure you want to cancel your leave?';
  static const String reject = 'Reject';
  static const String cancel = 'Cancel';
  static const String cancelRequest  = 'Cancel Request';
  static const String accept = 'Accept';
  static const String fetchDues = 'Fetch Invoice';
  static const String checkDues = 'Check Dues';
  static const String yes = 'Yes';
  static const String completed = 'Completed';
  static const String pending = 'Pending';
  static const String no = 'No';
  static const String leaveType = "Leave Type";
  static const String duration = "Duration";
  static const String totalLeaveDays = "Total Leave Days";
  static const String reason = "Reason";
  static const String reasonWithSemiColone = "Reason :";
  static const String lessDetails = 'Less Details';
  static const String downLoadAndShare = 'Download / Share Payment Receipt';
  static const String downLoadAndShareNOCReport = 'Download / Share NOC Report';
  static const String downLoadAndShareNocPaymentReceipt = 'View / Share NOC Payment ScreenShot';
  static const String moreDetails = 'More Details';
  static const String gitBucketUserName = "Gitbucket Username";
  static const String githubUsername = "Github Username";
  static const String skype = "Skype";
  static const String marriageAnniversary = "Marriage Anniversary ";
  static const String dob = "Date Of Birth";
  static const String alternatePhone = "Alternate phone";
  static const String alternateAddress = "Alternate Address";
  static const String address = "Address";
  static const String skills = "Skills";
  static const String doj = "Date Of Joining";
  static const String phone = "Phone";
  static const String post = "Post";
  static const String addNewComplaint = "Add New Complaint";
  static const String paymentScreenshots = "Payment Screenshots";
  static const String complaintDetail = "Complaint Detail";
  static const String noPost = 'No Post';
  static const String notFound = 'Not Found';
  static const String manageFamily = "Manage Family";
  static const String familyDetailsNotAvailable =
      "Family details not available";
  static const String editVisitorDetail = 'Edit';
  static const String editNOCRequest = 'Edit';

  static const String delete = 'Delete';
  static const String readMore = 'read more';
  static const String readLess = 'read less';
  static const String spotlight = 'Spotlight';
  static const String noSpotlight = 'No Spotlight';
  static const String mySpotlight = 'My Spotlight';
  static const String myPost = "My Post";
  static const String beTheFirstToComment = 'Be the first to comment';
  static const String comments = 'Comments';
  static const String deletePost = 'Delete Post';
  static const String areYouSureToDeletePost =
      'Are your sure you want to delete your post?';
  static const String deleteSpotlight = 'Delete Spotlight';
  static const String areYouSureToDeleteSpotlight =
      'Are your sure you want to delete your spotlight?';
  static const String deleteComment = 'Delete Comment';
  static const String areYouSureToDeleteComment =
      'Are your sure you want to delete your Comment?';
  static const String viewAll = 'View all';
  static const String createPost = 'Create Post';
  static const String createFeedback = 'Create Feedback';
  static const String feedback2 = 'Create Feedback';
  static const String addFeedback = 'Add Feedback';
  static const String shareYourThought = 'Share you thought';
  static const String shareYourFeedBackandSuggestion =
      'Share you feedback & suggestion';
  static const String inTheSpotlight = "In The Spotlight";
  static const String createASpotlight = 'Create a Spotlight';
  static const String enterGratitudeMessage =
      'Enter your grattitude message here *';
  static const String enterYourTitle = 'Enter your title *';
  static const String searchYourColleagues = 'Search for colleagues by name *';

  static const String infoText1 =
      "A Company email is required to login in to the application";
  static const String infoText2 = "What do you want to do?";
  static const String infoPopupTitle = "It\'s just a demo";
  static const String infoPopupContent =
      "Experience a demo of our app and explore its full functionality. While the data isn't live, this demo will give you a great overview of what Community App can do for you.";
  static const String infoPopupButtonName = "I Get It!";
  static const String demoRequest = 'Demo Request';
  static const String viewApp = 'View App';
  static const String emailScreenText =
      'We\'d love to offer you a personalized demo to showcase how our solution can meet your needs. Please click copy to message below and send a mail, and one of our experts will get in touch with you to schedule a demo at your convenience.';
  static const String noData = 'No Data';
  static const String noSuspenseHistoryFound = 'No suspense history found';
  static const String noNocRequestFound = 'No noc request found';
  static const String accountBooks = 'Account Books';
  static const String expensesList = 'Expenses';
  static const String netBalance = 'Net Balance';
  static const String totalIncome = 'Total Income';
  static const String totalExpenses = 'Total Expenses';
  static const String previousDue = 'Previous Due';
  static const String openingBalance = 'Opening Balance';
  static const String totalDue = 'Total Due';
  static const String totalInvoices = 'Total Invoices';
  static const String totalPaid = 'Total Paid';
  static const String totalPaidInvoices = 'Total Paid Invoices';
  static const String unpaidInvoice = 'Unpaid Invoices';
  static const String advancePaidInvoices = 'Adv Paid Invoices';

  static const String lastInvoiceAmount = 'Last Invoice Amount';
  static const String unitNoWithColon = 'Unit No:';
  static const String selectUnit = 'Select Unit';
  static const String chooseAnOption = 'Choose an option';
  static const String transactionReceipts = 'View / Upload Payment Screenshot';
  static const String hello = "Hello";
  static const String readMoreCaps = "Read More";
  static const String searchWithDot = 'Search...';
  static const String noCommitteeMember = 'No committee member';
  static const String noMember = 'No member found';
  static const String beFirstComment = 'Be the first to comment';

  static const String likes = "Likes";
  static const String noLikes = 'No Likes';
  static const String noHelper = 'No helper';
  static const String noBlock = 'No Block';
  static const String updateStatus = 'Update Status';

  static const String cash = "Cash";
  static const String online = "Online";
  static const String cheque = "Cheque";
  static const String selectTransactionReceipt = "Select Transaction Receipt";

  static const String addPayInEntry = "Add Pay In Entry";
  static const String selectPaymentMode = "Select Payment Mode";

  static const String memberList = "member-list";
  static const String reSendOtp = "Resend OTP";
  static const String houseStatementsList = "house-statements-list";
  static const String committeeList = "commitee-list";
  static const String accountPayIn = "account-book-pay-in";
  static const String expenseAction= "expense-action";
  static const String myVisitorPermission = "my-visitor";
  static const String nocList= "noc-list";
  static const String nocAction= "noc-action";
  static const String nocRequestPermission = "noc-request";
  static const String accountPayOut = "account-book-pay-out";



  static const String manageTaskList = "manage-task-list";
  static const String manageTaskAdd = "manage-task-add";
  static const String manageTaskEdit = "manage-task-edit";
  static const String manageTaskFollowUp = "manage-task-follow-up";
  static const String manageTaskAssign = "manage-task-assign";
  static const String manageTaskComment = "manage-task-comment";
  static const String manageTaskCancel = "manage-task-cancel";
  static const String manageTaskComplete = "manage-task-complete";
  static const String manageTaskReopen = "manage-task-reopen";
  static const String manageTaskHistory = "manage-task-history";


  static const String taskList = "task-list";
  static const String manageAssetsCreate = "manage-assets-create";
  static const String manageAssetsList = "manage-assets-list";
  static const String manageAssetsScan = "manage-assets-scan";
  static const String manageAssetsHistory = "manage-assets-history";
  static const String manageAssetsUpdateStatus = "manage-assets-update-status";
  static const String manageAssetsEdit = "manage-assets-edit";
  static const String taskAdd = "task-add";
  static const String taskEdit = "task-edit";
  static const String taskStatusUpdate = "task-status-update";
  static const String taskFollowUp = "task-follow-up";
  static const String taskAssign = "task-assign";
  static const String taskComment = "task-comment";
  static const String taskCancel = "task-cancel";
  static const String taskComplete = "task-complete";
  static const String taskReopen = "task-reopen";
  static const String taskHistory = "task-history";

  static const String accountCheque = "account-book-pay-in-cheque";
  static const String accountOnline = "account-book-pay-in-online";
  static const String accountCash = "account-book-pay-in-cash";
  static const String complaintAdd = "complaint-add";
  static const String complaintStatusUpdate = "complaint-status-update";
  static const String complaintComment = "complaint-comment";
  static const String postLike = "post-like";
  static const String postAdd = "post-add";
  static const String postShare = "post-share";
  static const String postComment = "post-comment";
  static const String vehicleAdd = "vehicle-add";
  static const String vehicleDelete = "vehicle-delete";
  static const String vehicleList = "vehicle-list";
  static const String complaintList = "complaint-list";
  static const String accountBookList = "account-book-list";
  static const String noticeList = "notice-list";
  static const String handymanList = "handyman-list";
  static const String vehicleSearch = "vehicle-search";
  static const String postList = "post-list";
  static const String unitList = "unit-list";
  static const String noTaskFound = "No Task Found";
  static const String noAssetFound = "No Asset Found";
  static const String youHaveNoPaymentDetailYet = "You have no payment details yet";
  static const String youHaveNoStatementDetailYet = "You have no statement details yet";
  static const String unitTransactionReceipt = "unit-transaction-receipt";
  static const String unitTransactionReceiptUpload =
      "unit-transaction-receipt-upload";
  static const String accountPaymentAdd = "account-payment-add";
  static const String managerUnitTransactionReceiptUpload =
      "manager-unit-transaction-receipt-upload";
  static const String manageMemberAdd = "manager-memeber-add";
  static const String managerVehicleAdd = "manager-vehicle-add";
  static const String managerVehicleList = "manager-vehicle-list";
  static const String amountHint = "Amount";
  static const String enterAmountHint = "Enter Amount";
  static const String selectTransactionDate = "Select Transaction Date";
  static const String partyHint = "Name (Flat Owner)";
  static const String remarksHint = "Remarks ";
  static const String upload = "Upload";
  static const String uploadSize = "Upload size hint";
  static const String errorMessageEnterAmount = "Please enter an amount.";
  static const String errorMessageEnterValidAmount = "Please enter a valid amount.";
  static const String errorMessageUploadReceipt =
      "Please upload a transaction receipt.";
  static const String errorMessageNoDataFound = "No data found!";
  static const String errorMessageRecognizingText = "Error recognizing text: ";
  static const String selectUnitNumberHint = "Select Unit Number";
  static const String selectHouseNumberHint = "Select house number";
  static const String houseNumberHint = "Select House Number ";
  static const String invalidImagePath = 'Invalid image path!';
  static const String selectHouse = 'Select House';
  static const String noHousesAvailable = "No houses available.";
  static const String uploadTransactionReceiptButton =
      "Upload Transaction Receipt";
  static const String invalidImagePathError = "Invalid image path!";
  static const String noDataFoundError = "No data found!";
  static const String errorRecognizingText = "Error recognizing text";
  static const String transactionReceiptDetailTitle =
      "Transaction Receipt Detail";
  static const String noReceiptsAvailable = "No receipts available.";
  static const String receiptButton = "Receipt";
  static const String addComplaint = "Complaint";
  static const String amountLabel = "Amount";
  static const String transactionIdLabel = "Transaction ID";
  static const String upiIdLabel = "UPI ID";
  static const String upiTransactionIdLabel = "UPI Transaction ID";
  static const String googleTransactionIdLabel = "Google Transaction ID";
  static const String typeAmountHint = "Type amount...";
  static const String selectUnitTitle = "Select Unit";
  static const String noImageSelected = "No image selected";
  static const String noTextRecognized = "No text recognized";
  static const String receiptImageLabel = "Receipt Image";
  static const String couldNotLoadError = "Could not load";
  static const String approveRequestTitle = "Approve Request";
  static const String receiptNumberLabel = "Receipt Number";
  static const String confirmButton = "Confirm";
  static const String enterReceiptNumberHint = "Enter Receipt Number";
  static const String cancelButton = "Cancel";
  static const String approvedStatus = "approved";
  static const String approvedButton = "Approved";
  static const String rejectRequestTitle = "Reject Request";
  static const String markTaskComplete = "Mark Task Complete";
  static const String reasonLabel = "Reason";
  static const String submitButton = "Submit";
  static const String completeTaskButton = "Complete Task";
  static const String nextButton = "Next";
  static const String enterReasonHint = "Enter reason ";
  static const String rejectedStatus = "rejected";
  static const String rejectButton = "Reject";
  static const String paymentConfirmationTitle = "Payment Confirmation";
  static const String nameFieldKey = "name";
  static const String paymentMethodFieldKey = "Payment Method";
  static const String amountFieldKey = "amount";
  static const String selectUnitFieldKey = "Select Unit";
  static const String descriptionFieldKey = "description";
  static const String nameLabel = "Name";
  static const String paymentMethodLabel = "Payment Method";
  static const String paymentAmountLabel = "Amount";
  static const String unitLabel = "Unit";
  static const String descriptionLabel = "Description";
  static const String searchYouSocietyName = "Enter Your Society Name";
  static const String searchYouBlock = "Search Your Block";
  static const String enterBuilding = "Select Block";
  static const String flatNoRequired = "Flat No is required";
  static const String societyRequired = "Society is required";
  static const String buildingRequired = "Building is required";
  static const String homeAddedSuccessfully = "Home added successfully!";

  static const String party = "Party (Flat Owner)";
  static const String selectMember = "Select Member";
  static const String selectPaymentMethod = "Select Payment Method";
  static const String paymentMethodError = "Please select payment method";
  static const String paymentMethod = "Please select payment method";
  static const String paymentMethodLabelNew = "Please Select Payment Method";
  static const String pleaseSelectParty = 'Please select party';
  static const String amount = "Amount";
  static const String assetsManagement = "Assets Management";
  static const String myAsset = "My Asset";
  static const String addAsset= "Add Asset";
  static const String editAsset= "Edit Asset";
  static const String updateAsset= "Update";
  static const String assetDetails= "Asset Details";
  static const String expenseDate = "Expense Date";
  static const String amountError = "Please enter amount";
  static const String receiptNumberField = "Receipt number";
  static const String receiptNumberFieldLabel = "Receipt Number";
  static const String receiptError = "Please enter receipt no";
  static const String uploadImageOptional = "Upload Image";
  static const String saveCapital = "Save";
  static const String submitFollowUp = "Submit Follow-up";
  static const String verifyButton = "Verify";
  static const String invoicesPending = "Invoices";
  static const String allowedTypes = 'Allowed types: jpeg, png, jpg';
  static const String upToMbSize = 'Up to 5MB size';
  static const String maximumOfOneImage = 'Maximum of 1 image';

  static const String deleteVehicleTitle = "Delete Vehicle";
  static const String deleteNocRequestTitle = "Delete NOC Request";
  static const String deleteUpcomingVisitor = "Delete Upcoming Visitor";
  static const String deleteNocRequestMessage = "Are you sure you want to delete this NOC request? This action cannot be undone.";
  static const String deleteUpcomingVisitorMessage = "Are you sure you want to delete this upcoming visitor? This action cannot be undone.";

  static const String deleteVehicleContent = "Are you sure you want to delete this vehicle?";
  static const String cancelTaskContent = "Are you sure you want to cancel this task?";
  static const String cancelBookingContent = "Are you sure you want to cancel booking?";
  static const String deleteMemberTitle = "Delete Member";
  static const String deleteReceipt = "Delete Receipt";
  static const String deleteMemberContent = "Are you sure you want to delete this member?";
  static const String deleteReceiptContent = "Are you sure you want to delete this receipt?";
  static const String deleteFamilyTitle = "Delete Family Member";
  static const String deleteFamilyContent = "Are you sure you want to delete this family member?";
  static const String cancelRequestTitle = "Cancel Request";
  static const String cancelVisitorPass = "Cancel Visitor Pass";
  static const String cancelVisitorPassContent = "Are you sure you want to cancel this visitor pass? This action cannot be undone.";
  static const String cancelRequestContent = "Are you sure you want to cancel your request?";
  // static const String cancel = "Cancel";
  // static const String delete = "Delete";
  static const String addVehiclePrompt = "Add vehicle by clicking on + button";
  static const String noVehicleAdded = "No Vehicle Added";
  static const String addVehicle = "Add Vehicle";
  static const String rcNumber = 'RC Number:';
  static const String noMembersFound = "No members found";

  static const String vehicleOwnerName = "Vehicle Owner's Name";
  static const String vehicleOwnerNameHint = "Vehicle Owner's Name*";
  static const String rcNumberHint = "RC Number";
  static const String doYouHaveAllocatedParking =
      "Do you have allocated parking?";
  static const String policeVerification =
      "Police Verification? ";
  static const String inWhichBlock = "In Which Block";
  static const String block = "Block";
  static const String youAre = "You Are";
  static const String registerAs = "Register as a";

  static const String vehicleType = "Select Vehicle Type";
  static const String vehicleTypeHint = " Select Vehicle Type";
  static const String vehicleDetailsAddedSuccessfully =
      "Vehicle added successfully!";

  static const String disableContactDetail =
      "Disable Contact Detail successfully!";

  static const String receiptDeletedSuccessfully =
      "Receipt deleted Successfully";

  static const String enableContactDetail =
      "Enable Contact Detail successfully!";
  static const String blockErrorMessage = "Please select a block number.";
  static const String invalidBlockFormat =
      "Invalid block format. Only alphanumeric characters and spaces are allowed.";
  static const String blockFieldEmpty = "Block field cannot be empty.";

  static const String communityName = "Community Name";
  static const String enterCommunityName = "Enter community name";
  static const String registrationNumber = "Registration Number";
  static const String enterRegistrationNumber = "Enter registration number";
  static const String propertyType = "Property Type";
  static const String selectPropertyType = "Select property type";
  static const String presidentName = "President Name";
  static const String enterPresidentName = "Enter president name";
  static const String signUpPhoneNumber = "Phone Number";
  static const String enterPhoneNumber = "Enter Your Phone Number";
  static const String presidentEmail = "President Email";
  static const String enterPresidentEmail = "Enter president email";
  static const String signUpTermsAndConditions = "Terms & Conditions";
  static const String iAgreeToThe = 'I agree to the ';
  static const String invalidEmailFormat = "Invalid email format";
  static const String emailRequired = "Email is required";
  static const String invalidCommunityName = "Invalid community name";
  static const String communityNameRequired = "Community name is required";
  static const String invalidRegistrationNumber = "Invalid registration number";
  static const String registrationNumberRequired =
      "Registration number is required";
  static const String phoneNumberMustBe10Digits =
      "Phone number must be 10 digits";
  static const String phoneNumberRequired = "Phone number is required";
  static const String invalidFirstName = "Invalid first name";
  static const String presidentNameRequired = "President name is required";
  static const String propertyTypeRequired = "Property type is required";
  static const String termsAndConditionsText = "Terms & Conditions";
  static const String termsAndConditionsTapped = "Terms & Conditions tapped";
  static const String getStartedWithSpace = "Get Started";
  static const String firstNameRequired = "First name is required";
  static const String lastNameRequired = "Last name is required";
  static const String emailIsRequired = "Email is required";
  static const String invalidLastName = "Invalid last name";
  static const String passwordTooShort = "Password too short";
  static const String passwordRequired = "Password required";
  static const String passwordsDoNotMatch = "Passwords do not match";
  static const String confirmPasswordRequired = "Confirm password required";

  static const String thankYouForSigningUp = "Thank You for Signing Up!";
  static const String welcomeMessage =
      "Welcome to Society Hub. We will verify your account within the next 24 hours.";
  static const String goToLoginScreen = "Go to login screen";
  static const String selectWorkType = "Select Work Type";
  static const String searchHelper = "Search helper";
  static const String searchTask = "Search task...";
  static const String searchAssets = "Search assets...";
  static const String searchBlockSmall = "Search block";
  static const String asASociety = "As a society";
  static const String asAMember = "As a member";
  static const String select = "Select an option";
  static const String pleaseEnterYourEmailAddress =
      "Email Address";
  static const String pleaseEnterYourEmailAddressSmall =
      "Enter your email address";
///Family permission
  static const String familyList = "family-list";
  static const String familyDelete = "family-delete";
  static const String familyAdd = "family-add";

  ///Manager delete permission
  static const String managerVehicleDelete =  "manager-vehicle-delete";
  static const String managerMemberDelete =  "manager-memeber-delete";

  static const String managerComplaintAdd =  "manager-complaint-add";

  static const String or = 'or';
  static const String pleaseEnterYourPhoneNumber = "Mobile Number";
  static const String enterYourPhoneNumber = "Enter your mobile number";
  static const String otpTextForMobile = "We have sent an OTP on your mobile number";
  static const String loginWithNumber = 'Login with Mobile Number';
  static const String loginWithEmail = 'Login with Email';
  static const String editYourProfile = 'Edit Profile';
  static const String updateProfile = 'Update Profile';
  static const String enterYourFirstName = 'Enter First Name';
  static const String enterYourLastName = 'Enter Last Name';
  static const String pleaseEnterYourFirstName = 'Please enter your first name';
  static const String pleaseEnterYourLastName = 'Please enter your last name';
  static const String enterYoursPhoneNumber = "Enter Phone Number";
  static const String pleaseEnterYoursPhoneNumber = "Please enter your phone number";
  static const String pleaseEnterYoursEmailAddress = "Please enter your email address";
  static const String emailAddress = "Email Address";
  static const String updatePhoneNumberMsg = "To update your phone number, please contact the society president.";
  static const String updateEmailMsg = "To update your email, please contact the society president.";
  static const String houseSize = 'House Size';
  static const String houseNumber = 'House Number';
  static const String houseHold = 'Household';
  static const String howToPayWithIconText = 'How To Pay?';

  static const String noVehiclesFound = "No Vehicles found";
  static const String noNOCFound = "No NOC found";
  static const String errorMessageFor3Characters = "Minimum 3 characters are required!";
  static const String biometricLogin = 'Biometric login';
  static const String fingerprintEnabled = 'Biometric authentication enabled';
  static const String fingerprintFailed = 'Biometric authentication failed';
  static const String fingerprintDisabled = 'Biometric authentication disabled.';
  static const String noFamilyMemberFound = 'No Family Member Found';
  static const String sharedTransactionReceipt = 'Shared Transaction Receipt';
  static const String complaintType = 'Complaint Type *';
  static const String blockWithStar = 'Block *';
  static const String selectInWhichBlock = 'Select In Which Block';
  static const String floor = 'Floor';
  static const String postCreateSuccessfully = 'Post created successfully' ;
  static const String pleaseWaitMoment = "Please wait it will take a moment" ;
  static const String noPostContent = 'No post content available' ;
  static const String areYouSureDeleteComment = 'Are your sure you want to delete your Comment?';
  static const String comment = 'Comment';
  static const String share = 'Share';
  static const String couldNotLoad = 'Could not load';
  static const String couldNotLoadVideo = 'Could not load video';
  static const String accountDeactivate =  'Account Deactivated' ;
  static const String accountDisableMsg = "Your account has been temporarily disabled. Please contact your administrator for assistance or click below for more information.";
  static const String exit = 'Exit' ;
  static const String newNotificationReceived = "Alert";

  static const String receivedANewMessageContent = "This notification is for [Society Name]. Switch societies to see it.";   /// Please don't remove '[Society Name]' from this string

   static const String receiptsStatusAlertContent = "Receipts may take sometime as Treasurer matches payments with bank records before generating them.";

  static const String disableContactDetailLabel = "Hide Contact Detail";
  static const String enableContactDetailLabel = "Show Contact Detail";
  static const String setPrimaryMember = "Set Primary Member";
  static const String memberDeletedSuccessfully = "Member deleted successfully!";

  static const String leaveThePage = "Your profile setup is not finished. If you go back, you’ll be logged out. Do you wish to proceed?";

  static const String notificationsContent = 'Notifications may include alert sound and icon badges. This can be configured in settings.';

  static const String notificationsTitle = "\"Society Hub\" would like to send you notifications.";

  static const String     donNotAllow =     "Don't allow";


  static const String     selectRelationship =     "Select Relationship";
  static const String     done =      "Done";
  static const String     selectGender =     "Select Gender";
  static const String     selectComplaintType =     "Select Complaint Type";
  static const String     selectBlock =     "Select Block";
  static const String     selectFloor =     "Select Floor";

  static const String     selectVehicleType =    "Select Vehicle Type";

  static const String     selectThePropertyType =    "Select Property Type";
  static const String     selectPaymentType =    "Select Payment Type";


  static const String     noFlatErrorMessage =    "There is no flat number for this block. Please select another block or connect with admin.";

  static const String addPet = 'Add Pet';
  static const String pets = 'Pets';
  static const String noPetsFound = "No pets found";
  static const String petAddedSuccessfully = "Pet Added Successfully";
  static const String petBasicInfo = 'Pet Basic Information';
  static const String editPetBasicInfo = 'Edit Pet Basic Information';
  static const String petVaccinationInfo = 'Pet Vaccination Details';
  static const String editPetVaccinationInfo = 'Edit Pet Vaccination Details';
  static const String deletePetTitle = "Delete Pet";
  static const String deletePetContent = "Are you sure you want to delete this pet?";
   static const String petDeletedSuccessfully = 'Pet deleted Successfully';
   static const String  updatePetInfoSuccessfully = 'Update Pet Information Successfully';
   static const String petVaccinationDetailAddedSuccessfully = 'Pet Vaccination Detail Added Successfully';
   static const String editPetPetVaccinationDetailSuccessfully = 'Edit Pet Vaccination Detail Successfully';



  static const suspenseEntryAddSuccessfully  = 'Suspense Entry AddSuccessfully!';
}

