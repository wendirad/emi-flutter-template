import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/failures/auth_failures.dart';
import '../../../domain/use_cases/update_profile_use_case.dart';

part 'update_profile_event.dart';
part 'update_profile_state.dart';

class UpdateProfileBloc extends Bloc<UpdateProfileEvent, UpdateProfileState> {
  final UpdateProfileUseCase updateProfile;

  UpdateProfileBloc(this.updateProfile) : super(UpdateProfileState.initial()) {
    on<ProfileUpdateRequested>(_onProfileUpdateRequested);
  }

  FutureOr<void> _onProfileUpdateRequested(
    ProfileUpdateRequested event,
    Emitter<UpdateProfileState> emit,
  ) async {
    emit(state.copyWith(process: ProfileUpdateStatus.inProgress, error: null));

    final status = await updateProfile(param: event.param);

    status.fold(
      (failure) => emit(
        state.copyWith(process: ProfileUpdateStatus.failed, error: failure),
      ),
      (_) => emit(
        state.copyWith(process: ProfileUpdateStatus.successful, error: null),
      ),
    );
  }
}
