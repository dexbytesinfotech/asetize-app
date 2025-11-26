import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:intl/intl.dart';
import '../../../core/util/app_theme/app_string.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../../core/util/workplace_icon.dart';
import '../../presentation/widgets/appbar/common_appbar.dart';
import '../../presentation/widgets/basic_view_container/container_first.dart';
import '../../presentation/widgets/pinch_zoom_widget.dart';
import '../../presentation/widgets/workplace_widgets.dart';

class NoticeDetailPage extends StatelessWidget {
  final String content;
  final String date;
  final String title;

  const NoticeDetailPage({
    Key? key,
    required this.content,
    required this.title,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ContainerFirst(
      contextCurrentView: context,
      isSingleChildScrollViewNeed: true,
      isFixedDeviceHeight: true,
      isListScrollingNeed: false,
      isOverLayStatusBar: false,
      appBarHeight: 56,
      appBar: const CommonAppBar(
        title: AppString.noticeBoard,
        icon: WorkplaceIcons.backArrow,
      ),
      containChild: PinchZoomReleaseUnzoomWidget(
        fingersRequiredToPinch: 2,
        child: Padding(
          padding: const EdgeInsets.all(15.0).copyWith(top: 5, left: 10),
          child: Column(
            mainAxisSize: MainAxisSize.max, // Use max to fill available space
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:  EdgeInsets.only(right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    WorkplaceWidgets.calendarIcon(),
                    const SizedBox(width: 10),
                    Text(
                      date, // Use the date passed to the constructor
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15,right: 10,top: 10),
                child: HtmlWidget(
                  title, // Pass the HTML content
                  textStyle: appTextStyle.appTitleStyle(),
                  customStylesBuilder: (element) {
                    return {
                      'text-align': 'justify', // Ellipsis for overflow
                    };
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0).copyWith(top: 10, right: 10),
                child: HtmlWidget(
                  content, // Pass the HTML content
                  textStyle: appTextStyle.appNormalTextStyle(),
                  customStylesBuilder: (element) {
                    return {
                      // 'max-lines': '7', // Limit to 7 lines (if required)
                      // 'text-overflow': 'ellipsis', // Ellipsis for overflow
                      'text-align': 'justify', // Ellipsis for overflow
                    };
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
