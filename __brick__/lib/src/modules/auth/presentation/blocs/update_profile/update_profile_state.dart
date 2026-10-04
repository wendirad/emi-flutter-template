part of 'update_profile_bloc.dart';

enum ProfileUpdateStatus { idle, inProgress, successful, failed }

class UpdateProfileState extends Equatable {
  final ProfileUpdateStatus process;
  final ProfileUpdateFailure? error;

  const UpdateProfileState({required this.process, this.error});

  static UpdateProfileState initial() =>
      UpdateProfileState(process: ProfileUpdateStatus.idle);

  UpdateProfileState copyWith({
    ProfileUpdateStatus? process,
    ProfileUpdateFailure? error,
  }) => UpdateProfileState(
    process: process ?? this.process,
    error: error ?? this.error,
  );

  @override
  List<Object> get props => [process, ?error];
}
