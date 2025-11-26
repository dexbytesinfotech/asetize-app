import '../../../../core/util/app_navigator/app_navigator.dart';
import '../../../../imports.dart';
part 'team_member_event.dart';
part 'team_member_state.dart';

class TeamMemberBloc extends Bloc<TeamMemberEvent, TeamMemberState> {
  List<User> data = [];
  List<User> usersListMain = [];
  GetTeamDetails getTeamDetails =
  GetTeamDetails(RepositoryImpl(WorkplaceDataSourcesImpl()));

  List<String> selectedFilter = [];

  TeamMemberBloc() : super(TeamMemberInitial()) {

    on<TeamMemberEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<FetchTeamList>((event, emit) async {
      // TODO: implement event handler
      emit(TeamMemberLoadingState());
      Either<Failure, TeamDetailsModel> response = await getTeamDetails.call('');
      response.fold((left) {
        if (left is UnauthorizedFailure) {
          appNavigator.tokenExpireUserLogout(event.mContext);
        } else if (left is NoDataFailure) {
          emit(TeamMemberErrorState(errorMessage: jsonDecode(left.errorMessage)['error']));
        } else if (left is ServerFailure) {
          emit(const TeamMemberErrorState(errorMessage: 'Server Failure'));
        } else if (left is InvalidDataUnableToProcessFailure) {
          emit(TeamMemberErrorState(errorMessage: jsonDecode(left.errorMessage)['error']));
        } else {
          emit(const TeamMemberErrorState(errorMessage: 'Something went wrong'));
        }
      }, (right) {
        data = right.data ?? [];
        usersListMain = right.data ?? [];
        /// Filter data
        data = filterUsers();
        BlocProvider.of<MainAppBloc>(event.mContext).mainAppDataProvider!.setTeamMemberList(right.data);
        emit(TeamMemberDataFetched());
      });
    });

    on<OnSearchMemberEvent>((event, emit) async {
      // TODO: implement event handler
      emit(TeamMemberLoadingState());
      data = filterUsers(searchText: event.searchKey??"");
      emit(TeamMemberDataFetched());
    });

    on<OnFilterUpdateEvent>((event, emit) async {
      emit(TeamMemberLoadingState());
      if(event.isInit==true){
        String result = "";
        result = await PrefUtils().readStr(WorkplaceNotificationConst.filterValue);
        if(result.isNotEmpty){
          selectedFilter = result.split(',');
        }
      }
      else {
          selectedFilter = event.selectedFilter??[];
          String result = "";
          if (selectedFilter.isNotEmpty) {
            result = selectedFilter.join(",");
          }
          await PrefUtils().saveStr(
              WorkplaceNotificationConst.filterValue, result);
         data = filterUsers(searchText: event.searchKey!);
      }

      emit(TeamMemberDataFetched());
    });

    on<ResetTeamBlocEvent>((event, emit) async {
      await PrefUtils().saveStr(WorkplaceNotificationConst.filterValue, "");
      selectedFilter.clear();
      emit(TeamMemberInitial());
    });

    on<StoreTeamViewIsListOrGridEvent>((event, emit){
      emit(TeamMemberLoadingState());
      PrefUtils().saveBool(WorkplaceNotificationConst.teamViewIsGrid,event.isGrid);

      PrefUtils().readBool(WorkplaceNotificationConst.teamViewIsGrid).then((value) {
        print(value);
      });
      emit(StoreTeamViewIsListOrGridState(isGrid: event.isGrid));
    });

    /// Add function to get selected filter first time Note It must end of the all other function
    add(const OnFilterUpdateEvent(isInit: true));
  }


  List<User> filterUsers({String searchText = ""}){
    List<User> filteredList = [];
    filteredList.addAll(usersListMain);
    if (searchText.isNotEmpty || selectedFilter.isNotEmpty) {

      filteredList = usersListMain.where((element) {
        final nameMatch = element.name?.toLowerCase().contains(searchText.toLowerCase()) ?? false;
        final descriptionMatch = element.shortDescription
            ?.toLowerCase()
            .contains(searchText.toLowerCase()) ??
            false;

        /// Add filter in search
        if(selectedFilter.isNotEmpty && selectedFilter[0].isNotEmpty){
          final fetchedBlockList = element.houses!.where((elementNew) {
            return elementNew.block!.toLowerCase()==selectedFilter[0].toLowerCase();
          });
          if(searchText.isNotEmpty){
            return ((nameMatch || descriptionMatch) && fetchedBlockList.isNotEmpty);
          }
          return fetchedBlockList.isNotEmpty;
        }

        return nameMatch || descriptionMatch;
      }).toList();

      /// Arrange list according to Bloc house number
      // if(selectedFilter.isNotEmpty && filteredList.isNotEmpty){
      //   filteredList.sort((a, b) {
      //     int houseNumberA = int.parse(a.houses![0].houseNumber!);
      //     int houseNumberB = int.parse(b.houses![0].houseNumber!);
      //     return houseNumberA.compareTo(houseNumberB);
      //   });
      // }
    }


    return filteredList;
  }
}
