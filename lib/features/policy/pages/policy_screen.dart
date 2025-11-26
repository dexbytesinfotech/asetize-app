import 'package:asetize/features/policy/pages/pdf_view_page.dart';
import 'package:asetize/features/policy/pages/policy_list_screen.dart';
import '../../../imports.dart';
import '../bloc/policy_bloc/policy_bloc.dart';
import '../bloc/policy_bloc/policy_event.dart';
import '../bloc/policy_bloc/policy_state.dart';
class PolicyScreen extends StatefulWidget {
  final int? postId;
  const PolicyScreen({super.key, this.postId});

  @override
  State<PolicyScreen> createState() => _PolicyScreenState();
}

class _PolicyScreenState extends State<PolicyScreen> {
  late PolicyBloc policyBloc;

  @override
  void initState() {
    policyBloc = BlocProvider.of<PolicyBloc>(context);
    if (widget.postId != null) {
      policyBloc.add(
          GetPolicyDataByIdEvent(mContext: context, postId: widget.postId));
    } else {
      policyBloc.add(GetPolicyDataEvent(mContext: context));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ContainerFirst(
        contextCurrentView: context,
        isSingleChildScrollViewNeed: false,
        isFixedDeviceHeight: true,
        isListScrollingNeed: true,
        appBarHeight: 50,
        appBar: const CommonAppBar(
          title:AppString.policy,
        ),
        containChild: BlocConsumer<PolicyBloc, PolicyState>(
          listener: (BuildContext context, state) {
            if (state is GetPolicyByIdDoneState) {
              if (policyBloc.policyDataById!.fileCount! > 1) {
                Navigator.push(
                        context,
                    SlideLeftRoute(
                            widget:  PolicyListScreen(
                                files: policyBloc.policyDataById!.files ?? [],
                                title: policyBloc.policyDataById?.title)))
                    .then((value) {
                  Navigator.of(context).pop();
                });
              } else {
                if (policyBloc.policyDataById?.files?.first.type == "pdf") {
                  Navigator.push(
                      context,
                      SlideLeftRoute(
                          widget:  PdfViewPage(
                                title: policyBloc
                                    .policyDataById?.files?.first.fileName,
                                type: policyBloc
                                    .policyDataById?.files?.first.type,
                                pdfUrl: policyBloc
                                        .policyDataById?.files?.first.url ??
                                    '',
                              ))).then((value) {
                    Navigator.of(context).pop();
                  });
                } else if (policyBloc.policyDataById?.files?.first.type ==
                    "image") {
                  Navigator.of(context)
                      .push(FadeRoute(
                          widget: FullPhotoView(
                                title: policyBloc
                                    .policyDataById?.files?.first.fileName,
                                profileImgUrl: policyBloc
                                        .policyDataById?.files?.first.url ??
                                    '',
                              )))
                      .then((value) {
                    Navigator.of(context).pop();
                  });
                }
              }
            }
          },
          bloc: policyBloc,
          builder: (BuildContext context, state) {
            if (state is PolicyLoadingState) {
              return const Center(
                  child: CircularProgressIndicator(
                color: Colors.blueAccent,
              ));
            }

            return (widget.postId != null)
                ? WorkplaceWidgets.policyWidget(
                    title: '${policyBloc.policyDataById?.title}',
                    content: '${policyBloc.policyDataById?.content}',
                    fileCount: policyBloc.policyDataById?.fileCount,
                    onTap: () {
                      if (policyBloc.policyDataById!.fileCount! > 1) {
                        Navigator.push(
                            context,
                            SlideLeftRoute(
                                widget: PolicyListScreen(
                                    files:
                                        policyBloc.policyDataById!.files ?? [],
                                    title: policyBloc.policyDataById?.title)));
                      } else {
                        if (policyBloc.policyDataById?.files?.first.type ==
                            "pdf") {
                          Navigator.push(
                              context,
                              SlideLeftRoute(
                                  widget:  PdfViewPage(
                                        title: policyBloc.policyDataById?.files
                                            ?.first.fileName,
                                        type: policyBloc
                                            .policyDataById?.files?.first.type,
                                        pdfUrl: policyBloc.policyDataById?.files
                                                ?.first.url ??
                                            '',
                                      )));
                        } else if (policyBloc
                                .policyDataById?.files?.first.type ==
                            "image") {
                          Navigator.of(context).push(FadeRoute(
                              widget: FullPhotoView(
                                    title: policyBloc
                                        .policyDataById?.files?.first.fileName,
                                    profileImgUrl: policyBloc
                                            .policyDataById?.files?.first.url ??
                                        '',
                                  )));
                        }
                      }
                    },
                  )
                : (policyBloc.policyData.isEmpty)
                    ? Center(
                        child: Text(
                          AppString.noData,
                          style: appStyles.noDataTextStyle(),
                        ),
                      )
                    : ListView.separated(
                        padding: EdgeInsets.zero,
                        itemCount: policyBloc.policyData.length,
                        itemBuilder: (BuildContext context, int index) {
                          return WorkplaceWidgets.policyWidget(
                            title: '${policyBloc.policyData[index].title}',
                            content: '${policyBloc.policyData[index].content}',
                            fileCount: policyBloc.policyData[index].fileCount,
                            onTap: () {
                              if (policyBloc.policyData[index].fileCount! > 1) {
                                Navigator.push(
                                    context,
                                    SlideLeftRoute(
                                        widget: PolicyListScreen(
                                            files: policyBloc
                                                    .policyData[index].files ??
                                                [],
                                            title: policyBloc
                                                .policyData[index].title)));
                              } else {
                                if (policyBloc
                                        .policyData[index].files?[0].type ==
                                    "pdf") {
                                  Navigator.push(
                                      context,
                                      SlideLeftRoute(
                                          widget: PdfViewPage(
                                                title: policyBloc
                                                    .policyData[index]
                                                    .files?[0]
                                                    .fileName,
                                                type: policyBloc
                                                    .policyData[index]
                                                    .files?[0]
                                                    .type,
                                                pdfUrl: policyBloc
                                                        .policyData[index]
                                                        .files?[0]
                                                        .url ??
                                                    '',
                                              )));
                                } else if (policyBloc
                                        .policyData[index].files?[0].type ==
                                    "image") {
                                  Navigator.of(context).push(FadeRoute(
                                      widget:  FullPhotoView(
                                            title: policyBloc.policyData[index]
                                                .files?[0].fileName,
                                            profileImgUrl: policyBloc
                                                    .policyData[index]
                                                    .files?[0]
                                                    .url ??
                                                '',
                                          )));
                                }
                              }
                            },
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
                      );
          },
        ));
  }
}
