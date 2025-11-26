import 'package:asetize/imports.dart';
import 'package:flutter/material.dart';

class AmountPayableCard extends StatelessWidget {
  final String amountPayable;
  final String billGeneratedOn;
  final String dueDate;
  final String billCycle;
  final String billMode;
  final String status; // Changed to String for status

  // Constructor to accept parameters
  AmountPayableCard({
    required this.amountPayable,
    required this.billGeneratedOn,
    required this.dueDate,
    required this.billCycle,
    required this.billMode,
    required this.status, // Accepting status
  });

  @override
  Widget build(BuildContext context) {
    Color cardColor;
    Color buttonColor;
    bool isPaid;

    // Determine colors and button status based on the status
    if (status == 'Paid') {
      cardColor = Colors.green.withOpacity(0.2);
      buttonColor = const Color(0xFF757575); // Gray when paid
      isPaid = true;
    } else if (status == 'Overdue') {
      cardColor = Colors.red;
      buttonColor = AppColors.textBlueColor;// Gray when overdue
      isPaid = false;
    } else if (status == 'Due') {
      cardColor = Colors.orange.withOpacity(0.2);
      buttonColor = AppColors.textBlueColor; // Regular button color when due
      isPaid = false;
    } else {
      cardColor = Colors.white; // Default color
      buttonColor = AppColors.textBlueColor;
      isPaid = false;
    }

    return Padding(
      padding: const EdgeInsets.all(18.0).copyWith(top: 0,left: 19),
      child: Card(
        color: Colors.white, // Set card color based on status
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: const BorderSide(
            color: Colors.grey, // Set the desired border color here
            width: 0.5, // Set the desired border width
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Amount Payable Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [

                      Text(
                        'AMOUNT PAYABLE',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  // if (isPaid)
                    Container(
                      decoration: BoxDecoration(
                        color: cardColor,
                        // border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child:  Text(
                        status,
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                amountPayable,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              // Bill Details
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bill Generated On',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        billGeneratedOn,
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 35),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Due Date',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          dueDate,
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bill Cycle',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 150,
                        child: Text(
                          billCycle,
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 60),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bill Mode',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          billMode,
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Buttons
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Expanded(
              //       child: ElevatedButton(
              //         onPressed: isPaid ? null : () {
              //           // Add your pay action here
              //         },
              //         style: ElevatedButton.styleFrom(
              //           foregroundColor: Colors.white,
              //           backgroundColor: buttonColor, // Set button color based on status
              //           shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(8),
              //           ),
              //         ),
              //         child:  Text(
              //           'Pay Now',
              //           style: appStyles.tabTextStyle(),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
