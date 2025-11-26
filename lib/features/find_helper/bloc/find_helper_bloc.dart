import '../../../core/network/api_base_helpers.dart';
import '../../../imports.dart';
import '../models/find_helper_model.dart';
part 'find_helper_event.dart';
part 'find_helper_state.dart';

class FindHelperBloc extends Bloc<FindHelperEvent, FindHelperState> {
  List<FindHelperData> findHelperData = [];

  FindHelperBloc() : super(FindHelperInitialState()) {
    on<FetchFindHelperDataEvent>(_onFetchFindHelperDataEvent);
    on<ResetFindHelperEvent>((event, emit) {
      findHelperData.clear();
    });
  }

  Future<void> _onFetchFindHelperDataEvent(
      FetchFindHelperDataEvent event, Emitter<FindHelperState> emit) async {
    emit(FindHelperLoadingState());
    try {
      Either<Failure, dynamic> response = await ApiBaseHelpers().get(
        Uri.parse(ApiConst.handymanList,),
        ApiBaseHelpers.headers(),
      );
      response.fold(
            (left) {
          if (left is UnauthorizedFailure) {
            emit(FindHelperErrorState(errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(FindHelperErrorState(errorMessage: left.errorMessage));
          } else if (left is ServerFailure) {
            emit(FindHelperErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(FindHelperErrorState(errorMessage: left.errorMessage));
          } else {
            emit(FindHelperErrorState(errorMessage: 'Something went wrong'));
          }
        },
            (right) {
          try {
            findHelperData = FindHelperModel.fromJson(right).data ?? [];
            emit(FetchFindHelperDataDoneState());
          } catch (e) {
            emit(FindHelperErrorState(
                errorMessage: 'Failed to parse server response.'));
          }
        },
      );
    } catch (e) {
      emit(FindHelperErrorState(
          errorMessage: 'Unexpected error occurred while fetching data.'));
     // LoadingWidget2.endLoadingWidget(event.mContext!);
    }
  }
}
