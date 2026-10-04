part of 'update_profile_bloc.dart';

sealed class UpdateProfileEvent extends Equatable {
  const UpdateProfileEvent();

  @override
  List<Object?> get props => [];
}

class UpdateProfileRequested extends UpdateProfileEvent {
  final String? businessName;
  final String? firstName;
  final String? lastName;
  final File? profilePicture;
  final bool removeProfilePicture;

  const UpdateProfileRequested({
    this.businessName,
    this.firstName,
    this.lastName,
    this.profilePicture,
    this.removeProfilePicture = false,
  });

  @override
  List<Object?> get props => [
    businessName,
    firstName,
    lastName,
    profilePicture,
    removeProfilePicture,
  ];
}
