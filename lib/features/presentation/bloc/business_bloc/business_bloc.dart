import '../../../../core/util/app_navigator/app_navigator.dart';
import '../../../../imports.dart';
import '../../../data/models/business_detail_module.dart';
import '../../../domain/usecases/get_business_details.dart';
part 'business_event.dart';
part 'business_state.dart';

class BusinessBloc extends Bloc<BusinessEvent, BusinessState> {
  List<User> data = [];
  GetBusinessDetails getBusinessDetails =
  GetBusinessDetails(RepositoryImpl(WorkplaceDataSourcesImpl()));

  BusinessBloc() : super(BusinessInitial()) {
    on<BusinessEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<FetchBusinessList>((event, emit) async {
      // TODO: implement event handler
      emit(BusinessLoadingState());
      Either<Failure, BusinessDetailsModel> response =
      await getBusinessDetails.call('');
      response.fold((left) {
        if (left is UnauthorizedFailure) {
          appNavigator.tokenExpireUserLogout(event.mContext);
        }
        //emit(BusinessDataFetched());
      }, (right) {
        data = right.data ?? [];
        BlocProvider.of<MainAppBloc>(event.mContext)
            .mainAppDataProvider!
            .setBusinessList(right.data);
        emit(BusinessDataFetched());
      });
      // await fetchTeamData(event.mContext);
    });

    on<ResetBusinessBlocEvent>((event, emit) {
      emit(BusinessInitial());
    });

    on<StoreBusinessViewIsListOrGridEvent>((event, emit){
      emit(BusinessLoadingState());
      PrefUtils().saveBool(WorkplaceNotificationConst.businessViewIsGrid,event.isGrid);

      PrefUtils().readBool(WorkplaceNotificationConst.businessViewIsGrid).then((value) {
        print(value);
      });
      emit(StoreBusinessViewIsListOrGridState(isGrid: event.isGrid));
    });

  }

// Future<void> fetchTeamData(BuildContext mContext) {
//   return getTeamDetails.call('').fold((left) {
//     if (left is UnauthorizedFailure) {
//       appNavigator.tokenExpireUserLogout(mContext);
//     }
//     //emit(TeamMemberDataFetched());
//   }, (right) {
//     data = right.data ?? [];
//     emit(TeamMemberDataFetched());
//   });
// }
}
