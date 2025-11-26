import '../../../core/network/api_base_helpers.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../imports.dart';
import '../models/my_vehicle_model.dart';
import 'my_vehicle_event.dart';
import 'my_vehicle_state.dart';

class MyVehicleListBloc extends Bloc<MyVehicleListEvent, MyVehicleListState> {
  List<VehicleData> myVehicleListData = [];

  MyVehicleListBloc() : super(MyVehicleInitialState()) {
    on<MyVehicleEvent>(_myVehicleList);
    on<DeleteMyVehicleEvent>(_deleteMyVehicle);
    on<ResetMyVehicleBlocEvent>((event, emit) {
      myVehicleListData.clear();
      emit(MyVehicleInitialState());
    });
  }

  Future<void> _myVehicleList(
      MyVehicleEvent event, Emitter<MyVehicleListState> emit) async {
    emit(MyVehicleLoadingState());
    try {
      Either<Failure, dynamic> response = await ApiBaseHelpers().get(
        Uri.parse(ApiConst.myVehicleList),
        ApiBaseHelpers.headers(),
      );
      response.fold(
            (left) {
          if (left is UnauthorizedFailure) {
            emit(MyVehicleErrorState('Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(MyVehicleErrorState(left.errorMessage));
          } else if (left is ServerFailure) {
            emit(MyVehicleErrorState('Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(MyVehicleErrorState(jsonDecode(left.errorMessage)['error']));
          } else {
            emit(MyVehicleErrorState('Something went wrong'));
          }
        },
            (right) {
          try {
            myVehicleListData = MyVehicleModel.fromJson(right).data ?? [];
            if (myVehicleListData.isEmpty) {
              emit(MyVehicleEmptyState());
            } else {
              emit(MyVehicleLoadedState());
            }
          } catch (e) {
            emit(MyVehicleErrorState('Failed to parse server response.'));
          }
        },
      );
    } catch (e) {
      emit(MyVehicleErrorState('Unexpected error occurred while fetching data.'));
    }
  }

  Future<void> _deleteMyVehicle(
      DeleteMyVehicleEvent event, Emitter<MyVehicleListState> emit) async {
    emit(DeleteMyVehicleLoadingState());
    try {
      Either<Failure, dynamic> response = await ApiBaseHelpers().delete(
        Uri.parse(ApiConst.deleteMyVehicle + event.id.toString()),
        ApiBaseHelpers.headers(),
        null,
      );
      response.fold(
            (left) {
              if (left is UnauthorizedFailure) {
                emit(MyVehicleErrorState(left.errorMessage ?? ""));
              } else if (left is NoDataFailure) {
                emit(MyVehicleErrorState(left.errorMessage));
              } else if (left is ServerFailure) {
                emit(MyVehicleErrorState('Server Failure'));
              } else if (left is InvalidDataUnableToProcessFailure) {
                emit(MyVehicleErrorState(jsonDecode(left.errorMessage)['error']));
              } else {
                emit(MyVehicleErrorState('Something went wrong'));
              }
        },
            (right) {
            emit(DeleteMyVehicleLoadedState());

        },
      );
    } catch (e) {
      emit(DeleteMyVehicleErrorState('Unexpected error occurred while fetching data.'));
    }
  }
}
