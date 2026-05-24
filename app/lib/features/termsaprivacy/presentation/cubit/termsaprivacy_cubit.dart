import 'package:bloc/bloc.dart';
import 'package:todoon/core/utils/failure.dart';
import 'package:todoon/common/app_state/app_state.dart';
import 'package:todoon/features/termsaprivacy/domain/usecases/get_termsaprivacy_usecase.dart';

part 'termsaprivacy_state.dart';

class TermsAndPrivacyCubit extends Cubit<TermsAndPrivacyState> {
  final GetTermsAndPrivacyUseCase _getTermsAndPrivacyUseCase;

  TermsAndPrivacyCubit({
    required GetTermsAndPrivacyUseCase getTermsAndPrivacyUseCase,
  }) : _getTermsAndPrivacyUseCase = getTermsAndPrivacyUseCase,
       super(TermsAndPrivacyState.loading());

  Future<void> loadData() async {
    emit(TermsAndPrivacyState.loading(isFullScreen: true));

    final results = await _getTermsAndPrivacyUseCase.execute(null);
    emit(
      results.fold(
        (f) => TermsAndPrivacyState.error(failure: f),
        (termsAndPrivacy) => TermsAndPrivacyState.content(
          termsContent: termsAndPrivacy.terms,
          privacyContent: termsAndPrivacy.privacy,
        ),
      ),
    );
  }
}
