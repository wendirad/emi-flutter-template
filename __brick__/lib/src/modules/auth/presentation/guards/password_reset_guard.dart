import 'dart:async';

import 'package:flutter_modular/flutter_modular.dart';
import '../../../../core/constants/constants.dart';
import '../../domain/use_cases/verify_password_reset_code_use_case.dart';

class PasswordResetGuard extends RouteGuard {
  final VerifyPasswordResetCodeUseCase verifyPasswordResetCode;

  PasswordResetGuard()
    : verifyPasswordResetCode = Modular.get<VerifyPasswordResetCodeUseCase>(),
      super(redirectTo: AppRoute.resetPassword.str);

  @override
  FutureOr<bool> canActivate(String path, ParallelRoute<dynamic> route) async {
    final Object? arguments = Modular.args.data;
    final Map<Object?, Object?> query = arguments is Map
        ? arguments
        : const {};

    if (query['mode'] != 'resetPassword') return false;

    final String oobCode = query['oobCode'] as String? ?? '';

    final codeVerification = await verifyPasswordResetCode(
      param: VerifyPasswordResetCodeParam(code: oobCode),
    );

    if (codeVerification.isLeft()) {
      final error = codeVerification.fold((l) => l, (_) => null);

      await Modular.to.pushNamed(AppRoute.resetPassword.str, arguments: error);

      return true;
    }

    Modular.setArguments(VerifyPasswordResetCodeParam(code: oobCode));

    return true;
  }
}
