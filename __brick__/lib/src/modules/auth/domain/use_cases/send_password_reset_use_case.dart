import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/app.dart';
import '../failures/auth_failures.dart';

class SendPasswordResetEmailUseCase
    implements UseCase<Unit, PasswordResetParam> {
  final IAuthRepository authRepository;

  SendPasswordResetEmailUseCase({required this.authRepository});

  @override
  Future<Either<PasswordResetFailure, Unit>> call({
    required PasswordResetParam param,
  }) async {
    return await authRepository.sendPasswordResetEmail(email: param.email);
  }
}

class PasswordResetParam extends Equatable {
  final String email;

  const PasswordResetParam({required this.email});

  @override
  List<Object?> get props => [email];
}
