import '../../../core/util/app_navigator/app_navigator.dart';
import '../../../imports.dart';
import '../../domain/usecases/post_guest_customer_login.dart';
import '../../otp/pages/otp_new_screen.dart';
import '../../otp/pages/otp_verification_screen.dart';
import '../models/post_sign_up_model.dart';
part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState>{

  PostGuestCustomerLogin guestCustomerLogin =
  PostGuestCustomerLogin(RepositoryImpl(WorkplaceDataSourcesImpl()));
  SignUpBloc() : super(SignUpInitialState()){
   on<SignUpUserEvent>((event ,emit) async {
    emit(SignUpLoadingState());
    Either<Failure, SignUpModel> response = await guestCustomerLogin.call( GuestCustomerLoginParams(email: event.email, name: event.name));
    response.fold((left) {
      if (left is UnauthorizedFailure) {
        appNavigator.tokenExpireUserLogout(event.context);
      } else {}
      emit(SignUpErrorState());
    }, (right)  async {

      // store the token we get when guest customer login
      if (right.data != null) {
        try {
          String? apiToken = right.data!.token;
          await PrefUtils().saveStr(WorkplaceNotificationConst.accessTokenC, apiToken);
        //  emit(SignUpDoneState());
          Navigator.push(event.context, SlideLeftRoute(widget: OtpVerificationScreen(email: event.email )));
        } catch (e) {
          print(e);
        }
      }
      //emit(SignUpDoneState());
    });

   });

  }
}