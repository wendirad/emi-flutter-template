import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/presentation/blocs/load_state.dart';
import '../../../../../core/use_cases/use_cases.dart';
import '../../../domain/entities/auth_entities.dart';
import '../../../domain/failures/auth_failures.dart';
import '../../../domain/use_cases/use_cases.dart';

part 'current_user_event.dart';

typedef CurrentUserState = LoadState<AuthUser, AuthSessionFailure>;

class CurrentUserBloc extends Bloc<CurrentUserEvent, CurrentUserState> {
  final GetCurrentUserUseCase _getCurrentUser;

  CurrentUserBloc({required GetCurrentUserUseCase getCurrentUser})
    : _getCurrentUser = getCurrentUser,
      super(const CurrentUserState.idle()) {
    on<CurrentUserRequested>(_onCurrentUserRequested);
  }

  Future<void> _onCurrentUserRequested(
    CurrentUserRequested event,
    Emitter<CurrentUserState> emit,
  ) async {
    emit(const CurrentUserState.inProgress());

    final result = await _getCurrentUser(param: const NoParam());

    emit(
      result.fold(
        (failure) => CurrentUserState.failure(failure),
        (user) => CurrentUserState.success(user),
      ),
    );
  }
}
