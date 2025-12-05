import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:asetize/widgets/common_card_view.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../../core/util/one_signal_notification/one_signal_notification_handler.dart';
import '../../../imports.dart';
import '../../noc_list/widgets/noc_request_shimmer.dart';
import '../bloc/home_new_bloc.dart';
import '../bloc/home_new_event.dart';
import '../bloc/home_new_state.dart';
import '../models/notice_board.dart';
import 'notice_detail_page.dart';

class AllNoticeScreen extends StatefulWidget {
  const AllNoticeScreen({super.key});

  @override
  State<AllNoticeScreen> createState() => _AllNoticeScreenState();
}

class _AllNoticeScreenState extends State<AllNoticeScreen> {
  late HomeNewBloc homeNewBloc;
  bool isShowLoader = true;


  @override
  void initState() {
    super.initState();
    homeNewBloc = BlocProvider.of<HomeNewBloc>(context);
    homeNewBloc.add(OnHomeNoticeBoardEvent());
    OneSignalNotificationsHandler.instance.refreshPage = refreshDataOnNotificationComes;
  }

  Future<void> refreshDataOnNotificationComes() async {
    isShowLoader = false;
    homeNewBloc.add(OnHomeNoticeBoardEvent());
  }

  int _calculateMaxLines(String text, double maxWidth, TextStyle style) {
    final span = TextSpan(text: text, style: style);
    final tp = TextPainter(
      text: span,
      maxLines: null,
      textDirection: TextDirection.ltr,
    );
    tp.layout(maxWidth: maxWidth);
    return tp.computeLineMetrics().length;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height / 1.5;

    return ContainerFirst(
      contextCurrentView: context,
      isSingleChildScrollViewNeed: false,
      isFixedDeviceHeight: true,
      isListScrollingNeed: true,
      isOverLayStatusBar: false,
      isOverLayAppBar: false,
      appBarHeight: 56,
      appBar: const CommonAppBar(
        title: AppString.noticeBoard,
        icon: WorkplaceIcons.backArrow,
      ),
      containChild:
      BlocBuilder<HomeNewBloc, HomeNewState>(
        bloc: homeNewBloc,
        builder: (BuildContext context, state) {
          if (state is NoticeboardLoadingState) {

            if (isShowLoader == true) {
              return                         NocRequestShimmer()   ;
          }

          }
          return
            homeNewBloc.notices.isEmpty
                ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    'No notice available',
                    style: appStyles.noDataTextStyle(),
                  ),
                ),
              ],
            )
                : ListView.builder(
              padding: const EdgeInsets.only(top: 5),
              itemCount: homeNewBloc.notices.length, // Number of announcements
              itemBuilder: (context, index) {
                Notice notice = homeNewBloc.notices[index];
                final contentText = notice.content;
                const textStyle = TextStyle(
                  letterSpacing: 0,
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                );

                // Calculate the number of lines
                final maxLines = _calculateMaxLines(contentText,
                    MediaQuery.of(context).size.width - 32, textStyle);

                return Padding(padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0), // Adjusted padding
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        SlideLeftRoute(
                          widget:  NoticeDetailPage(
                            content: contentText,
                            date: notice.createdAt,
                            title:  notice.title.trim(),
                          ),
                        ),
                      );
                    },
                    child: CommonCardView(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0).copyWith(left: 15, right: 15, top: 15,bottom: 15), // Reduced padding
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text(
                              notice.title.trim(),
                              style:
                              appTextStyle.appTitleStyle(fontSize: 15),
                            ),
                            const SizedBox(height: 10),
                            HtmlWidget(
                              contentText, // Pass the HTML content
                              textStyle: appTextStyle.appSubTitleStyle(
                                  fontWeight: FontWeight.normal),
                              customStylesBuilder: (element) {
                                return {
                                  'max-lines':
                                  '7', // Limit to 7 lines (if required)
                                  'text-overflow':
                                  'ellipsis', // Ellipsis for overflow
                                  'text-align':
                                  'justify', // Ellipsis for overflow
                                };
                              },
                            ),
                            // Text(
                            //   contentText,
                            //   style: textStyle,
                            //   textAlign: TextAlign.justify,
                            //   maxLines: 7, // Keep this as 7 to show limited lines initially
                            //   overflow: TextOverflow.ellipsis, // Ellipsis for overflow
                            // ),
                            if (maxLines >
                                7) // Show 'Read More' if the text exceeds 7 lines
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    SlideLeftRoute(
                                      widget:  NoticeDetailPage(
                                        content:
                                        contentText, // Pass the full content
                                        date: notice.createdAt,
                                        title: notice.title.trim(),
                                      ),
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      AppString.readMoreCaps,
                                      style: appTextStyle.appSubTitleStyle(
                                        color: AppColors.textBlueColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            SizedBox(height: 4,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                 WorkplaceWidgets.calendarIcon(size: 15),
                                const SizedBox(width: 6),
                                Text(
                                  notice.createdAt,
                                  style:
                                  appTextStyle.appTitleStyle(fontSize: 12,fontWeight: FontWeight.normal, color: Colors.grey.shade500,),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
        },
      ),
    );
  }
}
