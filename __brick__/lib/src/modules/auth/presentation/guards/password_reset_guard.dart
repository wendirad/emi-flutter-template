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
  FutureOr<bool> canActivate(String path, ParallelRoute route) async {
    final bool isPasswordResetConfirm =
        Modular.args.data?['mode'] == 'resetPassword';

    if (!isPasswordResetConfirm) return false;

    final String oobCode = Modular.args.data?['oobCode'] ?? '';

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
