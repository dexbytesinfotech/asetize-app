import 'package:asetize/imports.dart';
import '../../../../core/util/app_navigator/app_navigator.dart';
import 'about_event.dart';
import 'about_state.dart';

class AboutBloc extends Bloc<AboutEvent, AboutState> {
  GetAboutUs aboutUsDetail =
      GetAboutUs(RepositoryImpl(WorkplaceDataSourcesImpl()));
  List<AboutData> aboutUsList = [];

  AboutBloc() : super(AboutInitialState()) {
    on<FetchAboutDataEvent>((event, emit) async {
      emit(AboutLoadingState());
      Either<Failure, AboutUsModal> response = await aboutUsDetail.call('');
      response.fold((left) {
        if (left is UnauthorizedFailure) {
          appNavigator.tokenExpireUserLogout(event.mContext);
        }else if (left is NoDataFailure) {
          emit(AboutErrorState(errorMessage:left.errorMessage ));
        } else if (left is ServerFailure) {
          emit(AboutErrorState(errorMessage:'Server Failure'));
        } else if (left is InvalidDataUnableToProcessFailure) {
          emit(AboutErrorState(errorMessage:jsonDecode(left.errorMessage)['error']));
        } else {
          emit(AboutErrorState(errorMessage:'Something went wrong'));
        }
      }, (right) {
        aboutUsList = right.aboutData ?? [];
        emit(FetchedAboutDataState());
      });
    });
  }
}
