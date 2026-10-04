part of 'update_profile_bloc.dart';

// Sentinel so copyWith can tell "keep the error" from an explicit null.
const Object _unset = Object();

enum ProfileUpdateStatus { idle, inProgress, successful, failed }

class UpdateProfileState extends Equatable {
  final ProfileUpdateStatus process;
  final ProfileUpdateFailure? error;

  const UpdateProfileState({required this.process, this.error});

  static UpdateProfileState initial() =>
      UpdateProfileState(process: ProfileUpdateStatus.idle);

  UpdateProfileState copyWith({
    ProfileUpdateStatus? process,
    Object? error = _unset,
  }) => UpdateProfileState(
    process: process ?? this.process,
    error: identical(error, _unset)
        ? this.error
        : error as ProfileUpdateFailure?,
  );

  @override
  List<Object> get props => [process, ?error];
}
