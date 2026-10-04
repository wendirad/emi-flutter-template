// The package import carries the generated project name, which can sort
// differently from here.
// ignore_for_file: directives_ordering

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:{{project_name.snakeCase()}}/src/modules/auth/domain/failures/auth_failures.dart';
import 'package:{{project_name.snakeCase()}}/src/modules/auth/domain/use_cases/use_cases.dart';
import 'package:{{project_name.snakeCase()}}/src/modules/auth/presentation/blocs/sign_in/sign_in_bloc.dart';

class MockSignInUseCase extends Mock
    implements SignInWithEmailAndPasswordUseCase {}

class FakeSignInParam extends Fake implements SignInParam {}

void main() {
  late MockSignInUseCase signIn;

  const request = SignInRequested(
    email: 'jane@example.com',
    password: 'Valid#Pass1',
    saveInfo: false,
  );

  setUpAll(() => registerFallbackValue(FakeSignInParam()));
  setUp(() => signIn = MockSignInUseCase());

  test('starts idle', () {
    expect(SignInBloc(signIn: signIn).state, const SignInState.idle());
  });

  blocTest<SignInBloc, SignInState>(
    'emits inProgress then success when sign-in succeeds',
    setUp: () => when(
      () => signIn(param: any(named: 'param')),
    ).thenAnswer((_) async => const Right(unit)),
    build: () => SignInBloc(signIn: signIn),
    act: (bloc) => bloc.add(request),
    expect: () => [const SignInState.inProgress(), const SignInState.success()],
    verify: (_) {
      final param =
          verify(
                () => signIn(param: captureAny(named: 'param')),
              ).captured.single
              as SignInParam;
      expect(param.email, 'jane@example.com');
      expect(param.saveInfo, isFalse);
    },
  );

  blocTest<SignInBloc, SignInState>(
    'emits inProgress then the failure when sign-in fails',
    setUp: () => when(() => signIn(param: any(named: 'param'))).thenAnswer(
      (_) async => Left(SignInWithEmailAndPasswordFailure.fromCode('x')),
    ),
    build: () => SignInBloc(signIn: signIn),
    act: (bloc) => bloc.add(request),
    expect: () => [
      const SignInState.inProgress(),
      SignInState.failure(SignInWithEmailAndPasswordFailure.fromCode('x')),
    ],
  );
}
