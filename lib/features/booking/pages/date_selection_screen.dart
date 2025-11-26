import 'package:table_calendar/table_calendar.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../../imports.dart';
import '../../../widgets/commonTitleRowWithIcon.dart';
import '../../../widgets/common_card_view.dart';
import 'booking_details_and_payment_screen.dart';

class DateSelectionScreen extends StatefulWidget {
  const DateSelectionScreen({super.key});

  @override
  State<DateSelectionScreen> createState() => _DateSelectionScreenState();
}

class _DateSelectionScreenState extends State<DateSelectionScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();
  int? selectedIndex;
  String? selectedTime;



  List<AvailableSlotDataModel> slotList = [
    AvailableSlotDataModel(time: "09:00 AM",status: "Available"),
    AvailableSlotDataModel(time: "10:00 AM",status: "Booked"),
    AvailableSlotDataModel(time: "11:00 AM",status: "Available"),
    AvailableSlotDataModel(time: "12:00 AM",status: "Available"),

  ];


  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'booked':
        return Colors.red.shade600; // Not approved
      case 'available':
        return Colors.green.shade600; // Success
      default:
        return Colors.grey; // Unknown or default state
    }

  }

  Widget _infoTile2({required List<AvailableSlotDataModel> valuesList}) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: valuesList.length,
      itemBuilder: (context, index) {
        final item = valuesList[index];
        final isBooked = item.status.toLowerCase() == 'booked';
        final isSelected = selectedIndex == index;
        return GestureDetector(
          onTap: () {
            if (!isBooked) {
              setState(() {
                if (isSelected) {
                  selectedIndex = null;
                  selectedTime = null;
                } else {
                  selectedIndex = index;
                  selectedTime = item.time; // ⬅️ Capture selected time
                }
              });
            }
          },
          child: CommonCardView(
            margin: const EdgeInsets.only(bottom: 10),
            side: BorderSide(
              width: 1.5,
              color: isBooked
                  ? Colors.grey.shade300
                  : isSelected
                  ? AppColors.appBlueColor
                  : Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 18, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.time,
                    style: appTextStyle.appTitleStyle2(
                      fontWeight: FontWeight.w500,
                      color: isBooked ? Colors.grey : Colors.black,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: _getStatusColor(item.status).safeOpacity(0.18),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 4),
                    child: Text(
                      item.status,
                      style: appTextStyle.appTitleStyle2(
                        fontSize: 12,
                        color: _getStatusColor(item.status).safeOpacity(
                            isBooked ? 0.5 : 1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {

    return ContainerFirst(
      contextCurrentView: context,
      isSingleChildScrollViewNeed: true,
      isFixedDeviceHeight: false,
      isListScrollingNeed: false,
      isOverLayStatusBar: false,
      appBarHeight: 56,
      appBar: const CommonAppBar(
        title: 'Select Date & Check Availability',
      ),
      containChild: Padding(
        padding: const EdgeInsets.only(top: 4,bottom: 90,left: 15,right: 15),
        child: Column(
          children: [
            CommonCardView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10).copyWith(bottom: 15),
                child: TableCalendar(
                  firstDay: DateTime.utc(2024, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  enabledDayPredicate: (day) {
                    return !day.isBefore(DateTime.now().subtract(const Duration(days: 1)));
                  },
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    headerMargin: const EdgeInsets.only(bottom: 5),
                    titleTextStyle: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                    leftChevronIcon: Icon(Icons.chevron_left, color: Theme.of(context).iconTheme.color),
                    rightChevronIcon: Icon(Icons.chevron_right, color: Theme.of(context).iconTheme.color),
                  ),
                  calendarStyle: CalendarStyle(
                    weekendTextStyle: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                    defaultTextStyle: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                    todayDecoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: const BoxDecoration(
                      color: AppColors.textBlueColor,
                      shape: BoxShape.circle,
                    ),
                    selectedTextStyle: const TextStyle(color: Colors.white),
                  ),
                  rowHeight: 50,
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                    weekendStyle: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                  ),
                  daysOfWeekVisible: true,
                  locale: 'en_US',
                ),
              ),
            ),



            const SizedBox(height: 15,),
            const CommonTitleRowWithIcon(title: 'Available Time Slots',icon: Icons.access_time,),
            const SizedBox(height: 15,),
            _infoTile2(valuesList: slotList)
            // _infoTile(title: '09:00 AM', value: 'Available'),
            // _infoTile(title: '10:00 AM', value: 'Booked'),
            // _infoTile(title: '11:00 AM', value: 'Available'),
            // _infoTile(title: '02:00 AM', value: 'Available'),

          ],
        ),
      ),
      bottomMenuView: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFf9fafb),
              border: Border(
                top: BorderSide(
                  color: Colors.grey.shade300,
                  width: 0.5,
                ),
              ),
            ),
            child: AppButton(
              buttonName: 'Continue',
              buttonColor: selectedTime != null ? AppColors.textBlueColor : Colors.grey,
              backCallback:  selectedTime != null ?() {
                String formattedDate = projectUtil.uiShowDateFormat(_focusedDay);

                Navigator.push(
                  MainAppBloc.getDashboardContext,
                  SlideLeftRoute(
                      widget: BookingDetailsAndPaymentScreen(time:selectedTime ?? "",date: formattedDate )),
                );
              }:null,
            ),
          ),
        ],
      ),
    );

  }
}

class AvailableSlotDataModel {
  final String time;
  final String status;
  AvailableSlotDataModel({this.time = "", this.status = ''});
}