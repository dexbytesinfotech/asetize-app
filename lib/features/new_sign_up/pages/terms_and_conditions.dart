import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:asetize/imports.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../bloc/new_signup_bloc.dart';
import '../bloc/new_signup_event.dart';
import '../bloc/new_signup_state.dart';


class TermsAndCondition extends StatefulWidget {
  const TermsAndCondition({Key? key}) : super(key: key);

  @override
  State createState() => TermsAndConditionState();
}

class TermsAndConditionState extends State<TermsAndCondition> {
  late NewSignupBloc bloc;


  @override
  void initState() {
    bloc = BlocProvider.of<NewSignupBloc>(context);
    bloc.add(OnTermsAndConditionEvent(mContext: context, slug: 'about-us'));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ContainerFirst(
      contextCurrentView: context,
      isSingleChildScrollViewNeed: true,
      isFixedDeviceHeight: false,
      appBarHeight: 50,
      appBar: const CommonAppBar(title: AppString.termsAndConditionsText),
      containChild: BlocBuilder<NewSignupBloc, NewSignupState>(
        bloc: bloc,
        builder: (context, state) {
          if (state is SignupInitialState) {
            bloc.add(OnTermsAndConditionEvent(mContext: context, slug: 'about-us'));
          }
          if (state is TermsAndConditionErrorState) {
            return Center(child: Text(state.errorMessage,style: appTextStyle.errorTextStyle()));
          }
          if (state is SignupLoadingState) {
            return WorkplaceWidgets.progressLoader(context);
          }
          return bloc.termsAndCondition.isEmpty ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  AppString.noData,
                  style : appTextStyle.noDataTextStyle(),
                ),
              )
            ],
          ): ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: bloc.termsAndCondition.length,
            itemBuilder: (context, int index) {
              String content = '${bloc.termsAndCondition[index].content}';
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
