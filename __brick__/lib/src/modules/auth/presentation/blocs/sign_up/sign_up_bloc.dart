import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/presentation/blocs/process_state.dart';
import '../../../domain/failures/auth_failures.dart';
import '../../../domain/use_cases/use_cases.dart';

part 'sign_up_event.dart';

typedef SignUpState = ProcessState<SignUpWithEmailAndPasswordFailure>;

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final SignUpWithEmailAndPasswordUseCase _signUp;

  SignUpBloc({required SignUpWithEmailAndPasswordUseCase signUp})
    : _signUp = signUp,
      super(const SignUpState.idle()) {
    on<SignUpRequested>(_onSignUpRequested);
  }

  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<SignUpState> emit,
  ) async {
    emit(const SignUpState.inProgress());

    final result = await _signUp(
      param: SignUpParam(
        email: event.email,
        password: event.password,
        businessName: event.businessName,
      ),
    );

    emit(
      result.fold(
        (failure) => SignUpState.failure(failure),
        (_) => const SignUpState.success(),
      ),
    );
  }
}
