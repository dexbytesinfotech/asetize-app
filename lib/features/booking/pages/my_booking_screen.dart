import 'package:go_router/go_router.dart';
import 'package:asetize/core/util/app_theme/text_style.dart';
import 'package:asetize/widgets/common_card_view.dart';

import '../../../imports.dart';
import '../../presentation/pages/dashboard_screen.dart';
import '../bloc/booking_bloc.dart';
import 'booking_details_screen.dart';

class MyBookingScreen extends StatefulWidget {
  final bool isComeFromSuccess;

  const MyBookingScreen({super.key, this.isComeFromSuccess = false});

  @override
  State<MyBookingScreen> createState() => _MyBookingScreenState();
}

class _MyBookingScreenState extends State<MyBookingScreen> {
  late BookingBloc bloc;
  final List<String> filters = ["All", "Upcoming", "Completed", "Cancelled"];
  String selectedFilter = "All";

  final List<Map<String, dynamic>> bookings = [
    {
      'title': 'Fitness Center',
      'date': 'June 10, 2025',
      'time': '09:00 AM',
      'price': '₹1500',
      'hours': '3 hours',
      'member': '5 members',
      'status': 'Upcoming',
      'icon': Icons.fitness_center,
    },
    {
      'title': 'Basketball Court',
      'date': 'June 12, 2025',
      'time': '10:00 AM',
      'price': '₹2000.00',
      'hours': '2.5 hours',
      'member': '7 members',
      'status': 'Completed',
      'icon': Icons.sports_basketball,
    },
    {
      'title': 'Swimming Pool',
      'date': 'June 14, 2025',
      'time': '09:00 AM',
      'price': '₹1500',
      'hours': '4 hours',
      'member': '2 members',
      'status': 'Cancelled',
      'icon': Icons.pool,
    },
    {
      'title': 'Basketball Court',
      'date': 'June 16, 2025',
      'time': '09:00 AM',
      'hours': '1.5 hours',
      'member': '6 members',
      'price': '₹2000',
      'status': 'Completed',
      'icon': Icons.sports_basketball,
    },
  ];

  List<Map<String, dynamic>> get filteredBookings {
    if (selectedFilter == "All") return bookings;
    return bookings.where((b) => b['status'] == selectedFilter).toList();
  }

  @override
  void initState() {
    bloc = BlocProvider.of<BookingBloc>(context);
    super.initState();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Upcoming':
        return Colors.blue;
      case 'Completed':
        return Colors.green;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
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
        appBar: CommonAppBar(
          title: 'My Bookings',
          onLeftIconClickCallBack: () {
            if (widget.isComeFromSuccess == true) {
              Navigator.of(context).popUntil((route) => route.isFirst);
            } else {
              Navigator.pop(context);
            }
          },
        ),
        containChild: BlocListener<BookingBloc, BookingState>(
          listener: (BuildContext context, state) {},
          child: BlocBuilder<BookingBloc, BookingState>(
              bloc: bloc,
              builder: (BuildContext context, state) {
                return
                    // .isEmpty
                    //     ? Center(
                    //   child: Column(
                    //     children: [
                    //       Text(
                    //         AppString.noDataFound,
                    //         style: appTextStyle.noDataTextStyle(),
                    //       )
                    //     ],
                    //   ),
                    // )
                    // :
                    Stack(
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: 45,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: filters.length,
                            shrinkWrap: true,
                            padding: EdgeInsets.only(left: 20,right: 20),
                            itemBuilder: (context, index) {
                              final filter = filters[index];
                              final isSelected = filter == selectedFilter;
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: ChoiceChip(
                                  showCheckmark: false,
                                  label: Text(filter),
                                  selected: isSelected,
                                  onSelected: (_) {
                                    setState(() {
                                      selectedFilter = filter;
                                    });
                                  },
                                  selectedColor: AppColors.textBlueColor,
                                  backgroundColor: Colors.grey[200],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  labelStyle: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredBookings.length,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10).copyWith(top: 0),
                          itemBuilder: (context, index) {
                            final booking = filteredBookings[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  SlideLeftRoute(
                                    widget: const BookingDetailsScreen(),
                                  ),
                                );
                              },
                              child: CommonCardView(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 13),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                            decoration: BoxDecoration(
                                                color: Colors.grey.shade100,
                                                border: Border.all(
                                                    width: 0.2,
                                                    color: Colors.grey.shade200),
                                                borderRadius: BorderRadius.circular(8)),
                                            padding: const EdgeInsets.all(12),
                                            child: Icon(booking['icon'],
                                                size: 24, color: AppColors.appBlueColor)),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    booking['title'],
                                                    style: appTextStyle.appTitleStyle2()
                                                  ),
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                                    decoration: BoxDecoration(
                                                      color: _getStatusColor(booking['status']).safeOpacity(0.12),
                                                      borderRadius: BorderRadius.circular(12),),
                                                    child: Text(
                                                      booking['status'],
                                                      style: TextStyle(
                                                        fontSize: 10.5,
                                                        color: _getStatusColor(booking['status']),
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 6),
                                              Row(
                                                children: [
                                                  WorkplaceWidgets.calendarIcon(size: 16,color: Colors.grey.shade700),
                                                  const SizedBox(width: 6),
                                                  Text(
                                                    booking['date'],
                                                      style: appTextStyle.appSubTitleStyle3(fontSize: 13,color: Colors.grey.shade700)
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Icon(Icons.access_time,size: 16,color: Colors.grey.shade700,),
                                                  const SizedBox(width: 6),
                                                  Text(
                                                    booking['time'],
                                                    style: appTextStyle.appSubTitleStyle3(fontSize: 13,color: Colors.grey.shade700)
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 6),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(Icons.access_time,size: 16,color: Colors.grey.shade700,),
                                                      const SizedBox(width: 6),
                                                      Text(
                                                          booking['hours'],
                                                          style: appTextStyle.appSubTitleStyle3(fontSize: 13,color: Colors.grey.shade700)
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(Icons.group_rounded,size: 16,color: Colors.grey.shade700,),
                                                      const SizedBox(width: 6),
                                                      Text(booking['member'],
                                                          style: appTextStyle.appSubTitleStyle3(fontSize: 13,color: Colors.grey.shade700)
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(Icons.payment,size: 16,color: Colors.grey.shade700,),
                                                      const SizedBox(width: 6),
                                                      Text(
                                                        booking['price'],
                                                          style: appTextStyle.appTitleStyle2(fontSize: 15,fontWeight: FontWeight.w500)
                                                      ),
                                                    ],
                                                  ),

                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                            );
                          },
                        ),
                      ],
                    ),
                    // if (state is )
                    //   WorkplaceWidgets.progressLoader(context)
                  ],
                );
              }),
        ));
  }
}
