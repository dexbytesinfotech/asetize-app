/*
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:asetize_guard/global_components/common_appbar.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../core/app_themes/app_color.dart';
import '../../../core/util/app_theme/app_color.dart';
import '../../../global_components/container_first.dart';
import '../../presentation/widgets/appbar/common_appbar.dart';
import '../../presentation/widgets/basic_view_container/container_first.dart';

class CalendarAvailabilityScreen extends StatefulWidget {
  const CalendarAvailabilityScreen({super.key});

  @override
  _CalendarAvailabilityScreenState createState() =>
      _CalendarAvailabilityScreenState();
}

class _CalendarAvailabilityScreenState
    extends State<CalendarAvailabilityScreen> {
  final DateTime _firstSelectableDay = DateTime.now().add(Duration(days: 1));
  final DateTime _lastSelectableDay = DateTime.utc(2030, 12, 31);

  late DateTime _focusedDay;
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = _firstSelectableDay;
    _selectedDay = _firstSelectableDay;//By default select date
  }

  @override
  Widget build(BuildContext context) {
    return ContainerFirst(
      contextCurrentView: context,
      isSingleChildScrollViewNeed: false,
      isListScrollingNeed: true,
      isFixedDeviceHeight: false,
      appBarHeight: 56,
      appBar: CommonAppBar(
        title: 'Community Hall',
        isHideIcon: false,
      ),
      containChild: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100, // Light grey background
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade400), // Border
              ),
              padding: const EdgeInsets.all(10),
              child: TableCalendar(
                firstDay: _firstSelectableDay,
                lastDay: _lastSelectableDay,
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                rowHeight: 42,
                calendarStyle: CalendarStyle(
                  defaultTextStyle: TextStyle(color: Colors.black), // All days black
                  weekendTextStyle: TextStyle(color: Colors.black), // Weekend also black
                  outsideTextStyle: TextStyle(color: Colors.grey.shade400),
                  todayDecoration: BoxDecoration(
                    color: AppColors.textBlueColor, // Today's blue bg
                    shape: BoxShape.circle,
                  ),
                  todayTextStyle: TextStyle(
                    color: Colors.black, // Today's text black
                    fontWeight: FontWeight.bold,
                  ),
                  selectedDecoration: BoxDecoration(
                    color:AppColors.textBlueColor,// Selected day blue
                    shape: BoxShape.circle,
                  ),
                  selectedTextStyle: TextStyle(
                   // Selected day text black
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  dowTextFormatter: (date, locale) {
                    return DateFormat.E(locale).format(date)[0]; // S M T W...
                  },
                  weekendStyle: TextStyle(color: Colors.black),
                  weekdayStyle: TextStyle(color: Colors.black),
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  leftChevronVisible: false,
                  rightChevronVisible: false,
                  titleTextStyle: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                calendarBuilders: CalendarBuilders(
                  disabledBuilder: (context, day, focusedDay) {
                    return Center(
                      child: Text(
                        '${day.day}',
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  },
                ),
                enabledDayPredicate: (day) {
                  return day.isAfter(DateTime.now());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/
