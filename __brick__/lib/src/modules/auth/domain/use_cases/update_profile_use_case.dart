import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/use_cases/use_cases.dart';
import '../failures/auth_failures.dart';
import '../repositories/i_auth_repository.dart';

class UpdateProfileUseCase implements UseCase<Unit, UpdateProfileParam> {
  final IAuthRepository authRepository;

  UpdateProfileUseCase({required this.authRepository});

  @override
  Future<Either<ProfileUpdateFailure, Unit>> call({
    required UpdateProfileParam param,
  }) async {
    return authRepository.updateProfile(
      businessName: param.businessName,
      firstName: param.firstName,
      lastName: param.lastName,
      profilePicture: param.profilePicture,
      removeProfilePicture: param.removeProfilePicture,
    );
  }
}

class UpdateProfileParam extends Equatable {
  final String? businessName;
  final String? firstName;
  final String? lastName;
  final File? profilePicture;
  final bool removeProfilePicture;

  const UpdateProfileParam({
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
