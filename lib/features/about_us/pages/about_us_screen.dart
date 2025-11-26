import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:asetize/imports.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../bloc/about_bloc/about_bloc.dart';
import '../bloc/about_bloc/about_event.dart';
import '../bloc/about_bloc/about_state.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  State createState() => AboutUsScreenState();
}

class AboutUsScreenState extends State<AboutUsScreen> {
  late AboutBloc bloc;
  @override
  void initState() {
    bloc = BlocProvider.of<AboutBloc>(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ContainerFirst(
      contextCurrentView: context,
      isSingleChildScrollViewNeed: true,
      isFixedDeviceHeight: false,
      appBarHeight: 50,
      appBar: const CommonAppBar(title: AppString.aboutUS),
      containChild: BlocBuilder<AboutBloc, AboutState>(
        bloc: bloc,
        builder: (context, state) {
          if (state is AboutInitialState) {
            bloc.add(FetchAboutDataEvent(mContext: context));
          }
          if (state is AboutErrorState) {
            return Center(child: Text(state.errorMessage,style: appTextStyle.errorTextStyle()));
          }
          if (state is AboutLoadingState) {
            return WorkplaceWidgets.progressLoader(context);
          }
          return bloc.aboutUsList.isEmpty
              ? Center(
              child: Text(
                state is AboutLoadingState ? '' : AppString.noData,
                style: appStyles.noDataTextStyle(),
              ))
              : ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: bloc.aboutUsList.length,
            itemBuilder: (context, int index) {
              String content = '${bloc.aboutUsList[index].content}';
              String justifyContent = '''
                    <div style="text-align: justify; font-size: 16px; color: black;">
                       $content
                    </div>
                    ''';
              return Container(
                margin: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HtmlWidget(
                      justifyContent,
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
