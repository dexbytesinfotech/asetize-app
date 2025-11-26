import 'package:asetize/features/data/models/user_response_model.dart';

import '../../../core/util/project_util.dart';

class GetHomeDataModel {
  HomeData? data;
  String? message;

  GetHomeDataModel({this.data, this.message});

  GetHomeDataModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new HomeData.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class HomeData {
  List<Birthday>? birthday;
  List<WorkAnniversary>? workAnniversary;
  List<MarriageAnniversary>? marriageAnniversary;
  List<Announcements>? announcements;
  List<Holidays>? holidays;
  List<Events>? events;
  List<TodayLeaves>? todayLeaves;
  List<TodayWfh>? todayWfh;

  HomeData({
    this.birthday,
    this.workAnniversary,
    this.marriageAnniversary,
    this.announcements,
    this.holidays,
    this.events,
    this.todayLeaves,
    this.todayWfh,
  });

  HomeData.fromJson(Map<String, dynamic> json) {
    if (json['birthday'] != null) {
      birthday = <Birthday>[];
      json['birthday'].forEach((v) {
        birthday!.add(new Birthday.fromJson(v));
      });
    }
    if (json['work_anniversary'] != null) {
      workAnniversary = <WorkAnniversary>[];
      json['work_anniversary'].forEach((v) {
        workAnniversary!.add(new WorkAnniversary.fromJson(v));
      });
    }
    if (json['marriage_anniversary'] != null) {
      marriageAnniversary = <MarriageAnniversary>[];
      json['marriage_anniversary'].forEach((v) {
        marriageAnniversary!.add(new MarriageAnniversary.fromJson(v));
      });
    }
    if (json['announcements'] != null) {
      announcements = <Announcements>[];
      json['announcements'].forEach((v) {
        announcements!.add(new Announcements.fromJson(v));
      });
    }
    if (json['holidays'] != null) {
      holidays = <Holidays>[];
      json['holidays'].forEach((v) {
        holidays!.add(new Holidays.fromJson(v));
      });
    }
    if (json['events'] != null) {
      events = <Events>[];
      json['events'].forEach((v) {
        events!.add(new Events.fromJson(v));
      });
    }
    if (json['today_leaves'] != null) {
      todayLeaves = <TodayLeaves>[];
      json['today_leaves'].forEach((v) {
        todayLeaves!.add(new TodayLeaves.fromJson(v));
      });
    }
    if (json['today_wfh'] != null) {
      todayWfh = <TodayWfh>[];
      json['today_wfh'].forEach((v) {
        todayWfh!.add(new TodayWfh.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.birthday != null) {
      data['birthday'] = this.birthday!.map((v) => v.toJson()).toList();
    }
    if (this.workAnniversary != null) {
      data['work_anniversary'] =
          this.workAnniversary!.map((v) => v.toJson()).toList();
    }
    if (this.marriageAnniversary != null) {
      data['marriage_anniversary'] =
          this.marriageAnniversary!.map((v) => v.toJson()).toList();
    }
    if (this.announcements != null) {
      data['announcements'] =
          this.announcements!.map((v) => v.toJson()).toList();
    }
    if (this.holidays != null) {
      data['holidays'] = this.holidays!.map((v) => v.toJson()).toList();
    }
    if (this.events != null) {
      data['events'] = this.events!.map((v) => v.toJson()).toList();
    }
    if (this.todayLeaves != null) {
      data['today_leaves'] = this.todayLeaves!.map((v) => v.toJson()).toList();
    }
    if (this.todayWfh != null) {
      data['today_wfh'] = this.todayWfh!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Birthday {
  int? id;
  String? firstName;
  String? lastName;
  String? profilePhoto;
  String? jobTitle;
  String? dob;
  String? description;
  User? user;

  Birthday({
    this.id,
    this.firstName,
    this.lastName,
    this.profilePhoto,
    this.jobTitle,
    this.dob,
    this.description,
    this.user,
  });

  Birthday.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    profilePhoto = json['profile_photo'];
    jobTitle = json['job_title'];
    dob = json['dob'];
    description = json['description'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['profile_photo'] = this.profilePhoto;
    data['job_title'] = this.jobTitle;
    data['dob'] = this.dob;
    data['description'] = this.description;
    return data;
  }
}

class WorkAnniversary {
  int? id;
  String? firstName;
  String? lastName;
  String? profilePhoto;
  String? jobTitle;
  String? doj;
  String? description;
  User? user;

  WorkAnniversary({
    this.id,
    this.firstName,
    this.lastName,
    this.profilePhoto,
    this.jobTitle,
    this.doj,
    this.description,
    this.user,
  });

  WorkAnniversary.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    profilePhoto = json['profile_photo'];
    jobTitle = json['job_title'];
    doj = json['doj'];
    description = json['description'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['profile_photo'] = this.profilePhoto;
    data['job_title'] = this.jobTitle;
    data['doj'] = this.doj;
    data['description'] = this.description;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class MarriageAnniversary {
  int? id;
  String? firstName;
  String? lastName;
  String? profilePhoto;
  String? jobTitle;
  String? marriageAnniversaryDate;
  String? description;
  User? user;

  MarriageAnniversary({
    this.id,
    this.firstName,
    this.lastName,
    this.profilePhoto,
    this.jobTitle,
    this.marriageAnniversaryDate,
    this.description,
    this.user,
  });

  MarriageAnniversary.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    profilePhoto = json['profile_photo'];
    jobTitle = json['job_title'];
    marriageAnniversaryDate = json['marriage_anniversary_date'];
    description = json['description'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['profile_photo'] = this.profilePhoto;
    data['job_title'] = this.jobTitle;
    data['marriage_anniversary_date'] = this.marriageAnniversaryDate;
    data['description'] = this.description;
    return data;
  }
}

class Announcements {
  int? id;
  String? title;
  String? featuredImage;
  String? content;
  String? publishedAt;

  Announcements(
      {this.id,
      this.title,
      this.featuredImage,
      this.content,
      this.publishedAt});

  Announcements.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    featuredImage = json['featured_image'];
    content = json['content'];
    publishedAt = json['published_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['featured_image'] = this.featuredImage;
    data['content'] = this.content;
    data['published_at'] = this.publishedAt;
    return data;
  }
}

class Holidays {
  String? title;
  String? description;
  String? startDate;
  String? endDate;

  Holidays({this.title, this.description, this.startDate, this.endDate});

  Holidays.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    startDate = json['start_date'];
    endDate = json['end_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    return data;
  }
}

class Events {
  String? title;
  String? description;
  String? startDate;
  String? endDate;
  double? totalDays;

  Events(
      {this.title,
      this.description,
      this.startDate,
      this.endDate,
      this.totalDays});

  Events.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    totalDays = projectUtil.intToDouble(json['total_days']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['total_days'] = this.totalDays;
    return data;
  }
}

class TodayLeaves {
  int? id;
  String? name;
  String? status;
  String? duration;
  String? leaveType;
  String? startDate;
  String? endDate;
  String? assignedName;
  String? assignedId;
  String? createdAt;
  double? totalDays;
  String? messages;
  User? user;

  TodayLeaves(
      {this.id,
      this.name,
      this.status,
      this.duration,
      this.leaveType,
      this.startDate,
      this.endDate,
      this.assignedName,
      this.assignedId,
      this.createdAt,
      this.totalDays,
      this.messages,
      this.user});

  TodayLeaves.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
    duration = json['duration'];
    leaveType = json['leave_type'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    assignedName = json['assigned_name'];
    assignedId = json['assigned_id'];
    createdAt = json['created_at'];
    totalDays = projectUtil.intToDouble(json['total_days']);
    messages = json['messages'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['status'] = this.status;
    data['duration'] = this.duration;
    data['leave_type'] = this.leaveType;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['assigned_name'] = this.assignedName;
    data['assigned_id'] = this.assignedId;
    data['created_at'] = this.createdAt;
    data['total_days'] = this.totalDays;
    data['messages'] = this.messages;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class TodayWfh {
  int? id;
  String? name;
  String? status;
  String? duration;
  String? leaveType;
  String? startDate;
  String? endDate;
  String? assignedName;
  String? assignedId;
  String? createdAt;
  double? totalDays;
  String? messages;
  User? user;

  TodayWfh(
      {this.id,
      this.name,
      this.status,
      this.duration,
      this.leaveType,
      this.startDate,
      this.endDate,
      this.assignedName,
      this.assignedId,
      this.createdAt,
      this.totalDays,
      this.messages,
      this.user});

  TodayWfh.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
    duration = json['duration'];
    leaveType = json['leave_type'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    assignedName = json['assigned_name'];
    assignedId = json['assigned_id'];
    createdAt = json['created_at'];
    totalDays = projectUtil.intToDouble(json['total_days']);
    messages = json['messages'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['status'] = this.status;
    data['duration'] = this.duration;
    data['leave_type'] = this.leaveType;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['assigned_name'] = this.assignedName;
    data['assigned_id'] = this.assignedId;
    data['created_at'] = this.createdAt;
    data['total_days'] = this.totalDays;
    data['messages'] = this.messages;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}
