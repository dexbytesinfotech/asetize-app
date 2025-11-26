import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:asetize/imports.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../bloc/faq_bloc/faq_bloc.dart';
import '../bloc/faq_bloc/faq_event.dart';
import '../bloc/faq_bloc/faq_state.dart';

class FaqScreen extends StatefulWidget {
  final Function(dynamic)? onImageCallBack;
  const FaqScreen({Key? key, this.onImageCallBack}) : super(key: key);

  @override
  State createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  late bool isLeftTextAlign;
  int selectedIndex = -1;
  int selectedIndex2 = -1; //don't set it to 0
  bool isExpanded = false;
  bool isApiCall = false;
  FaqDataModel? faqDataModel;
  List<Data>? data = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FaqBloc bloc = BlocProvider.of<FaqBloc>(context);
    bool isShowLoader = false;
    AppDimens appDimens = AppDimens();
    appDimens.appDimensFind(context: context);

    Widget blackIconTiles() {
      return bloc.faqList.isEmpty
          ? Center(
              child: Text(
              AppString.noFaq,
              style: appTextStyle.noDataTextStyle(),
            ))
          : ListView.builder(
              key: Key('builder ${selectedIndex.toString()}'),
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: bloc.faqList.length,
              itemBuilder: (context, int index) {
                String title = bloc.faqList[index].title ?? "";
                String descriptions =
                    bloc.faqList[index].descriptions?.trim() ?? "";
                bool selected = selectedIndex == index;

                return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10)
                        .copyWith(bottom: 12),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.shade500,
                            blurRadius: 0.2,
                            offset: const Offset(0.0, 0.2))
                      ],
                    ),
                    child: FaqExpansionTileWidget(
                        key: Key(index.toString()),
                        //attention
                        initiallyExpanded: index == selectedIndex,
                        onCardClickCallBack: (z) {
                          setState(() {
                            selectedIndex = z ? index : -1;
                            descriptions.isEmpty
                                ? WorkplaceWidgets.successToast('Tapped on $title',durationInSeconds: 1)
                                : Container();
                          });
                        },
                        title: title,
                        titleTextStyle:appTextStyle.appTitleStyle(),
                        trailingIcon: descriptions.isEmpty
                            ? Icon(
                                selected
                                    ? Icons.arrow_drop_down_sharp
                                    : Icons.arrow_drop_down_sharp,
                                color: Colors.transparent,
                                size: 30,
                              )
                            : Icon(
                                selected
                                    ? Icons.arrow_drop_down_sharp
                                    : Icons.arrow_right,
                                color: Colors.grey,
                                size: 30),
                        children: [
                          Container(
                            padding:  const EdgeInsets.all(15)
                                .copyWith(top: 0, bottom: 16),
                            color: Colors.transparent,
                            child: HtmlWidget(
                              descriptions,
                              textStyle: appTextStyle.appSubTitleStyle(),
                            ),
                          ),
                        ]));
              },
            );
    }

    return ContainerFirst(
        reverse: false,
        contextCurrentView: context,
        isSingleChildScrollViewNeed: false,
        isListScrollingNeed: true,
        isFixedDeviceHeight: true,
        appBarHeight: 56,
        appBar: const CommonAppBar(
          title: AppString.faq,
        ),
        containChild: BlocBuilder<FaqBloc, FaqState>(
          builder: (context, state) {
            if (state is FaqInitState) {
              bloc.add(GetFaqListEvent(mContext: context));
            }
            if (state is FaqErrorState) {
              return Center(
                  child: Text(state.errorMessage));
            }
            if (state is FetchFaqDataState) {
              isShowLoader = false;
            }

            return RefreshIndicator(
              onRefresh: () async {
                isShowLoader = true;
                bloc.add(GetFaqListEvent(mContext: context));
                //await Future.delayed(const Duration(milliseconds: 2000));
              },
              child: Stack(
                children: [
                  blackIconTiles(),
                  if (state is FaqLoadingState)
                    WorkplaceWidgets.progressLoader(context,
                        color: isShowLoader == true
                            ? Colors.white.withOpacity(.4)
                            : Colors.white)
                ],
              ),
            );
          },
        ));
  }
}
