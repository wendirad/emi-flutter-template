import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/presentation/blocs/process_state.dart';
import '../../../domain/failures/auth_failures.dart';
import '../../../domain/use_cases/use_cases.dart';

part 'sign_in_event.dart';

typedef SignInState = ProcessState<SignInWithEmailAndPasswordFailure>;

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final SignInWithEmailAndPasswordUseCase _signIn;

  SignInBloc({required SignInWithEmailAndPasswordUseCase signIn})
    : _signIn = signIn,
      super(const SignInState.idle()) {
    on<SignInRequested>(_onSignInRequested);
  }

  Future<void> _onSignInRequested(
    SignInRequested event,
    Emitter<SignInState> emit,
  ) async {
    emit(const SignInState.inProgress());

    final result = await _signIn(
      param: SignInParam(
        email: event.email,
        password: event.password,
        saveInfo: event.saveInfo,
      ),
    );

    emit(
      result.fold(
        (failure) => SignInState.failure(failure),
        (_) => const SignInState.success(),
      ),
    );
  }
}
