part of 'current_user_bloc.dart';

sealed class CurrentUserEvent extends Equatable {
  const CurrentUserEvent();

  @override
  List<Object?> get props => [];
}

class CurrentUserRequested extends CurrentUserEvent {
  const CurrentUserRequested();
}
