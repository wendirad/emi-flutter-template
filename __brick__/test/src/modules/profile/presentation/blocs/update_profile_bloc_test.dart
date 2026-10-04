// The package import carries the generated project name, which can sort
// differently from here.
// ignore_for_file: directives_ordering

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:{{project_name.snakeCase()}}/src/modules/profile/domain/failures/profile_failures.dart';
import 'package:{{project_name.snakeCase()}}/src/modules/profile/domain/use_cases/use_cases.dart';
import 'package:{{project_name.snakeCase()}}/src/modules/profile/presentation/blocs/update_profile/update_profile_bloc.dart';

class MockUpdateProfileUseCase extends Mock implements UpdateProfileUseCase {}

class FakeUpdateProfileParam extends Fake implements UpdateProfileParam {}

void main() {
  late MockUpdateProfileUseCase updateProfile;

  const request = UpdateProfileRequested(
    firstName: 'Jane',
    lastName: 'Doe',
    removeProfilePicture: true,
  );

  setUpAll(() => registerFallbackValue(FakeUpdateProfileParam()));
  setUp(() => updateProfile = MockUpdateProfileUseCase());

  test('starts idle', () {
    expect(
      UpdateProfileBloc(updateProfile: updateProfile).state,
      const UpdateProfileState.idle(),
    );
  });

  blocTest<UpdateProfileBloc, UpdateProfileState>(
    'emits inProgress then success and passes the fields on',
    setUp: () => when(
      () => updateProfile(param: any(named: 'param')),
    ).thenAnswer((_) async => const Right(unit)),
    build: () => UpdateProfileBloc(updateProfile: updateProfile),
    act: (bloc) => bloc.add(request),
    expect: () => [
      const UpdateProfileState.inProgress(),
      const UpdateProfileState.success(),
    ],
    verify: (_) {
      final param =
          verify(
                () => updateProfile(param: captureAny(named: 'param')),
              ).captured.single
              as UpdateProfileParam;
      expect(param.firstName, 'Jane');
      expect(param.removeProfilePicture, isTrue);
    },
  );

  blocTest<UpdateProfileBloc, UpdateProfileState>(
    'emits inProgress then the failure when the update fails',
    setUp: () => when(
      () => updateProfile(param: any(named: 'param')),
    ).thenAnswer((_) async => Left(ProfileUpdateFailure.fromCode('x'))),
    build: () => UpdateProfileBloc(updateProfile: updateProfile),
    act: (bloc) => bloc.add(request),
    expect: () => [
      const UpdateProfileState.inProgress(),
      UpdateProfileState.failure(ProfileUpdateFailure.fromCode('x')),
    ],
  );
}
