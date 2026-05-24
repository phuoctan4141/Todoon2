import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:todoon/core/resources/assets_manager.dart';
import 'package:todoon/core/utils/error_handler.dart';
import 'package:todoon/core/utils/failure.dart';
import 'package:todoon/common/base/base_usecase.dart';

class TermsAndPrivacy {
  final String terms;
  final String privacy;

  TermsAndPrivacy({required this.terms, required this.privacy});
}

class GetTermsAndPrivacyUseCase extends UseCase<TermsAndPrivacy, void> {
  @override
  Future<Either<Failure, TermsAndPrivacy>> execute(void _) async {
    try {
      final results = await Future.wait([
        rootBundle.loadString(TermsAndPrivacyAssets.termsOfService),
        rootBundle.loadString(TermsAndPrivacyAssets.privacyPolicy),
      ]);
      return Right(TermsAndPrivacy(terms: results[0], privacy: results[1]));
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }
}
