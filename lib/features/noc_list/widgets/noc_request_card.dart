import 'package:flutter/material.dart';
import 'package:asetize/core/core.dart';
import 'package:asetize/widgets/common_card_view.dart';
import '../../../core/util/app_theme/app_color.dart';
import '../../../core/util/app_theme/text_style.dart';

class SocietyNocCard extends StatelessWidget {
  final String name;
  final String title;
  final String status;
  final String description;
  final String date;
  final Function()? onTap;

  const SocietyNocCard({
    Key? key,
    required this.name,
    required this.title,
    required this.status,
    required this.description,
    required this.date,
    required this.onTap,
  }) : super(key: key);

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange; // Waiting action
      case 'rejected':
        return Colors.red; // Not approved
      case 'approved':
        return Colors.green; // Success
      case 'issued':
        return Colors.green; // Issued or finalized
      default:
        return Colors.black12; // Unknown or default state
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: CommonCardView(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        child: Padding(
          padding: const EdgeInsets.all(15).copyWith(
            left: 23,
            right: 15,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title and Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Row(
                      children: [
                        Text(
                          "${name.split(" ")[0][0].toUpperCase()}${name.split(" ")[0].substring(1).toLowerCase()} ${name.split(" ")[1][0].toUpperCase()}${name.split(" ")[1].substring(1).toLowerCase()}",
                          style: appTextStyle.appTitleStyle().copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppColors.black,
                              ),
                        ),
                        Text(
                          ", $title",
                          style:  appTextStyle.appTitleStyle().copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        color: _getStatusColor(status),
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              // Description
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 3.5),
              // Date
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
