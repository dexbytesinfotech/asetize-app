import 'package:asetize/widgets/common_search_bar.dart';

import '../../../core/util/app_theme/text_style.dart';
import '../../../imports.dart';
import '../bloc/booking_bloc.dart';
import '../widgets/amenity_type_widget.dart';
import '../widgets/booking_card_view.dart';
import 'amenity_details_and_terms_screen.dart';
import 'booking_details_screen.dart';
import 'my_booking_screen.dart';

class NewMyBookingScreen extends StatefulWidget {
  const NewMyBookingScreen({super.key});

  @override
  State<NewMyBookingScreen> createState() =>
      _NewMyBookingScreenState();
}

class _NewMyBookingScreenState extends State<NewMyBookingScreen> {
  late BookingBloc bloc;
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    bloc = BlocProvider.of<BookingBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }


  Widget amenityList() {
    return  ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: 3,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final bookings = [
          {
            "venue": "Swimming Pool",
            "type": "Recreation",
            "date": DateTime(2025, 10, 15),
            "time": "10:00 AM - 12:00 PM",
            "guests": 4,
            "bookingRef": "BK001",
            "status": "confirmed",
          },
          {
            "venue": "Party Hall",
            "type": "Event Space",
            "date": DateTime(2025, 10, 20),
            "time": "6:00 PM - 10:00 PM",
            "guests": 25,
            "bookingRef": "BK002",
            "status": "pending",
          },
          {
            "venue": "Tennis Court",
            "type": "Sports",
            "date": DateTime(2025, 10, 8),
            "time": "7:00 AM - 8:00 AM",
            "guests": 2,
            "bookingRef": "BK003",
            "status": "cancelled",
          },
        ];
        final booking = bookings[index];
        return BookingCardView(
          onTab: (){

            Navigator.push(
              context,
              SlideLeftRoute(
                widget: const BookingDetailsScreen(),
              ),
            );
          },
          venue: booking["venue"] as String,
          type: booking["type"] as String,
          date: booking["date"] as DateTime,
          time: booking["time"] as String,
          guests: booking["guests"] as int,
          bookingRef: booking["bookingRef"] as String,
          status: booking["status"] as String,
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
        appBar: CommonAppBar(
          title: 'My Bookings',
          // onLeftIconClickCallBack: () {
          //   // if (widget.isComeFromSuccess == true) {
          //   //   Navigator.of(context).popUntil((route) => route.isFirst);
          //   // } else {
          //   //   Navigator.pop(context);
          //   // }
          // },
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
                  //     :
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, top: 0, bottom: 20),
                        child: Column(
                          children: [
                            amenityList(),
                          ],
                        ),
                      ),
                      // if (state is )
                      //   WorkplaceWidgets.progressLoader(context)
                    ],
                  );
              }),
        ));
  }
}
