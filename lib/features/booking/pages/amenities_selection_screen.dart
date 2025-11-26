import 'package:asetize/widgets/common_search_bar.dart';

import '../../../core/util/app_theme/text_style.dart';
import '../../../imports.dart';
import '../bloc/booking_bloc.dart';
import '../widgets/amenity_type_widget.dart';
import 'amenity_details_and_terms_screen.dart';
import 'my_booking_screen.dart';
import 'new_my_booking_screen.dart';

class AmenitiesSelectionScreen extends StatefulWidget {
  const AmenitiesSelectionScreen({super.key});

  @override
  State<AmenitiesSelectionScreen> createState() =>
      _AmenitiesSelectionScreenState();
}

class _AmenitiesSelectionScreenState extends State<AmenitiesSelectionScreen> {
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

  Widget searchBar() {
    return CommonSearchBar(
      margin: EdgeInsets.symmetric(horizontal: 10),
      padding: EdgeInsets.zero,
      hintText: 'Search amenities',
      controller: controller,
      onChangeTextCallBack: (searchText) {},
      onClickCrossCallBack: () {
        controller.clear();
        FocusScope.of(context).unfocus();
      },
    );
  }

  Widget amenityList() {
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 5),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
      itemBuilder: (context, index) {
        return AmenityTypeWidget(
          onTab: () {
            Navigator.push(
              context,
              SlideLeftRoute(
                widget: const AmenityDetailsAndTermsScreen(),
              ),
            );
          },
          imageUrl: "https://m.media-amazon.com/images/I/71fEvvr2k1S.jpg",
          amenityName: "Swimming Pool",
          description: "Open 10AM - 6PM",
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
          title: 'Select an Amenity',
          action: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  SlideLeftRoute(
                    widget: const NewMyBookingScreen(),
                  ),
                );
              },
              child: Container(
                  color: Colors.transparent,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  child: const Icon(
                    Icons.calendar_month,
                    size: 26,
                    color: Colors.black,
                  ))),
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
                          searchBar(),
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
