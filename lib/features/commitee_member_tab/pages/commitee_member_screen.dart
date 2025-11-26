import 'package:asetize/imports.dart';
import '../../../app_global_components/network_status_alert_view.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../member/bloc/team_member/team_member_bloc.dart';
import '../../member/pages/member_profile_bottom_sheet.dart';
import '../bloc/commitee_member_bloc.dart';
import '../bloc/commitee_member_event.dart';
import '../bloc/commitee_member_state.dart';
import '../../presentation/widgets/commitee_card_widget.dart';
import '../models/commitee_member_model.dart';

class CommitteeMemberScreen extends StatefulWidget {
  const CommitteeMemberScreen({Key? key}) : super(key: key);
  @override
  State createState() => _CommitteeMemberScreenState();
}

class _CommitteeMemberScreenState extends State<CommitteeMemberScreen> {
  TextEditingController controller = TextEditingController();
  late CommitteeMemberBloc committeeMemberBloc;
  List<CommitteeMembersList> searchedItems = [];
  bool isLoading = false;

  @override
  void initState() {
    committeeMemberBloc = BlocProvider.of<CommitteeMemberBloc>(context);
    if (committeeMemberBloc.committeeMemberList.isEmpty) {
      committeeMemberBloc.add(FetchCommitteeMembers(mContext: context));
    }
    super.initState();
  }

  void filter(String searchText, List<CommitteeMembersList> data) {
    List<CommitteeMembersList> results = [];
    if (searchText.isEmpty) {
      results = data;
    } else {
      results = data.where((element) =>
      element.name!.toLowerCase().startsWith(searchText.toLowerCase()) ||
          (element.shortDescription != null &&
              element.shortDescription!.toLowerCase().contains(searchText.toLowerCase()))
      ).toList();
    }
    setState(() {
      searchedItems = results;
    });
  }

  Widget searchBar() {
    return Container(
      margin: const EdgeInsets.only(top: 2, bottom: 5),
      padding: const EdgeInsets.symmetric(horizontal: 19),
      height: 50,
      child: TextField(
        controller: controller,
        onChanged: (searchText) {
          filter(searchText, committeeMemberBloc.committeeMemberList);
        },
        style: appTextStyle.appSubTitleStyle(
            fontWeight: FontWeight.normal, fontSize: 16),
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          hintText: AppString.searchWithDot,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
            icon: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SvgPicture.asset('assets/images/cross_icon.svg'),
            ),
            onPressed: () {
              controller.clear();
              FocusScope.of(context).unfocus();
              if (controller.text.isEmpty) {
                searchedItems = committeeMemberBloc.committeeMemberList;
              }
            },
          )
              : null,
          contentPadding: const EdgeInsets.only(top: 5),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppDimens appDimens = AppDimens();
    appDimens.appDimensFind(context: context);

    return BlocListener<CommitteeMemberBloc, CommitteeMemberState>(
      bloc: committeeMemberBloc,
      listener: (BuildContext context, CommitteeMemberState state) {
        if (state is CommitteeMemberError) {
          WorkplaceWidgets.errorSnackBar(context, state.message);
        }
      },
      child: BlocBuilder<CommitteeMemberBloc, CommitteeMemberState>(
        builder: (context, state) {
          if (state is CommitteeMemberLoaded) {
            isLoading = false;
            if (controller.text.isEmpty) {
              searchedItems = committeeMemberBloc.committeeMemberList;
            }
          }

          return RefreshIndicator(
            color: AppColors.appBlueA,
            onRefresh: () async {
              committeeMemberBloc.add(FetchCommitteeMembers(mContext: context));
              await Future.delayed(
                  const Duration(seconds: 1)); // Wait for 2 seconds
            },
            child: Stack(
              children: [
                // Display the list or "no data" message only when not loading
              //  if (!isLoading)
                  committeeMemberBloc.committeeMemberList.isNotEmpty
                      ? ListView(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          children: [
                            Column(
                              children: [
                                const SizedBox(height: 12),
                                searchBar(),
                                searchedItems.isEmpty
                                    ? SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                1.5,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              AppString.noCommitteeMember,
                                              style: appTextStyle
                                                  .noDataTextStyle(),
                                            )
                                          ],
                                        ),
                                      )
                                    : RefreshIndicator(
                                        color: AppColors.appBlueA,
                                        onRefresh: () async {
                                          committeeMemberBloc.add(
                                              FetchCommitteeMembers(
                                                  mContext: context));

                                          await Future.delayed(const Duration(
                                              seconds:
                                                  1)); // Wait for 2 seconds
                                        },
                                        child: ListView.builder(
                                          padding: EdgeInsets.only(
                                              left: 4.sp,
                                              right: 4.sp,
                                              bottom: 65),
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          scrollDirection: Axis.vertical,
                                          itemCount: searchedItems.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            final committeeMember =
                                                searchedItems[index];
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 6, left: 7, right: 7),
                                              child: CommitteeCardWidget(
                                                imageUrl: committeeMember
                                                    .profilePhoto,
                                                userName: committeeMember.name,
                                                jobTitle: committeeMember.shortDescription,
                                                onClickCallBack: ()
                                                {
                                                  return showModalBottomSheet(
                                                    context: MainAppBloc.getDashboardContext,
                                                    isDismissible: false,
                                                    enableDrag: true,
                                                    isScrollControlled: true,
                                                    backgroundColor: Colors.transparent,
                                                    shape: const RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.vertical(top: Radius.circular(15)),
                                                    ),
                                                    builder: (ctx) => StatefulBuilder(
                                                      builder: (ctx, state) => Padding(
                                                        padding:EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                                                        child: MemberProfileBottomSheet(
                                                             userData: User(
                                                                name: committeeMember.name,
                                                                profilePhoto: committeeMember.profilePhoto,
                                                                 shortDescription: committeeMember.shortDescription,
                                                                phone: committeeMember.phone,
                                                                countryCode: committeeMember.countryCode,
                                                               houses: committeeMember.houses,
                                                             ),
                                                        ),
                                                      ),
                                                    ),
                                                  ).then((value){

                                                  });
                                                },
                                                shortDescription: committeeMember
                                                                .shortDescription !=
                                                            null &&
                                                        committeeMember
                                                            .shortDescription!
                                                            .isNotEmpty
                                                    ? committeeMember
                                                        .shortDescription!
                                                    : 'A1-201, B-203',
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                              ],
                            ),
                          ],
                        )
                      : Center(
                          child: Text(
                            AppString.noDataFound,
                            style: appTextStyle.noDataTextStyle(),
                          ),
                        ),
                if (isLoading && state is CommitteeMemberLoading)
                  WorkplaceWidgets.progressLoader(context),

                NetworkStatusAlertView(onReconnect: () async {
                  committeeMemberBloc.add(FetchCommitteeMembers(mContext: context));
                  await Future.delayed(
                      const Duration(seconds: 1));
                },)
              ],
            ),
          );
        },
      ),
    );
  }
}
