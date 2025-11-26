import 'package:asetize/widgets/common_card_view.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../../imports.dart';
import '../../follow_up/pages/add_new_task.dart';
import 'date_selection_screen.dart';
import 'new_booking_request.dart';

class AmenityDetailsAndTermsScreen extends StatefulWidget {
  const AmenityDetailsAndTermsScreen({super.key});

  @override
  State<AmenityDetailsAndTermsScreen> createState() =>
      _AmenityDetailsAndTermsScreenState();
}

class _AmenityDetailsAndTermsScreenState
    extends State<AmenityDetailsAndTermsScreen> {

  Widget _infoTile({required String title, required String value}) {
    return CommonCardView(
      margin: EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: appTextStyle.appSubTitleStyle3(),
            ),
            Text(
              value,
              style: appTextStyle.appTitleStyle2(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  Widget expansionTileView(){
    return CommonCardView(
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.grey),
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16),
          initiallyExpanded: true,
          title: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Terms & Conditions',
              style: appTextStyle.appTitleStyle2(),
            ),
          ),
          childrenPadding: const EdgeInsets.only(bottom: 20,left: 0,),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '1. Maximum capacity: 8 persons at a time',
                  style: appTextStyle.appSubTitleStyle3(fontSize: 13,color: Colors.grey.shade700),
                ),
                SizedBox(height: 8),
                Text(
                    '2. Children below 12 must be accompanied by adults',
                    style: appTextStyle.appSubTitleStyle3(fontSize: 13,color: Colors.grey.shade700)),
                SizedBox(height: 8),
                Text('3. Proper swimming attire required',
                    style: appTextStyle.appSubTitleStyle3(fontSize: 13,color: Colors.grey.shade700)),
                SizedBox(height: 8),
                Text('4. No food or drinks allowed in pool area',
                    style: appTextStyle.appSubTitleStyle3(fontSize: 13,color: Colors.grey.shade700)),
              ],
            ),
          ],
        ),
      ),
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
        title: 'Amenity Details',
      ),
      containChild: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(bottom: 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SliderScreen(
              viewportFraction: 0.86,
              activeDotColor: AppColors.loaderColor2,
              enlargeCenterPage: true,
              isDotVisible: true,
              imageHeight: 180,
              urlImages: [
                'https://img.freepik.com/free-photo/umbrella-chair_74190-2092.jpg?semt=ais_hybrid&w=740',
                'https://t3.ftcdn.net/jpg/02/80/11/26/360_F_280112608_32mLVErazmuz6OLyrz2dK4MgBULBUCSO.jpg',
                'https://images.pexels.com/photos/1227571/pexels-photo-1227571.jpeg?cs=srgb&dl=pexels-freestockpro-1227571.jpg&fm=jpg',
              ],
            ),
            // Material(
            //   borderRadius: BorderRadius.circular(12),
            //   elevation: 1.5,
            //   shadowColor: Colors.grey.shade500,
            //   child:  ClipRRect(
            //     borderRadius: BorderRadius.circular(12),
            //     child: CachedNetworkImage(
            //       placeholder: (context, url) =>  const ImageLoader(),
            //       errorWidget: (context, url, error) => Image.asset(
            //         "assets/images/profile_avatar.png",
            //         height: 170,
            //         width: double.infinity,
            //         fit: BoxFit.cover,
            //       ),
            //       imageUrl: "https://m.media-amazon.com/images/I/71fEvvr2k1S.jpg",
            //       height: 170,
            //       width: double.infinity,
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            // ),
            const SizedBox(height: 8),
            expansionTileView(),
            const SizedBox(height: 12),
            _infoTile(title: 'Booking Charge', value: '₹500/hour'),
            _infoTile(title: 'Available Time Slots', value: '8:00 AM - 10:00 PM'),
            _infoTile(title: 'Maximum Duration', value: '8 hours'),
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
              buttonName: 'Proceed to Booking',
              buttonColor: AppColors.textBlueColor,
              backCallback: () {
                Navigator.push(
                  MainAppBloc.getDashboardContext,
                  SlideLeftRoute(widget: const NewBookingRequest()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
