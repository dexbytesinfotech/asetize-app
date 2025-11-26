class UserResponseModel {
  User? user;
  String? message;

  UserResponseModel({this.user, this.message});

  UserResponseModel.fromJson(Map<String, dynamic> json) {
    user = json['data'] != null ? User.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['data'] = user!.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? firstName;
  String? lastName;
  String? email;
  String? jobTitle;
  String? profilePhoto;
  String? countryCode;
  String? phone;
  List<RoleId>? roleId;
  String? emailVerifiedAt;
  String? phoneVerifiedAt;
  String? rememberToken;
  String? lastLogin;
  bool? globalNotifications;
  bool? isPublicContact;
  String? defaultLang;
  List<dynamic>? device;
  int? messageCount;
  int? notificationCount;
  int? status;
  String? displayMessage;
  bool? isBlockAccount;
  String? address;
  String? alternativeAddress;
  String? alternativePhone;
  String? dob;
  int? marriageStatus;
  String? marriageAnniversaryDate;
  String? gender;
  String? createdAt;
  String? updatedAt;
  bool? enableDelete;
  AdditionalInfo? additionalInfo;
  String? shortDescription;
  List<Managers>? managers;
  List<Houses>? houses;
  List<Companies>? companies;
  Company? company;
  List<String>? permissions;

  User(
      {
        this.name,
        this.id,
        this.firstName,
        this.lastName,
        this.email,
        this.jobTitle,
        this.profilePhoto,
        this.countryCode,
        this.phone,
        this.roleId,
        this.emailVerifiedAt,
        this.phoneVerifiedAt,
        this.rememberToken,
        this.lastLogin,
        this.globalNotifications,
        this.isPublicContact,
        this.defaultLang,
        this.device,
        this.messageCount,
        this.notificationCount,
        this.status,
        this.displayMessage,
        this.isBlockAccount,
        this.address,
        this.alternativeAddress,
        this.alternativePhone,
        this.dob,
        this.marriageStatus,
        this.marriageAnniversaryDate,
        this.gender,
        this.createdAt,
        this.updatedAt,
        this.enableDelete,
        this.additionalInfo,
        this.shortDescription,
        this.houses,
        this.companies,
        this.company,this.managers,
        this.permissions});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    jobTitle = json['job_title'];
    profilePhoto = json['profile_photo'];
    countryCode = json['country_code'];
    phone = json['phone'];
    if (json['role_id'] != null) {
      roleId = <RoleId>[];
      json['role_id'].forEach((v) {
        roleId!.add(RoleId.fromJson(v));
      });
    }
    emailVerifiedAt = json['email_verified_at'];
    phoneVerifiedAt = json['phone_verified_at'];
    rememberToken = json['remember_token'];
    lastLogin = json['last_login'];
    globalNotifications = json['global_notifications'];
    isPublicContact = json['is_public_contact'];
    defaultLang = json['default_lang'];
    device = json['device'];
    messageCount = json['message_count'];
    notificationCount = json['notification_count'];
    status = json['status'];
    displayMessage = json['display_message'];
    isBlockAccount = json['is_block_account'];
    address = json['address'];
    alternativeAddress = json['alternative_address'];
    alternativePhone = json['alternative_phone'];
    dob = json['dob'];
    marriageStatus = json['marriage_status'];
    marriageAnniversaryDate = json['marriage_anniversary_date'];
    gender = json['gender'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    enableDelete = json['enable_delete'];
    additionalInfo = json['additional_info'] != null
        ? AdditionalInfo.fromJson(json['additional_info'])
        : null;
        if (json['managers'] != null) {
      managers = <Managers>[];
      json['managers'].forEach((v) {
        managers!.add( Managers.fromJson(v));
      });
    }
    shortDescription = json['short_description'];
    if (json['houses'] != null) {
      houses = <Houses>[];
      json['houses'].forEach((v) {
        houses!.add(Houses.fromJson(v));
      });
    }
    if (json['companies'] != null) {
      companies = <Companies>[];
      json['companies'].forEach((v) {
        companies!.add(Companies.fromJson(v));
      });
    }
    company =
    json['company'] != null ? Company.fromJson(json['company']) : null;
    if (json.containsKey('permissions')) {
      permissions = json['permissions'].cast<String>();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['job_title'] = jobTitle;
    data['profile_photo'] = profilePhoto;
    data['country_code'] = countryCode;
    data['phone'] = phone;
    if (roleId != null) {
      data['role_id'] = roleId!.map((v) => v.toJson()).toList();
    }
    data['email_verified_at'] = emailVerifiedAt;
    data['phone_verified_at'] = phoneVerifiedAt;
    data['remember_token'] = rememberToken;
    data['last_login'] = lastLogin;
    data['global_notifications'] = globalNotifications;
    data['is_public_contact'] = isPublicContact;
    data['default_lang'] = defaultLang;
    data['device'] = device;
    data['message_count'] = messageCount;
    data['notification_count'] = notificationCount;
    data['status'] = status;
    data['display_message'] = displayMessage;
    data['is_block_account'] = isBlockAccount;
    data['address'] = address;
    data['alternative_address'] = alternativeAddress;
    data['alternative_phone'] = alternativePhone;
    data['dob'] = dob;
    data['marriage_status'] = marriageStatus;
    data['marriage_anniversary_date'] = marriageAnniversaryDate;
    data['gender'] = gender;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['enable_delete'] = enableDelete;
    if (additionalInfo != null) {
      data['additional_info'] = additionalInfo!.toJson();
    }
        if (managers != null) {
      data['managers'] = managers!.map((v) => v.toJson()).toList();
    }
    data['short_description'] = shortDescription;
    if (houses != null) {
      data['houses'] = houses!.map((v) => v.toJson()).toList();
    }
    if (companies != null) {
      data['companies'] = companies!.map((v) => v.toJson()).toList();
    }
    if (company != null) {
      data['company'] = company!.toJson();
    }
    if (permissions != null) {
      data['permissions'] = permissions;
    }
    return data;
  }
}

class RoleId {
  String? name;

  RoleId({this.name});

  RoleId.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    return data;
  }
}

class AdditionalInfo {
  String? phone;
  String? alternativePhone;
  String? dateOfBirth;
  String? marriageAnniversaryDate;
  String? address;
  String? alternativeAddress;
  String? bloodGroup;

  AdditionalInfo(
      {this.phone,
        this.alternativePhone,
        this.dateOfBirth,
        this.marriageAnniversaryDate,
        this.address,
        this.alternativeAddress,
        this.bloodGroup});

  AdditionalInfo.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    alternativePhone = json['alternative_phone'];
    dateOfBirth = json['date_of_birth'];
    marriageAnniversaryDate = json['marriage_anniversary_date'];
    address = json['address'];
    alternativeAddress = json['alternative_address'];
    bloodGroup = json['blood_group'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['phone'] = phone;
    data['alternative_phone'] = alternativePhone;
    data['date_of_birth'] = dateOfBirth;
    data['marriage_anniversary_date'] = marriageAnniversaryDate;
    data['address'] = address;
    data['alternative_address'] = alternativeAddress;
    data['blood_group'] = bloodGroup;
    return data;
  }

  // Method to convert object to a map
  Map<String, dynamic> toMap() {
    return {
    'phone': phone,
    'alternative_phone': alternativePhone,
    'date_of_birth': dateOfBirth,
    'marriage_anniversary_date': marriageAnniversaryDate,
    'address': address,
    'alternative_address': alternativeAddress,
    'blood_group': bloodGroup
    };
  }
}
class Managers {
  int? leadId;
  String? name;
  String? firstName;
  String? lastName;
  String? jobTitle;
  String? email;
  String? phone;
  String? profilePhoto;

  Managers(
      {this.leadId,
      this.name,
      this.firstName,
      this.lastName,
      this.jobTitle,
      this.email,
      this.phone,
      this.profilePhoto});

  Managers.fromJson(Map<String, dynamic> json) {
    leadId = json['lead_id'];
    name = json['name'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    jobTitle = json['job_title'];
    email = json['email'];
    phone = json['phone'];
    profilePhoto = json['profile_photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lead_id'] = leadId;
    data['name'] = name;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['job_title'] = jobTitle;
    data['email'] = email;
    data['phone'] = phone;
    data['profile_photo'] = profilePhoto;
    return data;
  }
}
class Houses {
  int? id;
  int? houseMemberId;
  String? title;
  String? houseNumber;
  String? block;
  String? status;
  bool? isInvoicePreview;
  String? invoicePreviewMessage;
  Houses({this.id, this.title, this.houseNumber, this.block, this.status,
    this.isInvoicePreview,
    this.invoicePreviewMessage,
    this.houseMemberId,
  });

  Houses.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    houseMemberId = json['house_member_id'];
    title = json['title'];
    houseNumber = json['house_number'];
    block = json['block'];
    status = json['status'];
    isInvoicePreview = json['is_invoice_preview'];
    invoicePreviewMessage = json['invoice_preview_message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['house_member_id'] = this.houseMemberId;
    data['title'] = title;
    data['house_number'] = houseNumber;
    data['block'] = block;
    data['status'] = status;
    data['is_invoice_preview'] = this.isInvoicePreview;
    data['invoice_preview_message'] = this.invoicePreviewMessage;
    return data;
  }
}

class Companies {
  int? id;
  String? logo;
  String? name;
  String? roleName;
  String? status;
  String? propertyType;
  bool? enableOnlinePayment;

  Companies(
      {this.id,
        this.logo,
        this.name,
        this.roleName,
        this.status,
        this.propertyType,
        this.enableOnlinePayment

      });

  Companies.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    logo = json['logo'];
    name = json['name'];
    roleName = json['role_name'];
    status = json['status'];
    propertyType = json['property_type'];
    enableOnlinePayment = json['enable_online_payment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['logo'] = logo;
    data['name'] = name;
    data['role_name'] = roleName;
    data['status'] = status;
    data['property_type'] = propertyType;
    data['enable_online_payment'] = enableOnlinePayment;
    return data;
  }
}

class Company {
  int? id;
  String? name;
  String? roleName;
  String? status;
  String? propertyType;

  Company({this.id, this.name, this.roleName, this.status, this.propertyType});

  Company.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    roleName = json['role_name'];
    status = json['status'];
    propertyType = json['property_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['role_name'] = roleName;
    data['status'] = status;
    data['property_type'] = propertyType;
    return data;
  }
}










// class UserResponseModel {
//   User? user;
//   String? message;
//
//   UserResponseModel({this.user, this.message});
//
//   UserResponseModel.fromJson(Map<String, dynamic> json) {
//     user = json['data'] != null ? User.fromJson(json['data']) : null;
//     message = json['message'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     if (user != null) {
//       data['data'] = user!.toJson();
//     }
//     data['message'] = message;
//     return data;
//   }
// }
//
// class User {
//   int? id;
//   String? name;
//   String? firstName;
//   String? lastName;
//   String? email;
//   String? countryCode;
//   String? phone;
//   String? shortDescription;
//   List<RoleId>? roleId;
//   String? emailVerifiedAt;
//   String? phoneVerifiedAt;
//   String? rememberToken;
//   String? lastLogin;
//   bool? globalNotifications;
//   String? defaultLang;
//   List<dynamic>? device;
//   String? profilePhoto;
//   int? messageCount;
//   int? notificationCount;
//   int? status;
//   String? displayMessage;
//   bool? isBlockAccount;
//   String? jobTitle;
//   String? address;
//   String? alternativeAddress;
//   String? alternativePhone;
//   String? dob;
//   String? doj;
//   int? marriageStatus;
//   String? marriageAnniversaryDate;
//   String? skills;
//   String? gender;
//   String? skype;
//   String? githubUsername;
//   String? bitbucketUsername;
//   String? createdAt;
//   String? updatedAt;
//   bool? enableDelete;
//   bool? enableLeaveApply;
//   List<Leads>? leads;
//   AdditionalInfo? additionalInfo;
//   List<Managers>? managers;
//   List<Houses>? houses;
//   String? totalSpotlight;
//   List<String>? permissions;
//   List<Companies>? companies;
//
//
//   User({
//     this.id,
//     this.name,
//     this.firstName,
//     this.lastName,
//     this.email,
//     this.countryCode,
//     this.shortDescription,
//     this.phone,
//     this.leads,
//     this.roleId,
//     this.emailVerifiedAt,
//     this.phoneVerifiedAt,
//     this.rememberToken,
//     this.lastLogin,
//     this.globalNotifications,
//     this.defaultLang,
//     this.device,
//     this.profilePhoto,
//     this.messageCount,
//     this.notificationCount,
//     this.status,
//     this.displayMessage,
//     this.isBlockAccount,
//     this.jobTitle,
//     this.address,
//     this.alternativeAddress,
//     this.alternativePhone,
//     this.dob,
//     this.doj,
//     this.marriageStatus,
//     this.marriageAnniversaryDate,
//     this.skills,
//     this.gender,
//     this.skype,
//     this.githubUsername,
//     this.bitbucketUsername,
//     this.createdAt,
//     this.updatedAt,
//     this.enableDelete,
//     this.enableLeaveApply,
//     this.additionalInfo,
//     this.managers,
//     this.totalSpotlight,
//     this.houses,
//     this.permissions = const [],
//     this.companies,
//
//   });
//
//   User.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     firstName = json['first_name'];
//     lastName = json['last_name'];
//     email = json['email'];
//     countryCode = json['country_code'];
//     shortDescription = json['short_description'];
//     phone = json['phone'];
//     if (json['role_id'] != null) {
//       roleId = <RoleId>[];
//       json['role_id'].forEach((v) {
//         roleId!.add(RoleId.fromJson(v));
//       });
//     }
//     if (json['houses'] != null) {
//       houses = <Houses>[];
//       json['houses'].forEach((v) {
//         houses!.add(new Houses.fromJson(v));
//       });
//     }
//     if (json['companies'] != null) {
//       companies = <Companies>[];
//       json['companies'].forEach((v) {
//         companies!.add(new Companies.fromJson(v));
//       });
//     }
//
//
//
//     emailVerifiedAt = json['email_verified_at'];
//     phoneVerifiedAt = json['phone_verified_at'];
//     rememberToken = json['remember_token'];
//     lastLogin = json['last_login'];
//     globalNotifications = json['global_notifications'];
//     defaultLang = json['default_lang'];
//     device = json['device'] ?? [];
//     profilePhoto = json['profile_photo'];
//     messageCount = json['message_count'];
//     notificationCount = json['notification_count'];
//     status = json['status'];
//     displayMessage = json['display_message'];
//     isBlockAccount = json['is_block_account'];
//     jobTitle = json['job_title'];
//     address = json['address'];
//     alternativeAddress = json['alternative_address'];
//     alternativePhone = json['alternative_phone'];
//     dob = json['dob'];
//     doj = json['doj'];
//     marriageStatus = json['marriage_status'];
//     marriageAnniversaryDate = json['marriage_anniversary_date'];
//     skills = json['skills'];
//     gender = json['gender'];
//     skype = json['skype'];
//     githubUsername = json['github_username'];
//     bitbucketUsername = json['bitbucket_username'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     enableDelete = json['enable_delete'];
//     enableLeaveApply = json['enable_leave_apply'];
//     if (json['leads'] != null) {
//       leads = <Leads>[];
//       json['leads'].forEach((v) {
//         leads!.add(Leads.fromJson(v));
//       });
//     }
//     additionalInfo = json['additional_info'] != null
//         ? new AdditionalInfo.fromJson(json['additional_info'])
//         : null;
//     if (json['managers'] != null) {
//       managers = <Managers>[];
//       json['managers'].forEach((v) {
//         managers!.add( Managers.fromJson(v));
//       });
//     }
//     totalSpotlight = json['total_spotlight'];
//
//      // permissions = json['permissions'].cast<String>();
//
//
//     // print('Permissions raw data: ${json['permissions']}');
//     // print('Permissions data type: ${json['permissions']?.runtimeType}');
//
//     if (json['permissions'] != null) {
//       if (json['permissions'] is List) {
//         permissions = List<String>.from(json['permissions']);
//       } else {
//         permissions = [];
//       }
//     } else {
//       permissions = [];
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['name'] = name;
//     data['first_name'] = firstName;
//     data['last_name'] = lastName;
//     data['email'] = email;
//     data['country_code'] = countryCode;
//     data['short_description'] = shortDescription;
//     data['phone'] = phone;
//     if (roleId != null) {
//       data['role_id'] = roleId!.map((v) => v.toJson()).toList();
//     }
//     data['email_verified_at'] = emailVerifiedAt;
//     data['phone_verified_at'] = phoneVerifiedAt;
//     data['remember_token'] = rememberToken;
//     data['last_login'] = lastLogin;
//     data['global_notifications'] = globalNotifications;
//     data['default_lang'] = defaultLang;
//     data['device'] = device;
//     data['profile_photo'] = profilePhoto;
//     data['message_count'] = messageCount;
//     data['notification_count'] = notificationCount;
//     data['status'] = status;
//     data['display_message'] = displayMessage;
//     data['is_block_account'] = isBlockAccount;
//     data['job_title'] = jobTitle;
//     data['address'] = address;
//     data['alternative_address'] = alternativeAddress;
//     data['alternative_phone'] = alternativePhone;
//     data['dob'] = dob;
//     data['doj'] = doj;
//     data['marriage_status'] = marriageStatus;
//     data['marriage_anniversary_date'] = marriageAnniversaryDate;
//     data['skills'] = skills;
//     data['gender'] = gender;
//     data['skype'] = skype;
//     data['github_username'] = githubUsername;
//     data['bitbucket_username'] = bitbucketUsername;
//     data['created_at'] = createdAt;
//     data['updated_at'] = updatedAt;
//     data['enable_delete'] = enableDelete;
//     if (leads != null) {
//       data['leads'] = leads!.map((v) => v.toJson()).toList();
//     }
//     if (additionalInfo != null) {
//       data['additional_info'] = additionalInfo!.toJson();
//     }
//     if (managers != null) {
//       data['managers'] = managers!.map((v) => v.toJson()).toList();
//     }
//     if (companies != null) {
//       data['companies'] = companies!.map((v) => v.toJson()).toList();
//     }
//     if (houses != null) {
//       data['houses'] = houses!.map((v) => v.toJson()).toList();
//     }
//
//     data['total_spotlight'] = totalSpotlight;
//     data['permissions'] = permissions;
//     return data;
//   }
// }
//
// class RoleId {
//   String? name;
//
//   RoleId({this.name});
//
//   RoleId.fromJson(Map<String, dynamic> json) {
//     name = json['name'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['name'] = name;
//     return data;
//   }
// }
//
// class Leads {
//   int? leadId;
//   String? name;
//   String? firstName;
//   String? lastName;
//   String? jobTitle;
//   String? email;
//   String? phone;
//   String? profilePhoto;
//
//   Leads(
//       {this.leadId,
//       this.name,
//       this.firstName,
//       this.lastName,
//       this.jobTitle,
//       this.email,
//       this.phone,
//       this.profilePhoto});
//
//   Leads.fromJson(Map<String, dynamic> json) {
//     leadId = json['lead_id'];
//     name = json['name'];
//     firstName = json['first_name'];
//     lastName = json['last_name'];
//     jobTitle = json['job_title'];
//     email = json['email'];
//     phone = json['phone'];
//     profilePhoto = json['profile_photo'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['lead_id'] = leadId;
//     data['name'] = name;
//     data['first_name'] = firstName;
//     data['last_name'] = lastName;
//     data['job_title'] = jobTitle;
//     data['email'] = email;
//     data['phone'] = phone;
//     data['profile_photo'] = profilePhoto;
//     return data;
//   }
// }
//
//
//
// class AdditionalInfo {
//   String? phone;
//   String? skills;
//   String? dateOfJoining;
//   String? dateOfBirth;
//   String? skype;
//   String? githubUsername;
//   String? bitbucketUsername;
//   String? address;
//   String? alternativeAddress;
//   String? bloodGroup;
//   String? carriesStartDate;
//   String? personalIntro;
//
//   AdditionalInfo(
//       {this.phone,
//       this.skills,
//       this.dateOfJoining,
//       this.dateOfBirth,
//       this.skype,
//       this.githubUsername,
//       this.bitbucketUsername,
//       this.address,
//       this.alternativeAddress,
//       this.bloodGroup,
//       this.carriesStartDate,
//       this.personalIntro});
//
//   AdditionalInfo.fromJson(Map<String, dynamic> json) {
//     phone = json['phone'];
//     skills = json['skills'];
//     dateOfJoining = json['date_of_joining'];
//     dateOfBirth = json['date_of_birth'];
//     skype = json['skype'];
//     githubUsername = json['github_username'];
//     bitbucketUsername = json['bitbucket_username'];
//     address = json['address'];
//     alternativeAddress = json['alternative_address'];
//     bloodGroup = json['blood_group'];
//     carriesStartDate = json['carries_start_date'];
//     personalIntro = json['personal_intro'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['phone'] = phone;
//     data['skills'] = skills;
//     data['date_of_joining'] = dateOfJoining;
//     data['date_of_birth'] = dateOfBirth;
//     data['skype'] = skype;
//     data['github_username'] = githubUsername;
//     data['bitbucket_username'] = bitbucketUsername;
//     data['address'] = address;
//     data['alternative_address'] = alternativeAddress;
//     data['blood_group'] = bloodGroup;
//     data['carries_start_date'] = carriesStartDate;
//     data['personal_intro'] = personalIntro;
//     return data;
//   }
//
//   // Method to convert object to a map
//   Map<String, dynamic> toMap() {
//     return {
//       'phone': phone,
//       'skills': skills,
//       'date_of_joining': dateOfJoining,
//       'date_of_birth': dateOfBirth,
//       'skype': skype,
//       'github_username': githubUsername,
//       'bitbucket_username': bitbucketUsername,
//       'address': address,
//       'alternative_address': alternativeAddress,
//       'blood_group': bloodGroup,
//       'carries_start_date': carriesStartDate,
//       'personal_intro': personalIntro,
//     };
//   }
// }
//
// class Managers {
//   int? leadId;
//   String? name;
//   String? firstName;
//   String? lastName;
//   String? jobTitle;
//   String? email;
//   String? phone;
//   String? profilePhoto;
//
//   Managers(
//       {this.leadId,
//       this.name,
//       this.firstName,
//       this.lastName,
//       this.jobTitle,
//       this.email,
//       this.phone,
//       this.profilePhoto});
//
//   Managers.fromJson(Map<String, dynamic> json) {
//     leadId = json['lead_id'];
//     name = json['name'];
//     firstName = json['first_name'];
//     lastName = json['last_name'];
//     jobTitle = json['job_title'];
//     email = json['email'];
//     phone = json['phone'];
//     profilePhoto = json['profile_photo'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['lead_id'] = leadId;
//     data['name'] = name;
//     data['first_name'] = firstName;
//     data['last_name'] = lastName;
//     data['job_title'] = jobTitle;
//     data['email'] = email;
//     data['phone'] = phone;
//     data['profile_photo'] = profilePhoto;
//     return data;
//   }
// }
// class Houses {
//   int? id;
//   String? title;
//   String? houseNumber;
//   String? block;
//
//   Houses({this.id, this.title, this.houseNumber, this.block});
//
//   Houses.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     title = json['title'];
//     houseNumber = json['house_number'];
//     block = json['block'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['title'] = title;
//     data['house_number'] = houseNumber;
//     data['block'] = block;
//     return data;
//   }
// }
//
//
// class Companies {
//   int? id;
//   String? name;
//   String? roleCode;
//   String? roleName;
//   String? status;
//
//   Companies({this.id, this.name, this.roleCode, this.roleName,this.status});
//
//   Companies.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     roleCode = json['role_code'];
//     roleName = json['role_name'];
//     status = json['status'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data =  <String, dynamic>{};
//     data['id'] = id;
//     data['name'] = name;
//     data['role_code'] = roleCode;
//     data['role_name'] = roleName;
//     data['status'] = status;
//     return data;
//   }
// }
//
