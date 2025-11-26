import '../../../../core/network/api_base_helpers.dart';
import '../../../../imports.dart';
import '../../models/house_bloc_model.dart';
import 'house_bloc_state.dart';
import 'house_block_event.dart';

class HouseBlockBloc extends Bloc<HouseBlockEvent, HouseBlockState> {

  HouseBlockBloc() : super(HouseBlockInitialState()) {


    on<ResetHouseBlockEvent>((event, emit) {
      MainAppBloc.houseBlockList.clear();
      emit(HouseBlockInitialState());
    });
    on<FetchHouseBlockEvent>((event, emit) async {
      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().get(Uri.parse(ApiConst.houseBlock), ApiBaseHelpers.headers());
        response.fold((left) {
          emit(HouseBlockLoadingState());

          if (left is UnauthorizedFailure) {
            emit(HouseBlockErrorState(errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(HouseBlockErrorState(errorMessage: left.errorMessage));
          } else if (left is ServerFailure) {
            emit(HouseBlockErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(HouseBlockErrorState(errorMessage: left.errorMessage));
          } else {
            emit(HouseBlockErrorState(errorMessage: 'Something went wrong'));
          }
        }, (right) {
          MainAppBloc.houseBlockList = HouseBlocModel.fromJson(right).data ?? [];
          emit(FetchedHouseBlockDoneState());
        });
      } catch (e) {
        emit(HouseBlockErrorState(errorMessage: '$e'));
      }
    });


  }
}