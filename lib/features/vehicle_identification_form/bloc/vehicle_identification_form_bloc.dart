import 'dart:convert';

import 'package:asetize/core/network/api_base_helpers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../app_global_components/loading_widget/loading_2_widget.dart';
import '../../../core/core.dart';
import 'vehicle_identification_form_event.dart';
import 'vehicle_identification_form_state.dart';

class VehicleFormBloc extends Bloc<VehicleFormEvent, VehicleFormState> {
  VehicleFormBloc() : super(VehicleFormInitial()) {
    on<SubmitVehicleFormEvent>(_submitVehicleForm);
  }

  Future<void> _submitVehicleForm(SubmitVehicleFormEvent event, Emitter<VehicleFormState> emit) async {
    emit(VehicleFormLoading());
    // LoadingWidget2.startLoadingWidget(event.mContext!);

    Map<String, dynamic> queryParameters = {
      "registration_number": event.registrationNumber,
      "owner_name": event.ownerName,
      "vehicle_type": event.vehicleType,
      "user_id" : event.userId,
      "house_id" : event.houseId,
      "is_parking_allotted": event.isParkingAllotted,
      'block_id' : event.blockId
    };
    try {
      // Call API
      var response = await ApiBaseHelpers().post(
        Uri.parse(ApiConst.addVehicle),
        ApiBaseHelpers.headers(),
        body: queryParameters,
      );

      // Handle response
      response.fold(
            (left) {
          LoadingWidget2.endLoadingWidget(event.mContext!);
          if (left is UnauthorizedFailure) {
            emit(VehicleFormError(error: left.errorMessage  ?? ""));
          } else if (left is NoDataFailure) {
            emit(VehicleFormError(error: left.errorMessage));
          } else if (left is ServerFailure) {
            emit(VehicleFormError(error: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(VehicleFormError(error: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(VehicleFormError(error: 'Something went wrong'));
          }
        },
            (data) {
          try {
            if (data['error_code'] == 422 && data['errors']?['registration_number'] != null) {
              String errorMessage = data['errors']['registration_number'].first;
              emit(VehicleFormError(error: errorMessage));
            } else if (data['data'] != null) {
              // Emit success state
              emit(VehicleFormSuccess(message: '${data['message']}'));
              // LoadingWidget2.endLoadingWidget(event.mContext!);
            } else {
              // Handle unexpected response format
              emit(VehicleFormError(error: "${data['error']}"));
              // LoadingWidget2.endLoadingWidget(event.mContext!);
            }
          } catch (e) {
            emit(VehicleFormError(error: "Error $e"));
            // LoadingWidget2.endLoadingWidget(event.mContext!);
          }
        },
      );
    } catch (e) {
      print("Exception caught during API call: $e");
      emit(VehicleFormError(error: "Error fetching vehicle data"));
      // LoadingWidget2.endLoadingWidget(event.mContext!);
    }
  }
}