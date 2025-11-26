import 'package:asetize/features/find_car_owner/bloc/find_car_onwer_event.dart';
import 'package:asetize/features/find_car_owner/bloc/find_car_onwer_state.dart';
import 'package:asetize/features/find_car_owner/models/vehicle_model.dart';
import '../../../core/network/api_base_helpers.dart';
import '../../../imports.dart';


class FindCarOnwerBloc extends Bloc<VehicleInfomationEvent, VehicleInfomationState> {


  List<FindMyVehicle> findMyVehicleList = [];

  FindCarOnwerBloc() : super(VehicleInfomationInitialState()) {
    on<SearchVehicleEvent>(_findCarOnwer);
  }

  Future<void> _findCarOnwer(
      SearchVehicleEvent event, Emitter<VehicleInfomationState> emit) async {
    emit(VehicleInfomationLoadingState());
    LoadingWidget2.startLoadingWidget(event.mContext!);

    try {
      Either<Failure, dynamic> response = await ApiBaseHelpers().get(
          Uri.parse(ApiConst.findVehicle + event.registrationNumber),
          ApiBaseHelpers.headers());

      response.fold((left) {
        LoadingWidget2.endLoadingWidget(event.mContext!);
        if (left is UnauthorizedFailure) {
          emit(VehicleInfomationErrorState('Unauthorized Failure'));
        } else if (left is NoDataFailure) {
          emit(VehicleInfomationErrorState(left.errorMessage));
        } else if (left is ServerFailure) {
          emit(VehicleInfomationErrorState('Server Failure'));
        } else if (left is InvalidDataUnableToProcessFailure) {
          emit(VehicleInfomationErrorState(left.errorMessage));
        } else {
          emit(VehicleInfomationErrorState('Something went wrong'));
        }
      }, (right) {
        try {
          // Extract the message
          var message = right['message'] ?? "No message received";

          // Check if data is empty and handle the message
          if (right['data'] == null || right['data'].isEmpty) {
            emit(VehicleInfomationErrorState(message));  // Emit message to UI
          } else {
            findMyVehicleList = VehicleModel.fromJson(right).data ?? [];
            emit(VehicleInfomationLoadedState());
          }

          LoadingWidget2.endLoadingWidget(event.mContext!);
        } catch (e) {
          emit(VehicleInfomationErrorState('Error parsing response'));
          LoadingWidget2.endLoadingWidget(event.mContext!);
        }
      });
    } catch (e) {
      emit(VehicleInfomationErrorState("Error fetching announcements"));
      LoadingWidget2.endLoadingWidget(event.mContext!);
    }
  }


}