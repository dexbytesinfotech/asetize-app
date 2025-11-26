class NewLeaveDataModel {
  final String title;
  final String leaveType;
  final String leaveDays;
  final String status;
  final String? date;
  final String? managerName;
  final String? managerImageUrl;
  final String? description;

  NewLeaveDataModel({
    required this.title,
    required this.leaveType,
    required this.leaveDays,
    required this.status,
    required this.date,
    required this.managerName,
    required this.description,
    required this.managerImageUrl,
  });
}

List<NewLeaveDataModel> newLeaveData = [
  NewLeaveDataModel(
      title: "Going for a trip",
      leaveType: 'Casual Leave',
      leaveDays: '3 Days',
      status: "Pending",
      date: "5th March - 8th March",
      managerName: "Jitendra Patidar",
      managerImageUrl:
          "https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8bWFsZSUyMHByb2ZpbGV8ZW58MHx8MHx8&w=1000&q=80",
      description:
          "I am writing to request a leave of absence to travel. I am traveling on a family trip to three different places. I hope for your kind approval."),
  NewLeaveDataModel(
      title: "Friend's Wedding",
      leaveType: 'Annual Leave',
      leaveDays: '3 Days',
      status: "Pending",
      date: "25th Feb - 28th Feb",
      managerName: "Jitendra Patidar",
      managerImageUrl:
          "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NXx8bWFsZSUyMHByb2ZpbGV8ZW58MHx8MHx8&w=1000&q=80",
      description: "I am writing this letter to inform you that"
          " I will need two days off from work to attend my friend's"
          " wedding in Chattarpur. I will be traveling to Chattarpur on the night of Feb 25, 2022."),
  NewLeaveDataModel(
      title: "Felling not well",
      leaveType: 'Sick Leave',
      leaveDays: '1 Days',
      status: "Approved",
      date: "Jan 14, 2023",
      managerName: "Jitendra Patidar",
      managerImageUrl:
          "https://static8.depositphotos.com/1468291/934/i/450/depositphotos_9346925-stock-photo-portrait-of-office-worker-at.jpg",
      description: "I am writing this letter to inform you that"
          " I will need two days off from work to attend my friend's"
          " wedding in Chattarpur. I will be traveling to Chattarpur on the night of Feb 25, 2022."),
  NewLeaveDataModel(
      title: "One Day Leave",
      leaveType: 'Casual Leave',
      leaveDays: '5 Days',
      status: "Rejected",
      date: "Jan 5, 2023",
      managerName: "Jitendra Patidar",
      managerImageUrl:
          "https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8bWFsZSUyMHByb2ZpbGV8ZW58MHx8MHx8&w=1000&q=80",
      description: "I am writing this letter to inform you that"
          " I will need two days off from work to attend my friend's"
          " wedding in Chattarpur. I will be traveling to Chattarpur on the night of Feb 25, 2022."),
  NewLeaveDataModel(
      title: "For Attending Family Function",
      leaveType: 'Annual Leave',
      leaveDays: '3 Days',
      status: "Approved",
      date: "Dec 8, 2023",
      managerName: "Jitendra Patidar",
      managerImageUrl:
          "https://static8.depositphotos.com/1468291/934/i/450/depositphotos_9346925-stock-photo-portrait-of-office-worker-at.jpg",
      description: "I am writing this letter to inform you that"
          " I will need two days off from work to attend my friend's"
          " wedding in Chattarpur. I will be traveling to Chattarpur on the night of Feb 25, 2022."),
];
