import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:asetize/features/policy/pages/pdf_view_page.dart';

import '../../../core/util/app_theme/text_style.dart';
import '../../../imports.dart';
import '../../data/models/get_policy_data_model.dart';

class PolicyListScreen extends StatefulWidget {
  final List<Files> files;
  final String? title;
  const PolicyListScreen({super.key, required this.files, this.title});

  @override
  State<PolicyListScreen> createState() => _PolicyListScreenState();
}

class _PolicyListScreenState extends State<PolicyListScreen> {
  String fileIcon(String fileFormat) {
    switch (fileFormat) {
      case 'pdf':
        return WorkplaceIcons.pdfFormat;
      case 'doc':
        return WorkplaceIcons.docFormat;
      case 'image':
        return WorkplaceIcons.imageFormat;
      default:
        return WorkplaceIcons.imageFormat;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ContainerFirst(
        contextCurrentView: context,
        isSingleChildScrollViewNeed: false,
        isFixedDeviceHeight: true,
        isListScrollingNeed: true,
        appBarHeight: 56,
        appBar: DetailsScreenAppBar(
          title: widget.title ?? "Leave Policy",
        ),
        containChild: ListView.separated(
          padding: EdgeInsets.zero,
          itemCount: widget.files.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                if (widget.files[index].type == "pdf") {
                  Navigator.push(
                      context,
                      SlideLeftRoute(
                          widget:PdfViewPage(
                                title: widget.files[index].fileName,
                                type: widget.files[index].type,
                                pdfUrl: widget.files[index].url ?? '',
                              )));
                } else if (widget.files[index].type == "image") {
                  Navigator.of(context).push(FadeRoute(
                      widget:  FullPhotoView(
                            title: widget.files[index].fileName,
                            profileImgUrl: widget.files[index].url ?? '',
                          )));
                }
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.indigoAccent.withOpacity(.1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SvgPicture.asset(
                            fileIcon(widget.files[index].type ?? 'pdf')),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HtmlWidget(
                            '${widget.files[index].fileName}',
                            // maxLines: 1,
                            // overflow: TextOverflow.ellipsis,
                            textStyle: appTextStyle.appNormalTextStyle(),),
                          Row(
                            children: [
                              Text(
                                '${widget.files[index].createdAt}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style : appTextStyle.appNormalSmallTextStyle(color: Colors.black.withOpacity(.6)),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                '${widget.files[index].fileSize}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: appTextStyle.appNormalSmallTextStyle(color: Colors.black.withOpacity(.6)),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: Colors.black,
                          size: 18,
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.sp),
              child: const Divider(
                thickness: 0.5,
              ),
            );
          },
        ));
  }
}
