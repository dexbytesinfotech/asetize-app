import '../../../imports.dart';

part 'approval_pending_event.dart';
part 'approval_pending_state.dart';

class ApprovalPendingBloc extends Bloc<ApprovalPendingEvent,ApprovalPendingState>{
  bool isApprovalPending =  false;
  ApprovalPendingBloc() : super(ApprovalPendingInitialState()){

   on<OnApprovalStateChangeEvent>((event ,emit) async {
     emit(ApprovalPendingLoadingState());
     isApprovalPending = event.isApprovalPending!;
     emit(ApprovalStateChangedState(isApprovalPending:isApprovalPending));
   });
  }


}