import 'package:flutter/material.dart';

import '../../../core/util/app_theme/text_style.dart';

class BookingCardView extends StatelessWidget {
  final String venue;
  final String type;
  final DateTime date;
  final String time;
  final int guests;
  final String bookingRef;
  final String status;
  final Color? tagColor;
  final VoidCallback onTab;
  final Color? tagTextColor;

  const BookingCardView({
    super.key,
    required this.venue,
    required this.type,
    required this.date,
    required this.time,
    required this.onTab,
    required this.guests,
    required this.bookingRef,
    required this.status,
    this.tagColor,
    this.tagTextColor,
  });

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green.withOpacity(0.3);
      case 'pending':
        return Colors.orange.withOpacity(0.3);
      case 'cancelled':
        return Colors.red.withOpacity(0.3);
      default:
        return Colors.grey.withOpacity(0.3);
    }
  }

  Color getStatusTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green[800]!; // Darker green
      case 'pending':
        return Colors.orange[800]!; // Darker orange
      case 'cancelled':
        return Colors.red[800]!; // Darker red
      default:
        return Colors.black87;
    }
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:  onTab,
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      venue,
                      style: appTextStyle.appTitleStyle2(),

                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    decoration: BoxDecoration(
                      color: getStatusColor(status),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: getStatusTextColor(status),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                type,
                style: appTextStyle.appSubTitleStyle2(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.calendar_month, size: 16, color: Colors.black),
                  const SizedBox(width: 5),
                  Text(
                    "${date.day}, ${date.toString().split(' ')[0].split('-').reversed.join('-')}",
                    style: appTextStyle.appSubTitleStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.access_time, size: 16, color: Colors.black),
                  const SizedBox(width: 5),
                  Text(
                    time,
                    style: appTextStyle.appSubTitleStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.group, size: 16, color: Colors.black),
                  const SizedBox(width: 5),
                  Text(
                    "$guests guests",
                    style: appTextStyle.appSubTitleStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                "Booking Ref: $bookingRef",
                style: appTextStyle.appSubTitleStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),                ),
            ],
          ),
        ),
      ),
    );
  }
}

