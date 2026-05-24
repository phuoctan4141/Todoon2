part of 'termsaprivacy_cubit.dart';

class TermsAndPrivacyState extends AppState {
  final String? termsContent;
  final String? privacyContent;

  const TermsAndPrivacyState({
    this.termsContent,
    this.privacyContent,
    super.flow = FlowState.loading,
    super.isFullScreen = false,
    super.failure,
    super.message,
  });

  @override
  List<Object?> get props => [termsContent, privacyContent, ...super.props];

  @override
  TermsAndPrivacyState copyWith({
    String? termsContent,
    String? privacyContent,
    FlowState? flow,
    bool? isFullScreen,
    Failure? failure,
    String? message,
  }) {
    return TermsAndPrivacyState(
      termsContent: termsContent ?? this.termsContent,
      privacyContent: privacyContent ?? this.privacyContent,
      flow: flow ?? this.flow,
      isFullScreen: isFullScreen ?? this.isFullScreen,
      failure: failure ?? this.failure,
      message: message ?? this.message,
    );
  }

  // Factory methods for common states
  factory TermsAndPrivacyState.loading({bool isFullScreen = true}) {
    return TermsAndPrivacyState(flow: .loading, isFullScreen: isFullScreen);
  }

  factory TermsAndPrivacyState.content({
    required String termsContent,
    required String privacyContent,
  }) {
    return TermsAndPrivacyState(
      termsContent: termsContent,
      privacyContent: privacyContent,
      flow: .content,
    );
  }

  factory TermsAndPrivacyState.error({
    required Failure failure,
    bool isFullScreen = false,
  }) {
    return TermsAndPrivacyState(
      flow: .error,
      isFullScreen: isFullScreen,
      failure: failure,
      message: failure.message,
    );
  }
}
