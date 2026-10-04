import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../app.dart';

abstract class UseCase<T, P> {
  Future<Either<Failure, T>> call({required P param});
}

class NoParam extends Equatable {
  const NoParam();

  @override
  List<Object?> get props => [];
}
