import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/presentation/blocs/load_state.dart';
import '../../../../../core/use_cases/use_cases.dart';
import '../../../domain/failures/auth_failures.dart';
import '../../../domain/use_cases/use_cases.dart';

part 'remembered_email_event.dart';

/// `data` is the saved email, or null when nothing is saved.
typedef RememberedEmailState = LoadState<String?, AuthSessionFailure>;

class RememberedEmailBloc
    extends Bloc<RememberedEmailEvent, RememberedEmailState> {
  final GetRememberedEmailUseCase _getRememberedEmail;

  RememberedEmailBloc({required GetRememberedEmailUseCase getRememberedEmail})
    : _getRememberedEmail = getRememberedEmail,
      super(const RememberedEmailState.idle()) {
    on<RememberedEmailRequested>(_onRememberedEmailRequested);
  }

  Future<void> _onRememberedEmailRequested(
    RememberedEmailRequested event,
    Emitter<RememberedEmailState> emit,
  ) async {
    emit(const RememberedEmailState.inProgress());

    final result = await _getRememberedEmail(param: const NoParam());

    emit(
      result.fold(
        (failure) => RememberedEmailState.failure(failure),
        (email) => RememberedEmailState.success(email),
      ),
    );
  }
}
