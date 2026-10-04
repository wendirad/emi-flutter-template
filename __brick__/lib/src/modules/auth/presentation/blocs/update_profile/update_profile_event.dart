part of 'update_profile_bloc.dart';

sealed class UpdateProfileEvent extends Equatable {
  const UpdateProfileEvent();

  @override
  List<Object> get props => [];
}

class ProfileUpdateRequested extends UpdateProfileEvent {
  final UpdateProfileParam param;

  const ProfileUpdateRequested(this.param);
}
