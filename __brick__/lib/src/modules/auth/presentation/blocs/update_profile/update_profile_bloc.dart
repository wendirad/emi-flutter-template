import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/presentation/blocs/process_state.dart';
import '../../../domain/failures/auth_failures.dart';
import '../../../domain/use_cases/use_cases.dart';

part 'update_profile_event.dart';

typedef UpdateProfileState = ProcessState<ProfileUpdateFailure>;

class UpdateProfileBloc extends Bloc<UpdateProfileEvent, UpdateProfileState> {
  final UpdateProfileUseCase _updateProfile;

  UpdateProfileBloc({required UpdateProfileUseCase updateProfile})
    : _updateProfile = updateProfile,
      super(const UpdateProfileState.idle()) {
    on<UpdateProfileRequested>(_onUpdateProfileRequested);
  }

  Future<void> _onUpdateProfileRequested(
    UpdateProfileRequested event,
    Emitter<UpdateProfileState> emit,
  ) async {
    emit(const UpdateProfileState.inProgress());

    final result = await _updateProfile(
      param: UpdateProfileParam(
        businessName: event.businessName,
        firstName: event.firstName,
        lastName: event.lastName,
        profilePicture: event.profilePicture,
        removeProfilePicture: event.removeProfilePicture,
      ),
    );

    emit(
      result.fold(
        (failure) => UpdateProfileState.failure(failure),
        (_) => const UpdateProfileState.success(),
      ),
    );
  }
}
