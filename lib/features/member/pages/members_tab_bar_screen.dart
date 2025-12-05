import 'package:asetize/features/member/pages/teams_screen.dart';
import '../../../core/util/app_permission.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../../imports.dart';
import '../../commitee_member_tab/bloc/commitee_member_bloc.dart';
import '../../commitee_member_tab/bloc/commitee_member_event.dart';
import '../../complaints/bloc/house_block_bloc/house_block_bloc.dart';
import '../bloc/team_member/team_member_bloc.dart';

class MembersTabBarScreen extends StatefulWidget {
  const MembersTabBarScreen({super.key});

  @override
  State<MembersTabBarScreen> createState() => _MembersTabBarScreenState();
}

class _MembersTabBarScreenState extends State<MembersTabBarScreen>
    with SingleTickerProviderStateMixin {
  bool isGrid = true;
  late TeamMemberBloc bloc;
  late UserProfileBloc userProfileBloc;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<TeamMemberBloc>(context);
    userProfileBloc = BlocProvider.of<UserProfileBloc>(context);

    PrefUtils()
        .readBool(WorkplaceNotificationConst.teamViewIsGrid)
        .then((value) {
      setState(() {
        isGrid = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeamMemberBloc, TeamMemberState>(
      bloc: bloc,
      builder: (context, state) {
        if (state is TeamMemberInitial) {
          bloc.add(FetchTeamList(mContext: context));
        }
        if (state is StoreTeamViewIsListOrGridState) {
          isGrid = state.isGrid;
        }

        return ContainerFirst(
          contextCurrentView: context,
          isSingleChildScrollViewNeed: false,
          isListScrollingNeed: true,
          isFixedDeviceHeight: false,
          appBarHeight: 56,
          bottomSafeArea: true,
          appBar: appBar(),
          containChild: const Expanded(
            child: TeamsScreen(), // 🔥 ONLY MEMBERS SCREEN
          ),
        );
      },
    );
  }

  Widget appBar() {
    return Container(
      padding: const EdgeInsets.only(left: 4, right: 10),
      decoration: const BoxDecoration(
        color: Color(0xFFF5F5F5),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 17, right: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppString.members,
              textAlign: TextAlign.center,
              style: appTextStyle.appBarTitleStyle(),
            ),

            // Show grid/list toggle only for members
            isGrid
                ? IconButton(
              icon: SvgPicture.asset('assets/images/list1.svg'),
              onPressed: () {
                bloc.add(const StoreTeamViewIsListOrGridEvent(
                    isGrid: false));
              },
            )
                : IconButton(
              icon: SvgPicture.asset(
                'assets/images/grid_icon.svg',
              ),
              onPressed: () {
                bloc.add(const StoreTeamViewIsListOrGridEvent(
                    isGrid: true));
              },
            ),
          ],
        ),
      ),
    );
  }
}
