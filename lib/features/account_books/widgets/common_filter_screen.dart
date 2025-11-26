// import '../../../imports.dart';
// import '../bloc/account_book_bloc.dart';
// import '../bloc/account_book_event.dart';
//
// class FilterBottomSheets extends StatefulWidget {
//   @override
//   _FilterBottomSheetState createState() => _FilterBottomSheetState();
// }
//
// class _FilterBottomSheetState extends State<FilterBottomSheets> {
//   String? selectedMethod;
//   String? selectedStatus;
//   DateTime? startDate;
//   DateTime? endDate;
//   late AccountBookBloc accountBloc;

//
//
//   final List<String> paymentMethods = ['Cash', 'Online', 'Cheque'];
//   final List<String> statuses = ['Pending', 'Approved', 'Rejected'];
//
//
//   Future<void> selectDate(BuildContext context, bool isStartDate) async {
//
//
//     DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//     );
//     if (pickedDate != null) {
//       setState(() {
//         if (isStartDate) {
//           startDate = pickedDate;
//         } else {
//           endDate = pickedDate;
//         }
//       });
//     }
//
//
//   }
//
//   @override
//   void initState() {
//     accountBloc = BlocProvider.of<AccountBookBloc>(context);
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(
//             'Filters',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.black),
//           ),
//           SizedBox(height: 16),
//           // Payment Method Dropdown
//           DropdownButtonFormField<String>(
//             value: selectedMethod,
//             decoration: InputDecoration(labelText: 'Payment Method'),
//             items: paymentMethods
//                 .map((method) => DropdownMenuItem(
//               value: method,
//               child: Text(method),
//             ))
//                 .toList(),
//             onChanged: (value) {
//               setState(() {
//                 selectedMethod = value;
//               });
//             },
//           ),
//           SizedBox(height: 16),
//           // Status Dropdown
//           DropdownButtonFormField<String>(
//             value: selectedStatus,
//             decoration: InputDecoration(labelText: 'Status'),
//             items: statuses
//                 .map((status) => DropdownMenuItem(
//               value: status,
//               child: Text(status),
//             ))
//                 .toList(),
//             onChanged: (value) {
//               setState(() {
//                 selectedStatus = value;
//               });
//             },
//           ),
//           SizedBox(height: 16),
//           // Date From Picker
//           TextFormField(
//             readOnly: true,
//             decoration: InputDecoration(
//               labelText: 'Start Date',
//               suffixIcon: Icon(Icons.calendar_today),
//             ),
//             onTap: () => selectDate(context, true),
//             controller: TextEditingController(
//               text: startDate != null
//                   ? '${startDate!.year}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}'
//                   : '',
//             ),
//           ),
//           SizedBox(height: 16),
//           // Date To Picker
//           TextFormField(
//             readOnly: true,
//             decoration: InputDecoration(
//               labelText: 'End Date',
//               suffixIcon: Icon(Icons.calendar_today),
//             ),
//             onTap: () => selectDate(context, false),
//             controller: TextEditingController(
//               text: endDate != null
//                   ? '${endDate!.year}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}'
//                   : '',
//             ),
//           ),
//           SizedBox(height: 24),
//           // Apply Button
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context, {
//
//
//               accountBloc.add(
//                 ApplyFilterOnPendingConfirmationEvent(
//                   mContext: context,
//                 dateTo: startDate.toString(),
//                 dateFrom:endDate.toString(),
//                 status: selectedStatus,
//                 method:selectedMethod
//
//
//
//
//
//               ),
//               )
//
//
//
//               });
//             },
//             child: Text('Apply Filters'),
//           ),
//         ],
//       ),
//     );
//   }
// }