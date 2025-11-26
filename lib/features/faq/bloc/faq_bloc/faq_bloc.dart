import 'package:asetize/imports.dart';
import '../../../../core/util/app_navigator/app_navigator.dart';
import 'faq_event.dart';
import 'faq_state.dart';

class FaqBloc extends Bloc<FaqEvent, FaqState> {
  GetFaqList getFaqList =
      GetFaqList(RepositoryImpl(WorkplaceDataSourcesImpl()));

  List<FAQ> faqList = [];

  FaqBloc() : super(FaqInitState()) {
    on<GetFaqListEvent>((event, emit) async {
      emit(FaqLoadingState());
      Either<Failure, FaqModal> response = await getFaqList.call('');
      response.fold((left) {
        if (left is UnauthorizedFailure) {
          appNavigator.tokenExpireUserLogout(event.mContext!);
        }else if (left is NoDataFailure) {
          emit(FaqErrorState(errorMessage:left.errorMessage ));
        } else if (left is ServerFailure) {
          emit(FaqErrorState(errorMessage:'Server Failure'));
        } else if (left is InvalidDataUnableToProcessFailure) {
          emit(FaqErrorState(errorMessage:left.errorMessage));
        } else {
          emit(FaqErrorState(errorMessage:'Something went wrong'));
        }
      }, (right) {
        faqList = right.faqList ?? [];
        emit(FetchFaqDataState());
      });
    });
  }
}
