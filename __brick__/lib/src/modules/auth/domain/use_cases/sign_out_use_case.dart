import 'package:dartz/dartz.dart';
import '../../../../core/app.dart';
import '../failures/auth_failures.dart';

class SignOutUseCase implements UseCase<Unit, NoParam> {
  final IAuthRepository authRepository;

  const SignOutUseCase({required this.authRepository});

  @override
  Future<Either<SignOutFailure, Unit>> call({required NoParam param}) async {
    return await authRepository.signOut();
  }
}
