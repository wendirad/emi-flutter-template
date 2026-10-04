import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../core/constants/constants.dart';
import 'data/repositories/auth_repository.dart';
import 'domain/repositories/i_auth_repository.dart';
import 'presentation/guards/guards.dart';
import 'domain/use_cases/use_cases.dart';
import 'presentation/views/views.dart';

class AuthModule extends Module {
  List<ModularRoute> get _routes => [
    ChildRoute(AppRoute.signUp.base, child: (_) => SignUpView()),
    ChildRoute(AppRoute.signIn.base, child: (_) => SignInView()),
    ChildRoute(AppRoute.resetPassword.base, child: (_) => PasswordResetView()),
    ChildRoute(
      AppRoute.confirmPasswordReset.base,
      child: (_) => ConfirmPasswordResetView(),
      guards: [PasswordResetGuard()],
    ),
  ];

  @override
  void exportedBinds(Injector i) {
    i.addLazySingleton<IAuthRepository>(
      () => AuthRepository(
        auth: Modular.get<FirebaseAuth>(),
        store: Modular.get<FirebaseFirestore>(),
        storage: Modular.get<FirebaseStorage>(),
      ),
    );

    i.addLazySingleton<SignUpWithEmailAndPasswordUseCase>(
      () => SignUpWithEmailAndPasswordUseCase(
        authRepository: Modular.get<IAuthRepository>(),
      ),
    );

    i.addLazySingleton<SignInWithEmailAndPasswordUseCase>(
      () => SignInWithEmailAndPasswordUseCase(
        authRepository: Modular.get<IAuthRepository>(),
      ),
    );

    i.addLazySingleton<SendPasswordResetEmailUseCase>(
      () => SendPasswordResetEmailUseCase(
        authRepository: Modular.get<IAuthRepository>(),
      ),
    );

    i.addLazySingleton<VerifyPasswordResetCodeUseCase>(
      () => VerifyPasswordResetCodeUseCase(
        authRepository: Modular.get<IAuthRepository>(),
      ),
    );

    i.addLazySingleton<ConfirmPasswordResetUseCase>(
      () => ConfirmPasswordResetUseCase(
        authRepository: Modular.get<IAuthRepository>(),
      ),
    );

    i.addLazySingleton<GetCurrentUserUseCase>(
      () => GetCurrentUserUseCase(
        authRepository: Modular.get<IAuthRepository>(),
      ),
    );

    i.addLazySingleton<ObserveAuthSessionUseCase>(
      () => ObserveAuthSessionUseCase(
        authRepository: Modular.get<IAuthRepository>(),
      ),
    );

    i.addLazySingleton<SignOutUseCase>(
      () => SignOutUseCase(authRepository: Modular.get<IAuthRepository>()),
    );

    i.addLazySingleton<UpdateProfileUseCase>(
      () =>
          UpdateProfileUseCase(authRepository: Modular.get<IAuthRepository>()),
    );

    super.exportedBinds(i);
  }

  @override
  void routes(RouteManager r) {
    for (ModularRoute route in _routes) {
      r.add(route);
    }
    super.routes(r);
  }
}
